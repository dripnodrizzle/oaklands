-- mt-api (formatted for readability)
-- NOTE: This relies on exploit-only functions (getrawmetatable, newcclosure, checkcaller, etc.)
-- and is not intended for normal Roblox Studio/client.

-- Prevent loading twice unless MTAPIDebug is enabled
if not getgenv().MTAPIDebug and getgenv().MTAPIMutex ~= nil then
	return
end

-- Detect executor / environment
local a = function()
	if is_protosmasher_caller ~= nil then return 0 end
	if elysianexecute ~= nil then return 1 end
	if fullaccess ~= nil then return 2 end
	if syn ~= nil then return 3 end
	return 4
end

-- Pick the correct "caller check" function for the executor
local function b()
	local c = a()
	if c == 0 then return is_protosmasher_caller end
	if c == 1 or c == 3 then return checkcaller end
	if c == 2 then error("mt-api: Exploit not supported") end
	return nil
end

-- Hook storage tables
local d = {} -- per-object GET hooks
local e = {} -- per-object SET blocks (ignore writes)
local f = {} -- per-object SET hooks
local g = {} -- per-object CALL hooks

local h = {} -- per-object property emulators

local i = {} -- global GET hooks (keyed by id)
local j = {} -- global SET hooks (keyed by id)
local k = {} -- global CALL hooks (keyed by id)
local l = {} -- global SET blocks (keyed by id)

-- Counters for global hook ids
local m = 0
local n = 0
local o = 0

