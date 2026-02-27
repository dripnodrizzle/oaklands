--> Server Hopper - Jump to different servers without leaving the game
--> Great for finding more apples or resetting farming areas
--> Safe: Uses official Roblox TeleportService

print("[Server Hopper] Initializing...")

local Services = setmetatable({}, {
    __index = function(self, index)
        return game:GetService(index)
    end
})

local TeleportService = Services.TeleportService
local Players = Services.Players
local Player = Players.LocalPlayer
local PlaceId = game.PlaceId
local HttpService = Services.HttpService

print("[Hopper] Loaded - Server Hopper v1.0")

print("===== HOPPER COMMANDS =====")
print("_G.ListServers()                 -- List all public servers with player counts")
print("_G.HopToRandomServer()           -- Jump to random server (not current)")
print("_G.HopToServer(jobId)            -- Jump to a specific server by JobId")
print("_G.HopToNewServer()              -- Jump to a new server (not current)")
print("_G.GetCurrentServerCode()        -- Show current server code")
print("_G.AutoHopServers = true/false   -- Auto-hop every 5 minutes")
print("_G.AutoHopInterval = 300         -- Seconds between hops (default 300s = 5min)")
print("=============================")
-- List all public servers for this place, with player counts

local function ListServers()
    print("[Hopper] Fetching public servers...")
    local servers = {}
    local cursor = ""
    local urlBase = "https://games.roblox.com/v1/games/" .. tostring(PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
    local tries = 0
    repeat
        local url = urlBase .. (cursor ~= "" and ("&cursor=" .. cursor) or "")
        print("[Hopper][DEBUG] Requesting URL: " .. url)
        local success, response = pcall(function()
            if http_request then
                return http_request({Url = url, Method = "GET"})
            elseif request then
                return request({Url = url, Method = "GET"})
            elseif syn and syn.request then
                return syn.request({Url = url, Method = "GET"})
            else
                error("No supported HTTP request function found.")
            end
        end)
        local result = nil
        if success and response and response.Body then
            local ok, data = pcall(function()
                return HttpService:JSONDecode(response.Body)
            end)
            if ok and data then
                result = data
            end
        end
        if not result then
            print("[Hopper][ERROR] Http request or JSONDecode failed.")
            break
        end
        if result and result.data then
            print("[Hopper][DEBUG] Servers in this page: " .. tostring(#result.data))
            for _, server in ipairs(result.data) do
                table.insert(servers, server)
            end
            cursor = result.nextPageCursor or ""
        else
            print("[Hopper][ERROR] No data field in response! Full result:")
            print(HttpService:JSONEncode(result))
            break
        end
        tries = tries + 1
        task.wait(0.5)
    until cursor == "" or tries > 5
    print("[Hopper] Found " .. tostring(#servers) .. " servers:")
    for i, server in ipairs(servers) do
        local code = string.sub(server.id, 1, 8)
        local players = server.playing or 0
        local maxPlayers = server.maxPlayers or "?"
        local ping = server.ping or "?"
        local current = (server.id == game.JobId) and "<-- YOU" or ""
        print(string.format("[%d] %s | Players: %d/%s | Ping: %s %s", i, code, players, maxPlayers, tostring(ping), current))
    end
    print("[Hopper] Use _G.HopToServer(jobId) to join a specific server.")
    return servers
end

_G.ListServers = ListServers

_G.HopToServer = function(jobId)
    if _G.IsHopping then
        print("[Hopper] Already hopping, please wait...")
        return false
    end
    if not jobId or jobId == "" then
        print("[Hopper] Invalid JobId.")
        return false
    end
    if jobId == game.JobId then
        print("[Hopper] Already in this server!")
        return false
    end
    _G.IsHopping = true
    print("[Hopper] Hopping to server: " .. tostring(jobId))
    task.wait(0.5)
    pcall(function()
        TeleportService:TeleportToPlaceInstance(PlaceId, jobId, Player)
    end)
    task.wait(2)
    _G.IsHopping = false
    return true
end

_G.AutoHopServers = false
_G.AutoHopInterval = 300
_G.IsHopping = false

--> GET SERVER IDENTIFIER
local function GetServerCode()
    local id = game.JobId
    if id and id ~= "" then
        return string.sub(id, 1, 8)
    end
    return "UNKNOWN"
end

_G.GetCurrentServerCode = function()
    local code = GetServerCode()
    print("[Hopper] Current server code: " .. code)
    print("[Hopper] Game PlaceId: " .. PlaceId)
    return code
end

--> HOP TO RANDOM SERVER

_G.HopToRandomServer = function()
    if _G.IsHopping then
        print("[Hopper] Already hopping, please wait...")
        return false
    end
    _G.IsHopping = true
    print("[Hopper] Searching for a new server...")
    local servers = ListServers()
    local currentJobId = game.JobId
    local candidates = {}
    for _, server in ipairs(servers) do
        if server.id ~= currentJobId and (server.playing or 0) < (server.maxPlayers or 100) then
            table.insert(candidates, server)
        end
    end
    if #candidates == 0 then
        print("[Hopper] No other servers found!")
        _G.IsHopping = false
        return false
    end
    local chosen = candidates[math.random(1, #candidates)]
    print(string.format("[Hopper] Hopping to server %s (%d/%d players)", string.sub(chosen.id,1,8), chosen.playing or 0, chosen.maxPlayers or 0))
    task.wait(0.5)
    pcall(function()
        TeleportService:TeleportToPlaceInstance(PlaceId, chosen.id, Player)
    end)
    task.wait(2)
    _G.IsHopping = false
    return true
end

_G.HopToNewServer = _G.HopToRandomServer

--> AUTO HOP
task.spawn(function()
    local lastHop = tick()
    while true do
        task.wait(10)
        
        if _G.AutoHopServers and (tick() - lastHop) >= _G.AutoHopInterval then
            print("[Hopper] [AUTO] Time for server hop!")
            lastHop = tick()
            _G.HopToRandomServer()
            task.wait(5)
        end
    end
end)

--> REJOIN CURRENT SERVER (if needed)
_G.RejoinCurrentServer = function()
    local code = GetServerCode()
    print("[Hopper] Rejoining server: " .. code)
    
    _G.IsHopping = true
    task.wait(0.5)
    
    pcall(function()
        TeleportService:Teleport(PlaceId, Player)
    end)
    
    task.wait(2)
    _G.IsHopping = false
    return true
end

print("[Hopper] Ready!")
print("")
print("[QUICK START]")
print("  1. _G.HopToRandomServer()        -- Jump to a new server")
print("  2. Or enable _G.AutoHopServers = true for auto-hopping")
print("  3. Watch the screen fade as you transfer")
print("")
print("[TIPS]")
print("  - Hopping takes 5-10 seconds total")
print("  - You'll keep your inventory and status")
print("  - Great for finding fresh apple spawns")
print("  - Default auto-hop is every 5 minutes (300s)")
print("  - Change interval: _G.AutoHopInterval = 600  (for 10 min)")
print("")
