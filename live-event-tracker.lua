-- Live Event Tracker (Compatible Version)
-- Monitors ReplicatedStorage.Events without console spam

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

print("=== Live Event Tracker ===")
print("Monitoring events without spam...")
print("")

-- Configuration
local Config = {
    MaxRecentEvents = 10,
    ShowTimestamps = true,
    UpdateInterval = 3,
    TrackClientEvents = true,
    TrackServerCalls = true,
    ShowSummary = true,
    FocusOnEvents = true,
}

-- Data tracking
local recentEvents = {}
local eventCounts = {}
local activeEvents = {}
local lastUpdate = tick()

-- Get all remotes (focus on ReplicatedStorage.Events)
local allRemotes = {}
local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
local priorityRemotes = {}

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

-- Get other remotes
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
    
    eventCounts[eventName] = (eventCounts[eventName] or 0) + 1
    
    activeEvents[eventName] = {
        count = (activeEvents[eventName] and activeEvents[eventName].count or 0) + 1,
        lastSeen = timestamp,
        direction = direction,
        isPriority = isPriority or false,
    }
    
    table.insert(recentEvents, 1, {
        name = eventName,
        direction = direction,
        time = timestamp,
        args = args,
        isPriority = isPriority or false,
    })
    
    while #recentEvents > Config.MaxRecentEvents do
        table.remove(recentEvents)
    end
end

-- Format time ago
local function timeAgo(timestamp)
    local diff = tick() - timestamp
    if diff < 1 then
        return "now"
    elseif diff < 60 then
        return string.format("%.0fs", diff)
    else
        return string.format("%.0fm", diff / 60)
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

-- Hook server calls (with compatibility check)
if Config.TrackServerCalls then
    local success = pcall(function()
        if not getrawmetatable or not getnamecallmethod then
            error("Functions not available")
        end
        
        local mt = getrawmetatable(game)
        local old_namecall = mt.__namecall
        
        -- Try to make writable
        local makeWritable = setreadonly or make_writeable or function() end
        local makeReadonly = setreadonly or make_readonly or function() end
        
        makeWritable(mt, false)
        
        local hookFunc = function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if (method == "FireServer" or method == "InvokeServer") and allRemotes[self] then
                local isPriority = priorityRemotes[self] or false
                trackEvent(allRemotes[self], "→SERVER", args, isPriority)
            end
            
            return old_namecall(self, ...)
        end
        
        -- Use newcclosure if available
        if newcclosure then
            mt.__namecall = newcclosure(hookFunc)
        else
            mt.__namecall = hookFunc
        end
        
        makeReadonly(mt, true)
        print("[Tracker] ✓ Server call tracking enabled")
    end)
    
    if not success then
        print("[Tracker] ⚠ Server call tracking not available (executor limitation)")
        print("[Tracker] ✓ Client event tracking still active")
    end
end

-- Display active events summary
local function displaySummary()
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
    
    if #priorityList > 0 then
        print("\n[🔥 ACTIVE - ReplicatedStorage.Events - " .. os.date("%H:%M:%S") .. "]")
        print(string.rep("─", 60))
        
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
        
        for eventName, data in pairs(activeEvents) do
            if tick() - data.lastSeen < 5 then
                data.count = 0
            end
        end
        
        lastUpdate = tick()
    end
end)

-- Commands
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

_G.WatchEvent = function(eventName)
    print("\n[Tracker] Watching for: " .. eventName)
    print("Run _G.StopWatch() to stop")
    print("")
    
    _G.WatchActive = true
    local foundCount = 0
    
    for remote, fullName in pairs(allRemotes) do
        if fullName:lower():find(eventName:lower()) then
            print("  Found: " .. fullName)
            foundCount = foundCount + 1
            
            if remote:IsA("RemoteEvent") then
                remote.OnClientEvent:Connect(function(...)
                    if _G.WatchActive then
                        print("\n[" .. os.date("%H:%M:%S") .. "] " .. fullName)
                        local args = {...}
                        for i, arg in ipairs(args) do
                            local argStr = tostring(arg)
                            if type(arg) == "userdata" then
                                pcall(function()
                                    argStr = arg.Name or tostring(arg)
                                end)
                            end
                            print(string.format("  [%d] %s (%s)", i, argStr, type(arg)))
                        end
                    end
                end)
            end
        end
    end
    
    if foundCount == 0 then
        print("  No matching events found!")
        print("  Try: _G.ShowAll() to see all available events")
    end
end

_G.StopWatch = function()
    _G.WatchActive = false
    print("[Tracker] Watch stopped")
end

print("=== Commands ===")
print("  _G.ShowRecent() - Show last " .. Config.MaxRecentEvents .. " events")
print("  _G.ShowStats() - Show ReplicatedStorage.Events statistics")
print("  _G.ShowAll() - Show all remote statistics")
print("  _G.ShowActive() - Show currently active events")
print("  _G.WatchEvent('name') - Watch specific event in detail")
print("  _G.ToggleSummary() - Toggle auto-summary on/off")
print("  _G.ClearStats() - Reset all statistics")
print("")
print("[Tracker] ✓ Focusing on ReplicatedStorage.Events")
print("[Tracker] ✓ Auto-summary every " .. Config.UpdateInterval .. "s")
