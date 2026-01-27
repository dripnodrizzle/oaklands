--> Kill Aura
--> Automatically kills NPCs within radius

print("[Kill Aura] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera

local EntityFolder = Workspace:FindFirstChild("EntityFolder")
if not EntityFolder then
    warn("[Kill Aura] EntityFolder not found!")
    return
end

-- Settings
local AURA_RADIUS = 35 -- studs
local ATTACK_INTERVAL = 0.05 -- seconds between attacks
local SHOW_VISUALS = true -- show aura circle

-- Get combat remotes
local CombatRemotes = ReplicatedStorage.Events.Combat
local ToggleWeapon = CombatRemotes:FindFirstChild("Toggle Weapon")
local Attack = CombatRemotes:FindFirstChild("Attack")
local UseSkill = CombatRemotes:FindFirstChild("UseSkill")

-- Get character
local char = Player.Character
if not char or not char:FindFirstChild("HumanoidRootPart") then
    warn("[Kill Aura] Character not found!")
    return
end

local hrp = char.HumanoidRootPart

-- Toggle weapon on
if ToggleWeapon then
    pcall(function() ToggleWeapon:FireServer() end)
    task.wait(0.2)
end

-- Create visual aura
local auraVisual
if SHOW_VISUALS then
    auraVisual = Instance.new("Part")
    auraVisual.Name = "KillAura"
    auraVisual.Size = Vector3.new(AURA_RADIUS * 2, 0.5, AURA_RADIUS * 2)
    auraVisual.Anchored = true
    auraVisual.CanCollide = false
    auraVisual.Transparency = 0.7
    auraVisual.Color = Color3.fromRGB(255, 0, 0)
    auraVisual.Material = Enum.Material.Neon
    auraVisual.Parent = Workspace
    
    -- Make it a cylinder
    local mesh = Instance.new("CylinderMesh")
    mesh.Parent = auraVisual
end

-- Stats tracking
local killCount = 0
local damageCount = 0
local startTime = tick()
local lastStatsUpdate = tick()

-- Track targeted NPCs to avoid spam
local targetedNPCs = {}

print(string.format("[Kill Aura] Active - %d stud radius", AURA_RADIUS))
print("Press Ctrl+C in console or close game to stop")
print("")

-- Main aura loop
local connection
connection = RunService.Heartbeat:Connect(function()
    -- Update visual position
    if auraVisual then
        auraVisual.CFrame = CFrame.new(hrp.Position) * CFrame.new(0, -2, 0)
    end
    
    -- Find NPCs in range
    for _, npc in ipairs(EntityFolder:GetChildren()) do
        if npc:IsA("Model") and npc ~= char then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local rootPart = npc:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local distance = (rootPart.Position - hrp.Position).Magnitude
                    
                    if distance <= AURA_RADIUS then
                        -- Check if we should attack this NPC
                        local lastAttack = targetedNPCs[npc] or 0
                        if tick() - lastAttack >= ATTACK_INTERVAL then
                            targetedNPCs[npc] = tick()
                            
                            -- Face the NPC
                            pcall(function()
                                hrp.CFrame = CFrame.new(hrp.Position, rootPart.Position)
                            end)
                            
                            -- Point camera occasionally
                            if math.random() < 0.2 then
                                pcall(function()
                                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, rootPart.Position)
                                end)
                            end
                            
                            -- Attack
                            local startHealth = humanoid.Health
                            pcall(function() Attack:FireServer() end)
                            
                            -- Try skill occasionally
                            if math.random() < 0.1 and UseSkill then
                                local skillId = math.random(1, 4)
                                pcall(function() UseSkill:FireServer(skillId) end)
                            end
                            
                            -- Track if we killed it
                            task.wait(0.02)
                            if humanoid.Health <= 0 then
                                killCount = killCount + 1
                                print(string.format("[Kill] %s (Total: %d)", npc.Name, killCount))
                                targetedNPCs[npc] = nil
                            elseif humanoid.Health < startHealth then
                                damageCount = damageCount + 1
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Clean up old targets
    for npc, lastTime in pairs(targetedNPCs) do
        if tick() - lastTime > 5 or not npc.Parent then
            targetedNPCs[npc] = nil
        end
    end
    
    -- Stats update every 10 seconds
    if tick() - lastStatsUpdate > 10 then
        lastStatsUpdate = tick()
        local elapsed = tick() - startTime
        local kpm = killCount / (elapsed / 60)
        print(string.format("[Stats] Kills: %d | Damage Hits: %d | KPM: %.1f", 
            killCount, damageCount, kpm))
    end
end)

-- Cleanup function
_G.StopKillAura = function()
    if connection then
        connection:Disconnect()
        print("[Kill Aura] Stopped")
    end
    if auraVisual then
        auraVisual:Destroy()
    end
    
    local elapsed = tick() - startTime
    print("")
    print("=" .. string.rep("=", 60))
    print(string.format("[Kill Aura] Session Complete - %.1f seconds", elapsed))
    print(string.format("Total Kills: %d", killCount))
    print(string.format("Kills Per Minute: %.1f", killCount / (elapsed / 60)))
    print("=" .. string.rep("=", 60))
end

print("[Kill Aura] Running... Call _G.StopKillAura() to stop")
print("[Kill Aura] Or use: loadstring('_G.StopKillAura()')() to stop remotely")
