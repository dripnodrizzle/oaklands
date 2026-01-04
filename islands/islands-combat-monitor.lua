-- Islands Combat Traffic Monitor
-- Monitors all remote traffic to identify combat/damage patterns
-- Helps determine if damage is client-side or server-side

print("[Combat Monitor] Initializing...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer

-- Configuration
local MONITOR_ENABLED = true
local LOG_ALL_TRAFFIC = false -- Set to true to see ALL remotes
local combatLog = {}

-- Known patterns to watch for
local COMBAT_KEYWORDS = {
    "combat", "attack", "damage", "hit", "sword", "weapon", 
    "punch", "melee", "strike", "swing", "hurt", "kill"
}

local function isCombatRelated(name)
    local nameLower = name:lower()
    for _, keyword in ipairs(COMBAT_KEYWORDS) do
        if nameLower:find(keyword) then
            return true
        end
    end
    return false
end

local function serializeValue(value, depth)
    depth = depth or 0
    if depth > 3 then return "..." end
    
    local valueType = type(value)
    
    if valueType == "table" then
        local result = "{\n"
        local indent = string.rep("  ", depth + 1)
        
        for k, v in pairs(value) do
            result = result .. indent .. tostring(k) .. " = " .. serializeValue(v, depth + 1) .. "\n"
        end
        
        return result .. string.rep("  ", depth) .. "}"
    elseif valueType == "string" then
        return '"' .. value .. '"'
    elseif valueType == "Instance" then
        return tostring(value) .. " (" .. value.ClassName .. ")"
    else
        return tostring(value)
    end
end

-- =====================================================
-- TRAFFIC MONITOR
-- =====================================================

local monitoredRemotes = {}
local trafficCount = 0

local function logTraffic(remoteName, method, args, isCombat)
    if not MONITOR_ENABLED then return end
    if not LOG_ALL_TRAFFIC and not isCombat then return end
    
    trafficCount = trafficCount + 1
    
    local logEntry = {
        id = trafficCount,
        remote = remoteName,
        method = method,
        timestamp = tick(),
        isCombat = isCombat,
        args = args
    }
    
    table.insert(combatLog, logEntry)
    
    -- Keep only last 100 entries
    if #combatLog > 100 then
        table.remove(combatLog, 1)
    end
    
    -- Print to console
    local prefix = isCombat and "[COMBAT]" or "[TRAFFIC]"
    print(string.format("\n%s [#%d] %s:%s", prefix, trafficCount, remoteName, method))
    
    if #args > 0 then
        for i, arg in ipairs(args) do
            print(string.format("  [arg%d] %s", i, serializeValue(arg)))
        end
    else
        print("  (no arguments)")
    end
end

-- =====================================================
-- UNIVERSAL REMOTE HOOK
-- =====================================================

local function setupMonitor()
    print("[Combat Monitor] Setting up traffic monitoring...")
    
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Monitor RemoteEvent/RemoteFunction calls
        if (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) and 
           (method == "FireServer" or method == "InvokeServer") then
            
            local remoteName = self.Name
            local isCombat = isCombatRelated(remoteName)
            
            -- Track new remotes
            if not monitoredRemotes[remoteName] then
                monitoredRemotes[remoteName] = {
                    remote = self,
                    path = self:GetFullName(),
                    callCount = 0,
                    isCombat = isCombat
                }
                
                if isCombat then
                    print(string.format("[Combat Monitor] ⚔️ Combat remote detected: %s", remoteName))
                end
            end
            
            monitoredRemotes[remoteName].callCount = monitoredRemotes[remoteName].callCount + 1
            
            -- Log traffic
            logTraffic(remoteName, method, args, isCombat)
        end
        
        return oldNamecall(self, ...)
    end)
    
    print("[Combat Monitor] ✓ Traffic monitoring active!")
end

-- =====================================================
-- ANALYSIS FUNCTIONS
-- =====================================================

