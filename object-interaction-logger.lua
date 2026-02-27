-- Interaction Logger: Logs UID and Name of everything you interact with
-- Works for clicking, touching, and tool activation

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Helper to extract UID from attributes or children
local function getUID(obj)
    if obj:GetAttribute("UID") then
        return obj:GetAttribute("UID")
    end
    for _, child in ipairs(obj:GetChildren()) do
        if (child:IsA("StringValue") or child:IsA("IntValue")) and child.Name:lower():find("uid") then
            return child.Value
        end
    end
    return nil
end

-- Log function
local function logObject(obj, context)
    if not obj then return end
    local uid = getUID(obj)
    print(string.format("[INTERACT] %s | Name: %s | UID: %s", context or "", obj.Name, tostring(uid)))
end

-- Mouse click logging
mouse.Button1Down:Connect(function()
    local target = mouse.Target
    if target then
        logObject(target, "MouseClick")
    end
end)

-- Touch logging (for your character)
local function onTouched(part)
    logObject(part, "Touched")
end

if player.Character then
    for _, part in ipairs(player.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Touched:Connect(onTouched)
        end
    end
end
player.CharacterAdded:Connect(function(char)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Touched:Connect(onTouched)
        end
    end
end)

-- Tool activation logging
player.Backpack.ChildAdded:Connect(function(tool)
    if tool:IsA("Tool") then
        tool.Activated:Connect(function()
            logObject(tool, "ToolActivated")
        end)
    end
end)
for _, tool in ipairs(player.Backpack:GetChildren()) do
    if tool:IsA("Tool") then
        tool.Activated:Connect(function()
            logObject(tool, "ToolActivated")
        end)
    end
end

print("[Interaction Logger] Loaded. Will log UID and Name of everything you interact with.")
