--> BlueSteel Tracker - With Real-Time Distance Display
--> Highlights all BlueSteel on map + on-screen distance widget
--> Shows live distance as you walk toward items
--> Safe: No teleportation, no automation, pure visual aid

print("[BlueSteel Tracker+] Starting...")

local Services = setmetatable({}, {
    __index = function(self, index)
        return game:GetService(index)
    end
})

local Version = "v1.0-bluesteel-tracker-gui"
local Players = Services.Players
local Player = Players.LocalPlayer
local UserInputService = Services.UserInputService
local RunService = Services.RunService

print("[Tracker] Loaded - BlueSteel Tracker with Distance Display")
print("===== TRACKER COMMANDS =====")
print("_G.HighlightAllBlueSteel = true/false   -- Highlight all BlueSteel")
print("_G.ShowDistanceGUI = true/false         -- Show distance widget")
print("_G.BlueSteelCount()                     -- Count BlueSteel")
print("_G.ClearAllHighlights()                 -- Clear highlights")
print("=============================")

--> TRACKING SYSTEM
local trackedBlueSteel = {}
local blueSteelHighlights = {}

_G.HighlightAllBlueSteel = false
_G.ShowDistanceGUI = false

--> GUI SETUP
local screenGui = nil
local distanceLabel = nil
local itemNameLabel = nil
local isDragging = false
local dragOffset = Vector2.new(0, 0)

local function CreateGUI()
    if screenGui then return end
    
    print("[GUI] Creating distance display widget...")
    
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BlueSteelTrackerGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = Player:WaitForChild("PlayerGui")
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 250, 0, 120)
    mainFrame.Position = UDim2.new(0, 20, 0, 20)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 25, 35)
    mainFrame.BorderColor3 = Color3.fromRGB(70, 130, 180)
    mainFrame.BorderSizePixel = 2
    mainFrame.Parent = screenGui
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "⚡ CLOSEST BLUESTEEL"
    titleLabel.Parent = mainFrame
    
    -- Distance label
    distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Size = UDim2.new(1, -10, 0, 35)
    distanceLabel.Position = UDim2.new(0, 5, 0, 30)
    distanceLabel.BackgroundColor3 = Color3.fromRGB(15, 25, 35)
    distanceLabel.TextColor3 = Color3.fromRGB(70, 130, 180)
    distanceLabel.TextSize = 24
    distanceLabel.Font = Enum.Font.GothamBold
    distanceLabel.Text = "-- m"
    distanceLabel.Parent = mainFrame
    
    -- Item name label
    itemNameLabel = Instance.new("TextLabel")
    itemNameLabel.Name = "ItemNameLabel"
    itemNameLabel.Size = UDim2.new(1, -10, 0, 20)
    itemNameLabel.Position = UDim2.new(0, 5, 0, 70)
    itemNameLabel.BackgroundColor3 = Color3.fromRGB(15, 25, 35)
    itemNameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    itemNameLabel.TextSize = 12
    itemNameLabel.Font = Enum.Font.Gotham
    itemNameLabel.Text = "Scanning..."
    itemNameLabel.Parent = mainFrame
    
    -- Make draggable
    titleLabel.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragOffset = Services.UserInputService:GetMouseLocation() - mainFrame.AbsolutePosition
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if isDragging and mainFrame then
            local mousePos = UserInputService:GetMouseLocation()
            mainFrame.Position = UDim2.new(0, mousePos.X - dragOffset.X, 0, mousePos.Y - dragOffset.Y)
        end
    end)
    
    print("[GUI] Distance display created successfully")
end

local function RemoveGUI()
    if screenGui then
        pcall(function() screenGui:Destroy() end)
        screenGui = nil
        distanceLabel = nil
        itemNameLabel = nil
        print("[GUI] Distance display removed")
    end
end

