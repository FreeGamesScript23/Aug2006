local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "AshbornnHub " .. Fluent.Version,
    SubTitle = "Universal by Ashbornn",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {

    Universal = Window:AddTab({ Title = "Universal", Icon = "box" }),
    LP = Window:AddTab({ Title = "Local Player", Icon = "user-round" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Create a ScreenGui object to hold the button
local gui = Instance.new("ScreenGui")
gui.Name = "AshbornnHubGui"
gui.Parent = game.CoreGui

-- Create the button
local button = Instance.new("TextButton")
button.Name = "ToggleButton"
button.Text = "Open/Close"
button.Size = UDim2.new(0, 70, 0, 30) -- Adjust the size as needed
button.Position = UDim2.new(0, 10, 0, 10) -- Position at top left with 10px offset
button.BackgroundColor3 = Color3.new(0, 0, 0) -- Black background
button.TextColor3 = Color3.new(1, 1, 1) -- White text
button.Parent = gui

-- Functionality for the button
button.MouseButton1Click:Connect(function()
    Window:Minimize()
    
end)


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



local AntiFlingEnabled = false
local playerAddedConnection = nil
local localHeartbeatConnection = nil

-- Constants
local Services = setmetatable({}, {
    __index = function(Self, Index)
        local NewService = game:GetService(Index)
        if NewService then
            Self[Index] = NewService
        end
        return NewService
    end
})

local LocalPlayer = Services.Players.LocalPlayer

-- Functions
local function CharacterAdded(Player)
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local PrimaryPart = Character:WaitForChild("HumanoidRootPart")

    local Detected = false

    local function CheckFling()
        if not (Character:IsDescendantOf(workspace) and PrimaryPart:IsDescendantOf(Character)) then
            return
        end

        if PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 or PrimaryPart.AssemblyLinearVelocity.Magnitude > 100 then
            if not Detected then
                game.StarterGui:SetCore("ChatMakeSystemMessage", {
                    Text = "Fling Exploit detected, Player: " .. tostring(Player);
                    Color = Color3.fromRGB(255, 200, 0);
                })
            end
            Detected = true

            for _, Part in ipairs(Character:GetDescendants()) do
                if Part:IsA("BasePart") then
                    Part.CanCollide = false
                    Part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    Part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
                end
            end

            PrimaryPart.CanCollide = false
            PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            PrimaryPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
        end
    end

    Services.RunService.Heartbeat:Connect(CheckFling)
end

local function OnPlayerAdded(Player)
    if AntiFlingEnabled and Player ~= LocalPlayer then
        CharacterAdded(Player)
    end
end

local function NeutralizeLocalPlayer()
    local LastPosition = nil
    local function CheckLocalPlayerFling()
        pcall(function()
            local Character = LocalPlayer.Character
            if Character then
                local PrimaryPart = Character:FindFirstChild("HumanoidRootPart")
                if PrimaryPart then
                    if PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 250 then
                        PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        PrimaryPart.CFrame = LastPosition

                        game.StarterGui:SetCore("ChatMakeSystemMessage", {
                            Text = "You were flung. Neutralizing velocity. Thanks Ashbornn for this.";
                            Color = Color3.fromRGB(195, 115, 255);
                        })
                    else
                        LastPosition = PrimaryPart.CFrame
                    end
                end
            end
        end)
    end

    return Services.RunService.Heartbeat:Connect(CheckLocalPlayerFling)
end



















































        local Toggle = Tabs.LP:AddToggle("AntiFling", {Title = "Anti Fling (You can't fling me)", Default = false })

Toggle:OnChanged(function(enabled)
    AntiFlingEnabled = enabled
    if enabled then
        playerAddedConnection = Services.Players.PlayerAdded:Connect(OnPlayerAdded)
        for _, Player in ipairs(Services.Players:GetPlayers()) do
            if Player ~= LocalPlayer then
                CharacterAdded(Player)
            end
        end
        localHeartbeatConnection = NeutralizeLocalPlayer()
    else
        if playerAddedConnection then
            playerAddedConnection:Disconnect()
            playerAddedConnection = nil
        end
        if localHeartbeatConnection then
            localHeartbeatConnection:Disconnect()
            localHeartbeatConnection = nil
        end
    end
end)

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
            loadstring(game:HttpGet('https://raw.githubusercontent.com/LordRayven/AshbornnHub/main/FlingScript.lua'))()
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


local Toggle = Tabs.LP:AddToggle("Noclip", {Title = "Noclip", Default = false })

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

Tabs.Universal:AddButton({
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

Tabs.Universal:AddButton({
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
                            loadstring(game:HttpGet("https://raw.githubusercontent.com/LordRayven/AshbornnHub/main/ServerHop.lua", true))()
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
    local Dropdown = Tabs.Universal:AddDropdown("ViewPlayerd", {
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

Tabs.Universal:AddButton({
    Title = "Stop Viewing",
    Description = "Stop viewing the selected player",
    Callback = function()
        workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
    end
})

local Dropdown
local isResetting = false

local function CreateDropdownC()
    Dropdown = Tabs.Universal:AddDropdown("TPtoPlayer", {
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
    
Tabs.LP:AddButton({
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

if _G.cons then
    for _, v in pairs(_G.cons) do
        v:Disconnect()
    end

    _G.cons = nil
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

            local newcf = oldcf * CFrame.new(-1500, -5000, -1500)

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

local Toggle = Tabs.LP:AddToggle("FEInvisible", {Title = "FE Invisible", Default = false })

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


local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Slider for WalkSpeed
local WalkSpeedSlider = Tabs.LP:AddSlider("WalkSpeedSlider", {
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
local JumpPowerSlider = Tabs.LP:AddSlider("JumpPowerSlider", {
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





























    


    Tabs.Universal:AddParagraph({
        Title = "",
        Content = ""
    }) 
    Tabs.Universal:AddParagraph({
        Title = "",
        Content = ""
    }) Tabs.Universal:AddParagraph({
        Title = "",
        Content = ""
    }) Tabs.Universal:AddParagraph({
        Title = "",
        Content = ""
    }) Tabs.Universal:AddParagraph({
        Title = "",
        Content = ""
    }) Tabs.Universal:AddParagraph({
        Title = "",
        Content = ""
    }) Tabs.Universal:AddParagraph({
        Title = "",
        Content = ""
    }) Tabs.Universal:AddParagraph({
        Title = "",
        Content = ""
    }) Tabs.Universal:AddParagraph({
        Title = "",
        Content = ""
    }) Tabs.Universal:AddParagraph({
        Title = "",
        Content = ""
    }) 



    Tabs.Universal:AddButton({
        Title = "Button",
        Description = "Very important button",
        Callback = function()
            Window:Dialog({
                Title = "Title",
                Content = "This is a dialog",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            print("Confirmed the dialog.")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Cancelled the dialog.")
                        end
                    }
                }
            })
        end
    })



    

    local Input = Tabs.Universal:AddInput("Input", {
        Title = "Input",
        Default = "Default",
        Placeholder = "Placeholder",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(Value)
            print("Input changed:", Value)
        end
    })

    Input:OnChanged(function()
        print("Input updated:", Input.Value)
    end)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end


-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("AshbornnHub")
SaveManager:SetFolder("AshbornnHub/Universal")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Ashborrn Universal",
    Content = "Has been loaded Enjoy.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
