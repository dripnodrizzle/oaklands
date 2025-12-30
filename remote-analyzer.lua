--> Comprehensive Remote Analyzer
--> Logs ALL remotes fired with full details while you attack NPCs

print("[Analyzer] Starting comprehensive remote analysis...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local loggedRemotes = {}
local remoteCallCount = {}

-- Helper to serialize any value
local function SerializeValue(value, depth)
    depth = depth or 0
    if depth > 3 then return "..." end
    
    local valueType = type(value)
    
    if valueType == "nil" then
        return "nil"
    elseif valueType == "string" then
        return string.format('"%s"', value)
    elseif valueType == "number" then
        return tostring(value)
    elseif valueType == "boolean" then
        return tostring(value)
    elseif valueType == "userdata" then
        local typeOf = typeof(value)
        if typeOf == "Instance" then
            pcall(function()
                return string.format("%s (%s)", value:GetFullName(), value.ClassName)
            end)
            return string.format("Instance<%s>", value.ClassName or "Unknown")
        elseif typeOf == "Vector3" then
            return string.format("Vector3(%s, %s, %s)", value.X, value.Y, value.Z)
        elseif typeOf == "CFrame" then
            return string.format("CFrame(pos: %s, %s, %s)", value.Position.X, value.Position.Y, value.Position.Z)
        else
            return string.format("%s <%s>", tostring(value), typeOf)
        end
    elseif valueType == "table" then
        local result = "{"
        local count = 0
        for k, v in pairs(value) do
            if count > 0 then result = result .. ", " end
            result = result .. string.format("[%s] = %s", SerializeValue(k, depth + 1), SerializeValue(v, depth + 1))
            count = count + 1
            if count > 10 then
                result = result .. ", ..."
                break
            end
        end
        result = result .. "}"
        return result
    else
        return tostring(value)
    end
end

-- Hook all RemoteEvents and RemoteFunctions
local hookActive = true
local oldNamecall

local function HookAllRemotes()
    local hookedCount = 0
    
    -- Find all remotes
    local allRemotes = {}
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(allRemotes, obj)
        end
    end
    
    print(string.format("[Analyzer] Found %d total remotes", #allRemotes))
    
    -- Hook metamethod (non-blocking)
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Always call the original first to prevent blocking
        local result = {oldNamecall(self, ...)}
        
        -- Then log if it's a remote we care about
        if hookActive and (method == "FireServer" or method == "InvokeServer") and 
           (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
            
            task.spawn(function()
                pcall(function()
                    local remotePath = self:GetFullName()
                    
                    -- Count calls
                    remoteCallCount[remotePath] = (remoteCallCount[remotePath] or 0) + 1
                    
                    -- Log the call
                    local logEntry = {
                        name = self.Name,
                        path = remotePath,
                        method = method,
                        args = {},
                        time = os.time(),
                        count = remoteCallCount[remotePath]
                    }
                    
                    -- Serialize arguments
                    for i, arg in ipairs(args) do
                        logEntry.args[i] = {
                            type = type(arg),
                            typeof = typeof(arg),
                            value = SerializeValue(arg)
                        }
                    end
                    
                    table.insert(loggedRemotes, logEntry)
                    
                    -- Print important ones
                    local remoteName = self.Name:lower()
                    if remoteName:find("attack") or remoteName:find("damage") or 
                       remoteName:find("hit") or remoteName:find("combat") or
                       remoteName:find("kill") or remoteName:find("fight") then
                        
                        print(string.format("\n[IMPORTANT] %s:%s", self.Name, method))
                        print(string.format("  Path: %s", remotePath))
                        print(string.format("  Call #%d", logEntry.count))
                        print("  Arguments:")
                        for i, arg in ipairs(logEntry.args) do
                            print(string.format("    [%d] %s (%s) = %s", i, arg.type, arg.typeof, arg.value))
                        end
                        print("")
                    end
                end)
            end)
        end
        
        return unpack(result)
    end)
    
    print("[Analyzer] Hooked all remote calls!")
end

-- Monitor NPC health changes
local function MonitorNPCs()
    local EntityFolder = Workspace:FindFirstChild("EntityFolder")
    if not EntityFolder then return end
    
    for _, npc in ipairs(EntityFolder:GetChildren()) do
        if npc:IsA("Model") then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.HealthChanged:Connect(function(health)
                    if health < humanoid.MaxHealth then
                        print(string.format("\n[NPC DAMAGED] %s health: %.1f/%.1f", npc.Name, health, humanoid.MaxHealth))
                    end
                    if health <= 0 then
                        print(string.format("[NPC KILLED] %s died!", npc.Name))
                    end
                end)
            end
        end
    end
    
    print("[Analyzer] Monitoring NPC health changes")
end

-- Analysis report command
_G.ShowRemoteReport = function()
    print("\n========== REMOTE CALL REPORT ==========")
    
    -- Sort by call count
    local sorted = {}
    for path, count in pairs(remoteCallCount) do
        table.insert(sorted, {path = path, count = count})
    end
    table.sort(sorted, function(a, b) return a.count > b.count end)
    
    print("\nMost called remotes:")
    for i = 1, math.min(20, #sorted) do
        print(string.format("  %d. [%dx] %s", i, sorted[i].count, sorted[i].path))
    end
    
    print("\n\nRecent important calls:")
    local recentCount = 0
    for i = #loggedRemotes, math.max(1, #loggedRemotes - 50), -1 do
        local log = loggedRemotes[i]
        local name = log.name:lower()
        
        if name:find("attack") or name:find("damage") or name:find("hit") or 
           name:find("combat") or name:find("skill") then
            recentCount = recentCount + 1
            print(string.format("\n%d. %s:%s (call #%d)", recentCount, log.name, log.method, log.count))
            print("   Args:")
            for j, arg in ipairs(log.args) do
                print(string.format("     [%d] %s = %s", j, arg.typeof, arg.value))
            end
            
            if recentCount >= 10 then break end
        end
    end
    
    print("\n========================================")
end

-- Toggle hook on/off
_G.ToggleAnalyzer = function()
    hookActive = not hookActive
    print(string.format("[Analyzer] Hook is now %s", hookActive and "ENABLED" or "DISABLED"))
    if not hookActive then
        print("[Analyzer] Your UI should work normally now")
    end
end

-- Start monitoring
HookAllRemotes()
MonitorNPCs()

print("")
print("========== ANALYZER READY ==========")
print("1. Attack some NPCs now")
print("2. Watch the console for [IMPORTANT] remote calls")
print("3. Run: _G.ShowRemoteReport() for full analysis")
print("4. Run: _G.ToggleAnalyzer() to disable/enable hook")
print("5. If buttons don't work, run: _G.ToggleAnalyzer()")
print("====================================")
print("")
