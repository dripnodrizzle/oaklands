-- Engine Service Spy
print("Engine Service Spy Starting...")

local RS = game.ReplicatedStorage
local Engine = RS.Engine

if not Engine then
    print("Engine not found!")
    return
end

print("Found Engine")

local EngineService = require(Engine.EngineService)

if not EngineService then
    print("EngineService not found!")
    return
end

print("Found EngineService")

-- Store original FireServer
local oldFireServer = EngineService.FireServer
local events = {}

-- Filter out spam events
local ignoreList = {
    "SyncClock",
    "Ping",
    "Heartbeat",
    "UpdatePosition",
    "Movement"
}

local function shouldIgnore(name)
    for _, ignored in pairs(ignoreList) do
        if name == ignored then
            return true
        end
    end
    return false
end

-- Hook FireServer
EngineService.FireServer = function(remote, ...)
    local args = {...}
    local remoteName = "Unknown"
    
    if remote and remote.Name then
        remoteName = remote.Name
    end
    
    -- Skip spam events
    if not shouldIgnore(remoteName) then
        -- Log event
        local logEntry = {
            remote = remoteName,
            args = args,
            time = tick()
        }
        table.insert(events, logEntry)
        
        print("[ENGINE FIRE] " .. remoteName)
        for i, arg in pairs(args) do
            print("  Arg " .. tostring(i) .. " = " .. tostring(arg))
        end
    end
    
    -- Call original
    return oldFireServer(remote, ...)
end

print("Hooked EngineService.FireServer")

-- Show events
_G.ShowEvents = function()
    print("=== ENGINE EVENTS ===")
    print("Total: " .. tostring(#events))
    for i, event in pairs(events) do
        print("[" .. tostring(i) .. "] " .. event.remote)
        for j, arg in pairs(event.args) do
            print("  " .. tostring(j) .. " = " .. tostring(arg))
        end
    end
    print("====================")
end

print("Engine Spy Active!")
print("Use: _G.ShowEvents()")
