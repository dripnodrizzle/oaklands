-- Kill Aura Script for Arise (Roblox)
-- Attacks only when an enemy is within a specified range

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local AttackRemote = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Combat"):WaitForChild("Attack")
local Workspace = game:GetService("Workspace")



local enabled = true
local attackDelay = 0.0001 -- Adjust for desired speed
local auraRange = 12 -- Range in studs (change as needed, e.g., 10-15)

-- Helper: Find the closest enemy within range

local function isEnemyAlive(enemy)
    if not enemy then return false end
    -- Try to find a Humanoid and check health
    local humanoid = enemy:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health > 0 then
        return true
    end
    return false
end

local function getClosestEnemy()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position
    local closest, minDist = nil, auraRange
    local myName = LocalPlayer.Name
    -- Try common enemy folders
    for _, folderName in ipairs({"Enemies", "Mobs", "NPCs", "Monsters", "EntityFolder", "EntityDataFolder"}) do
        local folder = Workspace:FindFirstChild(folderName)
        if folder then
            for _, enemy in ipairs(folder:GetChildren()) do
                -- Exclude player character and non-models
                if enemy:IsA("Model") and enemy.Name ~= myName then
                    local root = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("RootPart")
                    if root and (root.Position - myPos).Magnitude <= minDist and isEnemyAlive(enemy) then
                        closest = enemy
                        minDist = (root.Position - myPos).Magnitude
                    end
                end
            end
        end
    end
    return closest
end




-- Kill aura: spam attacks ONLY when an enemy is in range
spawn(function()
    while enabled do
        local enemy = getClosestEnemy()
        if enemy then
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local myPos = myChar.HumanoidRootPart.Position
                local root = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("RootPart")
                if root and (root.Position - myPos).Magnitude <= auraRange then
                    -- Spam attacks rapidly while enemy is in range
                    for i = 1, 10 do
                        pcall(function()
                            AttackRemote:FireServer()
                        end)
                    end
                end
            end
        end
        wait(attackDelay)
    end
end)

-- To stop: set enabled = false
-- To change range: set auraRange = desired value
