--> Oaklands Game Script - JJSploit Lite Version
--> Core automation without external UI/ESP libraries
--> Features: Auto break trees/logs/ores, teleport, Item Search, farming

print("[Oaklands] Starting initialization...")

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

print("[Oaklands] Services metatable created")

local Version = "v1.2.1-jjsploit"
local ReplicatedFirst = Services.ReplicatedFirst
local Players = Services.Players
local Player = Players.LocalPlayer
local Character = Player.Character

print("[Oaklands] Player:", Player and Player.Name or "nil")
print("[Oaklands] Character:", Character and "loaded" or "nil")

local Colours = {
    Magnetite = BrickColor.new("Bright violet"),
    ["Rosa Quartz"] = BrickColor.new("Carnation pink"),
    Mythril = BrickColor.new("Med. bluish green"),
    Gold = BrickColor.new("Br. yellowish orange"),
    Iron = BrickColor.new("Dark grey"),
    Pyrite = BrickColor.new("Flame yellowish orange"),
    Quartz = BrickColor.new("Institutional white"),
    Tin = BrickColor.new("Light stone grey"),
    Copper = BrickColor.new("Flame reddish orange")
}

local Areas = {
    ["Oak Depot"] = Vector3.new(736, 82, 1677),
    ["Oak Depot Sell"] = Vector3.new(702, 83, 1790),
    ["Lighthouse"] = Vector3.new(1067, 118, 1958),
    ["Dock"] = Vector3.new(945, 79, 1509),
    ["Island"] = Vector3.new(945, 76, 1233),
    ["Crossway"] = Vector3.new(71, 107, 1465),
    ["Junkyard"] = Vector3.new(-550, 133, 2010),
    ["Mountains"] = Vector3.new(-1759, 419, 865),
    ["Abandoned Shelter"] = Vector3.new(-1819, 330, 561),
    ["Beach Hut"] = Vector3.new(-3591, 113, 163),
    ["Lake"] = Vector3.new(-3069, 132, 455)
}

--> CORE FUNCTIONS
local function Teleport(Pos)
    print("[Teleport] Attempting teleport...")
    if not Player or not Player.Character or not Player.Character:FindFirstChild("Humanoid") then
        print("[Error] Cannot teleport: Character not found")
        return
    end
    local targetPos = Pos
    if targetPos:IsA("CFrame") then
        targetPos = targetPos.Position
    end
    if not targetPos or targetPos == Vector3.new(0, 0, 0) then
        print("[Error] Cannot teleport: Invalid position")
        return
    end
    Player.Character:PivotTo(CFrame.new(targetPos))
    print("[Teleport] Success")
end

local Util = {}
Util.Highlights = {}

function Util.GetPlot()
    for i, v in next, Services.Workspace:GetDescendants() do
        if v:IsA("Model") and v.Name == "Plot" then
            if v:GetAttribute("PlotOwner") == Player.UserId then
                return v
            end
        end
    end
    return nil
end

function Util.GetOwnedItemsByName(itemName)
    local results = {}
    for i, v in next, Services.Workspace:GetDescendants() do
        if v:IsA("Model") and string.find(v.Name:lower(), itemName:lower()) then
            if v:GetAttribute("PlotOwner") == Player.UserId then
                table.insert(results, v)
            end
        end
    end
    return results
end

function Util.GetClosestTree()
    local trees = {}
    for i, v in next, Services.Workspace:GetDescendants() do
        if v:IsA("Model") and v.Name == "Tree" and v:GetAttribute("PlotOwner") == Player.UserId then
            table.insert(trees, v)
        end
    end
    if #trees == 0 then return nil end
    table.sort(trees, function(a, b)
        local aPos = a:GetPivot().Position
        local bPos = b:GetPivot().Position
        local charPos = Player.Character.HumanoidRootPart.Position
        return (aPos - charPos).Magnitude < (bPos - charPos).Magnitude
    end)
    return trees[1]
end

function Util.GetClosestLog()
    local logs = {}
    for i, v in next, Services.Workspace:GetDescendants() do
        if v:IsA("Model") and v.Name == "Log" and v:GetAttribute("PlotOwner") == Player.UserId then
            table.insert(logs, v)
        end
    end
    if #logs == 0 then return nil end
    table.sort(logs, function(a, b)
        local aPos = a:GetPivot().Position
        local bPos = b:GetPivot().Position
        local charPos = Player.Character.HumanoidRootPart.Position
        return (aPos - charPos).Magnitude < (bPos - charPos).Magnitude
    end)
    return logs[1]
