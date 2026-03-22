-- PlanetGravity.server.lua
-- Server-side script for managing planet gravity in PlanetRB

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Default gravity value (Roblox default is 196.2)
local DEFAULT_GRAVITY = 196.2

-- Table mapping planet names to their gravity values (studs/s^2)
local PlanetGravities = {
	Mercury = 3.7,
	Venus   = 8.87,
	Earth   = 9.81,
	Mars    = 3.72,
	Jupiter = 24.79,
	Saturn  = 10.44,
	Uranus  = 8.87,
	Neptune = 11.15,
	Moon    = 1.62,
}

-- RemoteEvent used to notify clients of gravity changes
local GravityChangedEvent = Instance.new("RemoteEvent")
GravityChangedEvent.Name = "GravityChanged"
GravityChangedEvent.Parent = ReplicatedStorage

-- Apply gravity for the given planet name
local function applyGravity(planetName: string)
	local gravity = PlanetGravities[planetName]
	if gravity then
		workspace.Gravity = gravity * 10  -- scale to Roblox studs
		GravityChangedEvent:FireAllClients(planetName, gravity)
		print("[PlanetGravity] Gravity set for planet:", planetName, "->", gravity)
	else
		warn("[PlanetGravity] Unknown planet:", planetName)
	end
end

-- Reset gravity to Roblox default
local function resetGravity()
	workspace.Gravity = DEFAULT_GRAVITY
	GravityChangedEvent:FireAllClients("Default", DEFAULT_GRAVITY)
	print("[PlanetGravity] Gravity reset to default:", DEFAULT_GRAVITY)
end

-- Expose functions for other server scripts
return {
	applyGravity = applyGravity,
	resetGravity = resetGravity,
	PlanetGravities = PlanetGravities,
}
