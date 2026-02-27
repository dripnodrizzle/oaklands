-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-15 21:42:52
-- Luau version 6, Types version 3
-- Time taken: 0.020545 seconds

local module_2_upvr = {}
local tbl_upvr_2 = {"Sword", "Greatsword", "Scythe", "Dagger", "Rapier", "Axe", "Spear", "Staff"}
local tbl_upvr = {"GuardPower", "MagicalPower", "PhysicalPower", "ArmorRating", "Health", "Mana"}
local module_upvr = {"Armor", "Companions", "Misc", "Mounts", "Shields", "Weapons"}
local module_upvr_2 = {"Armor", "Shields", "Weapons"}
local tbl_upvr_3 = {"Misc", "Companions", "Materials"}
local module_5_upvr = {"Misc", "Companions", "Mounts"}
function module_2_upvr.CreateItemDataFromNumberValue(arg1, arg2, arg3) -- Line 10
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local any_GetItemInfoFolder_result1_2 = module_2_upvr.GetItemInfoFolder(arg2.Name, arg3)
	if any_GetItemInfoFolder_result1_2 then
		return {
			Name = arg2.Name;
			Class = any_GetItemInfoFolder_result1_2.Class;
			Leveling = {
				Level = tonumber(arg2:GetAttribute("Level") or 1);
			};
		}
	end
end
function module_2_upvr.CreateItemDataFromName(arg1, arg2, arg3, arg4) -- Line 28
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local any_GetItemInfoFolder_result1 = module_2_upvr.GetItemInfoFolder(arg2, arg4)
	if any_GetItemInfoFolder_result1 then
		local module_3 = {}
		module_3.Name = arg2
		module_3.Class = any_GetItemInfoFolder_result1.Class
		module_3.Leveling = {
			Level = arg3 or 1;
		}
		return module_3
	end
end
function module_2_upvr.GetLevelInventoryClasses(arg1) -- Line 43
	--[[ Upvalues[1]:
		[1]: module_upvr_2 (readonly)
	]]
	return module_upvr_2
end
function module_2_upvr.GetArrayInventoryClasses(arg1) -- Line 47
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr
end
function module_2_upvr.IsArrayInventoryClass(arg1, arg2) -- Line 51
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return table.find(module_upvr, arg2)
end
function module_2_upvr.GetStackedInventoryClasses(arg1) -- Line 55
	--[[ Upvalues[1]:
		[1]: module_5_upvr (readonly)
	]]
	return module_5_upvr
end
function module_2_upvr.GetInventorySize(arg1, arg2, arg3) -- Line 59
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	if arg3 then
		if arg3 == "Materials" then
			return module_2_upvr.LengthOfDictionary(arg2.Data.Inventory.Materials)
		end
		local var14 = arg2.Data.Inventory[arg3]
		if var14 then
			var14 = #arg2.Data.Inventory[arg3]
		end
		return var14
	end
	return #arg2.Data.Inventory.Armor + #arg2.Data.Inventory.Weapons + #arg2.Data.Inventory.Shields
