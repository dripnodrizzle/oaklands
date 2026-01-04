--> Comprehensive Stat Monitor
--> Shows player stats, NPC info, combat stats, and game stats on-screen

print("[Stat Monitor] Starting GUI...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Create main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StatMonitor"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Main container
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Corner rounding
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Title.BorderSizePixel = 0
Title.Font = Enum.Font.GothamBold
Title.Text = "STAT MONITOR"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Stats container
local StatsContainer = Instance.new("ScrollingFrame")
StatsContainer.Name = "StatsContainer"
StatsContainer.Size = UDim2.new(1, -20, 1, -45)
StatsContainer.Position = UDim2.new(0, 10, 0, 35)
StatsContainer.BackgroundTransparency = 1
StatsContainer.BorderSizePixel = 0
StatsContainer.ScrollBarThickness = 6
StatsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
StatsContainer.Parent = MainFrame

-- Create text label for stats
local StatsText = Instance.new("TextLabel")
StatsText.Name = "StatsText"
StatsText.Size = UDim2.new(1, -10, 1, 0)
StatsText.Position = UDim2.new(0, 5, 0, 0)
StatsText.BackgroundTransparency = 1
StatsText.Font = Enum.Font.RobotoMono
StatsText.Text = ""
StatsText.TextColor3 = Color3.fromRGB(255, 255, 255)
StatsText.TextSize = 12
StatsText.TextXAlignment = Enum.TextXAlignment.Left
StatsText.TextYAlignment = Enum.TextYAlignment.Top
StatsText.RichText = true
StatsText.Parent = StatsContainer

-- Draggable
local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

RunService.Heartbeat:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Stats tracking
local combatStats = {
    kills = 0,
    damageDealt = 0,
    hits = 0,
    startTime = tick()
}

-- Get player stats
local function GetPlayerStats()
    local char = Player.Character
    if not char then return nil end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end
    
    local stats = {
        Health = string.format("%.0f/%.0f", humanoid.Health, humanoid.MaxHealth),
        Level = "?",
        Mana = "?",
        XP = "?",
        Gold = "?"
    }
    
    -- Try to find player stats in various locations
    local playerStats = Player:FindFirstChild("PlayerStats") 
        or Player:FindFirstChild("Stats")
        or Player:FindFirstChild("leaderstats")
    
    if playerStats then
        for _, stat in ipairs(playerStats:GetChildren()) do
            if stat:IsA("IntValue") or stat:IsA("NumberValue") or stat:IsA("StringValue") then
                stats[stat.Name] = tostring(stat.Value)
            end
        end
    end
    
    return stats
end

-- Get NPC info
local function GetNPCInfo()
    local EntityFolder = Workspace:FindFirstChild("EntityFolder")
    if not EntityFolder then return {} end
    
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return {} end
    
    local hrp = char.HumanoidRootPart
    local npcs = {}
    
    for _, npc in ipairs(EntityFolder:GetChildren()) do
        if npc:IsA("Model") and npc ~= char then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local rootPart = npc:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local distance = (rootPart.Position - hrp.Position).Magnitude
                    if distance <= 50 then
                        table.insert(npcs, {
                            name = npc.Name,
                            health = humanoid.Health,
                            maxHealth = humanoid.MaxHealth,
                            distance = distance
                        })
                    end
                end
            end
        end
    end
    
    -- Sort by distance
    table.sort(npcs, function(a, b) return a.distance < b.distance end)
    
    return npcs
end

-- Get game stats
local function GetGameStats()
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    local playerCount = #Players:GetPlayers()
    
    return {
        FPS = fps,
        Ping = ping,
        Players = playerCount
    }
end

-- Update display
local function UpdateDisplay()
    local lines = {}
    
    -- Player Stats
    table.insert(lines, '<font color="rgb(100, 200, 255)"><b>=== PLAYER ===</b></font>')
    local playerStats = GetPlayerStats()
    if playerStats then
        for stat, value in pairs(playerStats) do
            table.insert(lines, string.format('<font color="rgb(200, 200, 200)">%s:</font> <font color="rgb(255, 255, 100)">%s</font>', stat, value))
        end
    else
        table.insert(lines, '<font color="rgb(255, 100, 100)">Not in game</font>')
    end
    
    table.insert(lines, "")
    
    -- Combat Stats
    table.insert(lines, '<font color="rgb(255, 100, 100)"><b>=== COMBAT ===</b></font>')
    local elapsed = tick() - combatStats.startTime
    local dps = combatStats.damageDealt / math.max(1, elapsed)
    local kpm = combatStats.kills / math.max(1, elapsed / 60)
    
    table.insert(lines, string.format('<font color="rgb(200, 200, 200)">Kills:</font> <font color="rgb(255, 100, 100)">%d</font>', combatStats.kills))
    table.insert(lines, string.format('<font color="rgb(200, 200, 200)">Damage:</font> <font color="rgb(255, 150, 50)">%d</font>', combatStats.damageDealt))
    table.insert(lines, string.format('<font color="rgb(200, 200, 200)">Hits:</font> <font color="rgb(150, 255, 150)">%d</font>', combatStats.hits))
    table.insert(lines, string.format('<font color="rgb(200, 200, 200)">DPS:</font> <font color="rgb(255, 200, 100)">%.1f</font>', dps))
    table.insert(lines, string.format('<font color="rgb(200, 200, 200)">KPM:</font> <font color="rgb(150, 255, 255)">%.1f</font>', kpm))
    
    table.insert(lines, "")
    
    -- Nearby NPCs
    table.insert(lines, '<font color="rgb(255, 150, 255)"><b>=== NEARBY NPCs ===</b></font>')
    local npcs = GetNPCInfo()
    if #npcs > 0 then
        for i, npc in ipairs(npcs) do
            if i <= 5 then
                local healthPercent = (npc.health / npc.maxHealth) * 100
                local healthColor = healthPercent > 50 and "rgb(100, 255, 100)" or (healthPercent > 25 and "rgb(255, 200, 100)" or "rgb(255, 100, 100)")
                table.insert(lines, string.format('<font color="rgb(200, 200, 200)">%s:</font> <font color="%s">%.0f%%</font> <font color="rgb(150, 150, 150)">(%.0fm)</font>', 
                    npc.name, healthColor, healthPercent, npc.distance))
            end
        end
        if #npcs > 5 then
            table.insert(lines, string.format('<font color="rgb(150, 150, 150)">...and %d more</font>', #npcs - 5))
        end
    else
        table.insert(lines, '<font color="rgb(150, 150, 150)">None within 50 studs</font>')
    end
    
    table.insert(lines, "")
    
    -- Game Stats
    table.insert(lines, '<font color="rgb(100, 255, 100)"><b>=== GAME ===</b></font>')
    local gameStats = GetGameStats()
    table.insert(lines, string.format('<font color="rgb(200, 200, 200)">FPS:</font> <font color="rgb(100, 255, 100)">%d</font>', gameStats.FPS))
    table.insert(lines, string.format('<font color="rgb(200, 200, 200)">Ping:</font> <font color="rgb(255, 200, 100)">%dms</font>', gameStats.Ping))
    table.insert(lines, string.format('<font color="rgb(200, 200, 200)">Players:</font> <font color="rgb(150, 200, 255)">%d</font>', gameStats.Players))
    
    local elapsed = tick() - combatStats.startTime
    local minutes = math.floor(elapsed / 60)
    local seconds = math.floor(elapsed % 60)
    table.insert(lines, string.format('<font color="rgb(200, 200, 200)">Session:</font> <font color="rgb(200, 200, 200)">%02d:%02d</font>', minutes, seconds))
    
    StatsText.Text = table.concat(lines, "\n")
    
    -- Auto-resize canvas
    StatsContainer.CanvasSize = UDim2.new(0, 0, 0, StatsText.TextBounds.Y + 10)
end

-- Monitor NPC deaths for kill tracking
local EntityFolder = Workspace:FindFirstChild("EntityFolder")
if EntityFolder then
    EntityFolder.ChildRemoved:Connect(function(npc)
        if npc:IsA("Model") then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health <= 0 then
                combatStats.kills = combatStats.kills + 1
            end
        end
    end)
end

-- Update loop
RunService.Heartbeat:Connect(function()
    UpdateDisplay()
end)

-- Cleanup function
_G.StopStatMonitor = function()
    if ScreenGui then
        ScreenGui:Destroy()
    end
    print("[Stat Monitor] Stopped")
end

print("[Stat Monitor] GUI loaded!")
print("Drag the window to move it")
print("Stop with: _G.StopStatMonitor()")