end

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
    -- Fallback: VirtualInputManager not available (common in some executors like JJSploit)
    -- Just wait the duration to simulate a press timing without sending an input
    print("[Util.KeyPress] VirtualInputManager unavailable; skipping physical key event")
    task.wait(time)
end

--> ACTIONS
local Actions = {}

function Actions.GoToLog()
    local log = Util.GetClosestLog()
    if log then
        Teleport(log:GetPivot())
        print("[Log] Teleported to log")
        return true
    end
    print("[Error] No logs found")
    return false
end

function Actions.GoToTree()
    local tree = Util.GetClosestTree()
    if tree then
        Teleport(tree:GetPivot())
        print("[Tree] Teleported to tree")
        return true
    end
    print("[Error] No trees found")
    return false
end

function Actions.BreakTree()
    local tree = Util.GetClosestTree()
    if tree then
        Teleport(tree:GetPivot())
        task.wait(0.5)
        Util.KeyPress(Enum.KeyCode.F, 0.2)
        print("[Breaking] Tree break initiated")
        return true
    end
    return false
end

function Actions.BreakLog()
    local log = Util.GetClosestLog()
    if log then
        Teleport(log:GetPivot())
        task.wait(0.5)
        Util.KeyPress(Enum.KeyCode.F, 0.2)
        print("[Breaking] Log break initiated")
        return true
    end
    return false
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

--> AUTOMATION TOGGLES
local Auras = {
    tree_aura = false,
    log_aura = false,
    ore_aura = false
}

print("[Oaklands " .. Version .. "] Loaded - JJSploit Lite Edition")
print("===== COMMANDS =====")
print("_G.Auras.tree_aura = true/false     -- Auto break trees")
print("_G.Auras.log_aura = true/false      -- Auto break logs")
print("_G.Actions.GoToTree()               -- Teleport to closest tree")
print("_G.Actions.GoToLog()                -- Teleport to closest log")
print("_G.Actions.BreakTree()              -- Break closest tree")
print("_G.Actions.BreakLog()               -- Break closest log")
print("_G.ItemSearch.FindItemsByName('name') -- Search for items")
print("_G.ItemSearch.ClearAllHighlights()  -- Clear highlights")
print("====================")
print("[Oaklands] Setting up global references...")

--> AURA LOOPS (Non-blocking)
task.spawn(function()
    while true do
        task.wait(1)
        if Auras.tree_aura then
            if Actions.BreakTree() then
                task.wait(5)
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if Auras.log_aura then
            if Actions.BreakLog() then
                task.wait(5)
            end
        end
    end
end)

--> EXPOSE GLOBALS
_G.Auras = Auras
_G.Actions = Actions
_G.ItemSearch = ItemSearch
_G.Util = Util
_G.Teleport = Teleport

print("[Oaklands] Ready! Use _G.Auras, _G.Actions, _G.ItemSearch, _G.Util")

-- Golden Apple helpers (JJSploit-friendly)
_G.FindGoldenApples = function()
    local ok, res = pcall(function()
        return ItemSearch.FindItemsByName("golden apple")
    end)
    if not ok then
        print("[GoldenApple] Search failed:", res)
        return {}
    end
    return res or {}
end

_G.TeleportToClosestGoldenApple = function()
    local list = _G.FindGoldenApples()
    if #list == 0 then
        print("[GoldenApple] No Golden Apples found")
        return false
    end
    local closest = list[1]
    print("[GoldenApple] Teleporting to:", closest.name, math.floor(closest.distance))
    local target = closest.object:IsA("Model") and closest.object:GetPivot() or CFrame.new(closest.position)
    pcall(function() Teleport(target) end)
    return true
end

_G.AutoCollectGoldenApples = false
task.spawn(function()
    while true do
        task.wait(1)
        if _G.AutoCollectGoldenApples then
            local ok = _G.TeleportToClosestGoldenApple()
            if ok then
                task.wait(0.6)
                pcall(function() Util.KeyPress(Enum.KeyCode.E, 0.15) end)
                task.wait(1)
            else
                task.wait(3)
            end
        end
    end
end)
