-- Live Event Tracker
-- Monitors events in real-time without console spam

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

print("=== Live Event Tracker ===")
print("Monitoring events without spam...")
print("")

-- Configuration
local Config = {
    MaxRecentEvents = 10,      -- How many recent events to keep
    ShowTimestamps = true,      -- Show when events occurred
    UpdateInterval = 3,         -- How often to refresh display (seconds)
    TrackClientEvents = true,   -- Track OnClientEvent
    TrackServerCalls = true,    -- Track FireServer/InvokeServer
    ShowSummary = true,         -- Show periodic summary
    FocusOnEvents = true,       -- Focus specifically on ReplicatedStorage.Events
}

-- Data tracking
local recentEvents = {}
local eventCounts = {}
local activeEvents = {}  -- Events that fired recently
local lastUpdate = tick()

-- Get all remotes (focus on ReplicatedStorage.Events)
local allRemotes = {}
local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
local priorityRemotes = {}  -- Events from ReplicatedStorage.Events

if eventsFolder then
    print("[Tracker] Found Events folder!")
    print("[Tracker] Scanning ReplicatedStorage.Events...")
    
    local eventCount = 0
    for _, descendant in pairs(eventsFolder:GetDescendants()) do
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            allRemotes[descendant] = descendant:GetFullName()
            priorityRemotes[descendant] = true
            eventCounts[descendant:GetFullName()] = 0
            eventCount = eventCount + 1
        end
    end
    print("[Tracker] Found " .. eventCount .. " events in Events folder")
end

-- Also get other remotes (if not focusing only on Events)
local otherCount = 0
for _, descendant in pairs(ReplicatedStorage:GetDescendants()) do
    if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
        if not allRemotes[descendant] then
            allRemotes[descendant] = descendant:GetFullName()
            eventCounts[descendant:GetFullName()] = 0
            otherCount = otherCount + 1
        end
    end
end

if otherCount > 0 then
    print("[Tracker] Found " .. otherCount .. " other remotes")
end

print("[Tracker] Monitoring started...")
print("")

-- Add event to recent list
local function trackEvent(eventName, direction, args, isPriority)
    local timestamp = tick()
    
    -- Count it
    eventCounts[eventName] = (eventCounts[eventName] or 0) + 1
    
    -- Mark as active
    activeEvents[eventName] = {
        count = (activeEvents[eventName] and activeEvents[eventName].count or 0) + 1,
        lastSeen = timestamp,
        direction = direction,
        isPriority = isPriority or false,
    }
    
    -- Add to recent (limited size)
    table.insert(recentEvents, 1, {
        name = eventName,
        direction = direction,
        time = timestamp,
        args = args,
        isPriority = isPriority or false,
    })
    
    -- Trim to max size
    while #recentEvents > Config.MaxRecentEvents do
        table.remove(recentEvents)
    end
end

-- Format time ago
local function timeAgo(timestamp)
    local diff = tick() - timestamp
    if diff < 1 then
        return "just now"
    elseif diff < 60 then
        return string.format("%.0fs ago", diff)
    else
        return string.format("%.0fm ago", diff / 60)
    end
end

-- Hook client events
if Config.TrackClientEvents then
    for remote, fullName in pairs(allRemotes) do
        if remote:IsA("RemoteEvent") then
            remote.OnClientEvent:Connect(function(...)
                local args = {...}
                local isPriority = priorityRemotes[remote] or false
                trackEvent(fullName, "←CLIENT", args, isPriority)
            end)
        end
    end
end

-- Hook server calls
if Config.TrackServerCalls then
    local mt = getrawmetatable(game)
    local old_namecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if (method == "FireServer" or method == "InvokeServer") and allRemotes[self] then
            local isPriority = priorityRemotes[self] or false
            trackEvent(allRemotes[self], "→SERVER", args, isPriority)
        end
        
        return old_namecall(self, ...)
    end)
    
    setreadonly(mt, true)