-- Install metatable hooks
local function p()
	if not getrawmetatable then
		error("mt-api: Exploit not supported")
	end

	local c = a()
	local q = b()
	local r = getrawmetatable(game)

	-- Make metatable writable
	if c == 0 then
		make_writeable(r)
	elseif c == 2 then
		error("mt-api: Exploit not supported")
	else
		if setreadonly then
			setreadonly(r, false)
		else
			error("mt-api: Exploit not supported")
		end
	end

	-- Save original metamethods
	local s = r.__index
	local t = r.__newindex
	local u = r.__namecall

	----------------------------------------------------------------
	-- __index hook (property reads)
	----------------------------------------------------------------
	r.__index = newcclosure(function(self, v)
		-- If not debugging and caller is trusted, fall back to original
		if not getgenv().MTAPIDebug and q() then
			return s(self, v)
		end

		-- Per-object GET hook
		if d[self] and d[self][v] then
			local w = d[self][v]
			if w.IsCallback then
				return w.Value(self, s(self, v)) or s(self, v)
			else
				return w.Value or s(self, v)
			end

		-- Property emulator read
		elseif h[self] and h[self][v] then
			local x = h[self][v].Emulator
			return x[1]

		-- Global GET hooks
		else
			for _, z in next, i do
				if z[v] then
					local A = z[v]
					if A.IsCallback then
						return A.Value(self) or s(self, v)
					else
						return A.Value or s(self, v)
					end
				end
			end
		end

		return s(self, v)
	end)

	----------------------------------------------------------------
	-- __newindex hook (property writes)
	----------------------------------------------------------------
	r.__newindex = newcclosure(function(self, v, B)
		-- If not debugging and caller is trusted, fall back to original
		if not getgenv().MTAPIDebug and q() then
			return t(self, v, B)
		end

		-- Per-object SET hook
		if f[self] and f[self][v] then
			local C = f[self][v]
			if C.IsCallback then
				local D = C.Value(self, B)
				return t(self, v, D or B)
			else
				return t(self, v, C.Value or B)
			end

		-- Per-object SET block (ignore)
		elseif e[self] and e[self][v] then
			return

		-- Property emulator write
		elseif h[self] and h[self][v] then
			local x = h[self][v].Emulator
			x[1] = B
			return

		-- Global SET hooks / blocks
		else
			for _, z in next, j do
				if z[v] then
					local E = z[v]
					if E.IsCallback then
						local D = E.Value(self, B)
						return t(self, v, D or B)
					else
						return t(self, v, E.Value or B)
					end
				end
			end

			for _, z in next, l do
				if z[v] then
					return
				end
			end
		end

		return t(self, v, B)
	end)

	----------------------------------------------------------------
	-- __namecall hook (method calls + API entrypoints)
	----------------------------------------------------------------
	r.__namecall = newcclosure(function(self, ...)
		local F = { ... }
		local G = getnamecallmethod()

		-- If exploit caller, allow calling the "API" through namecalls
		if q() then
			-- Optional logging
			if getgenv()["MTAPISuperUser"] then
				local H = tostring(self) .. ":" .. tostring(G) .. "("
				local I = ""
				local J = ""

				for _, z in next, F do
					I = I .. tostring(z) .. ", "
					J = J .. typeof(z) .. ", "
				end

				I = I:sub(1, -3)
				J = J:sub(1, -3)
				H = H .. I .. ") (" .. J .. ")"
				rconsolewarn(H)
			end

			------------------------------------------------------------
			-- AddGetHook(propertyName, valueOrCallback)
			------------------------------------------------------------
			if G == "AddGetHook" then
				if #F < 1 then error("mt-api: Invalid argument count") end

				local v = F[1]
				local L = F[2]
				if type(v) ~= "string" then error("mt-api: Invalid hook type") end

				if not d[self] then d[self] = {} end
				d[self][v] = { Value = L, IsCallback = type(L) == "function" }

				local function M() d[self][v] = nil end
				local function N(_, P) d[self][v] = { Value = P, IsCallback = type(P) == "function" } end
				return { remove = M, Remove = M, modify = N, Modify = N }

			------------------------------------------------------------
			-- AddGlobalGetHook(propertyName, valueOrCallback)
			------------------------------------------------------------
			elseif G == "AddGlobalGetHook" then
				if #F < 1 then error("mt-api: Invalid argument count") end

				local v = F[1]
				local L = F[2]
				if type(v) ~= "string" then error("mt-api: Invalid hook type") end

				n = n + 1
				if not i[n] then i[n] = {} end
				i[n][v] = { Value = L, IsCallback = type(L) == "function" }

				local function M() i[n][v] = nil end
				local function N(_, P) i[n][v] = { Value = P, IsCallback = type(P) == "function" } end
				return { remove = M, Remove = M, modify = N, Modify = N }

			------------------------------------------------------------
			-- AddSetHook(propertyName, valueOrCallbackOrNil)
			-- If hook value is nil => block writes to that property
			------------------------------------------------------------
			elseif G == "AddSetHook" then
				local v = F[1]
				local L = F[2]
				if type(v) ~= "string" then error("mt-api: Invalid hook type") end

				if L ~= nil then
					if not f[self] then f[self] = {} end
					f[self][v] = { Value = L, IsCallback = type(L) == "function" }

					local function M() f[self][v] = nil end
					local function N(_, P) f[self][v] = { Value = P, IsCallback = type(P) == "function" } end
					return { remove = M, Remove = M, modify = N, Modify = N }
				else
					if not e[self] then e[self] = {} end
					e[self][v] = true

					local function M() e[self][v] = nil end
					local function N() return end
					return { remove = M, Remove = M, modify = N, Modify = N }
				end

			------------------------------------------------------------
			-- AddGlobalSetHook(propertyName, valueOrCallbackOrNil)
			-- If hook value is nil => block writes globally for that property
			------------------------------------------------------------
			elseif G == "AddGlobalSetHook" then
				local v = F[1]
				local L = F[2]
				if type(v) ~= "string" then error("mt-api: Invalid hook type") end

				o = o + 1
				if L ~= nil then
					if not j[o] then j[o] = {} end
					j[o][v] = { Value = L, IsCallback = type(L) == "function" }

					local function M() j[o][v] = nil end
					local function N(_, P) j[o][v] = { Value = P, IsCallback = type(P) == "function" } end
					return { remove = M, Remove = M, modify = N, Modify = N }
				else
					if not l[o] then l[o] = {} end
					l[o][v] = true

					local function M() l[o][v] = nil end
					local function N(_, P)
						if type(P) == "boolean" then
							l[o][v] = P
						end
					end
					return { remove = M, Remove = M, modify = N, Modify = N }
				end

			------------------------------------------------------------
			-- AddCallHook(methodName, callback)
			------------------------------------------------------------
			elseif G == "AddCallHook" then
				local functionName = F[1]
				local Q = F[2]
				if type(Q) ~= "function" or type(functionName) ~= "string" then
					error("mt-api: Invalid hook type")
				end

				if not g[self] then g[self] = {} end
				g[self][functionName] = { Callback = Q }

				local function M() g[self][functionName] = nil end
				local function N(_, P) g[self][functionName] = { Callback = P } end
				return { remove = M, Remove = M, modify = N, Modify = N }

			------------------------------------------------------------
			-- AddGlobalCallHook(methodName, callback)
			------------------------------------------------------------
			elseif G == "AddGlobalCallHook" then
				local functionName = F[1]
				local Q = F[2]
				if type(Q) ~= "function" or type(functionName) ~= "string" then
					error("mt-api: Invalid hook type")
				end

				m = m + 1
				if not k[m] then k[m] = {} end
				k[m][functionName] = { Callback = Q }

				local function M() k[m][functionName] = nil end
				local function N(_, P) k[m][functionName] = { Callback = P } end
				return { remove = M, Remove = M, modify = N, Modify = N }

			------------------------------------------------------------
			-- AddPropertyEmulator(propertyName)
			------------------------------------------------------------
			elseif G == "AddPropertyEmulator" then
				local v = F[1]
				if type(v) ~= "string" then error("mt-api: Invalid hook type") end

				if not h[self] then h[self] = {} end
				h[self][v] = { Emulator = { [1] = getrawmetatable(game).__index(self, v) } }

				local function M()
					-- Original code referenced functionName here; keeping behavior minimal:
					h[self][v] = nil
				end
				return { remove = M, Remove = M }
			end
		end

		-- For non-exploit callers (or if debugging), handle call hooks
		if not checkcaller() or getgenv().MTAPIDebug then
			-- Per-object call hook
			if g[self] and g[self][G] then
				local R = g[self][G]
				if R.Callback then
					local function S(...)
						return u(self, ...)
					end
					return R.Callback(S, ...)
				end
				error("mt-api: Callback is nil")
			end

			-- Global call hooks
			for _, z in next, k do
				if z[G] then
					local T = z[G]
					if T.Callback then
						return T.Callback(self, u, ...) or { Failure = true }
					end
					error("mt-api: Callback is nil")
				end
			end
		end

		return u(self, ...)
	end)

	-- Restore readonly protection
	if c == 0 then
		make_readonly(r)
	elseif c == 2 then
		error("mt-api: Exploit not supported")
	else
		if setreadonly then
			setreadonly(r, true)
		else
			error("mt-api: Exploit not supported")
		end
	end
