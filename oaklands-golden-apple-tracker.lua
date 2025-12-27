--> GoldenApple Tracker - With Real-Time Distance Display
--> Highlights all GoldenApples on map + on-screen distance widget
--> Shows live distance as you walk toward items
--> Safe: No teleportation, no automation, pure visual aid

print("[GoldenApple Tracker+] Starting...")

local Services = setmetatable({}, {
    __index = function(self, index)
        return game:GetService(index)
    end
})

local Version = "v1.1-tracker-gui"
local Players = Services.Players
local Player = Players.LocalPlayer
local UserInputService = Services.UserInputService
local RunService = Services.RunService

print("[Tracker] Loaded - GoldenApple Tracker with Distance Display")
print("===== TRACKER COMMANDS =====")
print("_G.HighlightAllGoldenApples = true/false   -- Highlight all apples")
print("_G.ShowDistanceGUI = true/false            -- Show distance widget")
print("_G.AppleCount()                            -- Count apples")
print("_G.ClearAllHighlights()                    -- Clear highlights")
print("=============================")

--> TRACKING SYSTEM
local trackedApples = {}
local appleHighlights = {}

_G.HighlightAllGoldenApples = false
_G.ShowDistanceGUI = false

--> GUI SETUP
local screenGui = nil
local distanceLabel = nil
local appleNameLabel = nil
local isDragging = false
local dragOffset = Vector2.new(0, 0)

local function CreateGUI()
    if screenGui then return end
    
    print("[GUI] Creating distance display widget...")
    
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AppleTrackerGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = Player:WaitForChild("PlayerGui")
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 250, 0, 120)
    mainFrame.Position = UDim2.new(0, 20, 0, 20)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
    mainFrame.BorderSizePixel = 2
    mainFrame.Parent = screenGui
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "🎯 CLOSEST APPLE"
    titleLabel.Parent = mainFrame
    
    -- Distance label
    distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Size = UDim2.new(1, -10, 0, 35)
    distanceLabel.Position = UDim2.new(0, 5, 0, 30)
    distanceLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    distanceLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    distanceLabel.TextSize = 24
    distanceLabel.Font = Enum.Font.GothamBold
    distanceLabel.Text = "-- m"
    distanceLabel.Parent = mainFrame
    
    -- Apple name label
    appleNameLabel = Instance.new("TextLabel")
    appleNameLabel.Name = "AppleNameLabel"
    appleNameLabel.Size = UDim2.new(1, -10, 0, 20)
    appleNameLabel.Position = UDim2.new(0, 5, 0, 70)
    appleNameLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    appleNameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    appleNameLabel.TextSize = 12
    appleNameLabel.Font = Enum.Font.Gotham
    appleNameLabel.Text = "Scanning..."
    appleNameLabel.Parent = mainFrame
    
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
        appleNameLabel = nil
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
        appleNameLabel.Text = "No character"
        return
    end
    
    local hrp = char.HumanoidRootPart
    local apples = trackedApples
    
    if #apples == 0 then
        distanceLabel.Text = "-- m"
        appleNameLabel.Text = "No apples found"
        return
    end
    
    -- Find closest apple
    local closest = apples[1]
    local closestDist = math.huge
    
    for _, apple in ipairs(apples) do
        if apple and apple.Parent then
            pcall(function()
                local pos = apple:GetPivot().Position
                local dist = (pos - hrp.Position).Magnitude
                if dist < closestDist then
                    closest = apple
                    closestDist = dist
                end
            end)
        end
    end
    
    if closest and closest.Parent then
        distanceLabel.Text = math.floor(closestDist) .. " m"
        appleNameLabel.Text = "→ Walk toward it"
    else
        distanceLabel.Text = "-- m"
        appleNameLabel.Text = "Looking..."
    end
end

local function FindAllGoldenApples()
    local results = {}
    for _, v in ipairs(Services.Workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name == "GoldenApple" then
            table.insert(results, v)
        end
    end
    return results
end

local function CreateHighlight(obj)
    if not obj or appleHighlights[obj] then return end
    
    pcall(function()
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(255, 215, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 140, 0)
        highlight.FillTransparency = 0.3
        highlight.OutlineTransparency = 0
        highlight.Parent = obj
        appleHighlights[obj] = highlight
    end)
end

local function RemoveHighlight(obj)
    if appleHighlights[obj] then
        pcall(function()
            appleHighlights[obj]:Destroy()
        end)
        appleHighlights[obj] = nil
    end
end

_G.RefreshHighlights = function()
    print("[Tracker] Refreshing highlights...")
    for obj, highlight in pairs(appleHighlights) do
        if not obj or not obj.Parent then
            RemoveHighlight(obj)
        end
    end
    
    local apples = FindAllGoldenApples()
    print("[Tracker] Found " .. #apples .. " GoldenApples")
    
    for _, apple in ipairs(apples) do
        CreateHighlight(apple)
    end
    
    trackedApples = apples
    return #apples
end

_G.ClearAllHighlights = function()
    print("[Tracker] Clearing highlights...")
    for obj, _ in pairs(appleHighlights) do
        RemoveHighlight(obj)
    end
    appleHighlights = {}
    trackedApples = {}
    RemoveGUI()
    _G.ShowDistanceGUI = false
    _G.HighlightAllGoldenApples = false
    print("[Tracker] All cleared")
end

_G.AppleCount = function()
    local apples = FindAllGoldenApples()
    print("[Tracker] Total GoldenApples: " .. #apples)
    return #apples
end

--> HIGHLIGHT MAINTENANCE
task.spawn(function()
    while true do
        task.wait(5)
        if _G.HighlightAllGoldenApples then
            local apples = FindAllGoldenApples()
            for _, apple in ipairs(apples) do
                if not appleHighlights[apple] then
                    CreateHighlight(apple)
                end
            end
            for obj, _ in pairs(appleHighlights) do
                if not obj or not obj.Parent then
                    RemoveHighlight(obj)
                end
            end
            trackedApples = apples
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
print("  1. _G.HighlightAllGoldenApples = true    (see all apples glow)")
print("  2. _G.ShowDistanceGUI = true             (show distance widget)")
print("  3. Walk toward the closest apple")
print("  4. Watch the distance count down in real-time")
print("  5. Press E when you reach it to pick up")
print("")
print("[TIPS]")
print("  - Drag the distance widget by its title bar to move it")
print("  - Distance updates every 0.1 seconds")
print("  - 100% safe: pure visual aid, no automation")
print("")
