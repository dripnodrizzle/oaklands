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

local function hookClientServerCommunication()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    if not LocalPlayer then
        warn("LocalPlayer not found")
        return
    end
    
    local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts", 5)
    if not PlayerScripts then
        warn("PlayerScripts not found")
        return
    end
    
    local RbxEvent = PlayerScripts:FindFirstChild("RbxEvent")
    if not RbxEvent then
        warn("RbxEvent not found in PlayerScripts")
        return
    end
    
    local success, err = pcall(function()
        local oldSendToServer = RbxEvent.SendToServer
        
        function RbxEvent:SendToServer(...)
            serverLog(formatArgs(...))
            local results = {oldSendToServer(self, ...)}
            return table.unpack(results)
        end
    end)
    
    if success then
        log("Successfully hooked client-server communication")
    else
        warn("Failed to hook communication: " .. tostring(err))
    end
end

hookClientServerCommunication()
