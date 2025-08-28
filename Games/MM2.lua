local success, err = pcall(function()
    loadstring(game:HttpGet("https://pandadevelopment.net/virtual/file/e1ec822b9365f7dd"))()
end)

if not success then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/refs/heads/main/Games/MM2-Backup"))()
end
