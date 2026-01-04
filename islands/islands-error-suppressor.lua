-- Islands Error Suppressor & Remote Revealer
-- Suppress annoying errors and reveal hidden RemoteEvents

print("Islands Error Suppressor Loading...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LogService = game:GetService("LogService")
local Stats = game:GetService("Stats")

-- =====================================================
-- ROACT CHILDREN WARNING SUPPRESSOR
-- =====================================================

local RoactSuppressor = {}
RoactSuppressor.suppressedCount = 0

function RoactSuppressor.suppressWarnings()
    pcall(function()
        local Roact = require(ReplicatedStorage.rbxts_include.node_modules["@rbxts"].roact.src)
        local Logging = require(ReplicatedStorage.rbxts_include.node_modules["@rbxts"].roact.src.Logging)
        
        if Logging and Logging.warnOnce then
            local originalWarnOnce = Logging.warnOnce
            
            Logging.warnOnce = function(message, ...)
                -- Filter out Children prop warnings
                if string.find(message, "Roact%.Children") or string.find(message, "was defined but was overridden") then
                    RoactSuppressor.suppressedCount = RoactSuppressor.suppressedCount + 1
                    return
                end
                
                return originalWarnOnce(message, ...)
            end
            
            print("✓ Suppressed Roact.Children warnings")
            return true
        end
    end)
    
    return false
end

-- =====================================================
-- MEMORY TRACKING ERROR SUPPRESSOR
-- =====================================================

local MemorySuppressor = {}
MemorySuppressor.suppressedCount = 0

function MemorySuppressor.suppressMemoryWarnings()
    -- Hook warn function directly using multiple methods
    local oldWarn = warn
    
    -- Method 1: Global override
    local function newWarn(...)
        local args = {...}
        local success, message = pcall(function()
            return table.concat(args, " ")
        end)
        
        if success and message then
            -- Filter out memory tracking warnings
            if string.find(message, "Memory tracking is currently disabled") or
               string.find(message, "MemoryTrackingEnabled") then
                MemorySuppressor.suppressedCount = MemorySuppressor.suppressedCount + 1
                return
            end
        end
        
        return oldWarn(...)
    end
    
    -- Set in multiple places
    warn = newWarn
    getgenv().warn = newWarn
    _G.warn = newWarn
    
    -- Also try rawset
    pcall(function()
        rawset(getfenv(), "warn", newWarn)
    end)
    
    -- Try to enable memory tracking
    pcall(function()
        if Stats.MemoryTrackingEnabled ~= nil then
            Stats.MemoryTrackingEnabled = true
            print("✓ Enabled memory tracking")
        end
    end)
    
    print("✓ Hooked warn() to suppress memory warnings (multi-method)")
end

-- =====================================================
-- PROMISE REJECTION INTERCEPTOR
-- =====================================================

local PromiseInterceptor = {}
PromiseInterceptor.rejections = {}
PromiseInterceptor.timedOutRemotes = {}

function PromiseInterceptor.hookPromiseRejections()
    local connection = LogService.MessageOut:Connect(function(message, messageType)
        -- Capture unhandled promise rejections
        if string.find(message, "Unhandled Promise rejection") then
            print("\n[Promise Rejection Detected]")
            print(message)
            
            table.insert(PromiseInterceptor.rejections, {
                message = message,
                timestamp = tick()
            })
            
            -- Extract RemoteEvent name if it's a timeout
            local remoteName = string.match(message, "RemoteEvent '([^']+)'")
            if remoteName then
                print("⚠️ Remote timed out: " .. remoteName)
                table.insert(PromiseInterceptor.timedOutRemotes, {
                    name = remoteName,
                    timestamp = tick()
                })
            end
        end
    end)
    
    print("✓ Monitoring promise rejections")
    return connection
end

function PromiseInterceptor.dumpTimeouts()
    print("\n=== Timed Out RemoteEvents ===")
    for i, remote in ipairs(PromiseInterceptor.timedOutRemotes) do
        print(string.format("%d. %s (%.1fs ago)", i, remote.name, tick() - remote.timestamp))
    end
end

-- =====================================================
-- REMOTE EVENT REVEALER
-- =====================================================

local RemoteRevealer = {}
RemoteRevealer.foundRemotes = {}
RemoteRevealer.obfuscatedRemotes = {}

function RemoteRevealer.scanForRemotes()
    print("\n=== Scanning for RemoteEvents ===")
    
    local function scanContainer(container, path)
        for _, child in ipairs(container:GetChildren()) do
            local fullPath = path .. "/" .. child.Name
            
            if child:IsA("RemoteEvent") then
                local isObfuscated = #child.Name > 20 or string.match(child.Name, "[^%w_]")
                
                if isObfuscated then
                    print(string.format("🔒 Obfuscated: %s", fullPath))
                    table.insert(RemoteRevealer.obfuscatedRemotes, {
                        name = child.Name,
                        path = fullPath,
                        remote = child
                    })
                else
                    print(string.format("📡 Normal: %s", fullPath))
                end
                
                table.insert(RemoteRevealer.foundRemotes, {
                    name = child.Name,
                    path = fullPath,
                    remote = child,
                    obfuscated = isObfuscated
                })
            elseif child:IsA("RemoteFunction") then
                print(string.format("📞 Function: %s", fullPath))
                table.insert(RemoteRevealer.foundRemotes, {
                    name = child.Name,
                    path = fullPath,
                    remote = child,
                    isFunction = true
                })
            end
            
            -- Recurse
            if child:IsA("Folder") or child:IsA("ModuleScript") then
                scanContainer(child, fullPath)
            end
        end
    end
    
    scanContainer(ReplicatedStorage, "ReplicatedStorage")
end

function RemoteRevealer.dumpObfuscatedRemotes()
    print("\n=== Obfuscated RemoteEvents ===")
    for i, remote in ipairs(RemoteRevealer.obfuscatedRemotes) do
        print(string.format("%d. %s", i, remote.path))
        print(string.format("   Name: %s", remote.name))
    end
end

-- =====================================================
-- REMOTE EVENT LOGGER
-- =====================================================

local RemoteLogger = {}
RemoteLogger.enabled = false
RemoteLogger.logs = {}

function RemoteLogger.hookAllRemotes()
    print("\n=== Hooking RemoteEvents ===")
    
    for _, remote in ipairs(RemoteRevealer.foundRemotes) do
        if remote.remote:IsA("RemoteEvent") then
            -- Hook OnClientEvent
            remote.remote.OnClientEvent:Connect(function(...)
                local args = {...}
                local log = string.format("[%s] Fired with %d args", remote.name, #args)
                print(log)
                
                table.insert(RemoteLogger.logs, {
                    remote = remote.name,
                    args = args,
                    timestamp = tick()
                })
            end)
        end
    end
    
    print(string.format("✓ Hooked %d RemoteEvents", #RemoteRevealer.foundRemotes))
    RemoteLogger.enabled = true
end

function RemoteLogger.dumpLogs(count)
    count = count or 10
    print(string.format("\n=== Last %d Remote Calls ===", count))
    
    local start = math.max(1, #RemoteLogger.logs - count + 1)
    for i = start, #RemoteLogger.logs do
        local log = RemoteLogger.logs[i]
        print(string.format("[%d] %s - %d args (%.1fs ago)", 
            i, log.remote, #log.args, tick() - log.timestamp))
    end
end

-- =====================================================
-- TIMEOUT BYPASS
-- =====================================================

local TimeoutBypass = {}

function TimeoutBypass.removeTimeouts()
    pcall(function()
        local ClientEvent = require(ReplicatedStorage.rbxts_include.node_modules["@rbxts"].net.out.client.ClientEvent)
        
        -- This would require hooking the timeout mechanism
        -- The timeout is at line 37 of ClientEvent
        print("⚠️ Timeout bypass would require deeper hooking")
    end)
end

-- =====================================================
-- INTERACT SPECIFIC FIXES
-- =====================================================

local InteractFixes = {}

function InteractFixes.hookWorkbenchInteract()
    pcall(function()
        local Player = game.Players.LocalPlayer
        
        -- Monitor the crafting UI service
        task.spawn(function()
            while true do
                task.wait(1)
                
                -- Check for opened crafting UI
                local playerGui = Player:WaitForChild("PlayerGui")
                if playerGui:FindFirstChild("MouseInteract") then
                    print("🔨 Crafting UI is open")
                end
            end
        end)
    end)
end

-- =====================================================
-- MAIN EXECUTION
-- =====================================================

print("\n=== Islands Error Suppressor ===")

-- Suppress annoying errors
RoactSuppressor.suppressWarnings()
MemorySuppressor.suppressMemoryWarnings()

-- Monitor promises
local promiseConnection = PromiseInterceptor.hookPromiseRejections()

-- Scan for remotes
RemoteRevealer.scanForRemotes()

-- Wait a bit then show obfuscated remotes
task.wait(2)
RemoteRevealer.dumpObfuscatedRemotes()
PromiseInterceptor.dumpTimeouts()

print("\n=== Available Commands ===")
print("  RemoteLogger.hookAllRemotes() - Start logging all remote calls")
print("  RemoteLogger.dumpLogs(10) - Show last 10 remote calls")
print("  RemoteRevealer.dumpObfuscatedRemotes() - List obfuscated remotes")
print("  PromiseInterceptor.dumpTimeouts() - Show timed out remotes")
print(string.format("\n✓ Suppressed %d Roact warnings", RoactSuppressor.suppressedCount))

return {
    RoactSuppressor = RoactSuppressor,
    MemorySuppressor = MemorySuppressor,
    PromiseInterceptor = PromiseInterceptor,
    RemoteRevealer = RemoteRevealer,
    RemoteLogger = RemoteLogger,
    TimeoutBypass = TimeoutBypass,
    InteractFixes = InteractFixes
}
