--> True Kill Aura
--> Passive aura that kills everything in range automatically

print("[True Kill Aura] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")

local EntityFolder = Workspace:FindFirstChild("EntityFolder")
if not EntityFolder then
    warn("[True Kill Aura] EntityFolder not found!")
    return
end

-- Settings
local AURA_RADIUS = 35 -- studs
local DAMAGE_TICK = 0.1 -- damage interval (seconds)
local DAMAGE_AMOUNT = 5000 -- damage per tick
local SHOW_VISUAL = true

-- Get character
local char = Player.Character
if not char or not char:FindFirstChild("HumanoidRootPart") then
    warn("[True Kill Aura] Character not found!")
    return
end

local hrp = char.HumanoidRootPart

-- Get combat remotes
local CombatRemotes = ReplicatedStorage.Events.Combat
local Hitted = CombatRemotes:FindFirstChild("Hitted")
local WeaponHitted = CombatRemotes:FindFirstChild("WeaponHitted")
local Attack = CombatRemotes:FindFirstChild("Attack")

-- Create visual aura
local auraVisual
if SHOW_VISUAL then
    auraVisual = Instance.new("Part")
    auraVisual.Name = "TrueKillAura"
    auraVisual.Size = Vector3.new(AURA_RADIUS * 2, 0.5, AURA_RADIUS * 2)
    auraVisual.Anchored = true
    auraVisual.CanCollide = false
    auraVisual.Transparency = 0.8
    auraVisual.Color = Color3.fromRGB(255, 0, 0)
    auraVisual.Material = Enum.Material.Neon
    auraVisual.Parent = Workspace
    
    local mesh = Instance.new("CylinderMesh")
    mesh.Parent = auraVisual
    
    -- Pulsing effect
    local pulseConnection
    pulseConnection = RunService.Heartbeat:Connect(function()
        if auraVisual and auraVisual.Parent then
            local pulse = math.sin(tick() * 3) * 0.1 + 0.8
            auraVisual.Transparency = pulse
        end
    end)
end

-- Stats
local killCount = 0
local startTime = tick()
local lastUpdate = tick()

print(string.format("[True Kill Aura] Active - %d stud radius", AURA_RADIUS))
print(string.format("[True Kill Aura] Damage: %d per %.2fs", DAMAGE_AMOUNT, DAMAGE_TICK))
print("NPCs in range will die automatically!")
print("")

-- Main aura loop - damages ALL NPCs in range simultaneously
local running = true
local auraLoop = task.spawn(function()
    while running do
        local npcsInRange = {}
        
        -- Find all NPCs in aura range
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
                                name = npc.Name
                            })
                        end
                    end
                end
            end
        end
        
        -- Damage all NPCs in range simultaneously
        if #npcsInRange > 0 then
            for _, npc in ipairs(npcsInRange) do
                local startHealth = npc.humanoid.Health
                
                -- Method 1: Direct health manipulation (client-side)
                pcall(function()
                    npc.humanoid.Health = math.max(0, npc.humanoid.Health - DAMAGE_AMOUNT)
                end)
                
                -- Method 2: Fire damage remotes rapidly
                if Hitted then
                    pcall(function() Hitted:FireServer(npc.model, DAMAGE_AMOUNT) end)
                    pcall(function() Hitted:FireServer(npc.humanoid, DAMAGE_AMOUNT) end)
                end
                
                if WeaponHitted then
                    pcall(function() WeaponHitted:FireServer(npc.model, DAMAGE_AMOUNT) end)
                    pcall(function() WeaponHitted:FireServer(npc.humanoid, DAMAGE_AMOUNT) end)
                end
                
                -- Method 3: Spam attack for each NPC
                if Attack then
                    for i = 1, 3 do
                        pcall(function() Attack:FireServer() end)
                    end
                end
                
                -- Check if killed
                if npc.humanoid.Health <= 0 and startHealth > 0 then
                    killCount = killCount + 1
                    print(string.format("[Kill] %s (Total: %d)", npc.name, killCount))
                end
            end
            
            -- Update stats
            if tick() - lastUpdate > 5 then
                lastUpdate = tick()
                local elapsed = tick() - startTime
                local kpm = killCount / (elapsed / 60)
                print(string.format("[Aura] Active | Targets: %d | Kills: %d | KPM: %.1f", 
                    #npcsInRange, killCount, kpm))
            end
        end
        
        -- Update visual position
        if auraVisual and auraVisual.Parent then
            auraVisual.CFrame = CFrame.new(hrp.Position) * CFrame.new(0, -2, 0)
        end
        
        task.wait(DAMAGE_TICK)
    end
end)

-- Cleanup function
_G.StopKillAura = function()
    running = false
    
    if auraVisual then
        auraVisual:Destroy()
    end
    
    local elapsed = tick() - startTime
    print("")
    print("=" .. string.rep("=", 60))
    print("[True Kill Aura] Stopped")
    print(string.format("Session Duration: %.1f seconds", elapsed))
    print(string.format("Total Kills: %d", killCount))
    if elapsed > 0 then
        print(string.format("Kills Per Minute: %.1f", killCount / (elapsed / 60)))
    end
    print("=" .. string.rep("=", 60))
end

print("[True Kill Aura] Running continuously...")
print("[True Kill Aura] Stop with: _G.StopKillAura()")
