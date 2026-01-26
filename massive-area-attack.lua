
-- massive-area-attack.lua
-- Standalone version: runs attack and VFX automatically for the local player


local module_upvr = require(game:GetService("ReplicatedStorage"):WaitForChild("Package"):WaitForChild("Modules"):WaitForChild("CoreMod"))
local AREA_RADIUS = 17.5 -- 15-20 studs
local ATTACK_COUNT = 20000 -- tens of thousands

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local userChar = localPlayer and localPlayer.Character or nil
if not userChar or not userChar.PrimaryPart then
    local function onCharAdded(char)
        repeat wait() until char.PrimaryPart
        userChar = char
    end
    if localPlayer then
        localPlayer.CharacterAdded:Connect(onCharAdded)
    end
    repeat wait() until userChar and userChar.PrimaryPart
end

local function getTargets()
    local origin = userChar.PrimaryPart.Position
    local myPlayer = Players:GetPlayerFromCharacter(userChar)
    local hitCharacters = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= myPlayer and plr.Character and plr.Character.PrimaryPart then
            local dist = (plr.Character.PrimaryPart.Position - origin).Magnitude
            if dist <= AREA_RADIUS then
                table.insert(hitCharacters, plr.Character)
            end
        end
    end
    for _, enemy in ipairs(workspace:GetChildren()) do
        if enemy:IsA("Model") and enemy ~= userChar and enemy.PrimaryPart and enemy:FindFirstChildOfClass("Humanoid") then
            local dist = (enemy.PrimaryPart.Position - origin).Magnitude
            if dist <= AREA_RADIUS then
                table.insert(hitCharacters, enemy)
            end
        end
    end
    return hitCharacters
end

local function doVFX()
    local vfxCount = 200
    for i = 1, vfxCount do
        local angle = math.random() * 2 * math.pi
        local dist = math.random() * AREA_RADIUS
        local x = math.cos(angle) * dist
        local z = math.sin(angle) * dist
        local pos = userChar.PrimaryPart.CFrame * CFrame.new(x, math.random(-2,2), z)
        local part = module_upvr:CreatePart(module_upvr.VFXFolder.Attacks.Robux.HeavensLight, pos)
        part.Anchored = true
        part.CanCollide = false
        module_upvr:EmitParticles(part, 0, true)
        module_upvr:ShakeAllCameras(part.Position, 1, 5, 0.1, 0.2)
        module_upvr:PlaySound("LightExplosion", part)
        module_upvr:PlaySound("LightSound", part)
        task.delay(2, function()
            module_upvr:DisableParticles(part)
            module_upvr:DestroyItem(part, 2)
        end)
        task.wait(0.01)
    end
end

task.spawn(function()
    while true do
        local targets = getTargets()
        if #targets > 0 then
            doVFX()
            for _, target in ipairs(targets) do
                local hum = target:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    for i = 1, ATTACK_COUNT do
                        hum:TakeDamage(1)
                    end
                end
            end
        end
        task.wait(0.5) -- check every half second
    end
end)
