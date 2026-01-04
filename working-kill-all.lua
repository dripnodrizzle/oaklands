--> Working Kill All
--> Based on understanding that Attack needs positioning

print("[Kill All] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")

local EntityFolder = Workspace:FindFirstChild("EntityFolder")
if not EntityFolder then
    warn("[Kill All] EntityFolder not found!")
    return
end

local Attack = ReplicatedStorage.Events.Combat.Attack

-- Get character
local char = Player.Character
if not char or not char:FindFirstChild("HumanoidRootPart") then
    warn("[Kill All] Character not found!")
    return
end

local hrp = char.HumanoidRootPart
local originalPos = hrp.CFrame

-- Get all alive NPCs
local function GetAliveNPCs()
    local npcs = {}
    for _, npc in ipairs(EntityFolder:GetChildren()) do
        if npc:IsA("Model") then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                -- Get position
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
                        position = pos
                    })
                end
            end
        end
    end
    return npcs
end

local npcs = GetAliveNPCs()
print(string.format("[Kill All] Found %d NPCs to kill", #npcs))

if #npcs == 0 then
    print("[Kill All] No NPCs to kill!")
    return
end

-- Kill all NPCs
local killed = 0
print("[Kill All] Starting attack sequence...")

for i, npc in ipairs(npcs) do
    -- Teleport close to NPC
    local offset = Vector3.new(3, 0, 0)
    hrp.CFrame = CFrame.new(npc.position + offset, npc.position)
    
    task.wait(0.1)
    
    -- Spam attacks
    for j = 1, 30 do
        pcall(function()
            Attack:FireServer()
        end)
        task.wait(0.03)
        
        -- Check if dead
        if npc.humanoid.Health <= 0 then
            killed = killed + 1
            print(string.format("[Kill All] Killed %s (%d/%d)", npc.model.Name, killed, #npcs))
            break
        end
    end
    
    -- Progress update
    if i % 5 == 0 then
        print(string.format("[Kill All] Progress: %d/%d NPCs processed", i, #npcs))
    end
end

-- Return to original position
task.wait(0.5)
hrp.CFrame = originalPos

print("")
print(string.format("[Kill All] Complete! Killed %d/%d NPCs", killed, #npcs))

if killed < #npcs then
    print("")
    print("[Kill All] Some NPCs survived. This means:")
    print("1. You might need a weapon equipped")
    print("2. The game has additional validation")
    print("3. May need to use skills instead of basic attack")
end