local function analyzeCombatPattern()
    print("\n===== COMBAT PATTERN ANALYSIS =====")
    
    local combatEntries = {}
    for _, entry in ipairs(combatLog) do
        if entry.isCombat then
            table.insert(combatEntries, entry)
        end
    end
    
    if #combatEntries == 0 then
        print("No combat traffic detected yet.")
        print("Try attacking an enemy and run this command again.")
        return
    end
    
    print(string.format("Found %d combat-related calls:", #combatEntries))
    
    for _, entry in ipairs(combatEntries) do
        print(string.format("\n[#%d] %s", entry.id, entry.remote))
        
        -- Analyze arguments for damage patterns
        for i, arg in ipairs(entry.args) do
            local argType = type(arg)
            print(string.format("  arg%d (%s):", i, argType))
            
            if argType == "number" then
                print(string.format("    Value: %.2f", arg))
                if arg > 0 and arg < 1000 then
                    print("    ⚠️ Possible damage value!")
                end
            elseif argType == "table" then
                print("    Table contents:")
                for k, v in pairs(arg) do
                    local keyLower = tostring(k):lower()
                    if keyLower:find("damage") or keyLower:find("health") or keyLower:find("hit") then
                        print(string.format("      ⚠️ %s = %s (DAMAGE FIELD!)", k, tostring(v)))
                    else
                        print(string.format("      %s = %s", k, tostring(v)))
                    end
                end
            elseif argType == "Instance" then
                print(string.format("    Instance: %s (%s)", arg.Name, arg.ClassName))
            else
                print(string.format("    Value: %s", tostring(arg)))
            end
        end
    end
    
    print("\n===================================")
end

local function listAllRemotes()
    print("\n===== MONITORED REMOTES =====")
    
    local combatRemotes = {}
    local otherRemotes = {}
    
    for name, data in pairs(monitoredRemotes) do
        if data.isCombat then
            table.insert(combatRemotes, {name = name, count = data.callCount, path = data.path})
        else
            table.insert(otherRemotes, {name = name, count = data.callCount, path = data.path})
        end
    end
    
    table.sort(combatRemotes, function(a, b) return a.count > b.count end)
    table.sort(otherRemotes, function(a, b) return a.count > b.count end)
    
    print(string.format("\n⚔️ Combat Remotes (%d):", #combatRemotes))
    for i, remote in ipairs(combatRemotes) do
        print(string.format("  [%d] %s (called %d times)", i, remote.name, remote.count))
        print(string.format("      Path: %s", remote.path))
    end
    
    print(string.format("\n📡 Other Remotes (%d):", #otherRemotes))
    for i, remote in ipairs(otherRemotes) do
        if i <= 10 then -- Show only top 10
            print(string.format("  [%d] %s (called %d times)", i, remote.name, remote.count))
        end
    end
    
    if #otherRemotes > 10 then
        print(string.format("  ... and %d more", #otherRemotes - 10))
    end
    
    print("\n=============================")
end

local function clearLog()
    combatLog = {}
    trafficCount = 0
    print("[Combat Monitor] Log cleared")
end

local function getRecentCombat(count)
    count = count or 5
    
    print(string.format("\n===== RECENT COMBAT TRAFFIC (Last %d) =====", count))
    
    local combatEntries = {}
    for i = #combatLog, 1, -1 do
        if combatLog[i].isCombat then
            table.insert(combatEntries, combatLog[i])
            if #combatEntries >= count then break end
        end
    end
    
    if #combatEntries == 0 then
        print("No combat traffic recorded yet.")
        return
    end
    
    for i = #combatEntries, 1, -1 do
        local entry = combatEntries[i]
        print(string.format("\n[#%d] %s @ %.2fs ago", 
            entry.id, entry.remote, tick() - entry.timestamp))
        
        for j, arg in ipairs(entry.args) do
            print(string.format("  arg%d: %s", j, serializeValue(arg, 0)))
        end
    end
    
    print("\n============================================")
end

-- =====================================================
-- INITIALIZE
-- =====================================================

setupMonitor()

print("\n[Combat Monitor] Ready!")
print("\n===== COMBAT MONITOR COMMANDS =====")
print("_G.CombatMonitor.Analyze()         -- Analyze combat patterns")
print("_G.CombatMonitor.ListRemotes()     -- List all monitored remotes")
print("_G.CombatMonitor.Recent(5)         -- Show recent combat traffic")
print("_G.CombatMonitor.Clear()           -- Clear traffic log")
print("_G.CombatMonitor.EnableAll()       -- Log ALL traffic (not just combat)")
print("_G.CombatMonitor.DisableAll()      -- Log only combat traffic")
print("_G.CombatMonitor.Enable()          -- Enable monitoring")
print("_G.CombatMonitor.Disable()         -- Disable monitoring")
print("===================================")

_G.CombatMonitor = {
    Analyze = analyzeCombatPattern,
    ListRemotes = listAllRemotes,
    Recent = getRecentCombat,
    Clear = clearLog,
    
    EnableAll = function()
        LOG_ALL_TRAFFIC = true
        print("[Combat Monitor] Now logging ALL traffic")
    end,
    
    DisableAll = function()
        LOG_ALL_TRAFFIC = false
        print("[Combat Monitor] Now logging only combat traffic")
    end,
    
    Enable = function()
        MONITOR_ENABLED = true
        print("[Combat Monitor] Monitoring enabled")
    end,
    
    Disable = function()
        MONITOR_ENABLED = false
        print("[Combat Monitor] Monitoring disabled")
    end,
    
    GetLog = function()
        return combatLog
    end,
    
    GetRemotes = function()
        return monitoredRemotes
    end
}

print("\n[Combat Monitor] Instructions:")
print("1. Go attack an enemy or hit something")
print("2. Run: _G.CombatMonitor.Analyze()")
print("3. Look for damage values in the output")
print("4. If you see damage fields, the combat boost script should work!")
print("5. If no damage fields found, damage is server-side only\n")
