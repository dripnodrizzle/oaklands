print("[KA] Start")

local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
if not LP then return end

local folder = WS:FindFirstChild("EntityFolder")
local events = RS:FindFirstChild("Events")
local combat = events and events:FindFirstChild("Combat")
local attack = combat and combat:FindFirstChild("Attack")
if not folder or not attack then return end

local radius = 45
local interval = 0.015
local maxTick = 4
local tweak = true
local scale = 0.6
local offset = Vector3.new(0,-1.2,0)

local running = true
local calls = 0
local start = tick()
local seen = {}
local last = {}

local function getRoot()
    local c = LP.Character
    if not c then return nil,nil end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then return nil,nil end
    return c,r
end

local function partOf(m)
    return m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart or m:FindFirstChildOfClass("BasePart")
end

local function restore()
    for p,d in pairs(seen) do
        if p and p.Parent and d then
            pcall(function() p.Size = d.s p.CFrame = d.c end)
        end
    end
    table.clear(seen)
end

local function apply(c)
    if not tweak then return end
    local ok = {HumanoidRootPart=true,Head=true,UpperTorso=true,LowerTorso=true,Torso=true}
    for _,p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") and ok[p.Name] and not seen[p] then
            seen[p] = {s=p.Size,c=p.CFrame}
            pcall(function() p.Size = p.Size * scale p.CFrame = p.CFrame + offset p.CanCollide = false end)
        end
    end
end

local conn
conn = RunService.Heartbeat:Connect(function()
    if not running then return end
    local c,r = getRoot()
    if not c or not r then return end
    if tweak then apply(c) end

    local now = tick()
    local done = 0
    for _,npc in ipairs(folder:GetChildren()) do
        if done >= maxTick then break end
        if npc:IsA("Model") and npc ~= c then
            local hum = npc:FindFirstChildOfClass("Humanoid")
            local rp = partOf(npc)
            if hum and hum.Health > 0 and rp and (rp.Position - r.Position).Magnitude <= radius then
                local t = last[npc] or 0
                if now - t >= interval then
                    last[npc] = now
                    pcall(function() attack:FireServer() end)
                    calls = calls + 1
                    done = done + 1
                end
            end
        end
    end

    for npc,t in pairs(last) do
        if (not npc.Parent) or (now - t > 6) then last[npc] = nil end
    end
end)

local function setTweak(v)
    tweak = v and true or false
    if not tweak then restore() end
    print("[KA] LocalHitbox: " .. (tweak and "ON" or "OFF"))
end

_G.SetLocalHitboxTweak = function(v) setTweak(v) end
_G.ToggleLocalHitboxTweak = function() setTweak(not tweak) end
_G.KillAuraStatus = function()
    print("[KA] Running: " .. tostring(running))
    print("[KA] Calls: " .. tostring(calls))
    print("[KA] LocalHitbox: " .. (tweak and "ON" or "OFF"))
end
_G.StopKillAura = function()
    running = false
    if conn then conn:Disconnect() conn = nil end
    restore()
    print("[KA] Stop | t=" .. tostring(math.floor((tick()-start)*10)/10) .. "s | c=" .. tostring(calls))
end

print("[KA] Running")
print("[KA] Stop: _G.StopKillAura()")