end

-- Display active events summary
local function displaySummary()
    -- Clean up old active events (older than 5 seconds)
    local now = tick()
    local activeList = {}
    local priorityList = {}
    
    for eventName, data in pairs(activeEvents) do
        if now - data.lastSeen < 5 then
            local entry = {
                name = eventName,
                count = data.count,
                direction = data.direction,
                lastSeen = data.lastSeen,
                isPriority = data.isPriority
            }
            
            if data.isPriority then
                table.insert(priorityList, entry)
            else
                table.insert(activeList, entry)
            end
        else
            activeEvents[eventName] = nil
        end
    end
    
    -- Show priority events first (from ReplicatedStorage.Events)
    if #priorityList > 0 then
        print("\n[🔥 ACTIVE - ReplicatedStorage.Events - " .. os.date("%H:%M:%S") .. "]")
        print(string.rep("─", 60))
        
        -- Sort by most recent
        table.sort(priorityList, function(a, b) return a.lastSeen > b.lastSeen end)
        
        for i, event in ipairs(priorityList) do
            local shortName = event.name:gsub("ReplicatedStorage%.Events%.", "")
            print(string.format("  %s %s x%d (%s)", 
                event.direction, 
                shortName, 
                event.count,
                timeAgo(event.lastSeen)
            ))
        end
    end
    
    -- Show other events if any
    if #activeList > 0 and not Config.FocusOnEvents then
        print("\n[Other Active Events]")
        
        table.sort(activeList, function(a, b) return a.lastSeen > b.lastSeen end)
        
        for i, event in ipairs(activeList) do
            if i <= 3 then
                local shortName = event.name:match("([^.]+)$") or event.name
                print(string.format("  %s %s x%d", event.direction, shortName, event.count))
            end
        end
        
        if #activeList > 3 then
            print(string.format("  ... and %d more (use _G.ShowAll)", #activeList - 3))
        end
    end
end

-- Auto-update loop
RunService.Heartbeat:Connect(function()
    if Config.ShowSummary and tick() - lastUpdate >= Config.UpdateInterval then
        displaySummary()
        
        -- Reset counts for active events
        for eventName, data in pairs(activeEvents) do
            if tick() - data.lastSeen < 5 then
                data.count = 0  -- Reset for next interval
            end
        end
        
        lastUpdate = tick()
    end
end)

-- Manual commands
_G.ShowRecent = function()
    print("\n=== Recent Events ===")
    print(string.rep("─", 70))
    
    if #recentEvents == 0 then
        print("No events tracked yet")
        return
    end
    
    for i, event in ipairs(recentEvents) do
        local shortName = event.name:match("([^.]+)$") or event.name
        local timeStr = Config.ShowTimestamps and " [" .. timeAgo(event.time) .. "]" or ""
        
        print(string.format("%s %s%s", event.direction, shortName, timeStr))
        
        -- Show args if not too many
        if #event.args <= 3 then
            for j, arg in ipairs(event.args) do
                local argStr = tostring(arg)
                if type(arg) == "userdata" then
                    pcall(function()
                        argStr = arg.Name or argStr
                    end)
                end
                print(string.format("    [%d] %s", j, argStr))
            end
        else
            print(string.format("    (%d arguments)", #event.args))
        end
    end
end

_G.ShowStats = function()
    print("\n=== Event Statistics (ReplicatedStorage.Events) ===")
    print(string.rep("─", 70))
    
    -- Convert to array and sort
    local statsList = {}
    local otherStats = {}
    
    for eventName, count in pairs(eventCounts) do
        if count > 0 then
            local stat = {name = eventName, count = count}
            if eventName:find("ReplicatedStorage%.Events%.") then
                table.insert(statsList, stat)
            else
                table.insert(otherStats, stat)
            end
        end
    end
    
    table.sort(statsList, function(a, b) return a.count > b.count end)
    
    -- Show Events folder stats
    for i, stat in ipairs(statsList) do
        if i <= 20 then
            local shortName = stat.name:gsub("ReplicatedStorage%.Events%.", "")
            print(string.format("  [%d] %s (%d calls)", i, shortName, stat.count))
        end
    end
    
    if #statsList > 20 then
        print(string.format("  ... and %d more", #statsList - 20))
    end
    
    local total = 0
    for _, stat in ipairs(statsList) do
        total = total + stat.count
    end
    
    print(string.rep("─", 70))
    print("Total Events folder calls: " .. total)
    
    if #otherStats > 0 then
        print("\nOther remotes: " .. #otherStats .. " active (use _G.ShowAll())")
    end
end

_G.ShowAll = function()
    print("\n=== All Event Statistics ===")
    print(string.rep("─", 70))
    
    local statsList = {}
    for eventName, count in pairs(eventCounts) do
        if count > 0 then
            table.insert(statsList, {name = eventName, count = count})
        end
    end
    
    table.sort(statsList, function(a, b) return a.count > b.count end)
    
    for i, stat in ipairs(statsList) do
        local shortName = stat.name:match("([^.]+)$") or stat.name
        local fullPath = stat.name:gsub("ReplicatedStorage%.Events%.", "")
        print(string.format("  [%d] %s (%d)", i, fullPath, stat.count))
    end
    
    print(string.rep("─", 70))
    print("Total: " .. #statsList .. " unique events")
end

_G.ShowActive = function()
    displaySummary()
end

_G.ClearStats = function()
    eventCounts = {}
    recentEvents = {}
    activeEvents = {}
    for remote, fullName in pairs(allRemotes) do
        eventCounts[fullName] = 0
    end
    print("[Tracker] Stats cleared!")
end

_G.ToggleSummary = function()
    Config.ShowSummary = not Config.ShowSummary
    print("[Tracker] Auto-summary: " .. (Config.ShowSummary and "ON" or "OFF"))
end

_G.SetUpdateInterval = function(seconds)
    Config.UpdateInterval = seconds
    print("[Tracker] Update interval: " .. seconds .. "s")
end
ReplicatedStorage.Events statistics")
print("  _G.ShowAll() - Show all remote statistics")
print("  _G.ShowActive() - Show currently active events")
print("  _G.WatchEvent('name') - Watch specific event in detail")
print("  _G.ToggleSummary() - Toggle auto-summary on/off")
print("  _G.ClearStats() - Reset all statistics")
print("")
print("[Tracker] ✓ Focusing on ReplicatedStorage.Events")
print("[Tracker] ✓
    
    for remote, fullName in pairs(allRemotes) do
        if fullName:lower():find(eventName:lower()) then
            print("  Found: " .. fullName)
            
            -- Set up detailed monitoring
            if remote:IsA("RemoteEvent") then
                remote.OnClientEvent:Connect(function(...)
                    if _G.WatchActive then
                        print("\n[" .. os.date("%H:%M:%S") .. "] " .. fullName)
                        local args = {...}
                        for i, arg in ipairs(args) do
                            print(string.format("  [%d] %s (%s)", i, tostring(arg), type(arg)))
                        end
                    end
                end)
            end
        end
    end
end

_G.StopWatch = function()
    _G.WatchActive = false
    print("[Tracker] Watch stopped")
end

print("=== Commands ===")
print("  _G.ShowRecent() - Show last " .. Config.MaxRecentEvents .. " events")
print("  _G.ShowStats() - Show event call statistics")
print("  _G.ShowActive() - Show currently active events")
print("  _G.WatchEvent('name') - Watch specific event in detail")
print("  _G.ToggleSummary() - Toggle auto-summary on/off")
print("  _G.ClearStats() - Reset all statistics")
print("")
print("[Tracker] ✓ Ready! Auto-summary every " .. Config.UpdateInterval .. "s")