local function UpdateDistanceDisplay()
    if not distanceLabel or not screenGui or not screenGui.Parent then
        return
    end
    
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        distanceLabel.Text = "-- m"
        itemNameLabel.Text = "No character"
        return
    end
    
    local hrp = char.HumanoidRootPart
    local items = trackedBlueSteel
    
    if #items == 0 then
        distanceLabel.Text = "-- m"
        itemNameLabel.Text = "No BlueSteel found"
        return
    end
    
    -- Find closest BlueSteel
    local closest = items[1]
    local closestDist = math.huge
    
    for _, item in ipairs(items) do
        if item and item.Parent then
            pcall(function()
                local pos = item:GetPivot and item:GetPivot().Position or item.PrimaryPart and item.PrimaryPart.Position or item:FindFirstChildWhichIsA("BasePart").Position
                local dist = (pos - hrp.Position).Magnitude
                if dist < closestDist then
                    closest = item
                    closestDist = dist
                end
            end)
        end
    end
    
    if closest and closest.Parent then
        distanceLabel.Text = math.floor(closestDist) .. " m"
        itemNameLabel.Text = "→ Walk toward it"
    else
        distanceLabel.Text = "-- m"
        itemNameLabel.Text = "Looking..."
    end
end

local function FindAllBlueSteel()
    local results = {}
    for _, v in ipairs(Services.Workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name == "BlueSteel" then
            table.insert(results, v)
        end
    end
    return results
end

local function CreateHighlight(obj)
    if not obj or blueSteelHighlights[obj] then return end
    
    pcall(function()
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(70, 130, 180)
        highlight.OutlineColor = Color3.fromRGB(30, 90, 150)
        highlight.FillTransparency = 0.3
        highlight.OutlineTransparency = 0
        highlight.Parent = obj
        blueSteelHighlights[obj] = highlight
    end)
end

local function RemoveHighlight(obj)
    if blueSteelHighlights[obj] then
        pcall(function()
            blueSteelHighlights[obj]:Destroy()
        end)
        blueSteelHighlights[obj] = nil
    end
end

_G.RefreshHighlights = function()
    print("[Tracker] Refreshing highlights...")
    for obj, highlight in pairs(blueSteelHighlights) do
        if not obj or not obj.Parent then
            RemoveHighlight(obj)
        end
    end
    
    local items = FindAllBlueSteel()
    print("[Tracker] Found " .. #items .. " BlueSteel")
    
    for _, item in ipairs(items) do
        CreateHighlight(item)
    end
    
    trackedBlueSteel = items
    return #items
end

_G.ClearAllHighlights = function()
    print("[Tracker] Clearing highlights...")
    for obj, _ in pairs(blueSteelHighlights) do
        RemoveHighlight(obj)
    end
    blueSteelHighlights = {}
    trackedBlueSteel = {}
    RemoveGUI()
    _G.ShowDistanceGUI = false
    _G.HighlightAllBlueSteel = false
    print("[Tracker] All cleared")
end

_G.BlueSteelCount = function()
    local items = FindAllBlueSteel()
    print("[Tracker] Total BlueSteel: " .. #items)
    return #items
end

--> HIGHLIGHT MAINTENANCE
task.spawn(function()
    while true do
        task.wait(5)
        if _G.HighlightAllBlueSteel then
            local items = FindAllBlueSteel()
            for _, item in ipairs(items) do
                if not blueSteelHighlights[item] then
                    CreateHighlight(item)
                end
            end
            for obj, _ in pairs(blueSteelHighlights) do
                if not obj or not obj.Parent then
                    RemoveHighlight(obj)
                end
            end
            trackedBlueSteel = items
        end
    end
end)

--> DISTANCE UPDATE LOOP
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.ShowDistanceGUI then
            if not screenGui then
                CreateGUI()
            end
            UpdateDistanceDisplay()
        end
    end
end)

--> MONITOR GUI TOGGLE
task.spawn(function()
    local lastState = false
    while true do
        task.wait(0.5)
        if _G.ShowDistanceGUI ~= lastState then
            lastState = _G.ShowDistanceGUI
            if _G.ShowDistanceGUI then
                CreateGUI()
                print("[Tracker] Distance display ON")
            else
                RemoveGUI()
                print("[Tracker] Distance display OFF")
            end
        end
    end
end)

print("[Tracker] Ready!")
print("")
print("[QUICK START]")
print("  1. _G.HighlightAllBlueSteel = true    (see all BlueSteel glow)")
print("  2. _G.ShowDistanceGUI = true          (show distance widget)")
print("  3. Walk toward the closest BlueSteel")
print("  4. Watch the distance count down in real-time")
print("  5. Press E when you reach it to pick up")
print("")
print("[TIPS]")
print("  - Drag the distance widget by its title bar to move it")
print("  - Distance updates every 0.1 seconds")
print("  - 100% safe: pure visual aid, no automation")
print("")
