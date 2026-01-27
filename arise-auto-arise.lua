-- Arise Ragnarock 100% Arise (Spam Arise Attempts)
-- Repeatedly tries to arise enemies to maximize success rate

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Remove existing UI if present
local existingGui = LocalPlayer.PlayerGui:FindFirstChild("AutoAriseUI")
if existingGui then
    existingGui:Destroy()
end

-- Configuration
local ENABLED = true
local SPAM_RATE = 0.05 -- Attempt every 50ms
local AUTO_COLLECT = false

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoAriseUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 200)
Frame.Position = UDim2.new(0.5, -125, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(150, 100, 255)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "👻 Auto Arise"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Frame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Frame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -20, 0, 35)
ToggleButton.Position = UDim2.new(0, 10, 0, 45)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
ToggleButton.Text = "✓ AUTO ARISE ON"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = Frame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

local CollectButton = Instance.new("TextButton")
CollectButton.Size = UDim2.new(1, -20, 0, 35)
CollectButton.Position = UDim2.new(0, 10, 0, 90)
CollectButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CollectButton.Text = "✗ AUTO COLLECT OFF"
CollectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CollectButton.TextSize = 16
CollectButton.Font = Enum.Font.GothamBold
CollectButton.Parent = Frame

local CollectCorner = Instance.new("UICorner")
CollectCorner.CornerRadius = UDim.new(0, 6)
CollectCorner.Parent = CollectButton

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.Position = UDim2.new(0, 10, 0, 135)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Attempts: 0"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = Frame

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -20, 0, 35)
InfoLabel.Position = UDim2.new(0, 10, 0, 160)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Status: Searching for Combat module..."
InfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
InfoLabel.TextSize = 11
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextWrapped = true
InfoLabel.Parent = Frame

-- Toggle buttons
ToggleButton.MouseButton1Click:Connect(function()
    ENABLED = not ENABLED
    if ENABLED then
        ToggleButton.Text = "✓ AUTO ARISE ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        ToggleButton.Text = "✗ AUTO ARISE OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

CollectButton.MouseButton1Click:Connect(function()
    AUTO_COLLECT = not AUTO_COLLECT
    if AUTO_COLLECT then
        CollectButton.Text = "✓ AUTO COLLECT ON"
        CollectButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        CollectButton.Text = "✗ AUTO COLLECT OFF"
        CollectButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

-- Try to get Combat module and hook it
local Combat
local attempts = 0
local ariseAttempts = 0

pcall(function()
    local Modules = ReplicatedStorage:WaitForChild("Modules", 5)
    local Game = Modules:WaitForChild("Game", 5)
    local CombatModule = Game:WaitForChild("Combat", 5)
    Combat = require(CombatModule)
    InfoLabel.Text = "Status: Combat module loaded!"
    print("[Auto Arise] Combat module loaded successfully!")
    
    -- Hook TryArise to spam it multiple times per call
    if Combat.TryArise then
        local originalTryArise = Combat.TryArise
        
        Combat.TryArise = function(...)
            local args = {...}
            local result
            
            -- Spam arise 20 times for each attempt
            for i = 1, 20 do
                result = originalTryArise(...)
                ariseAttempts += 1
                task.wait(0.001) -- Tiny delay between attempts
            end
            
            return result
        end
        
        InfoLabel.Text = "Status: TryArise hooked! (20x multiplier)"
        print("[Auto Arise] TryArise function hooked with 20x multiplier!")
    end
end)

if not Combat then
    InfoLabel.Text = "Status: Combat module not found!"
    warn("[Auto Arise] Could not load Combat module")
else
    -- Main arise loop - call the hooked function
    RunService.Heartbeat:Connect(function()
        if not ENABLED then return end
        
        pcall(function()
            attempts += 1
            
            -- This will now trigger 20 arise attempts thanks to our hook
            if Combat.TryArise then
                Combat.TryArise({}, true, true) -- Auto arise
                
                if AUTO_COLLECT then
                    Combat.TryArise({}, false, true) -- Collect
                end
            end
            
            StatusLabel.Text = "Attempts: " .. ariseAttempts
        end)
        
        task.wait(SPAM_RATE)
    end)
    
    InfoLabel.Text = "Status: Active!\n20x arise per attempt"
end

-- Also hook the keybind system for manual override
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- E key for arise (will spam 20x per call thanks to hook)
    if input.KeyCode == Enum.KeyCode.E and Combat and Combat.TryArise then
        for i = 1, 5 do
            Combat.TryArise({}, true, true)
            task.wait(0.01)
        end
    end
    
    -- F key for collect
    if input.KeyCode == Enum.KeyCode.F and Combat and Combat.TryArise then
        for i = 1, 5 do
            Combat.TryArise({}, false, true)
            task.wait(0.01)
        end
    end
end)

print("[Auto Arise] Script loaded!")
print("[Auto Arise] Spamming arise attempts every " .. SPAM_RATE .. " seconds")
print("[Auto Arise] Manual hotkeys: E (arise spam), F (collect spam)")
