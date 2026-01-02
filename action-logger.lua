--> Action Logger - Capture exact remote arguments
--> Shows you exactly what to send for mining/combat

print("[Action Logger] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:FindFirstChild("Events")

if not Events then
    warn("[Action Logger] Events folder not found!")
    return
end

local CombatFolder = Events:FindFirstChild("Combat")
if not CombatFolder then
    warn("[Action Logger] Combat folder not found!")
    return
end

local AttackRemote = CombatFolder:FindFirstChild("Attack")
if not AttackRemote then
    warn("[Action Logger] Attack remote not found!")
    return
end

print("[Action Logger] Found Combat.Attack remote!")
print("[Action Logger] Hooking into FireServer calls...")

-- Hook the remote to capture arguments
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

local capturedArgs = {}
local callCount = 0

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if self == AttackRemote and method == "FireServer" then
        callCount = callCount + 1
        
        print("\n[ACTION LOGGER] ===== Attack #" .. callCount .. " =====")
        print("Time: " .. os.date("%X"))
        print("Arguments count: " .. #args)
        
        for i, arg in ipairs(args) do
            local argType = typeof(arg)
            local argValue
            
            if argType == "Instance" then
                argValue = string.format("Instance: %s (%s)", arg.Name, arg.ClassName)
                print(string.format("  [%d] %s", i, argValue))
                print(string.format("      Path: %s", arg:GetFullName()))
            elseif argType == "Vector3" then
                argValue = string.format("Vector3.new(%.2f, %.2f, %.2f)", arg.X, arg.Y, arg.Z)
                print(string.format("  [%d] %s", i, argValue))
            elseif argType == "CFrame" then
                local pos = arg.Position
                argValue = string.format("CFrame.new(%.2f, %.2f, %.2f, ...)", pos.X, pos.Y, pos.Z)
                print(string.format("  [%d] %s", i, argValue))
            elseif argType == "table" then
                print(string.format("  [%d] table:", i))
                for k, v in pairs(arg) do
                    print(string.format("      [%s] = %s (%s)", tostring(k), tostring(v), typeof(v)))
                end
            else
                print(string.format("  [%d] %s: %s", i, argType, tostring(arg)))
            end
        end
        
        -- Store for later analysis
        table.insert(capturedArgs, {
            time = tick(),
            args = args
        })
        
        print("=====================================\n")
    end
    
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

print("[Action Logger] ✓ Ready!")
print("Now attack an enemy or mine a rock - I'll show the exact arguments!")
print("")
print("Commands:")
print("  _G.GetLastAttack() - Get last attack arguments")
print("  _G.GetAllAttacks() - Get all captured attacks")
print("  _G.ClearAttacks() - Clear captured data")
print("  _G.TestAttack() - Replay last attack")
print("")

_G.GetLastAttack = function()
    if #capturedArgs == 0 then
        print("[Action Logger] No attacks captured yet!")
        return nil
    end
    return capturedArgs[#capturedArgs]
end

_G.GetAllAttacks = function()
    print("[Action Logger] Captured " .. #capturedArgs .. " attacks")
    return capturedArgs
end

_G.ClearAttacks = function()
    capturedArgs = {}
    callCount = 0
    print("[Action Logger] Cleared all captured attacks")
end

_G.TestAttack = function()
    local last = _G.GetLastAttack()
    if not last then return end
    
    print("[Action Logger] Replaying last attack...")
    AttackRemote:FireServer(unpack(last.args))
    print("[Action Logger] ✓ Sent!")
end

print("[Action Logger] Monitoring started!")
