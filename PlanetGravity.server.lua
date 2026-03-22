local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

Workspace.Gravity = 0

local PLANET_CORE = Workspace:WaitForChild("PlanetCore")
local REMOTE_NAME = "PlanetGravityInput"

local GRAVITY_ACCELERATION = 260
local WALK_SPEED = 30
local AIR_CONTROL_SPEED = 12
local JUMP_SPEED = 58
local GROUND_CHECK_DISTANCE = 7
local IDLE_DAMPING = 0.82

local remote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
if not remote then
	local newRemote = Instance.new("RemoteEvent")
	newRemote.Name = REMOTE_NAME
	newRemote.Parent = ReplicatedStorage
	remote = newRemote
end

local states = {}

local function safeUnit(v, fallback)
	if v.Magnitude > 1e-5 then
		return v.Unit
	end
	return fallback
end

local function projectOntoPlane(v, normal)
	return v - normal * v:Dot(normal)
end

local function getPlanetUp(worldPosition)
	return safeUnit(worldPosition - PLANET_CORE.Position, Vector3.new(0, 1, 0))
end

local function makeRayParams(character)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {character}
	params.IgnoreWater = false
	return params
end

local function isGrounded(character, rootPart)
	local upDir = getPlanetUp(rootPart.Position)
	local gravityDir = -upDir

	local result = Workspace:Raycast(
		rootPart.Position,
		gravityDir * GROUND_CHECK_DISTANCE,
		makeRayParams(character)
	)

	return result ~= nil
end

local function cleanupOldObjects(rootPart)
	for _, name in ipairs({
		"PlanetGravityAttachment",
		"PlanetGravityForce",
		"PlanetAlignOrientation",
		"GravityDebug",
	}) do
		local obj = rootPart:FindFirstChild(name)
		if obj then
			obj:Destroy()
		end
	end
end

local function setupCharacter(character)
	local player = Players:GetPlayerFromCharacter(character)
	local humanoid = character:WaitForChild("Humanoid")
	local rootPart = character:WaitForChild("HumanoidRootPart")

	cleanupOldObjects(rootPart)

	pcall(function()
		rootPart:SetNetworkOwner(player)
	end)

	humanoid.AutoRotate = false
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	humanoid.UseJumpPower = true
	humanoid.MaxSlopeAngle = 89

	humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

	local attachment = Instance.new("Attachment")
	attachment.Name = "PlanetGravityAttachment"
	attachment.Parent = rootPart

	local gravityForce = Instance.new("VectorForce")
	gravityForce.Name = "PlanetGravityForce"
	gravityForce.Attachment0 = attachment
	gravityForce.RelativeTo = Enum.ActuatorRelativeTo.World
	gravityForce.ApplyAtCenterOfMass = true
	gravityForce.Parent = rootPart

	local align = Instance.new("AlignOrientation")
	align.Name = "PlanetAlignOrientation"
	align.Attachment0 = attachment
	align.Mode = Enum.OrientationAlignmentMode.OneAttachment
	align.RigidityEnabled = false
	align.ReactionTorqueEnabled = false
	align.Responsiveness = 20
	align.MaxTorque = 100000
	align.Parent = rootPart

	local debugPart = Instance.new("Part")
	debugPart.Name = "GravityDebug"
	debugPart.Anchored = false
	debugPart.CanCollide = false
	debugPart.Massless = true
	debugPart.Material = Enum.Material.Neon
	debugPart.Color = Color3.fromRGB(255, 0, 0)
	debugPart.Size = Vector3.new(0.35, 0.35, 10)
	debugPart.Parent = rootPart

	states[character] = {
		Player = player,
		Humanoid = humanoid,
		RootPart = rootPart,
		GravityForce = gravityForce,
		Align = align,
		MoveInput = Vector3.zero,
		JumpRequested = false,
		LastForward = Vector3.new(0, 0, -1),
		LastJumpTime = 0,
		LastDebugPrint = 0,
	}

	character.AncestryChanged:Connect(function(_, parent)
		if not parent then
			states[character] = nil
		end
	end)
end

local function cleanupCharacter(character)
	states[character] = nil
end

