-- Islands Combat Damage Boost
-- Multiplies outgoing combat damage by hooking remotes
-- NOTE: Only works if the server trusts client damage values

print("[Combat Boost] Initializing...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Configuration
local DAMAGE_MULTIPLIER = 10 -- Multiply your normal damage by this
local ENABLED = true

-- Storage for found remotes
local combatRemotes = {}
local hookedRemotes = {}

-- =====================================================
-- REMOTE FINDER
-- =====================================================

local function findCombatRemotes()
    print("[Combat Boost] Searching for combat remotes...")
    
    local remotesFound = 0
    
    -- Scan ReplicatedStorage for combat-related remotes
    local function scanForRemotes(container, path)
        for _, child in ipairs(container:GetDescendants()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local name = child.Name:lower()
                
                -- Look for combat-related names
                if name:find("combat") or 
                   name:find("attack") or 
                   name:find("damage") or 
                   name:find("hit") or 
                   name:find("sword") or
                   name:find("weapon") or
                   name:find("punch") or
                   name:find("melee") then
                    
                    table.insert(combatRemotes, {
                        remote = child,
                        name = child.Name,
                        path = child:GetFullName()
                    })
                    
                    remotesFound = remotesFound + 1
                    print(string.format("  [%d] Found: %s", remotesFound, child.Name))
                end
            end
        end
    end
    
    scanForRemotes(ReplicatedStorage, "ReplicatedStorage")
    
    if remotesFound > 0 then
        print(string.format("[Combat Boost] Found %d potential combat remotes", remotesFound))
    else
        warn("[Combat Boost] No combat remotes found! Game may use different naming.")
        print("[Combat Boost] Enabling universal hooking mode...")
    end
    
    return remotesFound > 0
end

-- =====================================================
-- UNIVERSAL REMOTE HOOK
-- =====================================================

local function hookAllRemotes()
    print("[Combat Boost] Setting up universal remote hook...")
    
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if not ENABLED then
            return oldNamecall(self, ...)
        end
        
        -- Check if this is a RemoteEvent/RemoteFunction being called
        if (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) and 
           (method == "FireServer" or method == "InvokeServer") then
            
            -- Try to find and modify damage values in the arguments
            local modified = false
            
            for i, arg in ipairs(args) do
                -- Check for direct damage values
                if type(arg) == "number" and arg > 0 and arg < 10000 then
                    -- Likely a damage value
                    local originalValue = arg
                    args[i] = arg * DAMAGE_MULTIPLIER
                    
                    if not hookedRemotes[self.Name] then
                        print(string.format("[Combat Boost] Hooked: %s (numeric damage)", self.Name))
                        hookedRemotes[self.Name] = true
                    end
                    
                    modified = true
                end
                
                -- Check for table with damage field
                if type(arg) == "table" then
                    if arg.Damage or arg.damage then
                        local damageKey = arg.Damage and "Damage" or "damage"
                        local originalDamage = arg[damageKey]
                        arg[damageKey] = originalDamage * DAMAGE_MULTIPLIER
                        
                        if not hookedRemotes[self.Name] then
                            print(string.format("[Combat Boost] Hooked: %s (table.%s)", self.Name, damageKey))
                            hookedRemotes[self.Name] = true
                        end
                        
                        modified = true
                    end
                    
                    -- Check for nested combat data
                    if arg.CombatData or arg.combatData then
                        local dataKey = arg.CombatData and "CombatData" or "combatData"
                        if arg[dataKey].Damage then
                            local originalDamage = arg[dataKey].Damage
                            arg[dataKey].Damage = originalDamage * DAMAGE_MULTIPLIER
                            
                            if not hookedRemotes[self.Name] then
                                print(string.format("[Combat Boost] Hooked: %s (nested damage)", self.Name))
                                hookedRemotes[self.Name] = true
                            end
                            
                            modified = true
                        end
                    end
                end
            end
        end
        
        return oldNamecall(self, unpack(args))
    end)
    
    print("[Combat Boost] Universal hook active!")
end

-- =====================================================
-- SPECIFIC REMOTE HOOK
-- =====================================================

local function hookSpecificRemotes()
    print("[Combat Boost] Hooking specific combat remotes...")
    
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if not ENABLED then
            return oldNamecall(self, ...)
        end
        
        -- Check if this is one of our combat remotes
        for _, remoteData in ipairs(combatRemotes) do
            if self == remoteData.remote and 
               (method == "FireServer" or method == "InvokeServer") then
                
                -- Modify damage in arguments
                if args[1] and type(args[1]) == "table" then
                    if args[1].Damage then
                        local originalDamage = args[1].Damage
                        args[1].Damage = originalDamage * DAMAGE_MULTIPLIER
                        
                        print(string.format("[Combat Boost] %s: %.1f -> %.1f", 
                            remoteData.name, originalDamage, args[1].Damage))
                    elseif args[1].damage then
                        local originalDamage = args[1].damage
                        args[1].damage = originalDamage * DAMAGE_MULTIPLIER
                        
                        print(string.format("[Combat Boost] %s: %.1f -> %.1f", 
                            remoteData.name, originalDamage, args[1].damage))
                    end
                elseif type(args[1]) == "number" then
                    local originalDamage = args[1]
                    args[1] = originalDamage * DAMAGE_MULTIPLIER
                    
                    print(string.format("[Combat Boost] %s: %.1f -> %.1f", 
                        remoteData.name, originalDamage, args[1]))
                end
                
                return oldNamecall(self, unpack(args))
            end
        end
        
        return oldNamecall(self, ...)
    end)
    
    print("[Combat Boost] Specific remote hooks active!")
