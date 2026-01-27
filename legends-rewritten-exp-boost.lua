--[[
    Legends Re:Written - EXP Boost
    Automatically boosts experience for quick level gains
    
    Features:
    - EXP multiplier/boost
    - Automatic EXP gain detection
    - Level monitoring
    - Remote exploration for EXP-related functions
    
    Data Location: game:GetService("ReplicatedStorage").Data.Level
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Configuration
local Config = {
    ExpMultiplier = 10,
    AutoBoost = true,
    MonitorLevels = true,
    ExpPerAction = 1000,
    MaxLevel = 999,
    LogExpGains = true,
    RetryDelay = 1
}

-- State Variables
local CurrentLevel = 0
local CurrentExp = 0
local TotalExpGained = 0
local LevelUps = 0
local StartTime = tick()

-- Logging Function
local function Log(message)
    print("[Legends Re:Written - EXP Boost] " .. message)
end

local function Warn(message)
    warn("[Legends Re:Written - EXP Boost] " .. message)
end

-- Explore the Data.Level structure
local function ExploreDataStructure()
    Log("========================================")
    Log("Exploring Data Structure...")
    Log("========================================")
    
    local data = ReplicatedStorage:FindFirstChild("Data")
    if not data then
        Warn("ERROR: Data folder not found in ReplicatedStorage!")
        return nil
    end
    
    Log("Found Data folder!")
    
    local level = data:FindFirstChild("Level")
    if not level then
        Warn("ERROR: Level object not found in Data folder!")
        Log("Available objects in Data:")
        for _, child in pairs(data:GetChildren()) do
            Log("  - " .. child.Name .. " (" .. child.ClassName .. ")")
        end
        return nil
    end
    
    Log("Found Level object: " .. level.ClassName)
    
    -- Explore Level object children
    Log("\nLevel object contents:")
    for _, child in pairs(level:GetChildren()) do
        Log("  - " .. child.Name .. " (" .. child.ClassName .. ")")
        if child:IsA("ValueBase") then
            Log("    Value: " .. tostring(child.Value))
        end
    end
    
    Log("\nLevel object properties:")
    if level:IsA("ValueBase") then
        Log("  Value: " .. tostring(level.Value))
    end
    
    return level
end

-- Get player's current level data
local function GetPlayerLevelData()
    local data = ReplicatedStorage:FindFirstChild("Data")
    if data then
        local level = data:FindFirstChild("Level")
        if level then
            return level
        end
    end
    
    if Player:FindFirstChild("Data") then
        local playerData = Player.Data
        if playerData:FindFirstChild("Level") then
            return playerData.Level
        end
        if playerData:FindFirstChild("Experience") or playerData:FindFirstChild("Exp") or playerData:FindFirstChild("XP") then
            return playerData
        end
    end
    
    local playerGui = Player:FindFirstChild("PlayerGui")
    if playerGui then
        for _, gui in pairs(playerGui:GetDescendants()) do
            if gui.Name:lower():find("level") or gui.Name:lower():find("exp") or gui.Name:lower():find("xp") then
                if gui:IsA("TextLabel") or gui:IsA("TextBox") then
                    Log("Found potential level UI: " .. gui:GetFullName())
                end
            end
        end
    end
    
    return nil
end

-- Find all EXP-related remotes
local function FindExpRemotes()
    Log("========================================")
    Log("Searching for EXP-related remotes...")
    Log("========================================")
    
    local remotes = {}
    
    for _, descendant in pairs(ReplicatedStorage:GetDescendants()) do
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            local name = descendant.Name:lower()
            if name:find("exp") or name:find("xp") or name:find("level") or name:find("gain") or name:find("reward") or name:find("quest") or name:find("complete") or name:find("claim") then
                table.insert(remotes, descendant)
                Log("Found: " .. descendant:GetFullName() .. " (" .. descendant.ClassName .. ")")
            end
        end
    end
    
    if #remotes == 0 then
        Warn("No EXP-related remotes found!")
        Log("Searching all remotes...")
        for _, descendant in pairs(ReplicatedStorage:GetDescendants()) do
            if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
                Log("  - " .. descendant:GetFullName() .. " (" .. descendant.ClassName .. ")")
            end
        end
    end
    
    return remotes
end

-- Try to boost EXP directly
local function BoostExpDirect()
    Log("Attempting direct EXP boost...")
    
    local levelData = GetPlayerLevelData()
    if not levelData then
        Warn("Could not find player level data!")
        return false
    end
    
    local expFields = {"Experience", "Exp", "XP", "CurrentExp", "CurrentXP"}
    local levelFields = {"Level", "CurrentLevel", "LVL"}
    
    for _, field in pairs(expFields) do
        local expObj = levelData:FindFirstChild(field)
        if expObj and expObj:IsA("ValueBase") then
            local currentValue = expObj.Value
            local success, err = pcall(function()
                expObj.Value = currentValue + Config.ExpPerAction
            end)
            
            if success then
                Log("Successfully added " .. Config.ExpPerAction .. " EXP via " .. field)
                return true
            else
                Warn("Failed to modify " .. field .. ": " .. tostring(err))
            end
        end
    end
    
    for _, field in pairs(levelFields) do
        local levelObj = levelData:FindFirstChild(field)
        if levelObj and levelObj:IsA("ValueBase") then
            Log("Current " .. field .. ": " .. tostring(levelObj.Value))
        end
    end
    
    return false
end

-- Try invoking EXP remotes
local function InvokeExpRemotes()
    Log("Attempting remote invocations...")
    
    local remotes = FindExpRemotes()
    local success = false
    
    for _, remote in pairs(remotes) do
        if remote:IsA("RemoteFunction") then
            local attempts = {
                function() return remote:InvokeServer(Config.ExpPerAction) end,
                function() return remote:InvokeServer("AddExp", Config.ExpPerAction) end,
                function() return remote:InvokeServer("GainExp", Config.ExpPerAction) end,
                function() return remote:InvokeServer("ClaimReward") end,
                function() return remote:InvokeServer("CompleteQuest") end,
                function() return remote:InvokeServer({Amount = Config.ExpPerAction}) end,
            }
            
            for i, attemptFunc in pairs(attempts) do
                local callSuccess, result = pcall(attemptFunc)
                if callSuccess then
                    Log("Success: " .. remote.Name .. " invoked (method " .. i .. ")")
                    if result then
                        Log("  Result: " .. tostring(result))
                    end
                    success = true
                end
            end
            
        elseif remote:IsA("RemoteEvent") then
            local attempts = {
                function() remote:FireServer(Config.ExpPerAction) end,
                function() remote:FireServer("AddExp", Config.ExpPerAction) end,
                function() remote:FireServer("GainExp", Config.ExpPerAction) end,
                function() remote:FireServer("ClaimReward") end,
                function() remote:FireServer("CompleteQuest") end,
                function() remote:FireServer({Amount = Config.ExpPerAction}) end,
            }
            
            for i, attemptFunc in pairs(attempts) do
                local callSuccess = pcall(attemptFunc)
                if callSuccess then
                    Log("Success: " .. remote.Name .. " fired (method " .. i .. ")")
                    success = true
                end
            end
        end
    end
    
    return success
end

-- Monitor level changes
local function MonitorLevelChanges()
    local levelData = GetPlayerLevelData()
    if not levelData then
        Warn("Cannot monitor level changes - data not found!")
        return
    end
    
    Log("Setting up level monitoring...")
    
    for _, child in pairs(levelData:GetDescendants()) do
        if child:IsA("ValueBase") then
            local fieldName = child.Name
            local lastValue = child.Value
            
            child:GetPropertyChangedSignal("Value"):Connect(function()
                local newValue = child.Value
                local change = newValue - (tonumber(lastValue) or 0)
                
                if Config.LogExpGains then
                    if change > 0 then
                        Log("Increased: " .. fieldName .. " " .. lastValue .. " -> " .. newValue .. " (+" .. change .. ")")
                        if fieldName:lower():find("exp") or fieldName:lower():find("xp") then
                            TotalExpGained = TotalExpGained + change
                        end
                        if fieldName:lower():find("level") or fieldName:lower():find("lvl") then
                            LevelUps = LevelUps + 1
                            Log("========================================")
                            Log("LEVEL UP! Now Level " .. newValue)
                            Log("Total EXP Gained: " .. TotalExpGained)
                            Log("Time Running: " .. math.floor(tick() - StartTime) .. "s")
                            Log("========================================")
                        end
                    elseif change < 0 then
                        Warn(fieldName .. " decreased: " .. lastValue .. " -> " .. newValue .. " (" .. change .. ")")
                    end
                end
                
                lastValue = newValue
            end)
            
            Log("Monitoring: " .. fieldName .. " = " .. tostring(child.Value))
        end
    end
end

-- Main EXP boost function
local function BoostExp()
    local success = false
    
    if BoostExpDirect() then
        success = true
    end
    
    wait(0.2)
    if InvokeExpRemotes() then
        success = true
    end
    
    return success
end

-- Get current stats
local function GetCurrentStats()
    local stats = {
        Level = "Unknown",
        Exp = "Unknown",
        TotalGained = TotalExpGained,
        LevelUps = LevelUps,
        Runtime = math.floor(tick() - StartTime)
    }
    
    local levelData = GetPlayerLevelData()
    if levelData then
        for _, child in pairs(levelData:GetDescendants()) do
            if child:IsA("ValueBase") then
                if child.Name:lower():find("level") or child.Name:lower():find("lvl") then
                    stats.Level = tostring(child.Value)
                elseif child.Name:lower():find("exp") or child.Name:lower():find("xp") then
                    stats.Exp = tostring(child.Value)
                end
            end
        end
    end
    
    return stats
end

-- Keyboard Controls
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.B then
        Log("Manual EXP boost triggered!")
        BoostExp()
    elseif input.KeyCode == Enum.KeyCode.N then
        Config.AutoBoost = not Config.AutoBoost
        Log("Auto-boost " .. (Config.AutoBoost and "ENABLED" or "DISABLED"))
    elseif input.KeyCode == Enum.KeyCode.I then
        Log("========================================")
        Log("Current Stats:")
        local stats = GetCurrentStats()
        Log("  Level: " .. stats.Level)
        Log("  Exp: " .. stats.Exp)
        Log("  Total EXP Gained: " .. stats.TotalGained)
        Log("  Level Ups: " .. stats.LevelUps)
        Log("  Runtime: " .. stats.Runtime .. "s")
        Log("========================================")
    elseif input.KeyCode == Enum.KeyCode.F then
        FindExpRemotes()
    elseif input.KeyCode == Enum.KeyCode.D then
        ExploreDataStructure()
    elseif input.KeyCode == Enum.KeyCode.M then
        Config.ExpMultiplier = Config.ExpMultiplier + 5
        Config.ExpPerAction = 1000 * Config.ExpMultiplier
        Log("EXP Multiplier increased to " .. Config.ExpMultiplier .. "x (" .. Config.ExpPerAction .. " exp per action)")
    elseif input.KeyCode == Enum.KeyCode.L then
        if Config.ExpMultiplier > 1 then
            Config.ExpMultiplier = Config.ExpMultiplier - 5
            Config.ExpPerAction = 1000 * Config.ExpMultiplier
            Log("EXP Multiplier decreased to " .. Config.ExpMultiplier .. "x (" .. Config.ExpPerAction .. " exp per action)")
        end
    end
end)

-- Initialize
Log("========================================")
Log("Legends Re:Written - EXP Boost")
Log("========================================")
Log("")
Log("Controls:")
Log("  B - Manually boost EXP")
Log("  N - Toggle auto-boost ON/OFF")
Log("  I - Show current stats")
Log("  F - Find EXP remotes")
Log("  D - Explore data structure")
Log("  M - Increase multiplier")
Log("  L - Decrease multiplier")
Log("")
Log("EXP Multiplier: " .. Config.ExpMultiplier .. "x")
Log("EXP Per Action: " .. Config.ExpPerAction)
Log("")

wait(2)
ExploreDataStructure()

if not Player.Character then
    Log("Waiting for character...")
    Player.CharacterAdded:Wait()
end

wait(1)

if Config.MonitorLevels then
    MonitorLevelChanges()
end

FindExpRemotes()

Log("")
Log("Initialization complete!")
Log("Press 'B' to boost EXP or 'N' to enable auto-boost")

task.spawn(function()
    while true do
        if Config.AutoBoost then
            BoostExp()
            wait(Config.RetryDelay)
        else
            wait(0.5)
        end
    end
end)

task.spawn(function()
    while true do
        wait(30)
        if TotalExpGained > 0 or LevelUps > 0 then
            local stats = GetCurrentStats()
            Log("--- Stats Update ---")
            Log("Level: " .. stats.Level .. " | EXP Gained: " .. stats.TotalGained .. " | Level Ups: " .. stats.LevelUps)
        end
    end
end)
