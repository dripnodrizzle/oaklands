--> Player Luck Checker
--> Displays your current luck stat

print("[Luck Checker] Searching for luck stat...")
print("")

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Search for luck in various locations
local function FindLuck()
    local locations = {
        Player:FindFirstChild("PlayerStats"),
        Player:FindFirstChild("Stats"),
        Player:FindFirstChild("leaderstats"),
        Player:FindFirstChild("PlayerData"),
        Player:FindFirstChild("Data")
    }
    
    -- Add character location
    if Player.Character then
        table.insert(locations, Player.Character:FindFirstChild("Stats"))
        table.insert(locations, Player.Character:FindFirstChild("PlayerStats"))
    end
    
    -- Search each location
    for _, location in ipairs(locations) do
        if location then
            -- Direct luck value
            local luck = location:FindFirstChild("Luck") 
                or location:FindFirstChild("luck")
                or location:FindFirstChild("LUCK")
            
            if luck then
                return luck, location:GetFullName()
            end
            
            -- Search deeper
            for _, child in ipairs(location:GetDescendants()) do
                if string.lower(child.Name):find("luck") then
                    return child, location:GetFullName()
                end
            end
        end
    end
    
    return nil
end

-- Try to find luck
local luckStat, location = FindLuck()

if luckStat then
    local value
    if luckStat:IsA("IntValue") or luckStat:IsA("NumberValue") then
        value = luckStat.Value
    elseif luckStat:IsA("StringValue") then
        value = luckStat.Value
    else
        value = tostring(luckStat)
    end
    
    print("=" .. string.rep("=", 50))
    print("YOUR LUCK STAT")
    print("=" .. string.rep("=", 50))
    print(string.format("Luck: %s", tostring(value)))
    print(string.format("Location: %s.%s", location, luckStat.Name))
    print(string.format("Type: %s", luckStat.ClassName))
    print("=" .. string.rep("=", 50))
    
    -- Monitor changes
    if luckStat:IsA("IntValue") or luckStat:IsA("NumberValue") then
        print("")
        print("[Luck Checker] Monitoring for changes...")
        
        luckStat.Changed:Connect(function(newValue)
            print(string.format("[Luck Changed] %s -> %s", tostring(value), tostring(newValue)))
            value = newValue
        end)
        
        _G.GetLuck = function()
            return luckStat.Value
        end
        
        print("Get current luck anytime: _G.GetLuck()")
    end
else
    print("=" .. string.rep("=", 50))
    print("LUCK STAT NOT FOUND")
    print("=" .. string.rep("=", 50))
    print("")
    print("Searching all player stats...")
    print("")
    
    -- Show all available stats
    local function ShowStats(location, name)
        if location then
            print(string.format("[%s]", name))
            for _, child in ipairs(location:GetChildren()) do
                if child:IsA("IntValue") or child:IsA("NumberValue") or child:IsA("StringValue") then
                    print(string.format("  %s: %s", child.Name, tostring(child.Value)))
                end
            end
            print("")
        end
    end
    
    ShowStats(Player:FindFirstChild("PlayerStats"), "PlayerStats")
    ShowStats(Player:FindFirstChild("Stats"), "Stats")
    ShowStats(Player:FindFirstChild("leaderstats"), "leaderstats")
    ShowStats(Player:FindFirstChild("PlayerData"), "PlayerData")
    ShowStats(Player:FindFirstChild("Data"), "Data")
    
    if Player.Character then
        ShowStats(Player.Character:FindFirstChild("Stats"), "Character.Stats")
    end
    
    print("If luck exists, it might be named differently.")
    print("Check the list above for similar stats.")
end
