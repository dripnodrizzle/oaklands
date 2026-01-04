-- Islands Master Loader
-- Easy loading interface for all Islands exploit scripts

print("🏝️ Islands Master Loader v1.0")
print("=" .. string.rep("=", 50))

local BASE_URL = "https://raw.githubusercontent.com/dripnodrizzle/oaklands/copilot/finish-inspector-lua-script/islands/"

-- =====================================================
-- SCRIPT REGISTRY
-- =====================================================

local SCRIPTS = {
    -- Core & Analysis
    core = {
        name = "Core Utils",
        file = "islands-core-utils.lua",
        description = "Core utilities and framework detection"
    },
    async = {
        name = "Async Exploiter",
        file = "islands-async-exploiter.lua",
        description = "Hook promise/async system, remove waits"
    },
    main = {
        name = "Main Hook",
        file = "islands-main-hook.lua",
        description = "Hook game initialization"
    },
    
    -- Debugging
    errors = {
        name = "Error Suppressor",
        file = "islands-error-suppressor.lua",
        description = "Clean console, reveal remotes"
    },
    spy = {
        name = "Remote Spy",
        file = "islands-remote-spy.lua",
        description = "Intercept all network traffic"
    },
    
    -- Gameplay
    interact = {
        name = "Interact Exploiter",
        file = "islands-interact-exploiter.lua",
        description = "Auto-interact, range bypass"
    },
    chest = {
        name = "Chest Exploiter",
        file = "islands-chest-exploiter.lua",
        description = "Auto-open chests, teleport"
    },
    chat = {
        name = "Chat Exploiter",
        file = "islands-chat-exploiter.lua",
        description = "Auto-accept invites, chat logger"
    },
    
    -- Items
    duper = {
        name = "Item Duper",
        file = "islands-item-duper.lua",
        description = "Item duplication framework"
    }
}

-- =====================================================
-- LOADER FUNCTIONS
-- =====================================================

local LoadedScripts = {}

local function loadScript(key)
    if not SCRIPTS[key] then
        warn("Script '" .. key .. "' not found!")
        return nil
    end
    
    if LoadedScripts[key] then
        print("Script '" .. key .. "' already loaded!")
        return LoadedScripts[key]
    end
    
    local script = SCRIPTS[key]
    local url = BASE_URL .. script.file
    
    print(string.format("📥 Loading: %s...", script.name))
    print(string.format("   %s", script.description))
    
    local httpSuccess, code = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not httpSuccess then
        warn(string.format("❌ Failed to fetch %s", script.name))
        warn(string.format("   HTTP Error: %s", tostring(code)))
        warn(string.format("   URL: %s", url))
        return nil
    end
    
    local compileSuccess, func = pcall(function()
        return loadstring(code)
    end)
    
    if not compileSuccess or not func then
        warn(string.format("❌ Failed to compile %s", script.name))
        warn(string.format("   Compile Error: %s", tostring(func)))
        return nil
    end
    
    local executeSuccess, result = pcall(func)
    
    if not executeSuccess then
        warn(string.format("❌ Failed to execute %s", script.name))
        warn(string.format("   Runtime Error: %s", tostring(result)))
        return nil
    end
    
    print(string.format("✅ %s loaded successfully", script.name))
    LoadedScripts[key] = result or true
    
    if not result then
        print("   ⚠️ Script returned nothing (this may be intentional)")
    end
    
    return result
end

-- =====================================================
-- PRESET CONFIGURATIONS
-- =====================================================

local Presets = {}

function Presets.monitoring()
    print("\n🔍 Loading Monitoring Suite...")
    loadScript("errors")
    loadScript("spy")
    loadScript("main")
    print("\n✅ Monitoring suite loaded")
    print("All game activity will be logged")
end

function Presets.gameplay()
    print("\n🎮 Loading Gameplay Suite...")
    loadScript("interact")
    loadScript("chest")
    loadScript("chat")
    print("\n✅ Gameplay suite loaded")
    print("Use commands from each script to activate features")
end

