local success, err = pcall(function()
    loadstring(game:HttpGet("https://pandadevelopment.net/virtual/file/c0d905745c0457b4"))()
end)

if not success then
    warn("LLD Source Failed:", err)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/refs/heads/main/AshMain-Modified.lua"))()
end
