--> NPC Server-Side Kill All
--> Finds and exploits damage RemoteEvents to kill NPCs server-side

print("[Server Kill] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local EntityFolder = Workspace:FindFirstChild("EntityFolder")
if not EntityFolder then
    warn("[Server Kill] EntityFolder not found!")
    return
end

-- Function to find all RemoteEvents and RemoteFunctions
local function FindRemotes()
    local remotes = {}
    
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(remotes, obj)
        end
    end
    
    print(string.format("[Server Kill] Found %d remotes in ReplicatedStorage", #remotes))
    return remotes
end

-- Function to find combat/damage related remotes
local function FindCombatRemotes(remotes)
    local combatRemotes = {}
    local keywords = {"damage", "attack", "hit", "hurt", "combat", "fight", "kill", "shoot", "fire", "swing"}
    
    for _, remote in ipairs(remotes) do
        local name = remote.Name:lower()
        for _, keyword in ipairs(keywords) do
            if name:find(keyword) then
                table.insert(combatRemotes, remote)
                print(string.format("[Server Kill] Found combat remote: %s (%s)", remote.Name, remote.ClassName))
                break
            end
        end
    end
    
    return combatRemotes
end

-- Try to kill NPCs using found remotes
local function TryKillNPCs(combatRemotes)
    local npcs = {}
    
    for _, npc in ipairs(EntityFolder:GetChildren()) do
        if npc:IsA("Model") then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                table.insert(npcs, npc)
            end
        end
    end
    
    print(string.format("[Server Kill] Found %d alive NPCs", #npcs))
    
    if #combatRemotes == 0 then
        warn("[Server Kill] No combat remotes found! Try these alternatives:")
        print("1. Use the inspector to find RemoteEvents when you attack")
        print("2. Look in ReplicatedStorage for damage/combat remotes")
        print("3. Try: _G.InspectObject('Remote') or _G.FindByClass('RemoteEvent')")
        return
    end
    
    -- Try each combat remote
    for _, remote in ipairs(combatRemotes) do
        print(string.format("[Server Kill] Trying remote: %s", remote.Name))
        
        for _, npc in ipairs(npcs) do
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            
            -- Try different common damage remote patterns
            pcall(function()
                if remote:IsA("RemoteEvent") then
                    -- Try various argument patterns
                    remote:FireServer(npc)
                    remote:FireServer(humanoid)
                    remote:FireServer(npc, 999999)
                    remote:FireServer(humanoid, 999999)
                    remote:FireServer({Target = npc, Damage = 999999})
                    remote:FireServer({Target = humanoid, Damage = 999999})
                end
            end)
            
            task.wait(0.01) -- Small delay to not spam
        end
    end
    
    print("[Server Kill] Attempted to kill all NPCs via server remotes")
    print("[Server Kill] Check if NPCs died. If not, you need to find the correct remote.")
end

-- Main execution
print("[Server Kill] Scanning for combat remotes...")
local allRemotes = FindRemotes()
local combatRemotes = FindCombatRemotes(allRemotes)

print("")
print("===== FOUND COMBAT REMOTES =====")
for i, remote in ipairs(combatRemotes) do
    print(string.format("%d. %s - %s", i, remote:GetFullName(), remote.ClassName))
end
print("================================")
print("")

-- Try to kill NPCs
TryKillNPCs(combatRemotes)

print("")
print("===== MANUAL USAGE =====")
print("If auto-kill didn't work, manually fire the damage remote:")
print("Example: ReplicatedStorage.RemoteName:FireServer(npc, damage)")
print("Use the inspector to find the correct remote and arguments!")
print("========================")
