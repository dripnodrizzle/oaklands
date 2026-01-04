-- Islands Core Utilities
-- Salvaged patterns from Islands decompiled code

print("Islands Core Utils Loading...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

-- =====================================================
-- COREGUI MANIPULATION
-- =====================================================

local function disableBackpack()
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
        print("✓ Disabled backpack GUI")
    end)
end

local function disableAllCoreGui()
    pcall(function()
        for _, guiType in pairs(Enum.CoreGuiType:GetEnumItems()) do
            StarterGui:SetCoreGuiEnabled(guiType, false)
        end
        print("✓ Disabled all CoreGUI")
    end)
end

-- =====================================================
-- RESET BUTTON CONTROL
-- =====================================================

local function disableResetButton()
    pcall(function()
        local BindableEvent = Instance.new("BindableEvent")
        BindableEvent.Event:Connect(function() end)
        StarterGui:SetCore("ResetButtonCallback", BindableEvent)
        StarterGui:SetCore("ResetButtonCallback", false)
        print("✓ Disabled reset button")
    end)
end

-- =====================================================
-- ENVIRONMENT DETECTION
-- =====================================================

local EnvironmentDetector = {}

function EnvironmentDetector.isStudio()
    return RunService:IsStudio()
end

function EnvironmentDetector.isClient()
    return RunService:IsClient()
end

function EnvironmentDetector.isServer()
    return RunService:IsServer()
end

function EnvironmentDetector.getPlaceType()
    local placeId = game.PlaceId
    local jobId = game.JobId
    
    return {
        placeId = placeId,
        jobId = jobId,
        isPrivateServer = game.PrivateServerId ~= "" and game.PrivateServerOwnerId ~= 0,
        isStudio = EnvironmentDetector.isStudio()
    }
end

-- =====================================================
-- MODULE DISCOVERY
-- =====================================================

local ModuleScanner = {}

function ModuleScanner.findModulesInPath(root, path)
    local results = {}
    local current = root
    
    for segment in string.gmatch(path, "[^/]+") do
        local found = current:FindFirstChild(segment)
        if found then
            current = found
        else
            return nil
        end
    end
    
    return current
end

function ModuleScanner.scanReplicatedStorage()
    print("\n=== Scanning ReplicatedStorage ===")
    
    local paths = {
        "TS/games/games-utils",
        "TS/util/place-utils",
        "TS/store/rodux",
        "TS/game-modes/queue/queue-meta",
        "rbxts_include",
        "Modules",
        "Engine/Modules"
    }
    
    for _, path in ipairs(paths) do
        local found = ModuleScanner.findModulesInPath(ReplicatedStorage, path)
        if found then
            print("✓ Found: " .. path)
            
            -- Try to list children
            pcall(function()
                for _, child in ipairs(found:GetChildren()) do
                    print("  - " .. child.Name .. " (" .. child.ClassName .. ")")
                end
            end)
        else
            print("✗ Not found: " .. path)
        end
    end
end

function ModuleScanner.findStoreModule()
    -- Look for Rodux/state management
    local paths = {
        "TS/store/rodux",
        "Modules/Store",
        "Modules/State",
        "Store",
        "State"
    }
    
    for _, path in ipairs(paths) do
        local found = ModuleScanner.findModulesInPath(ReplicatedStorage, path)
        if found then
            print("✓ Found store at: " .. path)
            return found
        end
    end
    
    return nil
end

-- =====================================================
-- CLIENT READY SIGNAL
-- =====================================================

local function createClientReadySignal()
    pcall(function()
        local clientReady = Instance.new("BoolValue")
        clientReady.Name = "ClientReady"
        clientReady.Value = true
        clientReady.Parent = Workspace
        print("✓ Created ClientReady signal")
    end)
end

-- =====================================================
-- FLAMEWORK/DEPENDENCY DETECTION
-- =====================================================

local function detectFrameworks()
    print("\n=== Detecting Frameworks ===")
    
    local frameworks = {
        {name = "Flamework", paths = {"rbxts_include/@easy-games", "flame/flamework-client"}},
        {name = "Rodux", paths = {"TS/store/rodux", "Modules/Rodux"}},
        {name = "Roact", paths = {"Modules/Roact", "rbxts_include/roact"}},
        {name = "GameCore", paths = {"rbxts_include/@easy-games/game-core"}},
        {name = "Lobby", paths = {"rbxts_include/@easy-games/lobby"}}
    }
    
    for _, framework in ipairs(frameworks) do
        local found = false
        for _, path in ipairs(framework.paths) do
            if ModuleScanner.findModulesInPath(ReplicatedStorage, path) then
                print("✓ " .. framework.name .. " detected at: " .. path)
                found = true
                break
            end
        end
        if not found then
            print("✗ " .. framework.name .. " not found")
        end
    end
end

-- =====================================================
-- MAIN EXECUTION
-- =====================================================

print("\n=== Islands Core Utils ===")
print("Environment: " .. (EnvironmentDetector.isStudio() and "Studio" or "Game"))
print("PlaceId: " .. game.PlaceId)

-- Scan the game structure
ModuleScanner.scanReplicatedStorage()
detectFrameworks()

-- Optional: Enable core modifications
-- Uncomment to use:
-- disableBackpack()
-- disableResetButton()
-- createClientReadySignal()

print("\n=== Islands Core Utils Ready ===")
print("Available functions:")
print("  - disableBackpack()")
print("  - disableAllCoreGui()")
print("  - disableResetButton()")
print("  - EnvironmentDetector.getPlaceType()")
print("  - ModuleScanner.scanReplicatedStorage()")
print("  - createClientReadySignal()")

return {
    disableBackpack = disableBackpack,
    disableAllCoreGui = disableAllCoreGui,
    disableResetButton = disableResetButton,
    EnvironmentDetector = EnvironmentDetector,
    ModuleScanner = ModuleScanner,
    createClientReadySignal = createClientReadySignal
}
