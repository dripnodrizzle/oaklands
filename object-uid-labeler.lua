-- Object UID/Name Labeler
-- Labels all BaseParts in workspace with their Name and UID (if found)
-- Text is small and non-intrusive

local function labelPart(part)
    if part:IsA("BasePart") and not part:FindFirstChild("NameLabel") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "NameLabel"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.Adornee = part
        billboard.AlwaysOnTop = true
        billboard.Parent = part

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 0)
        label.TextStrokeTransparency = 0.5
        label.TextScaled = false
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 12 -- smaller text
        -- Try to find UID in attributes or children
        local uid = part:GetAttribute("UID")
        if not uid then
            for _, child in ipairs(part:GetChildren()) do
                if (child:IsA("StringValue") or child:IsA("IntValue")) and child.Name:lower():find("uid") then
                    uid = child.Value
                    break
                end
            end
        end
        label.Text = part.Name .. (uid and (" | UID: " .. tostring(uid)) or "")
        label.Parent = billboard
    end
end

-- Label all existing parts
for _, part in ipairs(workspace:GetDescendants()) do
    labelPart(part)
end

-- Label new parts as they are added
workspace.DescendantAdded:Connect(function(obj)
    labelPart(obj)
end)
