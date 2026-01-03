--> EXP Boost
--> Multiplies experience gained from kills

print("[EXP Boost] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Settings
local TARGET_EXP = 5000 -- Set all exp gains to this amount

print("[EXP Boost] Hooking experience system...")

-- Hook all remote calls to modify exp values
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Hook FireServer calls that might contain exp data
    if method == "FireServer" or method == "InvokeServer" then
        -- Check if args contain exp-related data
        if args[1] and type(args[1]) == "table" then
            -- Look for common exp field names
            if args[1].Exp then
                local originalExp = args[1].Exp
                args[1].Exp = TARGET_EXP
                print(string.format("[EXP Boost] Modified Exp: %d -> %d", originalExp, TARGET_EXP))
            end
            
            if args[1].Experience then
                local originalExp = args[1].Experience
                args[1].Experience = TARGET_EXP
                print(string.format("[EXP Boost] Modified Experience: %d -> %d", originalExp, TARGET_EXP))
            end
            
            if args[1].XP then
                local originalExp = args[1].XP
                args[1].XP = TARGET_EXP
                print(string.format("[EXP Boost] Modified XP: %d -> %d", originalExp, TARGET_EXP))
            end
        end
        
        return oldNamecall(self, unpack(args))
    end
    
    return oldNamecall(self, ...)
end)

-- Also hook OnClientEvent to modify incoming exp
local oldFireClient = Instance.new("RemoteEvent").FireClient
for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
    if remote:IsA("RemoteEvent") then
        local oldConnect = remote.OnClientEvent.Connect
        remote.OnClientEvent.Connect = function(self, func)
            return oldConnect(self, function(...)
                local args = {...}
                
                -- Modify exp in received data
                if args[1] and type(args[1]) == "table" then
                    if args[1].Exp then
                        args[1].Exp = TARGET_EXP
                    end
                    if args[1].Experience then
                        args[1].Experience = TARGET_EXP
                    end
                    if args[1].XP then
                        args[1].XP = TARGET_EXP
                    end
                end
                
                return func(...)
            end)
        end
    end
end

print("[EXP Boost] Active! All exp gains will be set to " .. TARGET_EXP)
print("[EXP Boost] Kill enemies to see boosted exp")