end
function module_2_upvr.GetInvetoryClassSizeText(arg1, arg2, arg3, arg4) -- Line 73
	--[[ Upvalues[2]:
		[1]: module_2_upvr (readonly)
		[2]: tbl_upvr_3 (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var15
	if arg3 ~= "All" then
		var15 = arg3
	else
		var15 = nil
	end
	var15 = tbl_upvr_3
	if table.find(var15, arg3) then
	else
	end
	return `{module_2_upvr:GetInventorySize(arg2, var15)}{` / {arg4._GameData.INVENTORY_LIMIT}`}`
end
function module_2_upvr.GetWeaponStyle(arg1, arg2, arg3) -- Line 77
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Hands = arg3.Data.Equipped.Hands
	local var17
	if Hands[2] ~= "None" and Hands[2].Class == Hands[1].Class then
		var17 = "Dual"
	else
		var17 = "Single"
	end
	if Hands[2] ~= "None" then
		if Hands[2].Class ~= "Shield" then
		else
		end
	end
	return var17, true
end
function module_2_upvr.IsAWeapon(arg1, arg2) -- Line 86
	--[[ Upvalues[1]:
		[1]: tbl_upvr_2 (readonly)
	]]
	return table.find(tbl_upvr_2, arg2.Class)
end
function module_2_upvr.TypeIsWeapon(arg1, arg2) -- Line 90
	--[[ Upvalues[1]:
		[1]: tbl_upvr_2 (readonly)
	]]
	return table.find(tbl_upvr_2, arg2)
end
function module_2_upvr.GetItemInventoryClass(arg1, arg2) -- Line 94
	--[[ Upvalues[1]:
		[1]: tbl_upvr_2 (readonly)
	]]
	if arg2 == "Armor" then
		return "Armor"
	end
	if table.find(tbl_upvr_2, arg2) or arg2 == "Weapon" or arg2 == "Weapons" then
		return "Weapons"
	end
	if arg2 == "Shield" then
		return "Shields"
	end
	if arg2 == "Mount" then
		return "Mounts"
	end
	if arg2 == "Companion" then
		return "Companions"
	end
	if arg2 == "Aura" then
		return "Misc"
	end
	if arg2 == "Overlay" then
		return "Misc"
	end
	if arg2 == "Material" then
		return "Materials"
	end
end
function module_2_upvr.GetItemInfoClass(arg1, arg2) -- Line 105
	--[[ Upvalues[1]:
		[1]: tbl_upvr_2 (readonly)
	]]
	if arg2 == "Armor" then
		return "Armor"
	end
	if table.find(tbl_upvr_2, arg2) or arg2 == "Weapon" then
		return "Weapons"
	end
	if arg2 == "Shield" then
		return "Shields"
	end
	if arg2 == "Aura" then
		return "Auras"
	end
	if arg2 == "Mount" then
		return "Mounts"
	end
	if arg2 == "Overlay" then
		return "Overlays"
	end
	if arg2 == "Companion" then
		return "Companions"
	end
	if arg2 == "Material" then
		return "Materials"
	end
end
function module_2_upvr.ItemClassIsCosmetic(arg1, arg2) -- Line 116
	return table.find({"Aura", "Mount", "Overlay", "Companion"}, arg2)
end
function module_2_upvr.CalculateItemStatByLevel(arg1, arg2, arg3) -- Line 127
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local module = {}
	for i, v in arg3.Stats do
		if table.find(tbl_upvr, i) then
			v += v * 0.32 * (arg2 - 1)
		end
		module[i] = math.floor(v)
	end
	return module
end
function module_2_upvr.HoursInSeconds(arg1, arg2) -- Line 145
	return arg2 * 60 * 60
end
function module_2_upvr.SecondsToHMS(arg1, arg2) -- Line 149
	return string.format("%02d:%02d:%02d", math.floor(arg2 / 3600), math.floor(arg2 % 3600 / 60), arg2 % 60)
end
function module_2_upvr.LengthOfDictionary(arg1) -- Line 157
	local var26 = 0
	for _, _ in arg1 do
		var26 += 1
	end
	return var26
end
function module_2_upvr.GetItemInfoFolder(arg1, arg2) -- Line 167
	for _, v_3 in {"Armor", "Auras", "Companions", "Materials", "Mounts", "Overlays", "Shields", "Weapons", "Emotes"} do
		local var30 = arg2[v_3]
		if var30 and var30[arg1] then
			return var30[arg1], v_3
		end
	end
	return nil
end
function module_2_upvr.GetFloorFolderByPlaceId(arg1, arg2) -- Line 181
	for i_4, v_4 in arg2.Floors do
		if v_4.PlaceId == arg1 then
			return i_4, v_4
		end
	end
end
function module_2_upvr.GetDungeonFolderByPlaceId(arg1, arg2) -- Line 189
	for i_5, v_5 in arg2.Dungeons do
		if v_5.PlaceId == arg1 then
			return i_5, v_5
		end
	end
end
function module_2_upvr.FormatTime(arg1) -- Line 197
	local floored = math.floor(arg1 / 86400)
	local var36 = arg1 % 86400
	local floored_3 = math.floor(var36 / 3600)
	local var38 = var36 % 3600
	local floored_2 = math.floor(var38 / 60)
	local var40 = var38 % 60
	local module_4 = {}
	if 0 < floored then
		table.insert(module_4, floored..'D')
	end
	if 0 < floored_3 then
		table.insert(module_4, floored_3..'H')
	end
	if 0 < floored_2 then
		table.insert(module_4, floored_2..'M')
	end
	if 0 < var40 then
		table.insert(module_4, var40..'S')
	end
	return table.concat(module_4, ' ')
end
function module_2_upvr.GetCurrentWeek(arg1) -- Line 223
	local os_time_result1 = os.time()
	return math.floor(math.floor((os_time_result1 - os.time({
		year = os.date("*t", os_time_result1).year;
		month = 1;
		day = 1;
		hour = 0;
		min = 0;
		sec = 0;
	})) / 86400) / 7) + 1
end
function module_2_upvr.GetSecondsUntilNextWeek(arg1) -- Line 247
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local os_time_result1_2 = os.time()
	local os_date_result1 = os.date("*t", os_time_result1_2)
	return os_time_result1_2 - (os_date_result1.wday - 2) % 7 * 86400 - os_date_result1.hour * 3600 - os_date_result1.min * 60 - os_date_result1.sec + 604800 - os_time_result1_2
end
function module_2_upvr.GetPlaceIdInfoFolder(arg1, arg2, arg3) -- Line 280
	for i_6, v_6 in arg3.Floors do
		if v_6.PlaceId == arg2 then
			return i_6, v_6, "Floor"
		end
	end
	for i_7, v_7 in arg3.Bosses do
		if v_7.PlaceId == arg2 then
			return i_7, v_7, "Boss"
		end
	end
	for i_8, v_8 in arg3.DailyBosses do
		if v_8.PlaceId == arg2 then
			return i_8, v_8, "DailyBoss"
		end
	end
	for i_9, v_9 in arg3.Dungeons do
		if v_9.PlaceId == arg2 then
			return i_9, v_9, "Dungeon"
		end
	end
	for i_10, v_10 in arg3.Towers do
		if v_10.PlaceId == arg2 then
			return i_10, v_10, "Tower"
		end
	end
	for i_11, v_11 in arg3.Catacombs do
		if v_11.PlaceId == arg2 then
			return i_11, v_11, "Catacomb"
		end
	end
	for i_12, v_12 in arg3.BattleArenas do
		if v_12.PlaceId == arg2 then
			return i_12, v_12, "BattleArena"
		end
	end
	for i_13, v_13 in arg3.GuildHalls do
		if v_13.PlaceId == arg2 then
			return i_13, v_13, "GuildHall"
		end
	end
	for i_14, v_14 in arg3.Events do
		if v_14.PlaceId == arg2 then
			return i_14, v_14, "Event"
		end
	end
end
return module_2_upvr








-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-15 21:52:28
-- Luau version 6, Types version 3
-- Time taken: 0.113639 seconds

local tbl_12_upvr = {
	RequestDataRepeat = 10;
	SetterError = "[ReplicaController]: Replica setters can only be called inside write functions";
}
local RunService_upvr = game:GetService("RunService")
local function WaitForDescendant_upvr(arg1, arg2, arg3) -- Line 127, Named "WaitForDescendant"
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	local SOME_upvw = arg1:FindFirstChild(arg2, true)
	if SOME_upvw == nil then
		local os_clock_result1 = os.clock()
		while SOME_upvw == nil do
			if os_clock_result1 ~= nil and 1 < os.clock() - os_clock_result1 and (RunService_upvr:IsServer() == true or game:IsLoaded() == true) then
				warn('['..script.Name.."]: Missing "..arg3.." \""..arg2.."\" in "..arg1:GetFullName().."; Please check setup documentation")
			end
			task.wait()
		end
		arg1.DescendantAdded:Connect(function(arg1_2) -- Line 132
			--[[ Upvalues[2]:
				[1]: arg2 (readonly)
				[2]: SOME_upvw (read and write)
			]]
			if arg1_2.Name == arg2 then
				SOME_upvw = arg1_2
			end
		end):Disconnect()
		return SOME_upvw
	end
	return SOME_upvw
end
local var6_upvw
if RunService_upvr:IsServer() == true then
	var6_upvw = Instance.new("Folder")
	var6_upvw.Name = "ReplicaRemoteEvents"
	var6_upvw.Parent = game:GetService("ReplicatedStorage")
else
	var6_upvw = WaitForDescendant_upvr(game:GetService("ReplicatedStorage"), "ReplicaRemoteEvents", "folder")
end
local var9_upvw = {
	GetShared = function(arg1, arg2) -- Line 163, Named "GetShared"
		--[[ Upvalues[1]:
			[1]: WaitForDescendant_upvr (readonly)
		]]
		return WaitForDescendant_upvr(game:GetService("ReplicatedStorage"), arg2, "module")
	end;
	GetModule = function(arg1, arg2) -- Line 167, Named "GetModule"
		--[[ Upvalues[1]:
			[1]: WaitForDescendant_upvr (readonly)
		]]
		return WaitForDescendant_upvr(game:GetService("ServerScriptService"), arg2, "module")
	end;
	SetupRemoteEvent = function(arg1) -- Line 170, Named "SetupRemoteEvent"
		--[[ Upvalues[3]:
			[1]: RunService_upvr (readonly)
			[2]: var6_upvw (read and write)
			[3]: WaitForDescendant_upvr (readonly)
		]]
		if RunService_upvr:IsServer() == true then
			local RemoteEvent = Instance.new("RemoteEvent")
			RemoteEvent.Name = arg1
			RemoteEvent.Parent = var6_upvw
			return RemoteEvent
		end
		return WaitForDescendant_upvr(var6_upvw, arg1, "remote event")
	end;
	Shared = {};
}
local module_3 = require(var9_upvw.GetShared("Madwork", "MadworkScriptSignal"))
var9_upvw.NewScriptSignal = module_3.NewScriptSignal
var9_upvw.NewArrayScriptConnection = module_3.NewArrayScriptConnection
RunService_upvr = {}
local var11_upvr = RunService_upvr
WaitForDescendant_upvr = var9_upvw.NewScriptSignal()
var11_upvr.NewReplicaSignal = WaitForDescendant_upvr
WaitForDescendant_upvr = var9_upvw.NewScriptSignal()
var11_upvr.InitialDataReceivedSignal = WaitForDescendant_upvr
WaitForDescendant_upvr = false
var11_upvr.InitialDataReceived = WaitForDescendant_upvr
WaitForDescendant_upvr = {}
var11_upvr._replicas = WaitForDescendant_upvr
WaitForDescendant_upvr = {}
var11_upvr._class_listeners = WaitForDescendant_upvr
WaitForDescendant_upvr = {}
var11_upvr._child_listeners = WaitForDescendant_upvr
WaitForDescendant_upvr = require(var9_upvw.GetShared("Madwork", "MadworkMaid"))
local _replicas_upvr = var11_upvr._replicas
local _class_listeners_upvr = var11_upvr._class_listeners
local _child_listeners_upvr = var11_upvr._child_listeners
local any_SetupRemoteEvent_result1_upvr_2 = var9_upvw.SetupRemoteEvent("Replica_ReplicaRequestData")
local any_SetupRemoteEvent_result1_upvr = var9_upvw.SetupRemoteEvent("Replica_ReplicaSignal")
local var17_upvw = false
local function GetWriteLibFunctionsRecursive_upvr(arg1, arg2, arg3) -- Line 300, Named "GetWriteLibFunctionsRecursive"
	--[[ Upvalues[1]:
		[1]: GetWriteLibFunctionsRecursive_upvr (readonly)
	]]
	for i, v in pairs(arg2) do
		if type(v) == "table" then
			GetWriteLibFunctionsRecursive_upvr(arg1, v, arg3..i..'.')
		elseif type(v) == "function" then
			table.insert(arg1, {arg3..i, v})
		else
			error("[ReplicaController]: Invalid write function value \""..tostring(v).."\" ("..typeof(v).."); name_stack = \""..arg3..'"')
		end
	end
end
local tbl_3_upvr = {}
local function LoadWriteLib_upvr(arg1) -- Line 312, Named "LoadWriteLib"
	--[[ Upvalues[2]:
		[1]: tbl_3_upvr (readonly)
		[2]: GetWriteLibFunctionsRecursive_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var33 = tbl_3_upvr[arg1]
	if var33 ~= nil then
		return var33
	end
	local tbl_7 = {}
	GetWriteLibFunctionsRecursive_upvr(tbl_7, require(arg1), "")
	table.sort(tbl_7, function(arg1_3, arg2) -- Line 323
		local var36
		if arg1_3[1] >= arg2[1] then
			var36 = false
		else
			var36 = true
		end
		return var36
	end)
	local tbl_5 = {}
	for i_2, v_2 in ipairs(tbl_7) do
		({})[i_2] = v_2[2]
		tbl_5[v_2[1]] = i_2
		local var42
	end
	local module = {var42, tbl_5}
	tbl_3_upvr[arg1] = module
	return module
end
local function StringPathToArray_upvr(arg1) -- Line 342, Named "StringPathToArray"
	local module_2 = {}
	if arg1 ~= "" then
		for i_3 in string.gmatch(arg1, "[^%.]+") do
			table.insert(module_2, i_3)
		end
	end
	return module_2
end
local function DestroyReplicaAndDescendantsRecursive_upvr(arg1, arg2) -- Line 352, Named "DestroyReplicaAndDescendantsRecursive"
	--[[ Upvalues[3]:
		[1]: DestroyReplicaAndDescendantsRecursive_upvr (readonly)
		[2]: _replicas_upvr (readonly)
		[3]: _child_listeners_upvr (readonly)
	]]
	for i_4, v_3 in ipairs(arg1.Children) do
		DestroyReplicaAndDescendantsRecursive_upvr(v_3, true)
	end
	local Id = arg1.Id
	_replicas_upvr[Id] = nil
	arg1._maid:Cleanup()
	if arg2 ~= true and arg1.Parent ~= nil then
		local Children_2 = arg1.Parent.Children
		i_4 = Children_2
		v_3 = table.find(Children_2, arg1)
		table.remove(i_4, v_3)
	end
	_child_listeners_upvr[Id] = nil
end
local function CreateTableListenerPathIndex_upvr(arg1, arg2, arg3) -- Line 374, Named "CreateTableListenerPathIndex"
	local var59
	for i_5 = 1, #arg2 do
		local var60 = var59[1][arg2[i_5]]
		if var60 == nil then
			var60 = {{}}
			var59[1][arg2[i_5]] = var60
		end
		var59 = var60
	end
	local var62 = var59[arg3]
	if var62 == nil then
		var62 = {}
		var59[arg3] = var62
	end
	return var62
end
local function CleanTableListenerTable_upvr(arg1) -- Line 395, Named "CleanTableListenerTable"
	local _2 = arg1[2]
	local _1 = arg1[1]
	local tbl_2 = {_1}
	for i_6 = 1, #_2 do
		_1 = _1[1][_2[i_6]]
		table.insert(tbl_2, _1)
	end
	for i_7 = #tbl_2, 2, -1 do
		local var72 = tbl_2[i_7]
		if next(var72[1]) ~= nil then return end
		for i_8 = 2, 6 do
			if var72[i_8] ~= nil and 0 < #var72[i_8] then return end
		end
		tbl_2[i_7 - 1][1][_2[i_7 - 1]] = nil
	end
end
local var73_upvw
local function CreateReplicaBranch_upvr(arg1, arg2) -- Line 420, Named "CreateReplicaBranch"
	--[[ Upvalues[4]:
		[1]: _replicas_upvr (readonly)
		[2]: LoadWriteLib_upvr (readonly)
		[3]: WaitForDescendant_upvr (readonly)
		[4]: var73_upvw (read and write)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local tbl_9 = {}
	local pairs_result1_4, _, pairs_result3_4 = pairs(arg1)
	local var192
	for i_9, v_4 in pairs_result1_4, var192, pairs_result3_4 do
		v_4[6] = tonumber(i_9)
		table.insert(tbl_9, v_4)
	end
	var192 = tbl_9
	table.sort(var192, function(arg1_5, arg2_3) -- Line 428
		local var194
		if arg1_5[6] >= arg2_3[6] then
			var194 = false
		else
			var194 = true
		end
		return var194
	end)
	local tbl_13 = {}
	var192 = arg2
	local var196 = var192
	if not var196 then
		var196 = {}
	end
	for _, v_5 in ipairs(tbl_9) do
		local _6_2 = v_5[6]
		local _4_2 = v_5[4]
		local var202
		local var203 = false
		if _4_2 ~= 0 then
			var202 = _replicas_upvr[_4_2]
			if var202 == nil then
				var203 = true
			end
		end
		local var204
		local var205
		if v_5[5] ~= nil then
			local LoadWriteLib_upvr_result1 = LoadWriteLib_upvr(v_5[5])
			var204 = LoadWriteLib_upvr_result1[1]
			var205 = LoadWriteLib_upvr_result1[2]
		end
		local tbl_4 = {
			Data = v_5[3];
			Id = _6_2;
			Class = v_5[1];
			Tags = v_5[2];
			CustomFunctions = {};
			Parent = var202;
			Children = {};
			_write_lib = var204;
			_write_lib_dictionary = var205;
			_table_listeners = {{}};
			_function_listeners = {};
			_raw_listeners = {};
			_signal_listeners = {};
			_maid = WaitForDescendant_upvr.NewMaid();
		}
		setmetatable(tbl_4, var73_upvw)
		if var202 ~= nil then
			table.insert(var202.Children, tbl_4)
		elseif var203 == true then
			local var209 = tbl_13[_4_2]
			if var209 == nil then
				var209 = {}
				tbl_13[_4_2] = var209
			end
			table.insert(var209, tbl_4)
		end
		_replicas_upvr[_6_2] = tbl_4
		table.insert(var196, tbl_4)
		local var210 = tbl_13[_6_2]
		if var210 ~= nil then
			tbl_13[_6_2] = nil
			for _, v_6 in ipairs(var210) do
				v_6.Parent = tbl_4
				table.insert(tbl_4.Children, v_6)
				local _
			end
		end
	end
	if next(tbl_13) ~= nil then
		for i_12, v_7 in pairs(tbl_13) do
			var203 = tostring(i_12)
			local var221
			for i_13, v_8 in ipairs(v_7) do
				local var222
				if i_13 == 1 then
					var222 = ""
				else
					var222 = ", "
				end
				var221 = var221..var222..v_8:Identify()
			end
			var221 = var221.."}; "
		end
		error(var221)
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return var196
end
local function ReplicaSetValue_upvr(arg1, arg2, arg3) -- Line 515, Named "ReplicaSetValue"
	--[[ Upvalues[1]:
		[1]: _replicas_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var297 = _replicas_upvr[arg1]
	local _table_listeners_5 = var297._table_listeners
	local var299
	for i_14 = 1, #arg2 - 1 do
		var299 = var299[arg2[i_14]]
		if _table_listeners_5 ~= nil then
			local var300 = _table_listeners_5[1][arg2[i_14]]
		end
	end
	local var301 = arg2[#arg2]
	local var302 = var299[var301]
	var299[var301] = arg3
	if var302 ~= arg3 and var300 ~= nil then
		if var302 == nil then
			i_14 = var300[3]
			if i_14 ~= nil then
				i_14 = ipairs(var300[3])
				local ipairs_result1_17, ipairs_result2_8, ipairs_result3_3 = ipairs(var300[3])
				for _, v_9 in ipairs_result1_17, ipairs_result2_8, ipairs_result3_3 do
					v_9(arg3, var301)
					local _
				end
			end
		end
		ipairs_result1_17 = var300[1]
		local var307 = ipairs_result1_17[arg2[#arg2]]
		if var307 ~= nil then
			ipairs_result1_17 = var307[2]
			if ipairs_result1_17 ~= nil then
				ipairs_result1_17 = ipairs(var307[2])
				for _, v_10 in ipairs(var307[2]) do
					v_10(arg3, var302)
					local _
				end
			end
		end
	end
	for _, v_11 in ipairs(var297._raw_listeners) do
		v_11("SetValue", arg2, arg3)
	end
end
local function ReplicaSetValues_upvr(arg1, arg2, arg3) -- Line 554, Named "ReplicaSetValues"
	--[[ Upvalues[1]:
		[1]: _replicas_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var351 = _replicas_upvr[arg1]
	local _table_listeners_4 = var351._table_listeners
	local var353
	for i_18 = 1, #arg2 do
		var353 = var353[arg2[i_18]]
		if _table_listeners_4 ~= nil then
			local var354 = _table_listeners_4[1][arg2[i_18]]
		end
	end
	for i_19, v_12 in pairs(arg3) do
		local var358 = var353[i_19]
		var353[i_19] = v_12
		if var358 ~= v_12 and var354 ~= nil then
			if var358 == nil and var354[3] ~= nil then
				for _, v_13 in ipairs(var354[3]) do
					v_13(v_12, i_19)
				end
			end
			local var362 = var354[1][i_19]
			if var362 ~= nil and var362[2] ~= nil then
				for _, v_14 in ipairs(var362[2]) do
					v_14(v_12, var358)
				end
			end
		end
	end
	for _, v_15 in ipairs(var351._raw_listeners) do
		v_15("SetValues", arg2, arg3)
	end
end
local function ReplicaArrayInsert_upvr(arg1, arg2, arg3) -- Line 595, Named "ReplicaArrayInsert"
	--[[ Upvalues[1]:
		[1]: _replicas_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var389 = _replicas_upvr[arg1]
	local _table_listeners = var389._table_listeners
	local var391
	for i_23 = 1, #arg2 do
		var391 = var391[arg2[i_23]]
		if _table_listeners ~= nil then
			local var392 = _table_listeners[1][arg2[i_23]]
		end
	end
	i_23 = arg3
	table.insert(var391, i_23)
	local len = #var391
	if var392 ~= nil and var392[4] ~= nil then
		i_23 = var392[4]
		local ipairs_result1_27, ipairs_result2_22, ipairs_result3_2 = ipairs(i_23)
		for _, v_16 in ipairs_result1_27, ipairs_result2_22, ipairs_result3_2 do
			v_16(len, arg3)
		end
	end
	ipairs_result2_22 = var389._raw_listeners
	for _, v_17 in ipairs(ipairs_result2_22) do
		v_17("ArrayInsert", arg2, arg3, len)
	end
	return len
end
local function ReplicaArraySet_upvr(arg1, arg2, arg3, arg4) -- Line 624, Named "ReplicaArraySet"
	--[[ Upvalues[1]:
		[1]: _replicas_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var420 = _replicas_upvr[arg1]
	local _table_listeners_2 = var420._table_listeners
	local var422
	for i_26 = 1, #arg2 do
		var422 = var422[arg2[i_26]]
		if _table_listeners_2 ~= nil then
			local var423 = _table_listeners_2[1][arg2[i_26]]
		end
	end
	var422[arg3] = arg4
	if var423 ~= nil and var423[5] ~= nil then
		for _, v_18 in ipairs(var423[5]) do
			v_18(arg3, arg4)
		end
	end
	for _, v_19 in ipairs(var420._raw_listeners) do
		v_19("ArraySet", arg2, arg3, arg4)
	end
end
local function ReplicaArrayRemove_upvr(arg1, arg2, arg3) -- Line 651, Named "ReplicaArrayRemove"
	--[[ Upvalues[1]:
		[1]: _replicas_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var450 = _replicas_upvr[arg1]
	local _table_listeners_6 = var450._table_listeners
	local var452
	for i_29 = 1, #arg2 do
		var452 = var452[arg2[i_29]]
		if _table_listeners_6 ~= nil then
			local var453 = _table_listeners_6[1][arg2[i_29]]
		end
	end
	i_29 = arg3
	local popped = table.remove(var452, i_29)
	if var453 ~= nil and var453[6] ~= nil then
		i_29 = var453[6]
		local ipairs_result1, ipairs_result2_5, ipairs_result3_6 = ipairs(i_29)
		for _, v_20 in ipairs_result1, ipairs_result2_5, ipairs_result3_6 do
			v_20(arg3, popped)
		end
	end
	ipairs_result2_5 = var450._raw_listeners
	for _, v_21 in ipairs(ipairs_result2_5) do
		v_21("ArrayRemove", arg2, arg3, popped)
	end
	return popped
end
var73_upvw = {}
local var461 = var73_upvw
var461.__index = var461
function var461.ListenToChange(arg1, arg2, arg3) -- Line 687
	--[[ Upvalues[4]:
		[1]: StringPathToArray_upvr (readonly)
		[2]: CreateTableListenerPathIndex_upvr (readonly)
		[3]: var9_upvw (read and write)
		[4]: CleanTableListenerTable_upvr (readonly)
	]]
	local var462
	if var462 ~= "function" then
		var462 = error
		var462("[ReplicaController]: Only a function can be set as listener in Replica:ListenToChange()")
	end
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var462 = StringPathToArray_upvr(arg2)
		return var462
	end
	if type(arg2) ~= "string" or not INLINED() then
		var462 = arg2
	end
	if #var462 < 1 then
		error("[ReplicaController]: Passed empty path - a value key must be specified")
	end
	local CreateTableListenerPathIndex_upvr_result1_3 = CreateTableListenerPathIndex_upvr(arg1, var462, 2)
	table.insert(CreateTableListenerPathIndex_upvr_result1_3, arg3)
	return var9_upvw.NewArrayScriptConnection(CreateTableListenerPathIndex_upvr_result1_3, arg3, CleanTableListenerTable_upvr, {arg1._table_listeners, var462})
end
function var461.ListenToNewKey(arg1, arg2, arg3) -- Line 703
	--[[ Upvalues[4]:
		[1]: StringPathToArray_upvr (readonly)
		[2]: CreateTableListenerPathIndex_upvr (readonly)
		[3]: var9_upvw (read and write)
		[4]: CleanTableListenerTable_upvr (readonly)
	]]
	local var465
	if var465 ~= "function" then
		var465 = error
		var465("[ReplicaController]: Only a function can be set as listener in Replica:ListenToNewKey()")
	end
	local function INLINED_2() -- Internal function, doesn't exist in bytecode
		var465 = StringPathToArray_upvr(arg2)
		return var465
	end
	if type(arg2) ~= "string" or not INLINED_2() then
		var465 = arg2
	end
local CreateTableListenerPathIndex_upvr_result1_4 = CreateTableListenerPathIndex_upvr(arg1, var465, 3)
	table.insert(CreateTableListenerPathIndex_upvr_result1_4, arg3)
	if #var465 == 0 then
	return var9_upvw. NewArrayScriptConnection(CreateTableListenerPathIndex_upvr_result1_4, arg3)
	return var9_upvw. NewArrayScriptConnection @ireateTableListenerPathIndex_upvr_result1_4, arg3, CleanTableListenerTable_upyr, {arg1._table_listeners,
	end
	function var461. ListenToArrayInsert (arg1, arg2, arg3) -- Line 720
	-- [[ Upvalues[4]:
	[1]: StringPathToArray_upvr (readonly)
	[2]: CreateTableListenerPathIndex_upvr (readonly)
	[3]: var9_upvw (read and write)
	[4]: CleanTableListenerTable_upvr (readonly)
	］］
	local var468
	if var468 ~= "function" then
	var468 = error
	var468("[ReplicaController]: Only a function can be set as listener in Replica:ListenToArrayInsert()")
	end
	local function INLINED_3() -- Internal function, doesn't exist in bytecode
	var468 = StringPathToArray_upvr (arg2)
	return var468
	end
	if type (arg2) ~= "string" or not INLINED_3() then
	var468 = arg2
	end
	local CreateTableListenerPathIndex_upvr_result1_5 = CreateTableListenerPathIndex_upvr (arg1, var468, 4)
	table. insert(CreateTableListenerPathIndex_upvr_result1_5, arg3)
	if #var468 == Ø then
	4o0 ro wrasaintconnentionicrentaTahtalietanarpathtnday invr rocit1 5 ara？
	return var9_upvw. NewArrayScriptConnection(CreateTableListenerPathIndex_upvr_result1_5, arg3, CleanTableListenerTable_upvr, {arg1._table_listeners,
	end
	Dave LU FlIC
	function var461. ListenToArraySet (arg1, arg2, arg3) -- Line 737
	--[[ Upvalues[4]:
	[1]: StringPathToArray_upvr (readonly)
	[2]: CreateTableListenerPathIndex_upvr (readonly)
	[3]: var9_upvw (read and write)
	[4]: CleanTableListenerTable_upvr (readonly)
	］］
	local var471
	if var471 ~= "function" then
	var471 = error
	var471("[ReplicaController]: Only a function can be set as listener in Replica:ListenToArraySet ()")
	end
	local function INLINED_4() -- Internal function, doesn't exist in bytecode
	var471 = StringPathToArray_upvr (arg2)
	return var471
	if type (arg2) ~= "string" or not INLINED_4() then
	var471 = arg2
	CreateTableListenerPathIndex_upvr_result1_2 = CreateTableListenerPathindex_upvr (arg1, var471, 5)
	insert(CreateTableListenerPathIndex_upvr_result1_2, arg3)
	#var471 == 0 then
	return var9_upvw. NewArrayScriptConnection(CreateTableListenerPathIndex_upvr_result1_2, arg3)
	end
	return var9_upvw. NewArrayScriptConnection(CreateTableListenerPathIndex_upvr_result1_2, arg3, CleanTableListenerTable_upvr, {arg1._table_listeners,
	function var461. ListenToArrayRemove (arg1, arg2, arg3) -- Line 754
	--٢٢ Upvalues[47 :
	[1]: StringPathToArray_upvr (readonly)
	[2]: CreateTableListenerPathIndex_upvr (readonly)
	[3]: var9_upvw (read and write)
	[4]: CleanTableListenerTable_upvr (readonly)
	1]
	local var474
	if var474 ~= "function" then
	var474 = error
	var474("[ReplicaController]: Only a function can be set as listener in Replica:ListenToArrayRemove () "›
	end
	local function INLINED_5() -- Internal function, doesn't exist in bytecode
	var474 = StringPathToArray_upvr (arg2)
	return var474
	end
	if type (arg2) ~= "string" or not INLINED_5() then
	var474 = arg2
	end
	local CreateTableListenerPathIndex_upvr_result1 = CreateTableListenerPathIndex_upvr (arg1, var474, 6)
	table.insert(CreateTableListenerPathIndex_upvr_result1, arg3)
	if #var474 == 0 then
	return var9_upvw. NewArrayScriptConnection (CreateTableListenerPathIndex_upvr_result1, arg3)
	end
	return var9_upvw. NewArrayScriptConnection(CreateTableListenerPathIndex_upvr_result1, arg3, CleanTableListenerTable_upvr, {arg1._table_listeners, v
	end
	function var461.ListenToWrite(arg1, arg2, arg3) -- Line 771|
	--[[ Upvalues[1]:
	[1]: var9_upvw (read and write)
	］］
	if type (arg3) ~= "function" then
	error ("[ReplicaController]: Only a function can be as listener in Replica:ListenToWrite()")
	if arg1._write_lib == nil then
	error ("[ReplicaController]: _write_lib was not declared for this replica")
	end
	local var477 = arg1._write_lib_dictionary[arg2]
	if var477 == nil then
	error ("[ReplicaController]: Write function \'"..arg2…"\" not declared inside _write_lib of this replica")
	end
	local var478 = arg1._function_listeners[var477]
	if var478 == nil then
	var478 = {}
	arg1._function_listeners[var477] = var478
	end
	table. insert(var478, arg3)
	return var9_upvw. NewArrayScriptConnection(var478, arg3)
	end
	function var461. ListenToRaw(arg1, arg2) -- Line 795
	--[L Upvalues[1]:
	[1]: var9_upvw (read and write)
	］］
	local _raw_listeners = argl._raw_listeners
	table. insert(-raw_listeners, arg2)
	return var9_upvw. NewArrayScriptConnection(-raw_listeners, arg2)
	function var461. ConnectOnClientEvent(arg1, arg2) -- Line 802
	--[L Upvalues[1]:
	[1]: var9_upvw (read and write)
	if type (arg2) ~= "function" then
	error("[ReplicaController]: Only functions can be passed to Replica: ConnectOnClientEvent() ")
	end
	table. insert(argl._signal_listeners, arg2)
	return var9_upvw. NewArrayScriptConnection(argl._signal_listeners, arg2)
	end
	function var461. FireServer (arg1, ...) -- Line 810
	--[[ Upvalues[1]:
	[1]: any_SetupRemoteEvent_result1_upvr (readonly)
	］］
	any_SetupRemoteEvent_result1_upvr:FireServer (arg1.Id, ...)
	end
	function var461. ListenToChildAdded(arg1, arg2) -- Line 815
	--[[ Upvalues[3]:
	[1]: _replicas_upvr (readonly)
	[2]: _child_listeners_upvr (readonly)
	[3]: var9_upvw (read and write)
	]]
	if type (arg2) ~= "function" then
	error ("[ReplicaController]: Only a function can be set as listener")
	end
	if _replicas_upvr[argl.Id] == nil then return end
	local var480 = _child_listeners_upvrlarg1.Id]
	if var480 == nil then
	var480 = 1}
	_child_listeners_upvr[arg1.Id] = var480
	end
	table.insert(var480, arg2)
	return var9_upvw. NewArrayScriptConnection(var480, arg2)
	function var461.FindFirstChildOfClass(arg1, arg2) -- Line 833
	-, v_22 in ipairs(arg1.Children) do
	if v_22. Class == arg2 then
	return v_22
	end
	end
	return nil
	end
	function var461.Identify(arg1) -- Line 843
	" 11
	local var490 =
	for i_33, v_23 in pairs (argl. Tags) do
	var490 = var490.."" ••tostring(1_33)..'=' ..tostring(v_23)
	end
	return "[Id:" ….tostring(arg1.Id)..";Class:" ..argl.Class..";Tags: {" "..var490."}]"
	end
	function var461. IsActive(arg1) -- Line 854
	--[[ Upvalues [1]:
	[1]: _replicas_upvr (readonly)
	local var494
	if _replicas_upvr[arg1.Id] == nil then
	var494 = false
	else
	var494 = true
	end
	return var494
	end
	function var461. AddCleanupTask(arg1, arg2) -- Line 858
	return arg1._maid: AddCleanupTask (arg2)
	end
	function var461. RemoveCleanupTask (arg1, arg2) -- Line 862
	argl._maid: RemoveCleanupTask(arg2)
	end
	function var461. SetValue(arg1, arg2, arg3) -- Line 868
	--[L Upvalues [4]:
	[1]: var17_upvw (read and write)
	[2]: tbl_12_upvr (readonly)
	[3]: StringPathToArray_upvr (readonly)
	[4]: ReplicaSetValue_upvr (readonly)
	local var495
	if var495 == false then
	var495 = error
	var495(tbl_12_upvr.SetterError)
	end
	local function INLINED_6() -- Internal function, doesn't exist in bytecode
	var495 = StringPathToArray_upvr(arg2)
	return var495
	end
	if type (arg2) ~= "string" or not INLINED_6() then
	var495 = arg2
	end
	ReplicaSetValue_upvr(arg1.Id, var495, arg3)
	end
	function var461. SetValues (arg1, arg2, arg3) -- Line 876
	--[[ Upvalues [4]:
	[1]: var17_upvw (read and write)
	[2]: tbl_12_upvr (readonly)
	[3]: StringPathToArray_upvr (readonly)
	[4]: ReplicaSetValues_upvr (readonly)
	local var496
	if var496 == false then
	var496 = error
	var496 (tbl_12_upvr.SetterError)
	end
	local function INLINED_7() -- Internal function, doesn't exist in bytecode
	var496 = StringPathToArray_upvr (arg2)
	return var496
	end
	if type(arg2) ~= "string" or not INLINED_7() then
	var496 = arg2
	end
	ReplicaSetValues_upvr(arg1.Id, Var496, arg3)
	end
	function var461.ArrayInsert(arg1, arg2, arg3) -- Line 884
	-- [[ Upvalues[4]:
	[1]: var17_upvw (read and write)
	[2]: tbl_12_upvr (readonly)
	[3]: StringPathToArray_upvr (readonly)
	[4]: ReplicaArrayInsert_upvr (readonly)
	］］
	local var497
	if var497 == false then
	var497 = error
	var497(tbl_12_upvr.SetterError)
	end
	local function INLINED_8() -- Internal function, doesn't exist in bytecode
	var497 = StringPathToArray_upvr (arg2)
	return var497
	end
	if type (arg2) ~= "string" or not INLINED_8() then
	var497 = arg2
	end
	return ReplicaArrayInsert_upvr(arg1.Id, var497, arg3)
	end
	function var461. ArraySet(arg1, arg2, arg3, arg4) -- Lim 892
	--[[ Upvalues[4]:
	[1]: var17_upvw (read and write)
	[2]: tbl_12_upvr (readonly)
	[3]: StringPathToArray_upvr (readonly)
	[4]: ReplicaArraySet_upvr (readonly)
	］］
	local var498
	if var498 == false then
	var498 = error
	var498 (tbl_12_upvr.SetterError)
	end
	local function INLINED_9() -- Internal function, doesn't exist in bytecode
	var498 = StringPathToArray_upvr (arg2)
	return var498
	end
	if type(arg2) ~= "string" or not INLINED_9() then
	var498 = arg2
	end
	ReplicaArraySet_upvr(arg1.Id, var498, arg3, arg4)
	end
	function var461. ArrayRemove(arg1, arg2, arg3) -- Line 900
	--[L Upvalues [4]:
	[1]: var17_upvw (read and write)
	[2]: tbl_12_upvr (readonly)
	[3]: StringPathToArray_upvr (readonly)
	[4]: ReplicaArrayRemove_upvr (readonly)
	1]
	local var499
	if var499 == false then
	var499 = error
	var499(tbl_12_upvr.SetterError)
	end
	local function INLINED_10() -- Internal function, doesn't exist in bytecode
	var499 = StringPathToArray_upvr (arg2)
	return var499
	end
	if type(arg2) ~= "string" or not INLINED_10() then
	var499 = arg2
	end
	return ReplicaArrayRemove_upvr(arg1.Id, var499, arg3)
	end
	function var461. Write(arg1, arg2, ...) -- Line 908
	--[L Upvalues [2]:
	[1]: var17_upvw (read and write)
	[2]: tbl_12_upvr (readonly)
	if var17_upvw == false then
	error (tbl_12_upvr.SetterError)
	end
	local var502 = arg1. write_lib_dictionaryLarg2]
	local var503 = argl._function_listeners[var502]
	if var503 ~= nil then
	for -, v_24 in ipairs(var503) do
	V_24(. .. )
	end
	end
	return table.unpack(table.pack(arg1._write_lib[var502](arg1, …..)))
	end
	local var507_upvw = false
	function var11_upvr. RequestData() -- Line 926
	--[[ Upvalues[4]:
	[1]: var507_upvw (read and write)
	[2]: any_SetupRemoteEvent_result1_upvr_2 (readonly)
	[3]: tbl_12_upvr (readonly)
	[4]: var11_upvr (readonly)
	if var507_upvw == true then
	else
	var507_upvw = true
	task. spawn(function() -- Line 931
	--[[ Upvalues [3]:
	[1]: any_SetupRemoteEvent_result1_upvr_2 (copied, readonly)
	[2]: tbl_12_upvr (copied, readonly)
	[3]: var11_upvr (copied, readonly)
	while game: IsLoaded() == false do
	task. wait()
	end
	any_SetupRemoteEvent_result1_upvr_2:FireServer ()
	while task. wait(tbl_12_upvr.RequestDataRepeat) and var11_upvr. InitialDataReceived ~= true do
	any_SetupRemoteEvent_result1_upvr_2:FireServer()
	end
	end)
	end
	end
	function var11_upvr.ReplicaOfClassCreated(arg1, arg2) -- Line 945
	-- [[ Upvalues [2]:
	[1]: _class_listeners_upvr (readonly)
	[2]: var9_upvw (read and write)
	if type (arg1) ~= "string" then
	error ("[ReplicaController]: replica_class must be a string")
	if type (arg2) ~= "function" then
	error ("[ReplicaController]: Only a function can be set as listener in ReplicaController.ReplicaOfClassCreated() ")
	end
	local var509_upvw = _class_listeners_upvr[arg1]
	if var509_upvw == nil then
	var509_upvw = var9_upvw. NewScriptSignal()
	_class_listeners_upvr[arg1] = var509_upvw
	return var509_upvw: Connect(arg2, function() -- Line 958
	-- [[ Upvalues[3]:
	[1]: var509_upvw (read and write)
	[2]: _class_listeners_upvr (copied, readonly)
	[3]: arg1 (readonly)
	if var509_upvw: GetListenerCount() == 0 and _class_listeners_upvr[arg1] == var509_upvw then
	_class_listeners_upvr[arg1] = nil
	end
	end)
	function var11_upvr. GetReplicaById(arg1) -- Line 966
	--[[ Upvalues[1]:
	[1]: _replicas_upvr (readonly)
	］］
	return _replicas_upvr[arg1]
	end
	any_SetupRemoteEvent_result1_upvr_2.OnClientEvent:Connect(function() -- Line 973
	--[[ Upvalues[1]:
	[1]: var11_upvr (readonly)
	］］
	var11_upvr.InitialDataReceived = true
	var11_upvr.InitialDataReceivedSignal:Fire()
	end)
	var9_upvw.SetupRemoteEvent("Replica_ReplicaSetValue"). OnClientEvent:Connect(ReplicaSetValue_upvr)
	var9_upvw.SetupRemoteEvent("Replica_ReplicaSetValues"). OnClientEvent:Connect(ReplicaSetValues_upvr)
	var9_upvw.SetupRemoteEvent("Replica_ReplicaArrayInsert").OnClientEvent:Connect(ReplicaArrayInsert_upvr)
	var9_upvw.SetupRemoteEvent("Replica_ReplicaArraySet"). OnClientEvent:Connect(ReplicaArraySet_upvr)
	var9_upvw.SetupRemoteEvent ("Replica_ReplicaArrayRemove"). OnClientEvent:Connect (ReplicaArrayRemove_upvr)
	var9_upvw.SetupRemoteEvent("Replica_ReplicaWrite"). OnClientEvent:Connect(function(arg1, arg2, ...) -- Line 990
	--[[ Upvalues [2]:
	[1]: _replicas_upvr (readonly)
	[2]: var17_upvw (read and write)
	local var515 = _replicas_upvr[arg1]
	var17_upvw = true
	var515._write_lib[arg2](var515, ...)
	var17_upvw = false
	local var516 = var515._function_listeners[arg2]
	if var516 ~= nil then
	for -, v_25 in ipairs(var516) do
	v_25(...)
	end
	end
	any_SetupRemoteEvent_result1_upvr.OnClientEvent:Connect(function(arg1, ...) -- Line 1006
	--[[ Upvalues[1]:
	[1]: _replicas_upvr (readonly)
	］］
	for -, v_26 in ipairs(_replicas_upvr[arg1]._signal_listeners) do
	v_26(...)
	end
	end)
	var9_upvw.SetupRemoteEvent("Replica_ReplicaSetParent"). OnClientEvent:Connect(function(arg1, arg2) -- Line 1016
	--[[ Upvalues[2]:
	[1]: _replicas_upvr (readonly)
	[2]: _child_listeners_upvr (readonly)
	］］
	local var529 = _replicas_upvr[arg1]
	local Children = var529. Parent. Children
	local var531 = _replicas_upvr[arg2]
	table. remove (Children, t table. find (Children, var529))
	table. insert(var531. Children, var529)
	var529. Parent = var531
	local var532 = _child_listeners_upvr[arg2]
	if var532 ~= nil then
	for i_37 = 1, #var532 do
	var532[i_37](var529)
	end
	end
	end)
	local NewReplicaSignal_upvr = var11_upvr. NewReplicaSignal
	var9_upvw. SetupRemoteEvent ("Replica_ReplicaCreate"). OnClientEvent:Connect(function(arg1, arg2) -- Line 1033
	--[[ Upvalues [4]:
	[1]: CreateReplicaBranch_upvr (readonly)
	[2]: _child_listeners_upvr (readonly)
	[3]: NewReplicaSignal_upvr (readonly)
	[41: _class_listeners_upvr (readonly)
	］］
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local tbl_6 = {}
	if type (arg1) == "table" then
	table.sort(arg1, function(argl_8, arg2_6) - Line 1047
	local var597
	if argl_8[1] >= arg2_6[1] then
	var597 = false
	else
	var597 = true
	end
	return var597
	end)
	for il _38, v_27 in ipairs(arg1) do
	CreateReplicaBranch_upvr(v_27[2], tbl_6)
	end
	elseif arg2[1] ~= nil then
	local tb1_8 = {}
	i_38 = arg1
	tbl_8[tostring(i_38)] = arg2
	CreateReplicaBranch_upvr(tbl_8, tbl_6)
	else
	CreateReplicaBranch_upvr(arg2, tbl_6)
	end
	table.sort(tbl_6, function(arg1_9, arg2_7) -- Line 1059
	local var603
	if arg1_9. Id >= arg2_7. Id then
	var603 = false
	else
	var603 = true
	end
	return var603
	end)
	for -, V_28 in ipairs(tbl_6) do
	local Parent_2 = v_28.Parent
	if Parent_2 ~= nil then
	local var608 = _child_listeners_upvr[Parent_2.Id]
	if var608 ~= nil then
	for i _40 = 1, #var608 do
	var608[i_40](V_28)
	local-
	end
	end
	end
	end
	for -, v_29 in ipairs(tbl_6) do
	NewReplicaSignal_upvr:Fire(v_29)
	local var613 = _class_listeners_upvr[v_29.Class]
	if var613 ~= nil then
	var613:Fire(v_29)
	end
	end
	end)
	var9_upvw. SetupRemoteEvent ("Replica_ReplicaDestroy"). OnClientEvent:Connect(function(arg1) -- Line 1085
	--[L Upvalues[2]:
	[1]: _replicas_upvr (readonly)
	[2]: DestroyReplicaAndDescendantsRecursive_upvr (readonly)
	DestroyReplicaAndDescendantsRecursive_upvr(_replicas_upvr[arg1])
	end)
	return var11_upvr












    -- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-15 22:26:25
-- Luau version 6, Types version 3
-- Time taken: 0.052268 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicaController = require(ReplicatedStorage.Packages.ReplicaController)
local Parent_upvr = script.Parent
local tbl_7_upvw = {}
local var5_upvw
local var6_upvw
ReplicaController.ReplicaOfClassCreated("Info", function(arg1) -- Line 35
	--[[ Upvalues[1]:
		[1]: tbl_7_upvw (read and write)
	]]
	tbl_7_upvw = arg1.Data
end)
ReplicaController.ReplicaOfClassCreated("PlayerData", function(arg1) -- Line 39
	--[[ Upvalues[4]:
		[1]: var5_upvw (read and write)
		[2]: var6_upvw (read and write)
		[3]: tbl_7_upvw (read and write)
		[4]: Parent_upvr (readonly)
	]]
	var5_upvw = arg1
	var6_upvw = arg1.Children[1]
	local ActiveEvent_upvr = tbl_7_upvw._GameData.ActiveEvent
	local function _() -- Line 46, Named "SetEventMaterial"
		--[[ Upvalues[3]:
			[1]: var6_upvw (copied, read and write)
			[2]: ActiveEvent_upvr (readonly)
			[3]: Parent_upvr (copied, readonly)
		]]
		Parent_upvr.Container.FmExpand.TextLabel.Text = var6_upvw.Data.Inventory.Materials[ActiveEvent_upvr.Material] or 0
	end
	if ActiveEvent_upvr then
		Parent_upvr.Container.Topbar.TextLabel.Text = `{ActiveEvent_upvr.Name} Shop`
		local var10 = tbl_7_upvw.Materials[ActiveEvent_upvr.Material]
		if var10 then
			Parent_upvr.Container.FmExpand.ImageLabel.Image = var10.Image
		end
		Parent_upvr.Container.FmExpand.TextLabel.Text = var6_upvw.Data.Inventory.Materials[ActiveEvent_upvr.Material] or 0
		var6_upvw:ListenToNewKey({"Inventory", "Materials"}, function(arg1_2, arg2) -- Line 67
			--[[ Upvalues[3]:
				[1]: ActiveEvent_upvr (readonly)
				[2]: var6_upvw (copied, read and write)
				[3]: Parent_upvr (copied, readonly)
			]]
			if arg2 == ActiveEvent_upvr.Material then
				Parent_upvr.Container.FmExpand.TextLabel.Text = var6_upvw.Data.Inventory.Materials[ActiveEvent_upvr.Material] or 0
				var6_upvw:ListenToChange({"Inventory", "Materials", ActiveEvent_upvr.Material}, function() -- Line 71
					--[[ Upvalues[3]:
						[1]: var6_upvw (copied, read and write)
						[2]: ActiveEvent_upvr (copied, readonly)
						[3]: Parent_upvr (copied, readonly)
					]]
					Parent_upvr.Container.FmExpand.TextLabel.Text = var6_upvw.Data.Inventory.Materials[ActiveEvent_upvr.Material] or 0
				end)
			end
		end)
		if var6_upvw.Data.Inventory.Materials[ActiveEvent_upvr.Material] then
			var6_upvw:ListenToChange({"Inventory", "Materials", ActiveEvent_upvr.Material}, function() -- Line 78
				--[[ Upvalues[3]:
					[1]: var6_upvw (copied, read and write)
					[2]: ActiveEvent_upvr (readonly)
					[3]: Parent_upvr (copied, readonly)
				]]
				Parent_upvr.Container.FmExpand.TextLabel.Text = var6_upvw.Data.Inventory.Materials[ActiveEvent_upvr.Material] or 0
			end)
		end
	end
end)
local Skills_upvr = require(ReplicatedStorage.Skills)
local UIManagement_upvr = require(ReplicatedStorage.Modules.UIManagement)
local FmSkillInfo_upvr = Parent_upvr.Container.FmSkillInfo
local StatColors_upvr = require(ReplicatedStorage.Modules.StatColors)
local UIListLayout_upvr = Parent_upvr.Container.SfScroller.UIListLayout
local ReplicaFunctions_upvr = require(ReplicatedStorage.Modules.ReplicaFunctions)
local ItemInfoController_upvr = require(ReplicatedStorage.Modules.ItemInfoController)
local FmItemInfo_upvr = Parent_upvr.Container.FmItemInfo
local Abilities_upvr = require(ReplicatedStorage.Abilities)
local Notification_upvr = ReplicatedStorage.PlayerEvents.Notification
local FrameVisibility_upvr = require(ReplicatedStorage.Modules.FrameVisibility)
ReplicaController.ReplicaOfClassCreated("EventShop", function(arg1) -- Line 85
	--[[ Upvalues[15]:
		[1]: var6_upvw (read and write)
		[2]: tbl_7_upvw (read and write)
		[3]: var5_upvw (read and write)
		[4]: Skills_upvr (readonly)
		[5]: UIManagement_upvr (readonly)
		[6]: FmSkillInfo_upvr (readonly)
		[7]: StatColors_upvr (readonly)
		[8]: Parent_upvr (readonly)
		[9]: UIListLayout_upvr (readonly)
		[10]: ReplicaFunctions_upvr (readonly)
		[11]: ItemInfoController_upvr (readonly)
		[12]: FmItemInfo_upvr (readonly)
		[13]: Abilities_upvr (readonly)
		[14]: Notification_upvr (readonly)
		[15]: FrameVisibility_upvr (readonly)
	]]
	repeat
		task.wait()
	until var6_upvw
	local ActiveEvent_upvr_2 = tbl_7_upvw._GameData.ActiveEvent
	local var30_upvr = ActiveEvent_upvr_2
	if var30_upvr then
		var30_upvr = `{ActiveEvent_upvr_2.Name}_{ActiveEvent_upvr_2.Id}`
	end
	local function _(arg1_3) -- Line 93, Named "PurchasedMax"
		--[[ Upvalues[2]:
			[1]: var5_upvw (copied, read and write)
			[2]: var30_upvr (readonly)
		]]
		local var32 = var5_upvw.Data.EventShopPurchases[var30_upvr]
		if var32 then
			var32 = arg1_3.MaxPurchases
			if var32 then
				if arg1_3.MaxPurchases > (var5_upvw.Data.EventShopPurchases[var30_upvr][arg1_3.Name] or 0) then
					var32 = false
				else
					var32 = true
				end
			end
		end
		return var32
	end
	local function PopulateSkillInfo_upvr(arg1_4) -- Line 97, Named "PopulateSkillInfo"
		--[[ Upvalues[4]:
			[1]: Skills_upvr (copied, readonly)
			[2]: UIManagement_upvr (copied, readonly)
			[3]: FmSkillInfo_upvr (copied, readonly)
			[4]: StatColors_upvr (copied, readonly)
		]]
		local Info = Skills_upvr[arg1_4].Info
		UIManagement_upvr:ClearFrameOfClass(FmSkillInfo_upvr.FmStatRequirements, "TextLabel")
		FmSkillInfo_upvr.FmName.TlName.Text = arg1_4
		FmSkillInfo_upvr.FmItem.IlItem.Image = Info.Image
		FmSkillInfo_upvr.TlMana.Text = `Mana {Info.Stats.Mana}`
		FmSkillInfo_upvr.TlCooldown.Text = `Cooldown {Info.Stats.Cooldown}`
		FmSkillInfo_upvr.TlDescription.Text = Info.Description
		local Requirements = Info.Requirements
		if Requirements then
			Requirements = Info.Requirements.Stats
		end
		if Requirements then
			for i, v in Requirements do
				local clone_2 = script.TlStatRequirement:Clone()
				clone_2.Text = `<font color="#{StatColors_upvr[i]:ToHex()}">{i}</font> {v}`
				clone_2.Parent = FmSkillInfo_upvr.FmStatRequirements
			end
		end
		FmSkillInfo_upvr.Visible = true
	end
	local function _() -- Line 123, Named "SetCanvasSize"
		--[[ Upvalues[2]:
			[1]: Parent_upvr (copied, readonly)
			[2]: UIListLayout_upvr (copied, readonly)
		]]
		Parent_upvr.Container.SfScroller.CanvasSize = UDim2.new(0, UIListLayout_upvr.AbsoluteContentSize.X + 10, 0, 0)
	end
	local tbl_17_upvr = {
		BleeterBits = function(arg1_5, arg2) -- Line 128
			--[[ Upvalues[2]:
				[1]: var5_upvw (copied, read and write)
				[2]: var30_upvr (readonly)
			]]
			arg1_5.FmTopbar.TextLabel.Text = "Bleeter Bits"
			arg1_5.FmItem.IlItem.Image = "rbxassetid://17355459666"
			arg1_5.FmItem.IlItem.TlLevel.Text = `x{arg2.Amount}`
			arg1_5.BfPurchase.FmExpand.TextLabel.Text = `x{arg2.Cost}`
			local var43 = var5_upvw.Data.EventShopPurchases[var30_upvr]
			if var43 then
				var43 = arg2.MaxPurchases
				if var43 then
					if arg2.MaxPurchases > (var5_upvw.Data.EventShopPurchases[var30_upvr][arg2.Name] or 0) then
						var43 = false
					else
						var43 = true
					end
				end
			end
			if var43 then
				arg1_5.TextLabel.Text = ""
				arg1_5.BfPurchase.FmExpand.ImageLabel.Visible = false
				arg1_5.BfPurchase.FmExpand.TextLabel.Text = "Purchased"
				arg1_5.BfPurchase.FmExpand.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				return "Owned"
			end
		end;
		Coins = function(arg1_6, arg2) -- Line 144
			--[[ Upvalues[2]:
				[1]: var5_upvw (copied, read and write)
				[2]: var30_upvr (readonly)
			]]
			arg1_6.FmTopbar.TextLabel.Text = "Coins"
			arg1_6.FmItem.IlItem.Image = "rbxassetid://94812535407459"
			arg1_6.FmItem.IlItem.TlLevel.Text = `x{arg2.Amount}`
			arg1_6.BfPurchase.FmExpand.TextLabel.Text = `x{arg2.Cost}`
			local var45 = var5_upvw.Data.EventShopPurchases[var30_upvr]
			if var45 then
				var45 = arg2.MaxPurchases
				if var45 then
					if arg2.MaxPurchases > (var5_upvw.Data.EventShopPurchases[var30_upvr][arg2.Name] or 0) then
						var45 = false
					else
						var45 = true
					end
				end
			end
			if var45 then
				arg1_6.TextLabel.Text = ""
				arg1_6.BfPurchase.FmExpand.ImageLabel.Visible = false
				arg1_6.BfPurchase.FmExpand.TextLabel.Text = "Purchased"
				arg1_6.BfPurchase.FmExpand.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				return "Owned"
			end
		end;
		Weapons = function(arg1_7, arg2) -- Line 160
			--[[ Upvalues[8]:
				[1]: ReplicaFunctions_upvr (copied, readonly)
				[2]: tbl_7_upvw (copied, read and write)
				[3]: UIManagement_upvr (copied, readonly)
				[4]: ItemInfoController_upvr (copied, readonly)
				[5]: FmItemInfo_upvr (copied, readonly)
				[6]: FmSkillInfo_upvr (copied, readonly)
				[7]: var5_upvw (copied, read and write)
				[8]: var30_upvr (readonly)
			]]
			local any_GetItemInfoFolder_result1_upvr = ReplicaFunctions_upvr.GetItemInfoFolder(arg2.Name, tbl_7_upvw)
			local tbl_15_upvr = {
				Name = arg2.Name;
				Class = any_GetItemInfoFolder_result1_upvr.Class;
				Leveling = {
					Level = arg2.Level;
				};
			}
			arg1_7.FmTopbar.TextLabel.Text = arg2.Name
			UIManagement_upvr:SetEquipmentFrame(arg1_7.FmItem, {
				Name = arg2.Name;
				Leveling = {
					Level = arg2.Level;
				};
			})
			arg1_7.BfPurchase.FmExpand.TextLabel.Text = `x{arg2.Cost}`
			arg1_7.FmItem.TextButton.MouseButton1Click:Connect(function() -- Line 179
				--[[ Upvalues[5]:
					[1]: ItemInfoController_upvr (copied, readonly)
					[2]: FmItemInfo_upvr (copied, readonly)
					[3]: tbl_15_upvr (readonly)
					[4]: any_GetItemInfoFolder_result1_upvr (readonly)
					[5]: FmSkillInfo_upvr (copied, readonly)
				]]
				ItemInfoController_upvr:PopulateNewItemInfoFrame(FmItemInfo_upvr, "Weapons", tbl_15_upvr, any_GetItemInfoFolder_result1_upvr)
				FmSkillInfo_upvr.Visible = false
				FmItemInfo_upvr.Visible = true
			end)
			local var60 = var5_upvw.Data.EventShopPurchases[var30_upvr]
			if var60 then
				var60 = arg2.MaxPurchases
				if var60 then
					if arg2.MaxPurchases > (var5_upvw.Data.EventShopPurchases[var30_upvr][arg2.Name] or 0) then
						var60 = false
					else
						var60 = true
					end
				end
			end
			if var60 then
				arg1_7.TextLabel.Text = ""
				arg1_7.BfPurchase.FmExpand.ImageLabel.Visible = false
				arg1_7.BfPurchase.FmExpand.TextLabel.Text = "Purchased"
				arg1_7.BfPurchase.FmExpand.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				return "Owned"
			end
		end;
		Armor = function(arg1_8, arg2) -- Line 196
			--[[ Upvalues[8]:
				[1]: ReplicaFunctions_upvr (copied, readonly)
				[2]: tbl_7_upvw (copied, read and write)
				[3]: UIManagement_upvr (copied, readonly)
				[4]: ItemInfoController_upvr (copied, readonly)
				[5]: FmItemInfo_upvr (copied, readonly)
				[6]: FmSkillInfo_upvr (copied, readonly)
				[7]: var5_upvw (copied, read and write)
				[8]: var30_upvr (readonly)
			]]
			local any_GetItemInfoFolder_result1_upvr_2 = ReplicaFunctions_upvr.GetItemInfoFolder(arg2.Name, tbl_7_upvw)
			local tbl_8_upvr = {
				Name = arg2.Name;
				Class = any_GetItemInfoFolder_result1_upvr_2.Class;
				Leveling = {
					Level = arg2.Level;
				};
			}
			arg1_8.FmTopbar.TextLabel.Text = arg2.Name
			UIManagement_upvr:SetEquipmentFrame(arg1_8.FmItem, {
				Name = arg2.Name;
				Leveling = {
					Level = arg2.Level;
				};
			})
			arg1_8.BfPurchase.FmExpand.TextLabel.Text = `x{arg2.Cost}`
			arg1_8.FmItem.TextButton.MouseButton1Click:Connect(function() -- Line 215
				--[[ Upvalues[5]:
					[1]: ItemInfoController_upvr (copied, readonly)
					[2]: FmItemInfo_upvr (copied, readonly)
					[3]: tbl_8_upvr (readonly)
					[4]: any_GetItemInfoFolder_result1_upvr_2 (readonly)
					[5]: FmSkillInfo_upvr (copied, readonly)
				]]
				ItemInfoController_upvr:PopulateNewItemInfoFrame(FmItemInfo_upvr, "Weapons", tbl_8_upvr, any_GetItemInfoFolder_result1_upvr_2)
				FmSkillInfo_upvr.Visible = false
				FmItemInfo_upvr.Visible = true
			end)
			local var68 = var5_upvw.Data.EventShopPurchases[var30_upvr]
			if var68 then
				var68 = arg2.MaxPurchases
				if var68 then
					if arg2.MaxPurchases > (var5_upvw.Data.EventShopPurchases[var30_upvr][arg2.Name] or 0) then
						var68 = false
					else
						var68 = true
					end
				end
			end
			if var68 then
				arg1_8.TextLabel.Text = ""
				arg1_8.BfPurchase.FmExpand.ImageLabel.Visible = false
				arg1_8.BfPurchase.FmExpand.TextLabel.Text = "Purchased"
				arg1_8.BfPurchase.FmExpand.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				return "Owned"
			end
		end;
		Overlays = function(arg1_9, arg2) -- Line 232
			--[[ Upvalues[8]:
				[1]: ReplicaFunctions_upvr (copied, readonly)
				[2]: tbl_7_upvw (copied, read and write)
				[3]: UIManagement_upvr (copied, readonly)
				[4]: ItemInfoController_upvr (copied, readonly)
				[5]: FmItemInfo_upvr (copied, readonly)
				[6]: FmSkillInfo_upvr (copied, readonly)
				[7]: var5_upvw (copied, read and write)
				[8]: var30_upvr (readonly)
			]]
			local any_GetItemInfoFolder_result1_upvr_4 = ReplicaFunctions_upvr.GetItemInfoFolder(arg2.Name, tbl_7_upvw)
			local tbl_9_upvr = {
				Name = arg2.Name;
				Class = any_GetItemInfoFolder_result1_upvr_4.Class;
			}
			arg1_9.FmTopbar.TextLabel.Text = arg2.Name
			UIManagement_upvr:SetEquipmentFrame(arg1_9.FmItem, {
				Name = arg2.Name;
				Leveling = {
					Level = arg2.Level;
				};
			})
			arg1_9.FmItem.IlItem.TlLevel.Text = "x1"
			arg1_9.FmItem.IlItem.TlLevel.Visible = true
			arg1_9.BfPurchase.FmExpand.TextLabel.Text = `x{arg2.Cost}`
			arg1_9.FmItem.TextButton.MouseButton1Click:Connect(function() -- Line 250
				--[[ Upvalues[5]:
					[1]: ItemInfoController_upvr (copied, readonly)
					[2]: FmItemInfo_upvr (copied, readonly)
					[3]: tbl_9_upvr (readonly)
					[4]: any_GetItemInfoFolder_result1_upvr_4 (readonly)
					[5]: FmSkillInfo_upvr (copied, readonly)
				]]
				ItemInfoController_upvr:PopulateNewItemInfoFrame(FmItemInfo_upvr, "Companions", tbl_9_upvr, any_GetItemInfoFolder_result1_upvr_4)
				FmSkillInfo_upvr.Visible = false
				FmItemInfo_upvr.Visible = true
			end)
			local var81 = var5_upvw.Data.EventShopPurchases[var30_upvr]
			if var81 then
				var81 = arg2.MaxPurchases
				if var81 then
					if arg2.MaxPurchases > (var5_upvw.Data.EventShopPurchases[var30_upvr][arg2.Name] or 0) then
						var81 = false
					else
						var81 = true
					end
				end
			end
			if var81 then
				arg1_9.TextLabel.Text = ""
				arg1_9.BfPurchase.FmExpand.ImageLabel.Visible = false
				arg1_9.BfPurchase.FmExpand.TextLabel.Text = "Purchased"
				arg1_9.BfPurchase.FmExpand.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				return "Owned"
			end
		end;
		Companions = function(arg1_10, arg2) -- Line 267
			--[[ Upvalues[6]:
				[1]: ReplicaFunctions_upvr (copied, readonly)
				[2]: tbl_7_upvw (copied, read and write)
				[3]: UIManagement_upvr (copied, readonly)
				[4]: ItemInfoController_upvr (copied, readonly)
				[5]: FmItemInfo_upvr (copied, readonly)
				[6]: FmSkillInfo_upvr (copied, readonly)
			]]
			local any_GetItemInfoFolder_result1_upvr_10 = ReplicaFunctions_upvr.GetItemInfoFolder(arg2.Name, tbl_7_upvw)
			local tbl_5_upvr = {
				Name = arg2.Name;
				Class = any_GetItemInfoFolder_result1_upvr_10.Class;
				Variant = "Base";
			}
			arg1_10.FmTopbar.TextLabel.Text = arg2.Name
			UIManagement_upvr:SetEquipmentFrame(arg1_10.FmItem, {
				Name = arg2.Name;
				Leveling = {
					Level = arg2.Level;
				};
			})
			arg1_10.FmItem.IlItem.TlLevel.Text = `x{arg2.Amount}`
			arg1_10.FmItem.IlItem.TlLevel.Visible = true
			arg1_10.BfPurchase.FmExpand.TextLabel.Text = `x{arg2.Cost}`
			arg1_10.FmItem.TextButton.MouseButton1Click:Connect(function() -- Line 286
				--[[ Upvalues[5]:
					[1]: ItemInfoController_upvr (copied, readonly)
					[2]: FmItemInfo_upvr (copied, readonly)
					[3]: tbl_5_upvr (readonly)
					[4]: any_GetItemInfoFolder_result1_upvr_10 (readonly)
					[5]: FmSkillInfo_upvr (copied, readonly)
				]]
				ItemInfoController_upvr:PopulateNewItemInfoFrame(FmItemInfo_upvr, "Companions", tbl_5_upvr, any_GetItemInfoFolder_result1_upvr_10)
				FmSkillInfo_upvr.Visible = false
				FmItemInfo_upvr.Visible = true
			end)
		end;
		Mounts = function(arg1_11, arg2) -- Line 294
			--[[ Upvalues[8]:
				[1]: ReplicaFunctions_upvr (copied, readonly)
				[2]: tbl_7_upvw (copied, read and write)
				[3]: UIManagement_upvr (copied, readonly)
				[4]: Item










                -- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-15 22:27:20
-- Luau version 6, Types version 3
-- Time taken: 0.030112 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicaController = require(ReplicatedStorage.Packages.ReplicaController)
local Parent_upvr = script.Parent
local tbl_upvw = {}
local var5_upvw
ReplicaController.ReplicaOfClassCreated("Info", function(arg1) -- Line 34
	--[[ Upvalues[1]:
		[1]: tbl_upvw (read and write)
	]]
	tbl_upvw = arg1.Data
end)
ReplicaController.ReplicaOfClassCreated("PlayerData", function(arg1) -- Line 38
	--[[ Upvalues[2]:
		[1]: var5_upvw (read and write)
		[2]: Parent_upvr (readonly)
	]]
	var5_upvw = arg1.Children[1]
	local function _() -- Line 43, Named "SetBountyBoons"
		--[[ Upvalues[2]:
			[1]: var5_upvw (copied, read and write)
			[2]: Parent_upvr (copied, readonly)
		]]
		Parent_upvr.Container.FmExpand.TextLabel.Text = var5_upvw.Data.Inventory.Materials["Bounty Boon"] or 0
	end
	Parent_upvr.Container.FmExpand.TextLabel.Text = var5_upvw.Data.Inventory.Materials["Bounty Boon"] or 0
	var5_upvw:ListenToNewKey({"Inventory", "Materials"}, function(arg1_2, arg2) -- Line 55
		--[[ Upvalues[2]:
			[1]: var5_upvw (copied, read and write)
			[2]: Parent_upvr (copied, readonly)
		]]
		if arg2 == "Bounty Boon" then
			Parent_upvr.Container.FmExpand.TextLabel.Text = var5_upvw.Data.Inventory.Materials["Bounty Boon"] or 0
			var5_upvw:ListenToChange({"Inventory", "Materials", "Bounty Boon"}, function() -- Line 59
				--[[ Upvalues[2]:
					[1]: var5_upvw (copied, read and write)
					[2]: Parent_upvr (copied, readonly)
				]]
				Parent_upvr.Container.FmExpand.TextLabel.Text = var5_upvw.Data.Inventory.Materials["Bounty Boon"] or 0
			end)
		end
	end)
	if var5_upvw.Data.Inventory.Materials["Bounty Boon"] then
		var5_upvw:ListenToChange({"Inventory", "Materials", "Bounty Boon"}, function() -- Line 66
			--[[ Upvalues[2]:
				[1]: var5_upvw (copied, read and write)
				[2]: Parent_upvr (copied, readonly)
			]]
			Parent_upvr.Container.FmExpand.TextLabel.Text = var5_upvw.Data.Inventory.Materials["Bounty Boon"] or 0
		end)
	end
end)
local Skills_upvr = require(ReplicatedStorage.Skills)
local UIManagement_upvr = require(ReplicatedStorage.Modules.UIManagement)
local FmSkillInfo_upvr = Parent_upvr.Container.FmSkillInfo
local StatColors_upvr = require(ReplicatedStorage.Modules.StatColors)
local UIListLayout_upvr = Parent_upvr.Container.SfScroller.UIListLayout
local ReplicaFunctions_upvr = require(ReplicatedStorage.Modules.ReplicaFunctions)
local ItemInfoController_upvr = require(ReplicatedStorage.Modules.ItemInfoController)
local FmItemInfo_upvr = Parent_upvr.Container.FmItemInfo
local Abilities_upvr = require(ReplicatedStorage.Abilities)
local Notification_upvr = ReplicatedStorage.PlayerEvents.Notification
local var25_upvw = "Exclusive"
local FrameVisibility_upvr = require(ReplicatedStorage.Modules.FrameVisibility)
ReplicaController.ReplicaOfClassCreated("BountyShop", function(arg1) -- Line 72
	--[[ Upvalues[15]:
		[1]: var5_upvw (read and write)
		[2]: Skills_upvr (readonly)
		[3]: UIManagement_upvr (readonly)
		[4]: FmSkillInfo_upvr (readonly)
		[5]: StatColors_upvr (readonly)
		[6]: Parent_upvr (readonly)
		[7]: UIListLayout_upvr (readonly)
		[8]: ReplicaFunctions_upvr (readonly)
		[9]: tbl_upvw (read and write)
		[10]: ItemInfoController_upvr (readonly)
		[11]: FmItemInfo_upvr (readonly)
		[12]: Abilities_upvr (readonly)
		[13]: Notification_upvr (readonly)
		[14]: var25_upvw (read and write)
		[15]: FrameVisibility_upvr (readonly)
	]]
	repeat
		task.wait()
	until var5_upvw
	local function PopulateSkillInfo_upvr(arg1_3) -- Line 77, Named "PopulateSkillInfo"
		--[[ Upvalues[4]:
			[1]: Skills_upvr (copied, readonly)
			[2]: UIManagement_upvr (copied, readonly)
			[3]: FmSkillInfo_upvr (copied, readonly)
			[4]: StatColors_upvr (copied, readonly)
		]]
		local Info = Skills_upvr[arg1_3].Info
		UIManagement_upvr:ClearFrameOfClass(FmSkillInfo_upvr.FmStatRequirements, "TextLabel")
		FmSkillInfo_upvr.FmName.TlName.Text = arg1_3
		FmSkillInfo_upvr.FmItem.IlItem.Image = Info.Image
		FmSkillInfo_upvr.TlMana.Text = `Mana {Info.Stats.Mana}`
		FmSkillInfo_upvr.TlCooldown.Text = `Cooldown {Info.Stats.Cooldown}`
		FmSkillInfo_upvr.TlDescription.Text = Info.Description
		local Requirements = Info.Requirements
		if Requirements then
			Requirements = Info.Requirements.Stats
		end
		if Requirements then
			for i, v in Requirements do
				local clone = script.TlStatRequirement:Clone()
				clone.Text = `<font color="#{StatColors_upvr[i]:ToHex()}">{i}</font> {v}`
				clone.Parent = FmSkillInfo_upvr.FmStatRequirements
			end
		end
		FmSkillInfo_upvr.Visible = true
	end
	local function _() -- Line 103, Named "SetCanvasSize"
		--[[ Upvalues[2]:
			[1]: Parent_upvr (copied, readonly)
			[2]: UIListLayout_upvr (copied, readonly)
		]]
		Parent_upvr.Container.SfScroller.CanvasSize = UDim2.new(0, UIListLayout_upvr.AbsoluteContentSize.X + 10, 0, 0)
	end
	local tbl_3_upvr = {
		BleeterBits = function(arg1_4, arg2) -- Line 108
			arg1_4.FmTopbar.TextLabel.Text = "Bleeter Bits"
			arg1_4.FmItem.IlItem.Image = "rbxassetid://17355459666"
			arg1_4.FmItem.IlItem.TlLevel.Text = `x{arg2.Amount}`
			arg1_4.BfPurchase.FmExpand.TextLabel.Text = `x{arg2.Cost}`
		end;
		Coins = function(arg1_5, arg2) -- Line 115
			arg1_5.FmTopbar.TextLabel.Text = "Coins"
			arg1_5.FmItem.IlItem.Image = "rbxassetid://94812535407459"
			arg1_5.FmItem.IlItem.TlLevel.Text = `x{arg2.Amount}`
			arg1_5.BfPurchase.FmExpand.TextLabel.Text = `x{arg2.Cost}`
		end;
		Weapons = function(arg1_6, arg2) -- Line 122
			--[[ Upvalues[6]:
				[1]: ReplicaFunctions_upvr (copied, readonly)
				[2]: tbl_upvw (copied, read and write)
				[3]: UIManagement_upvr (copied, readonly)
				[4]: ItemInfoController_upvr (copied, readonly)
				[5]: FmItemInfo_upvr (copied, readonly)
				[6]: FmSkillInfo_upvr (copied, readonly)
			]]
			local any_GetItemInfoFolder_result1_upvr_3 = ReplicaFunctions_upvr.GetItemInfoFolder(arg2.Name, tbl_upvw)
			local tbl_5_upvr = {
				Name = arg2.Name;
				Class = any_GetItemInfoFolder_result1_upvr_3.Class;
				Leveling = {
					Level = arg2.Level;
				};
			}
			arg1_6.FmTopbar.TextLabel.Text = arg2.Name
			UIManagement_upvr:SetEquipmentFrame(arg1_6.FmItem, {
				Name = arg2.Name;
				Leveling = {
					Level = arg2.Level;
				};
			})
			arg1_6.BfPurchase.FmExpand.TextLabel.Text = `x{arg2.Cost}`
			arg1_6.FmItem.TextButton.MouseButton1Click:Connect(function() -- Line 141
				--[[ Upvalues[5]:
					[1]: ItemInfoController_upvr (copied, readonly)
					[2]: FmItemInfo_upvr (copied, readonly)
					[3]: tbl_5_upvr (readonly)
					[4]: any_GetItemInfoFolder_result1_upvr_3 (readonly)
					[5]: FmSkillInfo_upvr (copied, readonly)
				]]
				ItemInfoController_upvr:PopulateNewItemInfoFrame(FmItemInfo_upvr, "Weapons", tbl_5_upvr, any_GetItemInfoFolder_result1_upvr_3)
				FmSkillInfo_upvr.Visible = false
				FmItemInfo_upvr.Visible = true
			end)
		end;
		Armor = function(arg1_7, arg2) -- Line 149
			--[[ Upvalues[6]:
				[1]: ReplicaFunctions_upvr (copied, readonly)
				[2]: tbl_upvw (copied, read and write)
				[3]: UIManagement_upvr (copied, readonly)
				[4]: ItemInfoController_upvr (copied, readonly)
				[5]: FmItemInfo_upvr (copied, readonly)
				[6]: FmSkillInfo_upvr (copied, readonly)
			]]
			local any_GetItemInfoFolder_result1_upvr = ReplicaFunctions_upvr.GetItemInfoFolder(arg2.Name, tbl_upvw)
			local tbl_2_upvr = {
				Name = arg2.Name;
				Class = any_GetItemInfoFolder_result1_upvr.Class;
				Leveling = {
					Level = arg2.Level;
				};
			}
			arg1_7.FmTopbar.TextLabel.Text = arg2.Name
			UIManagement_upvr:SetEquipmentFrame(arg1_7.FmItem, {
				Name = arg2.Name;
				Leveling = {
					Level = arg2.Level;
				};
			})
			arg1_7.BfPurchase.FmExpand.TextLabel.Text = `x{arg2.Cost}`
			arg1_7.FmItem.TextButton.MouseButton1Click:Connect(function() -- Line 168
				--[[ Upvalues[5]:
					[1]: ItemInfoController_upvr (copied, readonly)
					[2]: FmItemInfo_upvr (copied, readonly)
					[3]: tbl_2_upvr (readonly)
					[4]: any_GetItemInfoFolder_result1_upvr (readonly)
					[5]: FmSkillInfo_upvr (copied, readonly)
				]]
				ItemInfoController_upvr:PopulateNewItemInfoFrame(FmItemInfo_upvr, "Weapons", tbl_2_upvr, any_GetItemInfoFolder_result1_upvr)
				FmSkillInfo_upvr.Visible = false
				FmItemInfo_upvr.Visible = true
			end)
		end;
		Materials = function(arg1_8, arg2) -- Line 176
			--[[ Upvalues[6]:
				[1]: ReplicaFunctions_upvr (copied, readonly)
				[2]: tbl_upvw (copied, read and write)
				[3]: UIManagement_upvr (copied, readonly)
				[4]: ItemInfoController_upvr (copied, readonly)
				[5]: FmItemInfo_upvr (copied, readonly)
				[6]: FmSkillInfo_upvr (copied, readonly)
			]]
			arg1_8.FmTopbar.TextLabel.Text = arg2.Name
			UIManagement_upvr:SetEquipmentFrame(arg1_8.FmItem, {
				Name = arg2.Name;
			})
			arg1_8.FmItem.IlItem.TlLevel.Text = `x{arg2.Amount}`
			arg1_8.FmItem.IlItem.TlLevel.Visible = true
			arg1_8.BfPurchase.FmExpand.TextLabel.Text = `x{arg2.Cost}`
			local any_GetItemInfoFolder_result1_upvr_2 = ReplicaFunctions_upvr.GetItemInfoFolder(arg2.Name, tbl_upvw)
			arg1_8.FmItem.TextButton.MouseButton1Click:Connect(function() -- Line 187
				--[[ Upvalues[5]:
					[1]: ItemInfoController_upvr (copied, readonly)
					[2]: FmItemInfo_upvr (copied, readonly)
					[3]: arg2 (readonly)
					[4]: any_GetItemInfoFolder_result1_upvr_2 (readonly)
					[5]: FmSkillInfo_upvr (copied, readonly)
				]]
				ItemInfoController_upvr:PopulateNewMaterialInfoFrame(FmItemInfo_upvr, arg2.Name, arg2.Amount, any_GetItemInfoFolder_result1_upvr_2)
				FmSkillInfo_upvr.Visible = false
				FmItemInfo_upvr.Visible = true
			end)
		end;
		Skills = function(arg1_9, arg2) -- Line 195
			--[[ Upvalues[4]:
				[1]: Skills_upvr (copied, readonly)
				[2]: FmItemInfo_upvr (copied, readonly)
				[3]: PopulateSkillInfo_upvr (readonly)
				[4]: var5_upvw (copied, read and write)
			]]
			arg1_9.FmTopbar.TextLabel.Text = arg2.Name
			arg1_9.FmItem.IlItem.Image = Skills_upvr[arg2.Name].Info.Image
			arg1_9.FmItem.IlItem.TlLevel.Text = ""
			arg1_9.BfPurchase.FmExpand.TextLabel.Text = `x{arg2.Cost}`
			arg1_9.FmItem.TextButton.MouseButton1Click:Connect(function() -- Line 201
				--[[ Upvalues[3]:
					[1]: FmItemInfo_upvr (copied, readonly)
					[2]: PopulateSkillInfo_upvr (copied, readonly)
					[3]: arg2 (readonly)
				]]
				FmItemInfo_upvr.Visible = false
				PopulateSkillInfo_upvr(arg2.Name)
			end)
			if var5_upvw.Data.BountyShopPurchases.Skills[arg2.Name] then
				arg1_9.TextLabel.Text = ""
				arg1_9.BfPurchase.FmExpand.ImageLabel.Visible = false
				arg1_9.BfPurchase.FmExpand.TextLabel.Text = "Owned"
				arg1_9.BfPurchase.FmExpand.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				return "Owned"
			end
		end;
		Abilities = function(arg1_10, arg2) -- Line 217
			--[[ Upvalues[2]:
				[1]: Abilities_upvr (copied, readonly)
				[2]: var5_upvw (copied, read and write)
			]]
			arg1_10.FmTopbar.TextLabel.Text = arg2.Name
			arg1_10.FmItem.IlItem.Image = Abilities_upvr[arg2.Name].Info.Image
			arg1_10.FmItem.IlItem.TlLevel.Text = ""
			arg1_10.BfPurchase.FmExpand.TextLabel.Text = `x{arg2.Cost}`
			if var5_upvw.Data.BountyShopPurchases.Abilities[arg2.Name] then
				arg1_10.TextLabel.Text = ""
				arg1_10.BfPurchase.FmExpand.ImageLabel.Visible = false
				arg1_10.BfPurchase.FmExpand.TextLabel.Text = "Owned"
				arg1_10.BfPurchase.FmExpand.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				return "Owned"
			end
		end;
	}
	local function CreatePurchasable_upvr(arg1_11, arg2, arg3) -- Line 234, Named "CreatePurchasable"
		--[[ Upvalues[6]:
			[1]: tbl_3_upvr (readonly)
			[2]: Parent_upvr (copied, readonly)
			[3]: var5_upvw (copied, read and write)
			[4]: Notification_upvr (copied, readonly)
			[5]: arg1 (readonly)
			[6]: var25_upvw (copied, read and write)
		]]
		local clone_3 = script.FmPurchasable:Clone()
		local var66 = tbl_3_upvr[arg1_11]
		if var66 then
			clone_3.Parent = Parent_upvr.Container.SfScroller
			if var66(clone_3, arg3) ~= "Owned" then
				clone_3.BfPurchase.TextButton.MouseButton1Click:Connect(function() -- Line 245
					--[[ Upvalues[7]:
						[1]: var5_upvw (copied, read and write)
						[2]: arg3 (readonly)
						[3]: Notification_upvr (copied, readonly)
						[4]: arg1 (copied, readonly)
						[5]: arg1_11 (readonly)
						[6]: arg2 (readonly)
						[7]: var25_upvw (copied, read and write)
					]]
					if (var5_upvw.Data.Inventory.Materials["Bounty Boon"] or 0) < arg3.Cost then
						Notification_upvr:Fire("NoMaterial", {
							Material = "Bounty Boon";
						})
					else
						local tbl_4 = {}
						tbl_4.Category = arg1_11
						tbl_4.Index = arg2
						tbl_4.ShopType = var25_upvw
						arg1:FireServer("Purchase", tbl_4)
					end
				end)
			end
		end
	end
	local function SetView_upvr() -- Line 266, Named "SetView"
		--[[ Upvalues[7]:
			[1]: FmItemInfo_upvr (copied, readonly)
			[2]: FmSkillInfo_upvr (copied, readonly)
			[3]: UIManagement_upvr (copied, readonly)
			[4]: Parent_upvr (copied, readonly)
			[5]: var25_upvw (copied, read and write)
			[6]: arg1 (readonly)
			[7]: CreatePurchasable_upvr (readonly)
		]]
		FmItemInfo_upvr.Visible = false
		FmSkillInfo_upvr.Visible = false
		UIManagement_upvr:ClearFrameOfClass(Parent_upvr.Container.SfScroller, "Frame")
		if var25_upvw == "Exclusive" then
			for i_2, v_2 in arg1.Data[var25_upvw] do
				for i_3, v_3 in v_2 do
					CreatePurchasable_upvr(i_2, i_3, v_3)
				end
			end
		elseif var25_upvw == "Weekly" then
			for i_6, v_6 in arg1.Data[var25_upvw] do
				CreatePurchasable_upvr(i_6, nil, v_6)
			end
		end
	end
	SetView_upvr()
	Parent_upvr.Container.SfScroller.CanvasSize = UDim2.new(0, UIListLayout_upvr.AbsoluteContentSize.X + 10, 0, 0)
	for _, v_4_upvr in Parent_upvr.Container.FmFilter:GetChildren(), nil do
		local View_upvr = v_4_upvr:GetAttribute("View")
		if View_upvr then
			v_4_upvr.TextButton.MouseButton1Click:Connect(function() -- Line 294
				--[[ Upvalues[5]:
					[1]: var25_upvw (copied, read and write)
					[2]: View_upvr (readonly)
					[3]: SetView_upvr (readonly)
					[4]: Parent_upvr (copied, readonly)
					[5]: v_4_upvr (readonly)
				]]
				var25_upvw = View_upvr
				SetView_upvr()
				for _, v_5 in Parent_upvr.Container.FmFilter:GetChildren(), nil do
					if v_5:GetAttribute("View") then
						v_5.FmShade.Visible = true
					end
				end
				v_4_upvr.FmShade.Visible = false
			end)
		end
	end
	View_upvr = Parent_upvr
	View_upvr.Container.Topbar.BfExit.TextButton.MouseButton1Click:Connect(function() -- Line 311
		--[[ Upvalues[2]:
			[1]: FrameVisibility_upvr (copied, readonly)
			[2]: Parent_upvr (copied, readonly)
		]]
		FrameVisibility_upvr:ManageFrame(Parent_upvr)
	end)
	UIListLayout_upvr:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line 317
		--[[ Upvalues[2]:
			[1]: Parent_upvr (copied, readonly)
			[2]: UIListLayout_upvr (copied, readonly)
		]]
		Parent_upvr.Container.SfScroller.CanvasSize = UDim2.new(0, UIListLayout_upvr.AbsoluteContentSize.X + 10, 0, 0)
	end)
	arg1:ConnectOnClientEvent(function(arg1_12, arg2) -- Line 321
		--[[ Upvalues[1]:
			[1]: SetView_upvr (readonly)
		]]
		if arg1_12 == "Update" then
			SetView_upvr()
		end
	end)
	var5_upvw:ListenToNewKey({"BountyShopPurchases", "Skills"}, function() -- Line 327
		--[[ Upvalues[1]:
			[1]: SetView_upvr (readonly)
		]]
		SetView_upvr()
	end)
	var5_upvw:ListenToNewKey({"BountyShopPurchases", "Abilities"}, function() -- Line 331
		--[[ Upvalues[1]:
			[1]: SetView_upvr (readonly)
		]]
		SetView_upvr()
	end)
	FmItemInfo_upvr.BfExit.TextButton.MouseButton1Click:Connect(function() -- Line 335
		--[[ Upvalues[1]:
			[1]: FmItemInfo_upvr (copied, readonly)
		]]
		FmItemInfo_upvr.Visible = false
	end)
	FmSkillInfo_upvr.BfExit.TextButton.MouseButton1Click:Connect(function() -- Line 339
		--[[ Upvalues[1]:
			[1]: FmSkillInfo_upvr (copied, readonly)
		]]
		FmSkillInfo_upvr.Visible = false
	end)
end)











MarketplaceIDs

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-15 21:38:30
-- Luau version 6, Types version 3
-- Time taken: 0.001009 seconds

return {
	DeveloperProducts = {
		["New Save"] = 1801719933;
		["Tiny Bleeter Bits"] = 1865700991;
		["Small Bleeter Bits"] = 1865700992;
		["Medium Bleeter Bits"] = 1865700988;
		["Large Bleeter Bits"] = 1865700990;
		["Huge Bleeter Bits"] = 1865700989;
		["Legendary Starter Pack!"] = 3318438945;
		["NIGHT OF FRIGHTS BUNDLE"] = 3444995038;
	};
	Gamepasses = {
		["Private Servers"] = 865602989;
	};
	Badges = {
		["Bleeter Baller"] = 1405796787098668;
		Alpha = 3560776935114782;
		Beta = 1376012736062986;
	};
}


-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-15 21:44:33
-- Luau version 6, Types version 3
-- Time taken: 0.000406 seconds

return {
	ProfileReplica = nil;
}



-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-15 21:44:53
-- Luau version 6, Types version 3
-- Time taken: 0.001216 seconds

local module = {}
local UpgradeCrystalFunctions_upvr = require(game:GetService("ReplicatedStorage").Modules.UpgradeCrystalFunctions)
function module.CalculateSellCoinsPrice(arg1, arg2, arg3, arg4) -- Line 8
	--[[ Upvalues[1]:
		[1]: UpgradeCrystalFunctions_upvr (readonly)
	]]
	local any_CalculateUpgradeCost_result1 = UpgradeCrystalFunctions_upvr:CalculateUpgradeCost(arg2, arg3, arg4)
	if any_CalculateUpgradeCost_result1 then
		return math.clamp(math.floor(any_CalculateUpgradeCost_result1 * 0.15), 1, math.huge)
	end
end
return module



-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-15 21:45:58
-- Luau version 6, Types version 3
-- Time taken: 0.000847 seconds

return {
	ArmorRating = "Armor Rating";
	CriticalDamage = "Critical Damage";
	CriticalRate = "Critical Rate";
	GuardPower = "Guard Power";
	Health = "Health";
	MagicalPower = "Magical Power";
	MagicalResistance = "Magical Resist";
	Mana = "Mana";
	PhysicalPower = "Physical Power";
	PhysicalResistance = "Phys Resist";
	WalkSpeed = "Walk Speed";
}



-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-15 21:46:22
-- Luau version 6, Types version 3
-- Time taken: 0.002414 seconds

local module_upvr = {
	GetStorageSize = function(arg1, arg2, arg3) -- Line 3, Named "GetStorageSize"
		local STORAGE = arg3._GameData.STORAGE
		return STORAGE.BaseSize + STORAGE.UpgradeSizeIncrement * (arg2.Data.Storage.UpgradeIncrement - 1)
	end;
}
function module_upvr.StorageHasSpace(arg1, arg2, arg3) -- Line 11
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var3
	if #arg2.Data.Storage.Items >= module_upvr:GetStorageSize(arg2, arg3) then
		var3 = false
	else
		var3 = true
	end
	return var3
end
return module_upvr



-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-15 21:48:37
-- Luau version 6, Types version 3
-- Time taken: 0.004263 seconds

local module_2 = {
	Default = nil;
}
local Players = game:GetService("Players")
local tbl_upvr = {}
local tbl_upvr_2 = {}
local tbl_upvr_3 = {}
tbl_upvr_3.__index = tbl_upvr_3
function tbl_upvr_3.CheckRate(arg1, arg2) -- Line 59
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local _sources = arg1._sources
	local os_clock_result1 = os.clock()
	local var13 = _sources[arg2]
	if var13 ~= nil then
		local maximum = math.max(os_clock_result1, var13 + arg1._rate_period)
		if maximum - os_clock_result1 < 1 then
			_sources[arg2] = maximum
			return true
		end
		return false
	end
	if typeof(arg2) == "Instance" and arg2:IsA("Player") and tbl_upvr[arg2] == nil then
		return false
	end
	_sources[arg2] = os_clock_result1 + arg1._rate_period
	return true
end
function tbl_upvr_3.CleanSource(arg1, arg2) -- Line 83
	arg1._sources[arg2] = nil
end
function tbl_upvr_3.Cleanup(arg1) -- Line 87
	arg1._sources = {}
end
function tbl_upvr_3.Destroy(arg1) -- Line 91
	--[[ Upvalues[1]:
		[1]: tbl_upvr_2 (readonly)
	]]
	tbl_upvr_2[arg1] = nil
end
function module_2.NewRateLimiter(arg1) -- Line 96
	--[[ Upvalues[2]:
		[1]: tbl_upvr_3 (readonly)
		[2]: tbl_upvr_2 (readonly)
	]]
	if arg1 <= 0 then
		error("[RateLimiter]: Invalid rate")
	end
	local module = {
		_sources = {};
		_rate_period = 1 / arg1;
	}
	setmetatable(module, tbl_upvr_3)
	tbl_upvr_2[module] = true
	return module
end
for _, v in ipairs(Players:GetPlayers()) do
	tbl_upvr[v] = true
end
module_2.Default = module_2.NewRateLimiter(({
	DefaultRateLimiterRate = 120;
}).DefaultRateLimiterRate)
Players.PlayerAdded:Connect(function(arg1) -- Line 122
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	tbl_upvr[arg1] = true
end)
Players.PlayerRemoving:Connect(function(arg1) -- Line 126
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: tbl_upvr_2 (readonly)
	]]
	tbl_upvr[arg1] = nil
	for i_2 in pairs(tbl_upvr_2) do
		i_2._sources[arg1] = nil
	end
end)
return module_2



-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-15 21:49:12
-- Luau version 6, Types version 3
-- Time taken: 0.002673 seconds

local module = {}
local module_upvr = {'K', 'M', 'B', 'T', "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dd", "Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod", "Vg", "Uvg", "Dvg", "Tvg", "Qavg", "Qivg", "Sxvg", "Spvg", "Ocvg"}
local module_2_upvr = {}
for i = 1, #module_upvr do
	table.insert(module_2_upvr, 1000 ^ i)
end
function module.Abbreviate(arg1, arg2) -- Line 9
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: module_2_upvr (readonly)
	]]
	local absolute = math.abs(arg2)
	if absolute < 1000 then
		return tostring(arg2)
	end
	local minimum = math.min(math.floor(math.log10(absolute) / 3), #module_upvr)
	return (math.floor(absolute / module_2_upvr[minimum] * 10) / 10 * math.sign(arg2))..module_upvr[minimum]
end
return module


-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-15 21:50:14
-- Luau version 6, Types version 3
-- Time taken: 0.008638 seconds

local module = {}
local var2_upvw
local function AcquireRunnerThreadAndCallEventHandler_upvr(arg1, ...) -- Line 60, Named "AcquireRunnerThreadAndCallEventHandler"
	--[[ Upvalues[1]:
		[1]: var2_upvw (read and write)
	]]
	var2_upvw = nil
	arg1(...)
	var2_upvw = var2_upvw
end
local function RunEventHandlerInFreeThread_upvr(...) -- Line 68, Named "RunEventHandlerInFreeThread"
	--[[ Upvalues[1]:
		[1]: AcquireRunnerThreadAndCallEventHandler_upvr (readonly)
	]]
	AcquireRunnerThreadAndCallEventHandler_upvr(...)
	while true do
		AcquireRunnerThreadAndCallEventHandler_upvr(coroutine.yield())
	end
end
local tbl_upvr_2 = {}
local function Disconnect(arg1) -- Line 88
	--[[ Upvalues[2]:
		[1]: var2_upvw (read and write)
		[2]: RunEventHandlerInFreeThread_upvr (readonly)
	]]
	local _listener = arg1._listener
	if _listener ~= nil then
		local _listener_table = arg1._listener_table
		local table_find_result1 = table.find(_listener_table, _listener)
		if table_find_result1 ~= nil then
			table.remove(_listener_table, table_find_result1)
		end
		arg1._listener = nil
	end
	if arg1._disconnect_listener ~= nil then
		if not var2_upvw then
			var2_upvw = coroutine.create(RunEventHandlerInFreeThread_upvr)
		end
		task.spawn(var2_upvw, arg1._disconnect_listener, arg1._disconnect_param)
		arg1._disconnect_listener = nil
	end
end
tbl_upvr_2.Disconnect = Disconnect
function module.NewArrayScriptConnection(arg1, arg2, arg3, arg4) -- Line 107
	--[[ Upvalues[1]:
		[1]: tbl_upvr_2 (readonly)
	]]
	local module_3 = {}
	module_3._listener = arg2
	module_3._listener_table = arg1
	module_3._disconnect_listener = arg3
	module_3._disconnect_param = arg4
	module_3.Disconnect = tbl_upvr_2.Disconnect
	return module_3
end
local tbl_upvr = {}
tbl_upvr.__index = tbl_upvr
function tbl_upvr.Disconnect(arg1) -- Line 132
	--[[ Upvalues[2]:
		[1]: var2_upvw (read and write)
		[2]: RunEventHandlerInFreeThread_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 27 start (CF ANALYSIS FAILED)
	local var9
	if var9 == false then
	else
		var9 = false
		arg1._is_connected = var9
		var9 = arg1._script_signal
		var9._listener_count -= 1
		var9 = arg1._script_signal._head
		if var9 == arg1 then
			var9 = arg1._script_signal
			var9._head = arg1._next
			-- KONSTANTWARNING: GOTO [47] #27
		end
		-- KONSTANTERROR: [0] 1. Error Block 27 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [28] 17. Error Block 19 start (CF ANALYSIS FAILED)
		var9 = arg1._script_signal._head
		while var9 ~= nil and var9._next ~= arg1 do
			var9 = var9._next
		end
		if var9 ~= nil then
			var9._next = arg1._next
		end
		var9 = arg1._disconnect_listener
		if var9 ~= nil then
			var9 = var2_upvw
			if not var9 then
				var9 = coroutine.create(RunEventHandlerInFreeThread_upvr)
				var2_upvw = var9
			end
			var9 = task.spawn
			var9(var2_upvw, arg1._disconnect_listener, arg1._disconnect_param)
			var9 = nil
			arg1._disconnect_listener = var9
		end
		-- KONSTANTERROR: [28] 17. Error Block 19 end (CF ANALYSIS FAILED)
	end
end
local tbl_upvr_3 = {}
tbl_upvr_3.__index = tbl_upvr_3
function tbl_upvr_3.Connect(arg1, arg2, arg3, arg4) -- Line 173
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local module_2 = {}
	module_2._listener = arg2
	module_2._script_signal = arg1
	module_2._disconnect_listener = arg3
	module_2._disconnect_param = arg4
	module_2._next = arg1._head
	module_2._is_connected = true
	setmetatable(module_2, tbl_upvr)
	arg1._head = module_2
	arg1._listener_count += 1
	return module_2
end
function tbl_upvr_3.GetListenerCount(arg1) -- Line 193
	return arg1._listener_count
end
function tbl_upvr_3.Fire(arg1, ...) -- Line 197
	--[[ Upvalues[2]:
		[1]: var2_upvw (read and write)
		[2]: RunEventHandlerInFreeThread_upvr (readonly)
	]]
	local _head_2 = arg1._head
	while _head_2 ~= nil do
		if _head_2._is_connected == true then
			if not var2_upvw then
				var2_upvw = coroutine.create(RunEventHandlerInFreeThread_upvr)
			end
			task.spawn(var2_upvw, _head_2._listener, ...)
		end
	end
end
function tbl_upvr_3.FireUntil(arg1, arg2, ...) -- Line 210
	local _head_3 = arg1._head
	while _head_3 ~= nil do
		if _head_3._is_connected == true then
			_head_3._listener(...)
			if arg2() ~= true then return end
		end
	end
end
function module.NewScriptSignal() -- Line 223
	--[[ Upvalues[1]:
		[1]: tbl_upvr_3 (readonly)
	]]
	return {
		_head = nil;
		_listener_count = 0;
		Connect = tbl_upvr_3.Connect;
		GetListenerCount = tbl_upvr_3.GetListenerCount;
		Fire = tbl_upvr_3.Fire;
		FireUntil = tbl_upvr_3.FireUntil;
	}
end
return module



-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-15 21:51:03
-- Luau version 6, Types version 3
-- Time taken: 0.008728 seconds

local module = {}
local var2_upvw
local function AcquireRunnerThreadAndCallEventHandler_upvr(arg1, ...) -- Line 41, Named "AcquireRunnerThreadAndCallEventHandler"
	--[[ Upvalues[1]:
		[1]: var2_upvw (read and write)
	]]
	var2_upvw = nil
	arg1(...)
	var2_upvw = var2_upvw
end
local function RunEventHandlerInFreeThread_upvr(...) -- Line 49, Named "RunEventHandlerInFreeThread"
	--[[ Upvalues[1]:
		[1]: AcquireRunnerThreadAndCallEventHandler_upvr (readonly)
	]]
	AcquireRunnerThreadAndCallEventHandler_upvr(...)
	while true do
		AcquireRunnerThreadAndCallEventHandler_upvr(coroutine.yield())
	end
end
local function CleanupTask_upvr(arg1, ...) -- Line 56, Named "CleanupTask"
	if type(arg1) == "function" then
		arg1(...)
	else
		if typeof(arg1) == "RBXScriptConnection" then
			arg1:Disconnect()
			return
		end
		if typeof(arg1) == "Instance" then
			arg1:Destroy()
			return
		end
		if type(arg1) == "table" then
			if type(arg1.Destroy) == "function" then
				arg1:Destroy()
				return
			end
			if type(arg1.Disconnect) == "function" then
				arg1:Disconnect()
			end
		end
	end
end
local function PerformCleanupTask_upvr(...) -- Line 72, Named "PerformCleanupTask"
	--[[ Upvalues[3]:
		[1]: var2_upvw (read and write)
		[2]: RunEventHandlerInFreeThread_upvr (readonly)
		[3]: CleanupTask_upvr (readonly)
	]]
	if not var2_upvw then
		var2_upvw = coroutine.create(RunEventHandlerInFreeThread_upvr)
	end
	task.spawn(var2_upvw, CleanupTask_upvr, ...)
end
local tbl_upvr = {}
tbl_upvr.__index = tbl_upvr
function tbl_upvr.AddCleanupTask(arg1, arg2) -- Line 89
	--[[ Upvalues[1]:
		[1]: PerformCleanupTask_upvr (readonly)
	]]
	if arg1._is_cleaned == true then
		PerformCleanupTask_upvr(arg2)
		return function() -- Line 92
		end
	end
	if type(arg2) == "function" then
		table.insert(arg1._cleanup_tasks, arg2)
	elseif typeof(arg2) == "RBXScriptConnection" then
		table.insert(arg1._cleanup_tasks, arg2)
	elseif typeof(arg2) == "Instance" then
		table.insert(arg1._cleanup_tasks, arg2)
	elseif type(arg2) == "table" then
		if type(arg2.Destroy) == "function" then
			table.insert(arg1._cleanup_tasks, arg2)
		elseif type(arg2.Disconnect) == "function" then
			table.insert(arg1._cleanup_tasks, arg2)
		else
			error("[MadworkMaid]: Received object table as cleanup task, but couldn't detect a :Destroy() method")
		end
	else
		error("[MadworkMaid]: Cleanup task of type \""..typeof(arg2).."\" not supported")
	end
	return function(...) -- Line 110
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
			[3]: PerformCleanupTask_upvr (copied, readonly)
		]]
		arg1:RemoveCleanupTask(arg2)
		PerformCleanupTask_upvr(arg2, ...)
	end
end
function tbl_upvr.RemoveCleanupTask(arg1, arg2) -- Line 116
	local _cleanup_tasks = arg1._cleanup_tasks
	local table_find_result1 = table.find(_cleanup_tasks, arg2)
	if table_find_result1 ~= nil then
		table.remove(_cleanup_tasks, table_find_result1)
	end
end
function tbl_upvr.CleanupOfOne(arg1, arg2, ...) -- Line 124
	--[[ Upvalues[1]:
		[1]: PerformCleanupTask_upvr (readonly)
	]]
	arg1:RemoveCleanupTask(arg2)
	PerformCleanupTask_upvr(arg2, ...)
end
function tbl_upvr.Cleanup(arg1, ...) -- Line 129
	--[[ Upvalues[1]:
		[1]: PerformCleanupTask_upvr (readonly)
	]]
	for _, v in ipairs(arg1._cleanup_tasks) do
		PerformCleanupTask_upvr(v, ...)
	end
	arg1._cleanup_tasks = {}
	arg1._is_cleaned = true
end
function module.NewMaid() -- Line 139
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local module_2 = {
		_cleanup_tasks = {};
		_is_cleaned = false;
	}
	setmetatable(module_2, tbl_upvr)
	return module_2
end
module.Cleanup = PerformCleanupTask_upvr
return module



-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-15 21:52:28
-- Luau version 6, Types version 3
-- Time taken: 0.113639 seconds

local tbl_12_upvr = {
	RequestDataRepeat = 10;
	SetterError = "[ReplicaController]: Replica setters can only be called inside write functions";
}
local RunService_upvr = game:GetService("RunService")
local function WaitForDescendant_upvr(arg1, arg2, arg3) -- Line 127, Named "WaitForDescendant"
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	local SOME_upvw = arg1:FindFirstChild(arg2, true)
	if SOME_upvw == nil then
		local os_clock_result1 = os.clock()
		while SOME_upvw == nil do
			if os_clock_result1 ~= nil and 1 < os.clock() - os_clock_result1 and (RunService_upvr:IsServer() == true or game:IsLoaded() == true) then
				warn('['..script.Name.."]: Missing "..arg3.." \""..arg2.."\" in "..arg1:GetFullName().."; Please check setup documentation")
			end
			task.wait()
		end
		arg1.DescendantAdded:Connect(function(arg1_2) -- Line 132
			--[[ Upvalues[2]:
				[1]: arg2 (readonly)
				[2]: SOME_upvw (read and write)
			]]
			if arg1_2.Name == arg2 then
				SOME_upvw = arg1_2
			end
		end):Disconnect()
		return SOME_upvw
	end
	return SOME_upvw
end
local var6_upvw
if RunService_upvr:IsServer() == true then
	var6_upvw = Instance.new("Folder")
	var6_upvw.Name = "ReplicaRemoteEvents"
	var6_upvw.Parent = game:GetService("ReplicatedStorage")
else
	var6_upvw = WaitForDescendant_upvr(game:GetService("ReplicatedStorage"), "ReplicaRemoteEvents", "folder")
end
local var9_upvw = {
	GetShared = function(arg1, arg2) -- Line 163, Named "GetShared"
		--[[ Upvalues[1]:
			[1]: WaitForDescendant_upvr (readonly)
		]]
		return WaitForDescendant_upvr(game:GetService("ReplicatedStorage"), arg2, "module")
	end;
	GetModule = function(arg1, arg2) -- Line 167, Named "GetModule"
		--[[ Upvalues[1]:
			[1]: WaitForDescendant_upvr (readonly)
		]]
		return WaitForDescendant_upvr(game:GetService("ServerScriptService"), arg2, "module")
	end;
	SetupRemoteEvent = function(arg1) -- Line 170, Named "SetupRemoteEvent"
		--[[ Upvalues[3]:
			[1]: RunService_upvr (readonly)
			[2]: var6_upvw (read and write)
			[3]: WaitForDescendant_upvr (readonly)
		]]
		if RunService_upvr:IsServer() == true then
			local RemoteEvent = Instance.new("RemoteEvent")
			RemoteEvent.Name = arg1
			RemoteEvent.Parent = var6_upvw
			return RemoteEvent
		end
		return WaitForDescendant_upvr(var6_upvw, arg1, "remote event")
	end;
	Shared = {};
}
local module_3 = require(var9_upvw.GetShared("Madwork", "MadworkScriptSignal"))
var9_upvw.NewScriptSignal = module_3.NewScriptSignal
var9_upvw.NewArrayScriptConnection = module_3.NewArrayScriptConnection
RunService_upvr = {}
local var11_upvr = RunService_upvr
WaitForDescendant_upvr = var9_upvw.NewScriptSignal()
var11_upvr.NewReplicaSignal = WaitForDescendant_upvr
WaitForDescendant_upvr = var9_upvw.NewScriptSignal()
var11_upvr.InitialDataReceivedSignal = WaitForDescendant_upvr
WaitForDescendant_upvr = false
var11_upvr.InitialDataReceived = WaitForDescendant_upvr
WaitForDescendant_upvr = {}
var11_upvr._replicas = WaitForDescendant_upvr
WaitForDescendant_upvr = {}
var11_upvr._class_listeners = WaitForDescendant_upvr
WaitForDescendant_upvr = {}
var11_upvr._child_listeners = WaitForDescendant_upvr
WaitForDescendant_upvr = require(var9_upvw.GetShared("Madwork", "MadworkMaid"))
local _replicas_upvr = var11_upvr._replicas
local _class_listeners_upvr = var11_upvr._class_listeners
local _child_listeners_upvr = var11_upvr._child_listeners
local any_SetupRemoteEvent_result1_upvr_2 = var9_upvw.SetupRemoteEvent("Replica_ReplicaRequestData")
local any_SetupRemoteEvent_result1_upvr = var9_upvw.SetupRemoteEvent("Replica_ReplicaSignal")
local var17_upvw = false
local function GetWriteLibFunctionsRecursive_upvr(arg1, arg2, arg3) -- Line 300, Named "GetWriteLibFunctionsRecursive"
	--[[ Upvalues[1]:
		[1]: GetWriteLibFunctionsRecursive_upvr (readonly)
	]]
	for i, v in pairs(arg2) do
		if type(v) == "table" then
			GetWriteLibFunctionsRecursive_upvr(arg1, v, arg3..i..'.')
		elseif type(v) == "function" then
			table.insert(arg1, {arg3..i, v})
		else
			error("[ReplicaController]: Invalid write function value \""..tostring(v).."\" ("..typeof(v).."); name_stack = \""..arg3..'"')
		end
	end
end
local tbl_3_upvr = {}
local function LoadWriteLib_upvr(arg1) -- Line 312, Named "LoadWriteLib"
	--[[ Upvalues[2]:
		[1]: tbl_3_upvr (readonly)
		[2]: GetWriteLibFunctionsRecursive_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var33 = tbl_3_upvr[arg1]
	if var33 ~= nil then
		return var33
	end
	local tbl_7 = {}
	GetWriteLibFunctionsRecursive_upvr(tbl_7, require(arg1), "")
	table.sort(tbl_7, function(arg1_3, arg2) -- Line 323
		local var36
		if arg1_3[1] >= arg2[1] then
			var36 = false
		else
			var36 = true
		end
		return var36
	end)
	local tbl_5 = {}
	for i_2, v_2 in ipairs(tbl_7) do
		({})[i_2] = v_2[2]
		tbl_5[v_2[1]] = i_2
		local var42
	end
	local module = {var42, tbl_5}
	tbl_3_upvr[arg1] = module
	return module
end
local function StringPathToArray_upvr(arg1) -- Line 342, Named "StringPathToArray"
	local module_2 = {}
	if arg1 ~= "" then
		for i_3 in string.gmatch(arg1, "[^%.]+") do
			table.insert(module_2, i_3)
		end
	end
	return module_2
end
local function DestroyReplicaAndDescendantsRecursive_upvr(arg1, arg2) -- Line 352, Named "DestroyReplicaAndDescendantsRecursive"
	--[[ Upvalues[3]:
		[1]: DestroyReplicaAndDescendantsRecursive_upvr (readonly)
		[2]: _replicas_upvr (readonly)
		[3]: _child_listeners_upvr (readonly)
	]]
	for i_4, v_3 in ipairs(arg1.Children) do
		DestroyReplicaAndDescendantsRecursive_upvr(v_3, true)
	end
	local Id = arg1.Id
	_replicas_upvr[Id] = nil
	arg1._maid:Cleanup()
	if arg2 ~= true and arg1.Parent ~= nil then
		local Children_2 = arg1.Parent.Children
		i_4 = Children_2
		v_3 = table.find(Children_2, arg1)
		table.remove(i_4, v_3)
	end
	_child_listeners_upvr[Id] = nil
end
local function CreateTableListenerPathIndex_upvr(arg1, arg2, arg3) -- Line 374, Named "CreateTableListenerPathIndex"
	local var59
	for i_5 = 1, #arg2 do
		local var60 = var59[1][arg2[i_5]]
		if var60 == nil then
			var60 = {{}}
			var59[1][arg2[i_5]] = var60
		end
		var59 = var60
	end
	local var62 = var59[arg3]
	if var62 == nil then
		var62 = {}
		var59[arg3] = var62
	end
	return var62
end
local function CleanTableListenerTable_upvr(arg1) -- Line 395, Named "CleanTableListenerTable"
	local _2 = arg1[2]
	local _1 = arg1[1]
	local tbl_2 = {_1}
	for i_6 = 1, #_2 do
		_1 = _1[1][_2[i_6]]
		table.insert(tbl_2, _1)
	end
	for i_7 = #tbl_2, 2, -1 do
		local var72 = tbl_2[i_7]
		if next(var72[1]) ~= nil then return end
		for i_8 = 2, 6 do
			if var72[i_8] ~= nil and 0 < #var72[i_8] then return end
		end
		tbl_2[i_7 - 1][1][_2[i_7 - 1]] = nil
	end
end
local var73_upvw
local function CreateReplicaBranch_upvr(arg1, arg2) -- Line 420, Named "CreateReplicaBranch"
	--[[ Upvalues[4]:
		[1]: _replicas_upvr (readonly)
		[2]: LoadWriteLib_upvr (readonly)
		[3]: WaitForDescendant_upvr (readonly)
		[4]: var73_upvw (read and write)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local tbl_9 = {}
	local pairs_result1_4, _, pairs_result3_4 = pairs(arg1)
	local var192
	for i_9, v_4 in pairs_result1_4, var192, pairs_result3_4 do
		v_4[6] = tonumber(i_9)
		table.insert(tbl_9, v_4)
	end
	var192 = tbl_9
	table.sort(var192, function(arg1_5, arg2_3) -- Line 428
		local var194
		if arg1_5[6] >= arg2_3[6] then
			var194 = false
		else
			var194 = true
		end
		return var194
	end)
	local tbl_13 = {}
	var192 = arg2
	local var196 = var192
	if not var196 then
		var196 = {}
	end
	for _, v_5 in ipairs(tbl_9) do
		local _6_2 = v_5[6]
		local _4_2 = v_5[4]
		local var202
		local var203 = false
		if _4_2 ~= 0 then
			var202 = _replicas_upvr[_4_2]
			if var202 == nil then
				var203 = true
			end
		end
		local var204
		local var205
		if v_5[5] ~= nil then
			local LoadWriteLib_upvr_result1 = LoadWriteLib_upvr(v_5[5])
			var204 = LoadWriteLib_upvr_result1[1]
			var205 = LoadWriteLib_upvr_result1[2]
		end
		local tbl_4 = {
			Data = v_5[3];
			Id = _6_2;
			Class = v_5[1];
			Tags = v_5[2];
			CustomFunctions = {};
			Parent = var202;
			Children = {};
			_write_lib = var204;
			_write_lib_dictionary = var205;
			_table_listeners = {{}};
			_function_listeners = {};
			_raw_listeners = {};
			_signal_listeners = {};
			_maid = WaitForDescendant_upvr.NewMaid();
		}
		setmetatable(tbl_4, var73_upvw)
		if var202 ~= nil then
			table.insert(var202.Children, tbl_4)
		elseif var203 == true then
			local var209 = tbl_13[_4_2]
			if var209 == nil then
				var209 = {}
				tbl_13[_4_2] = var209
			end
			table.insert(var209, tbl_4)
		end
		_replicas_upvr[_6_2] = tbl_4
		table.insert(var196, tbl_4)
		local var210 = tbl_13[_6_2]
		if var210 ~= nil then
			tbl_13[_6_2] = nil
			for _, v_6 in ipairs(var210) do
				v_6.Parent = tbl_4
				table.insert(tbl_4.Children, v_6)
				local _
			end
		end
	end
	if next(tbl_13) ~= nil then
		for i_12, v_7 in pairs(tbl_13) do
			var203 = tostring(i_12)
			local var221
			for i_13, v_8 in ipairs(v_7) do
				local var222
				if i_13 == 1 then
					var222 = ""
				else
					var222 = ", "
				end
				var221 = var221..var222..v_8:Identify()
			end
			var221 = var221.."}; "
		end
		error(var221)
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return var196
end
local function ReplicaSetValue_upvr(arg1, arg2, arg3) -- Line 515, Named "ReplicaSetValue"
	--[[ Upvalues[1]:
		[1]: _replicas_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var297 = _replicas_upvr[arg1]
	local _table_listeners_5 = var297._table_listeners
	local var299
	for i_14 = 1, #arg2 - 1 do
		var299 = var299[arg2[i_14]]
		if _table_listeners_5 ~= nil then
			local var300 = _table_listeners_5[1][arg2[i_14]]
		end
	end
	local var301 = arg2[#arg2]
	local var302 = var299[var301]
	var299[var301] = arg3
	if var302 ~= arg3 and var300 ~= nil then
		if var302 == nil then
			i_14 = var300[3]
			if i_14 ~= nil then
				i_14 = ipairs(var300[3])
				local ipairs_result1_17, ipairs_result2_8, ipairs_result3_3 = ipairs(var300[3])
				for _, v_9 in ipairs_result1_17, ipairs_result2_8, ipairs_result3_3 do
					v_9(arg3, var301)
					local _
				end
			end
		end
		ipairs_result1_17 = var300[1]
		local var307 = ipairs_result1_17[arg2[#arg2]]
		if var307 ~= nil then
			ipairs_result1_17 = var307[2]
			if ipairs_result1_17 ~= nil then
				ipairs_result1_17 = ipairs(var307[2])
				for _, v_10 in ipairs(var307[2]) do
					v_10(arg3, var302)
					local _
				end
			end
		end
	end
	for _, v_11 in ipairs(var297._raw_listeners) do
		v_11("SetValue", arg2, arg3)
	end
end
local function ReplicaSetValues_upvr(arg1, arg2, arg3) -- Line 554, Named "ReplicaSetValues"
	--[[ Upvalues[1]:
		[1]: _replicas_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var351 = _replicas_upvr[arg1]
	local _table_listeners_4 = var351._table_listeners
	local var353
	for i_18 = 1, #arg2 do
		var353 = var353[arg2[i_18]]
		if _table_listeners_4 ~= nil then
			local var354 = _table_listeners_4[1][arg2[i_18]]
		end
	end
	for i_19, v_12 in pairs(arg3) do
		local var358 = var353[i_19]
		var353[i_19] = v_12
		if var358 ~= v_12 and var354 ~= nil then
			if var358 == nil and var354[3] ~= nil then
				for _, v_13 in ipairs(var354[3]) do
					v_13(v_12, i_19)
				end
			end
			local var362 = var354[1][i_19]
			if var362 ~= nil and var362[2] ~= nil then
				for _, v_14 in ipairs(var362[2]) do
					v_14(v_12, var358)
				end
			end
		end
	end
	for _, v_15 in ipairs(var351._raw_listeners) do
		v_15("SetValues", arg2, arg3)
	end
end
local function ReplicaArrayInsert_upvr(arg1, arg2, arg3) -- Line 595, Named "ReplicaArrayInsert"
	--[[ Upvalues[1]:
		[1]: _replicas_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var389 = _replicas_upvr[arg1]
	local _table_listeners = var389._table_listeners
	local var391
	for i_23 = 1, #arg2 do
		var391 = var391[arg2[i_23]]
		if _table_listeners ~= nil then
			local var392 = _table_listeners[1][arg2[i_23]]
		end
	end
	i_23 = arg3
	table.insert(var391, i_23)
	local len = #var391
	if var392 ~= nil and var392[4] ~= nil then
		i_23 = var392[4]
		local ipairs_result1_27, ipairs_result2_22, ipairs_result3_2 = ipairs(i_23)
		for _, v_16 in ipairs_result1_27, ipairs_result2_22, ipairs_result3_2 do
			v_16(len, arg3)
		end
	end
	ipairs_result2_22 = var389._raw_listeners
	for _, v_17 in ipairs(ipairs_result2_22) do
		v_17("ArrayInsert", arg2, arg3, len)
	end
	return len
end
local function ReplicaArraySet_upvr(arg1, arg2, arg3, arg4) -- Line 624, Named "ReplicaArraySet"
	--[[ Upvalues[1]:
		[1]: _replicas_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var420 = _replicas_upvr[arg1]
	local _table_listeners_2 = var420._table_listeners
	local var422
	for i_26 = 1, #arg2 do
		var422 = var422[arg2[i_26]]
		if _table_listeners_2 ~= nil then
			local var423 = _table_listeners_2[1][arg2[i_26]]
		end
	end
	var422[arg3] = arg4
	if var423 ~= nil and var423[5] ~= nil then
		for _, v_18 in ipairs(var423[5]) do
			v_18(arg3, arg4)
		end
	end
	for _, v_19 in ipairs(var420._raw_listeners) do
		v_19("ArraySet", arg2, arg3, arg4)
	end
end
local function ReplicaArrayRemove_upvr(arg1, arg2, arg3) -- Line 651, Named "ReplicaArrayRemove"
	--[[ Upvalues[1]:
		[1]: _replicas_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var450 = _replicas_upvr[arg1]
	local _table_listeners_6 = var450._table_listeners
	local var452
	for i_29 = 1, #arg2 do
		var452 = var452[arg2[i_29]]
		if _table_listeners_6 ~= nil then
			local var453 = _table_listeners_6[1][arg2[i_29]]
		end
	end
	i_29 = arg3
	local popped = table.remove(var452, i_29)
	if var453 ~= nil and var453[6] ~= nil then
		i_29 = var453[6]
		local ipairs_result1, ipairs_result2_5, ipairs_result3_6 = ipairs(i_29)
		for _, v_20 in ipairs_result1, ipairs_result2_5, ipairs_result3_6 do
			v_20(arg3, popped)
		end
	end
	ipairs_result2_5 = var450._raw_listeners
	for _, v_21 in ipairs(ipairs_result2_5) do
		v_21("ArrayRemove", arg2, arg3, popped)
	end
	return popped
end
var73_upvw = {}
local var461 = var73_upvw
var461.__index = var461
function var461.ListenToChange(arg1, arg2, arg3) -- Line 687
	--[[ Upvalues[4]:
		[1]: StringPathToArray_upvr (readonly)
		[2]: CreateTableListenerPathIndex_upvr (readonly)
		[3]: var9_upvw (read and write)
		[4]: CleanTableListenerTable_upvr (readonly)
	]]
	local var462
	if var462 ~= "function" then
		var462 = error
		var462("[ReplicaController]: Only a function can be set as listener in Replica:ListenToChange()")
	end
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var462 = StringPathToArray_upvr(arg2)
		return var462
	end
	if type(arg2) ~= "string" or not INLINED() then
		var462 = arg2
	end
	if #var462 < 1 then
		error("[ReplicaController]: Passed empty path - a value key must be specified")
	end
	local CreateTableListenerPathIndex_upvr_result1_3 = CreateTableListenerPathIndex_upvr(arg1, var462, 2)
	table.insert(CreateTableListenerPathIndex_upvr_result1_3, arg3)
	return var9_upvw.NewArrayScriptConnection(CreateTableListenerPathIndex_upvr_result1_3, arg3, CleanTableListenerTable_upvr, {arg1._table_listeners, var462})
end
function var461.ListenToNewKey(arg1, arg2, arg3) -- Line 703
	--[[ Upvalues[4]:
		[1]: StringPathToArray_upvr (readonly)
		[2]: CreateTableListenerPathIndex_upvr (readonly)
		[3]: var9_upvw (read and write)
		[4]: CleanTableListenerTable_upvr (readonly)
	]]
	local var465
	if var465 ~= "function" then
		var465 = error
		var465("[ReplicaController]: Only a function can be set as listener in Replica:ListenToNewKey()")
	end
	local function INLINED_2() -- Internal function, doesn't exist in bytecode
		var465 = StringPathToArray_upvr(arg2)
		return var465
	end
	if type(arg2) ~= "string" or not INLINED_2() then
		var465 = arg2
	end
	local CreateTableListe



-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-15 22:11:55
-- Luau version 6, Types version 3
-- Time taken: 0.009924 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicaController = require(ReplicatedStorage.Packages.ReplicaController)
local PlayerEvents = ReplicatedStorage.PlayerEvents
local GlobalMarketEvents = PlayerEvents.GlobalMarketEvents
local tbl_upvw = {}
local var6_upvw
ReplicaController.ReplicaOfClassCreated("Info", function(arg1) -- Line 36
	--[[ Upvalues[1]:
		[1]: tbl_upvw (read and write)
	]]
	tbl_upvw = arg1.Data
end)
ReplicaController.ReplicaOfClassCreated("PlayerData", function(arg1) -- Line 40
	--[[ Upvalues[1]:
		[1]: var6_upvw (read and write)
	]]
	var6_upvw = arg1.Children[1]
end)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
local UIManagement_upvr = require(ReplicatedStorage.Modules.UIManagement)
local Container_upvr = script.Parent.Container
local CharacterController_upvr = require(ReplicatedStorage.Modules.CharacterController)
local FrameVisibility_upvr = require(ReplicatedStorage.Modules.FrameVisibility)
local var15_upvw
local Notification_upvr = PlayerEvents.Notification
local var17_upvw
ReplicaController.ReplicaOfClassCreated("LinkRequest", function(arg1) -- Line 44
	--[[ Upvalues[10]:
		[1]: LocalPlayer_upvr (readonly)
		[2]: UIManagement_upvr (readonly)
		[3]: Container_upvr (readonly)
		[4]: CharacterController_upvr (readonly)
		[5]: FrameVisibility_upvr (readonly)
		[6]: var15_upvw (read and write)
		[7]: var6_upvw (read and write)
		[8]: tbl_upvw (read and write)
		[9]: Notification_upvr (readonly)
		[10]: var17_upvw (read and write)
	]]
	local var18_upvr
	if arg1.Tags.Participants.Inviter ~= LocalPlayer_upvr then
		var18_upvr = arg1.Tags.Participants.Inviter
	else
		var18_upvr = arg1.Tags.Participants.Recipient
	end
	UIManagement_upvr:SetHeadshotImageLabel(Container_upvr.PlayerImageFrame.ImageLabel, var18_upvr.UserId)
	Container_upvr.DisplayName.TextColor3 = Color3.fromRGB(255, 255, 255)
	Container_upvr.DisplayName.Text = var18_upvr.DisplayName
	Container_upvr.Username.Text = `@{var18_upvr.Name}`
	Container_upvr.ConfirmBtnFrame.TextLabel.Text = "Confirm"
	if not Container_upvr.Parent.Visible and CharacterController_upvr:OpenWorld() then
		FrameVisibility_upvr:ManageFrame(Container_upvr.Parent)
	end
	CharacterController_upvr:SetState("LinkRequest", true)
	arg1:ListenToChange({LocalPlayer_upvr.Name, "Confirmed"}, function() -- Line 70
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: LocalPlayer_upvr (copied, readonly)
			[3]: Container_upvr (copied, readonly)
		]]
		local ConfirmBtnFrame = Container_upvr.ConfirmBtnFrame
		if arg1.Data[LocalPlayer_upvr.Name].Confirmed then
			ConfirmBtnFrame = "Confirmed"
		else
			ConfirmBtnFrame = "Confirm"
		end
		ConfirmBtnFrame.TextLabel.Text = ConfirmBtnFrame
	end)
	arg1:ListenToChange({var18_upvr.Name, "Confirmed"}, function() -- Line 78
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: var18_upvr (readonly)
			[3]: Container_upvr (copied, readonly)
		]]
		local var24 = Container_upvr
		if arg1.Data[var18_upvr.Name].Confirmed then
			var24 = Color3.fromRGB(0, 255, 0)
		else
			var24 = Color3.fromRGB(255, 255, 255)
		end
		var24.DisplayName.TextColor3 = var24
	end)
	var15_upvw = Container_upvr.ConfirmBtnFrame.TextButton.MouseButton1Click:Connect(function() -- Line 84
		--[[ Upvalues[4]:
			[1]: var6_upvw (copied, read and write)
			[2]: tbl_upvw (copied, read and write)
			[3]: arg1 (readonly)
			[4]: Notification_upvr (copied, readonly)
		]]
		if tbl_upvw._GameData.Prices.LINK.Coins <= var6_upvw.Data.Currencies.Coins then
			arg1:FireServer("Confirm")
		else
			Notification_upvr:Fire("NoCurrency", {
				Currency = "Coins";
			})
		end
	end)
	var17_upvw = Container_upvr.Topbar.ExitBtnFrame.TextButton.MouseButton1Click:Connect(function() -- Line 94
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:FireServer("Cancel")
	end)
	arg1:AddCleanupTask(function() -- Line 98
		--[[ Upvalues[3]:
			[1]: Container_upvr (copied, readonly)
			[2]: FrameVisibility_upvr (copied, readonly)
			[3]: CharacterController_upvr (copied, readonly)
		]]
		if Container_upvr.Parent.Visible then
			FrameVisibility_upvr:ManageFrame(Container_upvr.Parent)
		end
		CharacterController_upvr:SetState("LinkRequest", false)
	end)
end)



game:GetService("RobloxReplicatedStorage").ServerSideBulkPurchaseEvent





Chances


return {
	Common = 50;
	Uncommon = 30;
	Rare = 14;
	["Super Rare"] = 5;
	Legendary = 1;
}

Order

return {
	Common = 1;
	Uncommon = 2;
	Rare = 3;
	["Super Rare"] = 4;
	Legendary = 5;
}







