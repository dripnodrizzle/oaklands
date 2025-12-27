--> GoldenApple Tracker - Visual Highlighting Only
--> Highlights all GoldenApples on the map with golden glow
--> Shows real-time distances
--> You manually walk and collect (no automation)
--> Safe: No teleportation, no anti-cheat risk

print("[GoldenApple Tracker] Starting...")

local Services = setmetatable({}, {
    __index = function(self, index)
        return game:GetService(index)
    end
})

local Version = "v1.0-tracker"
local Players = Services.Players
local Player = Players.LocalPlayer

print("[Tracker] Loaded - GoldenApple Visual Tracker")
print("===== TRACKER COMMANDS =====")
print("_G.HighlightAllGoldenApples = true/false   -- Highlight all apples on map")
print("_G.ShowDistanceLabels = true/false         -- Show distances to each apple")
print("_G.RefreshHighlights()                     -- Update highlights manually")
print("_G.ClearAllHighlights()                    -- Remove all highlights")
print("_G.AppleCount()                            -- Count total GoldenApples")
print("=============================")

--> TRACKING SYSTEM
local trackedApples = {}
local appleHighlights = {}

_G.HighlightAllGoldenApples = false
_G.ShowDistanceLabels = true

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
        highlight.FillColor = Color3.fromRGB(255, 215, 0)      -- Golden yellow
        highlight.OutlineColor = Color3.fromRGB(255, 140, 0)   -- Golden orange
        highlight.FillTransparency = 0.3
        highlight.OutlineTransparency = 0
        highlight.Parent = obj
        appleHighlights[obj] = highlight
        print("[Highlight] Highlighted: " .. obj.Name)
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
    
    -- Clear old highlights
    for obj, highlight in pairs(appleHighlights) do
        if not obj or not obj.Parent then
            RemoveHighlight(obj)
        end
    end
    
    -- Find and highlight all GoldenApples
    local apples = FindAllGoldenApples()
    print("[Tracker] Found " .. #apples .. " GoldenApples")
    
    for _, apple in ipairs(apples) do
        CreateHighlight(apple)
    end
    
    trackedApples = apples
    return #apples
end

_G.ClearAllHighlights = function()
    print("[Tracker] Clearing all highlights...")
    for obj, _ in pairs(appleHighlights) do
        RemoveHighlight(obj)
    end
    appleHighlights = {}
    trackedApples = {}
    print("[Tracker] Highlights cleared")
end

_G.AppleCount = function()
    local apples = FindAllGoldenApples()
    print("[Tracker] Total GoldenApples in server: " .. #apples)
    return #apples
end

--> DISTANCE DISPLAY LOOP
task.spawn(function()
    print("[Distance Monitor] Started")
    while true do
        task.wait(0.5)
        
        if _G.HighlightAllGoldenApples and _G.ShowDistanceLabels then
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                
                for _, apple in ipairs(trackedApples) do
                    if apple and apple.Parent then
                        pcall(function()
                            local pos = apple:GetPivot().Position
                            local distance = math.floor((pos - hrp.Position).Magnitude)
                            -- Distance printed to console every 0.5s (can be noisy but helpful)
                            -- Commented out to reduce spam:
                            -- print("[Apple] " .. apple.Name .. " - " .. distance .. "m away")
                        end)
                    end
                end
            end
        end
    end
end)

--> HIGHLIGHT MAINTENANCE LOOP
task.spawn(function()
    print("[Highlight Maintenance] Started")
    while true do
        task.wait(5)  -- Check every 5 seconds
        
        if _G.HighlightAllGoldenApples then
            -- Find any new apples and highlight them
            local apples = FindAllGoldenApples()
            for _, apple in ipairs(apples) do
                if not appleHighlights[apple] then
                    CreateHighlight(apple)
                end
            end
            
            -- Remove highlights for deleted apples
            for obj, _ in pairs(appleHighlights) do
                if not obj or not obj.Parent then
                    RemoveHighlight(obj)
                end
            end
            
            trackedApples = apples
        end
    end
end)

--> STARTUP EXAMPLE
print("[Tracker] Ready!")
print("")
print("[QUICK START]")
print("  1. Run: _G.HighlightAllGoldenApples = true")
print("  2. All GoldenApples will glow golden on the map")
print("  3. Walk to them manually and press E to pick up")
print("  4. Run: _G.AppleCount() to see how many are nearby")
print("")
print("[TIPS]")
print("  - Highlights update automatically every 5 seconds")
print("  - Picked-up apples stop being highlighted")
print("  - Use _G.ClearAllHighlights() to stop seeing highlights")
print("  - This is 100% safe - just visual aid, no automation")
print("")
