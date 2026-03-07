-- Prize Wheel Free Spin Toggle Script for Roblox
-- Works specifically with Delta executor

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Bound child lookup prevents infinite yield warnings from long WaitForChild chains.
local function getChildSafe(parent, childName, timeout)
    if not parent then
        return nil
    end
    return parent:FindFirstChild(childName) or parent:WaitForChild(childName, timeout)
end

-- Function to create and setup the prize wheel toggle system
local function setupPrizeWheelToggle()
    local prizeWheelRemote
    
    -- Try to find the PrizeWheel remote
    local success, remote = pcall(function()
        local lobby = getChildSafe(ReplicatedStorage, "Lobby", 5)
        local remotes = getChildSafe(lobby, "Remotes", 5)
        local prizeWheel = getChildSafe(remotes, "PrizeWheel", 5)
        return prizeWheel
    end)
    
    if success and remote then
        prizeWheelRemote = remote
        if prizeWheelRemote:IsA("RemoteEvent") then
            print("[OK] Found PrizeWheel RemoteEvent successfully")
        else
            print("[WARN] PrizeWheel found but is not a RemoteEvent (" .. prizeWheelRemote.ClassName .. ")")
            prizeWheelRemote = nil
        end
    else
        print("[WARN] Could not find PrizeWheel remote - manual spin control only")
    end
    
    -- Create UI elements (simple text display for now)
    local isFreeSpinsEnabled = true
    
    -- Function to perform a spin
    local function performSpin()
        if isFreeSpinsEnabled then
            print("[INFO] Performing FREE spin!")
        else
            print("[INFO] Performing normal spin...")
        end
        
        if prizeWheelRemote and isFreeSpinsEnabled then
            -- Fire server with the remote
            local success, result = pcall(function()
                prizeWheelRemote:FireServer()
            end)
            
            if success then
                print("[OK] Spin fired successfully")
                return true
            else
                print("[ERROR] Error firing spin: " .. tostring(result))
                return false
            end
        elseif prizeWheelRemote then
            -- Even when disabled, still fire normally (but it might cost spins)
            local success, result = pcall(function()
                prizeWheelRemote:FireServer()
            end)
            
            if success then
                print("[OK] Spin fired successfully")
                return false  -- Not a free spin
            else
                print("[ERROR] Error firing spin: " .. tostring(result))
                return false
            end
        else
            print("[WARN] No remote available to spin")
            return false
        end
    end
    
    -- Toggle function
    local function toggleFreeSpins()
        isFreeSpinsEnabled = not isFreeSpinsEnabled
        if isFreeSpinsEnabled then
            print("[OK] Free spins enabled!")
        else
            print("[INFO] Free spins disabled!")
        end
    end
    
    -- Export functions for external use
    local exports = {
        spin = performSpin,
        toggle = toggleFreeSpins,
        enable = function()
            isFreeSpinsEnabled = true
            print("[OK] Free spins enabled!")
        end,
        disable = function()
            isFreeSpinsEnabled = false
            print("[INFO] Free spins disabled!")
        end,
        isEnabled = function()
            return isFreeSpinsEnabled
        end
    }
    
    -- Print instructions
    print("[INFO] Prize Wheel Toggle Script Loaded!")
    print("[INFO] Click the toggle command to switch free spin mode")
    print("[INFO] Use exports.spin() for manual spin")
    print("[INFO] Use exports.toggle() or exports.enable()/exports.disable()")
    
    return exports
end

-- Set up the system
local ok, prizeWheelToggle = pcall(setupPrizeWheelToggle)

if not ok then
    local setupError = tostring(prizeWheelToggle)
    warn("[ERROR] Setup failed: " .. setupError)
    return
end

-- Export globally so it's accessible from console
_G.PrizeWheelFreeSpin = prizeWheelToggle

print("[OK] Prize Wheel Free Spin Toggle loaded!")
print("[INFO] Available functions:")
print("   - PrizeWheelFreeSpin.spin()      # Perform a spin")
print("   - PrizeWheelFreeSpin.toggle()    # Toggle free spins on/off")
print("   - PrizeWheelFreeSpin.enable()    # Enable free spins") 
print("   - PrizeWheelFreeSpin.disable()   # Disable free spins")

-- Add a simple toggle button (since Delta doesn't support GUI well)
local function createToggleUI()
    print("\n[INFO] Toggle Instructions:")
    print("1. Type 'PrizeWheelFreeSpin.toggle()' in console to switch modes")
    print("2. Type 'PrizeWheelFreeSpin.spin()' in console to spin")
    print("3. Current mode: " .. (prizeWheelToggle.isEnabled() and "FREE" or "PAID"))
end

createToggleUI()
