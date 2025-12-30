--> Enhanced Kill All
--> Uses multiple combat remotes for better success rate

print("[Enhanced Kill] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")

local EntityFolder = Workspace:FindFirstChild("EntityFolder")
if not EntityFolder then
    warn("[Enhanced Kill] EntityFolder not found!")
    return
end

-- Get all combat remotes
local CombatRemotes = ReplicatedStorage.Events.Combat
local ToggleWeapon = CombatRemotes:FindFirstChild("Toggle Weapon")
local Attack = CombatRemotes:FindFirstChild("Attack")
local UseSkill = CombatRemotes:FindFirstChild("UseSkill")
local Hitted = CombatRemotes:FindFirstChild("Hitted")
local WeaponHitted = CombatRemotes:FindFirstChild("WeaponHitted")

print("[Enhanced Kill] Available remotes:")
if ToggleWeapon then print("- Toggle Weapon") end
if Attack then print("- Attack") end
if UseSkill then print("- UseSkill") end
if Hitted then print("- Hitted") end
if WeaponHitted then print("- WeaponHitted") end

-- Get character
local char = Player.Character
if not char or not char:FindFirstChild("HumanoidRootPart") then
    warn("[Enhanced Kill] Character not found!")
    return
end

local hrp = char.HumanoidRootPart
local originalPos = hrp.CFrame

-- Make sure weapon is toggled on
if ToggleWeapon then
    pcall(function()
        ToggleWeapon:FireServer()
        print("[Enhanced Kill] Toggled weapon ON")
    end)
    task.wait(0.2)
end

-- Get all alive NPCs
local function GetAliveNPCs()
    local npcs = {}
    for _, npc in ipairs(EntityFolder:GetChildren()) do
        if npc:IsA("Model") then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local pos
                if npc:FindFirstChild("HumanoidRootPart") then
                    pos = npc.HumanoidRootPart.Position
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
                        name = npc.Name
                    })
                end
            end
        end
    end
    return npcs
end

local npcs = GetAliveNPCs()
print(string.format("[Enhanced Kill] Found %d NPCs to kill", #npcs))

if #npcs == 0 then
    print("[Enhanced Kill] No NPCs to kill!")
    return
end

-- Kill function using multiple methods
local function KillNPC(npc)
    local startHealth = npc.humanoid.Health
    
    -- Method 1: Spam Attack
    for i = 1, 20 do
        if npc.humanoid.Health <= 0 then break end
        pcall(function() Attack:FireServer() end)
        task.wait(0.03)
    end
    
    if npc.humanoid.Health <= 0 then return true end
    
    -- Method 2: Try UseSkill with different patterns
    if UseSkill then
        local skills = {1, 2, 3, 4} -- Common skill IDs
        for _, skillId in ipairs(skills) do
            if npc.humanoid.Health <= 0 then break end
            
            pcall(function()
                UseSkill:FireServer(skillId)
            end)
            pcall(function()
                UseSkill:FireServer(skillId, npc.position)
            end)
            pcall(function()
                UseSkill:FireServer({Skill = skillId, Position = npc.position})
            end)
            
            task.wait(0.1)
        end
    end
    
    if npc.humanoid.Health <= 0 then return true end
    
    -- Method 3: Try firing damage remotes directly
    if Hitted then
        pcall(function()
            Hitted:FireServer(npc.model, 999999)
        end)
        pcall(function()
            Hitted:FireServer({Target = npc.model, Damage = 999999})
        end)
    end
    
    if WeaponHitted then
        pcall(function()
            WeaponHitted:FireServer(npc.model, 999999)
        end)
        pcall(function()
            WeaponHitted:FireServer({Target = npc.model, Damage = 999999})
        end)
    end
    
    task.wait(0.1)
    
    return npc.humanoid.Health <= 0
end

-- Kill all NPCs
local killed = 0
local failed = {}

print("[Enhanced Kill] Starting attack sequence...")
print("")

for i, npc in ipairs(npcs) do
    -- Teleport close to NPC
    local offset = Vector3.new(3, 0, 0)
    hrp.CFrame = CFrame.new(npc.position + offset, npc.position)
    
    task.wait(0.1)
    
    -- Try to kill
    local success = KillNPC(npc)
    
    if success then
        killed = killed + 1
        print(string.format("[Kill %d/%d] %s DEAD", killed, #npcs, npc.name))
    else
        table.insert(failed, npc.name)
        print(string.format("[Failed %d/%d] %s survived (%.0f HP)", i, #npcs, npc.name, npc.humanoid.Health))
    end
    
    task.wait(0.05)
end

-- Return to original position
task.wait(0.5)
hrp.CFrame = originalPos

-- Summary
print("")
print("=" .. string.rep("=", 50))
print(string.format("[Enhanced Kill] Complete! Killed %d/%d NPCs", killed, #npcs))

if #failed > 0 then
    print("")
    print(string.format("Failed to kill %d NPCs:", #failed))
    for _, name in ipairs(failed) do
        print("  - " .. name)
    end
    print("")
    print("This means the game has server-side validation that:")
    print("1. Requires proper weapon/tool equipped")
    print("2. Checks animation states or attack cooldowns")
    print("3. Validates player stats/levels")
    print("4. Or blocks programmatic remote calls")
else
    print("[Enhanced Kill] All NPCs eliminated!")
end
print("=" .. string.rep("=", 50))
