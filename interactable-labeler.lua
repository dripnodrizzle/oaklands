-- Interactable Object Labeler
-- Labels only interactable Models/Objects with their UID and RealName


local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Helper to extract UID and RealName
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

local function getRealName(obj)
    return obj.Name
end

-- Check if object is interactable (ProximityPrompt, ClickDetector, Tool, or custom logic)
local function isInteractable(obj)
    if obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChildOfClass("ClickDetector") then
        return true
    end
    if obj:IsA("Tool") then return true end
    return false
end

-- Label interactable objects

local function createBillboard(obj)
    local adornee = obj
    if obj:IsA("Model") then
        adornee = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
    end
    -- Only proceed if adornee is a valid BasePart or Attachment
    if not adornee or (not adornee:IsA("BasePart") and not adornee:IsA("Attachment")) then
        return
    end
    -- Prevent duplicate labels on the same object (search PlayerGui for a label with this adornee)
    for _, gui in ipairs(player.PlayerGui:GetChildren()) do
        if gui:IsA("BillboardGui") and gui.Adornee == adornee and gui.Name == "_UUIDLabel" then
            return
        end
    end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "_UUIDLabel"
    billboard.Size = UDim2.new(0, 200, 0, 40)
    billboard.Adornee = adornee
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = player.PlayerGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 0.5)
    label.TextStrokeTransparency = 0.5
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    local uid = getUID(obj)
    local realName = getRealName(obj)
    if not uid then uid = "None" end
    label.Text = string.format("UID: %s\nRealName: %s", tostring(uid), tostring(realName))
    label.Parent = billboard
end


local labelsEnabled = true

local function removeAllLabels()
    for _, gui in ipairs(player.PlayerGui:GetChildren()) do
        if gui:IsA("BillboardGui") and gui.Name == "_UUIDLabel" then
            gui:Destroy()
        end
    end
end

local function labelInteractables()
    if not labelsEnabled then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("BasePart")) and isInteractable(obj) then
            createBillboard(obj)
        end
    end
end

labelInteractables()

workspace.DescendantAdded:Connect(function(obj)
    if labelsEnabled and (obj:IsA("Model") or obj:IsA("BasePart")) and isInteractable(obj) then
        task.wait(0.1)
        createBillboard(obj)
    end
end)

-- Toggle with F6 key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F6 then
        labelsEnabled = not labelsEnabled
        if labelsEnabled then
            print("[Interactable Labeler] Labels enabled.")
            labelInteractables()
        else
            print("[Interactable Labeler] Labels disabled.")
            removeAllLabels()
        end
    end
end)

print("[Interactable Labeler] Labeled all interactable objects with UID and RealName.")
