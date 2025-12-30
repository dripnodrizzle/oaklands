--> NPC Kill All - Using Discovered Remotes
--> Attack has no args, UseSkill needs skill ID and position

print("[Kill All] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local EntityFolder = Workspace:FindFirstChild("EntityFolder")
if not EntityFolder then
    warn("[Kill All] EntityFolder not found!")
    return
end

local CombatFolder = ReplicatedStorage.Events.Combat
local Attack = CombatFolder.Attack
local UseSkill = CombatFolder.UseSkill

-- Get all alive NPCs
local function GetAliveNPCs()
    local npcs = {}
    for _, npc in ipairs(EntityFolder:GetChildren()) do
        if npc:IsA("Model") then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                table.insert(npcs, {model = npc, humanoid = humanoid})
            end
        end
    end
    return npcs
end

local npcs = GetAliveNPCs()
print(string.format("[Kill All] Found %d alive NPCs", #npcs))

if #npcs == 0 then
    print("[Kill All] No NPCs to kill!")
    return
end

-- Get character for reference
local char = Player.Character
if not char or not char:FindFirstChild("HumanoidRootPart") then
    warn("[Kill All] Character not found!")
    return
end

local hrp = char.HumanoidRootPart

-- Method 1: Spam Attack near each NPC
print("[Kill All] Method 1: Spamming Attack remote near NPCs...")
for i, npc in ipairs(npcs) do
    -- Teleport near NPC
    local npcPos = npc.model:GetPivot().Position
    hrp.CFrame = CFrame.new(npcPos + Vector3.new(0, 3, 5))
    
    -- Spam attack
    for j = 1, 20 do
        pcall(function()
            Attack:FireServer()
        end)
        task.wait(0.05)
    end
    
    if i % 5 == 0 then
        print(string.format("[Kill All] Processed %d/%d NPCs", i, #npcs))
    end
end

task.wait(1)

-- Method 2: UseSkill at NPC positions
print("[Kill All] Method 2: Using UseSkill at NPC positions...")
local remainingNPCs = GetAliveNPCs()

for i, npc in ipairs(remainingNPCs) do
    local pos = npc.model:GetPivot().Position
    
    -- Try different skill IDs that might be AoE damage
    for skillId = 1, 5 do
        pcall(function()
            UseSkill:FireServer(tostring(skillId), {pos.X, pos.Y, pos.Z})
        end)
        task.wait(0.05)
    end
end

task.wait(1)

-- Check results
local finalRemaining = GetAliveNPCs()
local killed = #npcs - #finalRemaining

print("")
print(string.format("[Kill All] Results: %d killed, %d remaining", killed, #finalRemaining))
print("")

if #finalRemaining > 0 then
    print("===== ALTERNATIVE APPROACH =====")
    print("Since Attack takes no arguments, it likely:")
    print("1. Attacks what you're looking at (mouse target)")
    print("2. Attacks nearest enemy in range")
    print("3. Requires you to be near/looking at the enemy")
    print("")
    print("Manual kill approach:")
    print("1. Get close to NPCs")
    print("2. Look at them")
    print("3. Spam: ReplicatedStorage.Events.Combat.Attack:FireServer()")
    print("")
    print("Or find a skill that does AOE damage:")
    print("ReplicatedStorage.Events.Combat.UseSkill:FireServer('skillID', {x, y, z})")
    print("================================")
end

print("")
print("[Kill All] Returning you to original position...")
-- Return to approximate original position
hrp.CFrame = CFrame.new(0, 50, 0)
