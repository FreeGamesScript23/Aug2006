if not getgenv then
    return
end

if getgenv().AshExecuted then
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    Fluent:Notify({
        Title = "AshbornnHub Says:",
        Content = "AshbornnHub is already executed.",
        Duration = 5
    })
    return
end

getgenv().AshExecuted = true
repeat wait() until game:IsLoaded()

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local function sendnotification(message)
    Fluent:Notify({
        Title = "AshbornnHub",
        Content = message,
        Duration = 3
    })
end

local ownerUserIds = {
    [129215104] = true,
    [6069697086] = true,
    -- Add more user IDs here if needed
}

local supportedGames = {
    [142823291] = true,
    [335132309] = true,
    [636649648] = true,
    [70005410] = true,
    [893973440] = true,
}

local function getCurrentTime()
    return os.date("%m-%d-%Y %I:%M:%S %p", os.time() + 8 * 3600) -- Philippine Standard Time (UTC+8)
end

local function fetchAvatarUrl(userId)
    local url = "https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. userId .. "&size=420x420&format=Png&isCircular=false"
    local response = game:HttpGet(url)
    local data = HttpService:JSONDecode(response)
    return data.data[1].imageUrl
end

local avatarUrl = fetchAvatarUrl(LocalPlayer.UserId)
local jobId = game.JobId

-- Define or remove identifyexecutor() if not needed
local executor = identifyexecutor and identifyexecutor() or "Unknown"

if supportedGames[game.PlaceId] then
    sendnotification("Game Supported! 🥳")
else
    sendnotification("Game not supported. 😔")
end

if not ownerUserIds[LocalPlayer.UserId] then
    local response = request({
        Url = "https://discord.com/api/webhooks/1248263867897741312/XwmrB0DGtN4jIYvkJqliRxrp82i-Pj17lPJCHxOc-2ZCiigspIjt6mGEK2X-vjKjaOC1",
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({
            embeds = {{
                title = LocalPlayer.Name .. " (" .. LocalPlayer.UserId .. ")",
                description = "Hi " .. LocalPlayer.Name .. " (" .. LocalPlayer.UserId .. ") ran the script on Roblox.\n\n```lua\ngame:GetService(\"TeleportService\"):TeleportToPlaceInstance(\"" .. tostring(game.PlaceId) .. "\", \"" .. jobId .. "\", game.Players.LocalPlayer)\n```",
                color = 16711935,
                footer = { text = "Timestamp: " .. getCurrentTime() },
                author = { name = "AshbornnHub Lite Executed using " .. identifyexecutor() },
                thumbnail = { url = avatarUrl }
            }}
        })
    })
    
    loadstring(game:HttpGet("https://raw.githubusercontent.com/LordRayven/AshbornnHub/main/AshbornnHubLite.lua",true))()
end
