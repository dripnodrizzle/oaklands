-- Player Rank Spoofer - Force S Rank
print("Rank Spoofer Starting...")

local RS = game.ReplicatedStorage
local Players = game.Players
local Player = Players.LocalPlayer

-- Find PlayerInfo module
local Modules = RS.Modules
local PlayerInfo = require(Modules.PlayerInfo)

if not PlayerInfo then
    print("PlayerInfo not found!")
    return
end

print("Found PlayerInfo")

-- Find rank data
local function findRankData()
    -- Check player data
    if PlayerInfo.playerData then
        print("Found playerData")
        for key, value in pairs(PlayerInfo.playerData) do
            print("  " .. tostring(key) .. " = " .. tostring(value))
        end
    end
    
    -- Check for rank/level attributes
    if Player then
        for _, attr in pairs(Player:GetAttributes()) do
            print("Player attribute: " .. tostring(attr))
        end
    end
end

print("Scanning for rank data...")
findRankData()

-- Try to modify rank to S (which is rank 5)
local function setSRank()
    -- Method 1: Direct playerData modification
    if PlayerInfo.playerData then
        if PlayerInfo.playerData.rank then
            PlayerInfo.playerData.rank = 5
            print("Set playerData.rank to 5 (S)")
        end
        if PlayerInfo.playerData.level then
            PlayerInfo.playerData.level = 900  -- Max level for S rank
            print("Set level to 900")
        end
        if PlayerInfo.playerData.dungeon then
            PlayerInfo.playerData.dungeon = {nil, 5}  -- S rank
            print("Set dungeon rank to 5")
        end
    end
    
    -- Method 2: Hook GetServerData to return fake rank
    local SharedData = require(RS.Engine.Modules.SharedData)
    if SharedData and SharedData.GetServerData then
        local oldGetServerData = SharedData.GetServerData
        
        SharedData.GetServerData = function()
            local data = oldGetServerData()
            if data and data.dungeon then
                -- Force dungeon to S rank
                data.dungeon = {data.dungeon[1], 5}  -- Keep dungeon ID, set rank to 5
                print("Spoofed dungeon rank to S in server data")
            end
            return data
        end
        
        print("Hooked SharedData.GetServerData")
    end
    
    -- Method 3: Player attributes
    pcall(function()
        Player:SetAttribute("Rank", 5)
        Player:SetAttribute("DungeonRank", 5)
        print("Set player attributes to rank 5")
    end)
end

setSRank()

-- Continuously enforce S rank
local RS = game:GetService("RunService")
RS.Heartbeat:Connect(function()
    pcall(function()
        if PlayerInfo.playerData then
            if PlayerInfo.playerData.rank and PlayerInfo.playerData.rank < 5 then
                PlayerInfo.playerData.rank = 5
            end
        end
    end)
end)

print("")
print("Rank Spoofer Active!")
print("Your client now thinks you're S rank")
print("Try entering a dungeon to see if server accepts it")
