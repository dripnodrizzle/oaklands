-- Configuration
local CONFIG = {
    enabled = true,
    maxDepth = 3,
    maxTableItems = 10
}

local function formatValue(value, depth, visited)
    depth = depth or 0
    visited = visited or {}
    
    if depth > CONFIG.maxDepth then
        return "..."
    end
    
    local valueType = type(value)
    
    if valueType == "string" then
        return '"' .. value .. '"'
    elseif valueType == "number" then
        return tostring(value)
    elseif valueType == "boolean" then
        return tostring(value)
    elseif valueType == "nil" then
        return "nil"
    elseif valueType == "function" then
        return "function"
    elseif valueType == "table" then
        if visited[value] then
            return "(circular)"
        end
        visited[value] = true
        
        local items = {}
        local count = 0
        for k, v in pairs(value) do
            count = count + 1
            if count > CONFIG.maxTableItems then
                table.insert(items, "...")
                break
            end
            table.insert(items, tostring(k) .. "=" .. formatValue(v, depth + 1, visited))
        end
        return "{" .. table.concat(items, ", ") .. "}"
    elseif valueType == "userdata" then
        -- Check for special Roblox types
        local success, result = pcall(function()
            -- Vector3
            if typeof(value) == "Vector3" then
                return string.format("Vector3(%g, %g, %g)", value.X, value.Y, value.Z)
            -- CFrame
            elseif typeof(value) == "CFrame" then
                local pos = value.Position
                return string.format("CFrame(%g, %g, %g, ...)", pos.X, pos.Y, pos.Z)
            -- Color3
            elseif typeof(value) == "Color3" then
                return string.format("Color3(%g, %g, %g)", value.R, value.G, value.B)
            -- Vector2
            elseif typeof(value) == "Vector2" then
                return string.format("Vector2(%g, %g)", value.X, value.Y)
            -- Instance
            elseif value.ClassName and value.Name then
                return value.ClassName .. " '" .. value.Name .. "'"
            end
            return tostring(value)
        end)
        
        if success then
            return result
        end
        return tostring(value)
    else
        return tostring(value)
    end
end

local function formatArgs(...)
    local args = {...}
    if #args == 0 then
        return "(no arguments)"
    end
    
    local formatted = {}
    for i, arg in ipairs(args) do
        table.insert(formatted, formatValue(arg))
    end
    return string.format("(%d args): %s", #args, table.concat(formatted, ", "))
end

local function getTimestamp()
    local seconds = tick() % 86400 -- Seconds since midnight
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

local function log(str)
    print("[" .. getTimestamp() .. "][Client]: " .. str)
end

local function serverLog(str)
    if CONFIG.enabled then
        print("[" .. getTimestamp() .. "][Server]: " .. str)
    end
end

local function hookRemote(remote)
    local remotePath = remote:GetFullName()
    
    pcall(function()
        if remote:IsA("RemoteEvent") then
            -- Hook client -> server (FireServer)
            if remote.FireServer then
                local oldFireServer = remote.FireServer
                remote.FireServer = function(self, ...)
                    serverLog("→ " .. remotePath .. " " .. formatArgs(...))
                    return oldFireServer(self, ...)
                end
            end
            
            -- Hook lowercase fireServer
            if remote.fireServer then
                local oldFireServerLower = remote.fireServer
                remote.fireServer = function(self, ...)
                    serverLog("→ " .. remotePath .. " " .. formatArgs(...))
                    return oldFireServerLower(self, ...)
                end
            end
            
            -- Hook server -> client (OnClientEvent)
            if remote.OnClientEvent then
                local oldConnect = remote.OnClientEvent.Connect
                remote.OnClientEvent.Connect = function(self, func)
                    return oldConnect(self, function(...)
                        log("← " .. remotePath .. " " .. formatArgs(...))
                        return func(...)
                    end)
                end
            end
            
        elseif remote:IsA("RemoteFunction") then
            -- Hook client -> server (InvokeServer)
            if remote.InvokeServer then
                local oldInvokeServer = remote.InvokeServer
                remote.InvokeServer = function(self, ...)
                    serverLog("→ " .. remotePath .. " " .. formatArgs(...))
                    local results = {oldInvokeServer(self, ...)}
                    return table.unpack(results)
                end
            end
            
            -- Hook lowercase invokeServer
            if remote.invokeServer then
                local oldInvokeServerLower = remote.invokeServer
                remote.invokeServer = function(self, ...)
                    serverLog("→ " .. remotePath .. " " .. formatArgs(...))
                    local results = {oldInvokeServerLower(self, ...)}
                    return table.unpack(results)
                end
            end
        end
    end)
end

local function hookAllRemotes()
    log("Starting remote hooking process...")
    local hooked = 0
    local foundRemotes = {}
    local errors = 0
    
    -- Hook existing remotes
    for _, remote in pairs(game:GetDescendants()) do
        if (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) and remote.Parent then
            table.insert(foundRemotes, remote:GetFullName())
            local success, err = pcall(function()
                hookRemote(remote)
                hooked = hooked + 1
            end)
            if not success then
                errors = errors + 1
                warn("Failed to hook " .. remote:GetFullName() .. ": " .. tostring(err))
            end
        end
    end
    
    -- Log what we found
    log("Found " .. #foundRemotes .. " remotes:")
    for i = 1, math.min(10, #foundRemotes) do
        log("  - " .. foundRemotes[i])
    end
    if #foundRemotes > 10 then
        log("  ... and " .. (#foundRemotes - 10) .. " more")
    end
    log("Successfully hooked " .. hooked .. " remotes (" .. errors .. " errors)")
    log("→ = Client->Server | ← = Server->Client")
    log("Monitoring all network traffic...")
    
    -- Hook new remotes as they're added
    game.DescendantAdded:Connect(function(remote)
        if (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) and remote.Parent then
            task.wait(0.1)
            pcall(function()
                hookRemote(remote)
                log("Hooked new remote: " .. remote:GetFullName())
            end)
        end
    end)
end

hookAllRemotes()
