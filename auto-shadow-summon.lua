-- auto-shadow-summon.lua
-- Automatically summons a shadow by firing the Skill remote with "SummonShadow" every second

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local skillRemote = ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("Skill")

local args = {"SummonShadow"}

print("[DEBUG] auto-shadow-summon.lua loaded and running!")

-- Continuously summon shadow every second
task.spawn(function()
    while true do
        skillRemote:FireServer(unpack(args))
        print("[DEBUG] SummonShadow remote fired!")
        task.wait(1)
    end
end)
