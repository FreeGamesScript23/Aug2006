--// Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local cache = {}

local bones = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "LowerTorso"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"}
}

--// Settings
local ESP_SETTINGS = {
    BoxOutlineColor = Color3.new(0, 0, 0),
    BoxColor = Color3.new(1, 1, 1),
    NameColor = Color3.new(1, 1, 1),
    HealthOutlineColor = Color3.new(0, 0, 0),
    HealthHighColor = Color3.new(0, 1, 0),
    HealthLowColor = Color3.new(1, 0, 0),
    CharSize = Vector2.new(4, 6),
    Teamcheck = false,
    WallCheck = false,
    Enabled = false,
    ShowBox = false,
    BoxType = "2D",
    ShowName = false,
    ShowHealth = false,
    ShowDistance = false,
    ShowSkeletons = false,
    ShowTracer = false,
    TracerColor = Color3.new(1, 1, 1),
    TracerThickness = 2,
    SkeletonsColor = Color3.new(1, 1, 1),
    TracerPosition = "Bottom",
    RoleColors = {
        Murder = Color3.new(1, 0, 0),
        Sheriff = Color3.new(0, 0, 1),
        Hero = Color3.new(0, 1, 0),
        Default = Color3.new(1, 1, 1)
    }
}

local function create(class, properties)
    local drawing = Drawing.new(class)
    for property, value in pairs(properties) do
        drawing[property] = value
    end
    return drawing
end

local function createEsp(player)
    local esp = {
        tracer = create("Line", {
            Thickness = ESP_SETTINGS.TracerThickness,
            Color = ESP_SETTINGS.TracerColor,
            Transparency = 0.5
        }),
        boxOutline = create("Square", {
            Color = ESP_SETTINGS.BoxOutlineColor,
            Thickness = 3,
            Filled = false
        }),
        box = create("Square", {
            Color = ESP_SETTINGS.BoxColor,
            Thickness = 1,
            Filled = false
        }),
        name = create("Text", {
            Color = ESP_SETTINGS.NameColor,
            Outline = true,
            Center = true,
            Size = 13
        }),
        healthOutline = create("Line", {
            Thickness = 3,
            Color = ESP_SETTINGS.HealthOutlineColor
        }),
        health = create("Line", {
            Thickness = 1
        }),
        distance = create("Text", {
            Color = Color3.new(1, 1, 1),
            Size = 12,
            Outline = true,
            Center = true
        }),
        boxLines = {},
    }

    cache[player] = esp
    cache[player]["skeletonlines"] = {}
end

local function isPlayerBehindWall(player)
    local character = player.Character
    if not character then
        return false
    end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        return false
    end

    local ray = Ray.new(camera.CFrame.Position, (rootPart.Position - camera.CFrame.Position).Unit * (rootPart.Position - camera.CFrame.Position).Magnitude)
    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {localPlayer.Character, character})
    
    return hit and hit:IsA("Part")
end

local function removeEsp(player)
    local esp = cache[player]
    if not esp then return end

    for _, drawing in pairs(esp) do
        drawing:Remove()
    end

    cache[player] = nil
end

local roles = {}

local function roleupdaterfix()
    while true do
        roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
        wait(1)  -- Update every second
    end
end

local function IsAlive(Player)
    for i, v in pairs(roles) do
        if Player.Name == i then
            if not v.Killed and not v.Dead then
                return true
            else
                return false
            end
        end
    end
end

local function getPlayerRoleColor(player)
    -- Specific user IDs
    if player.UserId == 290931 or player.UserId == 129215104 then
        return Color3.fromRGB(128, 0, 128) -- Purple color for specific UserIds
    end

    -- Check the roles table for specific roles
    for i, v in pairs(roles) do
        if v.Role == "Murderer" and i == player.Name then
            return Color3.fromRGB(225, 0, 0) -- Red color for Murderer
        elseif v.Role == "Sheriff" and i == player.Name then
            return Color3.fromRGB(0, 0, 225) -- Blue color for Sheriff
        elseif v.Role == "Hero" and i == player.Name then
            return Color3.fromRGB(255, 255, 0) -- Yellow color for Hero
        end
    end

    return Color3.fromRGB(0, 225, 0) -- Green color for alive players
