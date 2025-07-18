local success, err = pcall(function()
    loadstring(game:HttpGet("https://pandadevelopment.net/virtual/file/22c5bff8b561b21a"))()
end)

if not success then
    warn("Primary source failed, loading fallback...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/refs/heads/main/AshMain-Modified.lua"))()
end
