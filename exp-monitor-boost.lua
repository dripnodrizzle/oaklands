-- EXP Monitor & Boost Attempt
print("EXP Monitor Starting...")

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

-- Track EXP changes
local lastExp = 0
local expGains = {}

-- Monitor PlayerInfo for EXP changes
local function checkExpChange()
    if PlayerInfo.playerData and PlayerInfo.playerData.exp then
        local currentExp = PlayerInfo.playerData.exp
        
        if currentExp ~= lastExp and lastExp > 0 then
            local gain = currentExp - lastExp
            table.insert(expGains, {
                amount = gain,
                time = tick(),
                total = currentExp
            })
            print("[EXP GAIN] +" .. tostring(gain) .. " EXP (Total: " .. tostring(currentExp) .. ")")
        end
        
        lastExp = currentExp
    end
end

-- Initialize
if PlayerInfo.playerData and PlayerInfo.playerData.exp then
    lastExp = PlayerInfo.playerData.exp
    print("[EXP] Current EXP: " .. tostring(lastExp))
end

-- Monitor continuously
local RunService = game:GetService("RunService")
RunService.Heartbeat:Connect(checkExpChange)

-- Try to hook EXP setting functions
if PlayerInfo.playerData then
    -- Method 1: Hook direct modification
    local playerData = PlayerInfo.playerData
    local expMeta = getmetatable(playerData)
    
    if not expMeta then
        expMeta = {}
        setmetatable(playerData, expMeta)
    end
    
    -- Try to intercept exp changes
    pcall(function()
        local oldIndex = expMeta.__newindex or rawset
        
        expMeta.__newindex = function(tbl, key, value)
            if key == "exp" or key == "experience" then
                print("[EXP SET] Detected EXP change to: " .. tostring(value))
                
                -- Try to multiply it
                local boostedValue = value * 25000 / 100  -- Boost to massive amount
                print("[EXP BOOST] Attempting to set to: " .. tostring(boostedValue))
                
                oldIndex(tbl, key, boostedValue)
                return
            end
            
            oldIndex(tbl, key, value)
        end
        
        setmetatable(playerData, expMeta)
        print("Hooked PlayerInfo.playerData EXP modifications")
    end)
end

-- Show EXP gains
_G.ShowExpGains = function()
    print("\n=== EXP GAINS ===")
    print("Total gains recorded: " .. tostring(#expGains))
    
    for i, gain in pairs(expGains) do
        print("[" .. tostring(i) .. "] +" .. tostring(gain.amount) .. " EXP -> Total: " .. tostring(gain.total))
    end
    
    if #expGains > 0 then
        local totalGained = 0
        for _, gain in pairs(expGains) do
            totalGained = totalGained + gain.amount
        end
        print("\nTotal EXP gained this session: " .. tostring(totalGained))
    end
    print("=================\n")
end

print("")
print("EXP Monitor Active!")
print("Kill enemies or complete dungeons to see EXP gains")
print("Use: _G.ShowExpGains() to see all gains")
