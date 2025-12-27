--> Object Inspector - Real-time Item Detection
--> Raycast mode: See what you're looking at
--> Proximity mode: List nearby objects
--> Shows: Name, Class, Distance, Full Path

print("[Inspector] Starting...")

local Services = setmetatable({}, {
    __index = function(self, index)
        return game:GetService(index)
    end
})

local Version = "v1.0-inspector"
local Players = Services.Players
local Player = Players.LocalPlayer
local Camera = Services.Workspace.CurrentCamera

print("[Inspector] Loaded - Object Inspector")
print("===== INSPECTOR COMMANDS =====")
print("_G.RaycastMode = true/false    -- Enable/disable raycast (look at items)")
print("_G.ProximityMode = true/false  -- Enable/disable proximity (nearby items)")
print("_G.InspectDistance = 100       -- Set raycast max distance (default: 1000)")
print("_G.ProximityRadius = 500       -- Set proximity search radius (default: 500)")
print("==============================")

--> RAYCAST INSPECTOR
_G.RaycastMode = false
_G.InspectDistance = 1000

task.spawn(function()
    print("[Raycast] Mode initialized")
    local lastPrint = 0
    while true do
        task.wait(0.1)
        if _G.RaycastMode then
            local now = tick()
            -- Print every 0.5s to avoid spam
            if now - lastPrint < 0.5 then
                task.wait(0.1)
            else
                lastPrint = now
                
                local camera = Services.Workspace.CurrentCamera
                local mouse = Player:GetMouse()
                
                -- Create raycast from camera through mouse position
                local unitRay = camera:ScreenPointToRay(mouse.X, mouse.Y)
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParams.FilterDescendantsInstances = {Player.Character}
                
                local rayResult = Services.Workspace:Raycast(unitRay.Origin, unitRay.Direction * _G.InspectDistance, raycastParams)
                
                if rayResult then
                    local hit = rayResult.Instance
                    local distance = math.floor((rayResult.Position - camera.CFrame.Position).Magnitude)
                    
                    -- Try to find parent Model
                    local target = hit
                    if hit.Parent and hit.Parent:IsA("Model") then
                        target = hit.Parent
                    end
                    
                    print(string.format(
                        "[RAYCAST] Name: %s | Class: %s | Distance: %dm | Path: %s",
                        target.Name,
                        target.ClassName,
                        distance,
                        target:GetFullName()
                    ))
                else
                    print("[RAYCAST] Nothing in view")
                end
            end
        end
    end
end)

--> PROXIMITY INSPECTOR
_G.ProximityMode = false
_G.ProximityRadius = 500

task.spawn(function()
    print("[Proximity] Mode initialized")
    local lastScan = 0
    while true do
        task.wait(1)
        if _G.ProximityMode then
            local now = tick()
            if now - lastScan < 5 then
                task.wait(1)
            else
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
                            if v:IsA("Model") and v.GetPivot then
                                pos = v:GetPivot().Position
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
                                        path = v:GetFullName()
                                    })
                                end
                            end
                        end)
                    end
                    
                    table.sort(nearby, function(a, b) return a.distance < b.distance end)
                    
                    print("\n[PROXIMITY] Found " .. #nearby .. " objects within " .. _G.ProximityRadius .. "m:")
                    for i, obj in ipairs(nearby) do
                        if i <= 20 then  -- Show top 20
                            print(string.format("  %d. %s (%s) - %dm - %s", i, obj.name, obj.class, obj.distance, obj.path))
                        end
                    end
                    print("")
                end
            end
        end
    end
end)

--> HELPER: Show specific object info
_G.InspectObject = function(objectName)
    for _, v in ipairs(Services.Workspace:GetDescendants()) do
        if v.Name:lower() == objectName:lower() then
            print(string.format(
                "[INSPECT] %s | Class: %s | Path: %s",
                v.Name,
                v.ClassName,
                v:GetFullName()
            ))
            return v
        end
    end
    print("[INSPECT] Object '" .. objectName .. "' not found")
    return nil
end

--> HELPER: List all objects of a type
_G.FindObjectsByType = function(className, limit)
    limit = limit or 10
    local found = {}
    for _, v in ipairs(Services.Workspace:GetDescendants()) do
        if v.ClassName == className then
            table.insert(found, v)
        end
    end
    print("[FIND] Found " .. #found .. " objects of type '" .. className .. "':")
    for i = 1, math.min(#found, limit) do
        print("  " .. i .. ". " .. found[i].Name .. " - " .. found[i]:GetFullName())
    end
    return found
end

print("[Inspector] Ready!")
print("")
print("[USAGE]")
print("  Raycast: _G.RaycastMode = true    (look at items, prints name/class/distance)")
print("  Proximity: _G.ProximityMode = true (lists all nearby objects every 5s)")
print("  Search: _G.InspectObject('apple')  (find specific object)")
print("  Type: _G.FindObjectsByType('Model', 10) (find all objects of a class)")
print("")
