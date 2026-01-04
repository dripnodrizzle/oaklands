--> NPC Kill All
--> Instantly kills all NPCs in Workspace.EntityFolder
--> Note: Client-side only - changes may not replicate to server/other players

print("[NPC Kill All] Starting...")

local Workspace = game:GetService("Workspace")
local EntityFolder = Workspace:FindFirstChild("EntityFolder")

if not EntityFolder then
    warn("[NPC Kill All] EntityFolder not found in Workspace!")
    return
end

local killCount = 0

for _, npc in ipairs(EntityFolder:GetChildren()) do
    if npc:IsA("Model") then
        local humanoid = npc:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            humanoid.Health = 0
            killCount = killCount + 1
            print(string.format("[NPC Kill All] Killed: %s", npc.Name))
        end
    end
end

print(string.format("[NPC Kill All] Complete! Killed %d NPCs", killCount))
print("[NPC Kill All] Note: This is client-side only and may not be visible to other players")
