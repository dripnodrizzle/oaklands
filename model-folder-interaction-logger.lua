-- Model and Folder Interaction Logger
-- Logs when you interact with Models or Folders (e.g., clicking, touching)

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

-- Log function for Models and Folders
local function logModelOrFolder(obj, context)
    if not obj then return end
    if obj:IsA("Model") or obj:IsA("Folder") then
        local uid = getUID(obj)
        print(string.format("[MODEL/FOLDER INTERACT] %s | Type: %s | Name: %s | UID: %s", context or "", obj.ClassName, obj.Name, tostring(uid)))
    end
end


-- Mouse click logging (left click)
mouse.Button1Down:Connect(function()
    local target = mouse.Target
    if target and target.Parent and (target.Parent:IsA("Model") or target.Parent:IsA("Folder")) then
        logModelOrFolder(target.Parent, "MouseClick")
    end
end)

-- Keypress interaction logging (e.g., 'E' for interact)
mouse.KeyDown:Connect(function(key)
    if key:lower() == "e" then
        local target = mouse.Target
        if target and target.Parent and (target.Parent:IsA("Model") or target.Parent:IsA("Folder")) then
            logModelOrFolder(target.Parent, "KeyPress-E")
        end
    end
end)


-- (Touch-based logging removed to avoid logging every physical contact)


-- === Automatic Interaction Logging ===
local function logAutoInteraction(obj, context)
    if not obj then return end
    if obj:IsA("Model") or obj:IsA("Folder") then
        local uid = getUID(obj)
        print(string.format("[AUTO INTERACT] %s | Type: %s | Name: %s | UID: %s", context or "", obj.ClassName, obj.Name, tostring(uid)))
    end
end

-- Detect sitting in a chair (Seat/VehicleSeat)
local function monitorSeats(char)
    for _, seat in ipairs(workspace:GetDescendants()) do
        if seat:IsA("Seat") or seat:IsA("VehicleSeat") then
            seat:GetPropertyChangedSignal("Occupant"):Connect(function()
                if seat.Occupant and seat.Occupant.Parent == char then
                    logAutoInteraction(seat.Parent, "Sit")
                end
            end)
        end
    end
end

-- Detect laying in a bed (common pattern: Humanoid state change or special bed model)
local function monitorBeds(char)
    -- Look for beds by name or custom tag
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("bed") and (obj:IsA("Model") or obj:IsA("Folder")) then
            obj.AncestryChanged:Connect(function(child, parent)
                if child == obj and parent == char then
                    logAutoInteraction(obj, "Lay")
                end
            end)
        end
    end
end

-- Detect auto-pickup (item moves to backpack or character)
local function monitorAutoPickup(char)
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") or child.Name:lower():find("item") then
            logAutoInteraction(child, "AutoPickup")
        end
    end)
    player.Backpack.ChildAdded:Connect(function(child)
        if child:IsA("Tool") or child.Name:lower():find("item") then
            logAutoInteraction(child, "AutoPickup")
        end
    end)
end

local function monitorCharacter(char)
    monitorSeats(char)
    monitorBeds(char)
    monitorAutoPickup(char)
end

if player.Character then
    monitorCharacter(player.Character)
end
player.CharacterAdded:Connect(monitorCharacter)


-- === GUI Button Click Logging ===
local function logGuiButton(button, context)
    if not button then return end
    print(string.format("[GUI INTERACT] %s | Name: %s | Class: %s", context or "", button.Name, button.ClassName))
end

local function monitorGuiButtons()
    local function connectButtons(gui)
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                if not obj:FindFirstChild("_LoggerConnected") then
                    obj.MouseButton1Click:Connect(function()
                        logGuiButton(obj, "ButtonClick")
                    end)
                    local flag = Instance.new("BoolValue")
                    flag.Name = "_LoggerConnected"
                    flag.Parent = obj
                end
            end
        end
    end
    for _, gui in ipairs(player.PlayerGui:GetChildren()) do
        connectButtons(gui)
    end
    player.PlayerGui.ChildAdded:Connect(connectButtons)
end

monitorGuiButtons()

-- === ProximityPrompt and ClickDetector Logging ===
local function logPromptOrClick(obj, context)
    if not obj then return end
    print(string.format("[PROMPT/CLICK INTERACT] %s | Name: %s | Class: %s | Parent: %s", context or "", obj.Name, obj.ClassName, obj.Parent and obj.Parent.Name or "nil"))
end

local function monitorPromptsAndClickDetectors()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            if not obj:FindFirstChild("_LoggerConnected") then
                obj.Triggered:Connect(function(playerWho)
                    if playerWho == player then
                        logPromptOrClick(obj, "ProximityPrompt")
                    end
                end)
                local flag = Instance.new("BoolValue")
                flag.Name = "_LoggerConnected"
                flag.Parent = obj
            end
        elseif obj:IsA("ClickDetector") then
            if not obj:FindFirstChild("_LoggerConnected") then
                obj.MouseClick:Connect(function(playerWho)
                    if playerWho == player then
                        logPromptOrClick(obj, "ClickDetector")
                    end
                end)
                local flag = Instance.new("BoolValue")
                flag.Name = "_LoggerConnected"
                flag.Parent = obj
            end
        end
    end
    workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("ProximityPrompt") then
            obj.Triggered:Connect(function(playerWho)
                if playerWho == player then
                    logPromptOrClick(obj, "ProximityPrompt")
                end
            end)
        elseif obj:IsA("ClickDetector") then
            obj.MouseClick:Connect(function(playerWho)
                if playerWho == player then
                    logPromptOrClick(obj, "ClickDetector")
                end
            end)
        end
    end)
end

monitorPromptsAndClickDetectors()

print("[Model/Folder Interaction Logger] Loaded. Will log interactions with Models and Folders, GUI, and prompts.")
