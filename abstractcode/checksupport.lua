local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local aldasldaskdnanhalkdhnalk = {
    [129215104] = true, [6069697086] = true, [4072731377] = true, [6150337449] = true,
    [1571371222] = true, [2911976621] = true, [2729297689] = true, [6150320395] = true,
    [301098121] = true, [773902683] = true, [290931] = true, [6135258891] = true,
    [671905963] = true, [3129701628] = true, [3063352401] = true, [3129413184] = true,
    [8569193047] = true, [8458861060] = true
}
local ahdansjdaslndaslkdnsaldknaskdljpaj = aldasldaskdnanhalkdhnalk
getgenv().AshDevMode = ahdansjdaslndaslkdnsaldknaskdljpaj[LocalPlayer.UserId] or false
getgenv().PandaKeki = true

local function CheckSupport()
    local required = {
        "hookfunction", "hookmetamethod", "restorefunction",
        "isfunctionhooked", "getrawmetatable", "newcclosure"
    }
    for _, funcName in ipairs(required) do
        if typeof(getfenv()[funcName]) ~= "function" then
            return false
        end
    end
    return true
end

if not getgenv().AshDevMode then
    if not CheckSupport() then
        LocalPlayer:Kick("❌ Missing required exploit support. -dsc,gg/ashbornnhub")
        return
    end

    local function tryRestore(func)
        if func and isfunctionhooked(func) then
            pcall(restorefunction, func)
        end
    end

    local mt = getrawmetatable(game)
    local functionsToRestore = {
        game.HttpGet,
        game.HttpPost,
        game.HttpGetAsync,
        game.HttpPostAsync,
        mt.__namecall,
        request,
        http and http.request,
        syn and syn.request
    }

    task.spawn(function()
        while task.wait(0.3) do
            for _, fn in ipairs(functionsToRestore) do
                tryRestore(fn)
            end
        end
    end)
end
