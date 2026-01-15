--[[
    Blue Heater API Wrapper
    Provides functions to manipulate gold, force legendary drops, and set item stats.
    Attach/hook this to Blue Heater game scripts for automation or exploits.
]]

local BlueHeaterAPI = {}

-- Add gold/currency to player
function BlueHeaterAPI.addGold(amount)
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if remotes then
        for _, remoteName in ipairs({"ObtainDrop", "GoldDrop2", "GoldDrop", "Gold", "Money"}) do
            local remote = remotes:FindFirstChild(remoteName)
            if remote and remote:IsA("RemoteEvent") then
                remote:FireServer(remoteName, amount)
            end
        end
    end
end

-- Force a legendary item drop (gacha/loot)
function BlueHeaterAPI.forceLegendaryDrop()
    local dropRewardRemote = game:GetService("ReplicatedStorage"):FindFirstChild("DropReward")
    if dropRewardRemote then
        local remote = dropRewardRemote:FindFirstChild("Remote")
        if remote then
            local claimDrop = remote:FindFirstChild("ApplyClaimDropReward")
            if claimDrop then
                -- Example args, adjust as needed for Blue Heater's reward system
                local args = {"Legendary", true}
                claimDrop:InvokeServer(unpack(args))
            end
        end
    end
end

-- Set custom stats for an item (armor/weapon)
function BlueHeaterAPI.setItemStats(item, statsTable)
    -- Example: Directly set stats if possible, or use game's stat calculation function
    for stat, value in pairs(statsTable) do
        if item:FindFirstChild(stat) then
            item[stat].Value = value
        elseif item:GetAttribute(stat) ~= nil then
            item:SetAttribute(stat, value)
        end
    end
end

return BlueHeaterAPI
