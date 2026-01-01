--> Folder Browser
--> Browse workspace folders interactively

print("[Folder Browser] Starting...")
print("")

local Workspace = game:GetService("Workspace")

-- List all folders in a parent
local function ListFolders(parent, showPath)
    showPath = showPath or false
    local folders = {}
    
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("Folder") or child:IsA("Model") then
            table.insert(folders, child)
        end
    end
    
    -- Sort alphabetically
    table.sort(folders, function(a, b) return a.Name < b.Name end)
    
    if #folders == 0 then
        print("No folders found!")
        return folders
    end
    
    print("=" .. string.rep("=", 60))
    if showPath then
        print("Location: " .. parent:GetFullName())
        print("=" .. string.rep("=", 60))
    end
    print(string.format("Found %d folders:", #folders))
    print("")
    
    for i, folder in ipairs(folders) do
        local icon = folder:IsA("Folder") and "📁" or "🎭"
        local childCount = #folder:GetChildren()
        print(string.format("[%d] %s %s (%d children)", i, icon, folder.Name, childCount))
    end
    
    print("=" .. string.rep("=", 60))
    
    return folders
end

-- List all contents of a folder
local function ListFolderContents(folder)
    print("")
    print("=" .. string.rep("=", 60))
    print("Exploring: " .. folder:GetFullName())
    print("=" .. string.rep("=", 60))
    
    local children = folder:GetChildren()
    table.sort(children, function(a, b) return a.Name < b.Name end)
    
    if #children == 0 then
        print("Empty folder!")
        return
    end
    
    print(string.format("Total objects: %d", #children))
    print("")
    
    -- Group by type
    local grouped = {}
    for _, child in ipairs(children) do
        local type = child.ClassName
        if not grouped[type] then
            grouped[type] = {}
        end
        table.insert(grouped[type], child)
    end
    
    -- Display grouped
    for type, items in pairs(grouped) do
        print(string.format("[%s] (%d)", type, #items))
        for i, item in ipairs(items) do
            if i <= 10 then
                print(string.format("  - %s", item.Name))
            elseif i == 11 then
                print(string.format("  ... and %d more", #items - 10))
                break
            end
        end
        print("")
    end
    
    print("=" .. string.rep("=", 60))
end

-- Initial folder list
print("WORKSPACE FOLDERS")
local folders = ListFolders(Workspace)

print("")
print("Commands:")
print("  _G.Browse(number) - Open folder by number")
print("  _G.Browse('FolderName') - Open folder by name")
print("  _G.Back() - Go back to Workspace folders")
print("  _G.List(folder) - Show contents of any folder")
print("")
print("Example: _G.Browse(1) or _G.Browse('EntityFolder')")

-- Store current context
_G.CurrentFolders = folders
_G.CurrentParent = Workspace

-- Browse function
_G.Browse = function(target)
    local folder = nil
    
    if type(target) == "number" then
        folder = _G.CurrentFolders[target]
        if not folder then
            print("Invalid folder number! Use 1-" .. #_G.CurrentFolders)
            return
        end
    elseif type(target) == "string" then
        -- Search by name
        for _, f in ipairs(_G.CurrentFolders) do
            if f.Name:lower() == target:lower() then
                folder = f
                break
            end
        end
        if not folder then
            print("Folder not found: " .. target)
            print("Available folders:")
            for i, f in ipairs(_G.CurrentFolders) do
                print(string.format("  [%d] %s", i, f.Name))
            end
            return
        end
    else
        print("Usage: _G.Browse(number) or _G.Browse('name')")
        return
    end
    
    -- Show contents
    ListFolderContents(folder)
    
    -- Check for subfolders
    local subfolders = {}
    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("Folder") or child:IsA("Model") then
            table.insert(subfolders, child)
        end
    end
    
    if #subfolders > 0 then
        print("")
        print("Subfolders in " .. folder.Name .. ":")
        print("")
        table.sort(subfolders, function(a, b) return a.Name < b.Name end)
        for i, sub in ipairs(subfolders) do
            local icon = sub:IsA("Folder") and "📁" or "🎭"
            print(string.format("  [%d] %s %s", i, icon, sub.Name))
        end
        print("")
        print("Browse subfolder: _G.Browse(number)")
        
        _G.CurrentFolders = subfolders
        _G.CurrentParent = folder
    else
        print("")
        print("No subfolders. Use _G.Back() to return.")
    end
end

-- Go back
_G.Back = function()
    print("")
    print("WORKSPACE FOLDERS")
    _G.CurrentFolders = ListFolders(Workspace)
    _G.CurrentParent = Workspace
end

-- List any folder
_G.List = function(folder)
    if type(folder) == "string" then
        -- Try to find it
        folder = Workspace:FindFirstChild(folder, true)
        if not folder then
            print("Folder not found!")
            return
        end
    end
    
    if not folder then
        print("Usage: _G.List(folderObject) or _G.List('FolderName')")
        return
    end
    
    ListFolderContents(folder)
end

print("[Folder Browser] Ready!")
