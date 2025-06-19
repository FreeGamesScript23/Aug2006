local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()


local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = game.Players.LocalPlayer
local Player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local N = game:GetService("VirtualInputManager")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")

local defualtwalkspeed = 16
local defualtjumppower = 50
local defualtgravity = 196.1999969482422
newwalkspeed = defualtwalkspeed
newjumppower = defualtjumppower
antiafk = true

local AntiFlingEnabled = false
local playerAddedConnection = nil
local localHeartbeatConnection = nil 

local UserInputService = game:GetService("UserInputService")
local Touchscreen = UserInputService.TouchEnabled
getgenv().Ash_Device = Touchscreen and "Mobile" or "PC"
local placeId = game.PlaceId
local MarketplaceService = game:GetService("MarketplaceService")

-- Declare GameName outside the pcall block
local GameName

local success, info = pcall(function()
    return MarketplaceService:GetProductInfo(placeId)
end)

if success and info then
    GameName = info.Name
    print("Game Name: " .. GameName)
else
    GameName = "Unknown Game"
end


local Window = Fluent:CreateWindow({
    Title = "Hub" .. Fluent.Version,
    SubTitle = "Flee the facility",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Game", Icon = "gamepad" }),
    LPlayer = Window:AddTab({ Title = "Local Player", Icon = "users" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "wand" }),
    ServerH = Window:AddTab({ Title = "Server", Icon = "server" }), 
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do

function SendNotif(title, content, time)
Fluent:Notify({
        Title = title,
        Content = content,
        Duration = time
})
end
local rsrv = game:GetService("RunService")
local heartbeat = rsrv.Heartbeat
local renderstepped = rsrv.RenderStepped

local lp = game.Players.LocalPlayer
local mouse = lp:GetMouse()

local isinvisible = false
local visible_parts = {}
local kdown, loop

local function ghost_parts()
    for _, v in pairs(visible_parts) do
        v.Transparency = isinvisible and 0.5 or 0
    end
end

local function setup_character(character)
    local hum = character:WaitForChild("Humanoid")
    local root = character:WaitForChild("HumanoidRootPart")

    visible_parts = {}

    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") and v.Transparency == 0 then
            visible_parts[#visible_parts + 1] = v
        end
    end

    if kdown then
        kdown:Disconnect()
    end

    kdown = mouse.KeyDown:Connect(function(key)
        if key == "g" then
            isinvisible = not isinvisible
            ghost_parts()
        end
    end)

    if loop then
        loop:Disconnect()
    end

    loop = heartbeat:Connect(function()
        if isinvisible then
            local oldcf = root.CFrame
            local oldcamoffset = hum.CameraOffset

            local newcf = oldcf * CFrame.new(0, -40, 0)

            hum.CameraOffset = newcf:ToObjectSpace(CFrame.new(oldcf.Position)).Position
            root.CFrame = newcf

            renderstepped:Wait()

            hum.CameraOffset = oldcamoffset
            root.CFrame = oldcf
        end
    end)

    _G.cons = {kdown, loop}
end

lp.CharacterAdded:Connect(function(character)
    setup_character(character)
    if isinvisible then
        ghost_parts()
    end
end)

local function TeleportToPlayer(playerName)
    local targetPlayer = game.Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
    end
end
    -----THINGS---------
    local function GetOtherPlayers()
    local players = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    return players
end
    local Dropdown
local isResetting = false

local function CreateDropdown()
    Dropdown = Tabs.Teleport:AddDropdown("TPtoPlayer", {
        Title = "Teleport to Player",
        Values = GetOtherPlayers(),
        Multi = false,
        Default = "",
    })

    Dropdown:OnChanged(function(Value)
        if not isResetting and Value ~= "" then
            TeleportToPlayer(Value)
            isResetting = true
            Dropdown:SetValue("")  -- Reset selected value to default
            isResetting = false
        end
    end)
end

-- Initial creation of the dropdown
CreateDropdown()

local function UpdateDropdownA()
    local newValues = GetOtherPlayers()
    isResetting = true
    Dropdown.Values = newValues  -- Update the dropdown values
    Dropdown:SetValue("")  -- Reset selected value to default
    isResetting = false
end

-- Connect to PlayerAdded and PlayerRemoving events to update the dropdown
game.Players.PlayerAdded:Connect(UpdateDropdownA)
game.Players.PlayerRemoving:Connect(UpdateDropdownA)


    
    
    
   
Tabs.Main:AddButton({
    Title = "Update ESP",
    Description = "Click this when a new round starts",
    Callback = function()
        local waitTime = 0.5
        
        -- Store ESP options and their current values
        local espOptions = {
            {Option = Options.ExitsHighlight, Value = _G.ExitsESP},
            {Option = Options.PCHighlight, Value = _G.PCsESP},
            {Option = Options.PlayersHighlight, Value = _G.PlayersESP},
            {Option = Options.PodsHighlight, Value = _G.PodsESP},
            {Option = Options.Fullbright, Value = getgenv().Fullbright}
        }
        
        -- Turn on all ESP options
        for _, optionData in ipairs(espOptions) do
            if optionData.Value then
                optionData.Option:SetValue(true)
            end
        end

        wait(0.5)  -- Wait

        -- Turn off all ESP options and then turn them on again after a short delay
        for _, optionData in ipairs(espOptions) do
            if optionData.Value then
                optionData.Option:SetValue(false)
                wait(waitTime)
                optionData.Option:SetValue(true)
            end
        end
    end
})

local function updatePodsHighlight(pods)
    local state = pods

    if state then
        _G.PodsESP = true

        for _, obj in ipairs(game.Workspace:GetDescendants()) do
            if obj.Name == "FreezePod" then
                local hili = Instance.new("Highlight", obj)
                hili.Name = "PodsHighlight"
                hili.OutlineTransparency = 1
                hili.FillColor = Color3.fromRGB(0, 200, 255)
            end
        end
    else
        _G.PodsESP = false

        for _, obj in ipairs(game.Workspace:GetDescendants()) do
            if obj.Name == "PodsHighlight" then
                obj:Destroy()
            end
        end
    end
end

local function updateExitsHighlight(exits)
    local state = exits

    if state then
        _G.ExitsESP = true

        for _, obj in ipairs(game.Workspace:GetDescendants()) do
            if obj.Name == "ExitDoor" and not obj:FindFirstChild("ExitsHighlight") then
                local hili = Instance.new("Highlight", obj)
                hili.Name = "ExitsHighlight"
                hili.OutlineTransparency = 1
                hili.FillColor = Color3.fromRGB(255,255,0)
            end
        end
    else
        _G.ExitsESP = false

        for _, obj in ipairs(game.Workspace:GetDescendants()) do
            if obj.Name == "ExitsHighlight" then
                obj:Destroy()
            end
        end
    end
end

local state = false

local function getBeast()
    local players = game.Players:GetChildren()
    for _, player in ipairs(players) do
        local character = player.Character
        if character and character:FindFirstChild("BeastPowers") then
            return player
        end
    end
    return nil
end

local function getPlayerDistance(player)
    local localPlayer = game.Players.LocalPlayer
    if player and localPlayer.Character then
        local playerPosition = player.Character.HumanoidRootPart.Position
        local localPlayerPosition = localPlayer.Character.HumanoidRootPart.Position
        local distance = (playerPosition - localPlayerPosition).magnitude
        return distance
    end
    return math.huge -- Return a large value if distance cannot be calculated
end

-- Define the updatePlayersHighlight function
local function updatePlayersHighlight()
    if _G.PlayersESP then
        local players = game.Players:GetChildren()
        for _, player in ipairs(players) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local character = player.Character
                
                local distanceLabel = character:FindFirstChild("DistanceLabel")
                if not distanceLabel then
                    distanceLabel = Instance.new("BillboardGui", character)
                    distanceLabel.Name = "DistanceLabel"
                    distanceLabel.Size = UDim2.new(0, 100, 0, 40)
                    distanceLabel.StudsOffset = Vector3.new(0, 6, 0) -- Adjust the height of the label
                    distanceLabel.AlwaysOnTop = true
                    
                    local textLabel = Instance.new("TextLabel", distanceLabel)
                    textLabel.Size = UDim2.new(1, 0, 0.5, 0)
                    textLabel.Position = UDim2.new(0, 0, 0, 0)
                    textLabel.TextScaled = true
                    textLabel.BackgroundTransparency = 1
                    textLabel.TextColor3 = Color3.new(1, 1, 1)
                    textLabel.Font = Enum.Font.SourceSansBold -- Adjust font for readability
                    if player == getBeast() then
                        textLabel.TextColor3 = Color3.new(1, 0, 0)
                    else
                        textLabel.TextColor3 = Color3.new(0, 1, 0)
                    end
                end
                
                local distanceTextLabel = distanceLabel:FindFirstChild("TextLabel")
                if distanceTextLabel then
                    local distance = getPlayerDistance(player)
                    distanceTextLabel.Text = player.Name .. "\n" .. tostring(math.floor(distance)) .. "m"
                end
                
                local highlight = character:FindFirstChild("PlayerHighlight")
                if not highlight then
                    highlight = Instance.new("BoxHandleAdornment", character)
                    highlight.Name = "PlayerHighlight"
                    highlight.Size = Vector3.new(2, 4, 2)
                    highlight.AlwaysOnTop = true
                    highlight.ZIndex = 5
                    highlight.Transparency = 0.5
                    highlight.Color3 = Color3.fromRGB(0, 255, 0)
                    highlight.Adornee = character:FindFirstChild("HumanoidRootPart")
                end
                
                if player == getBeast() then
                    highlight.Color3 = Color3.fromRGB(255, 0, 0)
                else
                    highlight.Color3 = Color3.fromRGB(0, 255, 0)
                end
            end
        end
    else
        for _, obj in ipairs(game.Workspace:GetDescendants()) do
            if obj:IsA("BillboardGui") and obj.Name == "DistanceLabel" then
                obj:Destroy()
            elseif obj:IsA("BoxHandleAdornment") and obj.Name == "PlayerHighlight" then
                obj:Destroy()
            end
        end
    end
end





local function updatePCHighlight(pcs)
    local state = pcs

    if state then
        _G.PCsESP = true
    
        for _, obj in ipairs(game.Workspace:GetDescendants()) do
            if obj.Name == "ComputerTable" and not obj:FindFirstChild("PCHighlight") then
                local hili = Instance.new("Highlight", obj)
                hili.Name = "PCHighlight"
                hili.OutlineTransparency = 1
                hili.FillColor = obj:FindFirstChild("Screen").Color
            end
        end
    else
        _G.PCsESP = false

        for _, obj in ipairs(game.Workspace:GetDescendants()) do
            if obj.Name == "PCHighlight" then
                obj:Destroy()
            end
        end
    end
end

local TogglePods = Tabs.Main:AddToggle("PodsHighlight", {Title = "Pods ESP", Default = false})

TogglePods:OnChanged(function(pods)
    updatePodsHighlight(pods)
end)

Options.PodsHighlight:SetValue(false)

local ToggleExits = Tabs.Main:AddToggle("ExitsHighlight", {Title = "Exit ESP", Default = false})

ToggleExits:OnChanged(function(exits)
    updateExitsHighlight(exits)
end)

Options.ExitsHighlight:SetValue(false)

local TogglePCs = Tabs.Main:AddToggle("PCHighlight", {Title = "PCs ESP", Default = false})

TogglePCs:OnChanged(function(pcs)
    updatePCHighlight(pcs)
end)

Options.PCHighlight:SetValue(false)

local TogglePlayersESP = Tabs.Main:AddToggle("PlayersHighlight", {Title = "Players ESP", Default = false})

local updateLoop

-- Initialize PlayersESP variable
_G.PlayersESP = false

-- Toggle function
TogglePlayersESP:OnChanged(function(newState)
    _G.PlayersESP = newState
    local state = _G.PlayersESP

    if state then
        updateLoop = game:GetService("RunService").Heartbeat:Connect(updatePlayersHighlight)
    else
        if updateLoop then
            updateLoop:Disconnect()
            updateLoop = nil
        end
        for _, obj in ipairs(game.Workspace:GetDescendants()) do
            if obj:IsA("BillboardGui") and obj.Name == "DistanceLabel" then
                obj:Destroy()
            elseif obj:IsA("BoxHandleAdornment") and obj.Name == "PlayerHighlight" then
                obj:Destroy()
            end
        end
    end
end)

Options.PlayersHighlight:SetValue(false)


local ToggleAntiFail = Tabs.Main:AddToggle("AntiFail", {Title = "Anti Fail Computer", Default = false})

ToggleAntiFail:OnChanged(function(antiFail)
    local state = antiFail

    if state then
        task.spawn(function() 
            local OldNameCall = nil

            OldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
                local Args = {...}
                local NamecallMethod = getnamecallmethod()
                
                if NamecallMethod == "FireServer" and Args[1] == "SetPlayerMinigameResult" then
                    print("Minigame result - Intercepting result to true")
                    Args[2] = true
                end
                
                return OldNameCall(Self, unpack(Args))
            end)
        end)
    else
        -- Disable AntiFail here if needed
        -- Example: Disconnect the hook
    end
end)

Options.AntiFail:SetValue(false)

local ToggleFullbright = Tabs.Main:AddToggle("Fullbright", {Title = "Fullbright", Default = false})

local lighting = game:GetService("Lighting")

-- Store the original lighting settings to revert back to them later
local originalBrightness = lighting.Brightness
local originalClockTime = lighting.ClockTime
local originalFogEnd = lighting.FogEnd
local originalGlobalShadows = lighting.GlobalShadows
local originalOutdoorAmbient = lighting.OutdoorAmbient
local originalAmbient = lighting.Ambient

ToggleFullbright:OnChanged(function(fullbright)
    getgenv().Fullbright = fullbright

    if fullbright then
        lighting.Brightness = 2
        lighting.ClockTime = 14
        lighting.FogEnd = 100000
        lighting.GlobalShadows = false
        lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        lighting.Ambient = Color3.fromRGB(128, 128, 128) -- Set ambient light for fullbright
    else
        -- Revert to the original lighting settings
        lighting.Brightness = originalBrightness
        lighting.ClockTime = originalClockTime
        lighting.FogEnd = originalFogEnd
        lighting.GlobalShadows = originalGlobalShadows
        lighting.OutdoorAmbient = originalOutdoorAmbient
        lighting.Ambient = originalAmbient
    end
end)


Tabs.ServerH:AddButton({
        Title = "Rejoin",
        Description = "Rejoining on this current server",
        Callback = function()
            Window:Dialog({
                Title = "Rejoin this server?",
                Content = "Do you want to rejoin this server? ",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer)
        wait()
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Rejoin cancelled.")
                        end
                    }
                }
            })
        end
    })