end

-- =====================================================
-- MAIN INITIALIZATION
-- =====================================================

-- Try to find specific combat remotes
local foundRemotes = findCombatRemotes()

if foundRemotes then
    -- Use specific remote hooking
    hookSpecificRemotes()
else
    -- Fall back to universal hooking
    hookAllRemotes()
end

-- =====================================================
-- CONTROL INTERFACE
-- =====================================================

print("\n[Combat Boost] Active! Your attacks now deal " .. DAMAGE_MULTIPLIER .. "x damage")
print("\n===== COMBAT BOOST COMMANDS =====")
print("_G.CombatBoost.SetMultiplier(10)  -- Change damage multiplier")
print("_G.CombatBoost.Enable()           -- Enable damage boost")
print("_G.CombatBoost.Disable()          -- Disable damage boost")
print("_G.CombatBoost.ShowRemotes()      -- List hooked remotes")
print("=================================\n")

_G.CombatBoost = {
    SetMultiplier = function(multiplier)
        DAMAGE_MULTIPLIER = multiplier
        print(string.format("[Combat Boost] Multiplier set to %.1fx", multiplier))
    end,
    
    Enable = function()
        ENABLED = true
        print("[Combat Boost] Enabled")
    end,
    
    Disable = function()
        ENABLED = false
        print("[Combat Boost] Disabled")
    end,
    
    ShowRemotes = function()
        print("\n===== Hooked Combat Remotes =====")
        
        if #combatRemotes > 0 then
            for i, remoteData in ipairs(combatRemotes) do
                print(string.format("[%d] %s", i, remoteData.name))
                print(string.format("    Path: %s", remoteData.path))
            end
        else
            print("Using universal hooking mode")
            print("\nRemotes detected during gameplay:")
            for name, _ in pairs(hookedRemotes) do
                print(string.format("  - %s", name))
            end
        end
        
        print("=================================\n")
    end,
    
    GetMultiplier = function()
        return DAMAGE_MULTIPLIER
    end,
    
    IsEnabled = function()
        return ENABLED
    end
}

print("[Combat Boost] Ready! Just attack enemies normally - damage will be boosted automatically")
print("[Combat Boost] Note: Only works if server trusts client damage calculations")
