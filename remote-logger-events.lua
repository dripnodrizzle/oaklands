--[[
Remote Logger for Roblox
Logs all RemoteEvent and RemoteFunction calls under game.ReplicatedStorage.Events
Prints the remote name, type, and arguments when fired or invoked.
Place this script in your executor or run it in the command bar.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function logArgs(...)
    local args = {...}
    local out = ""
    for i, v in ipairs(args) do
        out = out .. string.format("[%d] %s ", i, tostring(v))
    end
    return out
end

local function hookRemote(remote)
    if remote:IsA("RemoteEvent") then
        remote.OnClientEvent:Connect(function(...)
            print("[RemoteEvent:OnClientEvent]", remote:GetFullName(), logArgs(...))
        end)
        -- Only hook FireServer if it exists and is a function
        local ok, oldFireServer = pcall(function() return remote.FireServer end)
        if ok and typeof(oldFireServer) == "function" then
            local success = pcall(function()
                remote.FireServer = function(self, ...)
                    print("[RemoteEvent:FireServer]", remote:GetFullName(), logArgs(...))
                    return oldFireServer(self, ...)
                end
            end)
            if not success then
                -- Could not overwrite FireServer, skip
            end
        end
    elseif remote:IsA("RemoteFunction") then
        local ok, oldInvokeServer = pcall(function() return remote.InvokeServer end)
        if ok and typeof(oldInvokeServer) == "function" then
            local success = pcall(function()
                remote.InvokeServer = function(self, ...)
                    print("[RemoteFunction:InvokeServer]", remote:GetFullName(), logArgs(...))
                    return oldInvokeServer(self, ...)
                end
            end)
            if not success then
                -- Could not overwrite InvokeServer, skip
            end
        end
    end
end

for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
        hookRemote(remote)
    end
end

ReplicatedStorage.DescendantAdded:Connect(function(obj)
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        hookRemote(obj)
    end
end)


print("[Remote Logger] Now logging all remotes under ReplicatedStorage.")

-- === Combat Remote Tester ===

local function testWeaponHitted()
    local success, combatFolder = pcall(function()
        return game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Combat")
    end)
    if not success or not combatFolder then
        print("[Combat Remote Tester] Could not find ReplicatedStorage.Events.Combat")
        return
    end
    local remote = combatFolder:FindFirstChild("WeaponHitted")
    if remote and remote:IsA("RemoteEvent") then
        print("[Combat Remote Tester] Attempting FireServer on: WeaponHitted")
        local ok, err = pcall(function()
            remote:FireServer()
        end)
        if ok then
            print("[Combat Remote Tester] Success: WeaponHitted")
        else
            print("[Combat Remote Tester] Error: WeaponHitted", err)
        end
    else
        print("[Combat Remote Tester] WeaponHitted remote not found or not a RemoteEvent.")
    end
end

-- Uncomment the next line to run the tester automatically:
-- testWeaponHitted()
