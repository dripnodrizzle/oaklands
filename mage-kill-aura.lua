--> Mage Kill Aura
--> Automatically fires Mage M1 attacks at nearby NPCs

print("[Mage Kill Aura] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera

-- Check for ENPC folder (this game's NPC folder)
local ENPCFolder = Workspace:FindFirstChild("ENPC")
if not ENPCFolder then
    warn("[Mage Kill Aura] ENPC folder not found!")
    return
end

print("[Mage Kill Aura] Found ENPC folder")

-- Settings
local AURA_RADIUS = 50 -- studs
local ATTACK_INTERVAL = 0.1 -- seconds between attacks
local SHOW_VISUALS = true -- show aura circle

-- Get Intelligence stat for damage calculation
local Intelligence = Player:WaitForChild("Intelligence")

-- Calculate damage (boosted for kill aura)
local function calculateDamage()
    return (Intelligence.Value ^ 1.25) * 100 -- 100x multiplier
end

-- Get Mage remotes
local MageFolder = ReplicatedStorage:FindFirstChild("Mage")
if not MageFolder then
    warn("[Mage Kill Aura] Mage folder not found in ReplicatedStorage!")
    warn("[Mage Kill Aura] Make sure you're playing as Mage class")
    return
end

local M1Remote = MageFolder:FindFirstChild("M1")
if not M1Remote then
    warn("[Mage Kill Aura] M1 remote not found!")
    return
end

print("[Mage Kill Aura] Found Mage remotes")

-- Get character
local char = Player.Character or Player.CharacterAdded:Wait()
if not char:FindFirstChild("HumanoidRootPart") then
    warn("[Mage Kill Aura] HumanoidRootPart not found!")
    return
end

local hrp = char.HumanoidRootPart

-- Create visual aura
local auraVisual
if SHOW_VISUALS then
    auraVisual = Instance.new("Part")
    auraVisual.Name = "MageKillAura"
    auraVisual.Size = Vector3.new(AURA_RADIUS * 2, 0.5, AURA_RADIUS * 2)
    auraVisual.Anchored = true
    auraVisual.CanCollide = false
    auraVisual.Transparency = 0.8
    auraVisual.Color = Color3.fromRGB(138, 43, 226) -- Purple for mage
    auraVisual.Material = Enum.Material.Neon
    auraVisual.Parent = Workspace
    
    -- Make it glow
    local PointLight = Instance.new("PointLight")
    PointLight.Brightness = 1
    PointLight.Color = Color3.fromRGB(138, 43, 226)
    PointLight.Range = AURA_RADIUS
    PointLight.Parent = auraVisual
end

-- Function to check if a model is an NPC (not a player)
local function isNPC(model)
    -- Check if it has a humanoid
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    -- Check if it's not a player character
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character == model then
            return false
        end
    end
    
    return true
end

-- Function to get closest NPC in camera view (mimics original GetTargetInFront)
local function getClosestNPC()
    local closestNPC = nil
    local closestDistance = AURA_RADIUS
    local hrpPosition = hrp.Position
    
    for _, npc in pairs(ENPCFolder:GetChildren()) do
        if npc.PrimaryPart then
            local npcPosition = npc.PrimaryPart.Position
            local distance = (npcPosition - hrpPosition).Magnitude
            
            if distance <= AURA_RADIUS then
                local humanoid = npc:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    -- Check if in camera view (20 degree cone like original)
                    local angle = math.acos(Camera.CFrame.LookVector:Dot((npcPosition - hrpPosition).Unit))
                    if angle <= math.rad(20) then
                        if distance < closestDistance then
                            closestDistance = distance
                            closestNPC = npc
                        end
                    end
                end
            end
        end
    end
    
    return closestNPC
end

-- Function to get nearby NPCs
local function getNearbyNPCs()
    local nearbyNPCs = {}
    
    for _, npc in pairs(ENPCFolder:GetChildren()) do
        if npc.PrimaryPart then
            local npcHRP = npc.PrimaryPart
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            
            if humanoid and humanoid.Health > 0 then
                local distance = (hrp.Position - npcHRP.Position).Magnitude
                
                if distance <= AURA_RADIUS then
                    table.insert(nearbyNPCs, npc)
                end
            end
        end
    end
    
    return nearbyNPCs
end

-- Function to fire Mage M1 combo (matches original script structure)
local function fireMageAttack(combo)
    local success, err = pcall(function()
        -- Get closest NPC for auto-targeting
        local closestNPC = getClosestNPC()
        
        -- Build the args table like the original script
        local args = {
            Player = Player,
            Character = char,
            Damage = calculateDamage(),
            Closest = closestNPC, -- Auto-targeting
            Cam = Camera.CFrame,
            Combo = combo
        }
        
        -- Fire M1 remote (this creates the pellet on client)
        M1Remote:FireServer(args)
    end)
    
    if not success then
        warn("[Mage Kill Aura] Attack error:", err)
    end
end

-- Stats
local stats = {
    totalAttacks = 0,
    targetsHit = {},
    startTime = tick()
}

-- Main attack loop
local currentCombo = 1
local lastAttackTime = 0
local running = true

print("[Mage Kill Aura] Active! Aura radius:", AURA_RADIUS, "studs")
print("[Mage Kill Aura] Press Ctrl+C to stop")

RunService.Heartbeat:Connect(function()
    if not running then return end
    
    -- Update aura visual position
    if auraVisual then
        auraVisual.Position = hrp.Position - Vector3.new(0, 3, 0)
    end
    
    -- Check if it's time to attack
    local currentTime = tick()
    if currentTime - lastAttackTime >= ATTACK_INTERVAL then
        lastAttackTime = currentTime
        
        -- Get nearby NPCs
        local targets = getNearbyNPCs()
        
        if #targets > 0 then
            -- Attack all nearby NPCs
            for _, target in ipairs(targets) do
                fireMageAttack(target, currentCombo)
                
                -- Track stats
                stats.totalAttacks = stats.totalAttacks + 1
                stats.targetsHit[target.Name] = (stats.targetsHit[target.Name] or 0) + 1
            end
            
            -- Cycle through combo (1, 2, 3, repeat)
            currentCombo = currentCombo + 1
            if currentCombo > 3 then
                currentCombo = 1
            end
        end
    endFire attack (the pellet will auto-target closest NPC)
            fireMageAttack(currentCombo)
            
            -- Track stats
            stats.totalAttacks = stats.totalAttacks + 1untime = math.floor(tick() - stats.startTime)
        print(string.format("[Mage Kill Aura] Runtime: %ds | Attacks: %d | NPCs: %d", 
            runtime, stats.totalAttacks, #getNearbyNPCs()))
    end
end)

-- Cleanup on script end
local function cleanup()
    running = false
    if auraVisual then
        auraVisual:Destroy()
    end
    print("[Mage Kill Aura] Stopped")
    print("[Mage Kill Aura] Total attacks fired:", stats.totalAttacks)
    print("[Mage Kill Aura] Targets hit:")
    for name, count in pairs(stats.targetsHit) do
        print("  -", name, ":", count, "attacks")
    end
end

-- Handle script end
game:GetService("ScriptContext").Error:Connect(cleanup)
