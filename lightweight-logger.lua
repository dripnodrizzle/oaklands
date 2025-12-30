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

local callLog = {}

-- Helper to serialize values safely
local function SafeSerialize(value)
    local t = typeof(value)
    if t == "Instance" then
        return string.format("%s (%s)", value.Name, value.ClassName)
    elseif t == "Vector3" then
        return string.format("Vector3(%.1f, %.1f, %.1f)", value.X, value.Y, value.Z)
    elseif t == "table" then
        local str = "{"
        local count = 0
        for k, v in pairs(value) do
            if count > 0 then str = str .. ", " end
            str = str .. tostring(k) .. "=" .. tostring(v)
            count = count + 1
            if count >= 5 then str = str .. ", ..."; break end
        end
        return str .. "}"
    else
        return tostring(value)
    end
end

-- Simple wrapper function
local function WrapRemote(remote, name)
    if not remote then return end
    
    local originalFire = remote.FireServer
    
    remote.FireServer = function(self, ...)
        local args = {...}
        
        -- Log it
        local logEntry = {
            remote = name,
            args = args,
            time = tick()
        }
        table.insert(callLog, logEntry)
        
        -- Print it
        print(string.format("\n[%s] Called!", name))
        for i, arg in ipairs(args) do
            print(string.format("  Arg %d: %s", i, SafeSerialize(arg)))
        end
        
        -- Call original
        return originalFire(self, ...)
    end
    
    print(string.format("[Logger] Wrapped: %s", name))
end

-- Wrap the combat remotes
WrapRemote(Attack, "Attack")
WrapRemote(Hitted, "Hitted")
WrapRemote(WeaponHitted, "WeaponHitted")
WrapRemote(UseSkill, "UseSkill")
WrapRemote(DamagePopup, "DamagePopup")

-- Monitor NPC health
local function MonitorNPCs()
    local EntityFolder = Workspace:FindFirstChild("EntityFolder")
    if not EntityFolder then return end
    
    for _, npc in ipairs(EntityFolder:GetChildren()) do
        if npc:IsA("Model") then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.HealthChanged:Connect(function(health)
                    if health < humanoid.MaxHealth then
                        print(string.format("[NPC] %s damaged! Health: %.1f", npc.Name, health))
                    end
                    if health <= 0 then
                        print(string.format("[NPC] %s DIED!", npc.Name))
                    end
                end)
            end
        end
    end
end

MonitorNPCs()

_G.ShowCallLog = function()
    print("\n===== CALL LOG =====")
    for i = math.max(1, #callLog - 20), #callLog do
        local log = callLog[i]
        print(string.format("\n%d. %s:", i, log.remote))
        for j, arg in ipairs(log.args) do
            print(string.format("   [%d] %s", j, SafeSerialize(arg)))
        end
    end
    print("\n====================")
end

print("")
print("[Logger] Ready! Attack NPCs and watch the output.")
print("[Logger] Run _G.ShowCallLog() to see all logged calls.")
print("")
