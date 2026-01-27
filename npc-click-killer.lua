--> NPC One-Hit Kill
--> Any NPC in Workspace.EntityFolder dies instantly when taking any damage

print("[NPC One-Hit Kill] Starting...")

local Workspace = game:GetService("Workspace")
local EntityFolder = Workspace:WaitForChild("EntityFolder", 10)

if not EntityFolder then
    warn("[NPC One-Hit Kill] EntityFolder not found in Workspace!")
    return
end

local function SetupNPC(npc)
    if not npc:IsA("Model") then return end
    
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Track last health to detect damage
    local lastHealth = humanoid.Health
    local isDying = false
    
    -- Listen for health changes
    humanoid.HealthChanged:Connect(function(newHealth)
        if isDying then return end
        
        -- If health decreased (took damage), kill instantly
        if newHealth < lastHealth and newHealth > 0 then
            isDying = true
            print(string.format("[NPC One-Hit Kill] %s took damage - killing instantly", npc.Name))
            humanoid.Health = 0
        end
        
        lastHealth = newHealth
    end)
    
    print(string.format("[NPC One-Hit Kill] Monitoring %s for damage", npc.Name))
end

-- Setup existing NPCs
for _, npc in ipairs(EntityFolder:GetChildren()) do
    SetupNPC(npc)
end

-- Setup new NPCs that spawn
EntityFolder.ChildAdded:Connect(function(npc)
    task.wait(0.5) -- Wait for NPC to fully load
    SetupNPC(npc)
end)

print("[NPC One-Hit Kill] Ready! Any damage to NPCs will kill them instantly.")
print("[NPC One-Hit Kill] Monitoring " .. #EntityFolder:GetChildren() .. " NPCs")
