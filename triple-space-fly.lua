-- Triple Space Fly Toggle
-- Press spacebar 3 times quickly to enable/disable flying

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Configuration
local PRESS_WINDOW = 0.5 -- Time window to register 3 presses (seconds)
local FLY_SPEED = 50 -- Flying speed
local MAX_PRESSES = 3 -- Number of presses needed to toggle

-- State variables
local spacePressed = 0
local lastPressTime = 0
local flying = false
local bodyVelocity = nil
local bodyGyro = nil
local flyConnection = nil

-- Function to create fly objects
local function createFlyObjects()
    if bodyVelocity then return end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = rootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
end

-- Function to remove fly objects
local function removeFlyObjects()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
end

-- Function to start flying
local function startFlying()
    flying = true
    createFlyObjects()
    
    print("Flying enabled!")
    
    -- Main fly loop
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flying then return end
        
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)
        
        -- Get movement input
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + (camera.CFrame.LookVector * FLY_SPEED)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - (camera.CFrame.LookVector * FLY_SPEED)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - (camera.CFrame.RightVector * FLY_SPEED)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + (camera.CFrame.RightVector * FLY_SPEED)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, FLY_SPEED, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, FLY_SPEED, 0)
        end
        
        -- Apply movement
        if bodyVelocity then
            bodyVelocity.Velocity = moveDirection
        end
        if bodyGyro then
            bodyGyro.CFrame = camera.CFrame
        end
    end)
end

-- Function to stop flying
local function stopFlying()
    flying = false
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    removeFlyObjects()
    
    print("Flying disabled!")
end

-- Function to toggle flying
local function toggleFly()
    if flying then
        stopFlying()
    else
        startFlying()
    end
end

-- Handle spacebar input
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Space then
        local currentTime = tick()
        
        -- Check if press is within time window
        if currentTime - lastPressTime <= PRESS_WINDOW then
            spacePressed = spacePressed + 1
        else
            -- Reset counter if too much time passed
            spacePressed = 1
        end
        
        lastPressTime = currentTime
        
        -- Toggle flying if we hit max presses
        if spacePressed >= MAX_PRESSES then
            toggleFly()
            spacePressed = 0 -- Reset counter
        end
    end
end)

-- Handle character respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Disable flying on respawn
    if flying then
        stopFlying()
    end
    spacePressed = 0
end)

print("Triple Space Fly loaded! Press spacebar 3 times quickly to toggle flying.")
print("Use WASD to move, Space to go up, Left Shift to go down.")
