-- Dungeon Reward & EXP Spy
-- Monitors all RemoteEvents/RemoteFunctions related to dungeons, rewards, and experience
-- Use this to find how to modify dungeon ranks and EXP values

print("[Dungeon Spy] Starting...")

local ReplicatedStorage = game.ReplicatedStorage
local Players = game.Players
local Player = Players.LocalPlayer

-- Logged data
local dungeonEvents = {}
local rewardEvents = {}
local expEvents = {}

-- Keywords to watch for
local dungeonKeywords = {"dungeon", "rank", "difficulty", "start", "lobby", "wave"}
local rewardKeywords = {"reward", "loot", "drop", "complete", "finish", "victory"}
local expKeywords = {"exp", "experience", "xp", "level", "gain"}

-- Check if string contains keywords
local function containsKeyword(str, keywords)
    str = string.lower(tostring(str))
    for _, keyword in ipairs(keywords) do
        if string.find(str, keyword) then
            return true
        end
    end
    return false
end

-- Format arguments for display
local function formatArgs(...)
    local args = {...}
    local formatted = {}
    for i, arg in ipairs(args) do
        if type(arg) == "table" then
            formatted[i] = "{table}"
        else
            formatted[i] = tostring(arg)
        end
    end
    return table.concat(formatted, ", ")
end

-- Get time string
local function getTime()
    return tostring(tick())
end

-- Hook RemoteEvent FireServer using simple method
local function hookRemoteEvent(remote)
    if not remote then return end
    if not remote.ClassName or remote.ClassName ~= "RemoteEvent" then return end
    
    local oldFireServer = remote.FireServer
    if not oldFireServer then return end
    
    remote.FireServer = function(self, ...)
        local remoteName = remote.Name
        local remoteParent = remote.Parent
        if remoteParent then
            remoteName = remoteParent.Name .. "." .. remoteName
        end
        
        local argsStr = formatArgs(...)
        
        -- Check if related to dungeons
        if containsKeyword(remoteName, dungeonKeywords) or 
           containsKeyword(argsStr, dungeonKeywords) then
            local event = {
                remote = remoteName,
                args = argsStr,
                time = getTime()
            }
            table.insert(dungeonEvents, event)
            print("[DUNGEON] " .. remoteName .. " -> Args: " .. event.args)
        end
        
        -- Check if related to rewards
        if containsKeyword(remoteName, rewardKeywords) or 
           containsKeyword(argsStr, rewardKeywords) then
            local event = {
                remote = remoteName,
                args = argsStr,
                time = getTime()
            }
            table.insert(rewardEvents, event)
            print("[REWARD] " .. remoteName .. " -> Args: " .. event.args)
        end
        
        -- Check if related to exp
        if containsKeyword(remoteName, expKeywords) or 
           containsKeyword(argsStr, expKeywords) then
            local event = {
                remote = remoteName,
                args = argsStr,
                time = getTime()
            }
            table.insert(expEvents, event)
            print("[EXP] " .. remoteName .. " -> Args: " .. event.args)
        end
        
        return oldFireServer(self, ...)
    end
end

-- Find and hook all RemoteEvents
print("[Dungeon Spy] Scanning for RemoteEvents...")

local function scanFolder(folder)
    if not folder then return end
    
    for _, descendant in ipairs(folder:GetDescendants()) do
        if descendant.ClassName == "RemoteEvent" then
            local name = descendant.Name
            if containsKeyword(name, dungeonKeywords) or 
               containsKeyword(name, rewardKeywords) or 
               containsKeyword(name, expKeywords) then
                pcall(function()
                    hookRemoteEvent(descendant)
                    print("[Dungeon Spy] Hooked: " .. name)
                end)
            end
        end
    end
end

-- Scan ReplicatedStorage
local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
if eventsFolder then
    scanFolder(eventsFolder)
end

local clientEvents = ReplicatedStorage:FindFirstChild("Client Events")
if clientEvents then
    scanFolder(clientEvents)
end

-- Also monitor the Engine system
if ReplicatedStorage:FindFirstChild("Engine") then
    print("[Dungeon Spy] Monitoring Engine system...")
end

print("")
print("=" .. string.rep("=", 60))
print("[Dungeon Spy] Active and monitoring")
print("[Dungeon Spy] Start/complete dungeons to capture events")
print("")
print("Commands:")
print("  _G.ShowDungeonEvents() - Show dungeon-related events")
print("  _G.ShowRewardEvents()  - Show reward-related events")
print("  _G.ShowExpEvents()     - Show experience-related events")
print("  _G.ShowAllEvents()     - Show all captured events")
print("=" .. string.rep("=", 60))

-- Helper functions
_G.ShowDungeonEvents = function()
    print("\n[DUNGEON EVENTS] Total: "..#dungeonEvents)
    for i, event in ipairs(dungeonEvents) do
        print(string.format("[%d] %s | %s -> %s", i, event.time, event.remote, event.args))
    end
end

_G.ShowRewardEvents = function()
    print("\n[REWARD EVENTS] Total: "..#rewardEvents)
    for i, event in ipairs(rewardEvents) do
        print(string.format("[%d] %s | %s -> %s", i, event.time, event.remote, event.args))
    end
end

_G.ShowExpEvents = function()
    print("\n[EXP EVENTS] Total: "..#expEvents)
    for i, event in ipairs(expEvents) do
        print(string.format("[%d] %s | %s -> %s", i, event.time, event.remote, event.args))
    end
end

_G.ShowAllEvents = function()
    _G.ShowDungeonEvents()
    _G.ShowRewardEvents()
    _G.ShowExpEvents()
end
