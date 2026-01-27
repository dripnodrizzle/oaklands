-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-04 12:20:45
-- Luau version 6, Types version 3
-- Time taken: 0.036550 seconds

local LocalPlayer_upvr = game.Players.LocalPlayer
local Character_upvr_2 = LocalPlayer_upvr.Character
local Humanoid_upvr = Character_upvr_2:WaitForChild("Humanoid")
local ReplicatedStorage_upvr = game.ReplicatedStorage
local RollEvent_upvr = ReplicatedStorage_upvr.Global.RollEvent
local function WMD_upvr(arg1) -- Line 13, Named "WMD"
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var14
	if arg1 == Vector3.new(0, 0, 0) then
		return "Backwards"
	end
	var14 = math.round(math.atan2(arg1.X, -arg1.Z) / (math.pi/2))
	local var15 = -var14 * (math.pi/2)
	var14 = -math.sin(var15)
	local rounded = math.round(var14)
	var14 = math.round(-math.cos(var15))
	if math.abs(rounded) <= 1e-10 then
		rounded = 0
	end
	if math.abs(var14) <= 1e-10 then
		var14 = 0
	end
	for i, v in {
		Forward = Vector3.new(0, 0, -1);
		Left = Vector3.new(-1, 0, 0);
		Backwards = Vector3.new(0, 0, 1);
		Right = Vector3.new(1, 0, 0);
	} do
		if Vector3.new(rounded, 0, var14) == v then
		end
	end
	return i
end
repeat
	task.wait()
