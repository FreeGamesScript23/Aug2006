function isFunctionHooked(fn)
    if type(fn) ~= "function" then return false end
    if type(isfunctionhooked) == "function" then
        local ok, res = pcall(isfunctionhooked, fn)
        if ok and res then return true end
    end
	
    local ok, info = pcall(debug.getinfo, fn, "S")
    if ok and type(info) == "table" and info.what ~= "C" then return true end
    return false
end

function resolve(name)
    if name == "request" then return getgenv().request or _G.request end
    if name == "http_request" then return getgenv().http_request or _G.http_request end
    if name == "syn.request" then return syn and syn.request end
    if name == "HttpGet" then return game.HttpGet end
    if name == "HttpPost" then return game.HttpPost end
    if name == "HttpGetAsync" then return game.HttpGetAsync end
end

task.spawn(function()
	while not getgenv().AshDestroyed do
		if isFunctionHooked(resolve("request")) or isFunctionHooked(resolve("HttpGet")) or isFunctionHooked(resolve("http_request")) or isFunctionHooked(resolve("HttpPost")) or isFunctionHooked(resolve("HttpGetAsync")) or isFunctionHooked(resolve("syn.request")) then
			game.Players.LocalPlayer:Kick("Something went wrong, Try rejoining.")
		end
		task.wait(1)
	end
end)
