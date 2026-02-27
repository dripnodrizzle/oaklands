function setmetatable_result1.AddEnum (arg1, arg2, arg3) -- Line 25
--[[ Upvalues[2]:
[1]: FreezeEnumTable_upvr (readonly)
[2]: tbl_upvr (readonly)
1]
if type(arg2) ~= "string" then
warn（"索引必须是string"，arg2, typeof（arg2），'\n'
, debug. traceback())
return false
end
if type(arg3) ~= "table" then
warn（"枚举表必须是table"
, arg3, typeof (arg3), "In' , debug. traceback))
return false
end
if argl[larg2] then
warn（”枚举表"
．.arg2．.”已存在”）
return false
end
FreezeEnumTable_upvr (arg3)
tbl_upvr[arg2] = arg3
return true
end
setmetatable_result1.ECSEntityType = {
Default = '1';
Monster = "Monster";
Tower = "Tower";
HexagonGrid = "HexagonGrid";
}
setmetatable_result1.SandBoxMonsterState = {
Default = 1;
Waiting = 2;
Spawning = 3;
Complete = 4;
}
setmetatable_result1.TreeNodeType = {
Root = 0;
Child = 1;
Leaf = 2;
}
setmetatable_result1.ECSEntityType = {
Default = '1';
Monster = "Monster";
Tower = "Tower";
HexagonGrid = "HexagonGrid";
}
setmetatable_result1.SandBoxMonsterState = {
Default = 1；
Waiting = 2;
Spawning = 3;
Complete = 4;
}
setmetatable_resultl.TreeNodeType = {
Root = 0;
Child = 1;
Leaf = 2;
}
setmetatable_result1.AnimeStateMachineInitMode = {
StandaloneMode = 1;
ClientSyncMode = 2;
setmetatable_resultl. AnimeBreakMode = {
NonInterruption = 1;
Interruption = 2;
InterruptionAndChangeSelf = 3;
NotPlayCurrAnime = 4;
NonInterruptionAndChangeSelf = 5;
}
setmetatable_result1. AnimeReloadMode = {
Add = 1;
Remove = 2;
Overwrite = 3;
setmetatable_result1.GoodsCurrencyType = {
Product = 1;
Pass = 2;
Customized = 3;
}
setmetatable_resultl. ReplicatedPolicy = {
Default = 1;
ClientToServer = 2;
ClientToAllClient = 3;
ServerNotToClient = 4;
ServerToTargetClient = 5;
}
setmetatable_resultl. ReplicatedObjectType = {
Sandbox = 1;
Element = 2;
}
setmetatable_result1.BuffRefreshType = {
IncreaseDuration = 0;
ReplacementDuration = 1;
}
setmetatable_result1.BuffClearType = {
FollowCharacter = 0;
FollowGameCycle = 1;
FollowPlayerCache = 2;
}
setmetatable_resultl.BuffOrigin = {
Ability = 0;
Item = 1;
InviteFriends = 2;
Premium = 3;
Temple = 4;
Rescue = 5;
Activity = 6;
setmetatable_resultl. CheckPurchaseNumMode = {
Forever = 1;
Daily = 2;
Weekly = 3;
Monthly = 4;
EveryYear = 5;
}
setmetatable_resultl.GEDurationPolicy = {
Instant = 1;
HasDuration = 2;
}
setmetatable_result1.GEExePolicy = {
OtherGEFinish = 1;
ThisGEApply = 2;
WaitForResult = 3;
}
setmetatable_result1.QuestType = {
Achievement = 1;
Dally = 2;
Weekly = 3;
Linearly = 4;
Cycle = 5;
｝
setmetatable_resultl .QuestState = {
NoReceive = 0;
Receive = 1;
Done = 2;
Submitted = 3;
}
setmetatable_resultl.LeaderboardIndex = {
RechargeLeaderboard = "RechargeLeaderboard";
CombatPowerLeaderboard = "CombatPowerLeaderboard";
MaxWavesLeaderboard = "MaxWavesLeaderboard";
KillCountLeaderboard = "KillCountLeaderboard";
CurPeriodAbyssLeaderboard = "CurPeriodAbyssLeaderboard";
LastPeriodAbyssLeaderboard = "LastPeriodAbyssLeaderboard";
setmetatable_resultl. PlayerDataStoreStatus = {
Free = 0;
Waiting = 1;
Processing = 2;
}
setmetatable_resultl.MainState = {
Normal = 1;
Small = 2;
Hide = 3;
}
setmetatable_resultl PlayerLoginInfo = {
RegisterTime = 1;
LoginDay = 2;
ContinuousLoginDay = 3;
LoginTime = 4;
OffLineTime = 5;
OnlineTime = 6;
DailyOnlineTime = 7;
WeeklyonlineTime = 8;
MonthlyOnlineTime = 9;
YearlyOnlineTime = 10;
LastUpdateTime = 11;
}
setmetatable_result1.PlayerGameStatus = {
Free = 1;
PrimaryGamePlay = 2;
PVP = 3;
}
"Free", "PrimaryGamePlay"
, "PVP"
setmetatable_result1.PlayerDataLoadingStatus = {
Loading = 0;
SuccessOnServer = 1;
SuccessOnClient = 2;
}
setmetatable_result1.UnlockedStatus = {
Unlocked = 1;
Locked = 0;
setmetatable_result1.DamageOrigin = {
Player = 1;
Tower = 2;
setmetatable_result1.BuffType = {
DamageUp = 1;
Vulnerability = 2;
Burn = 3;
Poison = 4;
Slows = 5;
NoAttacking = 6;
}
setmetatable_result1.BuffMap = {}
setmetatable_result1.WindowLayer = {
Main = 0;
Lower = 21;
Normal = 41;
Special = 51;
Tips = 61;
Resident = 71;
Floating = 81;
Guide = 101;
Loading = 121;
}
setmetatable_result1.Quality = {
Common = 1;
Uncommon = 2;
Rare = 3;
Epic = 4;
Legendary = 5;
Mythic = 6;
Godly = 7;
}
setmetatable_result1.Rarity = {
Normal = 1;
Gold = 2;
Rainbow = 3;
Diamond = 4;
}
Diamond = 4;
}
setmetatable_result1.CreatureType = {
Player = 1;
Monster = 2;
Door = 3;
Target = 4;
Boss = 5;
Folk = 6;
Debris = 7;
}
setmetatable_result1.MonsterType = {
Normal = 1;
Elite = 2;
Boss = 3;
Buff1 = 4;
Buff2 = 5;
Buff3 = 6;
Gems 1 = 7;
}
setmetatable_result1.FolkType = {
None = 0;
Monster = 1;
Structure = 2;
Projectile = 3;
｝
setmetatable_result1.AttrRecalcutedSwitchRecursiveMode = {
None = 0;
Normal = 1;
Force = 2;
}
setmetatable_result1.AttrChildCalcutedMode = {
Base = 0;
Magnification = 1;
Fixed = 2;
}
setmetatable_result1.Attr = require(script:WaitForChild("AttrEnum")). Attı
setmetatable_result1.KeyID = require(script:WaitForChild("KeyIDEnum"))
setmetatable_result1.SettingProperty = {
OrtherGainHero = "OrtherGainHero";
Sound = "Sound";
Music = "Music";
SkipSummonAnim = "SkipSummonAnim";
Potatomode = "Potatomode" ;
Trade = "Trade";
BattleScreenShake = "BattleScreenShake";
MyEffects = "MyEffects";
OthersEffects = "OthersEffects";
HitLight = "HitLight";
HitVibration = "HitVibration";
ShiftLockMode = "ShiftLockMode";
}
setmetatable_result1.AreaType = {
Safe = 1;
MainCity = 2;
Normal = 3;
setmetatable_result1.PassState = {
Sleep = 0;
Active = 1;
End = 2;
}
setmetatable_result1.PassType = {
Active = 1;
Recruit = 2;
PlayerLevel = 3;
EquipmentLevelUp = 4;
LimitedTime = 5;
}
setmetatable_result1.PopUpShopStatus = {
Closed = '0';
Purchased = '1';
Inactive = '2';
}
setmetatable_result1.PopUpShopStatus = {
Closed = '0';
Purchased = '1';
Inactive = '2';
}
setmetatable_result1.PopUpShopTimeLimitMode = {
Default = 1;
Ignore0ffLine = 2;
setmetatable_result1.PopUpShopProperty = {
ActiveTime = 1;
Status = 2;
}
setmetatable_result1.TeleportState = {
AFK = 1;
None = 2;
Area = 3;
JoinFriend = 4;
}
setmetatable_result1. CameraShakerReferedFunction = {
Shop = "Shop";
Backpack = "Backpack";
HeroBackpack = "HeroBackpack";
Summon = "Summon";
TrainingCamp = "TrainingCamp";
Blackmarket = "Blackmarket";
HeroManual = "HeroManual";
}
setmetatable_result1.PlayerOperatedSetting = {
Movable = 1;
Jumpable = 2;
}
setmetatable_result1.PlayerOperatedSettingOrigin = {
BackpackGui = 1;
Attack = 2;
Dash = 3;
Buff = 4;
Ability = 5;
AFK = 6;
SelectGain = 7;
MultiCamera = 8;
}
setmetatable_result1.MailProperty = {
Id = 1;
Type = 2;
SenderId = 3;
SendingDate = 4;
ExpirationDate = 5;
ReadState = 6;
Title = 7;
Text = 8;
Signatures = 9;
Item = 10;
}
setmetatable_result1.MailReadState = {
Unread = 0;
NotClaimed = 1;
Read = 2;
}
setmetatable_result1.CreatureAliveState = {
Alive = 0;
Dying = 1;
Died = 2;
}
setmetatable_result1.ShopShowType = {
GridFirst = 1;
Grid = 2;
List = 3;
ListSecond = 4;
NoDivisionList = 5;
Pass = 6;
}
setmetatable_result1.CreatureSetting = {
Movable = 0;
Jumpable = 1;
Walkable = 2;
Runable = 3;
Visiable = 4;
Hurtable = 5;
Clearable = 6;
InPutMode = 7;
Attackable = 8;
StunClearable = 9;
CameraFollow = 10;
Controllable = 11;
}
setmetatable_result1.RedPointType = {
Icon = 1;
Num = 2;
New = 3;
}
setmetatable_result1.CameraLayer = {
Normal = 1;
Main = 11;
Ability = 21;
Scence = 31;
UI = 41;
Max = 9999;
}
setmetatable_result1.PlayerOnlineInfo = {
UpdateTime = 1;
PlaceId = 2;
JobId = 3;
PrivateServerId = 4;
ReservedServerAccessCode = 5;
ServerOwnerId = 6;
}
setmetatable_result1.CrossServerMessageTopic = {
ServerInfo = "ServerInfo";
PlayerOnlineNotify = "PlayerOnlineNotify";
GuildChat = "GuildChat";
GuildDataOperation = "GuildDataOperation";
}
setmetatable_result1.OnlineServerInfo = {
PlaceId = 1;
JobId = 2;
CurrPlayer = 3;
MaxPlayers = 4;
}
setmetatable_result1.WorldIndex = {
PVP = "PVP":
World0 = 0;
World1 = 1;
World2 = 2;
World3 = 3;
World4 = 4;
World5 = 5;
World6 = 6;
World7 = 7;
World8 = 8;
World9 = 9;
}
setmetatable_result1.PlantFSMState = {
Idle = 1;
Attack = 2;
}
setmetatable_result1. PlantNodeName = {"Idle", "Attack"}
setmetatable_result1.MonsterFSMState = {
Run = 1;
Death = 2;
Idle = 3;
Attack = 4;
Stagger = 5;
Stun = 6;
Appear = 7;
}
setmetatable_result1.MonsterNodeName = {"Run", "Death", "Idle", "Attack", "Stagger", "Stun", "Appear"}
setmetatable_result1. TowerFSMState = {
Idle = 1;
Attack = 2;
setmetatable_result1.ProducerFSMState = {
Idle = 1;
Attack = 2;
}
setmetatable_result1.ProducerNodeName = {"Idle", "Attack"}
setmetatable_result1.TowerNodeName = {"Idle", "Attack"}
setmetatable_result1. PlayerFSMSwitchMode = {
AllowSwitchMyself = 1;
NotAllowSwitchMyself = 2;
setmetatable_result1.PlayerAnimeType = {
Attack = "Attack";
Dodge = "Dodge";
}
setmetatable_result1.PlayerFSMState = {
Run = 1;
Idle = 2;
Jump = 3;
FreeFalling = 4;
Equip = 5;
UnEquip = 6;
Attack = 7;
Dodoe = 8;
}
setmetatable_result1. PlayerFSMNodeName = {"Run", "Idle", "Jump", "FreeFalling", "Equip", "UnEquip", "Attack", "Dodge", "Stun", "WeaponDeployed", "Save"}
setmetatable_result1.PlayerAnimeName = {"Run", "Idle", "Jump"" "FreeFalling" "Equip" "UnEquip" "Attack", "Dodge"}
"Attack", "Dodge"}
setmetatable_resultl.AbilityIndex = {
Attack = 1;
Dash = 2;
Skillone = 3;
SkillTwo = 4;
SkillThree = 5;
ChangeWeaponOne = 6;
ChangeWeaponTwo = 7;
ChangeWeaponThree = 8;
}
setmetatable_result1.TeleportSystem = {
MatchSession 1;
}
setmetatable_result1. UpdateReward = {
NotReceived = 0;
Received = 1;
}
setmetatable_result1.TextChangeType = {
JustColor = 1;
JustBold = 2;
JustItalic = 3;
ColorAndBold = 4;
ColorAndItalic = 5;
BoldAndItalic = 6;
ThreeChange = 7;
}
setmetatable_result1.DailyReward = {
DailyDraw = "Daily Lottery";
DailyRewards_7 = "7-Day Sign-in";
DailyRewards_28 = "28-Day Sign-in";
}
J
setmetatable_result1.ModelRotationAxis = {
X = 1;
Y = 2;
Z = 3;
｝
setmetatable_result1.ModelRotationListening = {
X = 1;
Y = 2;
Z = 3;
}
setmetatable_result1 Projectile = {
Rays = 1;
Bezier = 2;
}
setmetatable_result1.BattleRoomStatisticsType = {
Coin = 1;
Score = 2;
KilledNum = 3;
}
setmetatable_result1.HistoricalStatisticsType = {
TotalOnlineTime = 1;
TotalCoinNum = 2;
TotalKillMonsterNum = 3;
TotalLotteryNum = 4;
TotalLoginDayNum = 5;
MaxWaveNum = 6;
MaxPower = 7;
AbyssMaxDamage = 8;
AbyssMaxRemainTime = 9;
TotalAbyssCoinNum = 10;
AbyssChallengeNum = 11;
AbyssPoints = 12;
}
setmetatable_resultl HistoricalStatisticsType = {
TotalOnlineTime = 1;
TotalCoinNum = 2;
TotalKillMonsterNum = 3;
TotalLotteryNum = 4;
TotalLoginDayNum = 5;
MaxWaveNum = 6;
MaxPower = 7;
AbyssMaxDamage = 8;
AbyssMaxRemainTime = 9;
TotalAbyssCoinNum = 10;
AbyssChallengeNum = 11;
AbyssPoints = 12;
}
setmetatable_result1.StatsShowType = {
DayHourMinSec = 1;
ThousandSeparator = 2;
KMB = 3;
Date = 4;
Percent = 5;
}
setmetatable_result1.CollisionGroupType = {
Player = "Player";
BlockCheck = "BlockCheck";
Area = "Area";
Scene = "Scene";
setmetatable_result1.DeviceType = {
PC = 1;
Tablet = 2;
Phone = 3;
Gamepad = 4;
Unknown = 5;
}
setmetatable_result1.DailyRecordType = {
RescuePatient = 1;
SatisfactionValue = 2;
Income = 3;
}
setmetatable_result1.GameItemUseType = {
Interact = 1;
Player = 2;
A11 = 3;
}
setmetatable_result1.MedicationState = {
Waite = 1;
Creating = 2;
Collect = 3;
}
setmetatable_result1.ModelMoveToolType = {
Liner = 1;
Parabola = 2;
Ellipse = 3;
SinWave = 4;
}
setmetatable_result1.GetType = {
Free = 1;
RobuBuy = 2;
GoodsBuy = 3;
LotteryByRobu = 4;
DailyReward = 5;
LotteryByCoin = 6;
}
setmetatable_result1.SceneAreaType = {
NoviceWard = "NoviceWard";
OneF = "OneF";
TwoF = "TwoF" ;
LowergroundF = "LowergroundF";
}
Night = "Night";
}
setmetatable_result1.ThrowableMoveType = {
RealPhysics = 1;
}
setmetatable_result1.BackpackItemOrigin = {
DailyReward = 1;
setmetatable_result1.PatientState = {
PatientIdle = "P1";
PatientFollow = "P2";
PatientStart = "PO";
PatientHealFlowOver = "S6";
PatientDie = "S53";
PatientEnd = "P100";
WorsenStart = "WO";
WorsenEnd = "W1";
}
setmetatable_result1.IstateChangeMode = {
Normal = 1;
OnlyEnter = 2;
}
setmetatable_result1.EmergencyType = {
Normal = 1;
Maternity = 2;
}
setmetatable_result1.EmergencyStage = {
Wait = 1;
Going = 2;
}
setmetatable_result1.PopUpShopType = {
Normal = 1;
Ascend = 2;
Trait = 3;
PremiumCurrency = 4;
NULL = 5;
｝
setmetatable_result1.PlayerForceTargetUpdateType = {
Normal = 1;
Rush = 2;
}
setmetatable_result1.KillEffectState = {
Traveling = 1;
Waiting = 2;
｝
setmetatable_result1.PremiumCurrencyChangedOrigin = {
BattleRoomCoinPoint = "BattleRoomCoinPoint";
BattleRoomSettlement = "BattleRoomSettlement";
Drop = "Drop";
}
setmetatable_result1.GameItemType = {
Weapon = 1;
Armor = 2;
Inlay = 3;
Ornament = 4;
}
setmetatable_result1.GameBackpackType = {
Item = "Item";
Equipment = "Equipment";
}
setmetatable_result1.HomeBaseFacility = {
AFK = "AFK":
Population = "Population";
SpeedLevel = "SpeedLevel";
DoorPlate = "DoorPlate";
PowerPlate = "PowerPlate";
}
setmetatable_result1.PoolType = {
Permanent = 1;
Limited = 2;
Turn = 3;
Up = 4;
}
setmetatable_result1.DrawType = {
SingleDraw = 1;
FiveDraws = 2;
setmetatable_result1.WeaponLotteryState = {
NotIgnore = 0;
Ignore = 1;
}
setmetatable_resultl.PassPrivilege = {
VIP = '8':
Harvest = '6';
ScalePrivilege = "10"
RarityPrivilege = "11" ,
DoubleCoin = '7';
TripleCoin = '8';
FivefoldCoin = '9';
TenfoldAFKRewark = '5';
HighLevelReward = "25";
EndlessGoldReward = "46";
EndlessGoldReward_2 = "53";
}
setmetatable_result1.PremiumCurrencyType = {
Gold = '1';
Abyss = '2';
}
setmetatable_result1.LoadingAnimType = {
Standby = 1;
Impact = 2;
Impacted = 3;
OpenDoor = 4;
CameraAnim = 5;
DoorShake = 6;
}
setmetatable_result1.ManualType = {
Brainrot = '1';
Plant = '2';
}
setmetatable_result1.SellResultState = {
Succ = 1;
PriceIsZero = 2;
NotHavehandheld = 3;
}
setmetatable_result1.SellResultState = {
Succ = 1;
PriceIsZero = 2;
NotHavehandheld = 3;
}
setmetatable_result1. MatchLevelShowType = {
Plant = 1;
Brainrot = 2;
}
setmetatable_result1.AnimationEntityType = {
Tower = 1;
Monster = 2;
Producer = 3;
}
setmetatable_result1.InviteRewardIssuePattern = {
OnlyOnce = 1;
ReissueLogin = 2;
}
setmetatable_resultl.AnimationLevelEnum = {
High = 1;
Middle = 2;
Low = 3;
VeryLow = 4;
}
setmetatable_result1.LockState = {
A11 = 1;
AllLock = 2;
AllUnlock = 3;
}
setmetatable_result1.WeaponType = {
Katana = 1;
}
setmetatable_result1.ArmorType = {
Head = 1;
Body = 2;
Leg = 3;
}
setmetatable_result1.BackpackTabType = {
Equip = 1;
Inlay = 2;
}
setmetatable_result1.BackpackEquipTabType = {
All = 1;
Weapon = 2;
Head = 3;
Body = 4;
Leg = 5;
Ornament = 6;
}
setmetatable_result1.GridType = {
BackpackGrid = 1;
WeaponBarGird = 2;
ArmorBarGrid = 3;
OrnamentBarGrid = 4;
｝
setmetatable_result1.DodgeDirection = {
Front = 1;
Back = 2;
Left = 3;
Right = 4;
}
setmetatable_result1.TraitType = {
Fixed = 1;
Percentage = 2;
setmetatable_result1.EquipmentSourceType = {
Equipped = 1;
Backpack = 2;
setmetatable_result1.EquipmentEnhanceSourceType = {
Backpack = 1;
Weapon = 2;
Armor = 3;
Ornament = 4;
}
setmetatable_result1.MatchStatisticsType = {
MatchKill = 1;
MatchMoney = 2;
MatchDuration = 3;
MatchItems = 4;
MatchDamage = 5;
MatchExp = 6;
MatchWaveNum = 7;
MatchAbyssMoney = 8;
MatchAbyssPoints = 9;
MatchAbyssBossPoints = 10;
MatchAbyssTimePoints = 11;
}
setmetatable_result1.DungeonDifficulty = {
Normal = 1;
Hard = 2;
Impossible = 3;
}
setmetatable_result1.MainLevel = {
S = 1;
A = 2;
B = 3;
C = 4;
D = 5;
}
setmetatable_result1.ElementType = {
Fire = 1;
Poison = 2;
Thunder = 3;
None = 4;
}
setmetatable_result1.ElementClearReason = {
None = 0;
TimeOut = 1；
ClearManual = 2;
Destroy = 3;
}
setmetatable_result1.DamageType = {
SkillDamage = 1;
ElementDamage = 2;
Normal = 10;
Burn = 11;
Poison = 12;
｝
setmetatable_result1.TrapType = {
SingleDamage = 1;
OngoingDamage = 2;
Teleport = 3;
}
setmetatable_result1.AtkType = {
Noraml = 1;
Ability = 2;
Element = 3;
}
setmetatable_result1.SandboxType = {
Monster = 1;
EliteMonster = 2;
Boss = 3;
Chest = 4;
Diamond = 5;
Buff = 6;
Recover = 7;
Endless = 8;
Abyss = 9;
}
setmetatable_result1.SandboxMode = {
Normal = 0;
Survival = 1;
Boss = 2;
EndLess = 3;
Connect = 4;
}
setmetatable_result1.CollisionShape = {
Sphere = 1;
Box = 2;
}
setmetatable_result1.RefreshAbilityMode = {
None = 0;
Refresh = 1;
ReduceRemain = 2;
ReducePercent = 3;
}
setmetatable_result1.ReviveType = {
Single = 0;
Team = 1;
}
setmetatable_result1.LevelRewardType = {
Common = 'Ø' ;
High = '1';
setmetatable_result1.LevelRewardStates = {
Lock = 0;
Unlock = 1;
Receive = 2;
}
setmetatable_resultl.TutorialPart = {
Dungeon = 1;
Lobby = 2;
}
setmetatable_result1.SummonMonsterOrigin = {
Scene = 1;
Self = 2;
}
setmetatable_result1.BackpackCapacityScoure = {
CapacityPrivilege = '1';
VIP = '2';
}
setmetatable_result1.TurnSpeedPriority = {
Skill = 1;
}
setmetatable_result1.DiamondSandboxType = {
Debris = 1;
PacMan = 2;
Stake = 3;
}
setmetatable_result1.SymbolType = {
Add = 1;
Reduce = 2;
}
setmetatable_result1.BuffSandboxType = {
SingleStake = 1;
BlowUpBalloon = 2;
MultipleStake = 3;
}
setmetatable_result1.CardType = {
Attribute = 1;
Mechanic = 2;
}
setmetatable_result1.CardMechanicType = {
Revive = 1;
}
setmetatable_resultl.AbilityType = {
None = 0;
NormalAttack = 1;
AbilitySkill = 2;
ItemSkill = 3;
MonsterSkill = 4;
}
setmetatable_result1.DungeonMapid = {
Dungeon1 = '1';
Dungeon2 = '2';
Dungeon3 = '3';
Dungeon4 = '4';
Novice = '5';
}
setmetatable_result1.DungeonType = {
Normal = 1;
Tower = 2;
Abyss = 3;
}
setmetatable_result1.ItemSource = {
Lottery = "Lottery";
Equipment = "Equipment";
Obtain = "Obtain";
}
setmetatable_result1.TargetPolicy = {
None = 0;
RangeX = 1;
Nearest = 2;
Farthest = 3;
Self = 4;
}
setmetatable_result1.AbilitySpecialEffect = {
Execution = 1;
}
setmetatable_result1.InlayType = {
CommonRefined = 1;
AdvancedRefined = 2;
EnhanceStone = 3;
EnhanceTicket = 4;
}
setmetatable_result1.RobloxModelType = {
R6 = "R6";
R15 ="R15";
}
setmetatable_result1.TraitConfigType = {
Refined = 1;
Enhance = 2;
}
setmetatable_result1.AbyssTicketOrigin = {
Free = 1;
Shop = 2;
}
setmetatable_result1.FriendGameState = {
Online = 1;
AFK = 2;
Lobby = 3;
Dungeon = 4;
}
setmetatable_result1.ServerType = {
Formal = 1;
Test = 2;
}
return setmetatable_result1








-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-11 04:24:47
-- Luau version 6, Types version 3
-- Time taken: 0.041599 seconds

local module_upvr = {
	PermanentPool1 = {
		DisPlayName = "Classic";
		ImageId = "";
		Describe = nil;
		StartTime = nil;
		EndTime = nil;
		GuaranteedCount = "PermanentPool1";
		DailyRefreshFreeTimes = 0;
		FreeInterval = nil;
		FreeIntervalMaxNum = nil;
		DesignatedGift = nil;
		CanPurchaseFuncInfoTable = {{
			FuncName = "CheckOrigin";
			Parameter = nil;
		}};
		PayPriceFuncInfoTable = nil;
		LuckAttrIndex = nil;
		BackgroundImageId = "rbxassetid://100460289041536";
		ShowIcons = {"rbxassetid://111940258440566", "rbxassetid://84098253211709", "rbxassetid://106563779144504", "rbxassetid://104016854812234", "rbxassetid://94592721854191"};
		
		{
			Probability = 0.52335;
			DisplayProbability = 0.5;
			StartIncrementalNum = 1;
			Increase = 0;
			
			{
				ItemId = "101";
				Icon = "rbxassetid://110813656364872";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "101";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "101";
						Num = 1;
					}};
				}};
			}
		}, {
			Probability = 0.37;
			DisplayProbability = 0.37;
			StartIncrementalNum = 1;
			Increase = 0;
			
			{
				ItemId = "102";
				Icon = "rbxassetid://104016854812234";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "102";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "102";
						Num = 1;
					}};
				}};
			}
		}, {
			Probability = 0.098;
			DisplayProbability = 0.112;
			StartIncrementalNum = 19;
			Increase = 1;
			
			{
				ItemId = "103";
				Icon = "rbxassetid://106563779144504";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "103";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "103";
						Num = 1;
					}};
				}};
			}
		}, {
			Probability = 0.00725;
			DisplayProbability = 0.014;
			StartIncrementalNum = 99;
			Increase = 1;
			
			{
				ItemId = "104";
				Icon = "rbxassetid://84098253211709";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "104";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "104";
						Num = 1;
					}};
				}};
			}
		}, {
			Probability = 0.0014;
			DisplayProbability = 0.004;
			StartIncrementalNum = 299;
			Increase = 1;
			
			{
				ItemId = "105";
				Icon = "rbxassetid://111940258440566";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "105";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "105";
						Num = 1;
					}};
				}};
			}
		}
	};
	PermanentPool2 = {
		DisPlayName = "Classic";
		ImageId = "";
		Describe = nil;
		StartTime = nil;
		EndTime = nil;
		GuaranteedCount = "PermanentPool1";
		DailyRefreshFreeTimes = 0;
		FreeInterval = nil;
		FreeIntervalMaxNum = nil;
		DesignatedGift = {
			DrawNum = 1;
			BranchPoolIndex = 2;
			GiftIndex = 1;
		};
		CanPurchaseFuncInfoTable = {{
			FuncName = "CheckOrigin";
			Parameter = nil;
		}};
		PayPriceFuncInfoTable = nil;
		LuckAttrIndex = nil;
		BackgroundImageId = "rbxassetid://106786128371237";
		ShowIcons = {"rbxassetid://78743599223174", "rbxassetid://94112222802447", "rbxassetid://87806884994777", "rbxassetid://122314187616433", "rbxassetid://114800360116691"};
		
		{
			Probability = 0.52335;
			DisplayProbability = 0.5;
			StartIncrementalNum = 1;
			Increase = 0;
			
			{
				ItemId = "106";
				Icon = "rbxassetid://70639357757444";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "106";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "106";
						Num = 1;
					}};
				}};
			}
		}, {
			Probability = 0.37;
			DisplayProbability = 0.37;
			StartIncrementalNum = 1;
			Increase = 0;
			
			{
				ItemId = "107";
				Icon = "rbxassetid://122314187616433";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "107";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "107";
						Num = 1;
					}};
				}};
			}
		}, {
			Probability = 0.098;
			DisplayProbability = 0.112;
			StartIncrementalNum = 19;
			Increase = 1;
			
			{
				ItemId = "108";
				Icon = "rbxassetid://87806884994777";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "108";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "108";
						Num = 1;
					}};
				}};
			}
		}, {
			Probability = 0.00725;
			DisplayProbability = 0.014;
			StartIncrementalNum = 99;
			Increase = 1;
			
			{
				ItemId = "109";
				Icon = "rbxassetid://94112222802447";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "109";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "109";
						Num = 1;
					}};
				}};
			}
		}, {
			Probability = 0.0014;
			DisplayProbability = 0.004;
			StartIncrementalNum = 299;
			Increase = 1;
			
			{
				ItemId = "110";
				Icon = "rbxassetid://78743599223174";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "110";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "110";
						Num = 1;
					}};
				}};
			}
		}
	};
	PermanentPool3 = {
		DisPlayName = "Classic";
		ImageId = "";
		Describe = nil;
		StartTime = nil;
		EndTime = nil;
		GuaranteedCount = "PermanentPool1";
		DailyRefreshFreeTimes = 0;
		FreeInterval = nil;
		FreeIntervalMaxNum = nil;
		DesignatedGift = nil;
		CanPurchaseFuncInfoTable = {{
			FuncName = "CheckOrigin";
			Parameter = nil;
		}};
		PayPriceFuncInfoTable = nil;
		LuckAttrIndex = nil;
		BackgroundImageId = "rbxassetid://93616867646817";
		ShowIcons = {"rbxassetid://131268972505017", "rbxassetid://133932757132073", "rbxassetid://133982698492275", "rbxassetid://117567886469573", "rbxassetid://122452206348337"};
		
		{
			Probability = 0.52335;
			DisplayProbability = 0.5;
			StartIncrementalNum = 1;
			Increase = 0;
			
			{
				ItemId = "111";
				Icon = "rbxassetid://122452206348337";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "111";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "111";
						Num = 1;
					}};
				}};
			}
		}, {
			Probability = 0.37;
			DisplayProbability = 0.37;
			StartIncrementalNum = 1;
			Increase = 0;
			
			{
				ItemId = "112";
				Icon = "rbxassetid://117567886469573";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "112";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "112";
						Num = 1;
					}};
				}};
			}
		}, {
			Probability = 0.098;
			DisplayProbability = 0.112;
			StartIncrementalNum = 19;
			Increase = 1;
			
			{
				ItemId = "113";
				Icon = "rbxassetid://133982698492275";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "113";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "113";
						Num = 1;
					}};
				}};
			}
		}, {
			Probability = 0.00725;
			DisplayProbability = 0.014;
			StartIncrementalNum = 99;
			Increase = 1;
			
			{
				ItemId = "114";
				Icon = "rbxassetid://133932757132073";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "114";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "114";
						Num = 1;
					}};
				}};
			}
		}, {
			Probability = 0.0014;
			DisplayProbability = 0.004;
			StartIncrementalNum = 299;
			Increase = 1;
			
			{
				ItemId = "115";
				Icon = "rbxassetid://131268972505017";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "115";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "115";
						Num = 1;
					}};
				}};
			}
		}
	};
	ChristmasLimited = {
		DisPlayName = "Classic";
		ImageId = "";
		Describe = nil;
		StartTime = nil;
		EndTime = nil;
		GuaranteedCount = "nil";
		DailyRefreshFreeTimes = 0;
		FreeInterval = nil;
		FreeIntervalMaxNum = nil;
		DesignatedGift = nil;
		CanPurchaseFuncInfoTable = {{
			FuncName = "CheckOrigin";
			Parameter = nil;
		}};
		PayPriceFuncInfoTable = nil;
		LuckAttrIndex = nil;
		BackgroundImageId = "rbxassetid://106786128371237";
		ShowIcons = {"rbxassetid://82184324520874"};
		
		{
			Probability = 1;
			DisplayProbability = 1;
			StartIncrementalNum = 1;
			Increase = 0;
			
			{
				ItemId = "116";
				Icon = "rbxassetid://82184324520874";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddWeaponToBackpackOverLimit";
					Parameter = {{
						Id = "116";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpackOverLimit";
					Parameter = {{
						Id = "116";
						Num = 1;
					}};
				}};
			}
		}
	};
	GunbladeLimited = {
		DisPlayName = "Classic";
		ImageId = "";
		Describe = nil;
		StartTime = nil;
		EndTime = nil;
		GuaranteedCount = "nil";
		DailyRefreshFreeTimes = 0;
		FreeInterval = nil;
		FreeIntervalMaxNum = nil;
		DesignatedGift = nil;
		CanPurchaseFuncInfoTable = {{
			FuncName = "CheckOrigin";
			Parameter = nil;
		}};
		PayPriceFuncInfoTable = nil;
		LuckAttrIndex = nil;
		BackgroundImageId = "rbxassetid://106786128371237";
		ShowIcons = {"rbxassetid://82184324520874"};
		
		{
			Probability = 1;
			DisplayProbability = 1;
			StartIncrementalNum = 1;
			Increase = 0;
			
			{
				ItemId = "117";
				Icon = "rbxassetid://109949809701752";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddWeaponToBackpackOverLimit";
					Parameter = {{
						Id = "117";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpackOverLimit";
					Parameter = {{
						Id = "117";
						Num = 1;
					}};
				}};
			}
		}
	};
	PermanentPool4 = {
		DisPlayName = "Classic";
		ImageId = "";
		Describe = nil;
		StartTime = nil;
		EndTime = nil;
		GuaranteedCount = "PermanentPool1";
		DailyRefreshFreeTimes = 0;
		FreeInterval = nil;
		FreeIntervalMaxNum = nil;
		DesignatedGift = nil;
		CanPurchaseFuncInfoTable = {{
			FuncName = "CheckOrigin";
			Parameter = nil;
		}};
		PayPriceFuncInfoTable = nil;
		LuckAttrIndex = nil;
		BackgroundImageId = "rbxassetid://115850889350718";
		ShowIcons = {"rbxassetid://71521401651832", "rbxassetid://134722423979173", "rbxassetid://106563779144504", "rbxassetid://122314187616433", "rbxassetid://114800360116691"};
		
		{
			Probability = 0.52335;
			DisplayProbability = 0.5;
			StartIncrementalNum = 1;
			Increase = 0;
			
			{
				ItemId = "106";
				Icon = "rbxassetid://70639357757444";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "106";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "106";
						Num = 1;
					}};
				}};
			}
		}, {
			Probability = 0.37;
			DisplayProbability = 0.37;
			StartIncrementalNum = 1;
			Increase = 0;
			
			{
				ItemId = "107";
				Icon = "rbxassetid://122314187616433";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "107";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "107";
						Num = 1;
					}};
				}};
			}
		}, {
			Probability = 0.098;
			DisplayProbability = 0.112;
			StartIncrementalNum = 19;
			Increase = 1;
			
			{
				ItemId = "103";
				Icon = "rbxassetid://106563779144504";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "103";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "103";
						Num = 1;
					}};
				}};
			}
		}, {
			Probability = 0.00725;
			DisplayProbability = 0.014;
			StartIncrementalNum = 99;
			Increase = 1;
			
			{
				ItemId = "118";
				Icon = "rbxassetid://90756114286139";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "118";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "118";
						Num = 1;
					}};
				}};
			}
		}, {
			Probability = 0.0014;
			DisplayProbability = 0.004;
			StartIncrementalNum = 299;
			Increase = 1;
			
			{
				ItemId = "119";
				Icon = "rbxassetid://128019488797291";
				MaxNum = nil;
				Weight = 1000;
				ConditFuncInfoTable = {{
					FuncName = "CheckCanAddItemToBack";
					Parameter = {{
						Id = "119";
						Num = 1;
					}};
				}};
				SpecialFuncInfoTable = {{
					FuncName = "AddWeaponToBackpack";
					Parameter = {{
						Id = "119";
						Num = 1;
					}};
				}};
			}
		}
	};
}
function Initile() -- Line 417
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	for i, v in pairs(module_upvr) do
		local var261
		for i_2, v_2 in ipairs(v) do
			if i_2 ~= 1 then
				var261 += v_2.Probability
			end
		end
		v[1].Probability = 1 - var261
		if v[1].Probability < 0 then
			warn("卡池概率配置有误，总和超过1", i)
		end
	end