remote.OnServerEvent:Connect(function(player, payload)
	if typeof(payload) ~= "table" then
		return
	end

	local character = player.Character
	if not character then
		return
	end

	local state = states[character]
	if not state then
		return
	end

	if typeof(payload.moveInput) == "Vector3" then
		state.MoveInput = payload.moveInput
	end

	if typeof(payload.jumpRequested) == "boolean" then
		state.JumpRequested = payload.jumpRequested
	end
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(setupCharacter)
	player.CharacterRemoving:Connect(cleanupCharacter)

	if player.Character then
		setupCharacter(player.Character)
	end
end)

for _, player in ipairs(Players:GetPlayers()) do
	player.CharacterAdded:Connect(setupCharacter)
	player.CharacterRemoving:Connect(cleanupCharacter)

	if player.Character then
		setupCharacter(player.Character)
	end
end

RunService.Heartbeat:Connect(function()
	for character, state in pairs(states) do
		local humanoid = state.Humanoid
		local rootPart = state.RootPart

		if not character.Parent or not rootPart.Parent or humanoid.Health <= 0 then
			states[character] = nil
			continue
		end

		local upDir = getPlanetUp(rootPart.Position)
		local gravityDir = -upDir

		state.GravityForce.Force = gravityDir * rootPart.AssemblyMass * GRAVITY_ACCELERATION

		local debugPart = rootPart:FindFirstChild("GravityDebug")
		if debugPart then
			debugPart.CFrame = CFrame.lookAt(
				rootPart.Position + gravityDir * 5,
				rootPart.Position + gravityDir * 10
			)
		end

		local currentLook = projectOntoPlane(rootPart.CFrame.LookVector, upDir)
		currentLook = safeUnit(currentLook, state.LastForward)

		local currentRight = safeUnit(currentLook:Cross(upDir), rootPart.CFrame.RightVector)

		local rawInput = state.MoveInput

		local desiredMove =
			(currentRight * rawInput.X) +
			(currentLook * -rawInput.Z)

		desiredMove = projectOntoPlane(desiredMove, upDir)

		local moveDir = Vector3.zero
		if desiredMove.Magnitude > 0.001 then
			moveDir = desiredMove.Unit
		end

		local facingDir = moveDir
		if facingDir.Magnitude <= 0 then
			facingDir = currentLook
		end
		facingDir = safeUnit(facingDir, state.LastForward)
		state.LastForward = facingDir

		state.Align.CFrame = CFrame.lookAt(
			rootPart.Position,
			rootPart.Position + facingDir,
			upDir
		)

		local grounded = isGrounded(character, rootPart)

		local velocity = rootPart.AssemblyLinearVelocity
		local radialVelocity = upDir * velocity:Dot(upDir)
		local tangentVelocity = velocity - radialVelocity

		if moveDir.Magnitude > 0 then
			local speed = grounded and WALK_SPEED or AIR_CONTROL_SPEED
			rootPart.AssemblyLinearVelocity = radialVelocity + (moveDir * speed)
		else
			rootPart.AssemblyLinearVelocity = radialVelocity + (tangentVelocity * IDLE_DAMPING)
		end

		local humState = humanoid:GetState()
		if humState == Enum.HumanoidStateType.PlatformStanding
			or humState == Enum.HumanoidStateType.Physics
			or humState == Enum.HumanoidStateType.Ragdoll
			or humState == Enum.HumanoidStateType.FallingDown
			or humState == Enum.HumanoidStateType.Seated then

			if grounded then
				humanoid:ChangeState(Enum.HumanoidStateType.Running)
			else
				humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
			end
		end

		if state.JumpRequested and grounded and (time() - state.LastJumpTime) > 0.12 then
			local currentVelocity = rootPart.AssemblyLinearVelocity
			local currentRadial = upDir * currentVelocity:Dot(upDir)
			local currentTangentOnly = currentVelocity - currentRadial
			rootPart.AssemblyLinearVelocity = currentTangentOnly + upDir * JUMP_SPEED
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			state.LastJumpTime = time()
		end

		if time() - state.LastDebugPrint > 1 then
			state.LastDebugPrint = time()
			print("Input:", rawInput, "MoveDir:", moveDir, "Grounded:", grounded)
		end

		state.JumpRequested = false
	end
end)
