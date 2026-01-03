--> Health Boost
--> Sets your health to 9999

print("[Health Boost] Starting...")

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Settings
local TARGET_HEALTH = 9999

local function boostHealth()
    local char = Player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Set max health and current health
    humanoid.MaxHealth = TARGET_HEALTH
    humanoid.Health = TARGET_HEALTH
    
    print("[Health Boost] Health set to " .. TARGET_HEALTH)
end

-- Boost health on initial load
if Player.Character then
    boostHealth()
end

-- Boost health when character spawns
Player.CharacterAdded:Connect(function(char)
    task.wait(0.5) -- Wait for character to fully load
    boostHealth()
end)

-- Continuously maintain health
local connection
connection = RunService.Heartbeat:Connect(function()
    local char = Player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Keep max health at 9999
            if humanoid.MaxHealth ~= TARGET_HEALTH then
                humanoid.MaxHealth = TARGET_HEALTH
            end
            
            -- Heal if damaged
            if humanoid.Health < TARGET_HEALTH then
                humanoid.Health = TARGET_HEALTH
            end
        end
    end
end)

print("[Health Boost] Active! Your health is now " .. TARGET_HEALTH)
print("[Health Boost] Health will be maintained even if damaged")