until Character_upvr_2:WaitForChild("LoadingDone")
local Agility_upvr = LocalPlayer_upvr.Agility
local var19_upvw = false
local var20_upvw = true
local any_LoadAnimation_result1_upvr_3 = Humanoid_upvr:LoadAnimation(script:WaitForChild("RFront"))
any_LoadAnimation_result1_upvr_3.Priority = 2
local any_LoadAnimation_result1_upvr = Humanoid_upvr:LoadAnimation(script:WaitForChild("RSlide"))
any_LoadAnimation_result1_upvr.Priority = 2
local any_LoadAnimation_result1_upvr_2 = Humanoid_upvr:LoadAnimation(script:WaitForChild("RLeft"))
any_LoadAnimation_result1_upvr_2.Priority = 4
local any_LoadAnimation_result1_upvr_4 = Humanoid_upvr:LoadAnimation(script:WaitForChild("RRight"))
any_LoadAnimation_result1_upvr_4.Priority = 4
local any_LoadAnimation_result1_upvr_5 = Humanoid_upvr:LoadAnimation(script:WaitForChild("RBack"))
any_LoadAnimation_result1_upvr_5.Priority = 4
local HumanoidRootPart_upvr = Character_upvr_2:WaitForChild("HumanoidRootPart")
local function Roll_upvr(arg1) -- Line 66, Named "Roll"
	--[[ Upvalues[13]:
		[1]: Humanoid_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
		[3]: Character_upvr_2 (readonly)
		[4]: var19_upvw (read and write)
		[5]: any_LoadAnimation_result1_upvr_5 (readonly)
		[6]: WMD_upvr (readonly)
		[7]: HumanoidRootPart_upvr (readonly)
		[8]: any_LoadAnimation_result1_upvr (readonly)
		[9]: any_LoadAnimation_result1_upvr_3 (readonly)
		[10]: any_LoadAnimation_result1_upvr_2 (readonly)
		[11]: any_LoadAnimation_result1_upvr_4 (readonly)
		[12]: RollEvent_upvr (readonly)
		[13]: Agility_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 48 start (CF ANALYSIS FAILED)
	Humanoid_upvr.JumpPower = 0
	local tbl = {
		Player = LocalPlayer_upvr;
		Character = Character_upvr_2;
		Action = nil;
		Evasion = false;
	}
	if arg1 == true then
		tbl.Evasion = true
	else
		var19_upvw = true
	end
	if Character_upvr_2.StatusFolder:FindFirstChild("Stun") ~= nil and Character_upvr_2.StatusFolder:FindFirstChild("Giant") ~= nil and Character_upvr_2.StatusFolder:FindFirstChild("Stopped") == nil and Character_upvr_2.StatusFolder:FindFirstChild("Chanting") == nil then
		tbl.Action = "Evade"
		any_LoadAnimation_result1_upvr_5:Play()
		-- KONSTANTWARNING: GOTO [183] #128
	end
	-- KONSTANTERROR: [0] 1. Error Block 48 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [70] 49. Error Block 49 start (CF ANALYSIS FAILED)
	if Humanoid_upvr.MoveDirection.Magnitude == 0 then
		tbl.Action = "Back"
		any_LoadAnimation_result1_upvr_5:Play()
	elseif WMD_upvr(HumanoidRootPart_upvr.CFrame:VectorToObjectSpace(Humanoid_upvr.MoveDirection)) == "Forward" then
		if Humanoid_upvr.FloorMaterial ~= Enum.Material.Air then
			any_LoadAnimation_result1_upvr:Play()
			tbl.Action = "Slide"
		else
			any_LoadAnimation_result1_upvr_3:Play()
			tbl.Action = "Front"
		end
	elseif WMD_upvr(HumanoidRootPart_upvr.CFrame:VectorToObjectSpace(Humanoid_upvr.MoveDirection)) == "Left" then
		tbl.Action = "Left"
		any_LoadAnimation_result1_upvr_2:Play()
	elseif WMD_upvr(HumanoidRootPart_upvr.CFrame:VectorToObjectSpace(Humanoid_upvr.MoveDirection)) == "Right" then
		tbl.Action = "Right"
		any_LoadAnimation_result1_upvr_4:Play()
	elseif WMD_upvr(HumanoidRootPart_upvr.CFrame:VectorToObjectSpace(Humanoid_upvr.MoveDirection)) == "Backwards" then
		tbl.Action = "Back"
		any_LoadAnimation_result1_upvr_5:Play()
	end
	RollEvent_upvr:FireServer(tbl)
	task.spawn(function() -- Line 106
		--[[ Upvalues[9]:
			[1]: LocalPlayer_upvr (copied, readonly)
			[2]: any_LoadAnimation_result1_upvr_5 (copied, readonly)
			[3]: any_LoadAnimation_result1_upvr_3 (copied, readonly)
			[4]: any_LoadAnimation_result1_upvr (copied, readonly)
			[5]: any_LoadAnimation_result1_upvr_4 (copied, readonly)
			[6]: any_LoadAnimation_result1_upvr_2 (copied, readonly)
			[7]: Character_upvr_2 (copied, readonly)
			[8]: Humanoid_upvr (copied, readonly)
			[9]: Agility_upvr (copied, readonly)
		]]
		if LocalPlayer_upvr.Class.Value ~= "Mage" then
			task.wait(0.65)
		end
		any_LoadAnimation_result1_upvr_5:Stop()
		any_LoadAnimation_result1_upvr_3:Stop()
		any_LoadAnimation_result1_upvr:Stop()
		any_LoadAnimation_result1_upvr_4:Stop()
		any_LoadAnimation_result1_upvr_2:Stop()
		if Character_upvr_2.StatusFolder:FindFirstChild("Giant") == nil then
			Humanoid_upvr.JumpPower = math.log10(Agility_upvr.Value) * 5 + 50
		else
			Humanoid_upvr.JumpPower = 100
		end
	end)
	if arg1 == false then
		task.wait(6 - math.log10(Agility_upvr.Value))
		var19_upvw = false
	end
	-- KONSTANTERROR: [70] 49. Error Block 49 end (CF ANALYSIS FAILED)
end
game:GetService("UserInputService").InputBegan:Connect(function(arg1, arg2) -- Line 128
	--[[ Upvalues[5]:
		[1]: Character_upvr_2 (readonly)
		[2]: var19_upvw (read and write)
		[3]: Roll_upvr (readonly)
		[4]: var20_upvw (read and write)
		[5]: Agility_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [1] 2. Error Block 2 start (CF ANALYSIS FAILED)
	do
		return
	end
	-- KONSTANTERROR: [1] 2. Error Block 2 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [2] 3. Error Block 3 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [2] 3. Error Block 3 end (CF ANALYSIS FAILED)
end)
LocalPlayer_upvr.PlayerGui.MobileControls.Dodge.MouseButton1Up:Connect(function() -- Line 154
	--[[ Upvalues[5]:
		[1]: Character_upvr_2 (readonly)
		[2]: var19_upvw (read and write)
		[3]: Roll_upvr (readonly)
		[4]: var20_upvw (read and write)
		[5]: Agility_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [8] 6. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [8] 6. Error Block 2 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [17] 12. Error Block 3 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [17] 12. Error Block 3 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [26] 18. Error Block 4 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [26] 18. Error Block 4 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [51] 36. Error Block 8 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [51] 36. Error Block 8 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [66] 49. Error Block 14 start (CF ANALYSIS FAILED)
	if var20_upvw == true and Character_upvr_2.StatusFolder:FindFirstChild("Stun") ~= nil then
		var20_upvw = false
		Roll_upvr(true)
		task.spawn(function() -- Line 170
			--[[ Upvalues[2]:
				[1]: Agility_upvr (copied, readonly)
				[2]: var20_upvw (copied, read and write)
			]]
			task.wait(24 - math.log(Agility_upvr.Value))
			var20_upvw = true
		end)
	end
	-- KONSTANTERROR: [66] 49. Error Block 14 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [89] 67. Error Block 13 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [89] 67. Error Block 13 end (CF ANALYSIS FAILED)
end)
local tbl_2_upvr = {{
	Part0 = "LeftLowerArm";
	Part1 = "LeftHand";
	Name = "TrailLeftArm";
}, {
	Part0 = "RightLowerArm";
	Part1 = "RightHand";
	Name = "TrailRightArm";
}, {
	Part0 = "LeftLowerLeg";
	Part1 = "LeftFoot";
	Name = "TrailLeftLeg";
}, {
	Part0 = "RightLowerLeg";
	Part1 = "RightFoot";
	Name = "TrailRightLeg";
}}
local function _(arg1, arg2) -- Line 185, Named "createAttachment"
	local Attachment_2 = Instance.new("Attachment")
	Attachment_2.Name = arg2
	Attachment_2.Parent = arg1
	return Attachment_2
end
local function _(arg1, arg2) -- Line 192, Named "fadeTrail"
	task.spawn(function() -- Line 193
		--[[ Upvalues[2]:
			[1]: arg2 (readonly)
			[2]: arg1 (readonly)
		]]
		local os_clock_result1_2 = os.clock()
		while os.clock() - os_clock_result1_2 < arg2 do
			arg1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, (os.clock() - os_clock_result1_2) / arg2), NumberSequenceKeypoint.new(1, 1)})
			task.wait()
		end
		arg1:Destroy()
	end)
end
local function createTrail_upvr(arg1, arg2, arg3, arg4) -- Line 207, Named "createTrail"
	if not arg1 or not arg2 then
	else
		local Attachment_3 = Instance.new("Attachment")
		Attachment_3.Name = arg3.."Attachment0"
		Attachment_3.Parent = arg1
		local Attachment = Instance.new("Attachment")
		Attachment.Name = arg3.."Attachment1"
		Attachment.Parent = arg2
		local Trail_upvr = Instance.new("Trail")
		Trail_upvr.Attachment0 = Attachment_3
		Trail_upvr.Attachment1 = Attachment
		Trail_upvr.Lifetime = 0.5
		Trail_upvr.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
		Trail_upvr.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.7, 0.5), NumberSequenceKeypoint.new(1, 1)})
		Trail_upvr.Name = arg3
		Trail_upvr.Parent = arg4
		local var46_upvr = 1
		task.spawn(function() -- Line 193
			--[[ Upvalues[2]:
				[1]: var46_upvr (readonly)
				[2]: Trail_upvr (readonly)
			]]
			local os_clock_result1 = os.clock()
			while os.clock() - os_clock_result1 < var46_upvr do
				Trail_upvr.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, (os.clock() - os_clock_result1) / var46_upvr), NumberSequenceKeypoint.new(1, 1)})
				task.wait()
			end
			Trail_upvr:Destroy()
		end)
	end
