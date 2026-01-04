-- Force S-Rank Dungeon Start
print("S-Rank Forcer Starting...")

local RS = game.ReplicatedStorage
local Engine = RS.Engine
local Events = RS.Events

if not Engine or not Events then
    print("Engine or Events not found!")
    return
end

print("Found Engine and Events")

local EngineService = require(Engine.EngineService)
local dungeonEvents = Events.Dungeon

if not EngineService or not dungeonEvents then
    print("EngineService or Dungeon events not found!")
    return
end

print("Found EngineService and Dungeon events")

-- Find the Start remote
local startRemote = dungeonEvents.Start

if not startRemote then
    print("Start remote not found!")
    return
end

print("Found Start remote")

-- Hook EngineService.FireServer to intercept dungeon starts
local oldFireServer = EngineService.FireServer

EngineService.FireServer = function(remote, ...)
    local args = {...}
    
    -- Check if this is the dungeon Start event
    if remote == startRemote then
        print("[S-RANK] Intercepted Dungeon Start!")
        print("[S-RANK] Original args: " .. tostring(#args))
        
        -- Try different S-rank parameters
        -- S rank is typically rank 5 in most games
        local rankAttempts = {
            {5},           -- Just rank 5
            {nil, 5},      -- Second parameter as rank
            {"S"},         -- String "S"
            {nil, "S"},    -- Second parameter as string
        }
        
        -- Try each rank attempt
        for i, attempt in pairs(rankAttempts) do
            print("[S-RANK] Attempting method " .. tostring(i))
            pcall(function()
                oldFireServer(remote, table.unpack(attempt))
            end)
        end
        
        -- Also call the original
        return oldFireServer(remote, ...)
    end
    
    -- Not dungeon start, pass through normally
    return oldFireServer(remote, ...)
end

print("Hooked EngineService.FireServer")
print("S-Rank Forcer Active!")
print("Try starting a dungeon now")
