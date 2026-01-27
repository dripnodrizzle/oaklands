-- Script Killer - Removes all exploit GUIs and resets environment
-- Run this to clean up before loading new scripts

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

print("=" .. string.rep("=", 50))
print("[Script Killer] Starting cleanup...")
print("=" .. string.rep("=", 50))

local cleanupCount = 0

-- Common GUI names used by exploit scripts
local commonNames = {
    "DamageBoostUI",
    "KillAuraUI",
    "AutoFarmUI",
    "InspectorUI",
    "RemoteSpyUI",
    "ExploitUI",
    "HackUI",
    "MenuUI",
    "ScriptUI",
    "ScreenGui"
}

-- Remove GUIs by common names
for _, name in ipairs(commonNames) do
    local gui = PlayerGui:FindFirstChild(name)
    if gui then
        gui:Destroy()
        cleanupCount += 1
        print("[Script Killer] Removed:", name)
    end
end

-- Remove all ScreenGuis that aren't default Roblox ones
for _, gui in ipairs(PlayerGui:GetChildren()) do
    if gui:IsA("ScreenGui") and gui.ResetOnSpawn == false then
        -- Check if it's likely a script GUI (has buttons, frames, etc)
        local hasScriptElements = false
        for _, child in ipairs(gui:GetDescendants()) do
            if child:IsA("TextButton") or child:IsA("TextBox") then
                hasScriptElements = true
                break
            end
        end
        
        if hasScriptElements then
            print("[Script Killer] Removed custom GUI:", gui.Name)
            gui:Destroy()
            cleanupCount += 1
        end
    end
end

-- Clear any cached script data
if getgenv then
    local keys = {}
    for key, _ in pairs(getgenv()) do
        if type(key) == "string" and (
            key:find("Damage") or key:find("Kill") or 
            key:find("Aura") or key:find("Exploit") or
            key:find("Hack") or key:find("Script")
        ) then
            table.insert(keys, key)
        end
    end
    
    for _, key in ipairs(keys) do
        getgenv()[key] = nil
        print("[Script Killer] Cleared global:", key)
        cleanupCount += 1
    end
end

print("=" .. string.rep("=", 50))
print("[Script Killer] Cleanup complete!")
print("[Script Killer] Removed " .. cleanupCount .. " items")
print("[Script Killer] Environment reset - ready for fresh scripts")
print("=" .. string.rep("=", 50))

-- Show confirmation
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Script Killer";
    Text = "Cleaned " .. cleanupCount .. " items";
    Duration = 3;
})
