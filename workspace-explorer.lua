--> Workspace Explorer
--> Lists all folders and objects in Workspace

print("[Workspace Explorer] Scanning Workspace...")
print("")

local Workspace = game:GetService("Workspace")

-- Recursively list all descendants
local function ListChildren(parent, indent, maxDepth, currentDepth)
    indent = indent or ""
    maxDepth = maxDepth or 10
    currentDepth = currentDepth or 0
    
    if currentDepth >= maxDepth then
        print(indent .. "  [Max depth reached]")
        return
    end
    
    local children = parent:GetChildren()
    
    -- Sort children by name
    table.sort(children, function(a, b)
        return a.Name < b.Name
    end)
    
    for _, child in ipairs(children) do
        local className = child.ClassName
        local name = child.Name
        
        -- Color-code by type
        local icon = ""
        if child:IsA("Folder") then
            icon = "📁"
        elseif child:IsA("Model") then
            icon = "🎭"
        elseif child:IsA("Part") or child:IsA("MeshPart") then
            icon = "🟦"
        elseif child:IsA("Script") or child:IsA("LocalScript") then
            icon = "📜"
        elseif child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            icon = "📡"
        else
            icon = "📄"
        end
        
        print(string.format("%s%s %s (%s)", indent, icon, name, className))
        
        -- Recursively list children
        if #child:GetChildren() > 0 then
            ListChildren(child, indent .. "  ", maxDepth, currentDepth + 1)
        end
    end
end

-- Get stats
local function GetStats(parent)
    local stats = {
        total = 0,
        folders = 0,
        models = 0,
        parts = 0,
        scripts = 0,
        remotes = 0,
        other = 0
    }
    
    for _, descendant in ipairs(parent:GetDescendants()) do
        stats.total = stats.total + 1
        
        if descendant:IsA("Folder") then
            stats.folders = stats.folders + 1
        elseif descendant:IsA("Model") then
            stats.models = stats.models + 1
        elseif descendant:IsA("BasePart") then
            stats.parts = stats.parts + 1
        elseif descendant:IsA("LuaSourceContainer") then
            stats.scripts = stats.scripts + 1
        elseif descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            stats.remotes = stats.remotes + 1
        else
            stats.other = stats.other + 1
        end
    end
    
    return stats
end

-- Show stats first
local stats = GetStats(Workspace)
print("=" .. string.rep("=", 60))
print("WORKSPACE STATISTICS")
print("=" .. string.rep("=", 60))
print(string.format("Total Objects: %d", stats.total))
print(string.format("  Folders: %d", stats.folders))
print(string.format("  Models: %d", stats.models))
print(string.format("  Parts: %d", stats.parts))
print(string.format("  Scripts: %d", stats.scripts))
print(string.format("  Remotes: %d", stats.remotes))
print(string.format("  Other: %d", stats.other))
print("=" .. string.rep("=", 60))
print("")

-- List everything
print("WORKSPACE HIERARCHY")
print("=" .. string.rep("=", 60))
ListChildren(Workspace, "", 10)
print("=" .. string.rep("=", 60))
print("")
print("[Workspace Explorer] Complete!")
print("")
print("Want to explore a specific folder?")
print("Use: _G.ExploreFolder(folderPath)")
print("Example: _G.ExploreFolder('Workspace.EntityFolder')")

-- Helper function to explore specific folder
_G.ExploreFolder = function(path)
    local target = game
    for part in string.gmatch(path, "[^.]+") do
        target = target:FindFirstChild(part)
        if not target then
            print("Path not found: " .. path)
            return
        end
    end
    
    print("")
    print("Exploring: " .. target:GetFullName())
    print("=" .. string.rep("=", 60))
    ListChildren(target, "", 10)
    print("=" .. string.rep("=", 60))
end

-- Helper to save to file (if executor supports)
_G.SaveWorkspaceTree = function()
    local output = {"WORKSPACE TREE\n" .. string.rep("=", 60) .. "\n"}
    
    local function BuildTree(parent, indent)
        indent = indent or ""
        for _, child in ipairs(parent:GetChildren()) do
            table.insert(output, string.format("%s%s (%s)", indent, child.Name, child.ClassName))
            if #child:GetChildren() > 0 then
                BuildTree(child, indent .. "  ")
            end
        end
    end
    
    BuildTree(Workspace)
    
    local text = table.concat(output, "\n")
    
    -- Try to save (may not work on all executors)
    if writefile then
        writefile("workspace_tree.txt", text)
        print("[Workspace Explorer] Saved to workspace_tree.txt")
    else
        print("[Workspace Explorer] writefile not supported by executor")
        print("Tree copied to clipboard (if supported):")
        if setclipboard then
            setclipboard(text)
            print("Copied to clipboard!")
        end
    end
end

print("Save tree to file: _G.SaveWorkspaceTree()")
