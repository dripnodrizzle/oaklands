game:GetService("ReplicatedStorage").Package.Modules.SkillMod.Buffs.SpeedBuff
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-26 00:46:49
-- Luau version 6, Types version 3
-- Time taken: 0.003395 seconds

local module = {
	ByPass = true;
	CoolDown = 30;
	Server = function(arg1, arg2) -- Line 14, Named "Server"
		if not arg2 then
		else
			arg2:SetAttribute("CDReduction", 0.5)
			local class_Humanoid_upvr = arg2:FindFirstChildOfClass("Humanoid")
			class_Humanoid_upvr.WalkSpeed *= 3
			task.delay(15, function() -- Line 21
				--[[ Upvalues[2]:
					[1]: class_Humanoid_upvr (readonly)
					[2]: arg2 (readonly)
				]]
				class_Humanoid_upvr.WalkSpeed = 0.3333333333333333 * class_Humanoid_upvr.WalkSpeed
				arg2:SetAttribute("CDReduction", nil)
			end)
		end
	end;
}
local module_upvr = require(game:GetService("ReplicatedStorage"):WaitForChild("Package"):WaitForChild("Modules"):WaitForChild("CoreMod"))
function module.Client(arg1, arg2) -- Line 30
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not arg2 or not arg2.PrimaryPart then
	else
		module_upvr:PlaySound("LightningAwaken", arg2.PrimaryPart)
		for _, v in pairs(arg2:GetDescendants()) do
			if v:IsA("BasePart") then
				module_upvr:DestroyItem(module_upvr:Clone(module_upvr.VFXFolder.Auras.SpeedAura.Attachment["Purple Lightning"], nil, v), 17)
			end
		end
		local clone_upvr = module_upvr:Clone(module_upvr.VFXFolder.Auras.SpeedAura.Attachment["Dark Lightning Glow Round"], nil, arg2.PrimaryPart)
		task.delay(15, function() -- Line 45
			--[[ Upvalues[3]:
				[1]: module_upvr (copied, readonly)
				[2]: arg2 (readonly)
				[3]: clone_upvr (readonly)
			]]
			module_upvr:DisableParticles(arg2)
			module_upvr:DestroyItem(clone_upvr, 2)
		end)
		module_upvr:ShakeAllCameras(arg2.PrimaryPart.Position, 1, 5, 0.2, 0.5)
	end
end
return module


=========================




game:GetService("ReplicatedStorage").Package.Modules.SkillMod.Attacks.Robux.HeavensLight
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-26 00:44:58
-- Luau version 6, Types version 3
-- Time taken: 0.006820 seconds

local module_upvr = require(game:GetService("ReplicatedStorage"):WaitForChild("Package"):WaitForChild("Modules"):WaitForChild("CoreMod"))
return {
	CoolDown = 25;
	Duration = 1;
	Server = function(arg1, arg2) -- Line 14, Named "Server"
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		local any_CreateHitBox_result1 = module_upvr:CreateHitBox(arg2.PrimaryPart.CFrame, Vector3.new(50, 50, 50), 5)
		any_CreateHitBox_result1.CanCollide = false
		any_CreateHitBox_result1.Anchored = true
		module_upvr:DamageEnemiesInPart(any_CreateHitBox_result1, 300, arg2, 60, 15):Connect(function(arg1_2) -- Line 23
			--[[ Upvalues[1]:
				[1]: module_upvr (copied, readonly)
			]]
			module_upvr:GetModule("SkillMod"):UseSkill(arg1_2, "Hit")
		end)
	end;
	Client = function(arg1, arg2) -- Line 34, Named "Client"
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		if not arg2 or not arg2.PrimaryPart then
		else
			for _ = 1, 60 do
				local any_CreatePart_result1_upvr = module_upvr:CreatePart(module_upvr.VFXFolder.Attacks.Robux.HeavensLight, arg2.PrimaryPart.CFrame * CFrame.new(math.random(-50, 50), -2.75, math.random(-50, 50)))
				any_CreatePart_result1_upvr.Anchored = true
				any_CreatePart_result1_upvr.CanCollide = false
				module_upvr:EmitParticles(any_CreatePart_result1_upvr, 0, true)
				module_upvr:ShakeAllCameras(any_CreatePart_result1_upvr.Position, 1, 5, 0.1, 0.2)
				module_upvr:PlaySound("LightExplosion", any_CreatePart_result1_upvr)
				module_upvr:PlaySound("LightSound", any_CreatePart_result1_upvr)
				task.delay(2, function() -- Line 53
					--[[ Upvalues[2]:
						[1]: module_upvr (copied, readonly)
						[2]: any_CreatePart_result1_upvr (readonly)
					]]
					module_upvr:DisableParticles(any_CreatePart_result1_upvr)
					module_upvr:DestroyItem(any_CreatePart_result1_upvr, 2)
				end)
				task.wait(0.25)
				local _
			end
		end
	end;
}






===============



game:GetService("ReplicatedStorage").Package.Modules.ChestMod
KONSTANTERROR: After: K:0: attempt to index nil with 'debug_name'
K
K
K
K
K
K
K

-- // Function Dumper made by King.Kevin
-- // Script Path: ReplicatedStorage.Package.Modules.ChestMod

--[[
Function Dump: SpawnChest

Function Upvalues: SpawnChest
		1 [table]:
		1 [table] table: 0x0aa8ad95c270d74e
				1 [Instance] = MarketplaceService
				2 [function] = UserOwnsGamepass
				3 [function] = ShakeAllCameras
				4 [function] = ShakeCamera
				5 [Instance] = Animations
				6 [function] = LockParticles
				7 [function] = GetModule
				8 [function] = ClearAnimpPriority
				9 [function] = SendMainMessage
				10 [function] = SendNotificationToAll
				11 [function] = DestroyItems
				12 [Instance] = Teleport Service
				13 [Instance] = Events
				14 [function] = Tween2
				15 [function] = PlaySoundAllClients
				16 [function] = SendMainMessageToAll
				17 [function] = SendRewardNotificationToAll
				18 [function] = SendRewardNotification
				19 [function] = Tween
				20 [function] = UseSpecificAnim
				21 [Instance] = SocialService
				22 [function] = SendNotification
				23 [function] = TweenModel
				24 [Instance] = Run Service
				25 [function] = PVPDisabled
				26 [function] = PlaySoundOnClient
				27 [function] = ConvertTableToValues
				28 [function] = CreateStatsFolder
				29 [function] = SendWarningNotificationToAll
				30 [Instance] = Sounds
				31 [function] = EmitParticles
				32 [function] = OnButtonUse
				33 [Instance] = Modules
				34 [Instance] = CollectionService
				35 [Instance] = Models
				36 [Instance] = Package
				37 [function] = CreatePart
				38 [Instance] = AvatarEditorService
				39 [function] = DisableParticles2
				40 [function] = DisableParticles
				41 [function] = PromptAllFavorite
				42 [Instance] = VFX
				43 [function] = createNumberIndex
				44 [Instance] = UserInputService
				45 [function] = PlayAnimById
				46 [function] = PlayAnimation
				47 [function] = SendWarningNotification
				48 [function] = TakeDamage
				49 [function] = GetShadowStats
				50 [function] = PlaySong
				51 [function] = DamageEnemiesInPart
				52 [function] = PromptFavorite
				53 [function] = PlaySound
				54 [function] = CreateHitBox
				55 [function] = DestroyItem
				56 [function] = Clone
				57 [Instance] = TweenService
				58 [Instance] = Debris
				59 [function] = InviteFriend
				60 [function] = CreateInstance
				61 [Instance] = ReplicatedStorage
		2 [table]:
		2 [table] table: 0xb09b4bf7ab5edc5e
				1 [function] = Claimed
				2 [function] = Init
				3 [function] = Triggered
				4 [function] = SpawnChest
				5 [function] = Respawn
				6 [function] = Reward

Function Constants: SpawnChest
		1 [string] = workspace
		2 [Instance] = Workspace
		3 [string] = ChestSpawns
		4 [string] = WaitForChild
		5 [string] = ModelsFolder
		6 [string] = Objects
		7 [string] = Chest
		8 [string] = Clone
		9 [string] = CFrame
		10 [string] = Spawn
		11 [string] = SetAttribute
		12 [string] = table
		13 [string] = clone
		15 [string] = Triggered

====================================================================================================

Function Dump: Triggered

Function Upvalues: Triggered
		1 [table] (Recursive table detected)
		2 [table] (Recursive table detected)

Function Constants: Triggered
		1 [string] = Chest
		2 [string] = ProximityPrompt
		3 [string] = FindFirstChildOfClass
		4 [string] = Triggered
		5 [string] = Connect

====================================================================================================

Function Dump: Init

Function Upvalues: Init
		1 [table] (Recursive table detected)
		2 [table] (Recursive table detected)

Function Constants: Init
		1 [string] = pairs
		3 [string] = CollectionService
		4 [string] = Chest
		5 [string] = GetTagged
		6 [string] = BasePart
		7 [string] = IsA
		8 [string] = Transparency
		9 [string] = CanCollide
		10 [string] = CFrame
		11 [string] = new
		13 [string] = SpawnChest

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)

Function Constants: Unknown Name

====================================================================================================

Function Dump: Reward

Function Upvalues: Reward
		1 [table]:
		1 [table] table: 0xd9730363714fc7fe
				1 [function] = GiveGems
				2 [function] = GiveWeapon
				3 [function] = GiveShadow
				4 [function] = RewardPlayer
				5 [function] = GiveItem
				6 [function] = GiveCash

Function Constants: Reward
		1 [string] = math
		2 [string] = random
		4 [string] = GiveCash
		5 [number] = 1
		6 [string] = GiveGems
		7 [string] = Name
		8 [string] = Chance
		10 [string] = Orc Blade
		11 [number] = 49.9
		12 [string] = Colosses Hammer
		13 [string] = SkyBlade
		14 [string] = Knight's Sword
		15 [string] = Flame Sword
		16 [string] = Magnus Spear
		17 [number] = 0.1
		18 [number] = 100000
		19 [string] = pairs
		21 [number] = 100
		22 [string] = GiveWeapon

====================================================================================================

Function Dump: Respawn

Function Upvalues: Respawn
		1 [table] (Recursive table detected)

Function Constants: Respawn
		1 [string] = ProximityPrompt
		2 [string] = FindFirstChildOfClass
		3 [string] = EmitParticles
		4 [string] = Spawn
		5 [string] = GetAttribute
		6 [string] = CFrame
		7 [string] = Transparency
		9 [string] = Tween
		10 [string] = Completed
		11 [string] = Wait
		12 [string] = Enabled

====================================================================================================

Function Dump: Claimed

Function Upvalues: Claimed
		1 [table] (Recursive table detected)

Function Constants: Claimed
		1 [string] = ProximityPrompt
		2 [string] = FindFirstChildOfClass
		3 [string] = Enabled
		4 [string] = Chest Opening
		5 [string] = PlaySound
		6 [string] = DisableParticles
		7 [string] = VFXFolder
		8 [string] = Other
		9 [string] = Coins
		10 [string] = CFrame
		11 [string] = CreatePart
		12 [string] = DestroyItem
		13 [string] = EmitParticles
		14 [string] = task
		15 [string] = spawn
		17 [string] = Position
		18 [string] = Transparency
		20 [Vector3] = 0, 5, 0
		21 [string] = Tween
		22 [string] = Completed
		23 [string] = Wait

====================================================================================================
]]







=============





game:GetService("ReplicatedStorage").Package.Modules.CoreMod
KONSTANTERROR: After: invalid argument #1 to 'create' (size out of range)
K
K
K
K
K
K
K

-- // Function Dumper made by King.Kevin
-- // Script Path: ReplicatedStorage.Package.Modules.CoreMod