end

local function updateEsp()
    for player, esp in pairs(cache) do
        local character, team = player.Character, player.Team
        if character and (not ESP_SETTINGS.Teamcheck or (team and team ~= localPlayer.Team)) then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            local humanoid = character:FindFirstChild("Humanoid")
            local isBehindWall = ESP_SETTINGS.WallCheck and isPlayerBehindWall(player)
            local shouldShow = not isBehindWall and ESP_SETTINGS.Enabled and IsAlive(player)
            local roleColor = getPlayerRoleColor(player)

            if rootPart and head and humanoid and shouldShow then
                local position, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    local hrp2D = camera:WorldToViewportPoint(rootPart.Position)
                    local charSize = (camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0)).Y - camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 2.6, 0)).Y) / 2
                    local boxSize = Vector2.new(math.floor(charSize * 1.8), math.floor(charSize * 1.9))
                    local boxPosition = Vector2.new(math.floor(hrp2D.X - charSize * 1.8 / 2), math.floor(hrp2D.Y - charSize * 1.6 / 2))

                    if ESP_SETTINGS.ShowName and ESP_SETTINGS.Enabled then
                        esp.name.Visible = true
                        esp.name.Text = string.lower(player.Name)
                        esp.name.Position = Vector2.new(boxSize.X / 2 + boxPosition.X, boxPosition.Y - 16)
                        esp.name.Color = ESP_SETTINGS.NameColor
                    else
                        esp.name.Visible = false
                    end

                    if ESP_SETTINGS.ShowBox and ESP_SETTINGS.Enabled then
                        if ESP_SETTINGS.BoxType == "2D" then
                            esp.boxOutline.Size = boxSize
                            esp.boxOutline.Position = boxPosition
                            esp.box.Size = boxSize
                            esp.box.Position = boxPosition
                            esp.box.Color = roleColor
                            esp.box.Visible = true
                            esp.boxOutline.Visible = true
                            for _, line in ipairs(esp.boxLines) do
                                line:Remove()
                            end
                        elseif ESP_SETTINGS.BoxType == "Corner Box Esp" then
                            local lineW = (boxSize.X / 5)
                            local lineH = (boxSize.Y / 6)
                            local lineT = 1
    
                            if #esp.boxLines == 0 then
                                for i = 1, 16 do
                                    local boxLine = create("Line", {
                                        Thickness = 1,
                                        Color = roleColor,
                                        Transparency = 1
                                    })
                                    esp.boxLines[#esp.boxLines + 1] = boxLine
                                end
                            end
    
                            local boxLines = esp.boxLines
    
                            -- top left
                            boxLines[1].From = Vector2.new(boxPosition.X - lineT, boxPosition.Y - lineT)
                            boxLines[1].To = Vector2.new(boxPosition.X + lineW, boxPosition.Y - lineT)
    
                            boxLines[2].From = Vector2.new(boxPosition.X - lineT, boxPosition.Y - lineT)
                            boxLines[2].To = Vector2.new(boxPosition.X - lineT, boxPosition.Y + lineH)
    
                            -- top right
                            boxLines[3].From = Vector2.new(boxPosition.X + boxSize.X - lineW, boxPosition.Y - lineT)
                            boxLines[3].To = Vector2.new(boxPosition.X + boxSize.X + lineT, boxPosition.Y - lineT)
    
                            boxLines[4].From = Vector2.new(boxPosition.X + boxSize.X + lineT, boxPosition.Y - lineT)
                            boxLines[4].To = Vector2.new(boxPosition.X + boxSize.X + lineT, boxPosition.Y + lineH)
    
                            -- bottom left
                            boxLines[5].From = Vector2.new(boxPosition.X - lineT, boxPosition.Y + boxSize.Y - lineH)
                            boxLines[5].To = Vector2.new(boxPosition.X - lineT, boxPosition.Y + boxSize.Y + lineT)
    
                            boxLines[6].From = Vector2.new(boxPosition.X - lineT, boxPosition.Y + boxSize.Y + lineT)
                            boxLines[6].To = Vector2.new(boxPosition.X + lineW, boxPosition.Y + boxSize.Y + lineT)
    
                            -- bottom right
                            boxLines[7].From = Vector2.new(boxPosition.X + boxSize.X + lineT, boxPosition.Y + boxSize.Y - lineH)
                            boxLines[7].To = Vector2.new(boxPosition.X + boxSize.X + lineT, boxPosition.Y + boxSize.Y + lineT)
    
                            boxLines[8].From = Vector2.new(boxPosition.X + boxSize.X - lineW, boxPosition.Y + boxSize.Y + lineT)
                            boxLines[8].To = Vector2.new(boxPosition.X + boxSize.X + lineT, boxPosition.Y + boxSize.Y + lineT)
    
                            for _, line in ipairs(boxLines) do
                                line.Color = roleColor
                                line.Visible = ESP_SETTINGS.Enabled
                            end
                        end
                    else
                        esp.box.Visible = false
                        esp.boxOutline.Visible = false
                        for _, line in ipairs(esp.boxLines) do
                            line:Remove()
                        end
                        esp.boxLines = {}
                    end
    
                    if ESP_SETTINGS.ShowHealth and ESP_SETTINGS.Enabled then
                        local health = humanoid.Health / humanoid.MaxHealth
                        local healthPos = boxPosition - Vector2.new(5, 0)
                        local healthSize = Vector2.new(2, boxSize.Y * health)
    
                        esp.healthOutline.From = Vector2.new(healthPos.X, boxPosition.Y)
                        esp.healthOutline.To = Vector2.new(healthPos.X, boxPosition.Y + boxSize.Y)
                        esp.healthOutline.Visible = true
    
                        esp.health.From = Vector2.new(healthPos.X, boxPosition.Y + boxSize.Y - healthSize.Y)
                        esp.health.To = Vector2.new(healthPos.X, boxPosition.Y + boxSize.Y)
                        esp.health.Color = ESP_SETTINGS.HealthLowColor:lerp(ESP_SETTINGS.HealthHighColor, health)
                        esp.health.Visible = true
                    else
                        esp.health.Visible = false
                        esp.healthOutline.Visible = false
                    end
    
                    if ESP_SETTINGS.ShowDistance and ESP_SETTINGS.Enabled then
                        esp.distance.Text = string.format("%.0fm", (camera.CFrame.Position - rootPart.Position).Magnitude)
                        esp.distance.Position = Vector2.new(boxSize.X / 2 + boxPosition.X, boxPosition.Y + boxSize.Y)
                        esp.distance.Visible = true
                    else
                        esp.distance.Visible = false
                    end
    
                    if ESP_SETTINGS.ShowTracer and ESP_SETTINGS.Enabled then
                        esp.tracer.From = ESP_SETTINGS.TracerPosition == "Top" and Vector2.new(camera.ViewportSize.X / 2, 0)
                            or ESP_SETTINGS.TracerPosition == "Center" and Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                            or Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                        esp.tracer.To = Vector2.new(position.X, position.Y)
                        esp.tracer.Visible = true
                    else
                        esp.tracer.Visible = false
                    end
                else
                    for _, drawing in pairs(esp) do
                        drawing.Visible = false
                    end
                end
            else
                for _, drawing in pairs(esp) do
                    drawing.Visible = false
                end
            end
        else
            for _, drawing in pairs(esp) do
                drawing.Visible = false
            end
        end
    end
end

Players.PlayerRemoving:Connect(function(player)
    removeEsp(player)
end)

RunService.RenderStepped:Connect(function()
    if ESP_SETTINGS.Enabled then
        updateEsp()
    end
end)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        createEsp(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    createEsp(player)
end)

coroutine.wrap(roleupdaterfix)()
