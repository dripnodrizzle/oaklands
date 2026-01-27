--[[
    Legends Re:Written - Full Boost
    Boosts EXP, Gold, and other resources
    
    Data Location: game:GetService("Players").LocalPlayer.Data
]]

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Configuration
local Config = {
    AutoBoost = true,
    ExpAmount = 10000,
    GoldAmount = 100000,
    StaminaAmount = 1000,
    BoostInterval = 1,
    MonitorChanges = true
}

-- State Variables
local TotalExpGained = 0
local TotalGoldGained = 0
local StartTime = tick()

-- Logging
local function Log(message)
    print("[Legends Re:Written - Boost] " .. message)
end

local function Warn(message)
    warn("[Legends Re:Written - Boost] " .. message)
end

-- Wait for Data
local Data = Player:WaitForChild("Data", 10)
if not Data then
    Warn("ERROR: Could not find Player.Data!")
    return
end

Log("Found Player Data!")

-- Explore Data structure
local function ExploreData()
    Log("========================================")
    Log("Exploring Player.Data structure...")
    Log("========================================")
    
    for _, child in pairs(Data:GetChildren()) do
        local valueStr = ""
        if child:IsA("ValueBase") then
            valueStr = " = " .. tostring(child.Value)
        elseif child:IsA("Folder") then
            valueStr = " (Folder with " .. #child:GetChildren() .. " items)"
        end
        Log("  - " .. child.Name .. " (" .. child.ClassName .. ")" .. valueStr)
    end
    
    Log("========================================")
end

-- Find server remotes
local function FindRemotes()
    local remotes = {}
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    for _, descendant in pairs(ReplicatedStorage:GetDescendants()) do
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            table.insert(remotes, descendant)
        end
    end
    
    return remotes
end

