--> Maximum Kill All
--> Multiple passes, higher attacks, 100% kill rate goal

print("[Maximum Kill] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local EntityFolder = Workspace:FindFirstChild("EntityFolder")
if not EntityFolder then
    warn("[Maximum Kill] EntityFolder not found!")
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
    warn("[Maximum Kill] Character not found!")
    return
end

local hrp = char.HumanoidRootPart
local originalPos = hrp.CFrame

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
        if npc:IsA("Model") and npc ~= char then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local rootPart = npc:FindFirstChild("HumanoidRootPart")
                local pos
                
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
                        name = npc.Name,
                        health = humanoid.Health
                    })
                end
            end
        end
    end
    return npcs
end

-- Ultra aggressive kill function
local function AttackNPC(npc, maxAttacks)
    local startHealth = npc.humanoid.Health
    local attacks = 0
    local lastDamageTime = tick()
    
    task.wait(0.05)
    
    -- Attack loop
    while npc.humanoid.Health > 0 and attacks < maxAttacks do
        attacks = attacks + 1
        
        -- Update NPC position (in case it moved)
        local currentPos
        if npc.rootPart and npc.rootPart.Parent then
            currentPos = npc.rootPart.Position
        elseif npc.model.PrimaryPart then
            currentPos = npc.model.PrimaryPart.Position
        else
            local part = npc.model:FindFirstChildOfClass("Part")
            if part then currentPos = part.Position end
        end
        
        if not currentPos then
            break
        end
        
        -- Move close and face NPC (less aggressive)
        local closePos = currentPos + Vector3.new(0, 0, 2)
        pcall(function()
            hrp.CFrame = CFrame.new(closePos, currentPos)
        end)
        
        -- Point camera (only occasionally to reduce load)
        if attacks % 5 == 0 and npc.rootPart and npc.rootPart.Parent then
            pcall(function()
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, npc.rootPart.Position)
            end)
        end
        
        -- Spam attacks (reduced to prevent crash)
        for i = 1, 2 do
            pcall(function() Attack:FireServer() end)
            task.wait(0.02)
        end
        
        -- Check if we dealt damage recently
        if npc.humanoid.Health < startHealth then
            lastDamageTime = tick()
        end
        
        -- If no damage in 2 seconds, try skills
        if tick() - lastDamageTime > 2 and UseSkill then
            for skillId = 1, 4 do
                pcall(function() UseSkill:FireServer(skillId) end)
                task.wait(0.03)
            end
            lastDamageTime = tick()
        end
        
        task.wait(0.05)
    end
    
    local damage = startHealth - npc.humanoid.Health
    local killed = npc.humanoid.Health <= 0
    
    return killed, damage, attacks
end

-- Main kill loop with multiple passes
local totalKilled = 0
local totalProcessed = 0
local passNumber = 1
local maxPasses = 5

print("[Maximum Kill] Starting multi-pass attack...")
print("")

local startTime = tick()

while passNumber <= maxPasses do
    local npcs = GetAliveNPCs()
    
    if #npcs == 0 then
        print(string.format("[Pass %d] No NPCs remaining!", passNumber))
        break
    end
    
    print(string.format("[Pass %d] Found %d alive NPCs", passNumber, #npcs))
    
    -- Sort by health (lowest first for quick kills)
    table.sort(npcs, function(a, b) return a.health < b.health end)
    
    local passKills = 0
    
    for i, npc in ipairs(npcs) do
        totalProcessed = totalProcessed + 1
        local startHealth = npc.humanoid.Health
        
        -- More attacks in later passes
        local maxAttacks = 100 + (passNumber * 50)
        
        print(string.format("  [%d/%d] Attacking %s (%.0f HP)...", 
            i, #npcs, npc.name, startHealth))
        
        local killed, damage, attacks = AttackNPC(npc, maxAttacks)
        
        if killed then
            totalKilled = totalKilled + 1
            passKills = passKills + 1
            print(string.format("    KILLED after %d attacks", attacks))
        elseif damage > 0 then
            print(string.format("    DAMAGED %.0f/%.0f HP remaining (%.0f dealt)", 
                npc.humanoid.Health, startHealth, damage))
        else
            print(string.format("    IMMUNE - no damage"))
        end
        
        -- Longer delay between NPCs to prevent crash
        task.wait(0.2)
    end
    
    print("")
    print(string.format("[Pass %d] Complete: %d kills", passNumber, passKills))
    print("")
    
    -- Longer break between passes to let game recover
    task.wait(1.5)
    
    -- If we killed at least one, try again
    if passKills == 0 and passNumber > 1 then
        print("[Maximum Kill] No kills this pass, stopping")
        break
    end
    
    passNumber = passNumber + 1
    task.wait(0.5)
end

local elapsed = tick() - startTime

-- Return to original position
task.wait(0.5)
hrp.CFrame = originalPos

-- Final scan
local remaining = #GetAliveNPCs()

-- Summary
print("=" .. string.rep("=", 60))
print(string.format("[Maximum Kill] Complete in %.1f seconds", elapsed))
print(string.format("Total Passes: %d", passNumber - 1))
print(string.format("Total Killed: %d", totalKilled))
print(string.format("Remaining Alive: %d", remaining))

if remaining == 0 then
    print("")
    print("SUCCESS - 100% KILL RATE ACHIEVED!")
    print("All NPCs eliminated!")
else
    local killRate = totalKilled / (totalKilled + remaining) * 100
    print(string.format("Kill Rate: %.1f%%", killRate))
    print("")
    print("Remaining NPCs are likely:")
    print("- Other players (immune)")
    print("- High-level bosses with damage cap")
    print("- Quest NPCs with protection")
    print("")
    print("For these, use: npc-click-killer.lua")
end

print("=" .. string.rep("=", 60))
