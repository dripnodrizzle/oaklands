
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
    -- Method 1: Hook LogService MessageOut
    pcall(function()
        LogService.MessageOut:Connect(function(message, messageType)
            if string.find(message, "Memory tracking is currently disabled") or
               string.find(message, "MemoryTrackingEnabled") then
                MemorySuppressor.suppressedCount = MemorySuppressor.suppressedCount + 1
                return true -- Consume the message
            end
        end)
        print("✓ Hooked LogService.MessageOut")
    end)
    
    -- Method 2: Hook warn function using multiple methods
    local oldWarn = warn
    
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
    
    -- Method 3: Disable the actual warning at the source
    pcall(function()
        if Stats.MemoryTrackingEnabled ~= nil then
            Stats.MemoryTrackingEnabled = true
            print("✓ Enabled Stats.MemoryTrackingEnabled")
        end
    end)
    
    print("✓ Memory warning suppression enabled (multi-method)")
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
-- VENDING MACHINE ERROR FIX
-- =====================================================

local VendingMachineFixes = {}
VendingMachineFixes.fixedCount = 0
VendingMachineFixes.preventedErrors = 0

function VendingMachineFixes.fixVendingMachineNilErrors()
    local Player = game.Players.LocalPlayer
    
    -- Wait for the vending machine service to load
    task.spawn(function()
        local success = pcall(function()
            local PlayerScripts = Player:WaitForChild("PlayerScripts", 10)
            if not PlayerScripts then
                warn("⚠️ PlayerScripts not found")
                return
            end
            
            -- Navigate to the vending machine service
            local tsPath = PlayerScripts:FindFirstChild("TS")
            if not tsPath then
                warn("⚠️ TS folder not found")
                return
            end
            
            local blockPath = tsPath:FindFirstChild("block")
            if not blockPath then
                warn("⚠️ block folder not found")
                return
            end
            
            local vendingPath = blockPath:FindFirstChild("vending-machine")
            if not vendingPath then
                warn("⚠️ vending-machine folder not found")
                return
            end
            
            local clientService = vendingPath:FindFirstChild("client-vending-machine-ui-service")
            if not clientService or not clientService:IsA("ModuleScript") then
                warn("⚠️ client-vending-machine-ui-service not found")
                return
            end
            
            print("✓ Found vending machine service, applying fix...")
            
            -- Hook the module by wrapping require
            local oldRequire = require
            local moduleCache = {}
            
            getgenv().require = function(module)
                -- Check if this is the vending machine service
                if module == clientService and not moduleCache[clientService] then
                    local originalModule = oldRequire(module)
                    
                    -- Try to hook the setupViewport function if accessible
                    if type(originalModule) == "table" then
                        for key, value in pairs(originalModule) do
                            if type(value) == "function" and (key == "setupViewport" or key == "setupTopViewport") then
                                local originalFunc = value
                                originalModule[key] = function(...)
                                    local args = {...}
                                    
                                    -- Wrap in pcall to catch nil errors
                                    local success, result = pcall(function()
                                        -- Check if first argument has inventoryRenderBlockModel before calling
                                        if args[1] and type(args[1]) == "table" then
                                            if not args[1].inventoryRenderBlockModel then
                                                VendingMachineFixes.preventedErrors = VendingMachineFixes.preventedErrors + 1
                                                warn("⚠️ Prevented nil inventoryRenderBlockModel access")
                                                return nil -- Return nil instead of crashing
                                            end
                                        end
                                        
                                        return originalFunc(...)
                                    end)
                                    
                                    if success then
                                        return result
                                    else
                                        VendingMachineFixes.preventedErrors = VendingMachineFixes.preventedErrors + 1
                                        warn("⚠️ Caught vending machine error: " .. tostring(result))
                                        return nil
                                    end
                                end
                                
                                VendingMachineFixes.fixedCount = VendingMachineFixes.fixedCount + 1
                                print("✓ Hooked " .. key .. " function")
                            end
                        end
                    end
                    
                    moduleCache[clientService] = originalModule
                    return originalModule
                end
                
                return oldRequire(module)
            end
            
            print("✓ Vending machine fix applied (module hooking enabled)")
        end)
        
        if not success then
            warn("⚠️ Failed to apply vending machine fix")
        end
    end)
    
    -- Also add a global error handler as backup
    task.spawn(function()
        while true do
            task.wait(0.1)
            
            -- Hook into any vending machine related errors via pcall wrapper
            local oldPcall = pcall
            getgenv().pcall = function(func, ...)
                local success, result = oldPcall(func, ...)
                
                if not success and type(result) == "string" then
                    if string.find(result, "inventoryRenderBlockModel") then
                        VendingMachineFixes.preventedErrors = VendingMachineFixes.preventedErrors + 1
                        warn("⚠️ Intercepted vending machine error")
                        return true, nil -- Pretend it succeeded
                    end
                end
                
                return success, result
            end
            
            break -- Only set once
        end
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
VendingMachineFixes.fixVendingMachineNilErrors()

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
print(string.format("✓ Applied %d vending machine hooks", VendingMachineFixes.fixedCount))
print(string.format("✓ Prevented %d vending machine errors", VendingMachineFixes.preventedErrors))

return {
    RoactSuppressor = RoactSuppressor,
    MemorySuppressor = MemorySuppressor,
    PromiseInterceptor = PromiseInterceptor,
    RemoteRevealer = RemoteRevealer,
    RemoteLogger = RemoteLogger,
    TimeoutBypass = TimeoutBypass,
    InteractFixes = InteractFixes,
    VendingMachineFixes = VendingMachineFixes
}
