-- LeaderboardManager.lua
-- Handles leaderboard display, player join announcements, and field entry logic

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local LeaderboardManager = {}

-- RemoteEvent for announcing new field joiners
if not Remotes:FindFirstChild("FieldJoinAnnouncement") then
    local event = Instance.new("RemoteEvent")
    event.Name = "FieldJoinAnnouncement"
    event.Parent = Remotes
end

-- RemoteEvent for updating leaderboard
if not Remotes:FindFirstChild("UpdateLeaderboard") then
    local event = Instance.new("RemoteEvent")
    event.Name = "UpdateLeaderboard"
    event.Parent = Remotes
end

-- Call this when a player enters the field
function LeaderboardManager.OnPlayerEnterField(player)
    -- Announce to all field players
    Remotes.FieldJoinAnnouncement:FireAllClients(player.Name)
    -- Show leaderboard to this player
    Remotes.UpdateLeaderboard:FireClient(player)
end

return LeaderboardManager
