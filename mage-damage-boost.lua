--> Mage Damage Boost
--> Multiplies your M1 attack damage

print("[Mage Damage Boost] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Settings
local DAMAGE_MULTIPLIER = 100 -- Multiply your normal damage by this

-- Get Mage remotes
local MageFolder = ReplicatedStorage:FindFirstChild("Mage")
if not MageFolder then
    warn("[Mage Damage Boost] Mage folder not found! Make sure you're playing as Mage class")
    return
end

local M1Remote = MageFolder:FindFirstChild("M1")
if not M1Remote then
    warn("[Mage Damage Boost] M1 remote not found!")
    return
end

print("[Mage Damage Boost] Found Mage remotes")

-- Hook the M1 remote to boost damage
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Check if this is the M1 remote being fired
    if self == M1Remote and method == "FireServer" then
        -- Modify the damage in the args
        if args[1] and type(args[1]) == "table" and args[1].Damage then
            local originalDamage = args[1].Damage
            args[1].Damage = originalDamage * DAMAGE_MULTIPLIER
            
            print(string.format("[Mage Damage Boost] Boosted damage: %.1f -> %.1f", 
                originalDamage, args[1].Damage))
        end
        
        return oldNamecall(self, unpack(args))
    end
    
    return oldNamecall(self, ...)
end)

print("[Mage Damage Boost] Active! Your M1 attacks now deal " .. DAMAGE_MULTIPLIER .. "x damage")
print("[Mage Damage Boost] Just use your normal attacks - damage will be boosted automatically")
