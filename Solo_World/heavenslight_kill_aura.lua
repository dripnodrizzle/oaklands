-- HeavensLight Area Damage Kill Aura Script
-- Place this in your executor or use with loadstring+HttpGet

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Try to find the attack/skill remote (replace with actual remote name if known)
local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage
local UseSkill = remotes:FindFirstChild("UseSkill") or remotes:FindFirstChild("Skill")

-- Replace with the actual enemy folder name if different
local ENEMY_FOLDER = Workspace:FindFirstChild("Enemies") or Workspace:FindFirstChild("EntityFolder")

if not UseSkill then
    warn("UseSkill remote not found!")
    return
end

while true do
    if ENEMY_FOLDER then
        for _, enemy in pairs(ENEMY_FOLDER:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("PrimaryPart") then
                -- Fire the skill remote at each enemy (arguments may need adjustment)
                pcall(function()
                    UseSkill:FireServer(enemy, "HeavensLight")
                end)
            end
        end
    end
    wait(0.5)
end
