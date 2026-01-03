-- Arise Ragnarock Damage Boost
-- Multiplies outgoing damage by hooking remotes

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local DAMAGE_MULTIPLIER = 5
local ENABLED = true

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DamageBoostUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 180)
Frame.Position = UDim2.new(0.5, -125, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(255, 50, 50)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "⚔️ Damage Boost"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -20, 0, 35)
ToggleButton.Position = UDim2.new(0, 10, 0, 45)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
ToggleButton.Text = "✓ ENABLED"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = Frame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

local MultiplierLabel = Instance.new("TextLabel")
MultiplierLabel.Size = UDim2.new(1, -20, 0, 25)
MultiplierLabel.Position = UDim2.new(0, 10, 0, 90)
MultiplierLabel.BackgroundTransparency = 1
MultiplierLabel.Text = "Multiplier: " .. DAMAGE_MULTIPLIER .. "x"
MultiplierLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
MultiplierLabel.TextSize = 14
MultiplierLabel.Font = Enum.Font.Gotham
MultiplierLabel.TextXAlignment = Enum.TextXAlignment.Left
MultiplierLabel.Parent = Frame

local MultiplierSlider = Instance.new("TextButton")
MultiplierSlider.Size = UDim2.new(1, -20, 0, 8)
MultiplierSlider.Position = UDim2.new(0, 10, 0, 120)
MultiplierSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MultiplierSlider.Text = ""
MultiplierSlider.Parent = Frame

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 4)
SliderCorner.Parent = MultiplierSlider

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.4, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = MultiplierSlider

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(0, 4)
SliderFillCorner.Parent = SliderFill

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.Position = UDim2.new(0, 10, 0, 145)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = Frame

-- Toggle functionality
ToggleButton.MouseButton1Click:Connect(function()
    ENABLED = not ENABLED
    if ENABLED then
        ToggleButton.Text = "✓ ENABLED"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        StatusLabel.Text = "Status: Active"
    else
        ToggleButton.Text = "✗ DISABLED"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        StatusLabel.Text = "Status: Inactive"
    end
end)

-- Slider functionality
local dragging = false
MultiplierSlider.MouseButton1Down:Connect(function()
    dragging = true
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if dragging then
        local mousePos = game:GetService("UserInputService"):GetMouseLocation()
        local sliderPos = MultiplierSlider.AbsolutePosition
        local sliderSize = MultiplierSlider.AbsoluteSize
        
        local relativeX = math.clamp(mousePos.X - sliderPos.X, 0, sliderSize.X)
        local percentage = relativeX / sliderSize.X
        
        DAMAGE_MULTIPLIER = math.floor(1 + percentage * 99) -- 1x to 100x
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        MultiplierLabel.Text = "Multiplier: " .. DAMAGE_MULTIPLIER .. "x"
    end
end)

-- Wait for Engine Service
local EngineService
local success = pcall(function()
    EngineService = ReplicatedStorage:WaitForChild("Engine", 5):WaitForChild("EngineService", 5)
end)

if not success or not EngineService then
    StatusLabel.Text = "Status: Engine not found"
    warn("Could not find Engine Service")
end

-- Find Client Events folder
local ClientEvents
pcall(function()
    ClientEvents = ReplicatedStorage:WaitForChild("Client Events", 5)
end)

-- Hook into FireServer for damage boost
local originalFireServer
local hookedRemotes = {}

if EngineService then
    -- Try to hook the Engine's FireServer if it exists
    local module = require(EngineService)
    
    if module and module.FireServer then
        originalFireServer = module.FireServer
        
        module.FireServer = function(remote, ...)
            local args = {...}
            
            if ENABLED and remote and remote.Name then
                local remoteName = remote.Name:lower()
                
                -- Check for damage-related remotes
                if remoteName:find("damage") or remoteName:find("attack") or 
                   remoteName:find("hit") or remoteName:find("combat") or
                   remoteName:find("punch") or remoteName:find("swing") then
                    
                    -- Log the remote if not already logged
                    if not hookedRemotes[remote.Name] then
                        hookedRemotes[remote.Name] = true
                        StatusLabel.Text = "Hooked: " .. remote.Name
                        print("[Damage Boost] Hooked remote:", remote.Name)
                    end
                    
                    -- Multiply numeric damage values in arguments
                    for i, arg in ipairs(args) do
                        if type(arg) == "number" and arg > 0 and arg < 10000 then
                            args[i] = arg * DAMAGE_MULTIPLIER
                        elseif type(arg) == "table" then
                            -- Check table for damage values
                            for key, value in pairs(arg) do
                                if type(value) == "number" and (
                                    tostring(key):lower():find("damage") or
                                    tostring(key):lower():find("dmg") or
                                    tostring(key):lower():find("power")
                                ) then
                                    arg[key] = value * DAMAGE_MULTIPLIER
                                end
                            end
                        end
                    end
                end
            end
            
            return originalFireServer(remote, unpack(args))
        end
        
        StatusLabel.Text = "Status: Hooked Engine"
        print("[Damage Boost] Successfully hooked FireServer")
    end
end

-- Alternative: Hook all RemoteEvents directly
local function hookRemoteEvent(remote)
    if not remote:IsA("RemoteEvent") then return end
    
    local originalFireServer2 = remote.FireServer
    remote.FireServer = newcclosure(function(self, ...)
        local args = {...}
        
        if ENABLED then
            local remoteName = remote.Name:lower()
            
            if remoteName:find("damage") or remoteName:find("attack") or 
               remoteName:find("hit") or remoteName:find("combat") or
               remoteName:find("punch") or remoteName:find("swing") then
                
                if not hookedRemotes[remote.Name] then
                    hookedRemotes[remote.Name] = true
                    StatusLabel.Text = "Hooked: " .. remote.Name
                    print("[Damage Boost] Hooked remote:", remote.Name)
                end
                
                for i, arg in ipairs(args) do
                    if type(arg) == "number" and arg > 0 and arg < 10000 then
                        args[i] = arg * DAMAGE_MULTIPLIER
                    elseif type(arg) == "table" then
                        for key, value in pairs(arg) do
                            if type(value) == "number" and (
                                tostring(key):lower():find("damage") or
                                tostring(key):lower():find("dmg") or
                                tostring(key):lower():find("power")
                            ) then
                                arg[key] = value * DAMAGE_MULTIPLIER
                            end
                        end
                    end
                end
            end
        end
        
        return originalFireServer2(self, unpack(args))
    end)
end

-- Hook existing remotes
for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
    if descendant:IsA("RemoteEvent") then
        pcall(function()
            hookRemoteEvent(descendant)
        end)
    end
end

-- Hook new remotes as they're added
ReplicatedStorage.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("RemoteEvent") then
        task.wait(0.1)
        pcall(function()
            hookRemoteEvent(descendant)
        end)
    end
end)

print("[Damage Boost] Loaded successfully!")
print("[Damage Boost] Multiplier:", DAMAGE_MULTIPLIER .. "x")
print("[Damage Boost] Enabled:", ENABLED)
