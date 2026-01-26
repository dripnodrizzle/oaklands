-- HeavensLight Area Damage Kill Aura Script
-- Place this in your executor or use with loadstring+HttpGet


-- HeavensLight Area Damage Kill Aura Script (updated for correct Skill remote)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local SkillRemote = ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):FindFirstChild("Skill")
local ENEMY_FOLDER = Workspace:FindFirstChild("Enemies") or Workspace:FindFirstChild("EntityFolder")

while true do
    if ENEMY_FOLDER and SkillRemote then
        for _, enemy in pairs(ENEMY_FOLDER:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("PrimaryPart") then
                pcall(function()
                    SkillRemote:FireServer(enemy, "HeavensLight")
                end)
            end
        end
    end
    wait(0.5)
end
