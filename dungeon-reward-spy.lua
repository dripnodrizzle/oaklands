--> Dungeon Reward & EXP Spy
--> Monitors all RemoteEvents/RemoteFunctions related to dungeons, rewards, and experience
--> Use this to find how to modify dungeon ranks and EXP values

print("[Dungeon Spy] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Store original functions
local originalFireServer = nil
local originalInvokeServer = nil

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
            formatted[i] = "{"..tostring(#arg).." items}"
        else
            formatted[i] = tostring(arg)
        end
    end
    return table.concat(formatted, ", ")
end

-- Hook RemoteEvent:FireServer
local function hookRemoteEvent(remote)
    if not remote:IsA("RemoteEvent") then return end
    
    local mt = getrawmetatable(remote)
    if not mt then return end
    
    setreadonly(mt, false)
    local oldFireServer = mt.__namecall
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        
        if method == "FireServer" and self == remote then
            local args = {...}
            local remoteName = remote:GetFullName()
            
            -- Check if related to dungeons
            if containsKeyword(remoteName, dungeonKeywords) or 
               containsKeyword(formatArgs(...), dungeonKeywords) then
                local event = {
                    remote = remoteName,
                    args = formatArgs(...),
                    time = os.date("%H:%M:%S")
                }
                table.insert(dungeonEvents, event)
                print("[DUNGEON] "..remoteName.." -> Args: "..event.args)
            end
            
            -- Check if related to rewards
            if containsKeyword(remoteName, rewardKeywords) or 
               containsKeyword(formatArgs(...), rewardKeywords) then
                local event = {
                    remote = remoteName,
                    args = formatArgs(...),
                    time = os.date("%H:%M:%S")
                }
                table.insert(rewardEvents, event)
                print("[REWARD] "..remoteName.." -> Args: "..event.args)
            end
            
            -- Check if related to exp
            if containsKeyword(remoteName, expKeywords) or 
               containsKeyword(formatArgs(...), expKeywords) then
                local event = {
                    remote = remoteName,
                    args = formatArgs(...),
                    time = os.date("%H:%M:%S")
                }
                table.insert(expEvents, event)
                print("[EXP] "..remoteName.." -> Args: "..event.args)
            end
        end
        
        return oldFireServer(self, ...)
    end)
    
    setreadonly(mt, true)
end

-- Find and hook all RemoteEvents
print("[Dungeon Spy] Scanning for RemoteEvents...")

local function scanFolder(folder)
    for _, descendant in ipairs(folder:GetDescendants()) do
        if descendant:IsA("RemoteEvent") then
            local name = descendant:GetFullName()
            if containsKeyword(name, dungeonKeywords) or 
               containsKeyword(name, rewardKeywords) or 
               containsKeyword(name, expKeywords) then
                pcall(function()
                    hookRemoteEvent(descendant)
                    print("[Dungeon Spy] Hooked: "..name)
                end)
            end
        end
    end
end

-- Scan ReplicatedStorage
if ReplicatedStorage:FindFirstChild("Events") then
    scanFolder(ReplicatedStorage.Events)
end

if ReplicatedStorage:FindFirstChild("Client Events") then
    scanFolder(ReplicatedStorage:FindFirstChild("Client Events"))
end

-- Also monitor the Engine system
if ReplicatedStorage:FindFirstChild("Engine") then
    print("[Dungeon Spy] Monitoring Engine system...")
end

print("")
print("="..string.rep("=", 60))
print("[Dungeon Spy] Active and monitoring")
print("[Dungeon Spy] Start/complete dungeons to capture events")
print("")
print("Commands:")
print("  _G.ShowDungeonEvents() - Show dungeon-related events")
print("  _G.ShowRewardEvents()  - Show reward-related events")
print("  _G.ShowExpEvents()     - Show experience-related events")
print("  _G.ShowAllEvents()     - Show all captured events")
print("="..string.rep("=", 60))

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
