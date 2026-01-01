-- Auto Shadow Arise Script
-- Automatically arises shadows from all defeated enemies using the TryArise remote

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Find the TryArise remote
local TryArise = nil
for _, descendant in pairs(ReplicatedStorage:GetDescendants()) do
    if descendant.Name == "TryArise" and (descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction")) then
        TryArise = descendant
        print("[FOUND] TryArise remote: " .. descendant:GetFullName())
        break
    end
end

if not TryArise then
    warn("[ERROR] Could not find TryArise remote!")
    return
end

-- Configuration
local Config = {
    AutoArise = true,           -- Automatically arise all defeated enemies
    AriseDelay = 0.1,           -- Delay between arise attempts (seconds)
    MaxDistance = 100,          -- Max distance to arise from (studs)
    DebugMode = true,           -- Show debug messages
    CheckInterval = 1,          -- How often to check for defeated enemies (seconds)
}

local arisenEnemies = {}  -- Track enemies we've already arisen

-- Debug print
local function debugPrint(message)
    if Config.DebugMode then
        print("[Auto-Arise] " .. message)
    end
end

-- Get player position
local function getPlayerPosition()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return LocalPlayer.Character.HumanoidRootPart.Position
    end
    return nil
end

-- Check if enemy is defeated
local function isDefeated(entity)
    if not entity or not entity:IsA("Model") then return false end
    
    local humanoid = entity:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    return humanoid.Health <= 0
end

-- Find all defeated enemies
local function findDefeatedEnemies()
    local enemies = {}
    local playerPos = getPlayerPosition()
    if not playerPos then return enemies end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name ~= LocalPlayer.Name then
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            local rootPart = obj:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health <= 0 then
                -- Check distance
                local distance = (rootPart.Position - playerPos).Magnitude
                if distance <= Config.MaxDistance then
                    -- Check if not already arisen
                    if not arisenEnemies[obj] then
                        table.insert(enemies, obj)
                    end
                end
            end
        end
    end
    
    return enemies
end

-- Arise shadow from enemy
local function ariseShadow(enemy)
    if not enemy then return false end
    
    local success, err = pcall(function()
        -- The remote expects: (entity_table, true)
        TryArise:FireServer(enemy, true)
    end)
    
    if success then
        arisenEnemies[enemy] = true
        debugPrint("✓ Arose shadow from: " .. enemy.Name)
        
        -- Clean up tracking after 30 seconds
        task.delay(30, function()
            arisenEnemies[enemy] = nil
        end)
        
        return true
    else
        warn("[ERROR] Failed to arise shadow: " .. tostring(err))
        return false
    end
end

-- Auto-arise loop
local function autoAriseLoop()
    while Config.AutoArise do
        local enemies = findDefeatedEnemies()
        
        if #enemies > 0 then
            debugPrint("Found " .. #enemies .. " defeated enemies to arise")
            
            for _, enemy in pairs(enemies) do
                ariseShadow(enemy)
                wait(Config.AriseDelay)
            end
        end
        
        wait(Config.CheckInterval)
    end
end

-- Start auto-arise
if Config.AutoArise then
    debugPrint("Auto-Arise enabled! Starting loop...")
    task.spawn(autoAriseLoop)
end

-- Manual functions
_G.AriseShadow = function(target)
    if type(target) == "string" then
        target = workspace:FindFirstChild(target, true)
    end
    
    if not target then
        warn("Target not found!")
        return
    end
    
    return ariseShadow(target)
end

_G.AriseAll = function()
    local enemies = findDefeatedEnemies()
    debugPrint("Arising " .. #enemies .. " shadows...")
    
    for _, enemy in pairs(enemies) do
        ariseShadow(enemy)
        wait(Config.AriseDelay)
    end
end

_G.ToggleAutoArise = function()
    Config.AutoArise = not Config.AutoArise
    debugPrint("Auto-Arise " .. (Config.AutoArise and "ENABLED" or "DISABLED"))
    
    if Config.AutoArise then
        task.spawn(autoAriseLoop)
    end
end

_G.SetAriseDistance = function(distance)
    Config.MaxDistance = distance
    debugPrint("Max arise distance set to: " .. distance .. " studs")
end

_G.FindDefeated = function()
    local enemies = findDefeatedEnemies()
    print("=== Defeated Enemies ===")
    for i, enemy in pairs(enemies) do
        local rootPart = enemy:FindFirstChild("HumanoidRootPart")
        local distance = rootPart and (rootPart.Position - getPlayerPosition()).Magnitude or "?"
        print(string.format("[%d] %s (%.1f studs away)", i, enemy.Name, distance))
    end
    print("Total: " .. #enemies)
end

debugPrint("Script loaded successfully!")
debugPrint("Auto-Arise is " .. (Config.AutoArise and "ENABLED" or "DISABLED"))
print("")
print("=== Commands ===")
print("  _G.AriseAll() - Arise all nearby defeated enemies")
print("  _G.AriseShadow(target) - Arise specific enemy")
print("  _G.ToggleAutoArise() - Toggle auto-arise on/off")
print("  _G.SetAriseDistance(studs) - Set max arise distance")
print("  _G.FindDefeated() - List all defeated enemies")
print("")
