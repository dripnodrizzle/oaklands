-- RO-LEVELING Infinite Rolls Exploit
-- Grants unlimited dodge rolls by exploiting the AddRolls remote

print("[RO-LEVELING] Infinite Rolls Loading...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Find the AddRolls remote
local AddRolls = ReplicatedStorage:WaitForChild("Global"):WaitForChild("AddRolls")

print("[RO-LEVELING] Found AddRolls remote!")

-- Function to add rolls
local function giveRolls(amount)
    amount = amount or 999
    
    pcall(function()
        AddRolls:FireServer(amount)
        print("[RO-LEVELING] Fired AddRolls with amount:", amount)
    end)
end

-- Auto-grant rolls on spawn
local function onCharacterAdded(character)
    task.wait(2) -- Wait for character to load
    giveRolls(999)
    print("[RO-LEVELING] Auto-granted 999 rolls!")
end

-- Connect to character respawns
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Continuous roll replenishment (every 5 seconds)
task.spawn(function()
    while task.wait(5) do
        giveRolls(999)
    end
end)

print("[RO-LEVELING] Infinite Rolls Active!")
print("[RO-LEVELING] You now have unlimited dodge rolls!")

-- Optional: Create a GUI toggle
local function createToggleGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RollsGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer.PlayerGui
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 100)
    Frame.Position = UDim2.new(0.5, -100, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 2
    Frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
    Frame.Parent = ScreenGui
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.Text = "RO-LEVELING Rolls"
    Title.TextColor3 = Color3.fromRGB(0, 255, 0)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 16
    Title.Parent = Frame
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 40)
    Button.Position = UDim2.new(0.05, 0, 0, 45)
    Button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    Button.Text = "Give 999 Rolls"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 14
    Button.Parent = Frame
    
    Button.MouseButton1Click:Connect(function()
        giveRolls(999)
        Button.Text = "✓ Rolls Added!"
        task.wait(0.5)
        Button.Text = "Give 999 Rolls"
    end)
    
    -- Make draggable
    local dragging, dragInput, dragStart, startPos
    
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
        end
    end)
    
    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    Frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

createToggleGUI()
