local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Config = {
    Names = false,
    NamesOutline = false,
    NamesColor = Color3.fromRGB(255, 255, 255),
    NamesOutlineColor = Color3.fromRGB(0, 0, 0),
    NamesFont = 3,
    NamesSize = 16,
    Distance = false,
    ESPEnabled = false
}

local function IsAlive(player)
    local data = getgenv().roles and getgenv().roles[player.Name:lower()]
    return data and not (data.Killed or data.Dead)
end

local function getRoleColor(player)
    local data = getgenv().roles and getgenv().roles[player.Name:lower()]
    if not IsAlive(player) then
        return Color3.fromRGB(80, 80, 80)
    end

    if data and data.Role then
        local role = data.Role
        if role == "Murderer" or role == "Vampire" or role == "Zombie" or role == "Freezer" then
            return Color3.fromRGB(200, 0, 0)
        elseif role == "Sheriff" or role == "Hunter" or role == "Survivor" or role == "Runner" then
            return Color3.fromRGB(0, 120, 255)
        elseif role == "Hero" then
            return Color3.fromRGB(255, 215, 0)
        elseif role == "Innocent" then
            return Color3.fromRGB(0, 255, 100)
        else
            return Color3.fromRGB(160, 160, 160)
        end
    end

    return Color3.fromRGB(160, 160, 160)
end

local ESPUpdaters = {}

function CreateEsp(player)
    local Name = Drawing.new("Text")
    local updater = {Name = Name}
    ESPUpdaters[player] = updater

    updater.Connection = RunService.RenderStepped:Connect(function()
        if not player.Parent then
            updater.Connection:Disconnect()
            Name:Remove()
            ESPUpdaters[player] = nil
            return
        end

        if not Config.ESPEnabled then
            Name.Visible = false
            return
        end

        if player.Character and player.Character:FindFirstChild("Humanoid") 
        and player.Character:FindFirstChild("HumanoidRootPart") 
        and player.Character:FindFirstChild("Head") 
        and player.Character.Humanoid.Health > 0 then

            local cam = workspace.CurrentCamera
            local HeadPos, OnScreen = cam:WorldToViewportPoint(player.Character.Head.Position + Vector3.new(0,2,0))
            local height = 60

            Name.Visible = OnScreen
            Name.Text = Config.Distance
                and player.Name .. " " .. string.format("%.1f", (Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude) .. "m"
                or player.Name

            Name.Center = true
            Name.Outline = Config.NamesOutline
            Name.OutlineColor = Config.NamesOutlineColor
            Name.Position = Vector2.new(HeadPos.X, HeadPos.Y - height * 0.5)
            Name.Font = Config.NamesFont
            Name.Size = Config.NamesSize
            Name.Color = IsAlive(player) and getRoleColor(player) or Color3.fromRGB(128,128,128)
        else
            Name.Visible = false
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