function Presets.full()
    print("\n🚀 Loading Full Suite...")
    print("This may take a moment...\n")
    
    -- Load in order
    loadScript("core")
    loadScript("errors")
    loadScript("async")
    loadScript("main")
    loadScript("spy")
    loadScript("interact")
    loadScript("chest")
    loadScript("chat")
    loadScript("duper")
    
    print("\n✅ Full suite loaded")
    print("All exploits are ready to use!")
end

function Presets.farming()
    print("\n🌾 Loading Farming Suite...")
    loadScript("errors")
    loadScript("interact")
    loadScript("chest")
    print("\n✅ Farming suite loaded")
    print("Auto-farming features ready")
end

function Presets.analysis()
    print("\n📊 Loading Analysis Suite...")
    loadScript("core")
    loadScript("spy")
    loadScript("duper")
    print("\n✅ Analysis suite loaded")
    print("Use these to discover new exploits")
end

-- =====================================================
-- PUBLIC API
-- =====================================================

local Islands = {
    load = loadScript,
    presets = Presets,
    scripts = SCRIPTS,
    loaded = LoadedScripts
}

-- Create a metatable that auto-loads scripts when accessed
local IslandsMetatable = {}
IslandsMetatable.__index = function(table, key)
    -- Check if it's a known script
    if SCRIPTS[key] then
        -- Auto-load if not already loaded
        if not LoadedScripts[key] then
            print(string.format("🔄 Auto-loading %s...", SCRIPTS[key].name))
            loadScript(key)
        end
        return LoadedScripts[key]
    end
    
    -- Check if it's a built-in function
    return rawget(Islands, key)
end

-- Helper to safely access loaded scripts (deprecated, use direct access)
function Islands.get(key)
    if not LoadedScripts[key] then
        warn(string.format("Script '%s' not loaded. Loading now...", key))
        return loadScript(key)
    end
    return LoadedScripts[key]
end

-- Helper to check if a script is loaded
function Islands.isLoaded(key)
    return LoadedScripts[key] ~= nil
end

-- Manual loading function (optional, for explicit control)
function Islands.loadScript(key)
    return loadScript(key)
end

-- Apply metatable for auto-loading
setmetatable(Islands, IslandsMetatable)

-- =====================================================
-- DISPLAY MENU
-- =====================================================

print("\n📋 Available Scripts:")
print(string.rep("-", 52))

local categories = {
    {name = "Core & Analysis", keys = {"core", "async", "main"}},
    {name = "Debugging", keys = {"errors", "spy"}},
    {name = "Gameplay", keys = {"interact", "chest", "chat"}},
    {name = "Items", keys = {"duper"}}
}

for _, category in ipairs(categories) do
    print(string.format("\n🔹 %s:", category.name))
    for _, key in ipairs(category.keys) do
        local script = SCRIPTS[key]
        print(string.format("   Islands.%s() - %s", key, script.description))
    end
end

print("\n" .. string.rep("-", 52))
print("\n🎯 Quick Presets:")
print("   Islands.presets.monitoring() - Error suppressor + Remote spy")
print("   Islands.presets.gameplay()   - Interact + Chest + Chat")
print("   Islands.presets.farming()    - Auto-farming setup")
print("   Islands.presets.analysis()   - Tools for finding exploits")
print("   Islands.presets.full()       - Load everything")

print("\n💡 Examples:")
print("   Islands.chest()              - Load chest exploiter")
print("   Islands.load('spy')          - Load remote spy")
print("   Islands.presets.full()       - Load all scripts")

print("\n📦 Individual Script Usage (AUTO-LOAD):")
print("   Scripts load automatically when accessed:")
print("   Islands.chest.AutoChestOpener.enable(15)")
print("   Islands.duper.ItemScanner.scanInventory()")
print("   Islands.spy.TrafficInterceptor.dumpTraffic()")

print("\n🔧 Helper Functions:")
print("   Islands.loadScript('chest')  - Manually load a script")
print("   Islands.isLoaded('spy')      - Check if script is loaded")
print("   Islands.loaded               - View all loaded scripts")

print("\n" .. string.rep("=", 52))
print("Ready! Type a command to get started")
print("Example: Islands.presets.monitoring()")
print(string.rep("=", 52))

-- Make it global for easy access
_G.Islands = Islands

return Islands
