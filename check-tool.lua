--> Tool Checker - See what tools you have equipped

print("[Tool Checker] Checking your character...")

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character

if not Character then
    warn("[Tool Checker] Character not found!")
    return
end

print("\n=== CHARACTER INFO ===")
print("Character: " .. Character.Name)

-- Check for equipped tool
local tool = Character:FindFirstChildOfClass("Tool")
if tool then
    print("\n✓ TOOL EQUIPPED:")
    print("  Name: " .. tool.Name)
    print("  Class: " .. tool.ClassName)
    
    -- Check tool properties
    for _, child in ipairs(tool:GetChildren()) do
        print("  - " .. child.Name .. " (" .. child.ClassName .. ")")
    end
else
    print("\n✗ NO TOOL EQUIPPED!")
    print("  You might need to equip a pickaxe to mine!")
end

-- Check backpack
local backpack = Player:FindFirstChild("Backpack")
if backpack then
    print("\n=== BACKPACK ===")
    local tools = backpack:GetChildren()
    if #tools > 0 then
        for _, item in ipairs(tools) do
            if item:IsA("Tool") then
                print("  - " .. item.Name)
            end
        end
    else
        print("  Empty")
    end
end

-- Check for mining-related objects
print("\n=== CHECKING FOR MINING TOOLS ===")
local foundPickaxe = false
for _, item in ipairs(Character:GetDescendants()) do
    if item.Name:lower():find("pick") or item.Name:lower():find("axe") or item.Name:lower():find("mine") then
        print("  Found: " .. item.Name .. " (" .. item.ClassName .. ")")
        foundPickaxe = true
    end
end

if backpack then
    for _, item in ipairs(backpack:GetDescendants()) do
        if item.Name:lower():find("pick") or item.Name:lower():find("axe") or item.Name:lower():find("mine") then
            print("  Found in backpack: " .. item.Name .. " (" .. item.ClassName .. ")")
            foundPickaxe = true
        end
    end
end

if not foundPickaxe then
    print("  ⚠️ No mining tools found! You may need to buy/equip a pickaxe.")
end

print("\n[Tool Checker] Done!")