Tabs.ServerH:AddButton({
        Title = "Serverhop",
        Description = "Join to another server",
        Callback = function()
            Window:Dialog({
                Title = "Join to another server?",
                Content = "Do you want to join to another server?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            loadstring(game:HttpGet("https://raw.githubusercontent.com/LordRayven/Hub/main/ServerHop.lua", true))()
        wait()
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Serverhop cancelled.")
                        end
                    }
                }
            })
        end
    })
    
    local Toggle = Tabs.LPlayer:AddToggle("Noclip", {Title = "Noclip", Default = false })

Toggle:OnChanged(function(noclip)
    loopnoclip = noclip
    while loopnoclip do
        local function loopnoclipfix()
            for _, b in pairs(Workspace:GetChildren()) do
                if b.Name == LocalPlayer.Name then
                    for _, v in pairs(Workspace[LocalPlayer.Name]:GetChildren()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end
            wait()
        end
        wait()
        pcall(loopnoclipfix)
    end
end)

Options.Noclip:SetValue(false)

local Toggle = Tabs.LPlayer:AddToggle("FEInvisible", {Title = "FE Invisible", Default = false })

Toggle:OnChanged(function(value)
    isinvisible = value
    if lp.Character then
        if not isinvisible then
            -- Restore visibility
            for _, v in pairs(visible_parts) do
                v.Transparency = 0
            end
        else
            ghost_parts()
        end
    end
end)

if lp.Character then
    setup_character(lp.Character)
    if isinvisible then
        ghost_parts()
    end
end

Options.FEInvisible:SetValue(false)

    
-- Store input values in getgenv()
getgenv().walkSpeedValue = 16
getgenv().jumpPowerValue = 50

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Set initial values
    humanoid:SetAttribute("WalkSpeed", getgenv().walkSpeedValue)
    humanoid:SetAttribute("JumpPower", getgenv().jumpPowerValue)
    humanoid:SetAttribute("WalkSpeedLock", false) -- Start unlocked
    humanoid:SetAttribute("JumpPowerLock", false) -- Start unlocked

    -- Update humanoid properties
    humanoid.WalkSpeed = humanoid:GetAttribute("WalkSpeed")
    humanoid.JumpPower = humanoid:GetAttribute("JumpPower")

    -- Monitor and enforce locked values
    spawn(function()
        while true do
            wait(0.1) -- Check every 0.1 seconds
            if humanoid:GetAttribute("WalkSpeedLock") and humanoid.WalkSpeed ~= getgenv().walkSpeedValue then
                humanoid.WalkSpeed = getgenv().walkSpeedValue
            end
            if humanoid:GetAttribute("JumpPowerLock") and humanoid.JumpPower ~= getgenv().jumpPowerValue then
                humanoid.JumpPower = getgenv().jumpPowerValue
            end
        end
    end)

    -- Listen for attribute changes
    humanoid:GetAttributeChangedSignal("WalkSpeed"):Connect(function()
        if not humanoid:GetAttribute("WalkSpeedLock") then
            humanoid.WalkSpeed = humanoid:GetAttribute("WalkSpeed")
            print("WalkSpeed updated to:", humanoid.WalkSpeed)
        end
    end)
    humanoid:GetAttributeChangedSignal("JumpPower"):Connect(function()
        if not humanoid:GetAttribute("JumpPowerLock") then
            humanoid.JumpPower = humanoid:GetAttribute("JumpPower")
            print("JumpPower updated to:", humanoid.JumpPower)
        end
    end)
end

-- Listen for CharacterAdded event
player.CharacterAdded:Connect(onCharacterAdded)

-- Trigger onCharacterAdded immediately if character already exists
if player.Character then
    onCharacterAdded(player.Character)
end

Tabs.LPlayer:AddInput("WalkSpeed", {
    Title = "WalkSpeed",
    Default = "16",
    Placeholder = "Enter WalkSpeed",
    Numeric = true, -- Only allows numbers
    Finished = true, -- Only calls callback when you press enter
    Callback = function(Value)
        getgenv().walkSpeedValue = tonumber(Value) or getgenv().walkSpeedValue -- If input is invalid, keep the previous value
        print("WalkSpeed input changed to:", getgenv().walkSpeedValue)
    end
})

Tabs.LPlayer:AddInput("JumpPower", {
    Title = "JumpPower",
    Default = "50",
    Placeholder = "Enter JumpPower",
    Numeric = true, -- Only allows numbers
    Finished = true, -- Only calls callback when you press enter
    Callback = function(Value)
        getgenv().jumpPowerValue = tonumber(Value) or getgenv().jumpPowerValue -- If input is invalid, keep the previous value
        print("JumpPower input changed to:", getgenv().jumpPowerValue)
    end
})

Tabs.LPlayer:AddButton({
    Title = "Lock WalkSpeed",
    Description = "So when you crouch it won't reset the speed",
    Callback = function()
        if player.Character then
            player.Character.Humanoid:SetAttribute("WalkSpeed", getgenv().walkSpeedValue)
            player.Character.Humanoid:SetAttribute("WalkSpeedLock", true)
            print("WalkSpeed locked at:", getgenv().walkSpeedValue)
        else
            print("Character not found")
        end
    end
})

Tabs.LPlayer:AddButton({
    Title = "Lock JumpPower",
    Description = "So when you crouch it won't reset your jump power",
    Callback = function()
        if player.Character then
            player.Character.Humanoid:SetAttribute("JumpPower", getgenv().jumpPowerValue)
            player.Character.Humanoid:SetAttribute("JumpPowerLock", true)
            print("JumpPower locked at:", getgenv().jumpPowerValue)
        else
            print("Character not found")
        end
    end
})



Tabs.LPlayer:AddParagraph({
        Title = "This is for Scrolling",
        Content = "For scrolling only"
    })
    Tabs.LPlayer:AddParagraph({
        Title = "This is for Scrolling",
        Content = "For scrolling only"
    })
Tabs.LPlayer:AddParagraph({
        Title = "This is for Scrolling",
        Content = "For scrolling only"
    })
    
    Tabs.Main:AddParagraph({
        Title = "This is for Scrolling",
        Content = "For scrolling only"
    })
    Tabs.Main:AddParagraph({
        Title = "This is for Scrolling",
        Content = "For scrolling only"
    })
Tabs.Main:AddParagraph({
        Title = "This is for Scrolling",
        Content = "For scrolling only"
    })

local Toggle = Tabs.Main:AddToggle("FEinviButton", {Title = "FE invisible Button", Default = false})

-- Variable to hold the ScreenGui and its position
local screenGui
local savedPosition = UDim2.new(0.5, -75, 0.5, -37.5)  -- Default position

local function createGui()
    -- Create a ScreenGui
    screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Create a Frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 100, 0, 75) -- Smaller size
    frame.Position = savedPosition  -- Use saved position
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black background
    frame.Parent = screenGui

    -- Add UICorner to Frame
    local uiCornerFrame = Instance.new("UICorner")
    uiCornerFrame.CornerRadius = UDim.new(0, 15)
    uiCornerFrame.Parent = frame

    -- Create a Button
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 80, 0, 40) -- Smaller size
    button.Position = UDim2.new(0.5, 0, 0.5, 0) -- Centered in the frame
    button.AnchorPoint = Vector2.new(0.5, 0.5)
    button.BackgroundTransparency = 1 -- Remove background color
    button.Text = "Invisible [ON]"
    button.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text color
    button.Parent = frame

    -- Function to toggle button text based on Options.FEInvisible value
    local function toggleButtonText()
        if Options.FEInvisible.Value then
            button.Text = " FE Invisible [ON]"
        else
            button.Text = "FE Invisible [OFF]"
        end
    end

    -- Connect the button click event to the toggle function
    button.MouseButton1Click:Connect(function()
        Options.FEInvisible:SetValue(not Options.FEInvisible.Value)
        toggleButtonText()
    end)

    -- Make the Frame draggable
    local UserInputService = game:GetService("UserInputService")

    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        savedPosition = frame.Position  -- Save the updated position
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Update button text based on Options.FEInvisible initial value
    toggleButtonText()
