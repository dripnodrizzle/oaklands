-- Interactable Object Labeler with Persistent UUIDs
-- Stores and reuses UUIDs for interactable objects in a local JSON file

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- File path for storing UUIDs
local uuidFilePath = "interactable-uuids.json"

-- Simple JSON encode/decode (for Lua, not Roblox)
local function encodeJSON(tbl)
    local json = "{\n"
    for k, v in pairs(tbl) do
        json = json .. string.format("  \"%s\": \"%s\",\n", k, v)
    end
    json = json:sub(1, -3) .. "\n}"
    return json
end

local function decodeJSON(str)
    local tbl = {}
    for key, value in str:gmatch('"([^"]+)":%s*"([^"]+)"') do
        tbl[key] = value
    end
    return tbl
end

-- Read UUIDs from file
local uuidMap = {}
local file = io.open(uuidFilePath, "r")
if file then
    local contents = file:read("*a")
    uuidMap = decodeJSON(contents)
    file:close()
end

-- Helper to generate a random UUID
local function generateUUID()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return template:gsub("[xy]", function(c)
        local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format("%x", v)
    end)
end

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

local function isInteractable(obj)
    if obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChildOfClass("ClickDetector") then
        return true
    end
    if obj:IsA("Tool") then return true end
    return false
end

local function getOrAssignUUID(obj)
    local realName = getRealName(obj)
    local uid = getUID(obj)
    if uid then return uid end
    if uuidMap[realName] then
        return uuidMap[realName]
    else
        local newUUID = generateUUID()
        uuidMap[realName] = newUUID
        -- Save to file
        local file = io.open(uuidFilePath, "w")
        file:write(encodeJSON(uuidMap))
        file:close()
        return newUUID
    end
end

local function createBillboard(obj)
    local adornee = obj
    if obj:IsA("Model") then
        adornee = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
    end
    if not adornee or (not adornee:IsA("BasePart") and not adornee:IsA("Attachment")) then
        return
    end
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
    local uuid = getOrAssignUUID(obj)
    label.Text = string.format("UUID: %s\nName: %s", tostring(uuid), tostring(getRealName(obj)))
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

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end
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


print("[Interactable Labeler] Labeled all interactable objects with persistent UUIDs.")