-- Try to use server remotes for gold/exp
local function TryServerRemotes()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local success = false
    
    -- Try the ObtainDrop remote for gold
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local obtainDrop = remotes:FindFirstChild("ObtainDrop")
        if obtainDrop and obtainDrop:IsA("RemoteEvent") then
            -- Try gold drops
            local goldAttempts = {
                {"GoldDrop2", Config.GoldAmount},
                {"GoldDrop", Config.GoldAmount},
                {"Gold", Config.GoldAmount},
                {"Money", Config.GoldAmount},
            }
            
            for _, attempt in pairs(goldAttempts) do
                local result, err = pcall(function()
                    obtainDrop:FireServer(attempt[1], attempt[2])
                end)
                if result then
                    Log("Server: Added " .. attempt[2] .. " gold via " .. attempt[1])
                    TotalGoldGained = TotalGoldGained + attempt[2]
                    success = true
                end
            end
        end
    end
    
    -- Search for other remotes
    if remotes then
        for _, remote in pairs(remotes:GetChildren()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                local remoteName = remote.Name:lower()
                
                -- Try EXP remotes
                if remoteName:find("exp") or remoteName:find("xp") or remoteName:find("level") then
                    local attempts = {
                        function() 
                            if remote:IsA("RemoteFunction") then
                                return remote:InvokeServer(Config.ExpAmount)
                            else
                                remote:FireServer(Config.ExpAmount)
                            end
                        end,
                        function() 
                            if remote:IsA("RemoteFunction") then
                                return remote:InvokeServer("Add", Config.ExpAmount)
                            else
                                remote:FireServer("Add", Config.ExpAmount)
                            end
                        end,
                    }
                    
                    for _, attemptFunc in pairs(attempts) do
                        local result, err = pcall(attemptFunc)
                        if result then
                            Log("Server: Used remote " .. remote.Name .. " for exp")
                            success = true
                            break
                        end
                    end
                end
            end
        end
    end
    
    return success
end

-- Boost function
local function BoostResources()
    local success = false
    
    -- Try server remotes first
    if TryServerRemotes() then
        success = true
    end
    
    -- Also boost client-side for immediate visual feedback
    local expFields = {"Experience", "Exp", "XP", "Level"}
    for _, fieldName in pairs(expFields) do
        local field = Data:FindFirstChild(fieldName)
        if field and field:IsA("ValueBase") then
            local oldValue = field.Value
            local result, err = pcall(function()
                field.Value = oldValue + Config.ExpAmount
            end)
            if result then
                TotalExpGained = TotalExpGained + Config.ExpAmount
                Log("Client: Added " .. Config.ExpAmount .. " to " .. fieldName)
                success = true
            end
        end
    end
    
    local goldFields = {"Gold", "Money", "Cash", "Coins", "Currency", "Yen"}
    for _, fieldName in pairs(goldFields) do
        local field = Data:FindFirstChild(fieldName)
        if field and field:IsA("ValueBase") then
            local oldValue = field.Value
            local result, err = pcall(function()
                field.Value = oldValue + Config.GoldAmount
            end)
            if result then
                TotalGoldGained = TotalGoldGained + Config.GoldAmount
                Log("Client: Added " .. Config.GoldAmount .. " to " .. fieldName)
                success = true
            end
        end
    end
    
    local stamina = Data:FindFirstChild("Stamina")
    if stamina and stamina:IsA("ValueBase") then
        local result, err = pcall(function()
            stamina.Value = Config.StaminaAmount
        end)
        if result then
            success = true
        end
    end
    
    return success
end

-- Monitor changes
local function MonitorData()
    Log("Setting up monitoring...")
    
    for _, child in pairs(Data:GetChildren()) do
        if child:IsA("ValueBase") then
            local fieldName = child.Name
            local lastValue = child.Value
            
            child:GetPropertyChangedSignal("Value"):Connect(function()
                if Config.MonitorChanges then
                    local newValue = child.Value
                    local change = tonumber(newValue) and tonumber(lastValue) and (newValue - lastValue) or 0
                    
                    if change > 0 then
                        Log("Increased " .. fieldName .. ": " .. lastValue .. " -> " .. newValue .. " (+" .. change .. ")")
                    elseif change < 0 then
                        Log("Decreased " .. fieldName .. ": " .. lastValue .. " -> " .. newValue .. " (" .. change .. ")")
                    end
                    
                    lastValue = newValue
                end
            end)
            
            Log("Monitoring: " .. fieldName .. " = " .. tostring(child.Value))
        end
    end
end

-- Get stats
local function GetStats()
    local stats = {}
    
    -- Find EXP/Level
    for _, fieldName in pairs({"Experience", "Exp", "XP", "Level"}) do
        local field = Data:FindFirstChild(fieldName)
        if field and field:IsA("ValueBase") then
            stats[fieldName] = tostring(field.Value)
        end
    end
    
    -- Find Gold
    for _, fieldName in pairs({"Gold", "Money", "Cash", "Coins", "Currency", "Yen"}) do
        local field = Data:FindFirstChild(fieldName)
        if field and field:IsA("ValueBase") then
            stats[fieldName] = tostring(field.Value)
        end
    end
    
    -- Find Stamina
    local stamina = Data:FindFirstChild("Stamina")
    if stamina and stamina:IsA("ValueBase") then
        stats.Stamina = tostring(stamina.Value)
    end
    
    stats.TotalExpGained = TotalExpGained
    stats.TotalGoldGained = TotalGoldGained
    stats.Runtime = math.floor(tick() - StartTime)
    
    return stats
end

-- Keyboard Controls
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.B then
        Log("Manual boost triggered!")
        BoostResources()
    elseif input.KeyCode == Enum.KeyCode.N then
        Config.AutoBoost = not Config.AutoBoost
        Log("Auto-boost " .. (Config.AutoBoost and "ENABLED" or "DISABLED"))
    elseif input.KeyCode == Enum.KeyCode.I then
        Log("========================================")
        Log("Current Stats:")
        local stats = GetStats()
        for key, value in pairs(stats) do
            Log("  " .. key .. ": " .. value)
        end
        Log("========================================")
    elseif input.KeyCode == Enum.KeyCode.D then
        ExploreData()
    elseif input.KeyCode == Enum.KeyCode.R then
        Log("Searching for remotes...")
        local remotes = FindRemotes()
        Log("Found " .. #remotes .. " remotes:")
        for _, remote in pairs(remotes) do
            Log("  - " .. remote:GetFullName() .. " (" .. remote.ClassName .. ")")
        end
    elseif input.KeyCode == Enum.KeyCode.M then
        Config.MonitorChanges = not Config.MonitorChanges
        Log("Monitoring " .. (Config.MonitorChanges and "ENABLED" or "DISABLED"))
    elseif input.KeyCode == Enum.KeyCode.Equals then
        Config.ExpAmount = Config.ExpAmount + 5000
        Config.GoldAmount = Config.GoldAmount + 50000
        Log("Boost amounts increased - EXP: " .. Config.ExpAmount .. ", Gold: " .. Config.GoldAmount)
    elseif input.KeyCode == Enum.KeyCode.Minus then
        Config.ExpAmount = math.max(1000, Config.ExpAmount - 5000)
        Config.GoldAmount = math.max(10000, Config.GoldAmount - 50000)
        Log("Boost amounts decreased - EXP: " .. Config.ExpAmount .. ", Gold: " .. Config.GoldAmount)
    end
end)

-- Initialize
Log("========================================")
Log("Legends Re:Written - Full Boost")
Log("========================================")
Log("")
Log("Controls:")
Log("  B - Manually boost resources")
Log("  N - Toggle auto-boost ON/OFF")
Log("  I - Show current stats")
Log("  D - Explore data structure")
Log("  R - List all remotes")
Log("  M - Toggle monitoring ON/OFF")
Log("  = - Increase boost amounts")
Log("  - - Decrease boost amounts")
Log("")
Log("EXP per boost: " .. Config.ExpAmount)
Log("Gold per boost: " .. Config.GoldAmount)
Log("Boost interval: " .. Config.BoostInterval .. "s")
Log("")

wait(1)
ExploreData()

wait(1)
MonitorData()

Log("")
Log("Initialization complete!")
Log("Auto-boost is " .. (Config.AutoBoost and "ENABLED" or "DISABLED"))
Log("Press 'N' to toggle, 'B' for manual boost, 'I' for stats")

-- Auto-boost loop
task.spawn(function()
    while true do
        if Config.AutoBoost then
            BoostResources()
        end
        wait(Config.BoostInterval)
    end
end)

-- Stats reporting
task.spawn(function()
    while true do
        wait(30)
        if TotalExpGained > 0 or TotalGoldGained > 0 then
            Log("--- 30s Update ---")
            Log("EXP Gained: " .. TotalExpGained .. " | Gold Gained: " .. TotalGoldGained .. " | Runtime: " .. math.floor(tick() - StartTime) .. "s")
        end
    end
end)