end

-- Function to handle GUI creation and destruction
local function handleToggle(value)
    if value then
        -- Create and show the GUI
        createGui()
    else
        -- Destroy the GUI
        if screenGui then
            screenGui:Destroy()
            screenGui = nil
        end
    end
end

-- Handle the toggle state change
Toggle:OnChanged(handleToggle)

-- Set the initial state of the toggle
Options.FEInvisible:SetValue(false)

-- Ensure the GUI persists across respawns
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function()
    if Toggle.Value then
        createGui()
    end
end)







end
        
-- Create a ScreenGui object to hold the button
local gui = Instance.new("ScreenGui")
gui.Name = "HubGui"
gui.Parent = game.CoreGui

-- Create the button as a TextButton
local button = Instance.new("TextButton")
button.Name = "ToggleButton"
button.Text = "Close" -- Initial text set to "Close"
button.Size = UDim2.new(0, 70, 0, 30) -- Adjust the size as needed
button.Position = UDim2.new(0, 10, 0, 10) -- Position at top left with 10px offset
button.BackgroundTransparency = 0.7 -- Set transparency to 50%
button.BackgroundColor3 = Color3.fromRGB(97, 62, 167) -- Purple background color
button.BorderSizePixel = 2 -- Add black stroke
button.BorderColor3 = Color3.new(0, 0, 0) -- Black stroke color
button.TextColor3 = Color3.new(1, 1, 1) -- White text color
button.FontSize = Enum.FontSize.Size12 -- Adjust text size
button.TextScaled = false -- Allow text to scale with button size
button.TextWrapped = true -- Wrap text if it's too long
button.TextStrokeTransparency = 0 -- Make text fully visible
button.TextStrokeColor3 = Color3.new(0, 0, 0) -- Black text stroke color
button.Parent = gui

