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



local mt = getrawmetatable(game);
local old = {};
for i, v in next, mt do old[i] = v end;
setreadonly(mt,false)
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
    Title = "Ashbornn Hub " .. Fluent.Version,
    SubTitle = "BloxHunt",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Game", Icon = "gamepad" }),
    Universal = Window:AddTab({ Title = "Universal", Icon = "box" }),
    LPlayer = Window:AddTab({ Title = "Local Player", Icon = "user" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "wand" }),
    Server = Window:AddTab({ Title = "Server", Icon = "server" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}


local Options = Fluent.Options

do



local function TeleportToPlayer(playerName)
    local targetPlayer = game.Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
    end
end

local function GetOtherPlayers()
    local players = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    return players
end

local Toggle = Tabs.LPlayer:AddToggle("AntiFling", {Title = "Anti Fling", Default = false })

local function togglePlayerCollision(enable)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local playerCharacter = player.Character
            if playerCharacter then
                for _, part in ipairs(playerCharacter:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = not enable
                    end
                end
            end
        end
    end
end

local function enableAntiFling()
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not Toggle.Value then
            connection:Disconnect()
            return
        end
        togglePlayerCollision(true)
    end)
end

local function disableAntiFling()
    togglePlayerCollision(false)
end

local function onCharacterAdded(character)
    if Toggle.Value then
        togglePlayerCollision(true)  -- Ensure anti-fling behavior on character respawn
    end
end

Toggle:OnChanged(function(antiFling)
    if antiFling then
        enableAntiFling()
    else
        disableAntiFling()
    end
end)

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
if Toggle.Value and LocalPlayer.Character then
    togglePlayerCollision(true)  -- Ensure anti-fling behavior when toggle is initially enabled
end

local FLINGTARGET = "" -- Initialize FLINGTARGET variable

local function GetOtherPlayers()
    local players = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    return players
end

local selectedPlayer = ""  -- Variable to store the selected player's name
local FLINGTARGET = ""  -- Variable to store the fling target
local Dropdown

local function CreateDropdown()
    Dropdown = Tabs.Universal:AddDropdown("Select Player", {
        Title = "Select Player",
        Values = GetOtherPlayers(),
        Multi = false,
        Default = "",
    })

    Dropdown:OnChanged(function(Value)
        selectedPlayer = Value  -- Update selectedPlayer when selection changes
        FLINGTARGET = Value  -- Update FLINGTARGET when selection changes
    end)
end

-- Initial creation of the dropdown
CreateDropdown()

local function UpdateDropdown()
    local newValues = GetOtherPlayers()
    Dropdown.Values = newValues  -- Update the dropdown values
    Dropdown:SetValue("")  -- Reset selected value to default
end

-- Connect to PlayerAdded and PlayerRemoving events to update the dropdown
game.Players.PlayerAdded:Connect(UpdateDropdown)
game.Players.PlayerRemoving:Connect(UpdateDropdown)

local Toggle = Tabs.Universal:AddToggle("Fling", {
    Title = "Fling",
    Default = false
})

Toggle:OnChanged(function(flingplayer)
    if flingplayer == true then
        -- Ensure a player is selected before executing the script
        if selectedPlayer ~= "" then
            -- You can pass the selectedPlayer to the loaded script if needed
            getgenv().FLINGTARGET = selectedPlayer
            loadstring(game:HttpGet('https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/FlingGood.lua'))()
            wait()
        else
            -- Handle case when no player is selected
            print("No player selected for flinging.")
        end
    end
    
    if flingplayer == false then
        getgenv().flingloop = false
        wait()
    end
end)


local Toggle = Tabs.LPlayer:AddToggle("Noclip", {Title = "Noclip", Default = false })

Toggle:OnChanged(function(noclip)
        loopnoclip = noclip
        while loopnoclip do
            function loopnoclipfix()
                for _, b in pairs(Workspace:GetChildren()) do
                    if b.Name == LocalPlayer.Name then
                        for _, v in pairs(Workspace[LocalPlayer.Name]:GetChildren()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                end
                task.wait()
            end
            task.wait()
            pcall(loopnoclipfix)
        end
end)

Options.Noclip:SetValue(false)

Tabs.Server:AddButton({
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

Tabs.Server:AddButton({
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
    
    
    local function CreateDropdownB()
    local Dropdown = Tabs.Visual:AddDropdown("ViewPlayerd", {
        Title = "View Player / Spectate Player",
        Values = GetOtherPlayers(),
        Multi = false,
        Default = "",
    })

    Dropdown:OnChanged(function(Value)
        if not isResetting and Value ~= "" then
            workspace.Camera.CameraSubject = game:GetService("Players")[Value].Character:WaitForChild("Humanoid")
            isResetting = true
            Dropdown:SetValue("")  -- Reset selected value to default
            isResetting = false
        end
    end)

    return Dropdown
end

-- Initial creation of the dropdown
local Dropdown = CreateDropdownB()

local function UpdateDropdownB()
    local newValues = GetOtherPlayers()
    isResetting = true
    Dropdown.Values = newValues  -- Update the dropdown values
    Dropdown:SetValue("")  -- Reset selected value to default
    isResetting = false
end

-- Connect to PlayerAdded and PlayerRemoving events to update the dropdown
game.Players.PlayerAdded:Connect(UpdateDropdownB)
game.Players.PlayerRemoving:Connect(UpdateDropdownB)

Tabs.Visual:AddButton({
    Title = "Stop Viewing",
    Description = "Stop viewing the selected player",
    Callback = function()
        workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
    end
})

local Dropdown
local isResetting = false

local function CreateDropdownC()
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
CreateDropdownC()

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

Tabs.Universal:AddButton({
        Title = "Infinite Yield",
        Description = "Best script for all games",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end
    })
    
Tabs.LPlayer:AddButton({
    Title = "Respawn",
    Callback = function()
        LocalPlayer.Character:WaitForChild("Humanoid").Health = 0
        wait()
    end
})

Tabs.Universal:AddButton({
    Title = "Open Console",
    Callback = function()
        game.StarterGui:SetCore("DevConsoleVisible", true)
        wait()
    end
})

Tabs.Universal:AddButton({
    Title = "Anti-Lag (Smooth parts)",
    Callback = function()
        local ToDisable = {
	Textures = true,
	VisualEffects = true,
	Parts = true,
	Particles = true,
	Sky = true
}

local ToEnable = {
	FullBright = false
}

local Stuff = {}

for _, v in next, game:GetDescendants() do
	if ToDisable.Parts then
		if v:IsA("Part") or v:IsA("Union") or v:IsA("BasePart") then
			v.Material = Enum.Material.SmoothPlastic
			table.insert(Stuff, 1, v)
		end
	end
	
	if ToDisable.Particles then
		if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Explosion") or v:IsA("Sparkles") or v:IsA("Fire") then
			v.Enabled = false
			table.insert(Stuff, 1, v)
		end
	end
	
	if ToDisable.VisualEffects then
		if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
			v.Enabled = false
			table.insert(Stuff, 1, v)
		end
	end
	
	if ToDisable.Textures then
		if v:IsA("Decal") or v:IsA("Texture") then
			v.Texture = ""
			table.insert(Stuff, 1, v)
		end
	end
	
	if ToDisable.Sky then
		if v:IsA("Sky") then
			v.Parent = nil
			table.insert(Stuff, 1, v)
		end
	end
end

game:GetService("TestService"):Message("Effects Disabler Script : Successfully disabled "..#Stuff.." assets / effects. Settings :")

for i, v in next, ToDisable do
	print(tostring(i)..": "..tostring(v))
end

if ToEnable.FullBright then
    local Lighting = game:GetService("Lighting")
    
    Lighting.FogColor = Color3.fromRGB(255, 255, 255)
    Lighting.FogEnd = math.huge
    Lighting.FogStart = math.huge
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 5
    Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
    Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.Outlines = true
end
    end
})


local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Slider for WalkSpeed
local WalkSpeedSlider = Tabs.LPlayer:AddSlider("WalkSpeedSlider", {
    Title = "WalkSpeed Slider",
    Description = "Adjust WalkSpeed",
    Default = 16, -- Default WalkSpeed
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        humanoid.WalkSpeed = Value
        print("WalkSpeed was changed to:", Value)
    end
})

WalkSpeedSlider:OnChanged(function(Value)
    humanoid.WalkSpeed = Value
    print("WalkSpeed changed to:", Value)
end)

WalkSpeedSlider:SetValue(16)

-- Slider for JumpPower
local JumpPowerSlider = Tabs.LPlayer:AddSlider("JumpPowerSlider", {
    Title = "JumpPower Slider",
    Description = "Adjust JumpPower",
    Default = 50, -- Default JumpPower
    Min = 0,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        humanoid.JumpPower = Value
        print("JumpPower was changed to:", Value)
    end
})

JumpPowerSlider:OnChanged(function(Value)
    humanoid.JumpPower = Value
    print("JumpPower changed to:", Value)
end)

JumpPowerSlider:SetValue(50)

--//Toggle\\--
local Toggle = Tabs.Visual:AddToggle("ESPPlayers", {Title = "ESP Players", Default = false })
local TeamCheckToggle = Tabs.Visual:AddToggle("TeamCheck", {Title = "Team Check", Default = false })

--//Variables\\--
local PlayerName = "Name" -- You can decide if you want the Player's name to be a display name which is "DisplayName", or username which is "Name"
local P = game:GetService("Players")
local LP = P.LocalPlayer

--//Debounce\\--
local DB = false
local ESPRunning = false

--//ESP Clear Function\\--
local function ClearESP()
    for _, player in pairs(P:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("Totally NOT Esp")
            local icon = player.Character:FindFirstChild("Icon")
            if highlight then
                highlight:Destroy()
            end
            if icon then
                icon:Destroy()
            end
        end
    end
end

--//Loop\\--
local function ESP()
    ESPRunning = true
    while ESPRunning do
        if not Toggle.Value then
            ESPRunning = false
            ClearESP()
            break
        end
        if DB then 
            return 
        end
        DB = true

        pcall(function()
            for i, v in pairs(P:GetPlayers()) do
                if v ~= LP then
                    if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local pos = math.floor((LP.Character:FindFirstChild("HumanoidRootPart").Position - v.Character:FindFirstChild("HumanoidRootPart").Position).magnitude)

                        if not TeamCheckToggle.Value or (v.TeamColor ~= LP.TeamColor) then
                            if v.Character:FindFirstChild("Totally NOT Esp") == nil and v.Character:FindFirstChild("Icon") == nil then
                                --//ESP-Highlight\\--
                                local ESP = Instance.new("Highlight", v.Character)
                                ESP.Name = "Totally NOT Esp"
                                ESP.Adornee = v.Character
                                ESP.Archivable = true
                                ESP.Enabled = true
                                ESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                ESP.FillColor = v.TeamColor.Color
                                ESP.FillTransparency = 0.5
                                ESP.OutlineColor = Color3.fromRGB(255, 255, 255)
                                ESP.OutlineTransparency = 0

                                --//ESP-Text\\--
                                local Icon = Instance.new("BillboardGui", v.Character)
                                local ESPText = Instance.new("TextLabel")

                                Icon.Name = "Icon"
                                Icon.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                                Icon.Active = true
                                Icon.AlwaysOnTop = true
                                Icon.ExtentsOffset = Vector3.new(0, 1, 0)
                                Icon.LightInfluence = 1.000
                                Icon.Size = UDim2.new(0, 800, 0, 50)

                                ESPText.Name = "ESP Text"
                                ESPText.Parent = Icon
                                ESPText.BackgroundColor3 = v.TeamColor.Color
                                ESPText.BackgroundTransparency = 1.000
                                ESPText.Size = UDim2.new(0, 800, 0, 50)
                                ESPText.Font = Enum.Font.SciFi
                                ESPText.Text = v[PlayerName].." | Distance: "..pos
                                ESPText.TextColor3 = v.TeamColor.Color
                                ESPText.TextSize = 18.000
                                ESPText.TextWrapped = true
                            else
                                if not v.Character:FindFirstChild("Totally NOT Esp").FillColor == v.TeamColor.Color and not v.Character:FindFirstChild("Icon").TextColor3 == v.TeamColor.Color then
                                    v.Character:FindFirstChild("Totally NOT Esp").FillColor = v.TeamColor.Color
                                    v.Character:FindFirstChild("Icon").TextColor3 = v.TeamColor.Color
                                else
                                    if v.Character:FindFirstChild("Totally NOT Esp").Enabled == false and v.Character:FindFirstChild("Icon").Enabled == false then
                                        v.Character:FindFirstChild("Totally NOT Esp").Enabled = true
                                        v.Character:FindFirstChild("Icon").Enabled = true
                                    else
                                        if v.Character:FindFirstChild("Icon") then
                                            v.Character:FindFirstChild("Icon")["ESP Text"].Text = v[PlayerName].." | Distance: "..pos
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)

        wait()

        DB = false
    end
end

Toggle:OnChanged(function()
    if Toggle.Value then
        ESP()
    else
        ESPRunning = false
        ClearESP()
    end
end)

TeamCheckToggle:OnChanged(function()
    -- This is where you can add any additional logic if needed when the team check toggle changes.
end)

Options.ESPPlayers:SetValue(false)
Options.TeamCheck:SetValue(false)



local Toggle = Tabs.Main:AddToggle("HighlightObjects", {Title = "ESP Hiders", Default = false })

local function HighlightObject(object)
    local Highlight = Instance.new("Highlight", object)
    Highlight.FillColor = Color3.fromRGB(255, 255, 0)
end

local function HighlightPlayer(player)
    if player.Character:FindFirstChild("Object") then
        HighlightObject(player.Character.Object)
    end
    
    player.Character.ChildAdded:Connect(function(child)
        if child.Name == "Object" then
            HighlightObject(child)
        end
    end)
end

local function EnableHighlighting()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        HighlightPlayer(player)
    end

    game:GetService("Players").PlayerAdded:Connect(function(player)
        HighlightPlayer(player)
    end)
end

local function DisableHighlighting()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player.Character:FindFirstChild("Object") then
            local object = player.Character.Object
            for _, highlight in ipairs(object:GetChildren()) do
                if highlight:IsA("Highlight") then
                    highlight:Destroy()
                end
            end
        end
    end
end

Toggle:OnChanged(function(value)
    if value then
        EnableHighlighting()
    else
        DisableHighlighting()
    end
end)

local player = game.Players.LocalPlayer
local teleportPosition = CFrame.new(-90, 62, 143)
local teleportEnabled = false

-- Function to teleport the player
local function teleportToCoin()
    player.Character.HumanoidRootPart.CFrame = teleportPosition
end

-- Button to teleport to coin
Tabs.Main:AddButton({
    Title = "TP to Coin",
    Description = "Teleport to Obby Coin",
    Callback = function()
        teleportToCoin()
    end
})

-- Toggle for looping teleport
local Toggle = Tabs.Main:AddToggle("LoopTPCoin", {
    Title = "Loop Teleport to Coin",
    Default = false
})

-- Handle the toggle change
Toggle:OnChanged(function(value)
    teleportEnabled = value
end)

-- Loop teleport using RenderStepped
game:GetService("RunService").RenderStepped:Connect(function()
    if teleportEnabled then
        teleportToCoin()
    end
end)

-- Set the initial value of the toggle to false
Options.LoopTPCoin:SetValue(false)

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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
