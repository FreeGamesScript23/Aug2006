return function()
    local dataOwner = loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/Games/niggIds.lua", true))()
    local ownerUserIds = dataOwner.ownerUserIds
    local priorityRanks = dataOwner.priorityRanks
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

    local function isOwner()
        return ownerUserIds[LocalPlayer.UserId]
    end

    if isOwner() then
        print("LocalPlayer is an owner, bypassing checks.")
        getgenv().AshDevMode = true
        getgenv().PandaKeki = true
        return
    end

    if not (isfunctionhooked and restorefunction and CheckSupport()) then
        LocalPlayer:Kick("Required function missing. Change your executor - dsc.gg/AshbornnHub")
        return
    end

    local security = tonumber(getgenv().SecurityLevel) or 0

    local functions = {}

    if security == 1 then
        table.insert(functions, game.HttpGet)
        table.insert(functions, game.HttpPost)
        table.insert(functions, request)
        if syn and syn.request then
            table.insert(functions, syn.request)
        end
    elseif security >= 2 then
        functions = {
            game.HttpGet,
            game.HttpPost,
            request,
            getrawmetatable(game).__namecall,
            Instance.new("RemoteEvent").FireServer,
            Instance.new("RemoteFunction").InvokeServer,
        }
        if syn and syn.request then
            table.insert(functions, syn.request)
        end
    end

    task.spawn(function()
        while true do
            for _, func in ipairs(functions) do
                if func and isfunctionhooked(func) then
                    restorefunction(func)
                end
            end
            task.wait(0.5)
        end
    end)
end
