local success, err = pcall(function()
    loadstring(game:HttpGet("https://pandadevelopment.net/virtual/file/1750da7174ed6675"))()
end)

if not success then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/refs/heads/main/Games/MM2-Backup"))()
end
