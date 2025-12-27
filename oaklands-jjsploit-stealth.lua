--> Oaklands Game Script - JJSploit Stealth Edition
--> Conservative, anti-ban version with human-like timing
--> Longer delays, no rapid automation, safer for avoiding detection

print("[Oaklands-Stealth] Starting initialization...")

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

print("[Oaklands-Stealth] Services created")

local Version = "v1.2.1-jjsploit-stealth"
local Players = Services.Players
local Player = Players.LocalPlayer

print("[Oaklands-Stealth] Player:", Player and Player.Name or "nil")

--> CORE FUNCTIONS
local function Teleport(Pos)
    if not Player or not Player.Character or not Player.Character:FindFirstChild("Humanoid") then
        print("[Teleport] Character not found")
        return
    end
    local targetPos = Pos
    if targetPos:IsA("CFrame") then
        targetPos = targetPos.Position
    end
    if not targetPos or targetPos == Vector3.new(0, 0, 0) then
        return
    end
    Player.Character:PivotTo(CFrame.new(targetPos))
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
    for i, v in next, Services.Workspace:GetDescendants() do
        if (v:IsA("Model") or v:IsA("BasePart")) and string.find(v.Name:lower(), searchLower) then
            local pos = v:IsA("Model") and v:GetPivot().Position or v.Position
            local distance = (pos - Player.Character.HumanoidRootPart.Position).Magnitude
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

print("[Oaklands-Stealth] Loaded - Stealth Edition")
print("===== STEALTH COMMANDS =====")
print("_G.FindApples()                      -- Search for apples")
print("_G.TeleportToClosestApple()          -- Teleport once (manual)")
print("_G.AutoCollectApples = true/false    -- Toggle slow auto-collect (10s+ delays)")
print("_G.ItemSearch.FindItemsByName(name)  -- Search for items")
print("=============================")

--> EXPOSE GLOBALS
_G.Teleport = Teleport
_G.ItemSearch = ItemSearch
_G.Util = Util

--> APPLE HELPERS (STEALTH MODE - SAFE)
_G.FindApples = function()
    local list = ItemSearch.FindItemsByName("apple")
    print("[Apples] Found " .. #list .. " apples nearby")
    return list
end

_G.TeleportToClosestApple = function()
    local list = _G.FindApples()
    if #list == 0 then
        print("[Apples] No apples found")
        return false
    end
    local closest = list[1]
    print("[Apples] Teleporting to apple at " .. math.floor(closest.distance) .. "m")
    local target = closest.object:IsA("Model") and closest.object:GetPivot() or CFrame.new(closest.position)
    pcall(function() _G.Teleport(target) end)
    return true
end

--> AUTO-COLLECT (STEALTH - SLOW, SAFE)
_G.AutoCollectApples = false
task.spawn(function()
    print("[Stealth] Auto-collect loop initialized (10+ second delays)")
    while true do
        task.wait(15)  -- Wait 15s between checks (very conservative)
        if _G.AutoCollectApples then
            print("[Stealth] Checking for apples...")
            local ok = _G.TeleportToClosestApple()
            if ok then
                -- MANUAL PICKUP ONLY - No automated key press
                print("[Stealth] Teleported. Press E manually to pick up apple.")
                print("[Stealth] Waiting 20 seconds before next attempt...")
                task.wait(20)  -- 20s delay between teleports (very safe)
            else
                task.wait(30)  -- Wait 30s if no apples found
            end
        end
    end
end)

print("[Oaklands-Stealth] Ready!")
print("[TIP] Use _G.TeleportToClosestApple() for manual control")
print("[TIP] Set _G.AutoCollectApples = true for slow auto mode (20s+ between actions)")
print("[TIP] ALWAYS press E manually for pickup - automated pressing may trigger anti-cheat")
