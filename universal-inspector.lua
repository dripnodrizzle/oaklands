--> Universal Inspector - Works on ANY Roblox Game
--> Real-time object detection and analysis
--> Raycast mode: See what you're looking at
--> Proximity mode: List nearby objects
--> Search mode: Find any object by name
--> Path finder: Get full object hierarchy
--> 100% Safe: Pure visual/informational tool

print("[Universal Inspector] Starting...")

local Services = setmetatable({}, {
    __index = function(self, index)
        return game:GetService(index)
    end
})

local Version = "v1.0-universal"
local Players = Services.Players
local Player = Players.LocalPlayer
local Camera = Services.Workspace.CurrentCamera
local UserInputService = Services.UserInputService
local RunService = Services.RunService

print("[Universal Inspector] Loaded - Works on ANY game")
print("===== INSPECTOR COMMANDS =====")
print("_G.RaycastMode = true/false       -- Enable/disable mouse-over inspection")
print("_G.ProximityMode = true/false     -- Enable/disable proximity (nearby items)")
print("_G.HighlightMode = true/false     -- Highlight objects on mouse-over")
print("_G.MouseOverDelay = 0.3           -- Hover delay before showing info")
print("_G.InspectDistance = 1000         -- Set raycast max distance")
print("_G.ProximityRadius = 500          -- Set proximity search radius")
print("_G.ShowBoringParts = false        -- Hide generic parts, focus on NPCs/items/actions")
print("_G.InspectObject('name')          -- Find and inspect specific object")
print("_G.FindByClass('ClassName')       -- Find all objects of a class")
print("_G.GetObjectPath(object)          -- Get full path to object")
print("_G.ListChildren(object)           -- List all children of object")
print("_G.ShowProperties(object)         -- Show all properties of object")
print("_G.ShowStats(object)              -- Show humanoid/object stats")
print("_G.ShowAttributes(object)         -- Show custom attributes")
print("_G.ShowActions(object)            -- Show available interactions")
print("==============================")

--> CONFIGURATION
_G.RaycastMode = true  -- Auto-enabled for mouse-over inspection
_G.ProximityMode = false
_G.HighlightMode = true  -- Auto-enabled for visual feedback
_G.InspectDistance = 1000
_G.ProximityRadius = 500
_G.MouseOverDelay = 0.3  -- Delay before showing info (seconds)
_G.ShowBoringParts = false  -- Set true to show generic parts without special properties

--> HIGHLIGHT MANAGEMENT
local activeHighlights = {}

local function CreateHighlight(obj)
    if not obj or not obj:IsA("Instance") then return nil end
    
    -- Remove existing highlight if any
    if activeHighlights[obj] then
        pcall(function() activeHighlights[obj]:Destroy() end)
    end
    
    local success, highlight = pcall(function()
        local h = Instance.new("Highlight")
        h.FillColor = Color3.fromRGB(0, 255, 255)
        h.OutlineColor = Color3.fromRGB(0, 200, 255)
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
        h.Parent = obj
        return h
    end)
    
    if success then
        activeHighlights[obj] = highlight
        return highlight
    end
    return nil
end

local function RemoveHighlight(obj)
    if activeHighlights[obj] then
        pcall(function() activeHighlights[obj]:Destroy() end)
        activeHighlights[obj] = nil
    end
end

local function ClearAllHighlights()
    for obj, highlight in pairs(activeHighlights) do
        pcall(function() highlight:Destroy() end)
    end
    activeHighlights = {}
end