end
Initile()
function module_upvr.GetPoolWeight(arg1, arg2, arg3) -- Line 435
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var266 = 0
	for _, v_3 in ipairs(module_upvr[arg2][arg3]) do
		var266 += v_3.Weight
	end
	return var266
end
return module_upvr








-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-11 04:21:33
-- Luau version 6, Types version 3
-- Time taken: 0.094546 seconds

return {{
	LevelRewardsTiers = 1;
	LevelRequire = 2;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 50;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 2;
	LevelRequire = 3;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 50;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 3;
	LevelRequire = 4;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 50;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 4;
	LevelRequire = 5;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 50;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 5;
	LevelRequire = 6;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 50;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 6;
	LevelRequire = 7;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 50;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 7;
	LevelRequire = 8;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 50;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 8;
	LevelRequire = 9;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 50;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 9;
	LevelRequire = 10;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 100;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 600;
		};
	}};
}, {
	LevelRewardsTiers = 10;
	LevelRequire = 11;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 50;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 11;
	LevelRequire = 12;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 50;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 12;
	LevelRequire = 13;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 50;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 13;
	LevelRequire = 14;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 50;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 14;
	LevelRequire = 15;
	BasicReward = {{
		FuncName = "AddItemToBackpack";
		Parameter = {{
			Id = "1001";
			Num = 5;
		}};
	}};
	PremiumReward = {{
		FuncName = "AddItemToBackpack";
		Parameter = {{
			Id = "1001";
			Num = 15;
		}};
	}};
}, {
	LevelRewardsTiers = 15;
	LevelRequire = 16;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 50;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 16;
	LevelRequire = 17;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 50;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 17;
	LevelRequire = 18;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 50;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 18;
	LevelRequire = 19;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 50;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 19;
	LevelRequire = 20;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 100;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 600;
		};
	}};
}, {
	LevelRewardsTiers = 20;
	LevelRequire = 21;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 100;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 21;
	LevelRequire = 22;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 100;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 22;
	LevelRequire = 23;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 100;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 23;
	LevelRequire = 24;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 100;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 24;
	LevelRequire = 25;
	BasicReward = {{
		FuncName = "AddItemToBackpack";
		Parameter = {{
			Id = "1001";
			Num = 5;
		}};
	}};
	PremiumReward = {{
		FuncName = "AddItemToBackpack";
		Parameter = {{
			Id = "1001";
			Num = 15;
		}};
	}};
}, {
	LevelRewardsTiers = 25;
	LevelRequire = 26;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 100;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 26;
	LevelRequire = 27;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 100;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 27;
	LevelRequire = 28;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 100;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 28;
	LevelRequire = 29;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 100;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
}, {
	LevelRewardsTiers = 29;
	LevelRequire = 30;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 200;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 600;
		};
	}};
}, {
	LevelRewardsTiers = 30;
	LevelRequire = 31;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 31;
	LevelRequire = 32;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 32;
	LevelRequire = 33;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 33;
	LevelRequire = 34;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 34;
	LevelRequire = 35;
	BasicReward = {{
		FuncName = "AddItemToBackpack";
		Parameter = {{
			Id = "1001";
			Num = 5;
		}};
	}};
	PremiumReward = {{
		FuncName = "AddItemToBackpack";
		Parameter = {{
			Id = "1001";
			Num = 15;
		}};
	}};
}, {
	LevelRewardsTiers = 35;
	LevelRequire = 36;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 36;
	LevelRequire = 37;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 37;
	LevelRequire = 38;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 38;
	LevelRequire = 39;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 39;
	LevelRequire = 40;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 900;
		};
	}};
}, {
	LevelRewardsTiers = 40;
	LevelRequire = 41;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 41;
	LevelRequire = 42;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 42;
	LevelRequire = 43;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 43;
	LevelRequire = 44;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 44;
	LevelRequire = 45;
	BasicReward = {{
		FuncName = "AddItemToBackpack";
		Parameter = {{
			Id = "1001";
			Num = 5;
		}};
	}};
	PremiumReward = {{
		FuncName = "AddItemToBackpack";
		Parameter = {{
			Id = "1001";
			Num = 15;
		}};
	}};
}, {
	LevelRewardsTiers = 45;
	LevelRequire = 46;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 46;
	LevelRequire = 47;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 47;
	LevelRequire = 48;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 48;
	LevelRequire = 49;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 49;
	LevelRequire = 50;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 300;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 900;
		};
	}};
}, {
	LevelRewardsTiers = 50;
	LevelRequire = 51;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 51;
	LevelRequire = 52;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 52;
	LevelRequire = 53;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 53;
	LevelRequire = 54;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 54;
	LevelRequire = 55;
	BasicReward = {{
		FuncName = "AddItemToBackpack";
		Parameter = {{
			Id = "1001";
			Num = 5;
		}};
	}};
	PremiumReward = {{
		FuncName = "AddItemToBackpack";
		Parameter = {{
			Id = "1001";
			Num = 15;
		}};
	}};
}, {
	LevelRewardsTiers = 55;
	LevelRequire = 56;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 150;
		};
	}};
	PremiumReward = {{
		FuncName = "AddPremiumCurrency";
		Parameter = {
			PremiumCurrencyId = '1';
			Num = 450;
		};
	}};
}, {
	LevelRewardsTiers = 56;
	LevelRequire = 57;
	BasicReward = {{
		FuncName = "AddPremiumCurrency";
		Paramete
		
		
		
		-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
		-- Decompiled on 2026-01-11 04:23:16
		-- Luau version 6, Types version 3
		-- Time taken: 0.005253 seconds
		
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local LocalPlayer_upvr = game:WaitForChild("Players").LocalPlayer
		local Script = ReplicatedStorage:WaitForChild("Tools"):WaitForChild("Script")
		local module_upvr_2 = require(Script:WaitForChild("ErrorCode"))
		local any_New_result1 = require(ReplicatedStorage:WaitForChild("LevelReward"):WaitForChild("Script"):WaitForChild("LevelRewardBaseClass")):New()
		local module_upvr = require(Script:WaitForChild("EnumCode"))
		function any_New_result1.GetPlayerLevelData(arg1) -- Line 26
			--[[ Upvalues[3]:
				[1]: LocalPlayer_upvr (readonly)
				[2]: module_upvr (readonly)
				[3]: module_upvr_2 (readonly)
			]]
			local LevelReward = LocalPlayer_upvr:WaitForChild("Configuration"):WaitForChild("LevelReward")
			local tbl = {}
			for i, v in pairs(LevelReward:WaitForChild("Common"):GetAttributes()) do
				tbl[tonumber(i)] = v
			end
			for i_2, v_2 in pairs(LevelReward:WaitForChild("High"):GetAttributes()) do
				({})[tonumber(i_2)] = v_2
				local var25
			end
			return module_upvr_2.SUCCEEDED, {
				Version = LevelReward:GetAttribute("Version");
				[module_upvr.LevelRewardType.Common] = tbl;
				[module_upvr.LevelRewardType.High] = var25;
			}
		end
		function any_New_result1.IsLevelRewardDataLoadSucc(arg1) -- Line 56
			--[[ Upvalues[2]:
				[1]: LocalPlayer_upvr (readonly)
				[2]: module_upvr_2 (readonly)
			]]
			local LevelReward_2 = LocalPlayer_upvr:WaitForChild("Configuration"):FindFirstChild("LevelReward")
			if LevelReward_2 == nil then
				return module_upvr_2.FAILED
			end
			if LevelReward_2:GetAttribute("Version") == nil then
				return module_upvr_2.FAILED
			end
			return module_upvr_2.SUCCEEDED
		end
		return any_New_result1





-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
		-- Decompiled on 2026-01-11 04:24:04
		-- Luau version 6, Types version 3
		-- Time taken: 0.001100 seconds
		
		local Script = game:GetService("ReplicatedStorage"):WaitForChild("Tools"):WaitForChild("Script")
		return {
			New = function(arg1) -- Line 14, Named "New"
				arg1.__index = arg1
				return setmetatable({}, arg1)
			end;
		}









        -- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-11 04:20:01
-- Luau version 6, Types version 3
-- Time taken: 0.052804 seconds

return {{
	Id = 1;
	Attr = {{38, 250}, {43, 8}};
	LevelExperience = 50;
}, {
	Id = 2;
	Attr = {{38, 265}, {43, 9}};
	LevelExperience = 150;
}, {
	Id = 3;
	Attr = {{38, 281}, {43, 10}};
	LevelExperience = 350;
}, {
	Id = 4;
	Attr = {{38, 298}, {43, 11}};
	LevelExperience = 500;
}, {
	Id = 5;
	Attr = {{38, 316}, {43, 12}};
	LevelExperience = 700;
}, {
	Id = 6;
	Attr = {{38, 340}, {43, 13}};
	LevelExperience = 800;
}, {
	Id = 7;
	Attr = {{38, 365}, {43, 14}};
	LevelExperience = 900;
}, {
	Id = 8;
	Attr = {{38, 391}, {43, 16}};
	LevelExperience = 1000;
}, {
	Id = 9;
	Attr = {{38, 418}, {43, 17}};
	LevelExperience = 1100;
}, {
	Id = 10;
	Attr = {{38, 446}, {43, 18}};
	LevelExperience = 1200;
}, {
	Id = 11;
	Attr = {{38, 485}, {43, 20}};
	LevelExperience = 1400;
}, {
	Id = 12;
	Attr = {{38, 525}, {43, 21}};
	LevelExperience = 1600;
}, {
	Id = 13;
	Attr = {{38, 567}, {43, 23}};
	LevelExperience = 1800;
}, {
	Id = 14;
	Attr = {{38, 610}, {43, 25}};
	LevelExperience = 2000;
}, {
	Id = 15;
	Attr = {{38, 655}, {43, 27}};
	LevelExperience = 2200;
}, {
	Id = 16;
	Attr = {{38, 715}, {43, 29}};
	LevelExperience = 2600;
}, {
	Id = 17;
	Attr = {{38, 777}, {43, 31}};
	LevelExperience = 3000;
}, {
	Id = 18;
	Attr = {{38, 841}, {43, 33}};
	LevelExperience = 3400;
}, {
	Id = 19;
	Attr = {{38, 907}, {43, 35}};
	LevelExperience = 3800;
}, {
	Id = 20;
	Attr = {{38, 975}, {43, 37}};
	LevelExperience = 4200;
}, {
	Id = 21;
	Attr = {{38, 1064}, {43, 40}};
	LevelExperience = 4800;
}, {
	Id = 22;
	Attr = {{38, 1155}, {43, 42}};
	LevelExperience = 5400;
}, {
	Id = 23;
	Attr = {{38, 1249}, {43, 45}};
	LevelExperience = 6000;
}, {
	Id = 24;
	Attr = {{38, 1346}, {43, 48}};
	LevelExperience = 6600;
}, {
	Id = 25;
	Attr = {{38, 1446}, {43, 51}};
	LevelExperience = 7200;
}, {
	Id = 26;
	Attr = {{38, 1573}, {43, 54}};
	LevelExperience = 8100;
}, {
	Id = 27;
	Attr = {{38, 1703}, {43, 57}};
	LevelExperience = 9000;
}, {
	Id = 28;
	Attr = {{38, 1837}, {43, 60}};
	LevelExperience = 9900;
}, {
	Id = 29;
	Attr = {{38, 1975}, {43, 64}};
	LevelExperience = 10800;
}, {
	Id = 30;
	Attr = {{38, 2116}, {43, 67}};
	LevelExperience = 11700;
}, {
	Id = 31;
	Attr = {{38, 2272}, {43, 71}};
	LevelExperience = 13200;
}, {
	Id = 32;
	Attr = {{38, 2432}, {43, 75}};
	LevelExperience = 14700;
}, {
	Id = 33;
	Attr = {{38, 2596}, {43, 79}};
	LevelExperience = 16200;
}, {
	Id = 34;
	Attr = {{38, 2764}, {43, 84}};
	LevelExperience = 17700;
}, {
	Id = 35;
	Attr = {{38, 2936}, {43, 88}};
	LevelExperience = 19200;
}, {
	Id = 36;
	Attr = {{38, 3140}, {43, 93}};
	LevelExperience = 24200;
}, {
	Id = 37;
	Attr = {{38, 3348}, {43, 98}};
	LevelExperience = 29200;
}, {
	Id = 38;
	Attr = {{38, 3561}, {43, 103}};
	LevelExperience = 34200;
}, {
	Id = 39;
	Attr = {{38, 3779}, {43, 109}};
	LevelExperience = 39200;
}, {
	Id = 40;
	Attr = {{38, 4002}, {43, 114}};
	LevelExperience = 44200;
}, {
	Id = 41;
	Attr = {{38, 4261}, {43, 121}};
	LevelExperience = 52200;
}, {
	Id = 42;
	Attr = {{38, 4525}, {43, 127}};
	LevelExperience = 60200;
}, {
	Id = 43;
	Attr = {{38, 4795}, {43, 134}};
	LevelExperience = 68200;
}, {
	Id = 44;
	Attr = {{38, 5071}, {43, 141}};
	LevelExperience = 76200;
}, {
	Id = 45;
	Attr = {{38, 5352}, {43, 148}};
	LevelExperience = 84200;
}, {
	Id = 46;
	Attr = {{38, 5674}, {43, 156}};
	LevelExperience = 99200;
}, {
	Id = 47;
	Attr = {{38, 6002}, {43, 164}};
	LevelExperience = 114200;
}, {
	Id = 48;
	Attr = {{38, 6337}, {43, 173}};
	LevelExperience = 129200;
}, {
	Id = 49;
	Attr = {{38, 6716}, {43, 182}};
	LevelExperience = 144200;
}, {
	Id = 50;
	Attr = {{38, 7102}, {43, 192}};
	LevelExperience = 159200;
}, {
	Id = 51;
	Attr = {{38, 7495}, {43, 202}};
	LevelExperience = 179200;
}, {
	Id = 52;
	Attr = {{38, 7935}, {43, 213}};
	LevelExperience = 199200;
}, {
	Id = 53;
	Attr = {{38, 8383}, {43, 224}};
	LevelExperience = 219200;
}, {
	Id = 54;
	Attr = {{38, 8839}, {43, 235}};
	LevelExperience = 239200;
}, {
	Id = 55;
	Attr = {{38, 9388}, {43, 249}};
	LevelExperience = 259200;
}, {
	Id = 56;
	Attr = {{38, 9947}, {43, 263}};
	LevelExperience = 284200;
}, {
	Id = 57;
	Attr = {{38, 10515}, {43, 277}};
	LevelExperience = 309200;
}, {
	Id = 58;
	Attr = {{38, 11093}, {43, 292}};
	LevelExperience = 334200;
}, {
	Id = 59;
	Attr = {{38, 11681}, {43, 306}};
	LevelExperience = 359200;
}, {
	Id = 60;
	Attr = {{38, 12417}, {43, 325}};
	LevelExperience = 384200;
}, {
	Id = 61;
	Attr = {{38, 13165}, {43, 343}};
	LevelExperience = 419200;
}, {
	Id = 62;
	Attr = {{38, 13925}, {43, 362}};
	LevelExperience = 454200;
}, {
	Id = 63;
	Attr = {{38, 14697}, {43, 382}};
	LevelExperience = 489200;
}, {
	Id = 64;
	Attr = {{38, 15481}, {43, 401}};
	LevelExperience = 524200;
}, {
	Id = 65;
	Attr = {{38, 16403}, {43, 424}};
	LevelExperience = 559200;
}, {
	Id = 66;
	Attr = {{38, 17339}, {43, 448}};
	LevelExperience = 604200;
}, {
	Id = 67;
	Attr = {{38, 18289}, {43, 471}};
	LevelExperience = 649200;
}, {
	Id = 68;
	Attr = {{38, 19253}, {43, 496}};
	LevelExperience = 694200;
}, {
	Id = 69;
	Attr = {{38, 20365}, {43, 523}};
	LevelExperience = 739200;
}, {
	Id = 70;
	Attr = {{38, 21493}, {43, 552}};
	LevelExperience = 784200;
}, {
	Id = 71;
	Attr = {{38, 22637}, {43, 580}};
	LevelExperience = 844200;
}, {
	Id = 72;
	Attr = {{38, 23797}, {43, 609}};
	LevelExperience = 904200;
}, {
	Id = 73;
	Attr = {{38, 24973}, {43, 639}};
	LevelExperience = 964200;
}, {
	Id = 74;
	Attr = {{38, 26165}, {43, 668}};
	LevelExperience = 1024200;
}, {
	Id = 75;
	Attr = {{38, 27373}, {43, 699}};
	LevelExperience = 1084200;
}, {
	Id = 76;
	Attr = {{38, 28893}, {43, 737}};
	LevelExperience = 1164200;
}, {
	Id = 77;
	Attr = {{38, 30433}, {43, 775}};
	LevelExperience = 1244200;
}, {
	Id = 78;
	Attr = {{38, 31993}, {43, 814}};
	LevelExperience = 1324200;
}, {
	Id = 79;
	Attr = {{38, 33573}, {43, 854}};
	LevelExperience = 1404200;
}, {
	Id = 80;
	Attr = {{38, 35173}, {43, 894}};
	LevelExperience = 1484200;
}, {
	Id = 81;
	Attr = {{38, 37267}, {43, 946}};
	LevelExperience = 1584200;
}, {
	Id = 82;
	Attr = {{38, 39387}, {43, 999}};
	LevelExperience = 1684200;
}, {
	Id = 83;
	Attr = {{38, 41533}, {43, 1053}};
	LevelExperience = 1784200;
}, {
	Id = 84;
	Attr = {{38, 43705}, {43, 1107}};
	LevelExperience = 1884200;
}, {
	Id = 85;
	Attr = {{38, 45903}, {43, 1162}};
	LevelExperience = 1984200;
}, {
	Id = 86;
	Attr = {{38, 48799}, {43, 1234}};
	LevelExperience = 2109200;
}, {
	Id = 87;
	Attr = {{38, 51729}, {43, 1307}};
	LevelExperience = 2234200;
}, {
	Id = 88;
	Attr = {{38, 54693}, {43, 1382}};
	LevelExperience = 2359200;
}, {
	Id = 89;
	Attr = {{38, 57691}, {43, 1456}};
	LevelExperience = 2484200;
}, {
	Id = 90;
	Attr = {{38, 60723}, {43, 1532}};
	LevelExperience = 2609200;
}, {
	Id = 91;
	Attr = {{38, 63789}, {43, 1609}};
	LevelExperience = 2759200;
}, {
	Id = 92;
	Attr = {{38, 66889}, {43, 1686}};
	LevelExperience = 2909200;
}, {
	Id = 93;
	Attr = {{38, 70023}, {43, 1765}};
	LevelExperience = 3059200;
}, {
	Id = 94;
	Attr = {{38, 73191}, {43, 1844}};
	LevelExperience = 3209200;
}, {
	Id = 95;
	Attr = {{38, 76391}, {43, 1924}};
	LevelExperience = 3359200;
}, {
	Id = 96;
	Attr = {{38, 79591}, {43, 2004}};
	LevelExperience = 3659200;
}, {
	Id = 97;
	Attr = {{38, 82791}, {43, 2084}};
	LevelExperience = 3959200;
}, {
	Id = 98;
	Attr = {{38, 85991}, {43, 2164}};
	LevelExperience = 4259200;
}, {
	Id = 99;
	Attr = {{38, 89191}, {43, 2244}};
	LevelExperience = 4559200;
}, {
	Id = 100;
	Attr = {{38, 92391}, {43, 2324}};
	LevelExperience = 4859200;
}, {
	Id = 101;
	Attr = {{38, 95591}, {43, 2404}};
	LevelExperience = 5359200;
}, {
	Id = 102;
	Attr = {{38, 98791}, {43, 2484}};
	LevelExperience = 5859200;
}, {
	Id = 103;
	Attr = {{38, 101991}, {43, 2564}};
	LevelExperience = 6359200;
}, {
	Id = 104;
	Attr = {{38, 105191}, {43, 2644}};
	LevelExperience = 6859200;
}, {
	Id = 105;
	Attr = {{38, 108391}, {43, 2724}};
	LevelExperience = 7359200;
}, {
	Id = 106;
	Attr = {{38, 111591}, {43, 2804}};
	LevelExperience = 8159200;
}, {
	Id = 107;
	Attr = {{38, 114791}, {43, 2884}};
	LevelExperience = 8959200;
}, {
	Id = 108;
	Attr = {{38, 117991}, {43, 2964}};
	LevelExperience = 9759200;
}, {
	Id = 109;
	Attr = {{38, 121191}, {43, 3044}};
	LevelExperience = 10559200;
}, {
	Id = 110;
	Attr = {{38, 124391}, {43, 3124}};
	LevelExperience = 11359200;
}, {
	Id = 111;
	Attr = {{38, 127591}, {43, 3204}};
	LevelExperience = 12859200;
}, {
	Id = 112;
	Attr = {{38, 130791}, {43, 3284}};
	LevelExperience = 14359200;
}, {
	Id = 113;
	Attr = {{38, 133991}, {43, 3364}};
	LevelExperience = 15859200;
}, {
	Id = 114;
	Attr = {{38, 137191}, {43, 3444}};
	LevelExperience = 17359200;
}, {
	Id = 115;
	Attr = {{38, 140391}, {43, 3524}};
	LevelExperience = 18859200;
}, {
	Id = 116;
	Attr = {{38, 143591}, {43, 3604}};
	LevelExperience = 21859200;
}, {
	Id = 117;
	Attr = {{38, 146791}, {43, 3684}};
	LevelExperience = 24859200;
}, {
	Id = 118;
	Attr = {{38, 149991}, {43, 3764}};
	LevelExperience = 27859200;
}, {
	Id = 119;
	Attr = {{38, 153191}, {43, 3844}};
	LevelExperience = 30859200;
}, {
	Id = 120;
	Attr = {{38, 156391}, {43, 3924}};
	LevelExperience = 33859200;
}}







-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-11 04:19:19
-- Luau version 6, Types version 3
-- Time taken: 0.008600 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local module_upvr = require(ReplicatedStorage:WaitForChild("Tools"):WaitForChild("Script"):WaitForChild("ErrorCode"))
local any_New_result1 = require(ReplicatedStorage:WaitForChild("Level"):WaitForChild("Script"):WaitForChild("LevelBaseClass")):New()
function any_New_result1.GetPlayerLevel(arg1, arg2) -- Line 19
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if typeof(arg2) ~= "Instance" or arg2:IsA("Player") == false then
		warn("获取玩家等级时玩家参数错误！")
		warn(arg2)
		warn(typeof(arg2))
		return module_upvr.FUNCTION_PARAM_ERROR
	end
	local Configuration_2 = arg2:FindFirstChild("Configuration")
	if not Configuration_2 then
		warn("[GetPlayerLevel] 玩家缺少 Configuration:", arg2.Name)
		return module_upvr.FAILED
	end
	local Level_3 = Configuration_2:FindFirstChild("Level")
	if Level_3 == nil then
		warn("客户端获取玩家等级时LevelInstance不存在！！！")
		return module_upvr.FAILED
	end
	local Level_4 = Level_3:GetAttribute("Level")
	if Level_4 == nil then
		warn("客户端获取玩家等级时Level属性尚未初始化")
		return module_upvr.FAILED
	end
	return module_upvr.SUCCEEDED, Level_4
end
function any_New_result1.GetPlayerExperience(arg1, arg2) -- Line 45
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if typeof(arg2) ~= "Instance" or arg2:IsA("Player") == false then
		warn("获取玩家经验时玩家参数错误！")
		warn(arg2)
		warn(typeof(arg2))
		return module_upvr.FUNCTION_PARAM_ERROR
	end
	local Configuration_4 = arg2:FindFirstChild("Configuration")
	if not Configuration_4 then
		warn("[GetPlayerExperience] 玩家缺少 Configuration:", arg2.Name)
		return module_upvr.FAILED
	end
	local Level_5 = Configuration_4:FindFirstChild("Level")
	if Level_5 == nil then
		warn("客户端获取玩家经验时LevelInstance不存在！！！")
		return module_upvr.FAILED
	end
	local Experience = Level_5:GetAttribute("Experience")
	if Experience == nil then
		warn("客户端获取玩家经验时Experience属性尚未初始化")
		return module_upvr.FAILED
	end
	return module_upvr.SUCCEEDED, Experience
end
function any_New_result1.GetPlayerLevelData(arg1, arg2) -- Line 70
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if typeof(arg2) ~= "Instance" or arg2:IsA("Player") == false then
		warn(" 获取玩家等级数据时玩家参数错误！")
		warn(arg2)
		warn(typeof(arg2))
		return module_upvr.FUNCTION_PARAM_ERROR
	end
	local Configuration = arg2:FindFirstChild("Configuration")
	if not Configuration then
		warn("[GetPlayerLevelData] 玩家缺少 Configuration:", arg2.Name)
		return module_upvr.FAILED
	end
	local Level_7 = Configuration:FindFirstChild("Level")
	if Level_7 == nil then
		warn("获取玩家等级数据时LevelInstance不存在！！！")
		return module_upvr.FAILED
	end
	local Level = Level_7:GetAttribute("Level")
	local Experience_2 = Level_7:GetAttribute("Experience")
	if Level == nil or Experience_2 == nil then
		warn("等级数据尚未初始化")
		return module_upvr.FAILED
	end
	return module_upvr.SUCCEEDED, {
		Level = Level;
		Experience = Experience_2;
	}
end
function any_New_result1.IsLoadLevelDataSucc(arg1, arg2) -- Line 98
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if typeof(arg2) ~= "Instance" or arg2:IsA("Player") == false then
		warn(" 获取玩家等级数据时玩家参数错误！")
		warn(arg2)
		warn(typeof(arg2))
		return module_upvr.FUNCTION_PARAM_ERROR
	end
	local Configuration_3 = arg2:FindFirstChild("Configuration")
	if not Configuration_3 then
		warn("[IsLoadLevelDataSucc] 玩家缺少 Configuration:", arg2.Name)
		return module_upvr.FAILED
	end
	local Level_2 = Configuration_3:FindFirstChild("Level")
	local var21 = false
	if Level_2 ~= nil then
		var21 = false
		if Level_2:GetAttribute("Level") ~= nil then
			if Level_2:GetAttribute("Experience") == nil then
				var21 = false
			else
				var21 = true
			end
		end
	end
	return module_upvr.SUCCEEDED, var21
end
return any_New_result1







-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-11 03:53:36
-- Luau version 6, Types version 3
-- Time taken: 0.002555 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Script = ReplicatedStorage:WaitForChild("Tools"):WaitForChild("Script")
local PremiumCurrency = ReplicatedStorage:WaitForChild("PremiumCurrency")
local Bindable = PremiumCurrency:WaitForChild("Bindable")
local Remote = PremiumCurrency:WaitForChild("Remote")
local any_New_result1_upvr = require(PremiumCurrency:WaitForChild("Script"):WaitForChild("PremiumCurrencyClientClass")):New()
local PremiumCurrencyHasChanged_upvr = Bindable:WaitForChild("PremiumCurrencyHasChanged")
Remote:WaitForChild("PremiumCurrencyHasChanged").OnClientEvent:Connect(function(arg1, arg2, arg3, arg4, arg5) -- Line 30
	--[[ Upvalues[1]:
		[1]: PremiumCurrencyHasChanged_upvr (readonly)
	]]
	PremiumCurrencyHasChanged_upvr:Fire(arg1, arg2, arg3, arg4, arg5)
end)
local PremiumCurrencyMaxNumHasChanged_upvr = Bindable:WaitForChild("PremiumCurrencyMaxNumHasChanged")
Remote:WaitForChild("PremiumCurrencyMaxNumHasChanged").OnClientEvent:Connect(function(arg1, arg2, arg3) -- Line 34
	--[[ Upvalues[1]:
		[1]: PremiumCurrencyMaxNumHasChanged_upvr (readonly)
	]]
	PremiumCurrencyMaxNumHasChanged_upvr:Fire(arg1, arg2, arg3)
end)
Bindable:WaitForChild("GetPremiumCurrencyNum").OnInvoke = function(arg1, arg2) -- Line 38
	--[[ Upvalues[1]:
		[1]: any_New_result1_upvr (readonly)
	]]
	return any_New_result1_upvr:GetPremiumCurrencyNum(arg1, arg2)
end
Bindable:WaitForChild("GetPremiumCurrencyMaxNum").OnInvoke = function(arg1, arg2) -- Line 42
	--[[ Upvalues[1]:
		[1]: any_New_result1_upvr (readonly)
	]]
	return any_New_result1_upvr:GetPremiumCurrencyMaxNum(arg1, arg2)
end











-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-11 03:53:36
-- Luau version 6, Types version 3
-- Time taken: 0.002555 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Script = ReplicatedStorage:WaitForChild("Tools"):WaitForChild("Script")
local PremiumCurrency = ReplicatedStorage:WaitForChild("PremiumCurrency")
local Bindable = PremiumCurrency:WaitForChild("Bindable")
local Remote = PremiumCurrency:WaitForChild("Remote")
local any_New_result1_upvr = require(PremiumCurrency:WaitForChild("Script"):WaitForChild("PremiumCurrencyClientClass")):New()
local PremiumCurrencyHasChanged_upvr = Bindable:WaitForChild("PremiumCurrencyHasChanged")
Remote:WaitForChild("PremiumCurrencyHasChanged").OnClientEvent:Connect(function(arg1, arg2, arg3, arg4, arg5) -- Line 30
	--[[ Upvalues[1]:
		[1]: PremiumCurrencyHasChanged_upvr (readonly)
	]]
	PremiumCurrencyHasChanged_upvr:Fire(arg1, arg2, arg3, arg4, arg5)
end)
local PremiumCurrencyMaxNumHasChanged_upvr = Bindable:WaitForChild("PremiumCurrencyMaxNumHasChanged")
Remote:WaitForChild("PremiumCurrencyMaxNumHasChanged").OnClientEvent:Connect(function(arg1, arg2, arg3) -- Line 34
	--[[ Upvalues[1]:
		[1]: PremiumCurrencyMaxNumHasChanged_upvr (readonly)
	]]
	PremiumCurrencyMaxNumHasChanged_upvr:Fire(arg1, arg2, arg3)
end)
Bindable:WaitForChild("GetPremiumCurrencyNum").OnInvoke = function(arg1, arg2) -- Line 38
	--[[ Upvalues[1]:
		[1]: any_New_result1_upvr (readonly)
	]]
	return any_New_result1_upvr:GetPremiumCurrencyNum(arg1, arg2)
end
Bindable:WaitForChild("GetPremiumCurrencyMaxNum").OnInvoke = function(arg1, arg2) -- Line 42
	--[[ Upvalues[1]:
		[1]: any_New_result1_upvr (readonly)
	]]
	return any_New_result1_upvr:GetPremiumCurrencyMaxNum(arg1, arg2)
end
















-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-11 03:52:58
-- Luau version 6, Types version 3
-- Time taken: 0.003159 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local module_upvr = require(ReplicatedStorage:WaitForChild("Tools"):WaitForChild("Script"):WaitForChild("ErrorCode"))
local any_New_result1 = require(ReplicatedStorage:WaitForChild("PremiumCurrency"):WaitForChild("Script"):WaitForChild("PremiumCurrencyBaseClass")):New()
function any_New_result1.GetPremiumCurrencyNum(arg1, arg2, arg3) -- Line 21
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if typeof(arg2) ~= "Instance" or arg2:IsA("Player") == false or typeof(arg3) ~= "string" then
		warn("Player", arg2, typeof(arg2))
		warn("PremiumCurrencyId", arg3, typeof(arg3))
		return module_upvr.FUNCTION_PARAM_ERROR
	end
	return module_upvr.SUCCEEDED, arg2:WaitForChild("Configuration"):WaitForChild("PremiumCurrencyList"):WaitForChild(arg3):GetAttribute("CurrNum")
end
function any_New_result1.GetPremiumCurrencyMaxNum(arg1, arg2, arg3) -- Line 35
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if typeof(arg2) ~= "Instance" or arg2:IsA("Player") == false or typeof(arg3) ~= "string" then
		warn("Player", arg2, typeof(arg2))
		warn("PremiumCurrencyId", arg3, typeof(arg3))
		return module_upvr.FUNCTION_PARAM_ERROR
	end
	return module_upvr.SUCCEEDED, arg2:WaitForChild("Configuration"):WaitForChild("PremiumCurrencyList"):WaitForChild(arg3):GetAttribute("MaxNum")
end
return any_New_result1









-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-11 03:52:02
-- Luau version 6, Types version 3
-- Time taken: 0.014268 seconds

local Script = game:GetService("ReplicatedStorage"):WaitForChild("Tools"):WaitForChild("Script")
return {
	New = function(arg1) -- Line 16, Named "New"
		local module = {}
		arg1.__index = arg1
		setmetatable(module, arg1)
		return module
	end;
}











-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-11 03:51:17
-- Luau version 6, Types version 3
-- Time taken: 0.002780 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Script = ReplicatedStorage:WaitForChild("Tools"):WaitForChild("Script")
local PremiumCurrency = ReplicatedStorage:WaitForChild("PremiumCurrency")
local Bindable = PremiumCurrency:WaitForChild("Bindable")
local Remote = PremiumCurrency:WaitForChild("Remote")
local any_New_result1_upvr = require(PremiumCurrency:WaitForChild("Script"):WaitForChild("PremiumCurrencyClientClass")):New()
local PremiumCurrencyHasChanged_upvr = Bindable:WaitForChild("PremiumCurrencyHasChanged")
Remote:WaitForChild("PremiumCurrencyHasChanged").OnClientEvent:Connect(function(arg1, arg2, arg3, arg4, arg5) -- Line 30
	--[[ Upvalues[1]:
		[1]: PremiumCurrencyHasChanged_upvr (readonly)
	]]
	PremiumCurrencyHasChanged_upvr:Fire(arg1, arg2, arg3, arg4, arg5)
end)
local PremiumCurrencyMaxNumHasChanged_upvr = Bindable:WaitForChild("PremiumCurrencyMaxNumHasChanged")
Remote:WaitForChild("PremiumCurrencyMaxNumHasChanged").OnClientEvent:Connect(function(arg1, arg2, arg3) -- Line 34
	--[[ Upvalues[1]:
		[1]: PremiumCurrencyMaxNumHasChanged_upvr (readonly)
	]]
	PremiumCurrencyMaxNumHasChanged_upvr:Fire(arg1, arg2, arg3)
end)
Bindable:WaitForChild("GetPremiumCurrencyNum").OnInvoke = function(arg1, arg2) -- Line 38
	--[[ Upvalues[1]:
		[1]: any_New_result1_upvr (readonly)
	]]
	return any_New_result1_upvr:GetPremiumCurrencyNum(arg1, arg2)
end
Bindable:WaitForChild("GetPremiumCurrencyMaxNum").OnInvoke = function(arg1, arg2) -- Line 42
	--[[ Upvalues[1]:
		[1]: any_New_result1_upvr (readonly)
	]]
	return any_New_result1_upvr:GetPremiumCurrencyMaxNum(arg1, arg2)
end











-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-11 03:49:24
-- Luau version 6, Types version 3
-- Time taken: 0.000947 seconds

return table.freeze({
	['1'] = {
		Name = "Gems";
		Quality = 4;
		Icon = "rbxassetid://98185521336221";
		Describe = "";
		Origin = "";
	};
	['2'] = {
		Name = "Abyss Coins";
		Quality = 5;
		Icon = "rbxassetid://76691625133482";
		Describe = "";
		Origin = "";
	};
})













-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-11 03:45:48
-- Luau version 6, Types version 3
-- Time taken: 0.004459 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Script = ReplicatedStorage:WaitForChild("UIModules"):WaitForChild("Script")
local Config = ReplicatedStorage:WaitForChild("EquipmentSystem"):WaitForChild("Config")
local Parent = script.Parent
local TextInfo_upvr = Parent:WaitForChild("TextInfo")
local any_New_result1 = require(ReplicatedStorage:WaitForChild("UI"):WaitForChild("Script"):WaitForChild("UIScrollViewItem")):New()
function any_New_result1.OnCreate(arg1) -- Line 52
end
local var9_upvw
local LevelImg_upvr = Parent:WaitForChild("LevelImg")
local HoleImg_upvr = Parent:WaitForChild("HoleImg")
local module_upvr_3 = require(Config:WaitForChild("TraitConfig"))
local module_upvr = require(Config:WaitForChild("TraitRatingDisplay"))
local module_upvr_2 = require(ReplicatedStorage:WaitForChild("Tools"):WaitForChild("Script"):WaitForChild("EnumCode"))
function any_New_result1.OnEnabled(arg1) -- Line 59
	--[[ Upvalues[7]:
		[1]: var9_upvw (read and write)
		[2]: LevelImg_upvr (readonly)
		[3]: HoleImg_upvr (readonly)
		[4]: module_upvr_3 (readonly)
		[5]: module_upvr (readonly)
		[6]: module_upvr_2 (readonly)
		[7]: TextInfo_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 17 start (CF ANALYSIS FAILED)
	var9_upvw = arg1.UserData
	local var15
	if var9_upvw.TraitId then
		var15 = true
		LevelImg_upvr.Visible = var15
		var15 = false
		HoleImg_upvr.Visible = var15
		var15 = module_upvr_3[var9_upvw.TraitId]
		local Rating = var15.Rating
		var15 = LevelImg_upvr
		var15.Image = module_upvr[Rating].Icon
		var15 = nil
		if module_upvr_3[var9_upvw.TraitId].TraitType == module_upvr_2.TraitType.Percentage then
			var15 = tostring(var9_upvw.AttrValue / 100)..'%'
		else
			var15 = tostring(var9_upvw.AttrValue)
		end
		TextInfo_upvr.Text = module_upvr_3[var9_upvw.TraitId].Name..' '..var15
		if module_upvr[Rating].Color and module_upvr[Rating] ~= "" then
			-- KONSTANTWARNING: GOTO [99] #75
		end
	else
		var15 = false
		LevelImg_upvr.Visible = var15
		var15 = true
		HoleImg_upvr.Visible = var15
		var15 = ""
		TextInfo_upvr.Text = var15
	end
	-- KONSTANTERROR: [0] 1. Error Block 17 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [99] 75. Error Block 11 start (CF ANALYSIS FAILED)
	RefreshContent()
	-- KONSTANTERROR: [99] 75. Error Block 11 end (CF ANALYSIS FAILED)
end
function RefreshContent() -- Line 89
end
return any_New_result1














-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-11 03:45:12
-- Luau version 6, Types version 3
-- Time taken: 0.005030 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Script = ReplicatedStorage:WaitForChild("UI"):WaitForChild("Script")
local _ = ReplicatedStorage:WaitForChild("UIModules"):WaitForChild("Script")
local _ = ReplicatedStorage:WaitForChild("Tools"):WaitForChild("Script")
local Config = ReplicatedStorage:WaitForChild("GameItem"):WaitForChild("Config")
local module_upvr = require(Config:WaitForChild("GameItemInfoConfig"))
local Parent = script.Parent
local WeaponTextFrame_upvr = Parent:WaitForChild("WeaponTextFrame")
local ChooseButton_upvr = Parent:WaitForChild("Frame"):WaitForChild("ChooseButton")
local Icon_upvr = ChooseButton_upvr:WaitForChild("Icon")
local UIStroke_upvr = ChooseButton_upvr:WaitForChild("UIStroke")
local var12_upvw
local var13_upvw
local any_New_result1_upvw = require(Script:WaitForChild("UIScrollViewItem")):New()
local module_upvr_3 = require(Script:WaitForChild("UIScrollView"))
local WeaponTextItem_upvr = WeaponTextFrame_upvr:WaitForChild("WeaponTextItem")
function any_New_result1_upvw.OnCreate(arg1) -- Line 69
	--[[ Upvalues[6]:
		[1]: var12_upvw (read and write)
		[2]: module_upvr_3 (readonly)
		[3]: any_New_result1_upvw (read and write)
		[4]: WeaponTextFrame_upvr (readonly)
		[5]: WeaponTextItem_upvr (readonly)
		[6]: ChooseButton_upvr (readonly)
	]]
	var12_upvw = module_upvr_3:New(any_New_result1_upvw, {
		ScrollParent = WeaponTextFrame_upvr;
		ViewItemScriptName = "WeaponTextItemScript";
		ViewItemInstance = WeaponTextItem_upvr;
	})
	ChooseButton_upvr.MouseButton1Click:Connect(OnClickChooseButton)
end
local Transparency_upvr = UIStroke_upvr.Transparency
local DMGText_upvr = Icon_upvr:WaitForChild("DMGText")
local LevelImage_upvr = ChooseButton_upvr:WaitForChild("LevelImage")
local module_upvr_2 = require(Config:WaitForChild("GameItemQualityColorConfig"))
function any_New_result1_upvw.OnEnabled(arg1) -- Line 82
	--[[ Upvalues[8]:
		[1]: var13_upvw (read and write)
		[2]: UIStroke_upvr (readonly)
		[3]: Transparency_upvr (readonly)
		[4]: Icon_upvr (readonly)
		[5]: DMGText_upvr (readonly)
		[6]: module_upvr (readonly)
		[7]: LevelImage_upvr (readonly)
		[8]: module_upvr_2 (readonly)
	]]
	var13_upvw = arg1.UserData
	if var13_upvw.CurrWeaponIndex == var13_upvw.Index then
		UIStroke_upvr.Transparency = 0
	else
		UIStroke_upvr.Transparency = Transparency_upvr
	end
	Icon_upvr.Image = var13_upvw.Image
	DMGText_upvr.Text = var13_upvw.DMG
	LevelImage_upvr.Image = module_upvr_2[module_upvr[var13_upvw.Id].Quality].BackgroundIcon
	RefreshContent()
end
function OnClickChooseButton() -- Line 104
	--[[ Upvalues[2]:
		[1]: any_New_result1_upvw (read and write)
		[2]: var13_upvw (read and write)
	]]
	any_New_result1_upvw:InvokeEvent("OnChooseWeapon", var13_upvw.Index)
end
function RefreshContent() -- Line 111
	RefreshTextInfo()
end
function RefreshTextInfo() -- Line 117
	--[[ Upvalues[3]:
		[1]: var13_upvw (read and write)
		[2]: module_upvr (readonly)
		[3]: var12_upvw (read and write)
	]]
	local tbl = {}
	local var27 = 1
	for _, v in pairs(var13_upvw.ExtraInfo.TraitList) do
		tbl[var27] = {}
		tbl[var27].TraitId = v.TraitId
		tbl[var27].AttrValue = v.AttrValue
		var27 += 1
	end
	while #tbl < module_upvr[var13_upvw.Id].HolesNum do
		table.insert(tbl, {})
	end
	var12_upvw:Create(tbl)
end
return any_New_result1_upvw












-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-11 03:44:30
-- Luau version 6, Types version 3
-- Time taken: 0.003725 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Script = ReplicatedStorage:WaitForChild("UIModules"):WaitForChild("Script")
local Config = ReplicatedStorage:WaitForChild("GameItem"):WaitForChild("Config")
local ChooseButton_upvr = script.Parent:WaitForChild("Frame"):WaitForChild("ChooseButton")
local var7_upvw
local any_New_result1_upvw = require(ReplicatedStorage:WaitForChild("UI"):WaitForChild("Script"):WaitForChild("UIScrollViewItem")):New()
function any_New_result1_upvw.OnCreate(arg1) -- Line 59
	--[[ Upvalues[1]:
		[1]: ChooseButton_upvr (readonly)
	]]
	ChooseButton_upvr.MouseButton1Click:Connect(OnClickChooseButton)
end
function any_New_result1_upvw.OnEnabled(arg1) -- Line 69
	--[[ Upvalues[1]:
		[1]: var7_upvw (read and write)
	]]
	var7_upvw = arg1.UserData
	RefreshContent()
end
function OnClickChooseButton() -- Line 78
	--[[ Upvalues[2]:
		[1]: any_New_result1_upvw (read and write)
		[2]: var7_upvw (read and write)
	]]
	any_New_result1_upvw:InvokeEvent("OnChooseSocketMat", var7_upvw.Id, nil, var7_upvw.SocketId)
end
local Cover_upvr = ChooseButton_upvr:WaitForChild("Cover")
local UIStroke_upvr = ChooseButton_upvr:WaitForChild("StrokeBack"):WaitForChild("UIStroke")
local Num_upvr = ChooseButton_upvr:WaitForChild("Num")
local module_upvr_3 = require(ReplicatedStorage:WaitForChild("Tools"):WaitForChild("Script"):WaitForChild("CommonToolFunc"))
local Icon_upvr = ChooseButton_upvr:WaitForChild("Icon")
local module_upvr_2 = require(Config:WaitForChild("GameItemInfoConfig"))
local Background_upvr = ChooseButton_upvr:WaitForChild("Background")
local module_upvr = require(Config:WaitForChild("GameItemQualityColorConfig"))
function RefreshContent() -- Line 85
	--[[ Upvalues[9]:
		[1]: var7_upvw (read and write)
		[2]: Cover_upvr (readonly)
		[3]: UIStroke_upvr (readonly)
		[4]: Num_upvr (readonly)
		[5]: module_upvr_3 (readonly)
		[6]: Icon_upvr (readonly)
		[7]: module_upvr_2 (readonly)
		[8]: Background_upvr (readonly)
		[9]: module_upvr (readonly)
	]]
	if var7_upvw.IsSelected then
		Cover_upvr.Visible = false
		UIStroke_upvr.Enabled = true
		UIStroke_upvr.Transparency = 0
	else
		Cover_upvr.Visible = false
		UIStroke_upvr.Enabled = true
		UIStroke_upvr.Transparency = 1
	end
	Num_upvr.Text = module_upvr_3:GetShowNum(var7_upvw.Num)
	Icon_upvr.Image = module_upvr_2[var7_upvw.Id].Icon
	Background_upvr.Image = module_upvr[module_upvr_2[var7_upvw.Id].Quality].BackgroundIcon
end
return any_New_result1_upvw



















-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-11 03:43:49
-- Luau version 6, Types version 3
-- Time taken: 0.010754 seconds

local Players_upvr = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = ReplicatedStorage:WaitForChild("UIModules"):WaitForChild("Script")
local Script = ReplicatedStorage:WaitForChild("Tools"):WaitForChild("Script")
local module_upvr_2 = require(ReplicatedStorage:WaitForChild("Shop"):WaitForChild("Script"):WaitForChild("ShopController"))
local module_upvr = require(script:FindFirstAncestor("ShopGui"):FindFirstChild("ShopAnimation"))
local GridFrame = script.Parent:WaitForChild("GridFrame")
local UIGradient_upvr_2 = GridFrame:WaitForChild("UIGradient")
local UIGradient_upvr = GridFrame:WaitForChild("UIStroke"):WaitForChild("UIGradient")
local BuyFrame = GridFrame:WaitForChild("BuyFrame")
local BuyButton_upvr = BuyFrame:WaitForChild("BuyButton")
local Icon_upvr = GridFrame:WaitForChild("Icon")
local NameText_upvr = GridFrame:WaitForChild("NameText")
local Position_upvr = Icon_upvr.Position
local var17_upvw
local var18_upvw
local var19_upvw
local var20_upvw
local any_New_result1_upvr = require(ReplicatedStorage:WaitForChild("UI"):WaitForChild("Script"):WaitForChild("UIScrollViewItem")):New()
local TweenService_upvr = game:GetService("TweenService")
local function PlayerEffectTween_upvr(arg1) -- Line 83, Named "PlayerEffectTween"
	--[[ Upvalues[1]:
		[1]: TweenService_upvr (readonly)
	]]
	if not arg1 then
	else
		if EffectTweenRunning then return end
		EffectTweenRunning = true -- Setting global
		local TweenInfo_new_result1_upvr_2 = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		local TweenInfo_new_result1_upvr = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		task.spawn(function() -- Line 104
			--[[ Upvalues[4]:
				[1]: TweenService_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: TweenInfo_new_result1_upvr_2 (readonly)
				[4]: TweenInfo_new_result1_upvr (readonly)
			]]
			while EffectTweenRunning do
				EffectTween = TweenService_upvr:Create(arg1, TweenInfo_new_result1_upvr_2, {
					ImageTransparency = 0;
				}) -- Setting global
				EffectTween:Play()
				EffectTween.Completed:Wait()
				if not EffectTweenRunning then break end
				EffectTween = TweenService_upvr:Create(arg1, TweenInfo_new_result1_upvr, {
					ImageTransparency = 1;
				}) -- Setting global
				EffectTween:Play()
				EffectTween.Completed:Wait()
			end
		end)
	end
end
local GiftButton_upvr = GridFrame:WaitForChild("GiftFrame"):WaitForChild("GiftButton")
function any_New_result1_upvr.OnCreate(arg1) -- Line 124
	--[[ Upvalues[2]:
		[1]: BuyButton_upvr (readonly)
		[2]: GiftButton_upvr (readonly)
	]]
	BuyButton_upvr.MouseButton1Click:Connect(BuyThings)
	GiftButton_upvr.MouseButton1Click:Connect(GiftThings)
end
function OnEnterBuyBtn() -- Line 131
	--[[ Upvalues[3]:
		[1]: Position_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Icon_upvr (readonly)
	]]
	module_upvr:DoIconMoveUp(Icon_upvr, Position_upvr)
end
function OnLeaveBuyBtn() -- Line 136
	--[[ Upvalues[3]:
		[1]: Position_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Icon_upvr (readonly)
	]]
	module_upvr:DoIconMoveDown(Icon_upvr, Position_upvr)
end
local Effect_upvr = GridFrame:WaitForChild("Effect")
function any_New_result1_upvr.OnEnabled(arg1) -- Line 142
	--[[ Upvalues[9]:
		[1]: var17_upvw (read and write)
		[2]: var18_upvw (read and write)
		[3]: var19_upvw (read and write)
		[4]: var20_upvw (read and write)
		[5]: PlayerEffectTween_upvr (readonly)
		[6]: Effect_upvr (readonly)
		[7]: UIGradient_upvr_2 (readonly)
		[8]: UIGradient_upvr (readonly)
		[9]: NameText_upvr (readonly)
	]]
	local UserData = arg1.UserData
	var17_upvw = UserData.Index
	var18_upvw = UserData.UserId
	var19_upvw = UserData.ShopShelveIndex
	var20_upvw = UserData.ShowType
	Refresh()
	PlayerEffectTween_upvr(Effect_upvr)
	if UserData.BgColor and UserData.TextColor and UserData.UIStrokeColor and UserData.EffectColor then
		UIGradient_upvr_2.Color = UserData.BgColor
		UIGradient_upvr.Color = UserData.UIStrokeColor
		NameText_upvr.TextColor3 = UserData.TextColor
		Effect_upvr.ImageColor3 = UserData.EffectColor
	end
end
function any_New_result1_upvr.OnDisabled(arg1) -- Line 162
	EffectTweenRunning = false -- Setting global
	if EffectTween then
		EffectTween:Cancel()
		EffectTween = nil -- Setting global
	end
end
function Refresh() -- Line 175
	RefreshShow()
end
local NumText_upvr = BuyButton_upvr:WaitForChild("NumText")
local CantBuyFrame_upvr = BuyFrame:WaitForChild("CantBuyFrame")
local DescripText_upvr = GridFrame:WaitForChild("DescripText")
function RefreshShow() -- Line 182
	--[[ Upvalues[14]:
		[1]: Players_upvr (readonly)
		[2]: var18_upvw (read and write)
		[3]: module_upvr_2 (readonly)
		[4]: var19_upvw (read and write)
		[5]: var17_upvw (read and write)
		[6]: NumText_upvr (readonly)
		[7]: BuyButton_upvr (readonly)
		[8]: CantBuyFrame_upvr (readonly)
		[9]: NameText_upvr (readonly)
		[10]: Icon_upvr (readonly)
		[11]: DescripText_upvr (readonly)
		[12]: var20_upvw (read and write)
		[13]: UIGradient_upvr (readonly)
		[14]: UIGradient_upvr_2 (readonly)
	]]
	local _, any_GetGoodsId_result2 = module_upvr_2:GetGoodsId(Players_upvr:GetPlayerByUserId(var18_upvw), var19_upvw, var17_upvw)
	module_upvr_2:RefreshPrice(any_GetGoodsId_result2, NumText_upvr)
	module_upvr_2:RefreshBuyButton(var18_upvw, any_GetGoodsId_result2, BuyButton_upvr, CantBuyFrame_upvr)
	module_upvr_2:RefreshGoodsShow(any_GetGoodsId_result2, 1, NameText_upvr, Icon_upvr, nil, DescripText_upvr)
	module_upvr_2:RefreshQuality(var20_upvw, var17_upvw, nil, nil, UIGradient_upvr, UIGradient_upvr_2, NameText_upvr)
end
function GetGoodsIdAndGoodsData() -- Line 192
	--[[ Upvalues[5]:
		[1]: Players_upvr (readonly)
		[2]: var18_upvw (read and write)
		[3]: module_upvr_2 (readonly)
		[4]: var19_upvw (read and write)
		[5]: var17_upvw (read and write)
	]]
	local _, any_GetGoodsId_result2_3 = module_upvr_2:GetGoodsId(Players_upvr:GetPlayerByUserId(var18_upvw), var19_upvw, var17_upvw)
	local _, any_GetGoodsQuality_result2 = module_upvr_2:GetGoodsQuality(any_GetGoodsId_result2_3)
	local _, any_GetGoodsIcon_result2 = module_upvr_2:GetGoodsIcon(any_GetGoodsId_result2_3)
	return any_GetGoodsId_result2_3, {
		ItemIcon = any_GetGoodsIcon_result2;
		Quality = any_GetGoodsQuality_result2;
	}
end
function BuyThings() -- Line 204
	--[[ Upvalues[1]:
		[1]: any_New_result1_upvr (readonly)
	]]
	local GetGoodsIdAndGoodsData_result1, GetGoodsIdAndGoodsData_result2 = GetGoodsIdAndGoodsData()
	any_New_result1_upvr:InvokeEvent("ClickBuy", GetGoodsIdAndGoodsData_result1, 1, GetGoodsIdAndGoodsData_result2)
end
function GiftThings() -- Line 210
	--[[ Upvalues[6]:
		[1]: Players_upvr (readonly)
		[2]: var18_upvw (read and write)
		[3]: module_upvr_2 (readonly)
		[4]: var19_upvw (read and write)
		[5]: var17_upvw (read and write)
		[6]: any_New_result1_upvr (readonly)
	]]
	local _, any_GetGoodsId_result2_2 = module_upvr_2:GetGoodsId(Players_upvr:GetPlayerByUserId(var18_upvw), var19_upvw, var17_upvw)
	any_New_result1_upvr:InvokeEvent("ClickGift", any_GetGoodsId_result2_2)
end
return any_New_result1_upvr
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-11 03:41:51
-- Luau version 6, Types version 3
-- Time taken: 0.009972 seconds

local Players_upvr = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Script = ReplicatedStorage:WaitForChild("UI"):WaitForChild("Script")
local _ = ReplicatedStorage:WaitForChild("UIModules"):WaitForChild("Script")
local module_upvr_2 = require(ReplicatedStorage:WaitForChild("Shop"):WaitForChild("Script"):WaitForChild("ShopController"))
local Parent_upvr = script.Parent
local GridScrolling_upvr = Parent_upvr:WaitForChild("GridFrame"):WaitForChild("GridScrolling")
local UIGridLayout_upvr = GridScrolling_upvr:WaitForChild("UIGridLayout")
local Grid_upvr = require(ReplicatedStorage:WaitForChild("Tools"):WaitForChild("Script"):WaitForChild("EnumCode")).ShopShowType.Grid
local var12_upvw
local var13_upvw
local var14_upvw
local tbl_2_upvr = {{
	BgColor = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("6a2091")), ColorSequenceKeypoint.new(1, Color3.fromHex("ad0fff"))});
	UIStrokeColor = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("e3c1ff")), ColorSequenceKeypoint.new(1, Color3.fromHex("b33bff"))});
	TextColor = Color3.fromHex("e8bdf1");
	EffectColor = Color3.fromHex("dd33ff");
}, {
	BgColor = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("007eff")), ColorSequenceKeypoint.new(1, Color3.fromHex("2982c7"))});
	UIStrokeColor = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("9adaff")), ColorSequenceKeypoint.new(1, Color3.fromHex("08b1ff"))});
	TextColor = Color3.fromHex("a0e8ff");
	EffectColor = Color3.fromHex("08b1ff");
}, {
	BgColor = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("00c7bb")), ColorSequenceKeypoint.new(1, Color3.fromHex("1a8f80"))});
	UIStrokeColor = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("9afffe")), ColorSequenceKeypoint.new(1, Color3.fromHex("56ffdd"))});
	TextColor = Color3.fromHex("56ffdd");
	EffectColor = Color3.fromHex("56ffdd");
}}
local any_New_result1_upvr = require(Script:WaitForChild("UIScrollViewItem")):New()
local module_upvr = require(Script:WaitForChild("UIScrollView"))
local GridItem_upvr = GridScrolling_upvr:WaitForChild("GridItem")
function any_New_result1_upvr.OnCreate(arg1) -- Line 108
	--[[ Upvalues[5]:
		[1]: var14_upvw (read and write)
		[2]: module_upvr (readonly)
		[3]: any_New_result1_upvr (readonly)
		[4]: GridScrolling_upvr (readonly)
		[5]: GridItem_upvr (readonly)
	]]
	var14_upvw = module_upvr:New(any_New_result1_upvr, {
		ScrollParent = GridScrolling_upvr;
		ViewItemScriptName = "GridItemScript";
		ViewItemInstance = GridItem_upvr;
	})
	arg1:AddListener("RefreshTargetArea", RefreshTargetArea)