--[[
Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table]:
		1 [table] table: 0x0aa8ad95c270d74e
				1 [Instance] = MarketplaceService
				2 [function] = UserOwnsGamepass
				3 [function] = ShakeAllCameras
				4 [function] = ShakeCamera
				5 [Instance] = Animations
				6 [function] = LockParticles
				7 [function] = GetModule
				8 [function] = ClearAnimpPriority
				9 [function] = SendMainMessage
				10 [function] = SendNotificationToAll
				11 [function] = DestroyItems
				12 [Instance] = Teleport Service
				13 [Instance] = Events
				14 [function] = Tween2
				15 [function] = PlaySoundAllClients
				16 [function] = SendMainMessageToAll
				17 [function] = SendRewardNotificationToAll
				18 [function] = SendRewardNotification
				19 [function] = Tween
				20 [function] = UseSpecificAnim
				21 [Instance] = SocialService
				22 [function] = SendNotification
				23 [function] = TweenModel
				24 [Instance] = Run Service
				25 [function] = PVPDisabled
				26 [function] = PlaySoundOnClient
				27 [function] = ConvertTableToValues
				28 [function] = CreateStatsFolder
				29 [function] = SendWarningNotificationToAll
				30 [Instance] = Sounds
				31 [function] = EmitParticles
				32 [function] = OnButtonUse
				33 [Instance] = Modules
				34 [Instance] = CollectionService
				35 [Instance] = Models
				36 [Instance] = Package
				37 [function] = CreatePart
				38 [Instance] = AvatarEditorService
				39 [function] = DisableParticles2
				40 [function] = DisableParticles
				41 [function] = PromptAllFavorite
				42 [Instance] = VFX
				43 [function] = createNumberIndex
				44 [Instance] = UserInputService
				45 [function] = PlayAnimById
				46 [function] = PlayAnimation
				47 [function] = SendWarningNotification
				48 [function] = TakeDamage
				49 [function] = GetShadowStats
				50 [function] = PlaySong
				51 [function] = DamageEnemiesInPart
				52 [function] = PromptFavorite
				53 [function] = PlaySound
				54 [function] = CreateHitBox
				55 [function] = DestroyItem
				56 [function] = Clone
				57 [Instance] = TweenService
				58 [Instance] = Debris
				59 [function] = InviteFriend
				60 [function] = CreateInstance
				61 [Instance] = ReplicatedStorage
		2 [Instance] = SwordSlash1

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash1

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash2

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash2

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash1

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash1

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash3

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash2

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash1

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash2

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash1

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash3

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash2

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash1

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash2

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash1

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash3

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash2

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash1

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash2

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = SwordSlash1

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dotted Slash

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = BatHit

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Circular Smack

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = Explosion

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [table] (Recursive table detected)
		2 [Instance] = LightningAwaken

Function Constants: Unknown Name
		1 [string] = DestroyItem

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
		1 [Instance] = Dark Lightning Glow Round
		2 [number] = 0

Function Constants: Unknown Name
		1 [string] = EmitCount
		2 [string] = GetAttribute
		3 [string] = Emit

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown 








==================================



Helpful locations

workspace.ChestSpawns
	workspace.ChestSpawns:GetChildren()[54]
game:GetService("Players").LocalPlayer.Data.Equipped.EquippedWeapon
		game:GetService("Players").LocalPlayer.Data.Equipped.EquippedWeapon["Knight's Sword"].Level
		game:GetService("Players").LocalPlayer.Data.Equipped.EquippedWeapon["Knight's Sword"].Upgrade
	game:GetService("Players").LocalPlayer.Data.Equipped.Weapon
game:GetService("Players").LocalPlayer.Data.Inventory.Machette.Level
game:GetService("Players").LocalPlayer.Data.PlayerStats
	game:GetService("Players").LocalPlayer.Data.PlayerStats.Attack
	game:GetService("Players").LocalPlayer.Data.PlayerStats.Cash
	game:GetService("Players").LocalPlayer.Data.PlayerStats.Exp
	game:GetService("Players").LocalPlayer.Data.PlayerStats.Gems
	game:GetService("Players").LocalPlayer.Data.PlayerStats.Health
	game:GetService("Players").LocalPlayer.Data.PlayerStats.Int
	game:GetService("Players").LocalPlayer.Data.PlayerStats.Level
	game:GetService("Players").LocalPlayer.Data.PlayerStats.Speed
	game:GetService("Players").LocalPlayer.Data.PlayerStats.StatPoints
	game:GetService("Players").LocalPlayer.Data.PlayerStats.Title
game:GetService("Players").LocalPlayer.Data.ShadowPities
game:GetService("Players").LocalPlayer.Data.SkillData
	game:GetService("Players").LocalPlayer.Data.SkillData.Exp
	game:GetService("Players").LocalPlayer.Data.SkillData.Level
game:GetService("Players").LocalPlayer.TempStats
	game:GetService("Players").LocalPlayer.TempStats.Mana
	game:GetService("Players").LocalPlayer.TempStats.MaxMana
game:GetService("Players").LocalPlayer.Data.ShadowSoldiers
game:GetService("Players").LocalPlayer.Data.DailyRewards
	game:GetService("Players").LocalPlayer.Data.DailyRewards.Claimed
	game:GetService("Players").LocalPlayer.Data.DailyRewards.Day
	game:GetService("Players").LocalPlayer.Data.DailyRewards.LastLogin
	game:GetService("Players").LocalPlayer.Data.DailyRewards.LeveledUnits
game:GetService("ReplicatedStorage").Package.Models.Enemies["Knight Commander"]
game:GetService("ReplicatedStorage").Package.Models.Enemies["Knight Commander[Shadow]"]		




=======================




game:GetService("ReplicatedStorage").Package.Modules.WeaponMod
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-26 00:22:42
-- Luau version 6, Types version 3
-- Time taken: 0.011198 seconds

local module_upvr = require(game:GetService("ReplicatedStorage"):WaitForChild("Package"):WaitForChild("Modules"):WaitForChild("CoreMod"))
local module = {}
local Weapons_upvr = module_upvr.ModelsFolder.Weapons
function module.Init(arg1) -- Line 11
	--[[ Upvalues[1]:
		[1]: Weapons_upvr (readonly)
	]]
	print("weaponMod Initiated")
	for _, v in pairs(Weapons_upvr:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = false
			v.CanCollide = false
			v.Massless = true
			v.CollisionGroup = "Players"
		end
	end
	for _, v_2 in pairs(Weapons_upvr:GetChildren()) do
		if v_2:IsA("Model") then
			local Handle = v_2:FindFirstChild("Handle")
			if not Handle then
				warn(v_2.Name.." Does not have a handle")
			else
				Handle.Transparency = 1
				v_2.PrimaryPart = Handle
				for _, v_3 in pairs(v_2:GetDescendants()) do
					if v_3:IsA("BasePart") then
						v_3.Anchored = false
						v_3.CanCollide = false
						if v_3 ~= Handle then
							local WeldConstraint_3 = Instance.new("WeldConstraint", Handle)
							WeldConstraint_3.Part0 = Handle
							WeldConstraint_3.Part1 = v_3
						end
					end
				end
			end
		end
	end
end
local any_GetModule_result1_upvr = module_upvr:GetModule("WeaponData")
function module.EquipWeapon(arg1, arg2, arg3, arg4) -- Line 43
	--[[ Upvalues[3]:
		[1]: Weapons_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: any_GetModule_result1_upvr (readonly)
	]]
	if not arg3 then
	else
		local RightHand = arg3:FindFirstChild("RightHand")
		local LeftHand = arg3:FindFirstChild("LeftHand")
		if not Weapons_upvr:FindFirstChild(arg2) then
			warn(arg2.." is not an existing weapon")
			return
		end
		if not arg3:FindFirstChild("Weapon") then
			local any_CreateInstance_result1_upvr = module_upvr:CreateInstance("Folder", "Weapon", arg3)
		end
		any_CreateInstance_result1_upvr:ClearAllChildren()
		local function _(arg1_2, arg2_2) -- Line 58, Named "weldToPart"
			--[[ Upvalues[2]:
				[1]: Weapons_upvr (copied, readonly)
				[2]: any_CreateInstance_result1_upvr (readonly)
			]]
			local clone = Weapons_upvr:FindFirstChild(arg1_2):Clone()
			clone.Parent = any_CreateInstance_result1_upvr
			clone:PivotTo(arg2_2.CFrame)
			local WeldConstraint_4 = Instance.new("WeldConstraint", clone.PrimaryPart)
			WeldConstraint_4.Part0 = arg2_2
			WeldConstraint_4.Part1 = clone.PrimaryPart
		end
		local clone_2 = Weapons_upvr:FindFirstChild(arg2):Clone()
		clone_2.Parent = any_CreateInstance_result1_upvr
		clone_2:PivotTo(RightHand.CFrame)
		local WeldConstraint_2 = Instance.new("WeldConstraint", clone_2.PrimaryPart)
		WeldConstraint_2.Part0 = RightHand
		WeldConstraint_2.Part1 = clone_2.PrimaryPart
		if not arg4 and (not any_GetModule_result1_upvr[arg2] or not any_GetModule_result1_upvr[arg2].OffHand) then return end
		local clone_3 = Weapons_upvr:FindFirstChild(any_GetModule_result1_upvr[arg2].OffHand):Clone()
		clone_3.Parent = any_CreateInstance_result1_upvr
		clone_3:PivotTo(LeftHand.CFrame)
		local WeldConstraint = Instance.new("WeldConstraint", clone_3.PrimaryPart)
		WeldConstraint.Part0 = LeftHand
		WeldConstraint.Part1 = clone_3.PrimaryPart
	end
end
function module.GetUpgradeCost(arg1, arg2) -- Line 78
	return math.floor(math.pow(arg2, 1.3) * 50)
end
module:Init()
return module







==================




game:GetService("ReplicatedStorage").Package.Modules.SummonMod
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-26 00:21:44
-- Luau version 6, Types version 3
-- Time taken: 0.026102 seconds

local module_upvr_4 = require(game:GetService("ReplicatedStorage"):WaitForChild("Package"):WaitForChild("Modules"):WaitForChild("CoreMod"))
local any_GetModule_result1_upvr_2 = module_upvr_4:GetModule("NPCData")
local module_upvr = {}
local tbl_upvr = {}
function module_upvr.New(arg1, arg2, arg3) -- Line 16
	--[[ Upvalues[4]:
		[1]: module_upvr_4 (readonly)
		[2]: any_GetModule_result1_upvr_2 (readonly)
		[3]: module_upvr (readonly)
		[4]: tbl_upvr (readonly)
	]]
	local Enemies = module_upvr_4.ModelsFolder.Enemies
	if not Enemies:FindFirstChild(arg1) then
		module_upvr_4:SendNotification(arg3, "This server is outDated. Join a new server to summon your shadow")
		warn(arg1.." is not an existing enemy")
		return
	end
	local var10
	if any_GetModule_result1_upvr_2[arg1] and any_GetModule_result1_upvr_2[arg1].Shadow then
		var10 = Enemies:FindFirstChild(any_GetModule_result1_upvr_2[arg1].Shadow) or var10
	end
	local clone_2 = var10:Clone()
	local var12 = arg1
	if not var12 then
		var12 = clone_2.Name
	end
	clone_2.Name = var12
	local class_Humanoid_2 = clone_2:FindFirstChildOfClass("Humanoid")
	for _, v in pairs(clone_2:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CollisionGroup = "Summon"
			module_upvr_4:Clone(module_upvr_4.VFXFolder.Auras.ShadowAura.Attachment["Purple Lightning"], nil, v)
		end
	end
	class_Humanoid_2.DisplayName = '['..arg3.Name.."]Shadow "..clone_2.Name
	clone_2.Parent = game.Workspace.Summons
	clone_2:PivotTo(CFrame.new(arg2))
	clone_2:SetAttribute("Owner", arg3.UserId)
	clone_2:SetAttribute("Range", 50)
	clone_2.PrimaryPart.Anchored = false
	clone_2.PrimaryPart:SetNetworkOwner(nil)
	if any_GetModule_result1_upvr_2[arg1] then
		class_Humanoid_2.MaxHealth = 100
		class_Humanoid_2.Health = class_Humanoid_2.MaxHealth
		class_Humanoid_2.WalkSpeed = 28
		module_upvr_4:CreateStatsFolder(clone_2, {
			Damage = 5;
		}).Damage.Value = any_GetModule_result1_upvr_2[arg1].Attack or 5
		if any_GetModule_result1_upvr_2[arg1].CombatColor then
			clone_2:SetAttribute("CombatColor", any_GetModule_result1_upvr_2[arg1].CombatColor)
		end
		if not any_GetModule_result1_upvr_2[arg1].Shadow then
			module_upvr_4:Clone(module_upvr_4.VFXFolder.Highlights.Shadow, nil, clone_2)
		end
	end
	local clone_3 = table.clone(module_upvr)
	clone_3.Owner = arg3
	clone_3.Model = clone_2
	clone_3.Humanoid = class_Humanoid_2
	clone_3:Died()
	clone_3:Moving()
	clone_3:CreateHealthBar()
	table.insert(tbl_upvr, clone_2)
	return clone_3
end
function module_upvr.Destroy(arg1) -- Line 89
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if not arg1 then
	elseif arg1.Model then
		if table.find(tbl_upvr, arg1.Model) then
			table.remove(tbl_upvr, table.find(tbl_upvr, arg1.Model))
		end
		arg1.Model:Destroy()
	end
end
function module_upvr.Died(arg1) -- Line 102
	--[[ Upvalues[2]:
		[1]: any_GetModule_result1_upvr_2 (readonly)
		[2]: module_upvr_4 (readonly)
	]]
	local Model_upvr = arg1.Model
	arg1.Humanoid.Died:Connect(function() -- Line 109
		--[[ Upvalues[3]:
			[1]: Model_upvr (readonly)
			[2]: module_upvr_4 (copied, readonly)
			[3]: arg1 (readonly)
		]]
		task.wait(1)
		for _, v_2 in pairs(Model_upvr:GetDescendants()) do
			if v_2:IsA("BasePart") then
				module_upvr_4:Tween(v_2, 1, {
					Transparency = 1;
				})
			end
		end
		task.wait(1)
		arg1:Destroy()
	end)
end
function module_upvr.Moving(arg1) -- Line 123
	--[[ Upvalues[2]:
		[1]: any_GetModule_result1_upvr_2 (readonly)
		[2]: module_upvr_4 (readonly)
	]]
	local Humanoid = arg1.Humanoid
	local DefaultIdleAnim = any_GetModule_result1_upvr_2.DefaultIdleAnim
	local DefaultRunAnim = any_GetModule_result1_upvr_2.DefaultRunAnim
	local var31 = any_GetModule_result1_upvr_2[arg1.Model.Name]
	if var31 then
		local IdleAnim = var31.IdleAnim
		if not IdleAnim then
			IdleAnim = any_GetModule_result1_upvr_2.DefaultIdleAnim
		end
		DefaultIdleAnim = IdleAnim
		IdleAnim = var31.RunAnim
		local var33 = IdleAnim
		if not var33 then
			var33 = any_GetModule_result1_upvr_2.DefaultRunAnim
		end
		DefaultRunAnim = var33
	end
	local any_PlayAnimById_result1_upvr = module_upvr_4:PlayAnimById(DefaultRunAnim, Humanoid, Enum.AnimationPriority.Movement)
	local function _(arg1_2, arg2) -- Line 139, Named "trackState"
		if not arg1_2 then
		else
			if arg2 then
				arg1_2:Play()
				return
			end
			arg1_2:Stop()
		end
	end
	if not any_PlayAnimById_result1_upvr then
	else
		any_PlayAnimById_result1_upvr:Stop()
	end
	local var36_upvw = false
	local any_PlayAnimById_result1_upvr_2 = module_upvr_4:PlayAnimById(DefaultIdleAnim, Humanoid, Enum.AnimationPriority.Idle)
	Humanoid.Running:Connect(function(arg1_3) -- Line 152
		--[[ Upvalues[3]:
			[1]: var36_upvw (read and write)
			[2]: any_PlayAnimById_result1_upvr (readonly)
			[3]: any_PlayAnimById_result1_upvr_2 (readonly)
		]]
		if 1 < arg1_3 and var36_upvw == false then
			var36_upvw = true
			local var38 = any_PlayAnimById_result1_upvr
			if not var38 then
			else
				var38:Play()
			end
			local var39 = any_PlayAnimById_result1_upvr_2
			if not var39 then
			else
				var39:Stop()
			end
		end
		if var36_upvw == false or 1 < arg1_3 then
		else
			var36_upvw = false
			local var40 = any_PlayAnimById_result1_upvr
			if not var40 then
			else
				var40:Stop()
			end
			local var41 = any_PlayAnimById_result1_upvr_2
			if not var41 then return end
			var41:Play()
		end
	end)
end
function module_upvr.CreateHealthBar(arg1) -- Line 169
	--[[ Upvalues[1]:
		[1]: module_upvr_4 (readonly)
	]]
	local Humanoid_2_upvr = arg1.Humanoid
	local Model = arg1.Model
	Humanoid_2_upvr.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	Humanoid_2_upvr.HealthDisplayDistance = 0
	local clone = module_upvr_4:Clone(module_upvr_4.VFXFolder.BillBoards.MobGUI, nil, Model.PrimaryPart)
	local HealthGUI_upvr = clone.GUI.HealthGUI
	local function updateHealth_upvr() -- Line 182, Named "updateHealth"
		--[[ Upvalues[3]:
			[1]: HealthGUI_upvr (readonly)
			[2]: module_upvr_4 (copied, readonly)
			[3]: Humanoid_2_upvr (readonly)
		]]
		local Healthbar = HealthGUI_upvr:FindFirstChild("Healthbar")
		local HealthNum = HealthGUI_upvr:FindFirstChild("HealthNum")
		if not HealthGUI_upvr or not Healthbar or not HealthNum then
		else
			HealthNum.Text = module_upvr_4:createNumberIndex(Humanoid_2_upvr.Health)..'/'..module_upvr_4:createNumberIndex(Humanoid_2_upvr.MaxHealth)
			module_upvr_4:Tween(Healthbar, 0.1, {
				Size = UDim2.new(Humanoid_2_upvr.Health / Humanoid_2_upvr.MaxHealth, 0, 1, 0);
			})
		end
	end
	clone.GUI.MobInfo.MobName.Text = '['..arg1.Owner.Name.."]Shadow "..Model.Name
	updateHealth_upvr()
	Humanoid_2_upvr:GetPropertyChangedSignal("Health"):Connect(function() -- Line 194
		--[[ Upvalues[1]:
			[1]: updateHealth_upvr (readonly)
		]]
		updateHealth_upvr()
	end)
end
local function getInRange_upvr(arg1, arg2) -- Line 199, Named "getInRange"
	local Character_upvr = arg2.Character
	if not Character_upvr or not Character_upvr.PrimaryPart then return end
	local module_upvr_3 = {}
	for _, v_3 in pairs(game.Players:GetPlayers()) do
		if v_3 ~= arg2 then
			local Character = v_3.Character
			if Character and Character.PrimaryPart and not Character:GetAttribute("PVPDisabled") and not Character:FindFirstChildOfClass("ForceField") then
				local class_Humanoid_3 = Character:FindFirstChildOfClass("Humanoid")
				if class_Humanoid_3 and class_Humanoid_3.Health > 0 and arg1:GetAttribute("Range") >= (Character.PrimaryPart.Position - Character_upvr.PrimaryPart.Position).Magnitude then
					table.insert(module_upvr_3, Character)
				end
			end
		end
	end
	local Range_upvr_2 = arg1:GetAttribute("Range")
	local function checkEnemiesInFolder(arg1_5) -- Line 220
		--[[ Upvalues[5]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
			[3]: Character_upvr (readonly)
			[4]: Range_upvr_2 (readonly)
			[5]: module_upvr_3 (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		local pairs_result1_2, pairs_result2_2, pairs_result3_8 = pairs(arg1_5:GetChildren())
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [120] 88. Error Block 25 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [120] 88. Error Block 25 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [7] 6. Error Block 2 start (CF ANALYSIS FAILED)
		-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [120.6]
		-- KONSTANTERROR: [7] 6. Error Block 2 end (CF ANALYSIS FAILED)
	end
	checkEnemiesInFolder(workspace.Summons)
	checkEnemiesInFolder(workspace.Enemies)
	return module_upvr_3
end
local function getClosestEnemy_upvr(arg1, arg2) -- Line 254, Named "getClosestEnemy"
	--[[ Upvalues[1]:
		[1]: getInRange_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var84
	local getInRange_upvr_result1 = getInRange_upvr(arg1, arg2)
	if not getInRange_upvr_result1 then
		getInRange_upvr_result1 = {}
	end
	for _, v_4 in pairs(getInRange_upvr_result1) do
		if v_4 and v_4.PrimaryPart then
			if not var84 then
			elseif (v_4.PrimaryPart.Position - arg1.PrimaryPart.Position).Magnitude > (v_4.PrimaryPart.Position - arg1.PrimaryPart.Position).Magnitude then
			end
		end
	end
	return v_4
end
local any_GetModule_result1_upvr = module_upvr_4:GetModule("SkillMod")
local function checkNPCList_upvr() -- Line 276, Named "checkNPCList"
	--[[ Upvalues[4]:
		[1]: tbl_upvr (readonly)
		[2]: getClosestEnemy_upvr (readonly)
		[3]: any_GetModule_result1_upvr_2 (readonly)
		[4]: any_GetModule_result1_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local pairs_result1_4, pairs_result2, pairs_result3 = pairs(tbl_upvr)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [155] 110. Error Block 28 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [155] 110. Error Block 28 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [5] 5. Error Block 50 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [155.4]
	if nil then
		-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [155.5]
		if nil then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			if nil then
				-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [155.6]
				-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [155.7]
				if nil > nil and nil then
					-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [155.9]
					local function INLINED_2() -- Internal function, doesn't exist in bytecode
						-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [155.10]
						return nil
					end
					if not nil or not INLINED_2() then
						-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [155.8]
						if nil then
							-- KONSTANTERROR: Expression was reused, decompilation is incorrect
							if nil then
								-- KONSTANTWARNING: GOTO [155] #110
							end
							-- KONSTANTWARNING: GOTO [155] #110
						end
					else
						-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [155.11]
						if nil then
							-- KONSTANTERROR: Expression was reused, decompilation is incorrect
							-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [155.12]
							if nil <= nil and nil then
								-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [155.13]
								-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [155.14]
								for _, _ in nil do
									-- KONSTANTERROR: Expression was reused, decompilation is incorrect
								end
							end
							-- KONSTANTERROR: Expression was reused, decompilation is incorrect (x2)
							if nil <= nil and nil then
								for _, _ in nil do
									-- KONSTANTERROR: Expression was reused, decompilation is incorrect (x3)
								end
							end
							-- KONSTANTERROR: Expression was reused, decompilation is incorrect (x2)
							if nil <= nil and nil then
								for _, _ in nil do
									-- KONSTANTERROR: Expression was reused, decompilation is incorrect (x3)
								end
							end
						end
					end
				end
			end
		end
	end
	-- KONSTANTERROR: [5] 5. Error Block 50 end (CF ANALYSIS FAILED)
end
task.spawn(function() -- Line 332
	--[[ Upvalues[1]:
		[1]: checkNPCList_upvr (readonly)
	]]
	while task.wait() do
		local pcall_result1, pcall_result2 = pcall(function() -- Line 334
			--[[ Upvalues[1]:
				[1]: checkNPCList_upvr (copied, readonly)
			]]
			task.spawn(function() -- Line 335
				--[[ Upvalues[1]:
					[1]: checkNPCList_upvr (copied, readonly)
				]]
				checkNPCList_upvr()
			end)
		end)
		if not pcall_result1 then
			warn(pcall_result2)
		end
	end
end)
return module_upvr










==================







game:GetService("ReplicatedStorage").Package.Modules.SkillMod
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-26 00:20:40
-- Luau version 6, Types version 3
-- Time taken: 0.011567 seconds

local module_upvr_2 = require(game:GetService("ReplicatedStorage"):WaitForChild("Package"):WaitForChild("Modules"):WaitForChild("CoreMod"))
local module_upvr = {
	Init = function(arg1) -- Line 13, Named "Init"
		print("Initiated")
	end;
	UseSkill = function(arg1, arg2, arg3, arg4, arg5, ...) -- Line 17, Named "UseSkill"
		--[[ Upvalues[1]:
			[1]: module_upvr_2 (readonly)
		]]
		if not arg2 or not arg2.PrimaryPart then
		else
			local class_Humanoid = arg2:FindFirstChildOfClass("Humanoid")
			if not class_Humanoid or class_Humanoid.Health <= 0 then return end
			local any_GetPlayerFromCharacter_result1 = game.Players:GetPlayerFromCharacter(arg2)
			for _, v in pairs(script:GetDescendants()) do
				if v:IsA("ModuleScript") and v.Name == arg3 then
					local v_2_upvr = require(v)
					if module_upvr_2.RunService:IsServer() then
						if arg2:GetAttribute(arg3) then return end
						if arg2:GetAttribute("SkillDuration") and not v_2_upvr.ByPass then return end
						if arg2:FindFirstChild("ForceField") and not v_2_upvr.ByPass then
							if not any_GetPlayerFromCharacter_result1 then
							else
								module_upvr_2:SendWarningNotification(any_GetPlayerFromCharacter_result1, "You can not use skills with a force field")
							end
						end
						if v_2_upvr.CoolDown and 0 < v_2_upvr.CoolDown then
							arg2:SetAttribute(arg3, true)
							local CoolDown = v_2_upvr.CoolDown
							local CDReduction = arg2:GetAttribute("CDReduction")
							if CDReduction then
								CoolDown *= CDReduction
							end
							task.delay(CoolDown, function() -- Line 46
								--[[ Upvalues[2]:
									[1]: arg2 (readonly)
									[2]: arg3 (readonly)
								]]
								arg2:SetAttribute(arg3, nil)
							end)
						end
						if v_2_upvr.Duration and 0 < v_2_upvr.Duration then
							arg2:SetAttribute("SkillDuration", true)
							local Duration = v_2_upvr.Duration
							local CDReduction_2 = arg2:GetAttribute("CDReduction")
							if CDReduction_2 then
								Duration *= CDReduction_2
							end
							task.delay(Duration, function() -- Line 58
								--[[ Upvalues[1]:
									[1]: arg2 (readonly)
								]]
								arg2:SetAttribute("SkillDuration", nil)
							end)
						end
						module_upvr_2.EventsFolder.Skill:FireAllClients(arg2, arg3, arg4, arg5)
					end
					if module_upvr_2.RunService:IsServer() and v_2_upvr.Server then
						task.spawn(function() -- Line 69
							--[[ Upvalues[4]:
								[1]: v_2_upvr (readonly)
								[2]: arg2 (readonly)
								[3]: arg4 (readonly)
								[4]: arg5 (readonly)
							]]
							v_2_upvr:Server(arg2, arg4, arg5)
						end)
						return
					end
					if v_2_upvr.Client then
						task.spawn(function() -- Line 78
							--[[ Upvalues[4]:
								[1]: v_2_upvr (readonly)
								[2]: arg2 (readonly)
								[3]: arg4 (readonly)
								[4]: arg5 (readonly)
							]]
							v_2_upvr:Client(arg2, arg4, arg5)
						end)
						return
					end
				end
			end
			warn(arg3.." Does not have a skill module assigned")
		end
	end;
}
if module_upvr_2.RunService:IsClient() then
	local var21_upvw = false
	module_upvr_2.EventsFolder.BindableEvents.Settings.Event:Connect(function(arg1, arg2, ...) -- Line 95
		--[[ Upvalues[1]:
			[1]: var21_upvw (read and write)
		]]
		if arg1 ~= "Disable Vfx" then
		else
			var21_upvw = arg2
		end
	end)
	module_upvr_2.EventsFolder.Skill.OnClientEvent:Connect(function(arg1, arg2, ...) -- Line 99
		--[[ Upvalues[2]:
			[1]: var21_upvw (read and write)
			[2]: module_upvr (readonly)
		]]
		if var21_upvw or not module_upvr.UseSkill then
		else
			module_upvr:UseSkill(arg1, arg2, ...)
		end
	end)
end
return module_upvr







====================================================================================================





game:GetService("ReplicatedStorage").Package.Modules.RewardMod
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-26 00:19:21
-- Luau version 6, Types version 3
-- Time taken: 0.016271 seconds

local module_upvr_2 = require(game:GetService("ReplicatedStorage"):WaitForChild("Package"):WaitForChild("Modules"):WaitForChild("CoreMod"))
local module_upvr = {
	GiveShadow = function(arg1, arg2, arg3) -- Line 11, Named "GiveShadow"
		--[[ Upvalues[1]:
			[1]: module_upvr_2 (readonly)
		]]
		local Data_6 = arg2:FindFirstChild("Data")
		if not Data_6 then
		else
			local ShadowSoldiers = Data_6:FindFirstChild("ShadowSoldiers")
			if not ShadowSoldiers then return end
			module_upvr_2:CreateInstance("Folder", arg3, nil).Parent = ShadowSoldiers
			module_upvr_2.EventsFolder.Ui:FireClient(arg2, "ShadowNotification")
		end
	end;
	RewardPlayer = function(arg1, arg2, arg3, arg4, arg5) -- Line 25, Named "RewardPlayer"
		--[[ Upvalues[1]:
			[1]: module_upvr_2 (readonly)
		]]
		module_upvr_2.EventsFolder.Reward:FireClient(arg2, arg3, arg4, arg5)
	end;
}
function module_upvr.GiveCash(arg1, arg2, arg3, arg4) -- Line 30
	--[[ Upvalues[2]:
		[1]: module_upvr_2 (readonly)
		[2]: module_upvr (readonly)
	]]
	if not arg3 or arg3 == 0 then return end
	local Data_2 = arg2:FindFirstChild("Data")
	if not Data_2 then
		return false
	end
	local PlayerStats_2 = Data_2:FindFirstChild("PlayerStats")
	if not PlayerStats_2 then return end
	local Cash = PlayerStats_2:FindFirstChild("Cash")
	if not Cash then return end
	local var9
	if module_upvr_2:UserOwnsGamepass(arg2, 3) and not arg4 then
		var9 *= 2
	end
	Cash.Value += var9
	module_upvr:RewardPlayer(arg2, "Gold", "Item", var9)
	return true
end
function module_upvr.GiveGems(arg1, arg2, arg3) -- Line 48
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not arg3 or arg3 == 0 then return end
	local Data = arg2:FindFirstChild("Data")
	if not Data then
		return false
	end
	local PlayerStats = Data:FindFirstChild("PlayerStats")
	if not PlayerStats then return end
	local Gems = PlayerStats:FindFirstChild("Gems")
	if not Gems then return end
	Gems.Value += arg3
	module_upvr:RewardPlayer(arg2, "Gem", "Item", arg3)
	return true
end
function module_upvr.GiveItem(arg1, arg2, arg3, arg4) -- Line 63
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: module_upvr_2 (readonly)
	]]
	if arg3 == "Gold" then
		module_upvr:GiveCash(arg2, arg4)
		return
	end
	if arg3 == "Gem" then
		module_upvr:GiveGems(arg2, arg4)
		return
	end
	if not arg4 or arg4 == 0 then return end
	local Data_4 = arg2:FindFirstChild("Data")
	if not Data_4 then
		return false
	end
	local Items = Data_4:FindFirstChild("Items")
	if not Items then return end
	local SOME_2 = Items:FindFirstChild(arg3)
	if not SOME_2 then
		SOME_2 = module_upvr_2:CreateInstance("NumberValue", arg3, Items)
	end
	SOME_2.Value += arg4
	module_upvr:RewardPlayer(arg2, arg3, "Item", arg4)
	return true
end
local any_GetModule_result1_upvr = module_upvr_2:GetModule("WeaponData")
function module_upvr.GiveWeapon(arg1, arg2, arg3) -- Line 92
	--[[ Upvalues[3]:
		[1]: module_upvr_2 (readonly)
		[2]: any_GetModule_result1_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	local Data_5 = arg2:FindFirstChild("Data")
	if not Data_5 then
		return false
	end
	local Inventory = Data_5:FindFirstChild("Inventory")
	local Equipped_2 = Data_5:FindFirstChild("Equipped")
	local Settings = Data_5:FindFirstChild("Settings")
	if not Inventory or not Equipped_2 or not Settings then return end
	local AutoDelete_2 = Settings:FindFirstChild("AutoDelete")
	if not Equipped_2:FindFirstChild("EquippedWeapon") or not AutoDelete_2 then return end
	if 100 <= #Inventory:GetChildren() + #Equipped_2:GetChildren() then
		module_upvr_2:SendWarningNotification(arg2, "Your inventory is full")
		return
	end
	if any_GetModule_result1_upvr[arg3] and any_GetModule_result1_upvr[arg3].Rarity then
		local SOME = AutoDelete_2:FindFirstChild(any_GetModule_result1_upvr[arg3].Rarity)
		if SOME and SOME.Value then
			module_upvr_2:SendWarningNotification(arg2, any_GetModule_result1_upvr[arg3].Rarity..": "..arg3.." has been auto deleted")
			return
		end
	end
	module_upvr_2:CreateInstance("Folder", arg3, nil).Parent = Inventory
	module_upvr:RewardPlayer(arg2, arg3, "Weapon")
	module_upvr_2.EventsFolder.Ui:FireClient(arg2, "WeaponNotification")
	return true
end
return module_upvr






====================================================================================================





game:GetService("ReplicatedStorage").Package.Modules.RequirementsMod
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-26 00:18:06
-- Luau version 6, Types version 3
-- Time taken: 0.009713 seconds

local module_upvr = require(game:GetService("ReplicatedStorage"):WaitForChild("Package"):WaitForChild("Modules"):WaitForChild("CoreMod"))
return {
	GetShadowLimit = function(arg1, arg2) -- Line 11, Named "GetShadowLimit"
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		local Data = arg2:FindFirstChild("Data")
		if not Data then
			module_upvr:SendWarningNotification(arg2, "your data has not loaded")
			return false
		end
		local ShadowSoldiers = Data:FindFirstChild("ShadowSoldiers")
		local EquippedShadows = Data:FindFirstChild("EquippedShadows")
		if not ShadowSoldiers or not EquippedShadows then
			module_upvr:SendWarningNotification(arg2, "your data has not loaded")
			return false
		end
		if 100 <= #ShadowSoldiers:GetChildren() + #EquippedShadows:GetChildren() then
			module_upvr:SendWarningNotification(arg2, "your shadow inventory is full")
			return false
		end
		return true
	end;
	GetLevel = function(arg1, arg2, arg3) -- Line 34, Named "GetLevel"
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		if not arg3 or arg3 == 1 or arg3 == 0 then
			return true
		end
		local Data_2 = arg2:FindFirstChild("Data")
		if not Data_2 then
			module_upvr:SendWarningNotification(arg2, "your data has not loaded")
			return false
		end
		local PlayerStats = Data_2:FindFirstChild("PlayerStats")
		if not PlayerStats then return end
		local Level = PlayerStats:FindFirstChild("Level")
		if not Level then return end
		if Level.Value < arg3 then
			module_upvr:SendWarningNotification(arg2, "You need level "..arg3)
			return false
		end
		return true
	end;
	ReturnTimeLeft = function(arg1, arg2, arg3) -- Line 60, Named "ReturnTimeLeft"
		if arg2 < arg3 then
			local var9 = arg3 - arg2
			local var10 = var9 % 3600
			local function addZeros(arg1_2) -- Line 73
				if arg1_2 < 10 then
					return '0'..math.round(arg1_2)
				end
				return math.round(arg1_2)
			end
			local floored_2 = math.floor(var9 / 3600)
			if floored_2 < 10 then
				var10 = '0'..math.round(floored_2)
			else
				var10 = math.round(floored_2)
			end
			local floored_3 = math.floor(var10 / 60)
			if floored_3 < 10 then
			else
			end
			local floored = math.floor(var9 % 60)
			if floored < 10 then
			else
			end
			return var10.." Hour(s) "..math.round(floored_3).." Minute(s) "..math.round(floored).." Second(s)"
		end
		return 0
	end;
	GetTimeLeft = function(arg1, arg2, arg3, arg4) -- Line 90, Named "GetTimeLeft"
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		if arg3 < arg4 then
			local var14 = arg4 - arg3
			while 60 <= var14 do
				local var15 = 0 + 1
			end
			repeat
			until 60 >= var15
			local function _(arg1_3) -- Line 112, Named "addZeros"
				if arg1_3 < 10 then
					return '0'..math.round(arg1_3)
				end
				return math.round(arg1_3)
			end
			local var16 = 0 + 1
			if var16 < 10 then
				-- KONSTANTWARNING: GOTO [38] #33
			end
			local var17 = var15 - 60
			if var17 < 10 then
			else
			end
			local var18 = var14 - 60
			if var18 < 10 then
			else
			end
			if arg2 then
				module_upvr:SendWarningNotification(arg2, "TimeLeft: "..math.round(var16).." Hour(s) "..math.round(var17).." Minute(s) "..math.round(var18).." Second(s)")
			end
			return false
		end
		return true
	end;
}






=====================================================================================================







game:GetService("ReplicatedStorage").Package.Modules.ManaMod
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-26 00:17:12
-- Luau version 6, Types version 3
-- Time taken: 0.008984 seconds

local any_GetModule_result1_upvr = require(game:GetService("ReplicatedStorage"):WaitForChild("Package"):WaitForChild("Modules"):WaitForChild("CoreMod")):GetModule("SummonList")
local module_upvr = {
	UseMana = function(arg1, arg2, arg3) -- Line 10, Named "UseMana"
		local var3 = arg3 or 5
		local Mana_4 = arg2:FindFirstChild("TempStats"):FindFirstChild("Mana")
		if Mana_4.Value < var3 then
			return false
		end
		Mana_4.Value -= var3
		return true
	end;
	GiveMana = function(arg1, arg2, arg3) -- Line 23, Named "GiveMana"
		local Mana = arg2:FindFirstChild("TempStats"):FindFirstChild("Mana")
		Mana.Value += arg3
	end;
	HealAllSummons = function(arg1, arg2) -- Line 31, Named "HealAllSummons"
		--[[ Upvalues[1]:
			[1]: any_GetModule_result1_upvr (readonly)
		]]
		if not any_GetModule_result1_upvr[arg2.UserId] then
		else
			for _, v_4 in pairs(any_GetModule_result1_upvr[arg2.UserId]) do
				if v_4 and v_4.PrimaryPart then
					local class_Humanoid_3 = v_4:FindFirstChildOfClass("Humanoid")
					if class_Humanoid_3 then
						class_Humanoid_3.Health += 0.05 * class_Humanoid_3.MaxHealth
						if class_Humanoid_3.Health > class_Humanoid_3.MaxHealth then
							class_Humanoid_3.Health = class_Humanoid_3.MaxHealth
						end
					end
				end
			end
		end
	end;
}
function module_upvr.HealSummons(arg1) -- Line 47
	--[[ Upvalues[2]:
		[1]: any_GetModule_result1_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	for _, v in pairs(game.Players:GetPlayers()) do
		if any_GetModule_result1_upvr[v.UserId] then
			for _, v_2 in pairs(any_GetModule_result1_upvr[v.UserId]) do
				if v_2 then
					if v_2.PrimaryPart then
						local class_Humanoid_4 = v_2:FindFirstChildOfClass("Humanoid")
						if class_Humanoid_4 and class_Humanoid_4.MaxHealth > class_Humanoid_4.Health and class_Humanoid_4.MaxHealth * 0.95 >= class_Humanoid_4.Health and module_upvr:UseMana(v, 0.05 * class_Humanoid_4.MaxHealth) then
							module_upvr:HealAllSummons(v)
						end
					end
				end
			end
		end
	end
end
function module_upvr.RegenMana(arg1) -- Line 70
	for _, v_3 in pairs(game.Players:GetPlayers()) do
		local TempStats = v_3:FindFirstChild("TempStats")
		if TempStats then
			local Mana_3 = TempStats:FindFirstChild("Mana")
			local MaxMana_2 = TempStats:FindFirstChild("MaxMana")
			if Mana_3 then
				if MaxMana_2 and MaxMana_2.Value > Mana_3.Value then
					Mana_3.Value += MaxMana_2.Value / 45
					if MaxMana_2.Value < Mana_3.Value then
						Mana_3.Value = MaxMana_2.Value
					end
				end
			end
		end
	end
end
local var57_upvw = false
task.spawn(function() -- Line 97
	--[[ Upvalues[2]:
		[1]: var57_upvw (read and write)
		[2]: module_upvr (readonly)
	]]
	print("Mana Mod Initiated")
	if var57_upvw then
	else
		var57_upvw = true
		task.spawn(function() -- Line 102
			--[[ Upvalues[1]:
				[1]: module_upvr (copied, readonly)
			]]
			while task.wait() do
				task.spawn(function() -- Line 104
					--[[ Upvalues[1]:
						[1]: module_upvr (copied, readonly)
					]]
					module_upvr:HealSummons()
				end)
			end
		end)
		while task.wait(1) do
			task.spawn(function() -- Line 112
				--[[ Upvalues[1]:
					[1]: module_upvr (copied, readonly)
				]]
				module_upvr:RegenMana()
			end)
		end
	end
end)
return module_upvr







=====================================================================================================







game:GetService("ReplicatedStorage").Package.Modules.ExpMod
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-26 00:16:06
-- Luau version 6, Types version 3
-- Time taken: 0.014112 seconds

local module_upvr = require(game:GetService("ReplicatedStorage"):WaitForChild("Package"):WaitForChild("Modules"):WaitForChild("CoreMod"))
local module_upvr_2 = {
	ExpPerLevel = 100;
}
function module_upvr_2.BindLevelUp(arg1, arg2) -- Line 14
	--[[ Upvalues[1]:
		[1]: module_upvr_2 (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Data_2 = arg2:FindFirstChild("Data")
	if not Data_2 then
	else
		local EquippedShadows_2_upvr = Data_2:WaitForChild("EquippedShadows")
		for _, v_2 in pairs(EquippedShadows_2_upvr:GetChildren()) do
			(function(arg1_2) -- Line 20, Named "bindLevelUp"
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (copied, readonly)
					[2]: EquippedShadows_2_upvr (readonly)
				]]
				local Exp_3_upvr = arg1_2:FindFirstChild("Exp")
				local Level_upvr_2 = arg1_2:FindFirstChild("Level")
				if not Exp_3_upvr or not Level_upvr_2 then
				else
					local var15_upvw = false
					local function levelUp() -- Line 28
						--[[ Upvalues[5]:
							[1]: var15_upvw (read and write)
							[2]: Exp_3_upvr (readonly)
							[3]: Level_upvr_2 (readonly)
							[4]: module_upvr_2 (copied, readonly)
							[5]: levelUp (readonly)
						]]
						-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
						local var16
						if var15_upvw then
						else
							var16 = Exp_3_upvr
							var16 = Level_upvr_2.Value * module_upvr_2.ExpPerLevel
							if var16.Value < var16 then return end
							var15_upvw = true
							local const_number_2 = 1
							var16 = Level_upvr_2.Value * module_upvr_2.ExpPerLevel
							repeat
								if var16 + (Level_upvr_2.Value + const_number_2) * module_upvr_2.ExpPerLevel >= Exp_3_upvr.Value then break end
								var16 += (Level_upvr_2.Value + const_number_2) * module_upvr_2.ExpPerLevel
								local var18 = const_number_2 + 1
							until 1000 <= var18
							local var19 = Exp_3_upvr
							var19.Value -= var16
							local var20 = Level_upvr_2
							var20.Value += var18
							task.wait(0.01)
							var15_upvw = false
							levelUp()
						end
					end
					local any_Connect_result1_upvw = Exp_3_upvr:GetPropertyChangedSignal("Value"):Connect(function() -- Line 52
						--[[ Upvalues[1]:
							[1]: levelUp (readonly)
						]]
						levelUp()
					end)
					local var24_upvw
					var24_upvw = arg1_2:GetPropertyChangedSignal("Parent"):Connect(function() -- Line 57
						--[[ Upvalues[4]:
							[1]: arg1_2 (readonly)
							[2]: EquippedShadows_2_upvr (copied, readonly)
							[3]: any_Connect_result1_upvw (read and write)
							[4]: var24_upvw (read and write)
						]]
						if arg1_2.Parent == EquippedShadows_2_upvr then
						else
							any_Connect_result1_upvw:Disconnect()
							var24_upvw:Disconnect()
						end
					end)
				end
			end)(v_2)
			local var28_upvr
		end
		EquippedShadows_2_upvr.ChildAdded:Connect(function(arg1_3) -- Line 70
			--[[ Upvalues[1]:
				[1]: var28_upvr (readonly)
			]]
			if not arg1_3:IsA("Folder") then
			else
				var28_upvr(arg1_3)
			end
		end)
	end
end
function module_upvr_2.LevelUpPlayer(arg1, arg2) -- Line 76
	--[[ Upvalues[2]:
		[1]: module_upvr_2 (readonly)
		[2]: module_upvr (readonly)
	]]
	local PlayerStats_2 = arg2:WaitForChild("Data"):WaitForChild("PlayerStats")
	local Exp_2_upvr = PlayerStats_2:WaitForChild("Exp")
	local var32_upvw = false
	local Level_upvr = PlayerStats_2:WaitForChild("Level")
	local StatPoints_upvr = PlayerStats_2:WaitForChild("StatPoints")
	local function levelUp_upvr() -- Line 84, Named "levelUp"
		--[[ Upvalues[8]:
			[1]: var32_upvw (read and write)
			[2]: Exp_2_upvr (readonly)
			[3]: Level_upvr (readonly)
			[4]: module_upvr_2 (copied, readonly)
			[5]: StatPoints_upvr (readonly)
			[6]: arg2 (readonly)
			[7]: module_upvr (copied, readonly)
			[8]: levelUp_upvr (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var35
		if var32_upvw then
		else
			var35 = Exp_2_upvr
			var35 = Level_upvr.Value * module_upvr_2.ExpPerLevel
			if var35.Value < var35 then return end
			var32_upvw = true
			local const_number = 1
			var35 = Level_upvr.Value * module_upvr_2.ExpPerLevel
			repeat
				if var35 + (Level_upvr.Value + const_number) * module_upvr_2.ExpPerLevel >= Exp_2_upvr.Value then break end
				var35 += (Level_upvr.Value + const_number) * module_upvr_2.ExpPerLevel
				local var37 = const_number + 1
			until 1000 <= var37
			local var38 = Exp_2_upvr
			var38.Value -= var35
			local var39 = Level_upvr
			var39.Value += var37
			local var40 = StatPoints_upvr
			var40.Value += var37 * 3
			local Character = arg2.Character
			if not Character then return end
			module_upvr:GetModule("SkillMod"):UseSkill(Character, "LevelUp")
			task.wait(0.01)
			var32_upvw = false
			levelUp_upvr()
		end
	end
	task.spawn(function() -- Line 115
		--[[ Upvalues[1]:
			[1]: levelUp_upvr (readonly)
		]]
		task.wait(3)
		levelUp_upvr()
	end)
	Exp_2_upvr:GetPropertyChangedSignal("Value"):Connect(levelUp_upvr)
end
function module_upvr_2.GiveShadowsExp(arg1, arg2, arg3) -- Line 124
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local Data_3 = arg2:FindFirstChild("Data")
	if not Data_3 then
	else
		local EquippedShadows = Data_3:FindFirstChild("EquippedShadows")
		if not EquippedShadows then return end
		for _, v_3 in pairs(EquippedShadows:GetChildren()) do
			local Exp_4 = v_3:FindFirstChild("Exp")
			if Exp_4 and v_3:FindFirstChild("Level") then
				local var53 = arg3 or 0
				if module_upvr:UserOwnsGamepass(arg2, 2) then
					var53 *= 2
				end
				Exp_4.Value += var53
			end
		end
	end
end
local any_GetModule_result1_upvr = module_upvr:GetModule("RewardMod")
function module_upvr_2.GiveExp(arg1, arg2, arg3) -- Line 149
	--[[ Upvalues[3]:
		[1]: module_upvr_2 (readonly)
		[2]: module_upvr (readonly)
		[3]: any_GetModule_result1_upvr (readonly)
	]]
	local Data = arg2:FindFirstChild("Data")
	local var56
	if not Data then
	else
		local PlayerStats = Data:FindFirstChild("PlayerStats")
		if not PlayerStats then return end
		local Exp = PlayerStats:FindFirstChild("Exp")
		if not Exp then return end
		module_upvr_2:GiveShadowsExp(arg2, var56)
		if module_upvr:UserOwnsGamepass(arg2, 1) then
			var56 *= 2
		end
		Exp.Value += var56
		any_GetModule_result1_upvr:RewardPlayer(arg2, "Exp", "Exp", var56)
	end
end
function module_upvr_2.GiveAllPlayersExp(arg1, arg2) -- Line 170
	--[[ Upvalues[1]:
		[1]: module_upvr_2 (readonly)
	]]
	for _, v in pairs(game.Players:GetPlayers()) do
		module_upvr_2:GiveExp(v, arg2)
	end
end
function module_upvr_2.GetLevelScaling(arg1, arg2) -- Line 176
	return math.pow(arg2, 1.5) * 100
end
return module_upvr_2






=====================================================================================================




game:GetService("ReplicatedStorage").Package.Modules.Libs.DailyData
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-26 00:13:02
-- Luau version 6, Types version 3
-- Time taken: 0.001258 seconds

return {{
	Name = "Gem";
	Typ = "Item";
	Amount = 5;
}, {
	Name = "Gold";
	Typ = "Item";
	Amount = 500;
}, {
	Name = "Gem";
	Typ = "Item";
	Amount = 7;
}, {
	Name = "Gold";
	Typ = "Item";
	Amount = 700;
}, {
	Name = "Gem";
	Typ = "Item";
	Amount = 10;
}, {
	Name = "Gold";
	Typ = "Item";
	Amount = 900;
}, {
	Name = "Gem";
	Typ = "Item";

	Amount = 15;
}}







=====================================================================================================






game:GetService("ReplicatedStorage").Package.Modules.Libs.WeaponData
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-26 00:06:23
-- Luau version 6, Types version 3
-- Time taken: 0.012501 seconds

return {
	DragonBlade = {
		Damage = 100;
		Color = Color3.new(0.988235, 1, 0.321569);
	};
	["Kings Katana"] = {
		Rarity = "Common";
		Damage = 5;
		Color = Color3.new(0.647059, 0.647059, 0.647059);
	};
	["Orc Blade"] = {
		Rarity = "Common";
		Damage = 7;
		Color = Color3.new(0.776471, 0.768627, 0.768627);
	};
	["Colosses Hammer"] = {
		Rarity = "UnCommon";
		Damage = 9;
	};
	SkyBlade = {
		Rarity = "Rare";
		Damage = 11;
		Color = Color3.new(0.988235, 1, 0.215686);
	};
	["Knight's Sword"] = {
		Rarity = "Epic";
		Damage = 13;
		Color = Color3.new(0.776471, 0.768627, 0.768627);
	};
	["Flame Sword"] = {
		Rarity = "Legendary";
		Damage = 50;
		Color = Color3.new(1, 0.239216, 0.239216);
	};
	["Magnus Spear"] = {
		Rarity = "Mythical";
		Damage = 750;
		Color = Color3.new(1, 0.239216, 0.239216);
	};
	RedKnife = {
		Rarity = "Mythical";
		Damage = 250;
		Color = Color3.new(1, 0.239216, 0.239216);
		OffHand = "RedKnife";
		IdleAnim = "rbxassetid://138783281749841";
		WalkAnim = "rbxassetid://103077378824551";
	};
	["Broken Sword"] = {
		Rarity = "Common";
		Damage = 9;
	};
	Machette = {
		Rarity = "UnCommon";
		Damage = 11;
	};
	Saber = {
		Rarity = "Rare";
		Damage = 13;
		Color = Color3.new(1, 0.772549, 0.313725);
	};
	["Knight Spear"] = {
		Rarity = "Epic";
		Damage = 15;
		Color = Color3.new(1, 1, 1);
	};
	["Sun Spear"] = {
		Rarity = "Legendary";
		Damage = 100;
		Color = Color3.new(1, 0.886275, 0.32549);
	};
	["Oger Sword"] = {
		Rarity = "Common";
		Damage = 11;
		Color = Color3.new(0.65098, 0.65098, 0.65098);
	};
	["Bone Scythe"] = {
		Rarity = "UnCommon";
		Damage = 13;
	};
	["Knight Greatsword"] = {
		Rarity = "Rare";
		Damage = 15;
	};
	["Magnus Axe"] = {
		Rarity = "Epic";
		Damage = 17;
		Color = Color3.new(1, 0.360784, 0.360784);
	};
	["Glacial Mage Sword"] = {
		Rarity = "Legendary";
		Damage = 150;
		Color = Color3.new(0.494118, 0.992157, 1);
	};
	["Holy Sword"] = {
		Rarity = "Legendary";
		Damage = 200;
		Color = Color3.new(1, 0.886275, 0.32549);
	};
	["Paladin Sword"] = {
		Rarity = "Common";
		Damage = 17;
		Color = Color3.new(1, 0.968627, 0.505882);
	};
	["Light Scythe"] = {
		Rarity = "UnCommon";
		Damage = 19;
		Color = Color3.new(1, 0.968627, 0.505882);
	};
	["Blue Lazer Sword"] = {
		Rarity = "Rare";
		Damage = 21;
		Color = Color3.new(0.345098, 0.356863, 1);
	};
	["Orange Laser Sword"] = {
		Rarity = "Epic";
		Damage = 23;
		Color = Color3.new(1, 0.568627, 0.278431);
	};
	["Light Sword"] = {
		Rarity = "Legendary";
		Damage = 200;
		Color = Color3.new(1, 1, 1);
	};
	Wado = {
		Rarity = "Common";
		Damage = 21;
		Color = Color3.new(1, 1, 1);
	};
	["Snow Katana"] = {
		Rarity = "UnCommon";
		Damage = 23;
		Color = Color3.new(0.403922, 0.94902, 1);
	};
	["Ancient Katana"] = {
		Rarity = "Rare";
		Damage = 25;
		Color = Color3.new(0.345098, 0.356863, 1);
	};
	["Pink Katana"] = {
		Rarity = "Epic";
		Damage = 27;
		Color = Color3.new(0.976471, 0.290196, 1);
	};
	["Darkness Katana"] = {
		Rarity = "Legendary";
		Damage = 250;
		Color = Color3.new(0.176471, 0.176471, 0.176471);
	};
	Harpoon = {
		Rarity = "Common";
		Damage = 26;
		Color = Color3.new(0.333333, 0.333333, 0.333333);
	};
	["Coral Sword"] = {
		Rarity = "UnCommon";
		Damage = 28;
		Color = Color3.new(0.980392, 0.423529, 1);
	};
	["Elemental Sword"] = {
		Rarity = "Rare";
		Damage = 30;
		Color = Color3.new(0.345098, 0.356863, 1);
	};
	["Water Sword"] = {
		Rarity = "Epic";
		Damage = 32;
		Color = Color3.new(0.27451, 0.372549, 1);
	};
	Trident = {
		Rarity = "Legendary";
		Damage = 300;
		Color = Color3.new(0.368627, 0.45098, 1);
	};
	["Spiked Club"] = {
		Rarity = "Common";
		Damage = 31;
		Color = Color3.new(0.513725, 0.356863, 0.223529);
	};
	["Iron Mace"] = {
		Rarity = "UnCommon";
		Damage = 34;
		Color = Color3.new(0.333333, 0.333333, 0.333333);
	};
	Karambit = {
		Rarity = "Rare";
		Damage = 35;
		Color = Color3.new(0.345098, 0.356863, 1);
	};
	["Bat Hammer"] = {
		Rarity = "Epic";
		Damage = 37;
		Color = Color3.new(0.258824, 0.258824, 0.258824);
	};
	["Reaper Scythe"] = {
		Rarity = "Legendary";
		Damage = 350;
		Color = Color3.new(1, 0.572549, 0.223529);
	};
	["Double-Edged Sword"] = {
		Rarity = "Common";
		Damage = 100;
		Color = Color3.new(0.333333, 0.333333, 0.333333);
	};
	["Earth Katana"] = {
		Rarity = "UnCommon";
		Damage = 150;
		Color = Color3.new(0.333333, 0.333333, 0.333333);
	};
	["Imperical Sword"] = {
		Rarity = "Rare";
		Damage = 200;
		Color = Color3.new(0.360784, 1, 0.380392);
	};
	["Crystal Sword"] = {
		Rarity = "Epic";
		Damage = 250;
		Color = Color3.new(0.396078, 1, 0.678431);
	};
	Crystalline = {
		Rarity = "Legendary";
		Damage = 400;
		Color = Color3.new(1, 0.572549, 0.223529);
	};
	["Knight Dagger"] = {
		Rarity = "Mythical";
		Damage = 5000;
		Color = Color3.new(1, 0.278431, 0.278431);
		OffHand = "Knight Dagger";
		IdleAnim = "rbxassetid://138783281749841";
		WalkAnim = "http://www.roblox.com/asset/?id=507777826";
	};
	["Celestial Spirit"] = {
		Rarity = "Mythical";
		Damage = 1500;
		Color = Color3.new(0.537255, 0.305882, 1);
	};
	UpgradeInfo = {
		Common = 20;
		UnCommon = 30;
		Rare = 40;
		Epic = 50;
		Legendary = 70;
		Mythical = 100;
	};
}






=====================================================================================================








game:GetService("ReplicatedStorage").Package.Modules.Libs.DungeonData
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-26 00:04:33
-- Luau version 6, Types version 3
-- Time taken: 0.006936 seconds

return {
	DefaultPlaceId = 116429603927158;
	
	{
		Name = "F - Rank";
		Image = "rbxassetid://89063451807432";
		Level = 15;
		Drops = {{
			Name = "Orc Blade";
			Chance = 49.9;
		}, {
			Name = "Colosses Hammer";
			Chance = 35;
		}, {
			Name = "SkyBlade";
			Chance = 10;
		}, {
			Name = "Knight's Sword";
			Chance = 4;
		}, {
			Name = "Flame Sword";
			Chance = 1;
		}, {
			Name = "Magnus Spear";
			Chance = 0.1;
		}};
	}, {
		Name = "E - Rank";
		Image = "rbxassetid://97563267868011";
		Level = 25;
		Drops = {{
			Name = "Broken Sword";
			Chance = 50;
		}, {
			Name = "Machette";
			Chance = 35;
		}, {
			Name = "Saber";
			Chance = 10;
		}, {
			Name = "Knight Spear";
			Chance = 4;
		}, {
			Name = "Sun Spear";
			Chance = 1;
		}};
	}, {
		Name = "D - Rank";
		Image = "rbxassetid://89865888127536";
		Level = 35;
		Drops = {{
			Name = "Oger Sword";
			Chance = 50;
		}, {
			Name = "Bone Scythe";
			Chance = 35;
		}, {
			Name = "Knight Greatsword";
			Chance = 10;
		}, {
			Name = "Magnus Axe";
			Chance = 4;
		}, {
			Name = "Glacial Mage Sword";
			Chance = 1;
		}};
	}, {
		Name = "C - Rank";
		Image = "rbxassetid://124057425208628";
		Level = 60;
		Drops = {{
			Name = "Paladin Sword";
			Chance = 50;
		}, {
			Name = "Light Scythe";
			Chance = 35;
		}, {
			Name = "Blue Lazer Sword";
			Chance = 10;
		}, {
			Name = "Orange Laser Sword";
			Chance = 4;
		}, {
			Name = "Light Sword";
			Chance = 1;
		}};
	}, {
		Name = "B - Rank";
		Image = "rbxassetid://92321956881499";
		Level = 90;
		Drops = {{
			Name = "Wado";
			Chance = 50;
		}, {
			Name = "Snow Katana";
			Chance = 35;
		}, {
			Name = "Ancient Katana";
			Chance = 10;
		}, {
			Name = "Pink Katana";
			Chance = 4;
		}, {
			Name = "Darkness Katana";
			Chance = 1;
		}};
	}, {
		Name = "A - Rank";
		Image = "rbxassetid://88159816232431";
		Level = 150;
		Drops = {{
			Name = "Harpoon";
			Chance = 50;
		}, {
			Name = "Coral Sword";
			Chance = 35;
		}, {
			Name = "Elemental Sword";
			Chance = 10;
		}, {
			Name = "Water Sword";
			Chance = 4;
		}, {
			Name = "Trident";
			Chance = 1;
		}};
	}, {
		Name = "S - Rank";
		Image = "rbxassetid://75475840376950";
		Level = 500;
		Drops = {{
			Name = "Spiked Club";
			Chance = 50;
		}, {
			Name = "Iron Mace";
			Chance = 35;
		}, {
			Name = "Karambit";
			Chance = 10;
		}, {
			Name = "Bat Hammer";
			Chance = 4;
		}, {
			Name = "Reaper Scythe";
			Chance = 1;
		}};
	}, {
		Name = "Insect Cave";
		Image = "rbxassetid://117380394243960";
		Level = 1000;
		Drops = {{
			Name = "Double-Edged Sword";
			Chance = 49.9;
		}, {
			Name = "Earth Katana";
			Chance = 35;
		}, {
			Name = "Imperical Sword";
			Chance = 10;
		}, {
			Name = "Crystal Sword";
			Chance = 4;
		}, {
			Name = "Crystalline";
			Chance = 1;
		}, {
			Name = "Celestial Spirit";
			Chance = 0.1;
		}};
	}, {
		Name = "Coming soon";
		Image = "rbxassetid://117380394243960";
		Level = 999999;
	}
}
=====================================================================================================





game:GetService("ReplicatedStorage").Package.Modules.Libs.ProductData
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-26 00:03:31
-- Luau version 6, Types version 3
-- Time taken: 0.012578 seconds

local any_GetModule_result1_upvr = require(game:GetService("ReplicatedStorage"):WaitForChild("Package"):WaitForChild("Modules"):WaitForChild("CoreMod")):GetModule("RewardMod")
local module = {}
local tbl_4 = {
	Name = "Donate 5";
	ProductId = 3267934783;
}
local function OnUse(arg1) -- Line 13
end
tbl_4.OnUse = OnUse
module[1] = tbl_4
local tbl_2 = {
	Name = "Donate 10";
	ProductId = 3267934784;
}
local function OnUse(arg1) -- Line 21
end
tbl_2.OnUse = OnUse
module[2] = tbl_2
local tbl_10 = {
	Name = "Donate 100";
	ProductId = 3267934785;
}
local function OnUse(arg1) -- Line 28
end
tbl_10.OnUse = OnUse
module[3] = tbl_10
local tbl_5 = {
	Name = "Donate 1000";
	ProductId = 3267934780;
}
local function OnUse(arg1) -- Line 35
end
tbl_5.OnUse = OnUse
module[4] = tbl_5
local tbl_12 = {
	Name = "Donate 10000";
	ProductId = 3267934781;
}
local function OnUse(arg1) -- Line 42
end
tbl_12.OnUse = OnUse
module[5] = tbl_12
local tbl_11 = {
	Name = "5k Gold";
	ProductId = 3289497023;
	Price = 20;
}
local function OnUse(arg1) -- Line 51
	--[[ Upvalues[1]:
		[1]: any_GetModule_result1_upvr (readonly)
	]]
	any_GetModule_result1_upvr:GiveCash(arg1, 5000, true)
end
tbl_11.OnUse = OnUse
module[6] = tbl_11
local tbl_14 = {
	Name = "15k Gold";
	Price = 50;
	ProductId = 3289497021;
}
local function OnUse(arg1) -- Line 60
	--[[ Upvalues[1]:
		[1]: any_GetModule_result1_upvr (readonly)
	]]
	any_GetModule_result1_upvr:GiveCash(arg1, 15000, true)
end
tbl_14.OnUse = OnUse
module[7] = tbl_14
local tbl_13 = {
	Name = "45k Gold";
	Price = 100;
	ProductId = 3289497024;
}
local function OnUse(arg1) -- Line 68
	--[[ Upvalues[1]:
		[1]: any_GetModule_result1_upvr (readonly)
	]]
	any_GetModule_result1_upvr:GiveCash(arg1, 45000, true)
end
tbl_13.OnUse = OnUse
module[8] = tbl_13
local tbl = {
	Name = "150k Gold";
	Price = 250;
	ProductId = 3289497022;
}
local function OnUse(arg1) -- Line 77
	--[[ Upvalues[1]:
		[1]: any_GetModule_result1_upvr (readonly)
	]]
	any_GetModule_result1_upvr:GiveCash(arg1, 150000, true)
end
tbl.OnUse = OnUse
module[9] = tbl
local tbl_7 = {
	Name = "400k Gold";
	Price = 500;
	ProductId = 3289497020;
}
local function OnUse(arg1) -- Line 86
	--[[ Upvalues[1]:
		[1]: any_GetModule_result1_upvr (readonly)
	]]
	any_GetModule_result1_upvr:GiveCash(arg1, 400000, true)
end
tbl_7.OnUse = OnUse
module[10] = tbl_7
local tbl_9 = {
	Name = "Gem 1";
	Price = 35;
	ProductId = 3339339987;
}
local function OnUse(arg1) -- Line 95
	--[[ Upvalues[1]:
		[1]: any_GetModule_result1_upvr (readonly)
	]]
	any_GetModule_result1_upvr:GiveGems(arg1, 1)
end
tbl_9.OnUse = OnUse
module[11] = tbl_9
local tbl_6 = {
	Name = "Gem 5";
	Price = 149;
	ProductId = 3339339988;
}
local function OnUse(arg1) -- Line 104
	--[[ Upvalues[1]:
		[1]: any_GetModule_result1_upvr (readonly)
	]]
	any_GetModule_result1_upvr:GiveGems(arg1, 5)
end
tbl_6.OnUse = OnUse
module[12] = tbl_6
local tbl_8 = {
	Name = "Gem 10";
	Price = 299;
	ProductId = 3339339985;
}
local function OnUse(arg1) -- Line 113
	--[[ Upvalues[1]:
		[1]: any_GetModule_result1_upvr (readonly)
	]]
	any_GetModule_result1_upvr:GiveGems(arg1, 10)
end
tbl_8.OnUse = OnUse
module[13] = tbl_8
local tbl_3 = {
	Name = "Gem 50";
	Price = 1199;
	ProductId = 3339339983;
}
local function OnUse(arg1) -- Line 122
	--[[ Upvalues[1]:
		[1]: any_GetModule_result1_upvr (readonly)
	]]
	any_GetModule_result1_upvr:GiveGems(arg1, 50)
end
tbl_3.OnUse = OnUse
module[14] = tbl_3
module[15] = {
	Name = "Starter Bundle";
	Price = 99;
	ProductId = 3467269819;
	Purchases = 1;
	OnUse = function(arg1) -- Line 132, Named "OnUse"
		--[[ Upvalues[1]:
			[1]: any_GetModule_result1_upvr (readonly)
		]]
		any_GetModule_result1_upvr:GiveGems(arg1, 10)
		any_GetModule_result1_upvr:GiveCash(arg1, 10000, true)
		any_GetModule_result1_upvr:GiveShadow(arg1, "Angel")
	end;
}
return module




=====================================================================================================










-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-26 00:01:43
-- Luau version 6, Types version 3
-- Time taken: 0.014199 seconds

return {
	DragonBlade = {
		Damage = 100;
		Color = Color3.new(0.988235, 1, 0.321569);
	};
	["Kings Katana"] = {
		Rarity = "Common";
		Damage = 5;
		Color = Color3.new(0.647059, 0.647059, 0.647059);
	};
	["Orc Blade"] = {
		Rarity = "Common";
		Damage = 7;
		Color = Color3.new(0.776471, 0.768627, 0.768627);
	};
	["Colosses Hammer"] = {
		Rarity = "UnCommon";
		Damage = 9;
	};
	SkyBlade = {
		Rarity = "Rare";
		Damage = 11;
		Color = Color3.new(0.988235, 1, 0.215686);
	};
	["Knight's Sword"] = {
		Rarity = "Epic";
		Damage = 13;
		Color = Color3.new(0.776471, 0.768627, 0.768627);
	};
	["Flame Sword"] = {
		Rarity = "Legendary";
		Damage = 50;
		Color = Color3.new(1, 0.239216, 0.239216);
	};
	["Magnus Spear"] = {
		Rarity = "Mythical";
		Damage = 750;
		Color = Color3.new(1, 0.239216, 0.239216);
	};
	RedKnife = {
		Rarity = "Mythical";
		Damage = 250;
		Color = Color3.new(1, 0.239216, 0.239216);
		OffHand = "RedKnife";
		IdleAnim = "rbxassetid://138783281749841";
		WalkAnim = "rbxassetid://103077378824551";
	};
	["Broken Sword"] = {
		Rarity = "Common";
		Damage = 9;
	};
	Machette = {
		Rarity = "UnCommon";
		Damage = 11;
	};
	Saber = {
		Rarity = "Rare";
		Damage = 13;
		Color = Color3.new(1, 0.772549, 0.313725);
	};
	["Knight Spear"] = {
		Rarity = "Epic";
		Damage = 15;
		Color = Color3.new(1, 1, 1);
	};
	["Sun Spear"] = {
		Rarity = "Legendary";
		Damage = 100;
		Color = Color3.new(1, 0.886275, 0.32549);
	};
	["Oger Sword"] = {
		Rarity = "Common";
		Damage = 11;
		Color = Color3.new(0.65098, 0.65098, 0.65098);
	};
	["Bone Scythe"] = {
		Rarity = "UnCommon";
		Damage = 13;
	};
	["Knight Greatsword"] = {
		Rarity = "Rare";
		Damage = 15;
	};
	["Magnus Axe"] = {
		Rarity = "Epic";
		Damage = 17;
		Color = Color3.new(1, 0.360784, 0.360784);
	};
	["Glacial Mage Sword"] = {
		Rarity = "Legendary";
		Damage = 150;
		Color = Color3.new(0.494118, 0.992157, 1);
	};
	["Holy Sword"] = {
		Rarity = "Legendary";
		Damage = 200;
		Color = Color3.new(1, 0.886275, 0.32549);
	};
	["Paladin Sword"] = {
		Rarity = "Common";
		Damage = 17;
		Color = Color3.new(1, 0.968627, 0.505882);
	};
	["Light Scythe"] = {
		Rarity = "UnCommon";
		Damage = 19;
		Color = Color3.new(1, 0.968627, 0.505882);
	};
	["Blue Lazer Sword"] = {
		Rarity = "Rare";
		Damage = 21;
		Color = Color3.new(0.345098, 0.356863, 1);
	};
	["Orange Laser Sword"] = {
		Rarity = "Epic";
		Damage = 23;
		Color = Color3.new(1, 0.568627, 0.278431);
	};
	["Light Sword"] = {
		Rarity = "Legendary";
		Damage = 200;
		Color = Color3.new(1, 1, 1);
	};
	Wado = {
		Rarity = "Common";
		Damage = 21;
		Color = Color3.new(1, 1, 1);
	};
	["Snow Katana"] = {
		Rarity = "UnCommon";
		Damage = 23;
		Color = Color3.new(0.403922, 0.94902, 1);
	};
	["Ancient Katana"] = {
		Rarity = "Rare";
		Damage = 25;
		Color = Color3.new(0.345098, 0.356863, 1);
	};
	["Pink Katana"] = {
		Rarity = "Epic";
		Damage = 27;
		Color = Color3.new(0.976471, 0.290196, 1);
	};
	["Darkness Katana"] = {
		Rarity = "Legendary";
		Damage = 250;
		Color = Color3.new(0.176471, 0.176471, 0.176471);
	};
	Harpoon = {
		Rarity = "Common";
		Damage = 26;
		Color = Color3.new(0.333333, 0.333333, 0.333333);
	};
	["Coral Sword"] = {
		Rarity = "UnCommon";
		Damage = 28;
		Color = Color3.new(0.980392, 0.423529, 1);
	};
	["Elemental Sword"] = {
		Rarity = "Rare";
		Damage = 30;
		Color = Color3.new(0.345098, 0.356863, 1);
	};
	["Water Sword"] = {
		Rarity = "Epic";
		Damage = 32;
		Color = Color3.new(0.27451, 0.372549, 1);
	};
	Trident = {
		Rarity = "Legendary";
		Damage = 300;
		Color = Color3.new(0.368627, 0.45098, 1);
	};
	["Spiked Club"] = {
		Rarity = "Common";
		Damage = 31;
		Color = Color3.new(0.513725, 0.356863, 0.223529);
	};
	["Iron Mace"] = {
		Rarity = "UnCommon";
		Damage = 34;
		Color = Color3.new(0.333333, 0.333333, 0.333333);
	};
	Karambit = {
		Rarity = "Rare";
		Damage = 35;
		Color = Color3.new(0.345098, 0.356863, 1);
	};
	["Bat Hammer"] = {
		Rarity = "Epic";
		Damage = 37;
		Color = Color3.new(0.258824, 0.258824, 0.258824);
	};
	["Reaper Scythe"] = {
		Rarity = "Legendary";
		Damage = 350;
		Color = Color3.new(1, 0.572549, 0.223529);
	};
	["Double-Edged Sword"] = {
		Rarity = "Common";
		Damage = 100;
		Color = Color3.new(0.333333, 0.333333, 0.333333);
	};
	["Earth Katana"] = {
		Rarity = "UnCommon";
		Damage = 150;
		Color = Color3.new(0.333333, 0.333333, 0.333333);
	};
	["Imperical Sword"] = {
		Rarity = "Rare";
		Damage = 200;
		Color = Color3.new(0.360784, 1, 0.380392);
	};
	["Crystal Sword"] = {
		Rarity = "Epic";
		Damage = 250;
		Color = Color3.new(0.396078, 1, 0.678431);
	};
	Crystalline = {
		Rarity = "Legendary";
		Damage = 400;
		Color = Color3.new(1, 0.572549, 0.223529);
	};
	["Knight Dagger"] = {
		Rarity = "Mythical";
		Damage = 5000;
		Color = Color3.new(1, 0.278431, 0.278431);
		OffHand = "Knight Dagger";
		IdleAnim = "rbxassetid://138783281749841";
		WalkAnim = "http://www.roblox.com/asset/?id=507777826";
	};
	["Celestial Spirit"] = {
		Rarity = "Mythical";
		Damage = 1500;
		Color = Color3.new(0.537255, 0.305882, 1);
	};
	UpgradeInfo = {
		Common = 20;
		UnCommon = 30;
		Rare = 40;
		Epic = 50;
		Legendary = 70;
		Mythical = 100;
	};
}
=====================================================================================================







game:GetService("ReplicatedStorage").Package.Modules.Libs.TraitData
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-26 00:00:06
-- Luau version 6, Types version 3
-- Time taken: 0.012204 seconds

local function Colors_upvr(...) -- Line 1, Named "Colors"
	return ColorSequence.new(...)
end
local function _() -- Line 5, Named "common"
	--[[ Upvalues[1]:
		[1]: Colors_upvr (readonly)
	]]
	return Colors_upvr(Color3.fromRGB(173, 173, 172), Color3.new(1, 1, 1), Color3.fromRGB(173, 173, 172))
end
local function _() -- Line 10, Named "rare"
	--[[ Upvalues[1]:
		[1]: Colors_upvr (readonly)
	]]
	return Colors_upvr(Color3.fromRGB(25, 167, 0), Color3.new(0.0156863, 1, 0), Color3.fromRGB(37, 173, 0))
end
local function _() -- Line 15, Named "Epic"
	--[[ Upvalues[1]:
		[1]: Colors_upvr (readonly)
	]]
	return Colors_upvr(Color3.fromRGB(0, 55, 255), Color3.new(0, 1, 1), Color3.fromRGB(0, 17, 173))
end
return {
	["Damage 1"] = {
		Damage = 1.05;
		Image = "rbxassetid://11953933662";
		Color = Colors_upvr(Color3.fromRGB(173, 173, 172), Color3.new(1, 1, 1), Color3.fromRGB(173, 173, 172));
		Description = "5% Damage Boost";
	};
	["Damage 2"] = {
		Damage = 1.1;
		Image = "rbxassetid://11953933662";
		Description = "10% Damage Boost";
		Color = Colors_upvr(Color3.fromRGB(25, 167, 0), Color3.new(0.0156863, 1, 0), Color3.fromRGB(37, 173, 0));
	};
	["Damage 3"] = {
		Damage = 1.15;
		Image = "rbxassetid://11953933662";
		Description = "15% Damage Boost";
		Color = Colors_upvr(Color3.fromRGB(0, 55, 255), Color3.new(0, 1, 1), Color3.fromRGB(0, 17, 173));
	};
	["Health 1"] = {
		Health = 1.05;
		Image = "rbxassetid://11953925184";
		Description = "5% Health Boost";
		Color = Colors_upvr(Color3.fromRGB(173, 173, 172), Color3.new(1, 1, 1), Color3.fromRGB(173, 173, 172));
	};
	["Health 2"] = {
		Health = 1.1;
		Image = "rbxassetid://11953925184";
		Description = "10% Health Boost";
		Color = Colors_upvr(Color3.fromRGB(25, 167, 0), Color3.new(0.0156863, 1, 0), Color3.fromRGB(37, 173, 0));
	};
	["Health 3"] = {
		Health = 1.15;
		Image = "rbxassetid://11953925184";
		Description = "15% Health Boost";
		Color = Colors_upvr(Color3.fromRGB(0, 55, 255), Color3.new(0, 1, 1), Color3.fromRGB(0, 17, 173));
	};
	["Critical 1"] = {
		Critical = 5;
		Image = "rbxassetid://11953876974";
		Description = "5% Crit Chance";
		Color = Colors_upvr(Color3.fromRGB(173, 173, 172), Color3.new(1, 1, 1), Color3.fromRGB(173, 173, 172));
	};
	["Critical 2"] = {
		Critical = 10;
		Image = "rbxassetid://11953876974";
		Description = "10% Crit Chance";
		Color = Colors_upvr(Color3.fromRGB(25, 167, 0), Color3.new(0.0156863, 1, 0), Color3.fromRGB(37, 173, 0));
	};
	["Critical 3"] = {
		Critical = 15;
		Image = "rbxassetid://11953876974";
		Description = "15% Crit Chance";
		Color = Colors_upvr(Color3.fromRGB(0, 55, 255), Color3.new(0, 1, 1), Color3.fromRGB(0, 17, 173));
	};
	Knight = {
		Damage = 1.2;
		Health = 1.1;
		Image = "rbxassetid://11953878286";
		Description = "20% damage Boost; 10% Health Boost";
		Lock = true;
		Sound = "kusakabe war cry";
		Color = Colors_upvr(Color3.fromRGB(255, 157, 0), Color3.new(1, 0.968627, 0), Color3.fromRGB(255, 119, 0));
	};
	Beserker = {
		Damage = 1.75;
		Health = 1.2;
		Image = "rbxassetid://11953933458";
		Description = "75% damage Boost; 20% Health Boost";
		Lock = true;
		Sound = "EpicHorn";
		Color = Colors_upvr(Color3.fromRGB(147, 0, 0), Color3.new(1, 0, 0), Color3.fromRGB(145, 0, 0));
	};
	["Quick 1"] = {
		AttackSpeed = 1.05;
		Image = "rbxassetid://13858987536";
		Color = Colors_upvr(Color3.fromRGB(173, 173, 172), Color3.new(1, 1, 1), Color3.fromRGB(173, 173, 172));
	};
	Chances = {
		["Damage 1"] = 20;
		["Health 1"] = 20;
		["Critical 1"] = 19.5;
		["Damage 2"] = 10;
		["Health 2"] = 10;
		["Critical 2"] = 10;
		["Damage 3"] = 3;
		["Health 3"] = 3;
		["Critical 3"] = 3;
		Knight = 1;
		Beserker = 0.5;
	};
	DisplayOrder = {"Damage 1", "Health 1", "Critical 1", "Damage 2", "Health 2", "Critical 2", "Damage 3", "Health 3", "Critical 3", "Knight", "Beserker"};
}





=====================================================================================================






game:GetService("ReplicatedStorage").Package.Modules.Libs.TitleData.TitleFunctions.Owner
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-25 23:56:19
-- Luau version 6, Types version 3
-- Time taken: 0.004860 seconds

local module = {}
local module_upvr = require(game:GetService("ReplicatedStorage"):WaitForChild("Package"):WaitForChild("Modules"):WaitForChild("CoreMod"))
function module.Use(arg1, arg2) -- Line 10
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local Data = arg2:FindFirstChild("Data")
	if not Data then
	else
		local PlayerStats = Data:FindFirstChild("PlayerStats")
		if not PlayerStats then return end
		local Title = PlayerStats:FindFirstChild("Title")
		if not Title then return end
		local Character = arg2.Character
		if not Character or not Character.PrimaryPart then return end
		local tbl_upvr_2 = {}
		for _, v_2 in pairs(Character:GetDescendants()) do
			if v_2:IsA("BasePart") and not v_2:FindFirstAncestor("Weapon") then
				(function(arg1_2) -- Line 22, Named "addParticles"
					--[[ Upvalues[2]:
						[1]: module_upvr (copied, readonly)
						[2]: tbl_upvr_2 (readonly)
					]]
					for _, v in pairs(module_upvr.VFXFolder.Auras.MaxAura:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							table.insert(tbl_upvr_2, module_upvr:Clone(v, nil, arg1_2))
						end
					end
				end)(v_2)
			end
		end
		local tbl_upvr = {Title:GetPropertyChangedSignal("Value"):Connect(function() -- Line 36
			--[[ Upvalues[3]:
				[1]: module_upvr (copied, readonly)
				[2]: tbl_upvr_2 (readonly)
				[3]: tbl_upvr (readonly)
			]]
			module_upvr:DestroyItems(tbl_upvr_2)
			tbl_upvr[1]:Disconnect()
		end)}
	end
end
return module
