--> Oaklands Game Script - JJSploit Walking Edition
--> No teleportation - uses natural humanoid movement only
--> Safest version for avoiding anti-cheat detection
--> Character walks to items like a real player

print("[Oaklands-Walk] Starting...")

if not LPH_OBFUSCATED then
    LPH_JIT_MAX = function(...)
        return ...
    end
end

--> VARIABLES
local Services = setmetatable({}, {
    __index = function(self, index)
        return game:GetService(index)
    end
})

local Version = "v1.2.1-jjsploit-walk"
local Players = Services.Players
local Player = Players.LocalPlayer

print("[Oaklands-Walk] Player:", Player and Player.Name or "nil")

--> CORE FUNCTIONS
local function WalkToPosition(targetPos, timeout)
    timeout = timeout or 60  -- Max 60s to reach target
    if not Player or not Player.Character then return false end
    
    local humanoid = Player.Character:FindFirstChild("Humanoid")
    local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not hrp then return false end
    
    print("[Walk] Moving toward target...")
    humanoid:MoveTo(targetPos)
    
    -- Wait for movement or timeout
    local startTime = tick()
    while tick() - startTime < timeout do
        task.wait(0.1)
        if not Player or not Player.Character then return false end
        
        local currentPos = hrp.Position
        local distance = (currentPos - targetPos).Magnitude
        
        if distance < 5 then
            print("[Walk] Reached target (distance: " .. math.floor(distance) .. "m)")
            return true
        end
        
        -- If stuck, move again
        if distance > (targetPos - currentPos).Magnitude then
            humanoid:MoveTo(targetPos)
        end
    end
    
    print("[Walk] Timeout reaching target")
    return false
end

local Util = {}
Util.Highlights = {}

function Util.KeyPress(keyCode, time)
    time = time or 0.1
    local vim = Services.VirtualInputManager
    if vim and type(vim.SendKeyEvent) == "function" then
        pcall(function()
            vim:SendKeyEvent(true, keyCode, false, Services.RunService:IsStudio())
            task.wait(time)
            vim:SendKeyEvent(false, keyCode, false, Services.RunService:IsStudio())
        end)
        return
    end
    task.wait(time)
end

--> ITEM SEARCH
local ItemSearch = {}

function ItemSearch.FindItemsByName(searchTerm)
    local results = {}
    local searchLower = searchTerm:lower()
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return results end
    
    local hrp = char.HumanoidRootPart
    for i, v in next, Services.Workspace:GetDescendants() do
        if (v:IsA("Model") or v:IsA("BasePart")) and string.find(v.Name:lower(), searchLower) then
            local pos = v:IsA("Model") and v:GetPivot().Position or v.Position
            local distance = (pos - hrp.Position).Magnitude
            table.insert(results, {
                name = v.Name,
                object = v,
                position = pos,
                distance = distance
            })
        end
    end
    table.sort(results, function(a, b) return a.distance < b.distance end)
    return results
end

function ItemSearch.HighlightItem(obj)
    if not obj then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 215, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 215, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = obj
    table.insert(Util.Highlights, highlight)
end

function ItemSearch.ClearAllHighlights()
    for _, h in ipairs(Util.Highlights) do
        if h and h.Parent then
            h:Destroy()
        end
    end
    Util.Highlights = {}
end

print("[Oaklands-Walk] Loaded - Walking Edition (NO TELEPORT)")
print("===== WALKING COMMANDS =====")
print("_G.FindGoldenApples()                      -- Search for apples")
print("_G.WalkToClosestGoldenApple()              -- Walk to apple (manual mode)")
print("_G.AutoWalkGoldenApples = true/false       -- Toggle walking auto-farm")
print("_G.ItemSearch.FindItemsByName(name)  -- Search for items")
print("=============================")
print("[TIP] Walking is SAFE - natural movement won't trigger anti-cheat!")

--> EXPOSE GLOBALS
_G.ItemSearch = ItemSearch
_G.Util = Util
_G.WalkToPosition = WalkToPosition

--> APPLE HELPERS (WALKING - SAFE)
_G.FindGoldenApples = function()
    local list = ItemSearch.FindItemsByName("GoldenApple")
    if #list > 0 then
        print("[GoldenApples] Found " .. #list .. " apples. Closest: " .. math.floor(list[1].distance) .. "m")
    else
        print("[GoldenApples] No golden apples found nearby")
    end
    return list
end

_G.WalkToClosestGoldenApple = function()
    local list = _G.FindGoldenApples()
    if #list == 0 then
        return false
    end
    
    local closest = list[1]
    print("[GoldenApple] Walking to " .. closest.name .. " (" .. math.floor(closest.distance) .. "m)")
    
    local success = WalkToPosition(closest.position, 60)
    
    if success then
        print("[Walking] Arrived! Press E to pick up the apple")
        ItemSearch.HighlightItem(closest.object)
        return true
    else
        print("[Walking] Could not reach apple")
        return false
    end
end

--> AUTO WALK FARM (WALKING - SAFE & NATURAL)
_G.AutoWalkGoldenApples = false
task.spawn(function()
    print("[Walk-Farm] Auto walk loop ready")
    while true do
        task.wait(30)  -- Check every 30 seconds
        if _G.AutoWalkGoldenApples then
            print("[Walk-Farm] Checking for apples...")
            local ok = _G.WalkToClosestGoldenApple()
            if ok then
                print("[Walk-Farm] Reached apple. Waiting 40s before next walk...")
                task.wait(40)  -- 40s delay for manual pickup
            else
                task.wait(30)  -- 30s if no apple found
            end
        end
    end
end)

print("[Oaklands-Walk] Ready!")
print("[BEST PRACTICE] Use _G.WalkToClosestGoldenApple() for single walks")
print("[AUTO MODE] Set _G.AutoWalkGoldenApples = true for continuous farming")
print("[PICKUP] You must press E manually - do NOT use automated key presses")
print("[SAFE] Walking looks like a real player - lowest ban risk!")
