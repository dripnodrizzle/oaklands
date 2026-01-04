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
    DebugMode = false,          -- Show debug messages (set to true for verbose output)
    CheckInterval = 2,          -- How often to check for defeated enemies (seconds)
    ShowSummary = true,         -- Show periodic summary instead of spam
}

local arisenEnemies = {}  -- Track enemies we've already arisen
local totalArisen = 0     -- Total shadows arisen this session

-- Debug print
local function debugPrint(message)
    if Config.DebugMode then
        print("[Auto-Arise] " .. message)
    end
end

-- Summary print (less spam)
local function summaryPrint(message)
    if Config.ShowSummary then
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
        totalArisen = totalArisen + 1
        debugPrint("✓ Arose shadow from: " .. enemy.Name)
        
        -- Clean up tracking after 30 seconds
        task.delay(30, function()
            arisenEnemies[enemy] = nil
        end)
        
        return true
    else
        if Config.DebugMode then
            warn("[ERROR] Failed to arise shadow: " .. tostring(err))
        end
        return false
    end
end

-- Auto-arise loop
local function autoAriseLoop()
    local lastSummary = tick()
    
    while Config.AutoArise do
        local enemies = findDefeatedEnemies()
        
        if #enemies > 0 then
            debugPrint("Found " .. #enemies .. " defeated enemies to arise")
            
            local arisenThisCheck = 0
            for _, enemy in pairs(enemies) do
                if ariseShadow(enemy) then
                    arisenThisCheck = arisenThisCheck + 1
                end
                wait(Config.AriseDelay)
            end
            
            if arisenThisCheck > 0 and Config.ShowSummary then
                summaryPrint("👻 Arose " .. arisenThisCheck .. " shadow(s) | Total: " .. totalArisen)
            end
        end
        
        -- Show periodic summary every 30 seconds
        if Config.ShowSummary and tick() - lastSummary >= 30 then
            summaryPrint("📊 Session: " .. totalArisen .. " shadows arisen")
            lastSummary = tick()
        end
        
        wait(Config.CheckInterval)
    end
end

-- Start auto-arise
if Config.AutoArise then
    summaryPrint("Auto-Arise enabled! 👻")
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
    print("[Auto-Arise] Arising " .. #enemies .. " shadows...")
    
    local count = 0
    for _, enemy in pairs(enemies) do
        if ariseShadow(enemy) then
            count = count + 1
        end
        wait(Config.AriseDelay)
    end
    
    print("[Auto-Arise] ✓ Arose " .. count .. " shadows!")
end

_G.ToggleAutoArise = function()
    Config.AutoArise = not Config.AutoArise
    print("[Auto-Arise] " .. (Config.AutoArise and "ENABLED ✓" or "DISABLED ✗"))
    
    if Config.AutoArise then
        task.spawn(autoAriseLoop)
    end
end

_G.ToggleDebug = function()
    Config.DebugMode = not Config.DebugMode
    print("[Auto-Arise] Debug mode " .. (Config.DebugMode and "ON" or "OFF"))
end

_G.SetAriseDistance = function(distance)
    Config.MaxDistance = distance
    print("[Auto-Arise] Max distance: " .. distance .. " studs")
end

_G.GetAriseStats = function()
    print("[Auto-Arise] === Session Stats ===")
    print("  Total shadows arisen: " .. totalArisen)
    print("  Auto-arise: " .. (Config.AutoArise and "ON" or "OFF"))
    print("  Max distance: " .. Config.MaxDistance .. " studs")
    print("  Check interval: " .. Config.CheckInterval .. "s")
end

_G.FindDefeated = function()
    local enemies = findDefeatedEnemies()
    print("[Auto-Arise] Found " .. #enemies .. " defeated enemies:")
    for i, enemy in pairs(enemies) do
        local distance = (enemy:FindFirstChild("HumanoidRootPart").Position - getPlayerPosition()).Magnitude
        print(string.format("  [%d] %s (%.1f studs)", i, enemy.Name, distance))
    end
    print("Total: " .. #enemies)
end


print("[Auto-Arise] ✓ Script loaded!")
print("  Auto-arise: " .. (Config.AutoArise and "ENABLED" or "DISABLED"))
print("  Max distance: " .. Config.MaxDistance .. " studs")
print("")
print("=== Commands ===")
print("  _G.AriseAll() - Arise all nearby defeated enemies")
print("  _G.AriseShadow(target) - Arise specific enemy")
print("  _G.ToggleAutoArise() - Toggle auto-arise on/off")
print("  _G.SetAriseDistance(studs) - Set max arise distance")
print("  _G.GetAriseStats() - Show session statistics")
print("  _G.FindDefeated() - List all defeated enemies")
print("")
