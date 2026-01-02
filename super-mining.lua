--> Super Mining - Rapid fire mining attacks
--> Spams Combat.Attack as fast as combat does
--> No arguments needed - just aim at rock and spam!

print("[Super Mining] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Get Combat.Attack remote
local Events = ReplicatedStorage:FindFirstChild("Events")
if not Events then
    warn("[Super Mining] Events folder not found!")
    return
end

local CombatFolder = Events:FindFirstChild("Combat")
if not CombatFolder then
    warn("[Super Mining] Combat folder not found!")
    return
end

local AttackRemote = CombatFolder:FindFirstChild("Attack")
if not AttackRemote then
    warn("[Super Mining] Attack remote not found!")
    return
end

-- Configuration
local Config = {
    Enabled = false,
    AttacksPerTick = 50,  -- Attacks to send per tick
    TickRate = 0.01,      -- Seconds between bursts (very fast)
    HoldToMine = true,    -- Hold key to mine, or toggle
    MiningKey = Enum.KeyCode.E,  -- Key to activate super mining
}

local miningActive = false
local attackCount = 0
local connection

-- Mining loop
local function startMining()
    if connection then return end
    
    print("[Super Mining] ⛏️ SUPER MINING ACTIVE!")
    
    connection = RunService.Heartbeat:Connect(function()
        if not miningActive then return end
        
        -- Rapid fire attacks
        for i = 1, Config.AttacksPerTick do
            AttackRemote:FireServer()
            attackCount = attackCount + 1
        end
    end)
end

local function stopMining()
    if connection then
        connection:Disconnect()
        connection = nil
        print("[Super Mining] ⛏️ Mining stopped. Total attacks: " .. attackCount)
    end
end

-- Key handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Config.MiningKey then
        if Config.HoldToMine then
            miningActive = true
            if not connection then
                startMining()
            end
        else
            -- Toggle mode
            miningActive = not miningActive
            if miningActive then
                startMining()
                print("[Super Mining] 🟢 ENABLED - Mining at " .. Config.AttacksPerTick .. " attacks/tick")
            else
                print("[Super Mining] 🔴 DISABLED")
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if Config.HoldToMine and input.KeyCode == Config.MiningKey then
        miningActive = false
    end
end)

-- Start mining connection
startMining()

print("[Super Mining] ✓ Loaded!")
print("=== SUPER MINING ===")
print("Hold '" .. Config.MiningKey.Name .. "' key to SUPER MINE")
print("Speed: " .. Config.AttacksPerTick .. " attacks per tick")
print("")
print("Commands:")
print("  _G.SetMiningSpeed(number) - Set attacks per tick (default 50)")
print("  _G.ToggleMiningMode() - Switch between hold/toggle mode")
print("  _G.SetMiningKey(KeyCode) - Change activation key")
print("  _G.GetMiningStats() - Show mining statistics")
print("")

-- Global functions
_G.SetMiningSpeed = function(speed)
    Config.AttacksPerTick = speed
    print("[Super Mining] Speed set to: " .. speed .. " attacks/tick")
end

_G.ToggleMiningMode = function()
    Config.HoldToMine = not Config.HoldToMine
    print("[Super Mining] Mode: " .. (Config.HoldToMine and "HOLD KEY" or "TOGGLE"))
end

_G.SetMiningKey = function(keyCode)
    Config.MiningKey = keyCode
    print("[Super Mining] Key set to: " .. keyCode.Name)
end

_G.GetMiningStats = function()
    print("[Super Mining] === Statistics ===")
    print("  Total attacks sent: " .. attackCount)
    print("  Currently mining: " .. tostring(miningActive))
    print("  Attacks per tick: " .. Config.AttacksPerTick)
    print("  Mode: " .. (Config.HoldToMine and "HOLD" or "TOGGLE"))
end

print("[Super Mining] Point at a rock and hold '" .. Config.MiningKey.Name .. "' to mine!")
