-- Arise Ragnarock Damage Boost
-- Multiplies outgoing damage by hooking remotes

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local DAMAGE_MULTIPLIER = 5
local ENABLED = true

-- UI Setup
-- Remove existing UI if present
local existingGui = LocalPlayer.PlayerGui:FindFirstChild("DamageBoostUI")
if existingGui then
    existingGui:Destroy()
end

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
Title.Size = UDim2.new(1, -50, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "⚔️ Damage Boost"
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
    print("[Damage Boost] UI closed")
end)

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

-- Metamethod hook for all RemoteEvent:FireServer calls
local hookedRemotes = {}
local damageBoosts = 0
local attackRemote

-- Find the Attack remote
pcall(function()
    attackRemote = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Combat"):WaitForChild("Attack")
    StatusLabel.Text = "Status: Found Attack remote"
    print("[Damage Boost] Found Attack remote!")
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    if method == "FireServer" and self:IsA("RemoteEvent") and ENABLED then
        -- Check if this is the Attack remote
        if attackRemote and self == attackRemote then
            if not hookedRemotes["Attack"] then
                hookedRemotes["Attack"] = true
                StatusLabel.Text = "Hooked: Attack"
                print("[Damage Boost] Hooked Attack remote!")
            end
            
            -- Pack args properly
            local args = table.pack(...)
            local modified = false
            
            -- Log original arguments for debugging
            print("[Damage Boost] Original args:")
            for i = 1, args.n do
                print("  [" .. i .. "]", args[i], type(args[i]))
                if type(args[i]) == "table" then
                    for k, v in pairs(args[i]) do
                        print("    ", k, "=", v)
                    end
                end
            end
            
            -- Multiply ALL numeric values (damage could be anywhere)
            for i = 1, args.n do
                local arg = args[i]
                if type(arg) == "number" and arg > 0 and arg < 10000 then
                    args[i] = arg * DAMAGE_MULTIPLIER
                    modified = true
                    print("[Damage Boost] Multiplied arg[" .. i .. "]: " .. arg .. " -> " .. args[i])
                elseif type(arg) == "table" then
                    -- Scan entire table for numeric values
                    for key, value in pairs(arg) do
                        if type(value) == "number" and value > 0 and value < 10000 then
                            arg[key] = value * DAMAGE_MULTIPLIER
                            modified = true
                            print("[Damage Boost] Multiplied table[" .. tostring(key) .. "]: " .. value .. " -> " .. arg[key])
                        end
                    end
                end
            end
            
            if modified then
                damageBoosts += 1
                StatusLabel.Text = "Boosted: " .. damageBoosts .. "x"
            else
                StatusLabel.Text = "Attack called (no numeric args)"
            end
            
            -- Return modified call
            return oldNamecall(self, table.unpack(args, 1, args.n))
        end
        
        -- Also check by name as fallback
        local remoteName = self.Name:lower()
        if remoteName == "attack" or remoteName:find("damage") or 
           remoteName:find("hit") or remoteName:find("combat") then
            
            if not hookedRemotes[self.Name] then
                hookedRemotes[self.Name] = true
                print("[Damage Boost] Also hooked:", self.Name)
            end
            
            local args = table.pack(...)
            
            -- Multiply numeric values
            for i = 1, args.n do
                local arg = args[i]
                if type(arg) == "number" and arg > 0 and arg < 10000 then
                    args[i] = arg * DAMAGE_MULTIPLIER
                elseif type(arg) == "table" then
                    for key, value in pairs(arg) do
                        if type(value) == "number" and value > 0 and value < 10000 then
                            arg[key] = value * DAMAGE_MULTIPLIER
                        end
                    end
                end
            end
            
            return oldNamecall(self, table.unpack(args, 1, args.n))
        end
    end
    
    -- Pass through all other calls unchanged
    return oldNamecall(self, ...)
end)

StatusLabel.Text = "Status: Hooked __namecall"
print("[Damage Boost] Metamethod hook active!")
print("[Damage Boost] Target: ReplicatedStorage.Events.Combat.Attack")

print("[Damage Boost] Loaded successfully!")
print("[Damage Boost] Multiplier:", DAMAGE_MULTIPLIER .. "x")
print("[Damage Boost] Enabled:", ENABLED)