end
local RaycastParams_new_result1_upvr = RaycastParams.new()
RaycastParams_new_result1_upvr.FilterType = Enum.RaycastFilterType.Include
RaycastParams_new_result1_upvr.FilterDescendantsInstances = {workspace.Map, workspace.Terrain, workspace.Baseplate}
local VFX_upvr = ReplicatedStorage_upvr.Global.VFX
RollEvent_upvr.OnClientEvent:Connect(function(arg1) -- Line 232
	--[[ Upvalues[5]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: tbl_2_upvr (readonly)
		[3]: createTrail_upvr (readonly)
		[4]: RaycastParams_new_result1_upvr (readonly)
		[5]: VFX_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local Character_upvr = arg1.Character
	local HumanoidRootPart_upvr_2 = arg1.Character.HumanoidRootPart
	local function Dash() -- Line 237
		--[[ Upvalues[8]:
			[1]: ReplicatedStorage_upvr (copied, readonly)
			[2]: Character_upvr (readonly)
			[3]: tbl_2_upvr (copied, readonly)
			[4]: createTrail_upvr (copied, readonly)
			[5]: arg1 (readonly)
			[6]: HumanoidRootPart_upvr_2 (readonly)
			[7]: RaycastParams_new_result1_upvr (copied, readonly)
			[8]: VFX_upvr (copied, readonly)
		]]
		local clone = ReplicatedStorage_upvr.Global.SFX.Dash:Clone()
		clone.Parent = Character_upvr.PrimaryPart
		game.Debris:AddItem(clone, 1.5)
		clone.PlaybackSpeed = math.random(90, 120) / 100
		clone:Play()
		for i_2, v_2 in pairs(tbl_2_upvr) do
			createTrail_upvr(Character_upvr:FindFirstChild(v_2.Part0), Character_upvr:FindFirstChild(v_2.Part1), v_2.Name, Character_upvr)
		end
		if arg1.Action == "Slide" then
			for _ = 1, 15 do
				i_2 = workspace:Raycast(HumanoidRootPart_upvr_2.Position, Vector3.new(0, -4, 0), RaycastParams_new_result1_upvr)
				if i_2 then
					v_2 = VFX_upvr.Dust:Clone()
					v_2.Parent = workspace.Debris
					v_2.CFrame = HumanoidRootPart_upvr_2.CFrame
					v_2.Position = i_2.Position
					v_2.Attachment.Dust.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, i_2.Instance.Color), ColorSequenceKeypoint.new(1, i_2.Instance.Color)})
					v_2.Attachment.Dust:Emit(1)
					game.Debris:AddItem(v_2, 2)
				end
				v_2 = task.wait
				v_2(0.05)
			end
		end
	end
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [368] 242. Error Block 55 start (CF ANALYSIS FAILED)
	Dash()
	do
		return
	end
	-- KONSTANTERROR: [368] 242. Error Block 55 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [371] 245. Error Block 56 start (CF ANALYSIS FAILED)
	Dash()
	-- KONSTANTERROR: [371] 245. Error Block 56 end (CF ANALYSIS FAILED)
end)
