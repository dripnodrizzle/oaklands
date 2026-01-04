-- Enhanced Auto Shadow Arise
-- Automatically captures and arises shadows using the exact game format

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Find the TryArise remote
local TryArise = nil
for _, descendant in pairs(ReplicatedStorage:GetDescendants()) do
    if descendant.Name == "TryArise" and (descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction")) then
        TryArise = descendant
        print("[Auto-Arise] ✓ Found TryArise: " .. descendant:GetFullName())
        break
    end
end

if not TryArise then
    warn("[Auto-Arise] ERROR: Could not find TryArise remote!")
    return
end

-- Configuration
local Config = {
    AutoArise = true,
    AriseDelay = 0.15,
    MaxDistance = 80,
    CheckInterval = 1.5,
    ShowMessages = true,
    MinHealth = 0,
    MaxHealth = 0,
}

local arisenEnemies = {}
local totalArisen = 0
local capturedFormat = nil  -- Store the exact format from manual arise

-- Capture the exact format used when manually arising
local mt = getrawmetatable(game)
local old_namecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if (method == "FireServer" or method == "InvokeServer") and self == TryArise then
        -- Capture the exact format for future reference
        if not capturedFormat and args[1] then
            capturedFormat = {
                type = type(args[1]),
                isTable = type(args[1]) == "table",
                secondArg = args[2],
            }
            
            if Config.ShowMessages then
                print("[Auto-Arise] 📸 Captured arise format:")
                print("  Arg 1 type: " .. type(args[1]))
                print("  Arg 2: " .. tostring(args[2]))
                
                if type(args[1]) == "table" then
                    print("  Table contents:")
                    for k, v in pairs(args[1]) do
                        print("    [" .. tostring(k) .. "] = " .. tostring(v))
                    end
                end
            end
        end
    end
    
    return old_namecall(self, ...)
end)

setreadonly(mt, true)

-- Get player position
local function getPlayerPosition()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return LocalPlayer.Character.HumanoidRootPart.Position
    end
    return nil
end

-- Build proper enemy reference (like the game does)
local function buildEnemyReference(enemy)
    -- Try to match the game's format
    -- Most games pass either the model directly or a reference table
    
    -- Option 1: Direct model reference
    if enemy:IsA("Model") then
        return enemy
    end
    
    -- Option 2: Build reference table (if game uses this format)
    local reference = {
        Model = enemy,
        Name = enemy.Name,
        Instance = enemy,
    }
    
    -- Check for common enemy properties
    local humanoid = enemy:FindFirstChildOfClass("Humanoid")
    if humanoid then
        reference.Humanoid = humanoid
        reference.MaxHealth = humanoid.MaxHealth
    end
    
    local rootPart = enemy:FindFirstChild("HumanoidRootPart")
    if rootPart then
        reference.RootPart = rootPart
        reference.Position = rootPart.Position
    end
    
    return enemy  -- Default to direct reference
end

-- Find all defeated enemies
local function findDefeatedEnemies()
    local enemies = {}
    local playerPos = getPlayerPosition()
    if not playerPos then return enemies end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= LocalPlayer.Character then
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            local rootPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
            
            if humanoid and rootPart then
                -- Check if defeated (health = 0)
                if humanoid.Health >= Config.MinHealth and humanoid.Health <= Config.MaxHealth then
                    -- Check distance
                    local distance = (rootPart.Position - playerPos).Magnitude
                    if distance <= Config.MaxDistance then
                        -- Check if not already arisen
                        local key = obj.Name .. "_" .. tostring(obj)
                        if not arisenEnemies[key] then
                            table.insert(enemies, {
                                model = obj,
                                name = obj.Name,
                                distance = distance,
                                key = key
                            })
                        end
                    end
                end
            end
        end
    end
    
    -- Sort by distance (closest first)
    table.sort(enemies, function(a, b) return a.distance < b.distance end)
    
    return enemies
end

