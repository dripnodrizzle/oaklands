--> Safe NPC Monitor
--> Just monitors NPC health - no remote calls

print("[Monitor] Starting safe NPC monitor...")

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Find EntityFolder
local EntityFolder = Workspace:FindFirstChild("EntityFolder")
if not EntityFolder then
    warn("[Monitor] EntityFolder not found!")
    return
end

-- Find Combat folder
local Events = ReplicatedStorage:FindFirstChild("Events")
local CombatFolder = Events and Events:FindFirstChild("Combat")

print("[Monitor] Combat remotes available:")
if CombatFolder then
    for _, remote in ipairs(CombatFolder:GetChildren()) do
        print(string.format("  - %s (%s)", remote.Name, remote.ClassName))
    end
else
    warn("[Monitor] Combat folder not found!")
end

-- Monitor NPCs
local monitoredCount = 0

for _, npc in ipairs(EntityFolder:GetChildren()) do
    if npc:IsA("Model") then
        local humanoid = npc:FindFirstChildOfClass("Humanoid")
        if humanoid then
            monitoredCount = monitoredCount + 1
            local lastHealth = humanoid.Health
            
            humanoid.HealthChanged:Connect(function(health)
                if health < lastHealth then
                    local damage = lastHealth - health
                    print(string.format("\n[DAMAGE] %s took %.1f damage! (%.1f/%.1f)", 
                        npc.Name, damage, health, humanoid.MaxHealth))
                end
                if health <= 0 then
                    print(string.format("[DEATH] %s died!", npc.Name))
                end
                lastHealth = health
            end)
        end
    end
end

print(string.format("\n[Monitor] Monitoring %d NPCs", monitoredCount))
print("[Monitor] Attack NPCs normally and watch the console!")
print("")
print("Once you attack and see damage, share the output with me.")
print("We'll figure out the pattern from YOUR attacks, not test calls.")
