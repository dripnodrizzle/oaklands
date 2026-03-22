-- PlanetGravity.client.lua
-- Client-side script for reacting to planet gravity changes in PlanetRB

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- Wait for the RemoteEvent created by the server script
local GravityChangedEvent = ReplicatedStorage:WaitForChild("GravityChanged")

-- Display a notification or update the UI when gravity changes
local function onGravityChanged(planetName: string, gravityValue: number)
	print(string.format(
		"[PlanetGravity] Planet: %s | Gravity: %.2f m/s²",
		planetName,
		gravityValue
	))

	-- Update the player's GUI if a gravity label exists
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if playerGui then
		local gravityHud = playerGui:FindFirstChild("GravityHUD")
		if gravityHud then
			local label = gravityHud:FindFirstChild("GravityLabel")
			if label and label:IsA("TextLabel") then
				label.Text = string.format("Planet: %s  |  Gravity: %.2f m/s²", planetName, gravityValue)
			end
		end
	end
end

-- Connect to the server event
GravityChangedEvent.OnClientEvent:Connect(onGravityChanged)
