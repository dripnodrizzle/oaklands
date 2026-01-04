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
    
    local success, result = pcall(function()
        local code = game:HttpGet(url)
        local func = loadstring(code)
        if not func then
            error("Failed to compile script")
        end
        return func()
    end)
    
    if success then
        print(string.format("✅ %s loaded successfully", script.name))
        LoadedScripts[key] = result or true  -- Store true if script returns nothing
        return result
    else
        warn(string.format("❌ Failed to load %s", script.name))
        warn(string.format("   Error: %s", tostring(result)))
        warn(string.format("   URL: %s", url))
        return nil
    end
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

-- Add individual loaders
for key, script in pairs(SCRIPTS) do
    Islands[key] = function()
        return loadScript(key)
    end
end

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

print("\n📦 Individual Script Usage:")
print("   After loading, each script returns its functions:")
print("   local Chest = Islands.chest()")
print("   Chest.AutoChestOpener.enable(15)")

print("\n" .. string.rep("=", 52))
print("Ready! Type a command to get started")
print("Example: Islands.presets.monitoring()")
print(string.rep("=", 52))

-- Make it global for easy access
_G.Islands = Islands

return Islands
