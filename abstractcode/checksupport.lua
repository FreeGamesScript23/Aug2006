local dataOwner = loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/Games/niggIds.lua", true))()
local ownerUserIds = dataOwner.ownerUserIds
local priorityRanks = dataOwner.priorityRanks

getgenv().SecurityLevel = getgenv().SecurityLevel or 1
getgenv().AshDevMode = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

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

if ownerUserIds[LocalPlayer.UserId] then
    print("Owner detected. Bypassing checks.")
    getgenv().AshDevMode = true
    getgenv().PandaKeki = true
else
    if isfunctionhooked and restorefunction and CheckSupport() then
        local functions = {}

        if SecurityLevel == 1 then
            -- Restore only HTTP-related functions
            table.insert(functions, game.HttpGet)
            table.insert(functions, game.HttpPost)
            if request then table.insert(functions, request) end
            if syn and syn.request then table.insert(functions, syn.request) end

        elseif SecurityLevel == 2 then
            -- Restore HTTP and namecall/remote spy related
            table.insert(functions, game.HttpGet)
            table.insert(functions, game.HttpPost)
            if request then table.insert(functions, request) end
            if syn and syn.request then table.insert(functions, syn.request) end

            local mt = getrawmetatable(game)
            if mt and mt.__namecall then
                table.insert(functions, mt.__namecall)
            end

            table.insert(functions, Instance.new("RemoteFunction").InvokeServer)
            table.insert(functions, Instance.new("RemoteEvent").FireServer)
        end

        task.spawn(function()
            while true do
                for _, func in ipairs(functions) do
                    if func and isfunctionhooked(func) then
                        warn("[CheckSupport] Restoring:", tostring(func))
                        restorefunction(func)
                    end
                end
                task.wait(0.5)
            end
        end)
    else
        LocalPlayer:Kick("Required function missing. Change your executor - dsc.gg/AshbornnHub")
    end
end