-- Apply blur effect
local blur = Instance.new("BlurEffect")
blur.Parent = button
blur.Size = 5 -- Adjust blur size as needed

-- Variable to keep track of button state
local isOpen = false
local isDraggable = false
local dragConnection

-- Functionality for the button
button.MouseButton1Click:Connect(function()
        isOpen = not isOpen -- Toggle button state
        
        if isOpen then
            button.Text = "Open"
        else
            button.Text = "Close"
        end
        
        Window:Minimize()
end)

-- Function to make the button draggable
function setDraggable(draggable)
        if draggable then
            -- Connect events for dragging
            dragConnection = button.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    local dragStart = input.Position
                    local startPos = button.Position
                    local dragInput = input

                    local function onInputChanged(input)
                        if input == dragInput then
                            local delta = input.Position - dragStart
                            button.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                        end
                    end

                    local function onInputEnded(input)
                        if input == dragInput then
                            dragInput = nil
                            game:GetService("UserInputService").InputChanged:Disconnect(onInputChanged)
                            input.Changed:Disconnect(onInputEnded)
                        end
                    end

                    game:GetService("UserInputService").InputChanged:Connect(onInputChanged)
                    input.Changed:Connect(onInputEnded)
                end
            end)
        else
            -- Disconnect events if not draggable
            if dragConnection then
                dragConnection:Disconnect()
                dragConnection = nil -- Reset dragConnection
            end
        end
