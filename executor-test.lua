-- Roblox Executor Test Script
-- Run this to check what works in your experience

-- 1. Basic print and loop
print("Executor Test: Basic print works!")
for i = 1, 3 do print("Loop test:", i) end

-- 2. Player and game services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
print("Player name:", player and player.Name or "N/A")

-- 3. GUI creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ExecutorTestGui"
ScreenGui.Parent = player and player.PlayerGui or game.CoreGui
local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(0, 300, 0, 50)
Label.Position = UDim2.new(0.5, -150, 0.5, -25)
Label.Text = "GUI Test: Success!"
Label.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.Font = Enum.Font.SourceSansBold
Label.TextSize = 24
Label.Parent = ScreenGui

-- 4. HttpService:GetAsync test
local HttpService = game:GetService("HttpService")
local PLACE_ID = game.PlaceId
local url = "https://games.roblox.com/v1/games/" .. PLACE_ID .. "/servers/Public?sortOrder=Asc&limit=1"
-- NOTE: Your executor blocks HttpService:GetAsync for security reasons.
local httpSuccess, httpResult = pcall(function()
    return HttpService:GetAsync(url)
end)
if httpSuccess then
    print("HttpService:GetAsync works! Result:", httpResult)
    if Label and Label.Parent then
        Label.Text = Label.Text .. "\nHttpService: Success!"
    end
else
    print("HttpService:GetAsync failed:", httpResult)
    if Label and Label.Parent then
        Label.Text = Label.Text .. "\nHttpService: Failed! (Blocked by executor or not supported)"
    end
end

-- 5. TeleportService test (will teleport you if allowed)
local TeleportService = game:GetService("TeleportService")
local teleportSuccess, teleportResult = pcall(function()
    return TeleportService:TeleportToPlaceInstance(PLACE_ID, game.JobId, player)
end)
if teleportSuccess then
    print("TeleportService: Success!")
   if Label and Label.Parent then
        Label.Text = Label.Text .. "\nTeleportService: Success!"
    end
else
    print("TeleportService: Failed:", teleportResult)
    Label.Text = Label.Text .. "\nTeleportService: Failed!"
end

-- 6. Instance creation test
local Part = Instance.new("Part")
Part.Name = "ExecutorTestPart"
Part.Size = Vector3.new(4, 1, 2)
Part.Position = player and player.Character and player.Character:GetPivot().Position + Vector3.new(0, 5, 0) or Vector3.new(0, 10, 0)
Part.Anchored = true
Part.Parent = workspace
print("Instance creation: Part created!")

-- 7. Check for exploit environment globals
if getgenv then print("getgenv exists!") else print("getgenv missing!") end
if isexecutor then print("isexecutor exists!") else print("isexecutor missing!") end
if syn then print("syn exists!") else print("syn missing!") end

-- 8. Check for custom HTTP request functions (syn.request, http_request, request)
local function testCustomHttp()
    local url = "https://httpbin.org/get"
    local body = nil
    if syn and syn.request then
        print("syn.request exists! Testing...")
        local result = syn.request({Url = url, Method = "GET"})
        print("syn.request result:", result and result.Body or result)
        body = result and result.Body
    elseif http_request then
        print("http_request exists! Testing...")
        local result = http_request({Url = url, Method = "GET"})
        print("http_request result:", result and result.Body or result)
        body = result and result.Body
    elseif request then
        print("request exists! Testing...")
        local result = request({Url = url, Method = "GET"})
        print("request result:", result and result.Body or result)
        body = result and result.Body
    else
        print("No custom HTTP request function found (syn.request, http_request, request)")
    end
    if Label and Label.Parent then
        if body then
            Label.Text = Label.Text .. "\nCustom HTTP: Success!"
        else
            Label.Text = Label.Text .. "\nCustom HTTP: Not available."
        end
    end
end

testCustomHttp()

-- End of test script
print("Executor Test Complete.")