local function IsInterestingObject(obj)
    if not obj then return false end
    
    -- Always show if setting is enabled
    if _G.ShowBoringParts then return true end
    
    -- Check for gameplay-relevant properties
    if obj:IsA("Model") then
        -- Has humanoid (NPC/character)
        if obj:FindFirstChildOfClass("Humanoid") then return true end
        -- Has primary part (likely important model)
        if obj.PrimaryPart then return true end
    end
    
    -- Tools/Items
    if obj:IsA("Tool") or obj:IsA("Accessory") then return true end
    
    -- Interactive elements
    if obj:FindFirstChildWhichIsA("ClickDetector", true) then return true end
    if obj:FindFirstChildWhichIsA("ProximityPrompt", true) then return true end
    if obj:FindFirstChildWhichIsA("Attachment", true) then return true end
    
    -- Has custom attributes (game-specific data)
    local attrs = obj:GetAttributes()
    for _ in pairs(attrs) do return true end
    
    -- Has configuration or stats
    if obj:FindFirstChild("Configuration") or obj:FindFirstChild("Stats") then return true end
    
    -- Special part names that might be important
    if obj:IsA("BasePart") then
        local name = obj.Name:lower()
        if name:find("shop") or name:find("buy") or name:find("sell") or 
           name:find("npc") or name:find("item") or name:find("weapon") or
           name:find("door") or name:find("chest") or name:find("interact") then
            return true
        end
    end
    
    -- Skip generic parts
    return false
end

