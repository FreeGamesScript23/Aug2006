function randomString()
	local length = math.random(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

local ASH = {};

-- StarterGui.Teleporter
ASH["1"] = Instance.new("ScreenGui", game:GetService("CoreGui"))
ASH["1"].IgnoreGuiInset = true
ASH["1"].ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
ASH["1"].Name = randomString()
ASH["1"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ASH["1"].ResetOnSpawn = false

-- Main background (fullscreen, semi-transparent)
ASH["2"] = Instance.new("Frame", ASH["1"])
ASH["2"].ZIndex = -999
ASH["2"].BorderSizePixel = 0
ASH["2"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ASH["2"].Size = UDim2.new(1, 0, 1, 0) -- Fullscreen
ASH["2"].BackgroundTransparency = 0.4

-- Teleport button with aspect ratio constraint
ASH["3"] = Instance.new("ImageButton", ASH["1"])
ASH["3"].BorderSizePixel = 0
ASH["3"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ASH["3"].Image = [[rbxassetid://81612087104606]]
ASH["3"].Size = UDim2.new(0.2, 0, 0.2, 0) 
ASH["3"].Position = UDim2.new(0.5, 0, 0.5, 0) 
ASH["3"].AnchorPoint = Vector2.new(0.5, 0.5)
ASH["3"].BackgroundTransparency = 1

local aspectConstraint = Instance.new("UIAspectRatioConstraint", ASH["3"])
aspectConstraint.AspectRatio = 1 

-- Teleporting label with dynamic font scaling
ASH["4"] = Instance.new("TextLabel", ASH["1"])
ASH["4"].BorderSizePixel = 0
ASH["4"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ASH["4"].TextSize = 25
ASH["4"].Font = Enum.Font.Ubuntu
ASH["4"].TextColor3 = Color3.fromRGB(86, 0, 255)
ASH["4"].Size = UDim2.new(0.3, 0, 0.05, 0)
ASH["4"].Position = UDim2.new(0.5, 0, 0.7, 0) 
ASH["4"].AnchorPoint = Vector2.new(0.5, 0.5)
ASH["4"].BackgroundTransparency = 1
ASH["4"].Text = "Teleporting in 10."

local textSizeConstraint = Instance.new("UITextSizeConstraint", ASH["4"])
textSizeConstraint.MaxTextSize = 30
textSizeConstraint.MinTextSize = 12

-- Cancel button with dynamic scaling
ASH["5"] = Instance.new("TextButton", ASH["1"])
ASH["5"].TextSize = 25
ASH["5"].TextColor3 = Color3.fromRGB(86, 0, 0)
ASH["5"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ASH["5"].Font = Enum.Font.Ubuntu
ASH["5"].Size = UDim2.new(0.3, 0, 0.05, 0)
ASH["5"].Position = UDim2.new(0.5, 0, 0.8, 0)
ASH["5"].AnchorPoint = Vector2.new(0.5, 0.5)
ASH["5"].BackgroundTransparency = 1
ASH["5"].Text = "Tap to Cancel"

local cancelTextConstraint = Instance.new("UITextSizeConstraint", ASH["5"])
cancelTextConstraint.MaxTextSize = 30
cancelTextConstraint.MinTextSize = 12

-- Discord label with dynamic scaling
ASH["6"] = Instance.new("TextLabel", ASH["1"])
ASH["6"].TextSize = 10
ASH["6"].Font = Enum.Font.Ubuntu
ASH["6"].TextColor3 = Color3.fromRGB(255, 255, 255)
ASH["6"].Size = UDim2.new(0.3, 0, 0.05, 0)
ASH["6"].Position = UDim2.new(0.5, 0, 0.35, 0)
ASH["6"].AnchorPoint = Vector2.new(0.5, 0.5)
ASH["6"].BackgroundTransparency = 1
ASH["6"].Text = "dsc.gg/ashbornnhub"

local discordTextConstraint = Instance.new("UITextSizeConstraint", ASH["6"])
discordTextConstraint.MaxTextSize = 15
discordTextConstraint.MinTextSize = 8

-- Title label with aspect ratio scaling
ASH["7"] = Instance.new("TextLabel", ASH["1"])
ASH["7"].TextSize = 50
ASH["7"].Font = Enum.Font.Ubuntu
ASH["7"].TextColor3 = Color3.fromRGB(50, 0, 75)
ASH["7"].Size = UDim2.new(0.3, 0, 0.05, 0)
ASH["7"].Position = UDim2.new(0.5, 0, 0.3, 0) 
ASH["7"].AnchorPoint = Vector2.new(0.5, 0.5)
ASH["7"].BackgroundTransparency = 1
ASH["7"].Text = "AshbornnHub"

local titleTextConstraint = Instance.new("UITextSizeConstraint", ASH["7"])
titleTextConstraint.MaxTextSize = 60
titleTextConstraint.MinTextSize = 20

function HoppingElite(teleportingText)
	local HttpService = game:GetService("HttpService")
	local TeleportService = game:GetService("TeleportService")
	local Players = game:GetService("Players")

	local PlaceId = game.PlaceId
	local JobId = game.JobId

	local function getServers()
		local servers = {}
		local req = request({
			Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", PlaceId)
		})

		if req and req.Body then
			local body = HttpService:JSONDecode(req.Body)
			if body and body.data then
				for _, server in ipairs(body.data) do
					if type(server) == "table" and tonumber(server.playing) and tonumber(server.maxPlayers) and 
						server.playing < server.maxPlayers and server.id ~= JobId then
						table.insert(servers, server.id)
					end
				end
			end
		end
		return servers
	end

	if request then
		while true do
			local servers = getServers()

			if #servers > 0 then
				local targetServer = servers[math.random(1, #servers)]
				teleportingText.Text = "Serverhop: Attempting to join a new server..."

				local success, errorMessage = pcall(function()
					TeleportService:TeleportToPlaceInstance(PlaceId, targetServer, Players.LocalPlayer)
				end)

				if not success then
					if errorMessage:find("full server") then
						teleportingText.Text = "Server is full. Trying another..."
						task.wait(0.5) 
					elseif errorMessage:find("Teleport is in processing") then
						teleportingText.Text = "Teleport in progress. Retrying..."
						task.wait(0.5)
					else
						teleportingText.Text = "Teleport failed: Retrying in 0.5 seconds..."
						task.wait(0.5)
					end
				else
					teleportingText.Text = "Successfully teleported!"
				end
			else
				teleportingText.Text = "Serverhop: Couldn't find a suitable server. Retrying..."
				task.wait(1)
			end
		end
	else
		teleportingText.Text = "Incompatible Exploit: Your exploit does not support HTTP requests."
	end
end


ASH["3"].MouseButton1Click:Connect(function()
    setclipboard("dsc.gg/ashbornnhub")
end)


local function startCountdown(teleportingLabel, cancelButton)
    local countdownTime = 3
    local cancelRequested = false

    cancelButton.MouseButton1Click:Connect(function()
        cancelRequested = true
        teleportingLabel.Text = "Teleportation Canceled."
        print("Countdown Canceled")
	    ASH["1"]:Destroy()
    end)

    for i = countdownTime, 1, -1 do
        if cancelRequested then
            break
        end
        
        teleportingLabel.Text = "Server Hopping in " .. i .. "."
        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        local goal = {TextTransparency = 0}
        local tween = game:GetService("TweenService"):Create(teleportingLabel, tweenInfo, goal)
        tween:Play()

        task.wait(1)
    end

    if not cancelRequested then
        teleportingLabel.Text = "Server Hopping."
        task.wait(0.2)
        teleportingLabel.Text = "Server Hopping.."
        task.wait(0.2)
        teleportingLabel.Text = "Server Hopping..."
        HoppingElite(teleportingLabel)
        task.wait(25)
        teleportingLabel.Text = "Finding a Server Please Wait..."
    end
end

startCountdown(ASH["4"], ASH["5"])

return ASH["1"], require;
