-- Brute-force Stats Remote for Health/Heal/SetHealth
-- Tries common argument patterns to see if any grant infinite health or healing

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StatsRemote = ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("Stats")

local testArgs = {
    {"Health", 999999},
    {"SetHealth", 999999},
    {"Heal", 999999},
    {"Regen", 999999},
    {"Player", game.Players.LocalPlayer},
}

for _, args in ipairs(testArgs) do
    pcall(function()
        StatsRemote:FireServer(unpack(args))
    end)
end

print("[Brute-force StatsRemote] All test arguments sent.")
