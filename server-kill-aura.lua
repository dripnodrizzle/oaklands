--> Server Kill Aura
--> Rapid-fires server attacks for all NPCs in range

print("[Server Kill Aura] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera

local EntityFolder = Workspace:FindFirstChild("EntityFolder")
if not EntityFolder then
    warn("[Server Kill Aura] EntityFolder not found!")
    return
end

-- Settings
local AURA_RADIUS = 10 -- studs
local ATTACKS_PER_TICK = 20 -- attacks per NPC per tick
local TICK_RATE = 0.08 -- seconds between ticks (slowed down slightly)
local SHOW_VISUAL = true
local MIN_HEIGHT = 5 -- minimum Y position to prevent falling through baseplate

-- Get character
local char = Player.Character
if not char or not char:FindFirstChild("HumanoidRootPart") then
    warn("[Server Kill Aura] Character not found!")
    return
end

local hrp = char.HumanoidRootPart
local humanoid = char:FindFirstChildOfClass("Humanoid")

if not humanoid then
    warn("[Server Kill Aura] Humanoid not found!")
    return
end

-- Anti-knockback setup - keep player standing
humanoid.PlatformStand = false
pcall(function()
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
end)

-- Continuously prevent falling
local antiKnockback = RunService.Heartbeat:Connect(function()
    if humanoid and humanoid.Parent then
        -- Check if being knocked down
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.FallingDown or 
           state == Enum.HumanoidStateType.Ragdoll then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            
            -- Only correct rotation when actually knocked down
            if hrp and hrp.Parent then
                local pos = hrp.Position
                local x, y, z = hrp.CFrame:ToEulerAnglesYXZ()
                -- Reset tilt/roll but keep turning direction
                hrp.CFrame = CFrame.new(pos) * CFrame.Angles(0, y, 0)
            end
        end
        
        -- Safety check: prevent falling through baseplate
        if hrp and hrp.Parent then
            local pos = hrp.Position
            if pos.Y < MIN_HEIGHT then
                -- Teleport back up to safe height
                local x, y, z = hrp.CFrame:ToEulerAnglesYXZ()
                hrp.CFrame = CFrame.new(pos.X, MIN_HEIGHT, pos.Z) * CFrame.Angles(0, y, 0)
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- stop downward momentum
            end
        end
        
        humanoid.PlatformStand = false
    end
end)

-- Get combat remotes
local CombatRemotes = ReplicatedStorage.Events.Combat
local ToggleWeapon = CombatRemotes:FindFirstChild("Toggle Weapon")
local Attack = CombatRemotes:FindFirstChild("Attack")
local UseSkill = CombatRemotes:FindFirstChild("UseSkill")

-- Toggle weapon on
if ToggleWeapon then
    pcall(function()
        ToggleWeapon:FireServer()
    end)
    task.wait(0.3)
end

-- Create visual aura
local auraVisual
if SHOW_VISUAL then
    auraVisual = Instance.new("Part")
    auraVisual.Name = "ServerKillAura"
    auraVisual.Size = Vector3.new(AURA_RADIUS * 2, 0.5, AURA_RADIUS * 2)
    auraVisual.Anchored = true
    auraVisual.CanCollide = false
    auraVisual.Transparency = 0.8
    auraVisual.Color = Color3.fromRGB(255, 50, 50)
    auraVisual.Material = Enum.Material.Neon
    auraVisual.Parent = Workspace
    
    local mesh = Instance.new("CylinderMesh")
    mesh.Parent = auraVisual
    
    -- Pulse effect
    task.spawn(function()
        while auraVisual and auraVisual.Parent do
            local pulse = math.sin(tick() * 5) * 0.15 + 0.75
            auraVisual.Transparency = pulse
            task.wait(0.03)
        end
    end)
end

-- Stats
local killCount = 0
local attacksFired = 0
local startTime = tick()
local lastUpdate = tick()

print(string.format("[Server Kill Aura] Active - %d stud radius", AURA_RADIUS))
print(string.format("[Server Kill Aura] Firing %d attacks per NPC every %.2fs", ATTACKS_PER_TICK, TICK_RATE))
print("")

-- Main aura loop
local running = true
local currentTarget = nil

local auraLoop = task.spawn(function()
    while running do
        local npcsInRange = {}
        
        -- Find all alive NPCs in range
        for _, npc in ipairs(EntityFolder:GetChildren()) do
            if npc:IsA("Model") and npc ~= char then
                local humanoid = npc:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local rootPart = npc:FindFirstChild("HumanoidRootPart") 
                        or npc.PrimaryPart 
                        or npc:FindFirstChildOfClass("Part")
                    
                    if rootPart then
                        local distance = (rootPart.Position - hrp.Position).Magnitude
                        if distance <= AURA_RADIUS then
                            table.insert(npcsInRange, {
                                model = npc,
                                humanoid = humanoid,
                                rootPart = rootPart,
                                name = npc.Name,
                                distance = distance
                            })
                        end
                    end
                end
            end
        end
        
        -- Sort by distance (closest first)
        table.sort(npcsInRange, function(a, b) return a.distance < b.distance end)
        
        -- Attack ALL NPCs in range rapidly
        if #npcsInRange > 0 then
            for _, npc in ipairs(npcsInRange) do
                local startHealth = npc.humanoid.Health
                
                -- Face the NPC (body only, not camera)
                pcall(function()
                    hrp.CFrame = CFrame.new(hrp.Position, npc.rootPart.Position)
                end)
                
                -- RAPID FIRE attacks
                for i = 1, ATTACKS_PER_TICK do
                    pcall(function() 
                        Attack:FireServer()
                        attacksFired = attacksFired + 1
                    end)
                end
                
                -- Try skills occasionally
                if UseSkill and math.random() < 0.2 then
                    for skillId = 1, 4 do
                        pcall(function() 
                            UseSkill:FireServer(skillId)
                            attacksFired = attacksFired + 1
                        end)
                    end
                end
                
                -- Check if killed
                task.wait(0.01)
                if npc.humanoid.Health <= 0 and startHealth > 0 then
                    killCount = killCount + 1
                    print(string.format("[Kill] %s at %.1f studs (Total: %d)", npc.name, npc.distance, killCount))
                end
            end
            
            -- Stats update
            if tick() - lastUpdate > 3 then
                lastUpdate = tick()
                local elapsed = tick() - startTime
                local kpm = killCount / math.max(1, elapsed / 60)
                local aps = attacksFired / elapsed
                print(string.format("[Aura] Targets: %d | Kills: %d | KPM: %.1f | APS: %.0f", 
                    #npcsInRange, killCount, kpm, aps))
            end
        end
        
        -- Update visual position
        if auraVisual and auraVisual.Parent then
            auraVisual.CFrame = CFrame.new(hrp.Position) * CFrame.new(0, -2, 0)
        end
        
        task.wait(TICK_RATE)
    end
end)

-- Cleanup function
_G.StopServerAura = function()
    running = false
    
    -- Disconnect anti-knockback
    if antiKnockback then
        antiKnockback:Disconnect()
    end
    
    -- Re-enable normal states
    if humanoid and humanoid.Parent then
        pcall(function()
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
        end)
    end
    
    if auraVisual then
        auraVisual:Destroy()
    end
    
    local elapsed = tick() - startTime
    print("")
    print("=" .. string.rep("=", 60))
    print("[Server Kill Aura] Stopped")
    print(string.format("Session Duration: %.1f seconds", elapsed))
    print(string.format("Total Kills: %d", killCount))
    print(string.format("Total Attacks Fired: %d", attacksFired))
    if elapsed > 0 then
        print(string.format("Kills Per Minute: %.1f", killCount / (elapsed / 60)))
        print(string.format("Attacks Per Second: %.1f", attacksFired / elapsed))
    end
    print("=" .. string.rep("=", 60))
end

print("[Server Kill Aura] Running - spamming server with attacks!")
print("[Server Kill Aura] Stop with: _G.StopServerAura()")
