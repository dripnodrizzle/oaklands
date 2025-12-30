--> Targeted NPC Server Kill
--> Uses the found combat remotes with proper arguments

print("[Targeted Kill] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local EntityFolder = Workspace:FindFirstChild("EntityFolder")
if not EntityFolder then
    warn("[Targeted Kill] EntityFolder not found!")
    return
end

-- Get the combat remotes
local CombatFolder = ReplicatedStorage:FindFirstChild("Events")
if CombatFolder then
    CombatFolder = CombatFolder:FindFirstChild("Combat")
end

if not CombatFolder then
    warn("[Targeted Kill] Combat folder not found!")
    return
end

local Attack = CombatFolder:FindFirstChild("Attack")
local Hitted = CombatFolder:FindFirstChild("Hitted")
local WeaponHitted = CombatFolder:FindFirstChild("WeaponHitted")
local UseSkill = CombatFolder:FindFirstChild("UseSkill")

print("[Targeted Kill] Found remotes:")
print("  Attack:", Attack and "✓" or "✗")
print("  Hitted:", Hitted and "✓" or "✗")
print("  WeaponHitted:", WeaponHitted and "✓" or "✗")
print("  UseSkill:", UseSkill and "✓" or "✗")
print("")

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

-- Get player's equipped tool/weapon
local function GetEquippedWeapon()
    local char = Player.Character
    if not char then return nil end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then return tool end
    
    -- Check backpack
    local backpack = Player:FindFirstChild("Backpack")
    if backpack then
        tool = backpack:FindFirstChildOfClass("Tool")
        if tool then return tool end
    end
    
    return nil
end

local npcs = GetAliveNPCs()
print(string.format("[Targeted Kill] Found %d alive NPCs", #npcs))
print("")

if #npcs == 0 then
    print("[Targeted Kill] No NPCs to kill!")
    return
end

-- Try Attack remote (most promising)
if Attack then
    print("[Targeted Kill] Trying Attack remote...")
    for _, npc in ipairs(npcs) do
        pcall(function()
            -- Try different patterns
            Attack:FireServer(npc.model)
            Attack:FireServer(npc.humanoid)
            Attack:FireServer({Target = npc.model})
            Attack:FireServer({Target = npc.humanoid})
            Attack:FireServer({Enemy = npc.model})
            Attack:FireServer(npc.model, 999999)
        end)
        task.wait(0.01)
    end
end

task.wait(0.5)

-- Try Hitted remote
if Hitted then
    print("[Targeted Kill] Trying Hitted remote...")
    for _, npc in ipairs(npcs) do
        pcall(function()
            Hitted:FireServer(npc.model)
            Hitted:FireServer(npc.humanoid)
            Hitted:FireServer(npc.model, 999999)
            Hitted:FireServer({Hit = npc.model, Damage = 999999})
        end)
        task.wait(0.01)
    end
end

task.wait(0.5)

-- Try WeaponHitted remote
if WeaponHitted then
    print("[Targeted Kill] Trying WeaponHitted remote...")
    local weapon = GetEquippedWeapon()
    
    for _, npc in ipairs(npcs) do
        pcall(function()
            WeaponHitted:FireServer(npc.model)
            WeaponHitted:FireServer(npc.humanoid)
            if weapon then
                WeaponHitted:FireServer(weapon, npc.model)
                WeaponHitted:FireServer(weapon, npc.humanoid)
                WeaponHitted:FireServer({Weapon = weapon, Target = npc.model})
            end
        end)
        task.wait(0.01)
    end
end

print("")
print("[Targeted Kill] Attack attempts complete!")
print("[Targeted Kill] Check if NPCs died.")
print("")

-- Count remaining
task.wait(1)
local remaining = #GetAliveNPCs()
local killed = #npcs - remaining

print(string.format("[Targeted Kill] Results: %d killed, %d remaining", killed, remaining))
print("")

if remaining > 0 then
    print("===== MANUAL DEBUGGING =====")
    print("The auto-kill didn't work. Try manually:")
    print("")
    print("1. Equip a weapon")
    print("2. Attack an NPC normally")
    print("3. Use the inspector to see which remote fires")
    print("4. Note the arguments it sends")
    print("")
    print("Then manually kill all NPCs:")
    print("for _, npc in ipairs(workspace.EntityFolder:GetChildren()) do")
    print("  ReplicatedStorage.Events.Combat.RemoteName:FireServer(npc, args)")
    print("end")
    print("============================")
end
