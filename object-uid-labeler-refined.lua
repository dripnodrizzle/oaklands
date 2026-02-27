-- Object UID Labeler (Refined): Labels only main items (Models/Folders) with their name and UID
-- Shows label on PrimaryPart (or first BasePart found)

local Workspace = game:GetService("Workspace")
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

local function createLabel(part, name, uid)
    if not part or part:FindFirstChild("UIDLabel") then return end
    local gui = Instance.new("BillboardGui")
    gui.Name = "UIDLabel"
    gui.Adornee = part
    gui.Size = UDim2.new(0, 120, 0, 24)
    gui.AlwaysOnTop = true
    gui.ExtentsOffset = Vector3.new(0, 2, 0)
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = string.format("%s\nUID: %s", name, tostring(uid))
    text.TextSize = 14
    text.TextColor3 = Color3.new(1,1,1)
    text.Font = Enum.Font.SourceSans
    text.Parent = gui
    gui.Parent = part
end

for _, obj in ipairs(Workspace:GetChildren()) do
    if obj:IsA("Model") or obj:IsA("Folder") then
        local uid = getUID(obj)
        if uid then
            local mainPart = obj.PrimaryPart
            if not mainPart then
                for _, part in ipairs(obj:GetDescendants()) do
                    if part:IsA("BasePart") then
                        mainPart = part
                        break
                    end
                end
            end
            if mainPart then
                createLabel(mainPart, obj.Name, uid)
            end
        end
    end
end

print("[Object UID Labeler] Main items labeled with name and UID.")