-- Arise Ragnarock Remote Logger
-- Logs all remote calls to find combat remotes

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Remove existing UI if present
local existingGui = LocalPlayer.PlayerGui:FindFirstChild("RemoteLoggerUI")
if existingGui then
    existingGui:Destroy()
end

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RemoteLoggerUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 350, 0, 400)
Frame.Position = UDim2.new(0.5, -175, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(100, 200, 255)
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
Title.Text = "📡 Remote Logger"
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

local LogScroll = Instance.new("ScrollingFrame")
LogScroll.Size = UDim2.new(1, -20, 1, -50)
LogScroll.Position = UDim2.new(0, 10, 0, 40)
LogScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LogScroll.BorderSizePixel = 0
LogScroll.ScrollBarThickness = 6
LogScroll.Parent = Frame

local LogLayout = Instance.new("UIListLayout")
LogLayout.Padding = UDim.new(0, 2)
LogLayout.Parent = LogScroll

local function addLog(text, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Font = Enum.Font.Code
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.Parent = LogScroll
    
    LogScroll.CanvasSize = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y)
    LogScroll.CanvasPosition = Vector2.new(0, LogScroll.AbsoluteCanvasSize.Y)
end

addLog("Remote Logger Active!", Color3.fromRGB(100, 255, 100))
addLog("Attack enemies to see remotes...", Color3.fromRGB(200, 200, 200))

print("=" .. string.rep("=", 50))
print("[Remote Logger] Starting...")
print("=" .. string.rep("=", 50))

-- Hook RemoteEvent.FireServer
local oldFireServer
oldFireServer = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    if method == "FireServer" and self:IsA("RemoteEvent") then
        local args = table.pack(...)
        
        addLog("", Color3.fromRGB(100, 255, 255))
        addLog("🔥 " .. self.Name, Color3.fromRGB(255, 200, 50))
        addLog("   Path: " .. self:GetFullName(), Color3.fromRGB(150, 150, 150))
        
        for i = 1, args.n do
            local arg = args[i]
            local argType = type(arg)
            if argType == "table" then
                addLog("   [" .. i .. "] table {", Color3.fromRGB(200, 150, 255))
                for k, v in pairs(arg) do
                    addLog("      " .. tostring(k) .. " = " .. tostring(v) .. " (" .. type(v) .. ")", Color3.fromRGB(180, 130, 235))
                end
                addLog("   }", Color3.fromRGB(200, 150, 255))
            else
                addLog("   [" .. i .. "] " .. tostring(arg) .. " (" .. argType .. ")", Color3.fromRGB(200, 200, 200))
            end
        end
        
        print("\n[FireServer] Remote:", self.Name)
        print("  Path:", self:GetFullName())
    end
    
    return oldFireServer(self, ...)
end)

-- Also try to hook the Engine Service
local success, EngineService = pcall(function()
    return ReplicatedStorage:WaitForChild("Engine", 5):WaitForChild("EngineService", 5)
end)

if success and EngineService then
    print("\n[Engine Service] Found! Attempting to hook...")
    
    local module = require(EngineService)
    
    if module and module.FireServer then
        local originalFireServer = module.FireServer
        
        module.FireServer = function(remote, ...)
            print("\n[Engine.FireServer] Remote:", remote:GetFullName())
            print("  Name:", remote.Name)
            print("  Arguments:")
            local args = {...}
            for i, arg in ipairs(args) do
                local argType = type(arg)
                if argType == "table" then
                    print("    [" .. i .. "] table:")
                    for k, v in pairs(arg) do
                        print("      ", k, "=", v, "(" .. type(v) .. ")")
                    end
                else
                    print("    [" .. i .. "]", arg, "(" .. argType .. ")")
                end
            end
            
            return originalFireServer(remote, ...)
        end
        
        print("[Engine Service] Successfully hooked FireServer!")
    end
end

print("\n[Remote Logger] Active! Now attack enemies and watch the console (F9)")
print("=" .. string.rep("=", 50))