end

-- Optional GUI signal helpers (exploit-specific)
local function U()
	if getgenv().MTAPIConnections then
		error("mt-api: Signals are not available until Synapse fixes their shit")
	end

	if getgenv().MTAPIGui then
		game:AddGlobalCallHook("MouseButton1Down", function(self, V, ...)
			local W = { ... }
			local X, Y = W[1], W[2]
			firesignal(getrawmetatable(game).__index(self, "MouseButton1Down"), X, Y)
		end)

		game:AddGlobalCallHook("MouseButton1Up", function(self, V, ...)
			local W = { ... }
			local X, Y = W[1] or nil, W[2] or nil
			firesignal(getrawmetatable(game).__index(self, "MouseButton1Up"), X, Y)
		end)

		game:AddGlobalCallHook("MouseButton1Click", function(self, V, ...)
			firesignal(getrawmetatable(game).__index(self, "MouseButton1Click"))
		end)

		game:AddGlobalCallHook("MouseButton2Down", function(self, V, ...)
			local W = { ... }
			local X, Y = W[1], W[2]
			firesignal(getrawmetatable(game).__index(self, "MouseButton2Down"), X, Y)
		end)

		game:AddGlobalCallHook("MouseButton2Up", function(self, V, ...)
			local W = { ... }
			local X, Y = W[1] or nil, W[2] or nil
			firesignal(getrawmetatable(game).__index(self, "MouseButton2Up"), X, Y)
		end)

		game:AddGlobalCallHook("MouseButton2Click", function(self, V, ...)
			firesignal(getrawmetatable(game).__index(self, "MouseButton2Click"))
		end)

		game:AddGlobalCallHook("MouseEnter", function(self, V, ...)
			local W = { ... }
			local X, Y = W[1] or nil, W[2] or nil
			firesignal(getrawmetatable(game).__index(self, "MouseEnter"), X, Y)
		end)

		game:AddGlobalCallHook("MouseLeave", function(self, V, ...)
			local W = { ... }
			local X, Y = W[1] or nil, W[2] or nil
			firesignal(getrawmetatable(game).__index(self, "MouseLeave"), X, Y)
		end)

		game:AddGlobalCallHook("MouseMoved", function(self, V, ...)
			local W = { ... }
			local X, Y = W[1] or nil, W[2] or nil
			firesignal(getrawmetatable(game).__index(self, "MouseMoved"), X, Y)
		end)
	end
end

-- Run installer + optional GUI hooks
p()
U()

-- Set mutex so it doesn't re-install
getgenv().MTAPIMutex = true
