--> Aggressive Kill All
--> More attacks, better positioning, camera targeting

print("[Aggressive Kill] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local EntityFolder = Workspace:FindFirstChild("EntityFolder")
if not EntityFolder then
    warn("[Aggressive Kill] EntityFolder not found!")
    return
end

-- Get combat remotes
local CombatRemotes = ReplicatedStorage.Events.Combat
local ToggleWeapon = CombatRemotes:FindFirstChild("Toggle Weapon")
local Attack = CombatRemotes:FindFirstChild("Attack")
local UseSkill = CombatRemotes:FindFirstChild("UseSkill")

-- Get character
local char = Player.Character
if not char or not char:FindFirstChild("HumanoidRootPart") then
    warn("[Aggressive Kill] Character not found!")
    return
end

local hrp = char.HumanoidRootPart
local originalPos = hrp.CFrame
local originalCam = Camera.CFrame

-- Toggle weapon on
if ToggleWeapon then
    pcall(function()
        ToggleWeapon:FireServer()
    end)
    task.wait(0.3)
end

-- Get all alive NPCs
local function GetAliveNPCs()
    local npcs = {}
    for _, npc in ipairs(EntityFolder:GetChildren()) do
        if npc:IsA("Model") then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local pos
                local rootPart = npc:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    pos = rootPart.Position
                elseif npc.PrimaryPart then
                    pos = npc.PrimaryPart.Position
                else
                    local part = npc:FindFirstChildOfClass("Part")
                    if part then pos = part.Position end
                end
                
                if pos then
                    table.insert(npcs, {
                        model = npc,
                        humanoid = humanoid,
                        position = pos,
                        rootPart = rootPart,
                        name = npc.Name
                    })
                end
            end
        end
    end
    return npcs
end

local npcs = GetAliveNPCs()
print(string.format("[Aggressive Kill] Found %d NPCs to kill", #npcs))

if #npcs == 0 then
    print("[Aggressive Kill] No NPCs to kill!")
    return
end

-- Aggressive kill function
local function KillNPC(npc)
    local startHealth = npc.humanoid.Health
    local attempts = 0
    
    -- Get very close - almost on top of NPC
    local closePos = npc.position + Vector3.new(0, 0, 2)
    hrp.CFrame = CFrame.new(closePos, npc.position)
    
    -- Point camera at NPC
    if npc.rootPart then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, npc.rootPart.Position)
    end
    
    task.wait(0.1)
    
    -- Ultra aggressive attack loop
    local maxAttempts = 100
    while npc.humanoid.Health > 0 and attempts < maxAttempts do
        attempts = attempts + 1
        
        -- Face the NPC constantly
        hrp.CFrame = CFrame.new(hrp.Position, npc.position)
        
        -- Spam attacks
        for i = 1, 5 do
            pcall(function() Attack:FireServer() end)
            task.wait(0.02)
        end
        
        -- Try skills every 10 attacks
        if UseSkill and attempts % 10 == 0 then
            for skillId = 1, 4 do
                pcall(function()
                    UseSkill:FireServer(skillId)
                end)
                task.wait(0.05)
            end
        end
        
        task.wait(0.05)
        
        -- Progress check
        if attempts % 20 == 0 then
            local damage = startHealth - npc.humanoid.Health
            if damage > 0 then
                print(string.format("  [%s] Dealt %.0f damage (%.0f/%.0f HP)", 
                    npc.name, damage, npc.humanoid.Health, startHealth))
            else
                print(string.format("  [%s] No damage yet after %d attempts", npc.name, attempts))
            end
        end
    end
    
    local totalDamage = startHealth - npc.humanoid.Health
    return npc.humanoid.Health <= 0, totalDamage, attempts
end

-- Kill all NPCs
local killed = 0
local damaged = 0
local immune = 0

print("[Aggressive Kill] Starting attack sequence...")
print("")

for i, npc in ipairs(npcs) do
    local startHealth = npc.humanoid.Health
    print(string.format("[%d/%d] Attacking %s (%.0f HP)...", i, #npcs, npc.name, startHealth))
    
    local success, totalDamage, attempts = KillNPC(npc)
    
    if success then
        killed = killed + 1
        print(string.format("  SUCCESS - %s DEAD after %d attacks", npc.name, attempts))
    elseif totalDamage > 0 then
        damaged = damaged + 1
        print(string.format("  PARTIAL - %s survived with %.0f/%.0f HP (%.0f damage dealt)", 
            npc.name, npc.humanoid.Health, startHealth, totalDamage))
    else
        immune = immune + 1
        print(string.format("  IMMUNE - %s took NO damage", npc.name))
    end
    
    print("")
    task.wait(0.1)
end

-- Return to original position
task.wait(0.5)
hrp.CFrame = originalPos
Camera.CFrame = originalCam

-- Summary
print("=" .. string.rep("=", 60))
print(string.format("[Aggressive Kill] Results: %d killed, %d damaged, %d immune (out of %d)", 
    killed, damaged, immune, #npcs))
print("=" .. string.rep("=", 60))

if killed == #npcs then
    print("SUCCESS - All NPCs eliminated!")
elseif killed > 0 then
    print("PARTIAL SUCCESS - Some NPCs killed, others resisted")
    print("Recommendation: Use the client-side one-hit-kill script instead")
else
    print("FAILED - No NPCs killed")
    print("The server validates attacks too strictly for remote spam to work")
    print("Use: npc-click-killer.lua for client-side one-hit kills")
end
