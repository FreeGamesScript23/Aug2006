local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- Default SecurityLevel to 1 if not set
getgenv().SecurityLevel = getgenv().SecurityLevel or 1
getgenv().AshDevMode = false

local function CheckSupport()
	local required = {
		"hookfunction",
		"hookmetamethod",
		"request",
		"fireproximityprompt",
		"getconnections",
		"getgc",
		"getgenv",
		"setreadonly",
		"islclosure",
		"newcclosure"
	}
	for _, v in ipairs(required) do
		if typeof(getfenv()[v]) ~= "function" then
			return false
		end
	end
	return true
end

local function isOwner(uid)
	local data = loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/Games/niggIds.lua", true))()
	return data.ownerUserIds and data.ownerUserIds[uid]
end

local function TryRestore()
	local functions = {}

	if SecurityLevel >= 1 then
		table.insert(functions, game.HttpPost)
		table.insert(functions, game.HttpGet)
		if typeof(request) == "function" then
			table.insert(functions, request)
		end
		if typeof(syn) == "table" and typeof(syn.request) == "function" then
			table.insert(functions, syn.request)
		end
	end

	if SecurityLevel >= 2 then
		local mt = getrawmetatable(game)
		if mt then
			table.insert(functions, mt.__namecall)
		end
		table.insert(functions, Instance.new("RemoteEvent").FireServer)
		table.insert(functions, Instance.new("RemoteFunction").InvokeServer)
	end

	task.spawn(function()
		while true do
			for _, func in ipairs(functions) do
				if func and isfunctionhooked(func) and not (getgenv().SkipRestore and getgenv().SkipRestore[func]) then
					restorefunction(func)
				end
			end
			task.wait(0.5)
		end
	end)
end

-- OWNER BYPASS
if isOwner(LocalPlayer.UserId) then
	getgenv().AshDevMode = true
	getgenv().PandaKeki = true
	warn("[CheckSupport] Owner bypass active")
else
	if isfunctionhooked and restorefunction and CheckSupport() then
		TryRestore()
	else
		LocalPlayer:Kick("❌ Missing required exploit functions.\nUse a better executor.\ndsc.gg/AshbornnHub")
	end
end
