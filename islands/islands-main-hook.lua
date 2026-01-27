-- Islands Main Hook - Intercept Game Initialization
-- Hook into the core game loading process

print("Islands Main Hook Loading...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer

-- =====================================================
-- LOGGER INTERCEPTOR
-- =====================================================

local LoggerInterceptor = {}
LoggerInterceptor.logLevel = nil
LoggerInterceptor.logs = {}

function LoggerInterceptor.hookLogger()
    pcall(function()
        local LogModule = require(ReplicatedStorage.rbxts_include.node_modules["@rbxts"].log.out)
        
        if LogModule and LogModule.default then
            local Logger = LogModule.default
            local LogLevel = LogModule.LogLevel
            
            -- Store original SetLogger
            local originalSetLogger = Logger.SetLogger
            
            Logger.SetLogger = function(logger)
                print("🔍 Logger being configured!")
                
                -- Try to upgrade to Verbose logging
                pcall(function()
                    logger:SetMinLogLevel(LogLevel.Verbose)
                    print("✓ Upgraded logging to Verbose")
                end)
                
                return originalSetLogger(logger)
            end
            
            -- Hook the logger output
            if Logger.RobloxOutput then
                print("✓ Hooked Logger.RobloxOutput")
            end
            
            print("✓ Hooked logging system")
            return true
        end
    end)
    
    return false
end

-- =====================================================
-- FLAMEWORK INTERCEPTOR
-- =====================================================

local FlameworkInterceptor = {}
FlameworkInterceptor.dependencies = {}

function FlameworkInterceptor.hookFlamework()
    pcall(function()
        local RuntimeLib = require(ReplicatedStorage.rbxts_include.RuntimeLib)
        
        -- Find the main script (optional)
        local mainScript = Player:WaitForChild("main", 5)
        if not mainScript then
            -- Not an error - game might use different structure
            return
        end
        
        print("✓ Found main script")
        
        -- The Flamework client is imported from script.Parent/flame/flamework-client
        pcall(function()
            local FlameworkClient = RuntimeLib.import(mainScript, mainScript.Parent, "flame", "flamework-client").FlameworkClient
            
            if FlameworkClient then
                print("✓ Found FlameworkClient")
                
                -- Hook the setup method
                local originalSetup = FlameworkClient.setup
                
                FlameworkClient.setup = function(self, dependencies)
                    print(string.format("🔧 Flamework.setup called with %d dependencies", #dependencies))
                    
                    -- Store dependencies
                    FlameworkInterceptor.dependencies = dependencies
                    
                    -- Log each dependency
                    for i, dep in ipairs(dependencies) do
                        print(string.format("  [%d] %s", i, tostring(dep)))
                    end
                    
                    return originalSetup(self, dependencies)
                end
                
                print("✓ Hooked Flamework.setup")
            end
        end)
    end)
end

-- =====================================================
-- GAME CORE CLIENT INTERCEPTOR
-- =====================================================

local GameCoreInterceptor = {}

function GameCoreInterceptor.hookGameCore()
    pcall(function()
        local GameCoreModule = ReplicatedStorage.rbxts_include.node_modules["@easy-games"]["game-core"].out
        local GameCoreClient = require(GameCoreModule).GameCoreClient
        
        if GameCoreClient then
            print("✓ Found GameCoreClient")
            
            -- Hook the new method
            local originalNew = GameCoreClient.new
            
            GameCoreClient.new = function(isProduction, clientStore)
                print("🎮 GameCoreClient.new called")
                print(string.format("  isProduction: %s", tostring(isProduction)))
                print(string.format("  clientStore: %s", tostring(clientStore)))
                
                local instance = originalNew(isProduction, clientStore)
                
                -- Hook registerApps
                local originalRegisterApps = instance.registerApps
                
                instance.registerApps = function(self, apps)
                    print("📱 GameCoreClient:registerApps called")
                    print(string.format("  apps: %s", tostring(apps)))
                    
                    return originalRegisterApps(self, apps)
                end
                
                print("✓ Hooked GameCoreClient instance")
                
                return instance
            end
            
            print("✓ Hooked GameCoreClient.new")
        end
    end)
end

-- =====================================================
-- PLACE UTILS INTERCEPTOR
-- =====================================================

local PlaceUtilsInterceptor = {}

function PlaceUtilsInterceptor.hookPlaceUtils()
    pcall(function()
        local RuntimeLib = require(ReplicatedStorage.rbxts_include.RuntimeLib)
        local PlaceUtils = RuntimeLib.import(nil, ReplicatedStorage, "TS", "util", "place-utils").PlaceUtils
        
        if PlaceUtils then
            print("✓ Found PlaceUtils")
            
            -- Hook all the place detection methods
            local methods = {
                "isGameModeServer",
                "isAnyWildIslandServer", 
                "isHubServer",
                "isPlayerIsland"
            }
            
            for _, method in ipairs(methods) do
                if PlaceUtils[method] then
                    local original = PlaceUtils[method]
                    
                    PlaceUtils[method] = function(...)
                        local result = original(...)
                        print(string.format("🗺️ PlaceUtils.%s() = %s", method, tostring(result)))
                        return result
                    end
                end
            end
            
            print("✓ Hooked PlaceUtils methods")
        end
    end)
end

-- =====================================================
-- TOOL SETUP INTERCEPTOR
-- =====================================================

local ToolSetupInterceptor = {}

function ToolSetupInterceptor.hookToolSetup()
    pcall(function()
        local RuntimeLib = require(ReplicatedStorage.rbxts_include.RuntimeLib)
        
        -- Hook setupBlockTools
        pcall(function()
            local setupBlockTools = RuntimeLib.import(nil, ReplicatedStorage, "TS", "tool", "setup", "setup-block-tools").setupBlockTools
            
            if setupBlockTools then
                local originalSetup = setupBlockTools
                
                _G.setupBlockTools = function(...)
                    print("🔨 setupBlockTools called")
                    return originalSetup(...)
                end
                
                print("✓ Hooked setupBlockTools")
            end
        end)
        
        -- Hook setupBlueprintTools
        pcall(function()
            local setupBlueprintTools = RuntimeLib.import(nil, ReplicatedStorage, "TS", "tool", "setup", "setup-blueprint-tools").setupBlueprintTools
            
            if setupBlueprintTools then
                local originalSetup = setupBlueprintTools
                
                _G.setupBlueprintTools = function(...)
                    print("📐 setupBlueprintTools called")
                    return originalSetup(...)
                end
                
                print("✓ Hooked setupBlueprintTools")
            end
        end)
        
        -- Hook transformToolMetadata
        pcall(function()
            local transformToolMetadata = RuntimeLib.import(nil, ReplicatedStorage, "TS", "tool", "tool-transform").transformToolMetadata
            
            if transformToolMetadata then
                local originalTransform = transformToolMetadata
                
                _G.transformToolMetadata = function(...)
                    print("🔄 transformToolMetadata called")
                    return originalTransform(...)
                end
                
                print("✓ Hooked transformToolMetadata")
            end
        end)
    end)
end

-- =====================================================
-- CLIENT READY MONITOR
-- =====================================================

local ClientReadyMonitor = {}

function ClientReadyMonitor.monitorClientReady()
    -- Wait for ClientReady signal
    task.spawn(function()
        local clientReady = Workspace:WaitForChild("ClientReady", 30)
        
        if clientReady then
            print("\n✅ CLIENT READY SIGNAL DETECTED")
            print(string.format("  Name: %s", clientReady.Name))
            print(string.format("  Value: %s", tostring(clientReady.Value)))
            print(string.format("  Class: %s", clientReady.ClassName))
            
            -- Hook value changes
            clientReady:GetPropertyChangedSignal("Value"):Connect(function()
                print(string.format("ClientReady value changed to: %s", tostring(clientReady.Value)))
            end)
        else
            warn("ClientReady signal not found after 30 seconds")
        end
    end)
end

-- =====================================================
-- RODUX STORE INTERCEPTOR
-- =====================================================

local RoduxInterceptor = {}

function RoduxInterceptor.hookRoduxStore()
    pcall(function()
        local RuntimeLib = require(ReplicatedStorage.rbxts_include.RuntimeLib)
        local ClientStore = RuntimeLib.import(nil, ReplicatedStorage, "TS", "store", "rodux").ClientStore
        
        if ClientStore then
            print("✓ Found ClientStore (Rodux)")
            
            -- Try to hook the store's dispatch method
            pcall(function()
                if ClientStore.dispatch then
                    local originalDispatch = ClientStore.dispatch
                    
                    ClientStore.dispatch = function(self, action)
                        print(string.format("📦 Store.dispatch: %s", tostring(action.type or action)))
                        return originalDispatch(self, action)
                    end
                    
                    print("✓ Hooked ClientStore.dispatch")
                end
            end)
        end
    end)
end

-- =====================================================
-- ENVIRONMENT DETECTOR
-- =====================================================

local EnvironmentDetector = {}

function EnvironmentDetector.detectEnvironment()
    pcall(function()
        local RuntimeLib = require(ReplicatedStorage.rbxts_include.RuntimeLib)
        local GameUtils = RuntimeLib.import(nil, ReplicatedStorage, "TS", "games", "games-utils").GameUtils
        
        if GameUtils and GameUtils.isProduction then
            local isProduction = GameUtils.isProduction()
            print(string.format("🌍 Environment: %s", isProduction and "PRODUCTION" or "DEVELOPMENT"))
        end
    end)
end

-- =====================================================
-- MAIN EXECUTION
-- =====================================================

print("\n=== Islands Main Hook ===")

-- Wait a bit for modules to load
task.wait(1)

print("\n=== Hooking Core Systems ===")

-- Hook everything
LoggerInterceptor.hookLogger()
GameCoreInterceptor.hookGameCore()
FlameworkInterceptor.hookFlamework()
PlaceUtilsInterceptor.hookPlaceUtils()
ToolSetupInterceptor.hookToolSetup()
RoduxInterceptor.hookRoduxStore()

-- Monitor signals
ClientReadyMonitor.monitorClientReady()

-- Detect environment
EnvironmentDetector.detectEnvironment()

print("\n=== Hook Complete ===")
print("All major systems are now hooked and monitored")
print("Initialization events will be logged as they occur")

-- Watch for the main script to load
task.spawn(function()
    local mainScript = Player:WaitForChild("main", 10)
    if mainScript then
        print("\n✓ Main script loaded: " .. mainScript:GetFullName())
    end
end)

print("\n=== Available Functions ===")
print("  FlameworkInterceptor.dependencies - View registered Flamework dependencies")
print("  LoggerInterceptor.logs - View captured logs")

return {
    LoggerInterceptor = LoggerInterceptor,
    FlameworkInterceptor = FlameworkInterceptor,
    GameCoreInterceptor = GameCoreInterceptor,
    PlaceUtilsInterceptor = PlaceUtilsInterceptor,
    ToolSetupInterceptor = ToolSetupInterceptor,
    ClientReadyMonitor = ClientReadyMonitor,
    RoduxInterceptor = RoduxInterceptor,
    EnvironmentDetector = EnvironmentDetector
}
