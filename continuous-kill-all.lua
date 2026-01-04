--> Continuous Kill All
--> Rescans for NPCs constantly, won't miss any

print("[Continuous Kill] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local EntityFolder = Workspace:FindFirstChild("EntityFolder")
if not EntityFolder then
    warn("[Continuous Kill] EntityFolder not found!")
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
    warn("[Continuous Kill] Character not found!")
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

-- Track processed NPCs to avoid repeating
local processedNPCs = {}
local killCount = 0
local attemptCount = 0

-- Get next alive NPC that hasn't been processed
local function GetNextNPC()
    for _, npc in ipairs(EntityFolder:GetChildren()) do
        -- Skip player's character
        if npc:IsA("Model") and not processedNPCs[npc] and npc ~= char then
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
                    return {
                        model = npc,
                        humanoid = humanoid,
                        position = pos,
                        rootPart = rootPart,
                        name = npc.Name
                    }
                end
            end
        end
    end
    return nil
end

-- Count total alive NPCs
local function CountAliveNPCs()
    local count = 0
    for _, npc in ipairs(EntityFolder:GetChildren()) do
        if npc:IsA("Model") and npc ~= char then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                count = count + 1
            end
        end
    end
    return count
end

-- Aggressive kill function
local function AttackNPC(npc)
    local startHealth = npc.humanoid.Health
    local attacks = 0
    local maxAttacks = 80
    
    task.wait(0.1)
    
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
            print("  Lost track of NPC!")
            break
        end
        
        -- Move close to current position
        local closePos = currentPos + Vector3.new(0, 0, 2)
        hrp.CFrame = CFrame.new(closePos, currentPos)
        
        -- Point camera at NPC
        if npc.rootPart and npc.rootPart.Parent then
            pcall(function()
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, npc.rootPart.Position)
            end)
        end
        
        -- Spam attacks
        for i = 1, 3 do
            pcall(function() Attack:FireServer() end)
            task.wait(0.02)
        end
        
        -- Try skill every 15 attacks
        if UseSkill and attacks % 15 == 0 then
            for skillId = 1, 4 do
                pcall(function() UseSkill:FireServer(skillId) end)
            end
        end
        
        task.wait(0.05)
    end
    
    local damage = startHealth - npc.humanoid.Health
    local killed = npc.humanoid.Health <= 0
    
    return killed, damage, attacks
end

-- Main loop - keep scanning until no NPCs left
print("[Continuous Kill] Starting continuous scan...")
print("")

local totalProcessed = 0
local startTime = tick()

while true do
    local npc = GetNextNPC()
    
    if not npc then
        -- No more unprocessed NPCs, check if any alive
        local aliveCount = CountAliveNPCs()
        if aliveCount == 0 then
            print("[Continuous Kill] No more NPCs found!")
            break
        else
            -- There are alive NPCs but we processed them all
            print(string.format("[Continuous Kill] %d NPCs alive but already attempted", aliveCount))
            break
        end
    end
    
    totalProcessed = totalProcessed + 1
    attemptCount = attemptCount + 1
    
    local startHealth = npc.humanoid.Health
    print(string.format("[%d] Attacking %s (%.0f HP)...", totalProcessed, npc.name, startHealth))
    
    local killed, damage, attacks = AttackNPC(npc)
    
    -- Mark as processed regardless of outcome
    processedNPCs[npc.model] = true
    
    if killed then
        killCount = killCount + 1
        print(string.format("  ✓ KILLED %s after %d attacks", npc.name, attacks))
    elseif damage > 0 then
        print(string.format("  ~ DAMAGED %s: %.0f/%.0f HP (%.0f damage)", 
            npc.name, npc.humanoid.Health, startHealth, damage))
    else
        print(string.format("  ✗ IMMUNE %s took no damage", npc.name))
    end
    
    print("")
    task.wait(0.1)
    
    -- Safety limit
    if totalProcessed >= 100 then
        print("[Continuous Kill] Safety limit reached (100 NPCs)")
        break
    end
end

local elapsed = tick() - startTime

-- Return to original position
task.wait(0.5)
hrp.CFrame = originalPos

-- Summary
print("=" .. string.rep("=", 60))
print(string.format("[Continuous Kill] Complete in %.1f seconds", elapsed))
print(string.format("Processed: %d NPCs", totalProcessed))
print(string.format("Killed: %d NPCs", killCount))
print(string.format("Success Rate: %.1f%%", killCount / math.max(1, totalProcessed) * 100))

local remaining = CountAliveNPCs()
if remaining > 0 then
    print(string.format("Remaining: %d NPCs still alive", remaining))
end

print("=" .. string.rep("=", 60))

if killCount > 0 then
    print("Some NPCs died - remotes work but server validates strictly")
    print("For guaranteed kills, use: npc-click-killer.lua")
else
    print("No kills - server blocks all remote attacks")
    print("Must use: npc-click-killer.lua for client-side one-hit kills")
end
