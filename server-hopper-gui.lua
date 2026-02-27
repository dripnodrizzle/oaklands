

-- Use http_request for HTTP requests (executor only)
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local PLACE_ID = game.PlaceId

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ServerHopperGui"
ScreenGui.Parent = player.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Available Servers"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 24
Title.Parent = Frame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Parent = Frame

local function getServers()
    local servers = {}
    local cursor = ""
    local fetchCount = 0
    repeat
        local url = "https://games.roblox.com/v1/games/" .. PLACE_ID .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end
        local result = nil
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
        if success and response and response.Body then
            local ok, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(response.Body)
            end)
            if ok and data and data.data then
                for _, server in ipairs(data.data) do
                    if server.playing < server.maxPlayers then
                        table.insert(servers, server)
                    end
                end
                cursor = data.nextPageCursor or ""
            else
                cursor = ""
            end
        else
            cursor = ""
        end
        fetchCount = fetchCount + 1
        if fetchCount > 5 then break end
    until cursor == "" or #servers >= 100
    return servers
end

-- Create server buttons
local function populateServers()
    ScrollingFrame:ClearAllChildren()
    local servers = getServers()
    local y = 0
    for i, server in ipairs(servers) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.Position = UDim2.new(0, 5, 0, y)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 20
        btn.Text = "Players: " .. server.playing .. "/" .. server.maxPlayers .. " | Ping: " .. server.ping .. "ms"
        btn.Parent = ScrollingFrame
        btn.MouseButton1Click:Connect(function()
            TeleportService:TeleportToPlaceInstance(PLACE_ID, server.id, player)
        end)
        y = y + 45
    end
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, y)
end

populateServers()

-- Refresh button
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0, 100, 0, 30)
RefreshBtn.Position = UDim2.new(1, -110, 1, -40)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.TextSize = 18
RefreshBtn.Text = "Refresh"
RefreshBtn.Parent = Frame
RefreshBtn.MouseButton1Click:Connect(populateServers)

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 18
CloseBtn.Text = "X"
CloseBtn.Parent = Frame
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Done!