--> RAYCAST INSPECTOR
task.spawn(function()
    print("[Raycast] Mouse-over inspection enabled")
    print("[Raycast] RaycastMode = " .. tostring(_G.RaycastMode))
    print("[Raycast] HighlightMode = " .. tostring(_G.HighlightMode))
    local lastPrintedObj = nil
    local lastHighlightObj = nil
    local currentHoverObj = nil
    local hoverStartTime = 0

    while true do
        task.wait(0.05)  -- More responsive
        if _G.RaycastMode then
            pcall(function()
                local now = tick()
                
                local mouse = Player:GetMouse()
                
                -- Create raycast from camera through mouse position
                local unitRay = Camera:ScreenPointToRay(mouse.X, mouse.Y)
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                
                local charTable = {}
                if Player.Character then
                    table.insert(charTable, Player.Character)
                end
                raycastParams.FilterDescendantsInstances = charTable
                
                local rayResult = Services.Workspace:Raycast(unitRay.Origin, unitRay.Direction * _G.InspectDistance, raycastParams)
                
                if rayResult then
                    local hit = rayResult.Instance
                    local distance = math.floor((rayResult.Position - Camera.CFrame.Position).Magnitude)
                    
                    -- Try to find parent Model or Character
                    local target = hit
                    
                    -- Check if part belongs to a character/NPC (has Humanoid ancestor)
                    local checkParent = hit.Parent
                    while checkParent and checkParent ~= Services.Workspace do
                        if checkParent:IsA("Model") then
                            local humanoid = checkParent:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                target = checkParent
                                break
                            end
                        end
                        checkParent = checkParent.Parent
                    end
                    
                    -- If no humanoid found, just use immediate parent if it's a model
                    if target == hit and hit.Parent and hit.Parent:IsA("Model") then
                        target = hit.Parent
                    end
                    
                    -- Skip if not interesting
                    if not IsInterestingObject(target) then
                        if lastHighlightObj then
                            RemoveHighlight(lastHighlightObj)
                            lastHighlightObj = nil
                        end
                        currentHoverObj = nil
                        lastPrintedObj = nil
                        return
                    end
                    
                    -- Track hover duration
                    if target ~= currentHoverObj then
                        currentHoverObj = target
                        hoverStartTime = now
                    end
                    
                    local hoverDuration = now - hoverStartTime
                    -- Only print if it's a new object AND hover delay is met
                    local shouldPrint = (target ~= lastPrintedObj) and (hoverDuration >= (_G.MouseOverDelay or 0.3))
                
                -- Highlight if enabled
                if _G.HighlightMode then
                    if target ~= lastHighlightObj then
                        if lastHighlightObj then
                            RemoveHighlight(lastHighlightObj)
                        end
                        CreateHighlight(target)
                        lastHighlightObj = target
                    end
                else
                    if lastHighlightObj then
                        RemoveHighlight(lastHighlightObj)
                        lastHighlightObj = nil
                    end
                end
                
                if shouldPrint then
                    lastPrintedObj = target

                    -- Get additional info
                    local info = {
                        Name = target.Name,
                        Class = target.ClassName,
                        Distance = distance .. "m",
                        Path = target:GetFullName()
                    }

                    -- Add type-specific info
                    if target:IsA("Part") or target:IsA("MeshPart") then
                        info.Size = string.format("%.1f,%.1f,%.1f", target.Size.X, target.Size.Y, target.Size.Z)
                        info.Material = tostring(target.Material)
                        info.Transparency = target.Transparency
                        info.CanCollide = tostring(target.CanCollide)
                    elseif target:IsA("Model") then
                        local primPart = target.PrimaryPart
                        if primPart then
                            info.PrimaryPart = primPart.Name
                        end
                        
                        -- Check for Humanoid (NPC/Player)
                        local humanoid = target:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            info.Type = "⚔️ NPC/Character"
                            info.Health = string.format("%.1f/%.1f (%.0f%%)", humanoid.Health, humanoid.MaxHealth, (humanoid.Health/humanoid.MaxHealth)*100)
                            info.WalkSpeed = humanoid.WalkSpeed
                            info.JumpPower = humanoid.JumpPower
                            if humanoid.DisplayName ~= target.Name then
                                info.DisplayName = humanoid.DisplayName
                            end
                            
                            -- Check for weapons/tools
                            for _, child in ipairs(target:GetChildren()) do
                                if child:IsA("Tool") then
                                    info.Equipped = child.Name
                                    break
                                end
                            end
                        end
                    elseif target:IsA("Tool") then
                        info.Type = "🗡️ Item/Weapon"
                        if target.ToolTip ~= "" then
                            info.Description = target.ToolTip
                        end
                        -- Check for damage stats
                        local config = target:FindFirstChild("Configuration")
                        if config then
                            for _, stat in ipairs(config:GetChildren()) do
                                if stat:IsA("NumberValue") or stat:IsA("IntValue") then
                                    info[stat.Name] = tostring(stat.Value)
                                end
                            end
                        end
                    elseif target:IsA("Accessory") then
                        info.Type = "👕 Accessory"
                    end

                    -- Check for attributes
                    local attrs = target:GetAttributes()
                    local attrCount = 0
                    for _ in pairs(attrs) do attrCount = attrCount + 1 end
                    if attrCount > 0 then
                        info.Attributes = attrCount .. " custom attributes"
                    end

                    -- Check for interactive elements (check both hit part and target model)
                    local clickDetector = hit:FindFirstChildOfClass("ClickDetector") or target:FindFirstChildOfClass("ClickDetector")
                    local proximityPrompt = hit:FindFirstChildOfClass("ProximityPrompt") or target:FindFirstChildOfClass("ProximityPrompt")
                    
                    -- Also check descendants for interactions
                    if not clickDetector then
                        clickDetector = target:FindFirstChildWhichIsA("ClickDetector", true)
                    end
                    if not proximityPrompt then
                        proximityPrompt = target:FindFirstChildWhichIsA("ProximityPrompt", true)
                    end
                    
                    if clickDetector then
                        info.Interaction = "🖱️ Clickable"
                        info.ClickRange = string.format("%.1fm", clickDetector.MaxActivationDistance)
                    elseif proximityPrompt then
                        info.Interaction = string.format("💬 %s", proximityPrompt.ActionText)
                        if proximityPrompt.ObjectText ~= "" then
                            info.Object = proximityPrompt.ObjectText
                        end
                        info.PromptRange = string.format("%.1fm", proximityPrompt.MaxActivationDistance)
                    end

                    print("\n[RAYCAST] ============================")
                    for key, value in pairs(info) do
                        print(string.format("  %s: %s", key, value))
                    end
                    print("======================================\n")
                end
            else
                currentHoverObj = nil
                hoverStartTime = 0
                lastPrintedObj = nil
                if lastHighlightObj then
                    RemoveHighlight(lastHighlightObj)
                    lastHighlightObj = nil
                end
            end
            end)
                end
            end
        else
            -- Clean up highlight when raycast disabled
            if lastHighlightObj then
                RemoveHighlight(lastHighlightObj)
                lastHighlightObj = nil
            end
        end
    end
end)

