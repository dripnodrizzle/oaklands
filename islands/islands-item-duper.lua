-- Islands Item Duplication Exploiter
-- Multiple methods to duplicate items

print("Islands Item Duper Loading...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

-- =====================================================
-- INVENTORY SERVICE FINDER
-- =====================================================

local InventoryFinder = {}
InventoryFinder.inventoryService = nil
InventoryFinder.inventoryUI = nil

function InventoryFinder.findInventory()
    print("🔍 Searching for inventory system...")
    
    pcall(function()
        local RuntimeLib = require(ReplicatedStorage.rbxts_include.RuntimeLib)
        
        -- Find inventory service with timeout
        local paths = {
            "TS/inventory/inventory-service",
            "TS/ui/inventory/client-inventory-ui-service"
        }
        
        for _, path in ipairs(paths) do
            pcall(function()
                local segments = {}
                for segment in path:gmatch("[^/]+") do
                    table.insert(segments, segment)
                end
                
                -- Try with short timeout to avoid hanging
                local success, module = pcall(function()
                    -- Use FindFirstChild instead of WaitForChild to avoid infinite yield
                    local current = ReplicatedStorage
                    for _, seg in ipairs(segments) do
                        current = current:FindFirstChild(seg)
                        if not current then return nil end
                    end
                    return require(current)
                end)
                
                if success and module then
                    print(string.format("✓ Found inventory module: %s", path))
                    
                    if path:match("client-inventory-ui-service") then
                        InventoryFinder.inventoryUI = module.ClientInventoryUIService
                    else
                        InventoryFinder.inventoryService = module
                    end
                end
            end)
        end
    end)
    
    if not InventoryFinder.inventoryService then
        warn("⚠️ Could not find inventory service - some features may not work")
        warn("   This is normal if Islands uses a different structure")
    end
end

-- =====================================================
-- ITEM SCANNER
-- =====================================================

local ItemScanner = {}
ItemScanner.items = {}

function ItemScanner.scanInventory()
    print("\n=== Scanning Inventory ===")
    
    -- Try to find inventory in PlayerGui
    pcall(function()
        local playerGui = Player:WaitForChild("PlayerGui")
        
        for _, gui in ipairs(playerGui:GetDescendants()) do
            if gui.Name:lower():match("inventory") or gui.Name:lower():match("item") then
                if gui:IsA("Frame") or gui:IsA("ImageButton") then
                    print(string.format("Found inventory UI: %s", gui:GetFullName()))
                end
            end
        end
    end)
    
    -- Try to find Backpack items
    pcall(function()
        local backpack = Player:WaitForChild("Backpack")
        print(string.format("\n📦 Backpack Items: %d", #backpack:GetChildren()))
        
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                print(string.format("  - %s", tool.Name))
                table.insert(ItemScanner.items, {
                    name = tool.Name,
                    object = tool,
                    location = "Backpack"
                })
            end
        end
    end)
    
    -- Try to find equipped items
    pcall(function()
        local character = Player.Character
        if character then
            for _, tool in ipairs(character:GetChildren()) do
                if tool:IsA("Tool") then
                    print(string.format("  - %s (equipped)", tool.Name))
                    table.insert(ItemScanner.items, {
                        name = tool.Name,
                        object = tool,
                        location = "Character"
                    })
                end
            end
        end
    end)
    
    return ItemScanner.items
end

-- =====================================================
-- NETWORK REQUEST INTERCEPTOR
-- =====================================================

local NetworkInterceptor = {}
NetworkInterceptor.requests = {}
NetworkInterceptor.itemRequests = {}

-- Helper to safely serialize data that may contain Instances
local function safeSerialize(data, depth)
    depth = depth or 0
    if depth > 3 then return "..." end
    
    local dataType = type(data)
    
    if dataType == "table" then
        local result = {}
        for k, v in pairs(data) do
            result[tostring(k)] = safeSerialize(v, depth + 1)
        end
        return result
    elseif dataType == "userdata" then
        -- Instance or other userdata
        local success, name = pcall(function() return data.Name end)
        if success then
            return string.format("[Instance: %s]", tostring(name))
        end
        return "[Userdata]"
    elseif dataType == "function" then
        return "[Function]"
    else
        return data
    end
end

-- Helper function to safely require modules without hanging
local function safeRequire(...)
    local segments = {...}
    local current = ReplicatedStorage
    
    for _, seg in ipairs(segments) do
        current = current:FindFirstChild(seg)
        if not current then 
            return nil 
        end
    end
    
    local success, module = pcall(require, current)
    if success then
        return module
    end
    return nil
end

function NetworkInterceptor.hookNetworkRequests()
    pcall(function()
        local RuntimeLib = require(ReplicatedStorage.rbxts_include.RuntimeLib)
        local networkModule = safeRequire("TS", "network", "network-service")
        
        if not networkModule then
            warn("⚠️ Could not find NetworkService")
            return
        end
        
        local NetworkService = networkModule.NetworkService
        
        if NetworkService and NetworkService.sendClientRequest then
            local originalSendRequest = NetworkService.sendClientRequest
            
            NetworkService.sendClientRequest = function(self, requestId, data)
                -- Debug: Log raw data type and keys
                pcall(function()
                    if type(data) == "table" then
                        local hasData = false
                        for k, v in pairs(data) do
                            hasData = true
                            break
                        end
                        
                        if hasData then
                            print(string.format("\n📡 Raw Request: ID=%s, DataType=%s", tostring(requestId), type(data)))
                            print("Raw data keys:")
                            for k, v in pairs(data) do
                                print(string.format("  %s = %s (type: %s)", tostring(k), tostring(v), type(v)))
                                
                                -- If it's a table, show its keys too
                                if type(v) == "table" then
                                    for k2, v2 in pairs(v) do
                                        print(string.format("    %s = %s (type: %s)", tostring(k2), tostring(v2), type(v2)))
                                    end
                                end
                            end
                        end
                    end
                end)
                
                -- Safely serialize the data
                local serializedData = nil
                pcall(function()
                    serializedData = safeSerialize(data)
                end)
                
                -- Store request
                pcall(function()
                    table.insert(NetworkInterceptor.requests, {
                        requestId = requestId,
                        data = data,  -- Store ORIGINAL data, not serialized
                        timestamp = tick()
                    })
                end)
                
                -- Check if it's item-related and store it
                pcall(function()
                    if data and type(data) == "table" then
                        -- Check for item-related properties
                        if data.item or data.itemId or data.slot or data.amount or data.hotbarTools then
                            table.insert(NetworkInterceptor.itemRequests, {
                                requestId = requestId,
                                data = data,  -- Store original data
                                timestamp = tick()
                            })
                            print("  📦 Item-related request detected!")
                        end
                    end
                end)
                
                return originalSendRequest(self, requestId, data)
            end
            
            print("✓ Hooked NetworkService.sendClientRequest")
            return true
        else
            warn("⚠️ NetworkService not found, trying RemoteEvent fallback...")
            return NetworkInterceptor.hookRemoteEventsFallback()
        end
    end)
end

-- Fallback: Hook RemoteEvents directly
function NetworkInterceptor.hookRemoteEventsFallback()
    print("🔄 Scanning for RemoteEvents...")
    
    local function hookRemote(remote)
        if not remote:IsA("RemoteEvent") then return end
        
        pcall(function()
            local oldFireServer = remote.FireServer
            remote.FireServer = function(self, ...)
                local args = {...}
                
                -- Try to detect item-related calls
                local isItemRelated = false
                for _, arg in ipairs(args) do
                    if type(arg) == "table" then
                        if arg.item or arg.itemId or arg.slot or arg.amount or arg.itemName then
                            isItemRelated = true
                            break
                        end
                    end
                end
                
                if isItemRelated then
                    print("📦 Item-related RemoteEvent fired:", remote:GetFullName())
                    
                    local serializedData = {}
                    for i, arg in ipairs(args) do
                        serializedData[i] = safeSerialize(arg)
                    end
                    
                    table.insert(NetworkInterceptor.itemRequests, {
                        remote = remote:GetFullName(),
                        args = serializedData,
                        timestamp = tick()
                    })
                end
                
                return oldFireServer(self, ...)
            end
        end)
    end
    
    -- Hook existing remotes
    for _, remote in ipairs(game:GetDescendants()) do
        hookRemote(remote)
    end
    
    -- Hook new remotes
    game.DescendantAdded:Connect(hookRemote)
    
    print("✓ Hooked RemoteEvents as fallback")
    return true
end

function NetworkInterceptor.dumpItemRequests(count)
    count = count or 10
    print("\n=== Recent Item Requests ===")
    
    local start = math.max(1, #NetworkInterceptor.itemRequests - count + 1)
    for i = start, #NetworkInterceptor.itemRequests do
        local req = NetworkInterceptor.itemRequests[i]
        pcall(function()
            print(string.format("[%d] %s (%.1fs ago)", 
                i, tostring(req.requestId), tick() - req.timestamp))
            
            if req.data then
                local success, jsonData = pcall(function()
                    return game:GetService("HttpService"):JSONEncode(req.data)
                end)
                
                if success then
                    print(string.format("  Data: %s", jsonData))
                else
                    print(string.format("  Data: %s", tostring(req.data)))
                end
            end
        end)
    end
end

-- Analyze all captured RequestIds
function NetworkInterceptor.analyzeRequestTypes()
    local success, err = pcall(function()
        print(string.format("\n=== RequestId Analysis (%d total requests) ===", #NetworkInterceptor.requests))
        
        local idCounts = {}
        local idExamples = {}
        
        for _, req in ipairs(NetworkInterceptor.requests) do
            local id = tostring(req.requestId)
            idCounts[id] = (idCounts[id] or 0) + 1
            
            if not idExamples[id] and req.data and type(req.data) == "table" then
                idExamples[id] = req
            end
        end
        
        local sortedIds = {}
        for id, count in pairs(idCounts) do
            table.insert(sortedIds, {id = id, count = count})
        end
        table.sort(sortedIds, function(a, b) return a.count > b.count end)
        
        print("\nRequestId frequencies:")
        for _, entry in ipairs(sortedIds) do
            print(string.format("\n  RequestId %s: %d times", entry.id, entry.count))
            
            local example = idExamples[entry.id]
            if example and example.data then
                local keys = {}
                for k, _ in pairs(example.data) do
                    table.insert(keys, tostring(k))
                end
                if #keys > 0 then
                    print("    Keys: " .. table.concat(keys, ", "))
                end
            end
        end
        
        print("\n💡 Use NetworkInterceptor.showRequestId(ID, count) to see specific requests")
    end)
    
    if not success then
        warn("❌ Analysis error:", err)
    end
end

-- Show details of specific RequestId
function NetworkInterceptor.showRequestId(requestId, count)
    local success, err = pcall(function()
        count = count or 5
        print(string.format("\n=== Recent RequestId %s ===", tostring(requestId)))
        
        local found = {}
        for i = #NetworkInterceptor.requests, 1, -1 do
            local req = NetworkInterceptor.requests[i]
            if tostring(req.requestId) == tostring(requestId) then
                table.insert(found, req)
                if #found >= count then
                    break
                end
            end
        end
        
        if #found == 0 then
            print("No requests found")
            return
        end
        
        for i, req in ipairs(found) do
            print(string.format("\n[%d] %.1fs ago", i, tick() - req.timestamp))
            
            if req.data and type(req.data) == "table" then
                for key, value in pairs(req.data) do
                    if type(value) == "table" then
                        local subKeys = {}
                        for k, _ in pairs(value) do
                            table.insert(subKeys, tostring(k))
                        end
                        print(string.format("  %s = {%s}", key, table.concat(subKeys, ", ")))
                    else
                        print(string.format("  %s = %s", key, tostring(value)))
                    end
                end
            end
        end
    end)
    
    if not success then
        warn("❌ ShowRequestId error:", err)
    end
end

-- =====================================================
-- RACE CONDITION DUPER
-- =====================================================

local RaceConditionDuper = {}
RaceConditionDuper.enabled = false
RaceConditionDuper.targetSlot = nil

function RaceConditionDuper.enable(slot)
    RaceConditionDuper.enabled = true
    RaceConditionDuper.targetSlot = slot
    
    print("\n=== Race Condition Duper ===")
    print("This attempts to duplicate items by sending requests simultaneously")
    print(string.format("Target slot: %s", tostring(slot)))
    print("\nPlace an item in the target slot and it will attempt to dupe it")
    
    -- This would require finding the exact request structure
    -- Common dupe methods:
    -- 1. Send move item requests at the same time
    -- 2. Send drop + store requests simultaneously
    -- 3. Exploit client-server sync issues
end

function RaceConditionDuper.disable()
    RaceConditionDuper.enabled = false
    print("✓ Race condition duper disabled")
end

-- =====================================================
-- REQUEST SPAM DUPER
-- =====================================================

local RequestSpamDuper = {}
RequestSpamDuper.enabled = false
RequestSpamDuper.targetItem = nil

function RequestSpamDuper.spamRequest(requestType, data, count)
    count = count or 10
    
    print(string.format("\n🔄 Spamming %d requests...", count))
    
    pcall(function()
        local networkModule = safeRequire("TS", "network", "network-service")
        if not networkModule then return end
        local NetworkService = networkModule.NetworkService
        
        if NetworkService and NetworkService.sendClientRequest then
            -- Send multiple requests rapidly
            for i = 1, count do
                task.spawn(function()
                    NetworkService:sendClientRequest(requestType, data)
                    print(string.format("  Sent request %d/%d", i, count))
                end)
            end
            
            print("✓ All requests sent")
        end
    end)
end

-- =====================================================
-- STORAGE TRANSFER DUPER
-- =====================================================

local StorageTransferDuper = {}

function StorageTransferDuper.findStorageRemotes()
    print("\n=== Scanning for Storage Remotes ===")
    
    pcall(function()
        local remotesModule = safeRequire("TS", "remotes", "remotes")
        if not remotesModule then return end
        local Remotes = remotesModule.default
        
        if Remotes then
            -- Look for storage-related remotes
            for _, container in ipairs({Remotes.Client, Remotes.Server}) do
                if container then
                    for _, remote in ipairs(container:GetChildren()) do
                        local name = remote.Name
                        if name:match("Storage") or name:match("Transfer") or name:match("Move") or 
                           name:match("Item") or name:match("Inventory") or name:match("Chest") then
                            print(string.format("✓ Found: %s (%s)", name, remote.ClassName))
                        end
                    end
                end
            end
        end
    end)
end

function StorageTransferDuper.dupeViaTransfer(itemSlot, targetStorage)
    print("\n=== Storage Transfer Dupe ===")
    print("This method tries to dupe by transferring to storage multiple times")
    
    -- Method: Send transfer to storage + drop item at same time
    -- Or: Send transfer to multiple storages simultaneously
    
    warn("⚠️ Not implemented yet - need to find exact transfer remote structure")
end

-- =====================================================
-- MULTI-SLOT DUPER
-- =====================================================

local MultiSlotDuper = {}

function MultiSlotDuper.dupeToSlots(itemSlot, targetSlots)
    print("\n=== Multi-Slot Dupe ===")
    print("Attempting to place same item in multiple slots simultaneously")
    
    -- Send move item requests to multiple slots at once
    for i, targetSlot in ipairs(targetSlots) do
        task.spawn(function()
            print(string.format("  Copying to slot %d", targetSlot))
            -- Send move request
        end)
    end
    
    warn("⚠️ Not implemented yet - need inventory slot structure")
end

-- =====================================================
-- DROP/PICKUP DUPER
-- =====================================================

local DropPickupDuper = {}
DropPickupDuper.enabled = false

function DropPickupDuper.enable()
    DropPickupDuper.enabled = true
    
    print("\n=== Drop/Pickup Duper ===")
    print("This method exploits the drop/pickup cycle")
    print("\nHow it works:")
    print("1. Drop item")
    print("2. Immediately pick it up (multiple times)")
    print("3. Server may not validate properly")
    
    -- Hook drop and pickup to spam them
    warn("⚠️ Experimental - may not work")
end

function DropPickupDuper.disable()
    DropPickupDuper.enabled = false
end

-- =====================================================
-- ITEM CLONER (CLIENT-SIDE)
-- =====================================================

local ItemCloner = {}

function ItemCloner.cloneItem(item)
    if not item then
        warn("No item specified")
        return nil
    end
    
    print(string.format("🔄 Cloning item: %s", item.Name))
    
    -- Clone the item object (client-side only)
    local cloned = item:Clone()
    cloned.Parent = Player.Backpack
    
    print("✓ Item cloned (CLIENT-SIDE ONLY)")
    print("⚠️ This is visual only - server won't recognize it")
    
    return cloned
end

function ItemCloner.massClone(item, count)
    count = count or 10
    
    print(string.format("🔄 Mass cloning %s x%d", item.Name, count))
    
    for i = 1, count do
        local cloned = item:Clone()
        cloned.Parent = Player.Backpack
        task.wait(0.1)
    end
    
    print("✓ Mass clone complete (CLIENT-SIDE ONLY)")
end

-- =====================================================
-- COMPREHENSIVE REMOTE SCANNER
-- =====================================================

local RemoteScanner = {}
RemoteScanner.hookedRemotes = {}
RemoteScanner.remoteTraffic = {}

function RemoteScanner.scanAllRemotes()
    print("\n=== Scanning ALL RemoteEvents/Functions ===")
    
    local remoteEvents = {}
    local remoteFunctions = {}
    
    for _, descendant in ipairs(game:GetDescendants()) do
        if descendant:IsA("RemoteEvent") then
            table.insert(remoteEvents, descendant:GetFullName())
        elseif descendant:IsA("RemoteFunction") then
            table.insert(remoteFunctions, descendant:GetFullName())
        end
    end
    
    print(string.format("Found %d RemoteEvents, %d RemoteFunctions", #remoteEvents, #remoteFunctions))
    
    return {events = remoteEvents, functions = remoteFunctions}
end

function RemoteScanner.hookAllRemotes()
    print("\n🔗 Hooking ALL RemoteEvents...")
    
    local hooked = 0
    
    for _, descendant in ipairs(game:GetDescendants()) do
        if descendant:IsA("RemoteEvent") then
            pcall(function()
                if not RemoteScanner.hookedRemotes[descendant] then
                    local oldFire = descendant.FireServer
                    if oldFire then
                        descendant.FireServer = function(self, ...)
                            local args = {...}
                            
                            -- Log all traffic
                            table.insert(RemoteScanner.remoteTraffic, {
                                remote = descendant:GetFullName(),
                                args = args,
                                timestamp = tick()
                            })
                            
                            print(string.format("🔥 RemoteEvent: %s", descendant.Name))
                            for i, arg in ipairs(args) do
                                print(string.format("  [%d] %s (%s)", i, tostring(arg), type(arg)))
                            end
                            
                            return oldFire(self, ...)
                        end
                        
                        RemoteScanner.hookedRemotes[descendant] = true
                        hooked = hooked + 1
                    end
                end
            end)
        end
    end
    
    print(string.format("✓ Hooked %d RemoteEvents", hooked))
end

function RemoteScanner.showRecentTraffic(count)
    count = count or 10
    print(string.format("\n=== Recent Remote Traffic (last %d) ===", count))
    
    local start = math.max(1, #RemoteScanner.remoteTraffic - count + 1)
    for i = start, #RemoteScanner.remoteTraffic do
        local traffic = RemoteScanner.remoteTraffic[i]
        print(string.format("\n[%d] %s (%.1fs ago)", i, traffic.remote, tick() - traffic.timestamp))
        for j, arg in ipairs(traffic.args) do
            print(string.format("  [%d] %s", j, tostring(arg)))
        end
    end
end

function RemoteScanner.hookPurchaseRemote()
    print("\n💰 Hooking Purchase Remote...")
    
    local purchaseRemote = game:GetService("RobloxReplicatedStorage"):FindFirstChild("ServerSideBulkPurchaseEvent")
    
    if not purchaseRemote then
        warn("❌ Purchase remote not found!")
        return
    end
    
    print("✓ Found:", purchaseRemote:GetFullName())
    print("Type:", purchaseRemote.ClassName)
    
    -- Hook using metamethods for RemoteEvent
    local mt = getrawmetatable(purchaseRemote)
    setreadonly(mt, false)
    
    local oldNamecall = mt.__namecall
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if self == purchaseRemote and method == "FireServer" then
            print("\n💰 PURCHASE REQUEST INTERCEPTED!")
            print("Arguments:")
            for i, arg in ipairs(args) do
                if type(arg) == "table" then
                    print(string.format("  [%d] table:", i))
                    for k, v in pairs(arg) do
                        if type(v) == "table" then
                            print(string.format("    %s = table (nested)", tostring(k)))
                            for k2, v2 in pairs(v) do
                                print(string.format("      %s = %s", tostring(k2), tostring(v2)))
                            end
                        else
                            print(string.format("    %s = %s (%s)", tostring(k), tostring(v), type(v)))
                        end
                    end
                else
                    print(string.format("  [%d] %s (%s)", i, tostring(arg), type(arg)))
                end
            end
            
            -- Store for analysis
            table.insert(RemoteScanner.remoteTraffic, {
                remote = "ServerSideBulkPurchaseEvent",
                args = args,
                timestamp = tick()
            })
        end
        
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
    
    print("✓ Purchase remote hooked! Try buying something now.")
end

-- =====================================================
-- RACE CONDITION EXPLOITER
-- =====================================================

local RaceConditionExploiter = {}

function RaceConditionExploiter.rapidHotbarSwap()
    print("\n⚡ Starting rapid hotbar swap exploit...")
    print("This will rapidly change hotbar slots to find race conditions")
    
    local success, NetworkService = pcall(function()
        return safeRequire("TS", "network", "network-service").NetworkService
    end)
    
    if not success or not NetworkService then
        warn("❌ NetworkService not found")
        return
    end
    
    print("💡 Equip an item, then run this:")
    print("  -- Rapidly move item between slots")
    print("  for i = 1, 100 do")
    print("    -- Change hotbar slots rapidly")
    print("  end")
end

function RaceConditionExploiter.dropPickupSpam(itemName)
    print(string.format("\n⚡ Drop/Pickup spam for: %s", itemName or "item"))
    print("This will spam drop and pickup to find desyncs")
    
    local player = Players.LocalPlayer
    local character = player.Character
    
    if not character then
        warn("❌ No character found")
        return
    end
    
    local tool = character:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
    
    if not tool then
        warn("❌ No tool found. Equip an item first!")
        return
    end
    
    print(string.format("✓ Found tool: %s", tool.Name))
    print("🔄 Starting spam (10 iterations)...")
    
    for i = 1, 10 do
        pcall(function()
            -- Equip
            tool.Parent = character
            task.wait(0.05)
            -- Drop
            tool.Parent = workspace
            task.wait(0.05)
            -- Pickup
            tool.Parent = player.Backpack
            task.wait(0.05)
        end)
        print(string.format("  Iteration %d/10", i))
    end
    
    print("✓ Spam complete. Check for inventory desyncs!")
end

function RaceConditionExploiter.craftingSpam()
    print("\n⚡ Crafting spam exploit")
    print("Open a crafting menu and spam craft button while moving ingredients")
    print("This may cause duplication if server doesn't validate properly")
end

-- =====================================================
-- OTHER SYSTEMS EXPLOITER
-- =====================================================

local OtherSystems = {}

function OtherSystems.scanCurrency()
    print("\n💰 Scanning for currency systems...")
    
    local player = Players.LocalPlayer
    local found = {}
    
    -- Check leaderstats
    pcall(function()
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            print("✓ Found leaderstats:")
            for _, stat in ipairs(leaderstats:GetChildren()) do
                if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                    print(string.format("  %s: %s", stat.Name, tostring(stat.Value)))
                    table.insert(found, {name = stat.Name, value = stat.Value, instance = stat})
                end
            end
        end
    end)
    
    -- Check player attributes
    pcall(function()
        print("\n✓ Player attributes:")
        for name, value in pairs(player:GetAttributes()) do
            print(string.format("  %s = %s", name, tostring(value)))
            if name == "Coins" or name == "Admin" or name == "AchievementPoints" then
                print(string.format("    ⭐ EXPLOITABLE: %s", name))
            end
        end
    end)
    
    return found
end

function OtherSystems.setCoins(amount)
    local player = Players.LocalPlayer
    local currentCoins = player:GetAttribute("Coins")
    
    print(string.format("\n💰 Coin Manipulation"))
    print(string.format("Current: %s", tostring(currentCoins)))
    print(string.format("Setting to: %s", tostring(amount)))
    
    -- Try to set attribute (client-side only, server may reject)
    pcall(function()
        player:SetAttribute("Coins", amount)
        task.wait(0.5)
        print(string.format("New value: %s", tostring(player:GetAttribute("Coins"))))
        print("\n⚠️ This is CLIENT-SIDE ONLY")
        print("Server will overwrite if it validates properly")
        print("Try buying something to see if server accepts it!")
    end)
end

function OtherSystems.setAdmin(enabled)
    local player = Players.LocalPlayer
    
    print(string.format("\n👑 Admin Flag Manipulation"))
    print(string.format("Setting Admin to: %s", tostring(enabled)))
    
    pcall(function()
        player:SetAttribute("Admin", enabled)
        task.wait(0.5)
        print(string.format("New value: %s", tostring(player:GetAttribute("Admin"))))
        print("\n⚠️ This may not grant actual admin powers")
        print("Server usually validates admin status separately")
    end)
end

function OtherSystems.setAchievementPoints(amount)
    local player = Players.LocalPlayer
    
    print(string.format("\n⭐ Achievement Points Manipulation"))
    print(string.format("Setting to: %s", tostring(amount)))
    
    pcall(function()
        player:SetAttribute("AchievementPoints", amount)
        task.wait(0.5)
        print(string.format("New value: %s", tostring(player:GetAttribute("AchievementPoints"))))
    end)
end

function OtherSystems.monitorAttributeChanges()
    print("\n👁️ Monitoring attribute changes...")
    
    local player = Players.LocalPlayer
    
    player.AttributeChanged:Connect(function(attributeName)
        local value = player:GetAttribute(attributeName)
        print(string.format("🔔 %s changed to: %s", attributeName, tostring(value)))
    end)
    
    print("✓ Monitoring enabled. Changes will be logged.")
end

function OtherSystems.scanBlocks()
    print("\n🧱 Scanning for block/building system...")
    
    pcall(function()
        local blockModule = safeRequire("TS", "block", "block-service")
        if blockModule then
            print("✓ Found block service")
            for key, _ in pairs(blockModule) do
                print(string.format("  %s", key))
            end
        end
    end)
end

function OtherSystems.scanXP()
    print("\n⭐ Scanning for XP/Level system...")
    
    local player = Players.LocalPlayer
    
    pcall(function()
        -- Check for level in PlayerGui
        for _, gui in ipairs(player.PlayerGui:GetDescendants()) do
            if gui:IsA("TextLabel") then
                local text = gui.Text:lower()
                if text:match("level") or text:match("xp") or text:match("exp") then
                    print(string.format("✓ Found: %s = '%s'", gui:GetFullName(), gui.Text))
                end
            end
        end
    end)
end

-- =====================================================
-- REQUEST ID FINDER
-- =====================================================

local RequestIdFinder = {}

function RequestIdFinder.findItemRequestIds()
    print("\n=== Finding Item-Related Request IDs ===")
    
    pcall(function()
        local clientRequestModule = safeRequire("TS", "event", "client-request-id")
        if not clientRequestModule then return end
        local ClientRequestId = clientRequestModule.ClientRequestId
        
        if ClientRequestId then
            print("✓ Found ClientRequestId enum")
            
            -- Scan all request IDs
            for key, value in pairs(ClientRequestId) do
                if key:match("ITEM") or key:match("INVENTORY") or key:match("STORAGE") or 
                   key:match("DROP") or key:match("PICKUP") or key:match("TRANSFER") then
                    print(string.format("  📦 %s = %s", key, tostring(value)))
                end
            end
        end
    end)
end

-- =====================================================
-- MAIN EXECUTION
-- =====================================================

print("\n=== Islands Item Duper ===")

-- Initialize
InventoryFinder.findInventory()
NetworkInterceptor.hookNetworkRequests()
ItemScanner.scanInventory()

task.wait(1)

StorageTransferDuper.findStorageRemotes()
RequestIdFinder.findItemRequestIds()

print("\n=== Available Commands ===")
print("\n📊 Analysis:")
print("  ItemScanner.scanInventory() - Scan current items")
print("  NetworkInterceptor.analyzeRequestTypes() - Show all RequestIds captured")
print("  NetworkInterceptor.showRequestId(ID, count) - Show specific RequestId details")
print("  NetworkInterceptor.dumpItemRequests(10) - Show recent item requests")
print("  RemoteScanner.scanAllRemotes() - Find ALL RemoteEvents/Functions")
print("  RemoteScanner.hookAllRemotes() - Hook and monitor ALL remotes")
print("  RemoteScanner.hookPurchaseRemote() - Hook ServerSideBulkPurchaseEvent")
print("  RemoteScanner.showRecentTraffic(10) - Show recent remote calls")

print("\n⚡ Race Condition Exploits:")
print("  RaceConditionExploiter.rapidHotbarSwap() - Rapid slot changes")
print("  RaceConditionExploiter.dropPickupSpam() - Spam drop/pickup (equip item first!)")
print("  RaceConditionExploiter.craftingSpam() - Spam crafting operations")

print("\n💎 Other Systems:")
print("  OtherSystems.scanCurrency() - Find coins/money systems")
print("  OtherSystems.setCoins(amount) - Change coin amount (client-side)")
print("  OtherSystems.setAdmin(true) - Try to enable admin flag")
print("  OtherSystems.setAchievementPoints(amount) - Change achievement points")
print("  OtherSystems.monitorAttributeChanges() - Watch for attribute changes")
print("  OtherSystems.scanXP() - Find XP/level systems")
print("  OtherSystems.scanBlocks() - Find block/building systems")

print("\n🔄 Duplication Methods:")
print("  RaceConditionDuper.enable(slot) - Race condition dupe (EXPERIMENTAL)")
print("  RequestSpamDuper.spamRequest(type, data, 10) - Spam requests")
print("  MultiSlotDuper.dupeToSlots(slot, {1,2,3}) - Multi-slot dupe")
print("  DropPickupDuper.enable() - Drop/pickup exploit")

print("\n🎨 Client-Side (Visual Only):")
print("  ItemCloner.cloneItem(tool) - Clone a tool (client-side)")
print("  ItemCloner.massClone(tool, 10) - Mass clone (client-side)")

print("\n⚠️ IMPORTANT NOTES:")
print("  - Most dupe methods require finding exact request structures")
print("  - Server-side validation may prevent duplication")
print("  - Use NetworkInterceptor to capture real item requests")
print("  - Then modify this script with correct request IDs and data")

print("\n💡 How to Find Duplication Exploits:")
print("  1. Enable NetworkInterceptor")
print("  2. Move items around in inventory")
print("  3. Drop/pickup items")
print("  4. Transfer to chests")
print("  5. Check dumpItemRequests() to see the request structure")
print("  6. Look for race conditions or validation bugs")

return {
    InventoryFinder = InventoryFinder,
    ItemScanner = ItemScanner,
    NetworkInterceptor = NetworkInterceptor,
    RemoteScanner = RemoteScanner,
    RaceConditionExploiter = RaceConditionExploiter,
    OtherSystems = OtherSystems,
    RaceConditionDuper = RaceConditionDuper,
    RequestSpamDuper = RequestSpamDuper,
    StorageTransferDuper = StorageTransferDuper,
    MultiSlotDuper = MultiSlotDuper,
    DropPickupDuper = DropPickupDuper,
    ItemCloner = ItemCloner,
    RequestIdFinder = RequestIdFinder
}
