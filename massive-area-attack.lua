
-- massive-area-attack.lua
-- Standalone version: runs attack and VFX automatically for the local player



local module_upvr = require(game:GetService("ReplicatedStorage"):WaitForChild("Package"):WaitForChild("Modules"):WaitForChild("CoreMod"))
local AREA_RADIUS = 17.5 -- 15-20 studs
local ATTACK_COUNT = 1 -- fire only once per cycle to prevent animation overload

print("[DEBUG] massive-area-attack.lua loaded and running!")

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local userChar = nil

local function waitForPrimaryPart(char)
    while not (char and char.PrimaryPart) do wait() end
    return char
end

local function getCurrentChar()
    if localPlayer then
        local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        return waitForPrimaryPart(char)
    end
    return nil
end

userChar = getCurrentChar()

localPlayer.CharacterAdded:Connect(function(char)
    userChar = waitForPrimaryPart(char)
end)

local function getTargets()
    if not userChar or not userChar.PrimaryPart then return {} end
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
    if not userChar or not userChar.PrimaryPart then return end
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



local function isTargetingMe(enemy)
    local hum = enemy:FindFirstChildOfClass("Humanoid")
    if not hum or not hum.Target then return false end
    return hum.Target == userChar
end




local skillRemote = game:GetService("ReplicatedStorage"):WaitForChild("Package"):WaitForChild("Events"):WaitForChild("Skill")

-- You may need to adjust the arguments to match the expected hitbox/area parameters for your game.
-- Here, we add a large hitbox argument (Vector3.new(100,100,100)) if the remote expects a size or CFrame.


task.spawn(function()
    while true do
        userChar = getCurrentChar()
        if userChar and userChar.PrimaryPart then
            print("[DEBUG] Character and PrimaryPart found:", userChar.Name)
            local targets = {}
            for _, enemy in ipairs(workspace:GetChildren()) do
                if enemy:IsA("Model") and enemy ~= userChar and enemy.PrimaryPart and enemy:FindFirstChildOfClass("Humanoid") then
                    if isTargetingMe(enemy) then
                        table.insert(targets, enemy)
                    end
                end
            end
            print("[DEBUG] Targets found:", #targets)
            for _, t in ipairs(targets) do
                print("[DEBUG] Target:", t.Name)
            end
            if #targets > 0 then
                doVFX()
                -- Only fire once per cycle to avoid animation spam
                local args = {"UseSkill", "Combat"}
                print("[DEBUG] Firing Skill remote:", unpack(args))
                skillRemote:FireServer(unpack(args))
            end
        else
            print("[DEBUG] Waiting for character/PrimaryPart...")
        end
        task.wait(0.1) -- check very frequently for continuous effect
    end
end)