--> PROXIMITY INSPECTOR
task.spawn(function()
    print("[Proximity] Mode initialized")
    local lastScan = 0
    
    while true do
        task.wait(1)
        if _G.ProximityMode then
            local now = tick()
            if now - lastScan >= 5 then
                lastScan = now
                
                local char = Player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then
                    print("[Proximity] Character not found")
                else
                    local hrp = char.HumanoidRootPart
                    local nearby = {}
                    
                    for _, v in ipairs(Services.Workspace:GetDescendants()) do
                        pcall(function()
                            local pos
                            if v:IsA("Model") then
                                if v.GetPivot then
                                    pos = v:GetPivot().Position
                                elseif v.PrimaryPart then
                                    pos = v.PrimaryPart.Position
                                end
                            elseif v:IsA("BasePart") then
                                pos = v.Position
                            end
                            
                            if pos then
                                local dist = (pos - hrp.Position).Magnitude
                                if dist < _G.ProximityRadius then
                                    table.insert(nearby, {
                                        name = v.Name,
                                        class = v.ClassName,
                                        distance = math.floor(dist),
                                        path = v:GetFullName(),
                                        object = v
                                    })
                                end
                            end
                        end)
                    end
                    
                    table.sort(nearby, function(a, b) return a.distance < b.distance end)
                    
                    print("\n[PROXIMITY] ============================")
                    print(string.format("Found %d objects within %dm:", #nearby, _G.ProximityRadius))
                    for i, obj in ipairs(nearby) do
                        if i <= 25 then  -- Show top 25
                            print(string.format("  %d. [%dm] %s (%s)", i, obj.distance, obj.name, obj.class))
                        end
                    end
                    if #nearby > 25 then
                        print(string.format("  ... and %d more", #nearby - 25))
                    end
                    print("======================================\n")
                end
            end
        end
    end
end)

--> HELPER: Inspect specific object by name
_G.InspectObject = function(objectName)
    print("[INSPECT] Searching for: " .. objectName)
    local found = {}
    
    for _, v in ipairs(Services.Workspace:GetDescendants()) do
        if v.Name:lower():find(objectName:lower()) then
            table.insert(found, v)
        end
    end
    
    if #found == 0 then
        print("[INSPECT] Object '" .. objectName .. "' not found")
        return nil
    end
    
    print(string.format("[INSPECT] Found %d matches:", #found))
    for i, obj in ipairs(found) do
        if i <= 10 then
            print(string.format("  %d. %s (%s) - %s", i, obj.Name, obj.ClassName, obj:GetFullName()))
        end
    end
    
    if #found > 10 then
        print(string.format("  ... and %d more", #found - 10))
    end
    
    return found
end

--> HELPER: Find all objects of a specific class
_G.FindByClass = function(className, limit)
    limit = limit or 25
    print("[FIND] Searching for class: " .. className)
    local found = {}
    
    for _, v in ipairs(Services.Workspace:GetDescendants()) do
        if v.ClassName == className then
            table.insert(found, v)
        end
    end
    
    print(string.format("[FIND] Found %d objects of class '%s':", #found, className))
    for i = 1, math.min(#found, limit) do
        local obj = found[i]
        local parent = obj.Parent and obj.Parent.Name or "nil"
        print(string.format("  %d. %s (Parent: %s)", i, obj.Name, parent))
    end
    
    if #found > limit then
        print(string.format("  ... and %d more (set limit higher to see more)", #found - limit))
    end
    
    return found
end

--> HELPER: Get full path to object
_G.GetObjectPath = function(obj)
    if not obj or not obj:IsA("Instance") then
        print("[PATH] Invalid object")
        return nil
    end
    
    local path = obj:GetFullName()
    print("[PATH] " .. path)
    return path
end

--> HELPER: List all children of object
_G.ListChildren = function(obj)
    if not obj or not obj:IsA("Instance") then
        print("[CHILDREN] Invalid object")
        return {}
    end
    
    local children = obj:GetChildren()
    print(string.format("[CHILDREN] %s has %d children:", obj.Name, #children))
    
    for i, child in ipairs(children) do
        print(string.format("  %d. %s (%s)", i, child.Name, child.ClassName))
    end
    
    return children
end

--> HELPER: Show properties of object
_G.ShowProperties = function(obj)
    if not obj or not obj:IsA("Instance") then
        print("[PROPERTIES] Invalid object")
        return
    end
    
    print(string.format("[PROPERTIES] %s (%s):", obj.Name, obj.ClassName))
    
    -- Common properties to check
    local properties = {
        "Parent", "Name", "ClassName", "Archivable",
        "Position", "Size", "CFrame", "Transparency",
        "Color", "Material", "Anchored", "CanCollide",
        "Velocity", "Health", "MaxHealth", "WalkSpeed"
    }
    
    for _, prop in ipairs(properties) do
        local success, value = pcall(function()
            return obj[prop]
        end)
        
        if success and value ~= nil then
            local valueStr = tostring(value)
            if #valueStr > 50 then
                valueStr = valueStr:sub(1, 50) .. "..."
            end
            print(string.format("  %s: %s", prop, valueStr))
        end
    end
end

--> HELPER: Show stats (Humanoids, etc)
_G.ShowStats = function(obj)
    if not obj or not obj:IsA("Instance") then
        print("[STATS] Invalid object")
        return
    end

    print(string.format("[STATS] %s (%s):", obj.Name, obj.ClassName))

    -- Check for Humanoid
    local humanoid = obj:FindFirstChildOfClass("Humanoid")
    if humanoid then
        print("  === Humanoid Stats ===")
        print(string.format("  Health: %.1f / %.1f", humanoid.Health, humanoid.MaxHealth))
        print(string.format("  WalkSpeed: %.1f", humanoid.WalkSpeed))
        print(string.format("  JumpPower: %.1f", humanoid.JumpPower))
        print(string.format("  JumpHeight: %.1f", humanoid.JumpHeight))
        print(string.format("  DisplayName: %s", humanoid.DisplayName))
        print(string.format("  Sit: %s", tostring(humanoid.Sit)))
        print(string.format("  PlatformStand: %s", tostring(humanoid.PlatformStand)))
        
        -- Check for custom states
        local state = humanoid:GetState()
        print(string.format("  State: %s", tostring(state)))
    end

    -- Check for Configuration/NumberValue/IntValue stats
    local config = obj:FindFirstChild("Configuration") or obj:FindFirstChild("Stats")
    if config then
        print("  === Custom Stats ===")
        for _, child in ipairs(config:GetChildren()) do
            if child:IsA("ValueBase") then
                print(string.format("  %s: %s", child.Name, tostring(child.Value)))
            end
        end
    end

    -- Check player stats if it's a player character
    if obj.Name == Player.Name or (obj.Parent and obj.Parent == Services.Workspace) then
        local player = Players:GetPlayerFromCharacter(obj)
        if player then
            print("  === Player Stats ===")
            print(string.format("  UserId: %d", player.UserId))
            print(string.format("  AccountAge: %d days", player.AccountAge))
            
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                print("  === Leaderstats ===")
                for _, stat in ipairs(leaderstats:GetChildren()) do
                    if stat:IsA("ValueBase") then
                        print(string.format("  %s: %s", stat.Name, tostring(stat.Value)))
                    end
                end
            end
        end
    end
end

--> HELPER: Show custom attributes
_G.ShowAttributes = function(obj)
    if not obj or not obj:IsA("Instance") then
        print("[ATTRIBUTES] Invalid object")
        return
    end

    local attrs = obj:GetAttributes()
    local count = 0
    for _ in pairs(attrs) do count = count + 1 end

    print(string.format("[ATTRIBUTES] %s has %d custom attributes:", obj.Name, count))

    if count == 0 then
        print("  (No custom attributes)")
    else
        for name, value in pairs(attrs) do
            local valueStr = tostring(value)
            if #valueStr > 50 then
                valueStr = valueStr:sub(1, 50) .. "..."
            end
            print(string.format("  %s: %s", name, valueStr))
        end
    end
end

--> HELPER: Show available actions/interactions
_G.ShowActions = function(obj)
    if not obj or not obj:IsA("Instance") then
        print("[ACTIONS] Invalid object")
        return
    end

    print(string.format("[ACTIONS] %s (%s):", obj.Name, obj.ClassName))
    local actionCount = 0

    -- Check for ClickDetector
    for _, child in ipairs(obj:GetDescendants()) do
        if child:IsA("ClickDetector") then
            actionCount = actionCount + 1
            local parent = child.Parent
            print(string.format("  [ClickDetector] Clickable: %s", parent.Name))
            print(string.format("    MaxActivationDistance: %.1f", child.MaxActivationDistance))
        end
    end

    -- Check for ProximityPrompt
    for _, child in ipairs(obj:GetDescendants()) do
        if child:IsA("ProximityPrompt") then
            actionCount = actionCount + 1
            print(string.format("  [ProximityPrompt] %s", child.ActionText))
            print(string.format("    ObjectText: %s", child.ObjectText))
            print(string.format("    MaxActivationDistance: %.1f", child.MaxActivationDistance))
            print(string.format("    KeyboardKeyCode: %s", tostring(child.KeyboardKeyCode)))
        end
    end

    -- Check for Tool
    if obj:IsA("Tool") then
        actionCount = actionCount + 1
        print("  [Tool] Equippable item")
        if obj.ToolTip ~= "" then
            print(string.format("    ToolTip: %s", obj.ToolTip))
        end
    end

    -- Check for Touchable parts
    if obj:IsA("BasePart") and not obj.CanCollide then
        actionCount = actionCount + 1
        print("  [TouchPart] May trigger on touch")
        print(string.format("    CanCollide: %s", tostring(obj.CanCollide)))
    end

    if actionCount == 0 then
        print("  (No interactive elements found)")
    end
end

--> HELPER: Clear highlights
_G.ClearHighlights = function()
    ClearAllHighlights()
    print("[Inspector] All highlights cleared")
end

--> HELPER: Get game info
_G.GetGameInfo = function()
    print("\n[GAME INFO] ============================")
    print("  Place ID: " .. game.PlaceId)
    print("  Job ID: " .. (game.JobId or "N/A"))
    print("  Creator ID: " .. game.CreatorId)
    print("  Creator Type: " .. tostring(game.CreatorType))
    if Services.MarketplaceService then
        local success, info = pcall(function()
            return Services.MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        if success and info then
            print("  Game Name: " .. (info.Name or "Unknown"))
            print("  Description: " .. (info.Description or "N/A"):sub(1, 100))
        end
    end
    print("======================================\n")
end

print("[Universal Inspector] Ready!")
print("")
print("===== QUICK START =====")
print("Mouse-over mode ENABLED - Focuses on NPCs, items, and interactions!")
print("_G.MouseOverDelay = 0.1         -- Faster inspection (default: 0.3s)")
print("_G.ShowBoringParts = true       -- Show ALL parts (default: only game objects)")
print("_G.RaycastMode = false          -- Disable mouse-over inspection")
print("_G.HighlightMode = false        -- Disable highlights")
print("_G.ProximityMode = true         -- List nearby objects every 5s")
print("_G.InspectObject('part_name')   -- Search for specific object")
print("_G.FindByClass('Part')          -- Find all objects of a class")
print("_G.ShowStats(object)            -- Show NPC/character stats")
print("_G.ShowAttributes(object)       -- Show custom attributes")
print("_G.ShowActions(object)          -- Show clickable/interactive elements")
print("_G.GetGameInfo()                -- Show game information")
print("_G.ClearHighlights()            -- Clear all highlights")
print("=======================")
print("")
print("[Universal Inspector] Works on ANY Roblox game!")
print("[Universal Inspector] 100% Safe - Pure informational tool")
