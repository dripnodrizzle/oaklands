-- Auto Arise Script
-- Ensures the player character successfully spawns/arises every time
-- Handles respawning, character loading, and resurrection mechanics

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local isProcessing = false

-- Configuration
local Config = {
    AutoRespawn = true,
    RespawnDelay = 0.5,  -- Delay before respawning (in seconds)
    MaxRetries = 10,      -- Maximum respawn attempts
    DebugMode = true,     -- Print debug messages
}

-- Debug print function
local function debugPrint(message)
    if Config.DebugMode then
        print("[Auto-Arise] " .. message)
    end
end

-- Check if character is alive
local function isCharacterAlive(character)
    if not character then return false end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    return humanoid.Health > 0
end

-- Force respawn function
local function forceRespawn()
    if isProcessing then return end
    isProcessing = true
    
    debugPrint("Attempting to respawn...")
    
    local success, error = pcall(function()
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
        
        wait(Config.RespawnDelay)
        LocalPlayer:LoadCharacter()
    end)
    
    if success then
        debugPrint("Respawn successful!")
    else
        debugPrint("Respawn error: " .. tostring(error))
    end
    
    wait(1)
    isProcessing = false
end

-- Enhanced respawn with retries
local function reliableRespawn()
    if isProcessing then return end
    
    task.spawn(function()
        local retries = 0
        while retries < Config.MaxRetries do
            retries = retries + 1
            debugPrint("Respawn attempt " .. retries .. "/" .. Config.MaxRetries)
            
            forceRespawn()
            
            -- Wait and check if respawn was successful
            wait(2)
            
            if LocalPlayer.Character and isCharacterAlive(LocalPlayer.Character) then
                debugPrint("Character successfully arose!")
                return
            end
        end
        
        debugPrint("Failed to respawn after " .. Config.MaxRetries .. " attempts")
    end)
end

-- Handle character death
local function onCharacterDeath(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    
    humanoid.Died:Connect(function()
        debugPrint("Character died, preparing to respawn...")
        
        if Config.AutoRespawn then
            wait(Config.RespawnDelay)
            reliableRespawn()
        end
    end)
end

-- Handle character added
local function onCharacterAdded(character)
    debugPrint("Character loading...")
    
    -- Wait for character to fully load
    character:WaitForChild("HumanoidRootPart", 10)
    character:WaitForChild("Humanoid", 10)
    
    debugPrint("Character fully loaded and ready!")
    
    -- Setup death handler
    onCharacterDeath(character)
end

-- Initialize for current character
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

-- Listen for new characters
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Heartbeat monitor (ensures character stays loaded)
local lastCheck = tick()
RunService.Heartbeat:Connect(function()
    if tick() - lastCheck >= 5 then
        lastCheck = tick()
        
        if not LocalPlayer.Character or not isCharacterAlive(LocalPlayer.Character) then
            if Config.AutoRespawn and not isProcessing then
                debugPrint("Character missing or dead, initiating respawn...")
                reliableRespawn()
            end
        end
    end
end)

-- Manual respawn command
_G.Respawn = function()
    debugPrint("Manual respawn triggered!")
    reliableRespawn()
end

-- Configuration commands
_G.SetAutoRespawn = function(enabled)
    Config.AutoRespawn = enabled
    debugPrint("Auto-respawn " .. (enabled and "enabled" or "disabled"))
end

_G.SetRespawnDelay = function(delay)
    Config.RespawnDelay = delay
    debugPrint("Respawn delay set to " .. delay .. " seconds")
end

debugPrint("Auto-Arise script loaded successfully!")
debugPrint("Commands available:")
debugPrint("  _G.Respawn() - Force respawn")
debugPrint("  _G.SetAutoRespawn(true/false) - Toggle auto-respawn")
debugPrint("  _G.SetRespawnDelay(seconds) - Set respawn delay")
