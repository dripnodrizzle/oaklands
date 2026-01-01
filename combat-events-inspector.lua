-- Combat Events Inspector
-- Monitors and logs all combat-related events in ReplicatedStorage

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

print("=== Combat Events Inspector ===")
print("")

-- Get all Combat events
local combatEvents = {}
local eventsFolder = ReplicatedStorage:FindFirstChild("Events")

if eventsFolder then
    local combatFolder = eventsFolder:FindFirstChild("Combat")
    
    if combatFolder then
        print("[FOUND] Combat Events Folder:")
        print(combatFolder:GetFullName())
        print("")
        
        for _, event in pairs(combatFolder:GetChildren()) do
            if event:IsA("RemoteEvent") or event:IsA("RemoteFunction") then
                table.insert(combatEvents, event)
                print("  • " .. event.Name .. " (" .. event.ClassName .. ")")
            end
        end
    else
        warn("[WARNING] Combat folder not found in Events")
    end
    
    -- Also check for other useful event folders
    print("")
    print("[ALL EVENT FOLDERS]")
    for _, folder in pairs(eventsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            local count = 0
            for _, child in pairs(folder:GetChildren()) do
                if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                    count = count + 1
                end
            end
            print(string.format("  📁 %s (%d remotes)", folder.Name, count))
        end
    end
else
    warn("[ERROR] Events folder not found in ReplicatedStorage")
end

print("")
print("=== Available Combat Events ===")
for i, event in pairs(combatEvents) do
    print(string.format("[%d] %s", i, event.Name))
end

print("")
print("=== Event Descriptions (Based on Names) ===")
local descriptions = {
    ["TryArise"] = "Summon shadow from defeated enemy",
    ["Attack"] = "Player attack action",
    ["DamagePopup"] = "Show damage numbers",
    ["Dash"] = "Dash/dodge ability",
    ["EquipShadow"] = "Equip summoned shadow",
    ["Hitted"] = "Entity was hit",
    ["Sprint"] = "Sprint/run toggle",
    ["ToggleWeapon"] = "Switch weapon visibility",
}

for _, event in pairs(combatEvents) do
    local desc = descriptions[event.Name] or "Unknown function"
    print(string.format("  %s: %s", event.Name, desc))
end

-- Monitor all combat events
print("")
print("=== Monitoring Combat Events ===")
print("Watching for event calls...")
print("")

local eventCounts = {}

-- Hook into all combat events
for _, event in pairs(combatEvents) do
    eventCounts[event.Name] = 0
    
    if event:IsA("RemoteEvent") then
        -- Monitor OnClientEvent
        event.OnClientEvent:Connect(function(...)
            eventCounts[event.Name] = eventCounts[event.Name] + 1
            
            print(string.format("[%s] OnClientEvent #%d", event.Name, eventCounts[event.Name]))
            local args = {...}
            for i, arg in pairs(args) do
                print(string.format("  [%d] %s (%s)", i, tostring(arg), type(arg)))
            end
            print("")
        end)
    end
end

-- Monitor outgoing calls (FireServer)
local mt = getrawmetatable(game)
local old_namecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if (method == "FireServer" or method == "InvokeServer") then
        -- Check if this is a combat event
        for _, event in pairs(combatEvents) do
            if self == event then
                eventCounts[event.Name] = eventCounts[event.Name] + 1
                
                print(string.format("[%s] %s #%d", event.Name, method, eventCounts[event.Name]))
                for i, arg in pairs(args) do
                    local argStr = tostring(arg)
                    if type(arg) == "table" then
                        argStr = "table: " .. tostring(arg)
                    elseif type(arg) == "userdata" then
                        pcall(function()
                            argStr = arg.Name or tostring(arg)
                        end)
                    end
                    print(string.format("  [%d] %s (%s)", i, argStr, type(arg)))
                end
                print("")
                break
            end
        end
    end
    
    return old_namecall(self, ...)
end)

setreadonly(mt, true)

-- Global functions
_G.GetCombatEvents = function()
    return combatEvents
end

_G.GetEventCounts = function()
    print("=== Event Call Counts ===")
    for name, count in pairs(eventCounts) do
        print(string.format("  %s: %d calls", name, count))
    end
end

_G.TestTryArise = function(target)
    local tryArise = nil
    for _, event in pairs(combatEvents) do
        if event.Name == "TryArise" then
            tryArise = event
            break
        end
    end
    
    if not tryArise then
        warn("TryArise event not found!")
        return
    end
    
    if type(target) == "string" then
        target = workspace:FindFirstChild(target, true)
    end
    
    if not target then
        warn("Target not found!")
        return
    end
    
    print("[TEST] Calling TryArise on: " .. target.Name)
    tryArise:FireServer(target, true)
end

_G.ListAllEvents = function()
    if not eventsFolder then return end
    
    print("=== All ReplicatedStorage Events ===")
    for _, folder in pairs(eventsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            print("")
            print("📁 " .. folder.Name)
            for _, event in pairs(folder:GetChildren()) do
                if event:IsA("RemoteEvent") or event:IsA("RemoteFunction") then
                    print("  • " .. event.Name)
                end
            end
        end
    end
end

print("=== Commands ===")
print("  _G.GetCombatEvents() - Get array of combat events")
print("  _G.GetEventCounts() - Show event call statistics")
print("  _G.TestTryArise(target) - Test arising a shadow")
print("  _G.ListAllEvents() - List all events in ReplicatedStorage")
print("")
print("Monitoring active! Events will be logged as they occur.")
