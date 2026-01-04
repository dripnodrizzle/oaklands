-- Rapid Punch Script
-- Press Q to fire PunchEvent 100 times rapidly

local uis = game:GetService("UserInputService")

uis.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Q then
        for i = 1, 100 do
            game.ReplicatedStorage.Events.PunchEvent:FireServer()
        end
    end
end)

print("[Rapid Punch] Loaded - Press Q to punch 100 times")
