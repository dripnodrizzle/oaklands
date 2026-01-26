-- HeavensLight Area Damage Kill Aura Script
-- Place this in your executor or use with loadstring+HttpGet


-- HeavensLight Area Damage Kill Aura Script (updated for correct Skill remote)

-- HeavensLight Area Damage Kill Aura Script (updated for correct Skill remote arguments)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SkillRemote = ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("Skill")

while true do
    if SkillRemote then
        pcall(function()
            SkillRemote:FireServer("UseSkill", "Combat")
        end)
    end
    wait(0.5)
end
