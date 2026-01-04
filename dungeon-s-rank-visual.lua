--> Dungeon S-Rank Visual Spoof
--> Forces dungeon rank display to show "S" rank (CLIENT-SIDE ONLY)
--> Note: This only changes the visual display, not actual rewards

print("[S-Rank Visual] Starting...")

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Wait for Static 3D Screen
local Static3DScreen = PlayerGui:WaitForChild("Static 3D Screen", 10)
if not Static3DScreen then
    warn("[S-Rank Visual] Static 3D Screen not found!")
    return
end

print("[S-Rank Visual] Found UI elements")

-- Function to force S rank display
local function forceRankDisplay(rankFrame)
    if rankFrame and rankFrame:IsA("GuiObject") then
        local content = rankFrame:FindFirstChild("Content")
        if content then
            local textLabel = content:FindFirstChild("TextLabel")
            if textLabel and textLabel:IsA("TextLabel") then
                -- Set to S rank
                textLabel.Text = "RANK: S"
                print("[S-Rank Visual] Set rank display to S")
            end
        end
    end
end

-- Monitor all screens for dungeon rank
local screens = {
    Static3DScreen:WaitForChild("Screen1", 5),
    Static3DScreen:WaitForChild("Screen5", 5)
}

for _, screen in ipairs(screens) do
    if screen then
        local screenInsets = screen:FindFirstChild("Content")
        if screenInsets then
            screenInsets = screenInsets:FindFirstChild("ScreenInsets")
            if screenInsets then
                local top = screenInsets:FindFirstChild("Top")
                if top then
                    local center = top:FindFirstChild("Center")
                    if center then
                        local dungeonRank = center:FindFirstChild("Dungeon Rank")
                        
                        if dungeonRank then
                            -- Force initial display
                            forceRankDisplay(dungeonRank)
                            
                            -- Monitor for changes
                            local content = dungeonRank:FindFirstChild("Content")
                            if content then
                                local textLabel = content:FindFirstChild("TextLabel")
                                if textLabel then
                                    -- Hook text changes
                                    textLabel:GetPropertyChangedSignal("Text"):Connect(function()
                                        if not textLabel.Text:match("RANK: S") then
                                            textLabel.Text = "RANK: S"
                                        end
                                    end)
                                    print("[S-Rank Visual] Monitoring rank display on "..screen.Name)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

print("[S-Rank Visual] Active - All dungeon ranks will display as S")
print("[S-Rank Visual] Note: This is visual only and does not affect actual rewards")
