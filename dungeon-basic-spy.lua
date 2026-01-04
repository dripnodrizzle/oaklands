print("Starting spy")

local events = {}
local RS = game.ReplicatedStorage
local eventsFolder = RS.Events

if not eventsFolder then
    print("No events folder")
    return
end

local dungeonFolder = eventsFolder.Dungeon
if not dungeonFolder then
    print("No dungeon folder")
    return
end

print("Found dungeon folder")

local getChildren = dungeonFolder.GetChildren
local children = getChildren(dungeonFolder)

for i, remote in pairs(children) do
    local remoteName = remote.Name
    local oldFire = remote.FireServer
    
    remote.FireServer = function(self, ...)
        local args = {...}
        
        print("EVENT FIRED")
        print(remoteName)
        
        for j, arg in pairs(args) do
            print(tostring(arg))
        end
        
        table.insert(events, {name = remoteName, args = args})
        
        return oldFire(self, ...)
    end
    
    print("Hooked")
    print(remoteName)
end

_G.ShowEvents = function()
    print("Total events")
    print(#events)
    
    for i, event in pairs(events) do
        print("Event")
        print(event.name)
        
        for j, arg in pairs(event.args) do
            print(tostring(arg))
        end
    end
end

print("Spy active")
