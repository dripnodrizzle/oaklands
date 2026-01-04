--> Remote Spy - Monitor Combat Remotes
--> Logs all combat remote calls to see the correct arguments

print("[Remote Spy] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CombatFolder = ReplicatedStorage:FindFirstChild("Events")
if CombatFolder then
    CombatFolder = CombatFolder:FindFirstChild("Combat")
end

if not CombatFolder then
    warn("[Remote Spy] Combat folder not found!")
    return
end

local function SpyOnRemote(remote)
    if not remote or not remote:IsA("RemoteEvent") then return end
    
    local originalNamecall
    originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if self == remote and method == "FireServer" then
            print(string.format("\n[REMOTE SPY] %s:FireServer called!", remote.Name))
            print("Arguments:")
            for i, arg in ipairs(args) do
                local argType = type(arg)
                local argValue = tostring(arg)
                
                if argType == "userdata" then
                    if typeof(arg) == "Instance" then
                        argValue = string.format("%s (%s)", arg:GetFullName(), arg.ClassName)
                    else
                        argValue = string.format("%s (typeof: %s)", tostring(arg), typeof(arg))
                    end
                elseif argType == "table" then
                    argValue = "{"
                    for k, v in pairs(arg) do
                        argValue = argValue .. string.format("%s = %s, ", tostring(k), tostring(v))
                    end
                    argValue = argValue .. "}"
                end
                
                print(string.format("  [%d] %s = %s", i, argType, argValue))
            end
            print("")
        end
        
        return originalNamecall(self, ...)
    end)
    
    print(string.format("[Remote Spy] Hooked: %s", remote.Name))
end

-- Hook all combat remotes
local remotes = {"Attack", "Hitted", "WeaponHitted", "UseSkill", "DamagePopup"}
for _, name in ipairs(remotes) do
    local remote = CombatFolder:FindFirstChild(name)
    if remote then
        SpyOnRemote(remote)
    end
end

print("")
print("[Remote Spy] All combat remotes are now being monitored!")
print("[Remote Spy] Attack an NPC and watch the console for the exact arguments.")
print("")
