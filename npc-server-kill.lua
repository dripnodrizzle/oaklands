--> NPC Server-Side Kill All
--> Finds and exploits damage RemoteEvents to kill NPCs server-side


print("[Kill Aura] Starting...")


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer


local EntityFolder = Workspace:FindFirstChild("EntityFolder")
if not EntityFolder then
    warn("[Kill Aura] EntityFolder not found!")
    return
end


-- Find all RemoteEvents and RemoteFunctions in ReplicatedStorage
local function FindRemotes()
    local remotes = {}
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(remotes, obj)
        end
    end
    print(string.format("[Kill Aura] Found %d remotes in ReplicatedStorage", #remotes))
    return remotes
end


-- Find combat/damage related remotes
local function FindCombatRemotes(remotes)
    local combatRemotes = {}
    -- Only use remotes that are likely to apply damage, not trigger attack animation
    local includeKeywords = {"damage", "hurt", "kill"}
    local excludeKeywords = {"attack", "swing", "m1", "slash", "combo"}
    for _, remote in ipairs(remotes) do
        local name = remote.Name:lower()
        local include = false
        for _, keyword in ipairs(includeKeywords) do
            if name:find(keyword) then
                include = true
                break
            end
        end
        if include then
            for _, ex in ipairs(excludeKeywords) do
                if name:find(ex) then
                    include = false
                    break
                end
            end
        end
        if include then
            table.insert(combatRemotes, remote)
            print(string.format("[Kill Aura] Using remote: %s (%s)", remote.Name, remote.ClassName))
        else
            print(string.format("[Kill Aura] Skipping remote: %s (%s)", remote.Name, remote.ClassName))
        end
    end
    return combatRemotes
end


-- True kill aura: rapidly kills all NPCs using damage remotes, no emote/animation, does not block M1
local function KillAura(combatRemotes)
    if #combatRemotes == 0 then
        warn("[Kill Aura] No combat remotes found! Use inspector to find correct remote.")
        return
    end
    local lastHit = {}
    local COOLDOWN = 0.15 -- seconds per NPC (very fast, but not spammed every frame)
    while true do
        for _, npc in ipairs(EntityFolder:GetChildren()) do
            if npc:IsA("Model") then
                local humanoid = npc:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local now = tick()
                    if not lastHit[npc] or now - lastHit[npc] > COOLDOWN then
                        for _, remote in ipairs(combatRemotes) do
                            pcall(function()
                                if remote:IsA("RemoteEvent") then
                                    -- Only fire damage, do NOT fire emote/animation remotes
                                    remote:FireServer(npc, 999999)
                                    remote:FireServer({Target = npc, Damage = 999999})
                                end
                            end)
                        end
                        lastHit[npc] = now
                    end
                end
            end
        end
        task.wait(0.05)
    end
end


print("[Kill Aura] Scanning for combat remotes...")
local allRemotes = FindRemotes()
local combatRemotes = FindCombatRemotes(allRemotes)

print("")
print("===== FOUND COMBAT REMOTES =====")
for i, remote in ipairs(combatRemotes) do
    print(string.format("%d. %s - %s", i, remote:GetFullName(), remote.ClassName))
end
print("================================")
print("")

-- Start kill aura in a separate thread so it never blocks M1 or other input
spawn(function()
    KillAura(combatRemotes)
end)

print("[Kill Aura] Running. M1 and other actions are not blocked.")
print("If kill aura does not work, use inspector to find the correct remote and arguments.")