end
function any_New_result1_upvr.OnEnabled(arg1) -- Line 113
	--[[ Upvalues[2]:
		[1]: var12_upvw (read and write)
		[2]: var13_upvw (read and write)
	]]
	local UserData = arg1.UserData
	var12_upvw = UserData.ShopShelveIndex
	var13_upvw = UserData.UserId
	Refresh()
end
local Size_upvr = Parent_upvr.Size
local CellSize_upvr = UIGridLayout_upvr.CellSize
function Refresh() -- Line 120
	--[[ Upvalues[10]:
		[1]: module_upvr_2 (readonly)
		[2]: var12_upvw (read and write)
		[3]: Size_upvr (readonly)
		[4]: Parent_upvr (readonly)
		[5]: CellSize_upvr (readonly)
		[6]: UIGridLayout_upvr (readonly)
		[7]: var13_upvw (read and write)
		[8]: Grid_upvr (readonly)
		[9]: tbl_2_upvr (readonly)
		[10]: var14_upvw (read and write)
	]]
	local any_GetGoodsList_result1 = module_upvr_2:GetGoodsList(var12_upvw)
	local ceiled = math.ceil(#any_GetGoodsList_result1 / 2)
	Parent_upvr.Size = UDim2.new(Size_upvr.X.Scale, 0, Size_upvr.Y.Scale * ceiled, 0)
	UIGridLayout_upvr.CellSize = UDim2.new(CellSize_upvr.X.Scale, 0, CellSize_upvr.Y.Scale / ceiled, 0)
	local tbl_3 = {}
	for i, _ in ipairs(any_GetGoodsList_result1) do
		local tbl = {
			Index = i;
			UserId = var13_upvw;
			ShopShelveIndex = var12_upvw;
			ShowType = Grid_upvr;
		}
		if tbl_2_upvr[i] then
			tbl.BgColor = tbl_2_upvr[i].BgColor
			tbl.TextColor = tbl_2_upvr[i].TextColor
			tbl.UIStrokeColor = tbl_2_upvr[i].UIStrokeColor
			tbl.EffectColor = tbl_2_upvr[i].EffectColor
		end
		table.insert(tbl_3, tbl)
	end
	var14_upvw:Create(tbl_3)
end
function BuyThings() -- Line 149
	--[[ Upvalues[5]:
		[1]: Players_upvr (readonly)
		[2]: var13_upvw (read and write)
		[3]: module_upvr_2 (readonly)
		[4]: var12_upvw (read and write)
		[5]: any_New_result1_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local _, any_GetGoodsId_result2_2 = module_upvr_2:GetGoodsId(Players_upvr:GetPlayerByUserId(var13_upvw), var12_upvw)
	local _, any_GetItemList_result2 = module_upvr_2:GetItemList(any_GetGoodsId_result2_2)
	if any_GetItemList_result2 == nil then
	else
		for i_2, v_2 in ipairs(any_GetItemList_result2) do
			table.insert({}, {
				Index = i_2;
				ItemId = v_2.ItemId;
				ItemNum = v_2.ItemNum;
			})
			local var58
		end
		any_New_result1_upvr:InvokeEvent("ClickBuy", any_GetGoodsId_result2_2, 1, var58)
	end
end
function GiftThings() -- Line 170
	--[[ Upvalues[5]:
		[1]: Players_upvr (readonly)
		[2]: var13_upvw (read and write)
		[3]: module_upvr_2 (readonly)
		[4]: var12_upvw (read and write)
		[5]: any_New_result1_upvr (readonly)
	]]
	local _, any_GetGoodsId_result2 = module_upvr_2:GetGoodsId(Players_upvr:GetPlayerByUserId(var13_upvw), var12_upvw)
	any_New_result1_upvr:InvokeEvent("ClickGift", any_GetGoodsId_result2)
end
function RefreshTargetArea(arg1) -- Line 177
	--[[ Upvalues[1]:
		[1]: Grid_upvr (readonly)
	]]
	if Grid_upvr ~= arg1.ShowType then
	else
		Refresh()
	end
end
return any_New_result1_upvr






-- and some random calls made while playing



local args = {
	2312583920
}
game:GetService("ReplicatedStorage"):WaitForChild("PlayerNameCacheAdmin"):WaitForChild("Remote"):WaitForChild("GetPlayerNameByUserId"):InvokeServer(unpack(args))



local args = {
	Instance.new("Player", nil)
}
game:GetService("ReplicatedStorage"):WaitForChild("Shop"):WaitForChild("Remote"):WaitForChild("GetPlayerBuyRecord"):InvokeServer(unpack(args))


local args = {
	1,
	1
}
game:GetService("ReplicatedStorage"):WaitForChild("Input"):WaitForChild("Remote"):WaitForChild("ChangeKeyPressedState"):InvokeServer(unpack(args))




local args = {
	workspace:WaitForChild("Recycle"):WaitForChild("Monster1"),
	"Death",
	Instance.new("AnimationTrack", nil),
	"Default"
}
game:GetService("ReplicatedStorage"):WaitForChild("AnimeStateMachine"):WaitForChild("Remote"):WaitForChild("ExecuteAnimeStoppedFunction"):FireServer(unpack(args))




local args = {
	9025448054
}
game:GetService("ReplicatedStorage"):WaitForChild("PlayerNameCacheAdmin"):WaitForChild("Remote"):WaitForChild("GetPlayerNameByUserId"):InvokeServer(unpack(args))




local args = {
	{
		ShiftLockMode = 0
	}
}
game:GetService("ReplicatedStorage"):WaitForChild("ClientSetting"):WaitForChild("Remote"):WaitForChild("SetSettingByPlayer"):InvokeServer(unpack(args))




local args = {
	Instance.new("Player", nil)
}
game:GetService("ReplicatedStorage"):WaitForChild("Shop"):WaitForChild("Remote"):WaitForChild("GetPlayerBuyRecord"):InvokeServer(unpack(args))




local args = {
	"PermanentPool3",
	3
}
game:GetService("ReplicatedStorage"):WaitForChild("Lottery"):WaitForChild("Remote"):WaitForChild("GetLotteryMaxGuarantee"):InvokeServer(unpack(args))



local args = {
	"PermanentPool3",
	3
}
game:GetService("ReplicatedStorage"):WaitForChild("Lottery"):WaitForChild("Remote"):WaitForChild("GetLotteryLastGuarantee"):InvokeServer(unpack(args))



local args = {
	game:GetService("Players").LocalPlayer.Character,
	"Idle"
}
game:GetService("ReplicatedStorage"):WaitForChild("AnimeStateMachine"):WaitForChild("Remote"):WaitForChild("ChangeAnimeStateSucc"):FireServer(unpack(args))



local args = {
	game:GetService("Players").LocalPlayer.Character,
	"Idle"
}
game:GetService("ReplicatedStorage"):WaitForChild("AnimeStateMachine"):WaitForChild("Remote"):WaitForChild("SetCurrAnimeStateName"):InvokeServer(unpack(args))




local args = {
	game:GetService("Players").LocalPlayer.Character,
	"Idle",
	Instance.new("AnimationTrack", nil),
	"Notexecuted"
}
game:GetService("ReplicatedStorage"):WaitForChild("AnimeStateMachine"):WaitForChild("Remote"):WaitForChild("ExecuteAnimeStoppedFunction"):FireServer(unpack(args))



local args = {
	"LotteryOne",
	true
}
game:GetService("ReplicatedStorage"):WaitForChild("Input"):WaitForChild("Remote"):WaitForChild("SetInputFuncState"):InvokeServer(unpack(args))



local args = {
	"1",
	1
}
game:GetService("ReplicatedStorage"):WaitForChild("Shop"):WaitForChild("Remote"):WaitForChild("ApplyPurchaseGoods"):InvokeServer(unpack(args))



local args = {
	3,
	1
}
game:GetService("ReplicatedStorage"):WaitForChild("WeaponShop"):WaitForChild("Remote"):WaitForChild("ApplyLotteryWeapon"):InvokeServer(unpack(args))



local args = {
	2
}
game:GetService("ReplicatedStorage"):WaitForChild("NewcomersGuideV2"):WaitForChild("Remote"):WaitForChild("GetPlayerGuidePartState"):InvokeServer(unpack(args))



local args = {
	"LotteryResultClose",
	true
}
game:GetService("ReplicatedStorage"):WaitForChild("Input"):WaitForChild("Remote"):WaitForChild("SetInputFuncState"):InvokeServer(unpack(args))



local args = {
	"LotteryContinue",
	false
}
game:GetService("ReplicatedStorage"):WaitForChild("Input"):WaitForChild("Remote"):WaitForChild("SetInputFuncState"):InvokeServer(unpack(args))




local args = {
	"LotteryContinue",
	true
}
game:GetService("ReplicatedStorage"):WaitForChild("Input"):WaitForChild("Remote"):WaitForChild("SetInputFuncState"):InvokeServer(unpack(args))




local args = {
	"LotterySkip",
	false
}
game:GetService("ReplicatedStorage"):WaitForChild("Input"):WaitForChild("Remote"):WaitForChild("SetInputFuncState"):InvokeServer(unpack(args))




local args = {
	2
}
game:GetService("ReplicatedStorage"):WaitForChild("NewcomersGuideV2"):WaitForChild("Remote"):WaitForChild("GetPlayerGuidePartState"):InvokeServer(unpack(args))





local args = {
	"LotteryResultClose",
	false
}
game:GetService("ReplicatedStorage"):WaitForChild("Input"):WaitForChild("Remote"):WaitForChild("SetInputFuncState"):InvokeServer(unpack(args))




local args = {
	"PermanentPool2",
	3
}
game:GetService("ReplicatedStorage"):WaitForChild("Lottery"):WaitForChild("Remote"):WaitForChild("GetLotteryMaxGuarantee"):InvokeServer(unpack(args))




local args = {
	"PermanentPool2",
	3
}
game:GetService("ReplicatedStorage"):WaitForChild("Lottery"):WaitForChild("Remote"):WaitForChild("GetLotteryLastGuarantee"):InvokeServer(unpack(args))




local args = {
	"LotteryFive",
	true
}
game:GetService("ReplicatedStorage"):WaitForChild("Input"):WaitForChild("Remote"):WaitForChild("SetInputFuncState"):InvokeServer(unpack(args))



local args = {
	game:GetService("Players").LocalPlayer.Character,
	"Ability1"
}
game:GetService("ReplicatedStorage"):WaitForChild("AnimeStateMachine"):WaitForChild("Remote"):WaitForChild("ChangeAnimeStateSucc"):FireServer(unpack(args))




local args = {
	"10006",
	"43",
	"31",
	{},
	1,
	"1058",
	"52808e90-ee53-4f68-ba61-80231196c93f"
}
game:GetService("ReplicatedStorage"):WaitForChild("GameplayAbilitySystem"):WaitForChild("Remote"):WaitForChild("GameplayEffectExeFinish"):FireServer(unpack(args))




local args = {
	7,
	1,
	"Ability1",
	1,
	3
}
game:GetService("ReplicatedStorage"):WaitForChild("PlayerFSM"):WaitForChild("Remote"):WaitForChild("RequestChangePlayerState"):InvokeServer(unpack(args))



local args = {
	"10006",
	"166",
	"1059",
	"27"
}
game:GetService("ReplicatedStorage"):WaitForChild("GameplayAbilitySystem"):WaitForChild("Remote"):WaitForChild("ExeGameplayEffectStartFuncSucc"):FireServer(unpack(args))




local args = {
	"ef114da8-fa9e-4237-8e7e-3b558d8e7b65"
}
game:GetService("ReplicatedStorage"):WaitForChild("DropReward"):WaitForChild("Remote"):WaitForChild("ApplyClaimDropReward"):InvokeServer(unpack(args))




local args = {
	"3d7d1960-cbba-4979-b267-51a43cfac230"
}
game:GetService("ReplicatedStorage"):WaitForChild("DropReward"):WaitForChild("Remote"):WaitForChild("ApplyClaimDropReward"):InvokeServer(unpack(args))



local args = {
	"10006",
	{},
	"1058",
	"52808e90-ee53-4f68-ba61-80231196c93f",
	1
}
game:GetService("ReplicatedStorage"):WaitForChild("GameplayAbilitySystem"):WaitForChild("Remote"):WaitForChild("ServerActivateGameplayEffect"):FireServer(unpack(args))



local args = {
	"10006",
	"31",
	"1058",
	"27"
}
game:GetService("ReplicatedStorage"):WaitForChild("GameplayAbilitySystem"):WaitForChild("Remote"):WaitForChild("ExeGameplayEffectStartFuncSucc"):FireServer(unpack(args))



local args = {
	"10006",
	{},
	"1059",
	"035d4c83-b1cf-425f-965a-4609da14e701",
	2
}
game:GetService("ReplicatedStorage"):WaitForChild("GameplayAbilitySystem"):WaitForChild("Remote"):WaitForChild("ServerActivateGameplayEffect"):FireServer(unpack(args))



local args = {
	"10006",
	"20",
	{}
}
game:GetService("ReplicatedStorage"):WaitForChild("GameplayAbilitySystem"):WaitForChild("Remote"):WaitForChild("ClientApplyServerActivateGA"):InvokeServer(unpack(args))



local args = {
	"40"
}
game:GetService("ReplicatedStorage"):WaitForChild("Perk"):WaitForChild("Remote"):WaitForChild("ReqPlayerSelectPerk"):InvokeServer(unpack(args))



local args = {
	"81198653-eb73-47c7-8c4f-a9230a718f7f"
}
game:GetService("ReplicatedStorage"):WaitForChild("DropReward"):WaitForChild("Remote"):WaitForChild("ApplyClaimDropReward"):InvokeServer(unpack(args))
