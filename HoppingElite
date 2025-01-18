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
ASH["1"] = Instance.new("ScreenGui", game:GetService("CoreGui"));
ASH["1"]["IgnoreGuiInset"] = true;
ASH["1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
ASH["1"]["Name"] = randomString()
ASH["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
ASH["1"]["ResetOnSpawn"] = false;


-- StarterGui.Teleporter.Main
ASH["2"] = Instance.new("Frame", ASH["1"]);
ASH["2"]["ZIndex"] = -999;
ASH["2"]["BorderSizePixel"] = 0;
ASH["2"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
ASH["2"]["Size"] = UDim2.new(9999, 9999, 9999, 9999);
ASH["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
ASH["2"]["Name"] = randomString()
ASH["2"]["BackgroundTransparency"] = 0.4;


-- StarterGui.Teleporter.ImageButton
ASH["3"] = Instance.new("ImageButton", ASH["1"]);
ASH["3"]["BorderSizePixel"] = 0;
ASH["3"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
ASH["3"]["Image"] = [[rbxassetid://81612087104606]];
ASH["3"]["Size"] = UDim2.new(0, 192, 0, 196);
ASH["3"]["BackgroundTransparency"] = 1;
ASH["3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
ASH["3"]["Position"] = UDim2.new(0.44061, 0, 0.37841, 0);


-- StarterGui.Teleporter.Teleporting
ASH["4"] = Instance.new("TextLabel", ASH["1"]);
ASH["4"]["BorderSizePixel"] = 0;
ASH["4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
ASH["4"]["TextSize"] = 25;
ASH["4"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
ASH["4"]["TextColor3"] = Color3.fromRGB(86, 0, 255);
ASH["4"]["BackgroundTransparency"] = 1;
ASH["4"]["RichText"] = true;
ASH["4"]["Size"] = UDim2.new(0, 176, 0, 50);
ASH["4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
ASH["4"]["Text"] = [[Teleporting in 10.]];
ASH["4"]["Name"] = randomString()
ASH["4"]["Position"] = UDim2.new(0.4455, 0, 0.67943, 0);


-- StarterGui.Teleporter.Cancel
ASH["5"] = Instance.new("TextButton", ASH["1"]);
ASH["5"]["Active"] = false;
ASH["5"]["BorderSizePixel"] = 0;
ASH["5"]["TextSize"] = 25;
ASH["5"]["TextColor3"] = Color3.fromRGB(86, 0, 0);
ASH["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
ASH["5"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
ASH["5"]["RichText"] = true;
ASH["5"]["Selectable"] = false;
ASH["5"]["Size"] = UDim2.new(0, 200, 0, 50);
ASH["5"]["BackgroundTransparency"] = 1;
ASH["5"]["Name"] = randomString()
ASH["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
ASH["5"]["Text"] = [[Tap to Cancel]];
ASH["5"]["Position"] = UDim2.new(0.43754, 0, 0.73963, 0);


-- StarterGui.Teleporter.Discord
ASH["6"] = Instance.new("TextLabel", ASH["1"]);
ASH["6"]["BorderSizePixel"] = 0;
ASH["6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
ASH["6"]["TextSize"] = 10;
ASH["6"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
ASH["6"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
ASH["6"]["BackgroundTransparency"] = 1;
ASH["6"]["RichText"] = true;
ASH["6"]["Size"] = UDim2.new(0, 200, 0, 50);
ASH["6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
ASH["6"]["Text"] = [[dsc.gg/ashbornnhub]];
ASH["6"]["Name"] = randomString()
ASH["6"]["Position"] = UDim2.new(0.43816, 0, 0.31698, 0);


-- StarterGui.Teleporter.Title
ASH["7"] = Instance.new("TextLabel", ASH["1"]);
ASH["7"]["BorderSizePixel"] = 0;
ASH["7"]["BackgroundColor3"] = Color3.fromRGB(86, 0, 128);
ASH["7"]["TextSize"] = 50;
ASH["7"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
ASH["7"]["TextColor3"] = Color3.fromRGB(50, 0, 75);
ASH["7"]["BackgroundTransparency"] = 1;
ASH["7"]["RichText"] = true;
ASH["7"]["Size"] = UDim2.new(0, 200, 0, 50);
ASH["7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
ASH["7"]["Text"] = [[AshbornnHub]];
ASH["7"]["Name"] = randomString()
ASH["7"]["Position"] = UDim2.new(0.43816, 0, 0.27397, 0);

function HoppingElite(teleportingText)
	local HttpService = game:GetService("HttpService")
	local TeleportService = game:GetService("TeleportService")
	local Players = game:GetService("Players")

	local PlaceId = game.PlaceId
	local JobId = game.JobId

	if request then
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
		if #servers > 0 then
			local targetServer = servers[math.random(1, #servers)]
			TeleportService:TeleportToPlaceInstance(PlaceId, targetServer, Players.LocalPlayer)
		else
			teleportingText.Text = "Serverhop: Couldn't find a suitable server."
		end
	else
		teleportingText.Text = "Incompatible Exploit: Your exploit does not support HTTP requests."
	end

end

local function startCountdown(teleportingLabel, cancelButton)
    local countdownTime = 10
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
        task.wait(0.5)
        teleportingLabel.Text = "Server Hopping.."
        task.wait(0.5)
        teleportingLabel.Text = "Server Hopping..."
        HoppingElite(teleportingLabel)
        task.wait(25)
        teleportingLabel.Text = "Finding a Server Please Wait..."
    end
end


startCountdown(ASH["4"], ASH["5"])


return ASH["1"], require;
