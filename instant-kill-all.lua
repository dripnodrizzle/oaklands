--> Instant Kill All
--> Attempts to set NPC health to 0 via various methods

print("[Instant Kill] Attempting instant kill...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local EntityFolder = Workspace:FindFirstChild("EntityFolder")
if not EntityFolder then
    warn("[Instant Kill] EntityFolder not found!")
    return
end

local char = Player.Character
if not char then
    warn("[Instant Kill] Character not found!")
    return
end

-- Get combat remotes
local CombatRemotes = ReplicatedStorage.Events.Combat
local Hitted = CombatRemotes:FindFirstChild("Hitted")
local WeaponHitted = CombatRemotes:FindFirstChild("WeaponHitted")
local DamagePopup = CombatRemotes:FindFirstChild("DamagePopup")

print("[Instant Kill] Found remotes:")
if Hitted then print("- Hitted") end
if WeaponHitted then print("- WeaponHitted") end
if DamagePopup then print("- DamagePopup") end
print("")

-- Get all NPCs
local npcs = {}
for _, npc in ipairs(EntityFolder:GetChildren()) do
    if npc:IsA("Model") and npc ~= char then
        local humanoid = npc:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            table.insert(npcs, {model = npc, humanoid = humanoid})
        end
    end
end

print(string.format("[Instant Kill] Found %d NPCs", #npcs))

local attempts = 0
local killed = 0

-- Try different damage remote patterns
for i, npc in ipairs(npcs) do
    local startHealth = npc.humanoid.Health
    
    -- Method 1: Direct humanoid (client-side only)
    pcall(function()
        npc.humanoid.Health = 0
    end)
    
    if npc.humanoid.Health <= 0 then
        killed = killed + 1
        print(string.format("[%d/%d] %s - CLIENT KILLED", i, #npcs, npc.model.Name))
        continue
    end
    
    -- Method 2: Fire damage remotes with massive damage
    if Hitted then
        attempts = attempts + 1
        pcall(function() Hitted:FireServer(npc.model, 999999999) end)
        pcall(function() Hitted:FireServer(npc.humanoid, 999999999) end)
        pcall(function() Hitted:FireServer({Target = npc.model, Damage = 999999999}) end)
        pcall(function() Hitted:FireServer({Target = npc.humanoid, Damage = 999999999}) end)
        pcall(function() Hitted:FireServer(npc.model.Name, 999999999) end)
    end
    
    if WeaponHitted then
        attempts = attempts + 1
        pcall(function() WeaponHitted:FireServer(npc.model, 999999999) end)
        pcall(function() WeaponHitted:FireServer(npc.humanoid, 999999999) end)
        pcall(function() WeaponHitted:FireServer({Target = npc.model, Damage = 999999999}) end)
        pcall(function() WeaponHitted:FireServer({Target = npc.humanoid, Damage = 999999999}) end)
    end
    
    task.wait(0.05)
    
    if npc.humanoid.Health <= 0 then
        killed = killed + 1
        print(string.format("[%d/%d] %s - SERVER KILLED", i, #npcs, npc.model.Name))
    elseif npc.humanoid.Health < startHealth then
        print(string.format("[%d/%d] %s - DAMAGED (%.0f HP)", i, #npcs, npc.model.Name, npc.humanoid.Health))
    else
        print(string.format("[%d/%d] %s - NO EFFECT", i, #npcs, npc.model.Name))
    end
end

print("")
print("=" .. string.rep("=", 60))
print(string.format("[Instant Kill] Results: %d/%d killed", killed, #npcs))
print("=" .. string.rep("=", 60))

if killed == 0 then
    print("")
    print("Instant kill via remotes FAILED - server validates all damage")
    print("The game requires proper attack sequences, not instant kills")
    print("")
    print("Your options:")
    print("1. Use: continuous-kill-all.lua (60% kill rate, takes time)")
    print("2. Use: npc-click-killer.lua (client-side one-hit kill)")
    print("3. Use: Kill Aura (see kill-aura.lua)")
elseif killed < #npcs then
    print("")
    print("Some NPCs immune to instant kill - use other scripts for them")
else
    print("")
    print("SUCCESS - All NPCs instantly killed!")
end
