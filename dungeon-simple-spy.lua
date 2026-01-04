-- Simple Dungeon Spy
print("Dungeon Spy Starting...")

local events = {}

-- Find Events folder
local RS = game.ReplicatedStorage
local eventsFolder = RS.Events

if not eventsFolder then
    print("Events folder not found!")
    return
end

print("Found Events folder")

-- Find Dungeon events
local dungeonFolder = eventsFolder.Dungeon
if not dungeonFolder then
    print("No Dungeon folder found")
    return
end

print("Monitoring Dungeon events...")

-- Check if hookfunction exists
if hookfunction then
    print("Using hookfunction method")
    
    local oldNamecall
    oldNamecall = hookfunction(game.GetChildren, function(...)
        return oldNamecall(...)
    end)
    
    -- Try to find and log Start event specifically
    local startEvent = dungeonFolder.Start
    if startEvent then
        print("Found Start event - monitoring manually")
        print("Call EngineService to start dungeons")
    end
else
    print("No hookfunction - using direct hook")
end

-- Get children function without colon
local getChildren = dungeonFolder.GetChildren
local children = getChildren(dungeonFolder)

-- Hook each remote in Dungeon folder
for i, remote in pairs(children) do
    if remote.ClassName == "RemoteEvent" then
        local remoteName = remote.Name
        
        -- Try to hook using pcall for safety
        local success = pcall(function()
            local oldFire = remote.FireServer
            
            remote.FireServer = function(self, ...)
                local args = {...}
                local logEntry = {
                    name = remoteName,
                    args = args,
                    time = tick()
                }
                table.insert(events, logEntry)
                
                print("[DUNGEON EVENT] " .. remoteName)
                for j, arg in pairs(args) do
                    print("  Arg " .. tostring(j) .. " = " .. tostring(arg))
                end
                
                return oldFire(self, ...)
            end
        end)
        
        if success then
            print("Hooked: " .. remoteName)
        else
            print("Failed to hook: " .. remoteName)
        end
    end
end

-- Show events function
_G.ShowEvents = function()
    print("=== CAPTURED EVENTS ===")
    print("Total: " .. tostring(#events))
    for i, event in pairs(events) do
        print("[" .. tostring(i) .. "] " .. event.name)
        for j, arg in pairs(event.args) do
            print("  " .. tostring(j) .. " = " .. tostring(arg))
        end
    end
    print("======================")
end

print("Dungeon Spy Active!")
print("Use: _G.ShowEvents()")
