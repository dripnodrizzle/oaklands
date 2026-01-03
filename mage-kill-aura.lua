--> Mage Kill Aura
--> Automatically fires Mage M1 attacks at nearby NPCs

print("[Mage Kill Aura] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera

-- Try to find NPC folders (common names in different games)
local npcFolders = {}
local possibleFolderNames = {"EntityFolder", "Enemies", "NPCs", "Monsters", "Mobs", "Characters", "Entities"}

for _, folderName in ipairs(possibleFolderNames) do
    local folder = Workspace:FindFirstChild(folderName)
    if folder then
        table.insert(npcFolders, folder)
        print("[Mage Kill Aura] Found NPC folder:", folderName)
    end
end

if #npcFolders == 0 then
    print("[Mage Kill Aura] No common NPC folders found, will scan entire Workspace")
end

-- Settings
local AURA_RADIUS = 50 -- studs
local ATTACK_INTERVAL = 0.1 -- seconds between attacks
local SHOW_VISUALS = true -- show aura circle
local BASE_DAMAGE = 123.06153343870662

-- Get Mage remotes
local MageFolder = ReplicatedStorage:WaitForChild("Mage")
local M1Remote = MageFolder:WaitForChild("M1")
local M1EventRemote = MageFolder:WaitForChild("M1Event")

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

-- Function to get nearby NPCs
local function getNearbyNPCs()
    local nearbyNPCs = {}
    
    -- First, try searching in known NPC folders
    if #npcFolders > 0 then
        for _, folder in ipairs(npcFolders) do
            for _, entity in pairs(folder:GetChildren()) do
                if entity:IsA("Model") then
                    local npcHRP = entity:FindFirstChild("HumanoidRootPart")
                    local humanoid = entity:FindFirstChildOfClass("Humanoid")
                    
                    if npcHRP and humanoid and humanoid.Health > 0 then
                        local distance = (hrp.Position - npcHRP.Position).Magnitude
                        
                        if distance <= AURA_RADIUS then
                            table.insert(nearbyNPCs, entity)
                        end
                    end
                end
            end
        end
    else
        -- Fallback: scan entire Workspace for NPCs
        for _, entity in pairs(Workspace:GetChildren()) do
            if entity:IsA("Model") and isNPC(entity) then
                local npcHRP = entity:FindFirstChild("HumanoidRootPart")
                local humanoid = entity:FindFirstChildOfClass("Humanoid")
                
                if npcHRP and humanoid and humanoid.Health > 0 then
                    local distance = (hrp.Position - npcHRP.Position).Magnitude
                    
                    if distance <= AURA_RADIUS then
                        table.insert(nearbyNPCs, entity)
                    end
                end
            end
        end
    end
    
    return nearbyNPCs
end

-- Function to fire Mage M1 combo
local function fireMageAttack(targetNPC, combo)
    pcall(function()
        -- Fire M1
        local args1 = {
            {
                Player = targetNPC,
                Cam = Camera.CFrame,
                Combo = combo,
                Character = char,
                Damage = BASE_DAMAGE
            }
        }
        M1Remote:FireServer(unpack(args1))
        
        -- Fire M1Event
        local args2 = {
            {
                Character = char,
                Combo = combo,
                Target = {},
                Player = targetNPC,
                Damage = BASE_DAMAGE
            }
        }
        M1EventRemote:FireServer(unpack(args2))
    end)
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
    end
end)

-- Stats display loop
task.spawn(function()
    while running do
        task.wait(5) -- Update stats every 5 seconds
        local runtime = math.floor(tick() - stats.startTime)
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
