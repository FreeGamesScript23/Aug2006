local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local KEY = 55
local function dec(t)
    local s = {}
    for i=1,#t do s[i] = tostring(t[i] - KEY) end
    return tonumber(table.concat(s))
end

local premiums = {
    [dec{61,55,61,64,61,64,62,55,63,61}] = true,
    [dec{59,55,62,57,62,58,56,58,62,62}] = true,
    [dec{61,56,60,55,58,58,62,59,59,64}] = true,
    [dec{56,60,62,56,58,62,56,57,57,57}] = true,
    [dec{57,64,56,56,64,62,61,61,57,56}] = true,
    [dec{57,62,57,64,57,64,62,61,63,64}] = true,
    [dec{61,56,60,55,58,57,55,58,64,60}] = true,
    [dec{58,55,56,55,64,63,56,57,56}] = true,
    [dec{62,62,58,64,55,57,61,63,58}] = true,
    [dec{61,62,56,64,55,60,64,61,58}] = true,
    [dec{58,56,57,64,62,55,56,61,57,63}] = true,
    [dec{58,55,61,58,58,60,57,59,55,56}] = true,
    [dec{62,55,55,62,63,58,59,55,58,63}] = true,
    [dec{59,62,61,62,64,58,62,61,55,62}] = true,
    [dec{58,56,57,64,59,56,58,56,63,59}] = true,
}

local monarchs = {
    [dec{56,57,64,57,56,60,56,55,59}] = true,
    [dec{61,56,58,60,57,60,63,63,64,56}] = true,
    [dec{57,64,55,64,58,56}] = true,
}

local Config = {
    Names = false,
    NamesOutline = false,
    NamesColor = Color3.fromRGB(255, 255, 255),
    NamesOutlineColor = Color3.fromRGB(0, 0, 0),
    NamesFont = 3,
    NamesSize = 16,
    Distance = false,
    ESPEnabled = false -- add this
}

local roles = {}
local SSeeRoles = true

local function fetchRoles()
    local remote = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
    if not remote then return end
    local success, result = pcall(function()
        return remote:InvokeServer()
    end)
    if success and type(result) == "table" then
        roles = result
    end
end

local RoundStart = ReplicatedStorage.Remotes.Gameplay.RoundStart
local RoleSelect = ReplicatedStorage.Remotes.Gameplay.RoleSelect
local PlayerDataChanged = ReplicatedStorage.Remotes.Gameplay.PlayerDataChanged

if SSeeRoles then
    fetchRoles()
end

RoundStart.OnClientEvent:Connect(function()
    if SSeeRoles then fetchRoles() end
end)
RoleSelect.OnClientEvent:Connect(function(playerName)
    if SSeeRoles then fetchRoles() end
end)
PlayerDataChanged.OnClientEvent:Connect(function(playerName)
    if SSeeRoles then fetchRoles() end
end)

local function IsAlive(Player)
    local data = roles[Player.Name]
    return data and not (data.Killed or data.Dead)
end

local function getRoleColor(player)
    local data = roles[player.Name]
    if data then
        if data.Role == "Murderer" or data.Role == "Vampire" or data.Role == "Zombie" or data.Role == "Freezer" then
            return Color3.fromRGB(139,0,0)
        elseif data.Role == "Sheriff" or data.Role == "Hunter" or data.Role == "Survivor" or data.Role == "Runner" then
            return Color3.fromRGB(0,0,255)
        elseif data.Role == "Hero" then
            return Color3.fromRGB(255,255,0)
        elseif data.Role == "Innocent" then
            return Color3.fromRGB(0,225,0)
        end
    end
    return Color3.fromRGB(128,128,128)
end

local function getTitleColor(player)
    if premiums[player.UserId] then return Color3.fromRGB(0,255,255) end
    if monarchs[player.UserId] then return Color3.fromRGB(128,0,128) end
    return Config.NamesColor
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
            Name.Text = Config.Distance and player.Name.." "..string.format("%.1f",(Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude).."m" or player.Name
            Name.Center = true
            Name.Outline = Config.NamesOutline
            Name.OutlineColor = Config.NamesOutlineColor
            Name.Position = Vector2.new(HeadPos.X, HeadPos.Y - height*0.5)
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
