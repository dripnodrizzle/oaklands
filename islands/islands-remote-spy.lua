-- Islands Remote Spy & Decoder
-- Intercept and decode obfuscated RemoteEvents

print("Islands Remote Spy Loading...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- =====================================================
-- REMOTE DECODER
-- =====================================================

local RemoteDecoder = {}
RemoteDecoder.decodedNames = {}

-- Known obfuscated remotes from error logs
RemoteDecoder.knownRemotes = {
    ["AbjkcahMIсKwаoxрYgEmfewtjeq/UtRjnxfхОР"] = "UNKNOWN_OBFUSCATED_1",
    ["UpdateIconTree"] = "Update Icon Tree",
    ["GetHighlightVisibilitystate"] = "Get Highlight Visibility State"
}

function RemoteDecoder.decodeRemoteName(name)
    -- Check if we know this remote
    if RemoteDecoder.knownRemotes[name] then
        return RemoteDecoder.knownRemotes[name]
    end
    
    -- Try to decode if it's obfuscated
    local isObfuscated = #name > 20 or string.match(name, "[^%w_]")
    
    if isObfuscated then
        return "OBFUSCATED_" .. string.sub(name, 1, 10) .. "..."
    end
    
    return name
end

-- =====================================================
-- REMOTE TRAFFIC INTERCEPTOR
-- =====================================================

local TrafficInterceptor = {}
TrafficInterceptor.traffic = {}
TrafficInterceptor.enabled = false

function TrafficInterceptor.hookRemote(remote, remotePath)
    -- Skip if not a RemoteEvent or RemoteFunction
    if not (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
        return
    end
    
    -- Protect against errors
    pcall(function()
        if remote:IsA("RemoteEvent") then
            -- Check if FireServer exists (some managed remotes don't have it)
            if not remote.FireServer then
                return
            end
            
            -- Hook FireServer
            local oldFireServer = remote.FireServer
            remote.FireServer = function(self, ...)
                local args = {...}
                local decodedName = RemoteDecoder.decodeRemoteName(remote.Name)
                
                print(string.format("→ [SEND] %s (%d args)", decodedName, #args))
                
                -- Log arguments
                for i, arg in ipairs(args) do
                    local argType = type(arg)
                    local argValue = tostring(arg)
                    
                    if argType == "table" then
                        pcall(function()
                            argValue = HttpService:JSONEncode(arg)
                        end)
                    end
                    
                    print(string.format("   [%d] %s: %s", i, argType, argValue))
                end
                
                table.insert(TrafficInterceptor.traffic, {
                    direction = "send",
                    remote = remote.Name,
                    decodedName = decodedName,
                    args = args,
                    timestamp = tick()
                })
                
                return oldFireServer(self, ...)
            end
        end
    end)
    end
    
    -- Hook OnClientEvent
    remote.OnClientEvent:Connect(function(...)
        local args = {...}
        local decodedName = RemoteDecoder.decodeRemoteName(remote.Name)
        
        print(string.format("← [RECV] %s (%d args)", decodedName, #args))
        
        -- Log arguments
        for i, arg in ipairs(args) do
            local argType = type(arg)
            local argValue = tostring(arg)
            
            if argType == "table" then
                pcall(function()
                    argValue = HttpService:JSONEncode(arg)
                end)
            end
            
            print(string.format("   [%d] %s: %s", i, argType, argValue))
        end
        
        table.insert(TrafficInterceptor.traffic, {
            direction = "receive",
            remote = remote.Name,
            decodedName = decodedName,
            args = args,
            timestamp = tick()
        })
    end)
end

function TrafficInterceptor.hookAllRemotes()
    print("\n=== Hooking All RemoteEvents ===")
    
    local count = 0
    
    local function scanContainer(container, path)
        for _, child in ipairs(container:GetChildren()) do
            local fullPath = path .. "/" .. child.Name
            
            if child:IsA("RemoteEvent") then
                TrafficInterceptor.hookRemote(child, fullPath)
                count = count + 1
                
                local decoded = RemoteDecoder.decodeRemoteName(child.Name)
                print(string.format("✓ Hooked: %s -> %s", child.Name, decoded))
            end
            
            -- Recurse
            if #child:GetChildren() > 0 then
                scanContainer(child, fullPath)
            end
        end
    end
    
    scanContainer(ReplicatedStorage, "ReplicatedStorage")
    
    print(string.format("\n✓ Hooked %d RemoteEvents", count))
    TrafficInterceptor.enabled = true
end

function TrafficInterceptor.dumpTraffic(count)
    count = count or 20
    print(string.format("\n=== Last %d Remote Calls ===", count))
    
    local start = math.max(1, #TrafficInterceptor.traffic - count + 1)
    for i = start, #TrafficInterceptor.traffic do
        local traffic = TrafficInterceptor.traffic[i]
        local arrow = traffic.direction == "send" and "→" or "←"
        
        print(string.format("[%d] %s %s - %d args (%.1fs ago)", 
            i, arrow, traffic.decodedName, #traffic.args, tick() - traffic.timestamp))
    end
end

-- =====================================================
-- REMOTE FUNCTION INTERCEPTOR
-- =====================================================

local FunctionInterceptor = {}

function FunctionInterceptor.hookRemoteFunction(remoteFunc, path)
    if not remoteFunc:IsA("RemoteFunction") then
        return
    end
    
    -- Hook InvokeServer
    local oldInvokeServer = remoteFunc.InvokeServer
    remoteFunc.InvokeServer = function(self, ...)
        local args = {...}
        local decodedName = RemoteDecoder.decodeRemoteName(remoteFunc.Name)
        
        print(string.format("→ [INVOKE] %s (%d args)", decodedName, #args))
        
        local result = oldInvokeServer(self, ...)
        
        print(string.format("← [RETURN] %s: %s", decodedName, tostring(result)))
        
        return result
    end
    
    print(string.format("✓ Hooked RemoteFunction: %s", remoteFunc.Name))
end

function FunctionInterceptor.hookAllRemoteFunctions()
    print("\n=== Hooking RemoteFunctions ===")
    
    local function scanContainer(container)
        for _, child in ipairs(container:GetDescendants()) do
            if child:IsA("RemoteFunction") then
                FunctionInterceptor.hookRemoteFunction(child, child:GetFullName())
            end
        end
    end
    
    scanContainer(ReplicatedStorage)
end

-- =====================================================
-- OBFUSCATED NAME FINDER
-- =====================================================

local ObfuscatedFinder = {}

function ObfuscatedFinder.findSuspiciousRemotes()
    print("\n=== Finding Suspicious RemoteEvents ===")
    
    local suspicious = {}
    
    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local name = remote.Name
            
            -- Check for obfuscation patterns
            local patterns = {
                {pattern = "[^%w_]", reason = "Special characters"},
                {pattern = "^[A-Z][a-z][A-Z]", reason = "Mixed case without separators"},
                {check = function() return #name > 30 end, reason = "Very long name"},
                {check = function() return name:match("^%u+$") and #name > 10 end, reason = "All uppercase"},
                {check = function() return name:match("^%l+$") and #name > 20 end, reason = "All lowercase long"}
            }
            
            for _, check in ipairs(patterns) do
                local isSuspicious = false
                local reason = ""
                
                if check.pattern then
                    if name:match(check.pattern) then
                        isSuspicious = true
                        reason = check.reason
                    end
                elseif check.check then
                    if check.check() then
                        isSuspicious = true
                        reason = check.reason
                    end
                end
                
                if isSuspicious then
                    table.insert(suspicious, {
                        name = name,
                        path = remote:GetFullName(),
                        reason = reason,
                        remote = remote
                    })
                    break
                end
            end
        end
    end
    
    print(string.format("Found %d suspicious remotes:", #suspicious))
    for i, item in ipairs(suspicious) do
        print(string.format("%d. %s (%s)", i, item.name, item.reason))
        print(string.format("   Path: %s", item.path))
    end
    
    return suspicious
end

-- =====================================================
-- MAIN EXECUTION
-- =====================================================

print("\n=== Islands Remote Spy ===")

-- Find suspicious remotes first
local suspicious = ObfuscatedFinder.findSuspiciousRemotes()

print("\n=== Starting Remote Interception ===")

-- Hook everything
TrafficInterceptor.hookAllRemotes()
FunctionInterceptor.hookAllRemoteFunctions()

print("\n=== Available Commands ===")
print("  TrafficInterceptor.dumpTraffic(20) - Show last 20 remote calls")
print("  ObfuscatedFinder.findSuspiciousRemotes() - Find suspicious remotes")
print("  RemoteDecoder.decodeRemoteName(name) - Decode a remote name")

print("\n✓ Remote spy is now active")
print("All RemoteEvent traffic will be logged in real-time")

return {
    RemoteDecoder = RemoteDecoder,
    TrafficInterceptor = TrafficInterceptor,
    FunctionInterceptor = FunctionInterceptor,
    ObfuscatedFinder = ObfuscatedFinder
}
