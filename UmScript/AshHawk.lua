-- Define services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Get the local player
local player = Players.LocalPlayer

-- Variables
local FOV_RADIUS = 100  -- Radius of the FOV circle
local predictionFactor = 0.1  -- Prediction factor for aiming
local HEAD_SCALE_FACTOR = 5  -- Increase head size factor

local aimbotEnabled = false  -- Variable to control if aimbot is enabled
local aimbotToggleKey = Enum.KeyCode.LeftShift  -- Key to toggle aimbot (can be changed)

-- List of target weapon names
local targetWeapons = {
    "AK74",
    "UMP45",
    "AVest",
    "SVUA",
    "SniperVest"
}

-- Function to check if a part is visible
local function isPartVisible(part)
    local character = player.Character
    if not character or not character:FindFirstChild("Head") then
        return false
    end

    local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).unit * 1000)
    local partHit, _ = workspace:FindPartOnRayWithIgnoreList(ray, {character, Camera})

    return partHit and partHit:IsDescendantOf(part.Parent)
end

-- Function to check if a part is within the FOV circle
local function isInFOV(part)
    local screenPoint = Camera:WorldToViewportPoint(part.Position)
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - screenCenter).magnitude

    return distance <= FOV_RADIUS
end

-- Function to find the nearest visible head within FOV that has a target weapon
local function findNearestHead()
    local closestHead = nil
    local shortestDistance = math.huge

    for _, bot in ipairs(workspace.Bots:GetChildren()) do
        if bot:IsA("Model") and bot:FindFirstChild("Head") and bot.Head:IsA("Part") then
            local head = bot.Head

            -- Check if the bot has any of the target weapons
            local hasTargetWeapon = false
            for _, weaponName in ipairs(targetWeapons) do
                if bot:FindFirstChild(weaponName) then
                    hasTargetWeapon = true
                    break
                end
            end

            -- Proceed if the bot has a target weapon and is visible within FOV
            if hasTargetWeapon and isPartVisible(head) and isInFOV(head) then
                local distance = (head.Position - player.Character.Head.Position).magnitude
                if distance < shortestDistance then
                    closestHead = head
                    shortestDistance = distance
                end
            end
        end
    end

    return closestHead
end

-- Function to create or update BoxHandleAdornment for highlighting
local function updateHighlight(head)
    if head then
        local highlight = head:FindFirstChild("Highlight")
        if not highlight then
            highlight = Instance.new("BoxHandleAdornment")
            highlight.Name = head.Name:lower().."_Highlight"
            highlight.Adornee = head
            highlight.Size = head.Size
            highlight.AlwaysOnTop = true
            highlight.ZIndex = 0
            highlight.Transparency = 0.5
            highlight.Color3 = Color3.fromRGB(255, 0, 0)  -- Red color
            highlight.Parent = head
        end
        highlight.Transparency = 0
    end
end

-- Function to remove highlight from all heads
local function removeHighlight()
    for _, bot in ipairs(workspace.Bots:GetChildren()) do
        local head = bot:FindFirstChild("Head")
        if head then
            local highlight = head:FindFirstChild("Highlight")
            if highlight then
                highlight:Destroy()
            end
        end
    end
end

-- Function to aim at the head with predictive aiming
local function aimAtHead(head)
    if head then
        local headPosition = head.Position
        local velocity = head.Velocity * predictionFactor  -- Adjust prediction factor based on desired strength

        -- Predicted position based on current velocity
        local predictedPosition = headPosition + velocity

        -- Adjust aim towards predicted position
        local direction = (predictedPosition - Camera.CFrame.Position).unit
        local newCameraCFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)
        Camera.CFrame = newCameraCFrame

    end
end

-- Increase Head Size Script with Specific Path

-- Services
local workspace = game:GetService("Workspace")

-- Configuration
local HEAD_SCALE_FACTOR = 5  -- Adjust this value to increase or decrease head size

-- Function to increase head size for bots with target weapons
local function increaseHeadSize()
    for _, bot in ipairs(workspace.Bots:GetChildren()) do
        if bot:IsA("Model") then
            local hasTargetWeapon = false

            -- Check if the bot has any of the target weapons
            for _, weaponName in ipairs(targetWeapons) do
                if bot:FindFirstChild(weaponName) then
                    hasTargetWeapon = true
                    break
                end
            end

            if hasTargetWeapon then
                local head = bot:FindFirstChild("Head")

                -- Check if bot has a valid head part
                if head and head:IsA("Part") then
                    -- Adjust head size based on a fixed scale factor
                    head.Size = head.Size * (HEAD_SCALE_FACTOR / head.Size.Y)
                end
            end
        end
    end
end




-- Update aimbot and highlighting every frame
RunService.RenderStepped:Connect(function()
    -- Check if aimbot toggle key is pressed
    if UserInputService:IsKeyDown(aimbotToggleKey) then
        aimbotEnabled = true  -- Enable aimbot when Shift is held down
    else
        aimbotEnabled = false  -- Disable aimbot otherwise
    end

    if aimbotEnabled then
        local targetHead = findNearestHead()

        if targetHead then
            aimAtHead(targetHead)
            increaseHeadSize()
        end

        -- Update highlighting for all heads with target weapons
        for _, bot in ipairs(workspace.Bots:GetChildren()) do
            if bot:IsA("Model") and bot:FindFirstChild("Head") and bot.Head:IsA("Part") then
                local head = bot.Head

                -- Check if the bot has any of the target weapons
                local hasTargetWeapon = false
                for _, weaponName in ipairs(targetWeapons) do
                    if bot:FindFirstChild(weaponName) then
                        hasTargetWeapon = true
                        break
                    end
                end

                -- Update highlight if the bot has a target weapon
                if hasTargetWeapon then
                    updateHighlight(head)
                else
                    -- Remove highlight if bot does not have a target weapon
                    local highlight = head:FindFirstChild("Highlight")
                    if highlight then
                        highlight:Destroy()
                    end
                end
            end
        end
    else
        removeHighlight()  -- Remove highlights if aimbot is disabled
    end
end)

-- Visualize FOV circle (optional)
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.Radius = FOV_RADIUS
fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Visible = true

RunService.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)
