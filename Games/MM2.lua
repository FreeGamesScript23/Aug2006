local success, err = pcall(function()
    loadstring(game:HttpGet("https://pandadevelopment.net/virtual/file/2e5f3ab0473d7265"))()
end)

if not success then
    warn("bruh loading the backup")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/refs/heads/main/Games/MM2-Backup"))()
end
