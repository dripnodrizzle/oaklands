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
                    if data and type(data) == "table" and (data.item or data.itemId or data.slot or data.amount) then
                        table.insert(NetworkInterceptor.itemRequests, {
                            requestId = requestId,
                            data = serializedData,
                            timestamp = tick()
                        })
                        print("  📦 Item-related request detected!")
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
print("  NetworkInterceptor.dumpItemRequests(10) - Show recent item requests")
print("  StorageTransferDuper.findStorageRemotes() - Find storage remotes")
print("  RequestIdFinder.findItemRequestIds() - Find item request IDs")

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
    RaceConditionDuper = RaceConditionDuper,
    RequestSpamDuper = RequestSpamDuper,
    StorageTransferDuper = StorageTransferDuper,
    MultiSlotDuper = MultiSlotDuper,
    DropPickupDuper = DropPickupDuper,
    ItemCloner = ItemCloner,
    RequestIdFinder = RequestIdFinder
}