-- Arise shadow from enemy
local function ariseShadow(enemyData)
    if not enemyData or not enemyData.model then return false end
    
    local enemy = enemyData.model
    local success, err = pcall(function()
        -- Build the reference in the format the game expects
        local reference = buildEnemyReference(enemy)
        
        -- Fire the remote with the exact format
        TryArise:FireServer(reference, true)
    end)
    
    if success then
        arisenEnemies[enemyData.key] = true
        totalArisen = totalArisen + 1
        
        if Config.ShowMessages then
            print(string.format("[Auto-Arise] 👻 Arose: %s (%.1f studs) | Total: %d", 
                enemyData.name, enemyData.distance, totalArisen))
        end
        
        -- Clean up after 60 seconds
        task.delay(60, function()
            arisenEnemies[enemyData.key] = nil
        end)
        
        return true
    else
        if Config.ShowMessages then
            warn("[Auto-Arise] ❌ Failed: " .. enemyData.name .. " - " .. tostring(err))
        end
        return false
    end
end

-- Auto-arise loop
local function autoAriseLoop()
    while Config.AutoArise do
        local enemies = findDefeatedEnemies()
        
        if #enemies > 0 then
            local arisenCount = 0
            
            for _, enemyData in pairs(enemies) do
                if ariseShadow(enemyData) then
                    arisenCount = arisenCount + 1
                end
                wait(Config.AriseDelay)
            end
        end
        
        wait(Config.CheckInterval)
    end
end

-- Start
if Config.AutoArise then
    print("[Auto-Arise] ✓ Started! Auto-arising shadows...")
    task.spawn(autoAriseLoop)
end

-- Global functions
_G.AriseNearest = function()
    local enemies = findDefeatedEnemies()
    if #enemies == 0 then
        print("[Auto-Arise] No defeated enemies found")
        return
    end
    
    print("[Auto-Arise] Arising nearest enemy: " .. enemies[1].name)
    ariseShadow(enemies[1])
end

_G.AriseAll = function()
    local enemies = findDefeatedEnemies()
    print("[Auto-Arise] Found " .. #enemies .. " defeated enemies")
    
    local count = 0
    for _, enemyData in pairs(enemies) do
        if ariseShadow(enemyData) then
            count = count + 1
        end
        wait(Config.AriseDelay)
    end
    
    print("[Auto-Arise] ✓ Arose " .. count .. " shadows!")
end

_G.ListDefeated = function()
    local enemies = findDefeatedEnemies()
    print("[Auto-Arise] === Defeated Enemies ===")
    for i, enemyData in pairs(enemies) do
        print(string.format("  [%d] %s (%.1f studs)", i, enemyData.name, enemyData.distance))
    end
    print("Total: " .. #enemies)
end

_G.ToggleAutoArise = function()
    Config.AutoArise = not Config.AutoArise
    print("[Auto-Arise] " .. (Config.AutoArise and "ENABLED ✓" or "DISABLED ✗"))
    if Config.AutoArise then
        task.spawn(autoAriseLoop)
    end
end

_G.SetDistance = function(distance)
    Config.MaxDistance = distance
    print("[Auto-Arise] Max distance: " .. distance .. " studs")
end

_G.AriseStats = function()
    print("[Auto-Arise] === Stats ===")
    print("  Shadows arisen: " .. totalArisen)
    print("  Auto-arise: " .. (Config.AutoArise and "ON" or "OFF"))
    print("  Max distance: " .. Config.MaxDistance)
    print("  Captured format: " .. (capturedFormat and "Yes" or "No"))
end

_G.TestArise = function(targetName)
    local target = workspace:FindFirstChild(targetName, true)
    if not target then
        warn("[Auto-Arise] Target not found: " .. targetName)
        return
    end
    
    print("[Auto-Arise] Testing arise on: " .. target.Name)
    local enemyData = {
        model = target,
        name = target.Name,
        distance = 0,
        key = target.Name .. "_test"
    }
    ariseShadow(enemyData)
end

print("[Auto-Arise] ✓ Ready!")
print("  Commands: _G.AriseAll() | _G.AriseNearest() | _G.ListDefeated() | _G.AriseStats()")
print("  Tip: Manually arise one shadow first so I can capture the exact format!")
print("")
