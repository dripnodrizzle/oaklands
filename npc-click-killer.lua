--> NPC Click Killer
--> Kills any NPC in Workspace.EntityFolder when clicked

print("[NPC Click Killer] Starting...")

local Workspace = game:GetService("Workspace")
local EntityFolder = Workspace:WaitForChild("EntityFolder", 10)

if not EntityFolder then
    warn("[NPC Click Killer] EntityFolder not found in Workspace!")
    return
end

local function SetupNPC(npc)
    if not npc:IsA("Model") then return end
    
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Find a part to attach the ClickDetector to
    local primaryPart = npc.PrimaryPart or npc:FindFirstChildOfClass("Part") or npc:FindFirstChildOfClass("MeshPart")
    if not primaryPart then return end
    
    -- Check if already has a click detector
    local existingCD = primaryPart:FindFirstChildOfClass("ClickDetector")
    if existingCD then
        existingCD:Destroy()
    end
    
    -- Create ClickDetector
    local clickDetector = Instance.new("ClickDetector")
    clickDetector.MaxActivationDistance = 32
    clickDetector.Parent = primaryPart
    
    -- Connect click event
    clickDetector.MouseClick:Connect(function(player)
        if humanoid and humanoid.Health > 0 then
            print(string.format("[NPC Click Killer] %s killed %s", player.Name, npc.Name))
            humanoid.Health = 0
        end
    end)
    
    print(string.format("[NPC Click Killer] Setup click detector on %s", npc.Name))
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

print("[NPC Click Killer] Ready! Click any NPC to kill it instantly.")
print("[NPC Click Killer] Monitoring " .. #EntityFolder:GetChildren() .. " NPCs")
