local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local premiums = {
    [6069697086] = true,
    [4072731377] = true,
    [6150337449] = true,
    [1571371222] = true,
    [2911976621] = true,
    [2729297689] = true,
    [6150320395] = true,
    [301098121] = true,
    [773902683] = true,
    [671905963] = true,
    [3129701628] = true,
    [3063352401] = true,
    [3129413184] = true
}

local monarchs = {
    [129215104] = true,
    [6135258891] = true,
    [290931] = true
}

local Config = {
    Names = true,
    NamesOutline = true,
    NamesColor = Color3.fromRGB(255, 255, 255),
    NamesOutlineColor = Color3.fromRGB(0, 0, 0),
    NamesFont = 3,
    NamesSize = 16,
    Distance = true -- Option to display distance
}

local roles = {}
local lastUpdate = 0

local function updateRoles()
    if os.time() - lastUpdate > 2 then
        local success, result = pcall(function()
            return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
        end)
        if success then
            roles = result
            lastUpdate = os.time()
        end
    end
end

RunService.RenderStepped:Connect(updateRoles)

local function IsAlive(Player)
    local playerData = roles[Player.Name]
    if playerData then
        return not (playerData.Killed or playerData.Dead)
    end
    return false
end

local function getRoleColor(player)
    local playerData = roles[player.Name]

    if monarchs[player.UserId] then
        return Color3.fromRGB(128, 0, 128)
    elseif premiums[player.UserId] then
        return Color3.fromRGB(13, 0, 255)
    end

    if playerData then
        if playerData.Role == "Murderer" then
            return Color3.fromRGB(225, 0, 0) -- Red color
        elseif playerData.Role == "Sheriff" then
            return Color3.fromRGB(0, 255, 225) -- Blue color
        elseif playerData.Role == "Hero" then
            return Color3.fromRGB(255, 255, 0) -- Yellow color
        end
    end

    return Color3.fromRGB(0, 225, 0) -- Green color for alive players
end

local function getTitleColor(player)
    if premiums[player.UserId] then
        return Color3.fromRGB(0, 255, 255) -- Dark blue color for premiums
    elseif monarchs[player.UserId] then
        return Color3.fromRGB(128, 0, 128) -- Purple color for monarchs
    end
    return Config.NamesColor -- Default color
end

local function CreateEsp(Player)
    local Title = Drawing.new("Text")
    local Name = Drawing.new("Text")

    local function UpdateEsp()
        local localPlayer = Players.LocalPlayer
        if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Head") and Player.Character.Humanoid.Health > 0 and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local HeadPos, IsVisible = workspace.CurrentCamera:WorldToViewportPoint(Player.Character.Head.Position + Vector3.new(0, 2, 0))
            local height = 60

            if Config.Names then
                local playerDistance = Config.Distance and (localPlayer.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude or 0

                Title.Visible = IsVisible
                Title.Center = true
                Title.Outline = Config.NamesOutline
                Title.OutlineColor = Config.NamesOutlineColor
                Title.Font = Config.NamesFont
                Title.Size = Config.NamesSize
                Title.Color = getTitleColor(Player)

                if premiums[Player.UserId] then
                    Title.Text = "(Premium)"
                elseif monarchs[Player.UserId] then
                    Title.Text = "(Monarch)"
                else
                    Title.Text = ""
                end

                Title.Position = Vector2.new(HeadPos.X, HeadPos.Y - height * 0.5 - 20)

                Name.Visible = IsVisible
                if IsAlive(Player) then
                    Name.Color = getRoleColor(Player)
                elseif premiums[Player.UserId] then
                    Name.Color = Color3.fromRGB(13, 0, 255) -- Dark blue for premiums when not alive
                elseif monarchs[Player.UserId] then
                    Name.Color = Color3.fromRGB(128, 0, 128) -- Purple for monarchs when not alive
                else
                    Name.Color = Color3.fromRGB(128, 128, 128) -- Gray color if not alive
                end
                Name.Text = Config.Distance and Player.Name .. " " .. string.format("%.1f", playerDistance) .. "m" or Player.Name
                Name.Center = true
                Name.Outline = Config.NamesOutline
                Name.OutlineColor = Config.NamesOutlineColor
                Name.Position = Vector2.new(HeadPos.X, HeadPos.Y - height * 0.5)
                Name.Font = Config.NamesFont
                Name.Size = Config.NamesSize
            else
                Title.Visible = false
                Name.Visible = false
            end
        else
            Title.Visible = false
            Name.Visible = false
        end
    end

    local Updater
    Updater = RunService.RenderStepped:Connect(function()
        UpdateEsp()
        if not Player.Parent then
            Updater:Disconnect()
            Title:Remove()
            Name:Remove()
        end
    end)
end

local function OnPlayerAdded(v)
    if v ~= Players.LocalPlayer then
        CreateEsp(v)
        v.CharacterAdded:Connect(function() CreateEsp(v) end)
    end
end

for _, v in pairs(Players:GetPlayers()) do
    OnPlayerAdded(v)
end

Players.PlayerAdded:Connect(OnPlayerAdded)

return Config