end

-- Function to toggle button visibility
function toggleButtonVisibility(visible)
        button.Visible = visible
end

Tabs.Settings:AddParagraph({
            Title = "To open Window from Chat just say:",
            Content = "/e ash"
        })


        -- Function to fetch avatar URL using Roblox API
local function fetchAvatarUrl(userId)
    local url = "https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. userId .. "&size=420x420&format=Png&isCircular=false"
    local response = HttpService:JSONDecode(game:HttpGet(url))
    if response and response.data and #response.data > 0 then
        return response.data[1].imageUrl
    else
        return "https://www.example.com/default-avatar.png"  -- Replace with a default avatar URL
    end
    end
    
    -- Fetch avatar URL for LocalPlayer
    local avatarUrl = fetchAvatarUrl(LocalPlayer.UserId)
    
    -- Function to get current timestamp in a specific format
    local function getCurrentTime()
    local hour = tonumber(os.date("!%H", os.time() + 8 * 3600)) -- Convert to Philippine Standard Time (UTC+8)
    local minute = os.date("!%M", os.time() + 8 * 3600)
    local second = os.date("!%S", os.time() + 8 * 3600)
    local day = os.date("!%d", os.time() + 8 * 3600)
    local month = os.date("!%m", os.time() + 8 * 3600)
    local year = os.date("!%Y", os.time() + 8 * 3600)
    
    local suffix = "AM"
    if hour >= 12 then
        suffix = "PM"
        if hour > 12 then
            hour = hour - 12
        end
    elseif hour == 0 then
        hour = 12
    end
    
    return string.format("%02d-%02d-%04d %02d:%02d:%02d %s", month, day, year, hour, minute, second, suffix)
    end
    
    -- Define the Input field for user feedback
    local Input = Tabs.Settings:AddInput("Input", {
    Title = "Send FeedBack",
    Default = "",
    Placeholder = "Send your feedback to Ashbornn",
    Numeric = false, -- Only allows numbers
    Finished = false, -- Only calls callback when you press enter
    Callback = function(Value)
        -- This function can be used for validation or other callback logic if needed
    end
    })
    
   -- Define the function to send feedback to Discord
