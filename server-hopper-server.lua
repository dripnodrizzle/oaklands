-- Place this in ServerScriptService
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- Create RemoteFunction if not present
local remote = ReplicatedStorage:FindFirstChild("ServerListRequest")
if not remote then
    remote = Instance.new("RemoteFunction")
    remote.Name = "ServerListRequest"
    remote.Parent = ReplicatedStorage
end

local PLACE_ID = game.PlaceId

remote.OnServerInvoke = function(player)
    local servers = {}
    local cursor = ""
    local maxFetch = 100
    local fetched = 0
    repeat
        local url = "https://games.roblox.com/v1/games/" .. PLACE_ID .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end
        local success, result = pcall(function()
            return HttpService:GetAsync(url)
        end)
        if success then
            local data = HttpService:JSONDecode(result)
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers then
                    table.insert(servers, server)
                    fetched = fetched + 1
                end
            end
            cursor = data.nextPageCursor or ""
        else
            cursor = ""
        end
    until cursor == "" or fetched >= maxFetch
    return servers
end
