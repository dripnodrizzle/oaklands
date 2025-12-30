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
print("_G.RaycastMode = true/false       -- Enable/disable raycast (look at items)")
print("_G.ProximityMode = true/false     -- Enable/disable proximity (nearby items)")
print("_G.HighlightMode = true/false     -- Highlight looked-at objects")
print("_G.InspectDistance = 1000         -- Set raycast max distance")
print("_G.ProximityRadius = 500          -- Set proximity search radius")
print("_G.InspectObject('name')          -- Find and inspect specific object")
print("_G.FindByClass('ClassName')       -- Find all objects of a class")
print("_G.GetObjectPath(object)          -- Get full path to object")
print("_G.ListChildren(object)           -- List all children of object")
print("_G.ShowProperties(object)         -- Show all properties of object")
print("==============================")

--> CONFIGURATION
_G.RaycastMode = false
_G.ProximityMode = false
_G.HighlightMode = false
_G.InspectDistance = 1000
_G.ProximityRadius = 500

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

--> RAYCAST INSPECTOR
task.spawn(function()
    print("[Raycast] Mode initialized")
    local lastPrint = 0
    local lastHighlightObj = nil
    
    while true do
        task.wait(0.1)
        if _G.RaycastMode then
            local now = tick()
            
            -- Print every 0.5s to avoid spam
            local shouldPrint = (now - lastPrint >= 0.5)
            
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
                
                -- Try to find parent Model
                local target = hit
                if hit.Parent and hit.Parent:IsA("Model") then
                    target = hit.Parent
                end
                
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
                    lastPrint = now
                    
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
                    elseif target:IsA("Model") then
                        local primPart = target.PrimaryPart
                        if primPart then
                            info.PrimaryPart = primPart.Name
                        end
                    end
                    
                    print("\n[RAYCAST] ============================")
                    for key, value in pairs(info) do
                        print(string.format("  %s: %s", key, value))
                    end
                    print("======================================\n")
                end
            else
                if lastHighlightObj then
                    RemoveHighlight(lastHighlightObj)
                    lastHighlightObj = nil
                end
                if shouldPrint then
                    lastPrint = now
                    print("[RAYCAST] Nothing in view")
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
print("_G.RaycastMode = true           -- Look at objects to inspect them")
print("_G.HighlightMode = true         -- Highlight objects you look at")
print("_G.ProximityMode = true         -- List nearby objects every 5s")
print("_G.InspectObject('part_name')   -- Search for specific object")
print("_G.FindByClass('Part')          -- Find all objects of a class")
print("_G.GetGameInfo()                -- Show game information")
print("_G.ClearHighlights()            -- Clear all highlights")
print("=======================")
print("")
print("[Universal Inspector] Works on ANY Roblox game!")
print("[Universal Inspector] 100% Safe - Pure informational tool")
