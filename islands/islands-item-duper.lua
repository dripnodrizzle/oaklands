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
    pcall(function()
        local RuntimeLib = require(ReplicatedStorage.rbxts_include.RuntimeLib)
        
        -- Find inventory service
        local paths = {
            "TS/inventory/inventory-service",
            "TS/inventory/client-inventory-service",
            "TS/ui/inventory/client-inventory-ui-service"
        }
        
        for _, path in ipairs(paths) do
            pcall(function()
                local segments = {}
                for segment in path:gmatch("[^/]+") do
                    table.insert(segments, segment)
                end
                
                local module = RuntimeLib.import(nil, ReplicatedStorage, unpack(segments))
                if module then
                    print(string.format("✓ Found module at: %s", path))
                    
                    if path:match("client-inventory-ui-service") then
                        InventoryFinder.inventoryUI = module.ClientInventoryUIService
                    else
                        InventoryFinder.inventoryService = module
                    end
                end
            end)
        end
    end)
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

function NetworkInterceptor.hookNetworkRequests()
    pcall(function()
        local RuntimeLib = require(ReplicatedStorage.rbxts_include.RuntimeLib)
        local NetworkService = RuntimeLib.import(nil, ReplicatedStorage, "TS", "network", "network-service").NetworkService
        
        if NetworkService and NetworkService.sendClientRequest then
            local originalSendRequest = NetworkService.sendClientRequest
            
            NetworkService.sendClientRequest = function(self, requestId, data)
                -- Log all requests
                print(string.format("📡 Request: %s", tostring(requestId)))
                
                table.insert(NetworkInterceptor.requests, {
                    requestId = requestId,
                    data = data,
                    timestamp = tick()
                })
                
                -- Check if it's item-related
                if data and (data.item or data.itemId or data.slot or data.amount) then
                    print("  📦 Item-related request detected!")
                    print(string.format("  Data: %s", game:GetService("HttpService"):JSONEncode(data)))
                    
                    table.insert(NetworkInterceptor.itemRequests, {
                        requestId = requestId,
                        data = data,
                        timestamp = tick()
                    })
                end
                
                return originalSendRequest(self, requestId, data)
            end
            
            print("✓ Hooked NetworkService.sendClientRequest")
            return true
        end
    end)
end

function NetworkInterceptor.dumpItemRequests(count)
    count = count or 10
    print("\n=== Recent Item Requests ===")
    
    local start = math.max(1, #NetworkInterceptor.itemRequests - count + 1)
    for i = start, #NetworkInterceptor.itemRequests do
        local req = NetworkInterceptor.itemRequests[i]
        print(string.format("[%d] %s (%.1fs ago)", 
            i, tostring(req.requestId), tick() - req.timestamp))
        print(string.format("  Data: %s", game:GetService("HttpService"):JSONEncode(req.data)))
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
        local RuntimeLib = require(ReplicatedStorage.rbxts_include.RuntimeLib)
        local NetworkService = RuntimeLib.import(nil, ReplicatedStorage, "TS", "network", "network-service").NetworkService
        
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
        local RuntimeLib = require(ReplicatedStorage.rbxts_include.RuntimeLib)
        local Remotes = RuntimeLib.import(nil, ReplicatedStorage, "TS", "remotes", "remotes").default
        
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
        local RuntimeLib = require(ReplicatedStorage.rbxts_include.RuntimeLib)
        local ClientRequestId = RuntimeLib.import(nil, ReplicatedStorage, "TS", "event", "client-request-id").ClientRequestId
        
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
