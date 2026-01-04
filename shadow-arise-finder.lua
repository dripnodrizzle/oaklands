-- Shadow Arise Finder & Auto-Summoner
-- Discovers and uses the mechanic to summon shadows from defeated enemies

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local discoveredRemotes = {}
local ariseRemote = nil

print("=== Shadow Arise Finder ===")
print("This script will help you find the 'arise shadow' mechanic")
print("")

-- Function to search for arise-related remotes
local function findAriseRemotes()
    local keywords = {
        "arise", "shadow", "summon", "revive", "raise", "resurrect", 
        "minion", "spawn", "undead", "necro", "dark", "soul"
    }
    
    local possibleRemotes = {}
    
    -- Search in ReplicatedStorage
    for _, descendant in pairs(ReplicatedStorage:GetDescendants()) do
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            local name = descendant.Name:lower()
            
            for _, keyword in pairs(keywords) do
                if name:find(keyword) then
                    table.insert(possibleRemotes, descendant)
                    print("[FOUND] Possible arise remote: " .. descendant:GetFullName())
                    break
                end
            end
        end
    end
    
    return possibleRemotes
end

-- Monitor remote calls to find arise mechanic
local function monitorRemoteCalls()
    local mt = getrawmetatable(game)
    local old_namecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if method == "FireServer" or method == "InvokeServer" then
            local remoteName = tostring(self)
            
            -- Check if this might be arise-related
            if remoteName:lower():find("arise") or 
               remoteName:lower():find("shadow") or 
               remoteName:lower():find("summon") or
               remoteName:lower():find("raise") then
                
                print("[DETECTED] Arise remote call:")
                print("  Remote: " .. remoteName)
                print("  Method: " .. method)
                print("  Arguments:")
                for i, arg in pairs(args) do
                    print("    [" .. i .. "] " .. tostring(arg) .. " (" .. type(arg) .. ")")
                end
                print("")
                
                ariseRemote = self
            end
        end
        
        return old_namecall(self, ...)
    end)
    
    setreadonly(mt, true)
    print("[MONITOR] Remote call monitoring active!")
    print("Try to manually arise a shadow from an enemy, and this script will detect it.")
    print("")
end

-- Find nearby defeated enemies/corpses
local function findDefeatedEnemies()
    local enemies = {}
    local workspace = game:GetWorkspace()
    
    -- Look for NPCs/enemies in workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health <= 0 then
                table.insert(enemies, obj)
            end
        end
    end
    
    return enemies
end

-- Try to arise shadow from target
local function ariseShadow(target)
    if not ariseRemote then
        warn("[ERROR] Arise remote not found yet! Try manually arising first.")
        return false
    end
    
    print("[ARISE] Attempting to arise shadow from: " .. target.Name)
    
    local success, err = pcall(function()
        -- Try different common patterns
        ariseRemote:FireServer(target)
        ariseRemote:FireServer(target.Name)
        ariseRemote:FireServer(target, "Arise")
    end)
    
    if success then
        print("[SUCCESS] Shadow arise command sent!")
    else
        warn("[ERROR] " .. tostring(err))
    end
    
    return success
end

-- Auto-arise all defeated enemies
local function autoAriseAll()
    local enemies = findDefeatedEnemies()
    print("[AUTO-ARISE] Found " .. #enemies .. " defeated enemies")
    
    for _, enemy in pairs(enemies) do
        ariseShadow(enemy)
        wait(0.1)  -- Small delay between each
    end
end

-- Search for remotes on startup
print("Searching for arise-related remotes...")
local possibleRemotes = findAriseRemotes()

if #possibleRemotes == 0 then
    print("[INFO] No obvious arise remotes found by name.")
    print("[INFO] Monitoring remote calls instead...")
else
    print("")
    print("Found " .. #possibleRemotes .. " possible remotes!")
    ariseRemote = possibleRemotes[1]  -- Use first found
end

-- Start monitoring
monitorRemoteCalls()

-- Manual inspection helper
print("")
print("=== Manual Inspection ===")
print("1. Look for defeated enemies and try to arise them manually")
print("2. This script will detect which remote is being called")
print("3. Or check your game's GUI for arise buttons and inspect them")
print("")

-- List all RemoteEvents/Functions for manual inspection
print("=== All Available Remotes ===")
local allRemotes = {}
for _, descendant in pairs(ReplicatedStorage:GetDescendants()) do
    if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
        table.insert(allRemotes, descendant:GetFullName())
    end
end

table.sort(allRemotes)
for i, remote in pairs(allRemotes) do
    if i <= 30 then  -- Show first 30
        print("  " .. remote)
    end
end

if #allRemotes > 30 then
    print("  ... and " .. (#allRemotes - 30) .. " more")
end

print("")
print("=== Global Commands ===")
print("  _G.AriseShadow(target) - Arise shadow from specific enemy")
print("  _G.AutoAriseAll() - Auto-arise all defeated enemies")
print("  _G.FindEnemies() - List all defeated enemies")
print("  _G.ListRemotes() - List all remotes")
print("  _G.SetAriseRemote(path) - Manually set arise remote")
print("")

-- Global functions
_G.AriseShadow = ariseShadow
_G.AutoAriseAll = autoAriseAll
_G.FindEnemies = findDefeatedEnemies
_G.ListRemotes = function()
    for _, remote in pairs(allRemotes) do
        print(remote)
    end
end
_G.SetAriseRemote = function(path)
    local parts = path:split(".")
    local current = game
    
    for _, part in pairs(parts) do
        current = current[part]
    end
    
    if current then
        ariseRemote = current
        print("[SET] Arise remote set to: " .. current:GetFullName())
    else
        warn("[ERROR] Could not find remote at path: " .. path)
    end
end

print("Script loaded! Waiting for arise activity...")