local function sendFeedbackToDiscord(feedbackMessage)
    local response = request({
        Url = "https://discord.com/api/webhooks/1255142396639973377/91po7RwMaLiXYgeerK6KCFRab6h20xHy_WepLYJvIjcTxiv_kwAyJBa9DnPDJjc0F-ga",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode({
            embeds = {{
                title = LocalPlayer.Name .. " (" .. LocalPlayer.UserId .. ")",
                description = "Hi " .. LocalPlayer.Name .. " Send a Feedback! in " .. Ash_Device .. ", Using " .. identifyexecutor(),
                color = 16711935,
                footer = { text = "Timestamp: " .. getCurrentTime() },
                author = { name = "User Send a Feedback in \nGame Place:\n" .. GameName .. " (" .. game.PlaceId .. ")" },  -- Replace with actual identification method
                fields = {
                    { name = "Feedback: ", value = feedbackMessage, inline = true }
                },
                thumbnail = {
                    url = avatarUrl
                }
            }}
        })
    })
    
    if response and response.StatusCode == 204 then
        print("Feedback sent successfully.")
        SendNotif("Feedback has been sent to Ashbornn Thank you.", " ", 3)
    else
        warn("Failed to send feedback to Discord:", response)
    end
    end
    
    -- Define a variable to track the last time feedback was sent
    local lastFeedbackTime = 0
    local cooldownDuration = 60  -- Cooldown period in seconds (1 minute)
    
    -- Function to check if enough time has passed since last feedback
    local function canSendFeedback()
    local currentTime = os.time()
    return (currentTime - lastFeedbackTime >= cooldownDuration)
    end
    
    -- Update lastFeedbackTime after sending feedback
    local function updateLastFeedbackTime()
    lastFeedbackTime = os.time()
    end
    
    -- Define the button to send feedback
    Tabs.Settings:AddButton({
    Title = "Send FeedBack",
    Description = "Tap to Send",
    Callback = function()
        if not canSendFeedback() then
            SendNotif("You cant spam this message", "Try again Later Lol", 3)
            return
        end
        
        local feedbackMessage = Input.Value  -- Get the value directly from Input
        
        -- Check if feedbackMessage is non-empty before sending
        if feedbackMessage and feedbackMessage ~= "" then
            sendFeedbackToDiscord(feedbackMessage)
            updateLastFeedbackTime()  -- Update cooldown timestamp
        else
            SendNotif("You cant send empty feedback loll", "Try again later", 3)
        end
    end
    })
    


-- Create the toggle for draggable button
local DraggableToggle = Tabs.Settings:AddToggle("Draggable Button", {Title = "Draggable Button", Default = false})

DraggableToggle:OnChanged(function(value)
        isDraggable = value
        setDraggable(isDraggable)
end)

-- Create another toggle for button visibility
local VisibilityToggle = Tabs.Settings:AddToggle("Button Visibility", {Title = "Toggle Window Visibility", Default = true})

VisibilityToggle:OnChanged(function(value)
        toggleButtonVisibility(value)
end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder(string.char(65,115,104,98,111,114,110,110,72,117,98))
SaveManager:SetFolder(string.char(65,115,104,98,111,114,110,110,72,117,98,47,77,77,50))

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()

local TimeEnd = tick()
local TotalTime = string.format("%.2f", math.abs(TimeStart - TimeEnd))
SendNotif(string.char(65,115,104,98,111,114,110,110,72,117,98), string.char(83,117,99,99,101,115,115,102,117,108,108,121,32,108,111,97,100,101,100,32,116,104,101,32,115,99,114,105,112,116,32,105,110,32) .. TotalTime .. string.char(115,46), 3)
