-- Movement Unlocker Script
-- Automatically reactivates jump and run when they get stuck or disabled
-- Works in any Roblox game

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Configuration
local Config = {
    AutoFix = true,              -- Automatically fix stuck movement
    CheckInterval = 0.5,         -- How often to check (seconds)
    ForceJumpEnabled = true,     -- Always keep jump enabled
    ForceRunEnabled = true,      -- Always keep running enabled
    ShowNotifications = true,    -- Show when fixes are applied
    EmergencyKey = Enum.KeyCode.J, -- Press this key to force unlock (J key)
}

local fixCount = 0
local lastNotification = 0

-- Print helper
local function notify(message)
    if Config.ShowNotifications and tick() - lastNotification > 2 then
        print("[Movement Unlocker] " .. message)
        lastNotification = tick()
    end
end

-- Get the player's humanoid
local function getHumanoid()
    if LocalPlayer.Character then
        return LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

-- Fix jump state
local function fixJump()
    local humanoid = getHumanoid()
    if not humanoid then return false end
    
    local wasDisabled = humanoid:GetState() == Enum.HumanoidStateType.Jumping and false or
                        humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping) == false
    
    if wasDisabled or Config.ForceJumpEnabled then
        pcall(function()
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        end)
        return wasDisabled
    end
    
    return false
end

-- Fix running state
local function fixRun()
    local humanoid = getHumanoid()
    if not humanoid then return false end
    
    local wasDisabled = humanoid:GetStateEnabled(Enum.HumanoidStateType.Running) == false
    
    if wasDisabled or Config.ForceRunEnabled then
        pcall(function()
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
        end)
        return wasDisabled
    end
    
    return false
end

-- Fix all movement states
local function fixAllMovement()
    local humanoid = getHumanoid()
    if not humanoid then return false end
    
    local fixed = false
    
    -- Enable critical movement states
    local states = {
        Enum.HumanoidStateType.Running,
        Enum.HumanoidStateType.Jumping,
        Enum.HumanoidStateType.Freefall,
        Enum.HumanoidStateType.Flying,
        Enum.HumanoidStateType.Climbing,
        Enum.HumanoidStateType.Swimming,
        Enum.HumanoidStateType.RunningNoPhysics,
    }
    
    for _, state in ipairs(states) do
        local wasDisabled = not humanoid:GetStateEnabled(state)
        if wasDisabled then
            pcall(function()
                humanoid:SetStateEnabled(state, true)
            end)
            fixed = true
        end
    end
    
    -- Also reset some properties that might cause issues
    pcall(function()
        if humanoid.WalkSpeed == 0 then
            humanoid.WalkSpeed = 16 -- Default walkspeed
            fixed = true
        end
        if humanoid.JumpPower == 0 and humanoid.UseJumpPower then
            humanoid.JumpPower = 50 -- Default jump power
            fixed = true
        end
        if humanoid.JumpHeight == 0 and not humanoid.UseJumpPower then
            humanoid.JumpHeight = 7.2 -- Default jump height
            fixed = true
        end
    end)
    
    return fixed
end

-- Monitor and auto-fix
local function monitorMovement()
    if not Config.AutoFix then return end
    
    local humanoid = getHumanoid()
    if not humanoid then return end
    
    -- Force check and re-enable running states more aggressively
    local jumpFixed = false
    local runFixed = false
    
    if not humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        jumpFixed = true
    end
    
    if not humanoid:GetStateEnabled(Enum.HumanoidStateType.Running) then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        runFixed = true
    end
    
    if not humanoid:GetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics) then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
        runFixed = true
    end
    
    -- Also check walkspeed
    if humanoid.WalkSpeed <= 0 then
        humanoid.WalkSpeed = 16
        runFixed = true
    end
    
    if jumpFixed or runFixed then
        fixCount = fixCount + 1
        local fixes = {}
        if jumpFixed then table.insert(fixes, "jump") end
        if runFixed then table.insert(fixes, "run") end
        notify("✓ Fixed: " .. table.concat(fixes, ", ") .. " (Total: " .. fixCount .. ")")
    end
