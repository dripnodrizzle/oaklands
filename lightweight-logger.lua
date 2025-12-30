--> Lightweight Remote Logger
--> Logs combat remotes WITHOUT breaking the game

print("[Logger] Starting lightweight remote logger...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local CombatFolder = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Combat")

-- Get combat remotes
local Attack = CombatFolder:FindFirstChild("Attack")
local Hitted = CombatFolder:FindFirstChild("Hitted")
local WeaponHitted = CombatFolder:FindFirstChild("WeaponHitted")
local UseSkill = CombatFolder:FindFirstChild("UseSkill")
local DamagePopup = CombatFolder:FindFirstChild("DamagePopup")

print("[Logger] Found remotes:")
print("  Attack:", Attack and "✓" or "✗")
print("  Hitted:", Hitted and "✓" or "✗")
print("  WeaponHitted:", WeaponHitted and "✓" or "✗")
print("  UseSkill:", UseSkill and "✓" or "✗")
print("  DamagePopup:", DamagePopup and "✓" or "✗")

-- Monitor NPC health to see when damage occurs
local function MonitorNPCs()
    local EntityFolder = Workspace:FindFirstChild("EntityFolder")
    if not EntityFolder then 
        warn("[Logger] EntityFolder not found!")
        return 
    end
    
    print(string.format("[Logger] Monitoring %d NPCs", #EntityFolder:GetChildren()))
    
    for _, npc in ipairs(EntityFolder:GetChildren()) do
        if npc:IsA("Model") then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local lastHealth = humanoid.Health
                
                humanoid.HealthChanged:Connect(function(health)
                    if health < lastHealth then
                        local damage = lastHealth - health
                        print(string.format("\n[NPC DAMAGED] %s took %.1f damage! (%.1f/%.1f HP)", 
                            npc.Name, damage, health, humanoid.MaxHealth))
                    end
                    if health <= 0 then
                        print(string.format("[NPC KILLED] %s died!", npc.Name))
                    end
                    lastHealth = health
                end)
            end
        end
    end
    
    -- Monitor new NPCs
    EntityFolder.ChildAdded:Connect(function(npc)
        task.wait(0.5)
        if npc:IsA("Model") then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            if humanoid then
                print(string.format("[Logger] Now monitoring new NPC: %s", npc.Name))
                local lastHealth = humanoid.Health
                
                humanoid.HealthChanged:Connect(function(health)
                    if health < lastHealth then
                        local damage = lastHealth - health
                        print(string.format("\n[NPC DAMAGED] %s took %.1f damage! (%.1f/%.1f HP)", 
                            npc.Name, damage, health, humanoid.MaxHealth))
                    end
                    if health <= 0 then
                        print(string.format("[NPC KILLED] %s died!", npc.Name))
                    end
                    lastHealth = health
                end)
            end
        end
    end)
end

MonitorNPCs()

-- Manual testing functions
_G.TestAttack = function()
    print("\n[Test] Calling Attack:FireServer()")
    Attack:FireServer()
end

_G.TestHitted = function(npc)
    if not npc then
        print("[Test] Usage: _G.TestHitted(workspace.EntityFolder.NPCName)")
        return
    end
    print(string.format("\n[Test] Calling Hitted:FireServer(%s)", npc.Name))
    Hitted:FireServer(npc)
end

_G.TestWeaponHitted = function(npc)
    if not npc then
        print("[Test] Usage: _G.TestWeaponHitted(workspace.EntityFolder.NPCName)")
        return
    end
    print(string.format("\n[Test] Calling WeaponHitted:FireServer(%s)", npc.Name))
    WeaponHitted:FireServer(npc)
end

_G.TestKillAll = function()
    print("\n[Test] Attempting to kill all NPCs...")
    local EntityFolder = Workspace:FindFirstChild("EntityFolder")
    if not EntityFolder then return end
    
    for _, npc in ipairs(EntityFolder:GetChildren()) do
        if npc:IsA("Model") then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                -- Try various patterns
                pcall(function() Attack:FireServer() end)
                pcall(function() Attack:FireServer(npc) end)
                pcall(function() Attack:FireServer(humanoid) end)
                pcall(function() Hitted:FireServer(npc) end)
                pcall(function() Hitted:FireServer(humanoid) end)
                pcall(function() WeaponHitted:FireServer(npc) end)
                task.wait(0.05)
            end
        end
    end
    
    print("[Test] Attack attempts complete. Check if NPCs took damage.")
end

print("")
print("========== LOGGER READY ==========")
print("The logger is now monitoring NPC health.")
print("Attack NPCs and watch for damage messages!")
print("")
print("Manual test commands:")
print("  _G.TestAttack() - Test Attack remote")
print("  _G.TestHitted(npc) - Test Hitted remote")
print("  _G.TestKillAll() - Try to kill all NPCs")
print("==================================")
print("")