end

-- Character respawn handler
local function onCharacterAdded(character)
    -- Wait for humanoid
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        notify("👤 Character loaded - monitoring movement")
        
        -- Force enable movement states on spawn
        task.wait(0.5)
        fixAllMovement()
    end
end

-- Setup character monitoring
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Start auto-fix loop
if Config.AutoFix then
    RunService.Heartbeat:Connect(function()
        monitorMovement()
    end)
end

-- Emergency key binding
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Config.EmergencyKey then
        local fixed = fixAllMovement()
        print("[Movement Unlocker] 🚨 EMERGENCY FIX APPLIED!")
        print("  All movement states have been reset")
        if fixed then
            print("  ✓ Issues were detected and fixed")
        else
            print("  ℹ No issues detected, but states were reset anyway")
        end
    end
end)

-- Global functions
_G.FixMovement = function()
    local fixed = fixAllMovement()
    print("[Movement Unlocker] Manual fix applied!")
    return fixed
end

_G.FixJump = function()
    fixJump()
    print("[Movement Unlocker] Jump fixed!")
end

_G.FixRun = function()
    fixRun()
    print("[Movement Unlocker] Run fixed!")
end

_G.ToggleAutoFix = function()
    Config.AutoFix = not Config.AutoFix
    print("[Movement Unlocker] Auto-fix: " .. (Config.AutoFix and "ENABLED ✓" or "DISABLED ✗"))
end

_G.SetEmergencyKey = function(keyCode)
    Config.EmergencyKey = keyCode
    print("[Movement Unlocker] Emergency key set to: " .. tostring(keyCode))
end

_G.CheckMovement = function()
    local humanoid = getHumanoid()
    if not humanoid then
        print("[Movement Unlocker] ✗ No humanoid found")
        return
    end
    
    print("[Movement Unlocker] === Movement Status ===")
    print("  Jump enabled: " .. tostring(humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping)))
    print("  Run enabled: " .. tostring(humanoid:GetStateEnabled(Enum.HumanoidStateType.Running)))
    print("  WalkSpeed: " .. tostring(humanoid.WalkSpeed))
    print("  JumpPower: " .. tostring(humanoid.JumpPower))
    print("  JumpHeight: " .. tostring(humanoid.JumpHeight))
    print("  Current state: " .. tostring(humanoid:GetState()))
    print("  Fixes applied: " .. fixCount)
end

_G.ResetSpeed = function(speed)
    speed = speed or 16
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = speed
        print("[Movement Unlocker] WalkSpeed set to: " .. speed)
    end
end

_G.ResetJump = function()
    local humanoid = getHumanoid()
    if humanoid then
        if humanoid.UseJumpPower then
            humanoid.JumpPower = 50
            print("[Movement Unlocker] JumpPower reset to: 50")
        else
            humanoid.JumpHeight = 7.2
            print("[Movement Unlocker] JumpHeight reset to: 7.2")
        end
    end
end

-- Print loaded message
print("[Movement Unlocker] ✓ Loaded!")
print("  Auto-fix: " .. (Config.AutoFix and "ENABLED" or "DISABLED"))
print("  Emergency key: " .. tostring(Config.EmergencyKey.Name) .. " (Press to force unlock)")
print("")
print("=== Commands ===")
print("  _G.FixMovement() - Fix all movement issues now")
print("  _G.FixJump() - Fix jump only")
print("  _G.FixRun() - Fix run only")
print("  _G.CheckMovement() - Show current movement status")
print("  _G.ToggleAutoFix() - Toggle automatic fixes")
print("  _G.ResetSpeed(speed) - Reset walk speed (default 16)")
print("  _G.ResetJump() - Reset jump power/height")
print("  Press '" .. Config.EmergencyKey.Name .. "' key for emergency unlock!")
print("")
