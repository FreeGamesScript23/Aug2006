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
local UserInputService = game:GetService("UserInputService")
local virtualInput = game:GetService("VirtualInputManager")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")

local Window = Fluent:CreateWindow({
    Title = "AshbornnHub ",
    SubTitle = "Fisch",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
        Main = Window:AddTab({ Title = "Main", Icon = "box" }),
        Fish = Window:AddTab({ Title = "Fishing", Icon = "waves" }),
        Teleport = Window:AddTab({ Title = "Locations", Icon = "map-pin" }),
        Misc = Window:AddTab({ Title = "Misc", Icon = "aperture" }),
        Server = Window:AddTab({ Title = "Server", Icon = "server" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

function SendNotif(title, content, time)
    Fluent:Notify({
            Title = title,
            Content = content,
            Duration = time
    })
    end

local Options = Fluent.Options

do

    function TeleportToPlayer(playerName)
        local targetPlayer = game.Players:FindFirstChild(playerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
        end
end

function GetOtherPlayers()
        local players = {}
        for _, Player in ipairs(game.Players:GetPlayers()) do
            if Player ~= game.Players.LocalPlayer then
                table.insert(players, Player.Name)
            end
        end
        return players
end

function TeleportPlayer(Position, Offset)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait() 
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if rootPart then
        rootPart.CFrame = Position * Offset
        print("Teleported to position:", Position)
    else
        warn("HumanoidRootPart not found.")
    end
end


    --------------------------------------------------------------------------------FISH------------------------------------------------------------------------------------------

        
local discord = "https://discord.com/invite/nzXkxej9wa"


Tabs.Main:AddButton({
            Title = "Infinite Yield",
            Description = "Best script for all games",
            Callback = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
            end
        })
        
        
Tabs.Main:AddButton({
        Title = "Copy Discord Invite (for updates)",
        Callback = function()
            setclipboard(discord)
        end
})
        
Tabs.Main:AddButton({
        Title = "Respawn",
        Callback = function()
            LocalPlayer.Character:WaitForChild("Humanoid").Health = 0
            wait()
        end
})

Tabs.Main:AddButton({
        Title = "Open Console",
        Callback = function()
            game.StarterGui:SetCore("DevConsoleVisible", true)
            wait()
        end
})

Tabs.Main:AddButton({
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
        
--------------------------------------------------------------------------------MAIN------------------------------------------------------------------------------------------


-- Auto Click SHAKE button using VirtualInputManager
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local GuiService = game:GetService("GuiService")
local virtualInput = game:GetService("VirtualInputManager")
local isAutoClicking = false

local function click_this_gui(to_click: GuiObject, offsetX, offsetY)
    if not iswindowactive() then
        repeat task.wait() until iswindowactive()
    end

    local inset = GuiService:GetGuiInset()

    local absoluteSize = to_click.AbsoluteSize
    local offset = {
        x = absoluteSize.X / 2,
        y = absoluteSize.Y / 2
    }

    local x = to_click.AbsolutePosition.X + offset.x + offsetX -- Add horizontal offset
    local y = to_click.AbsolutePosition.Y + offset.y + offsetY -- Add vertical offset

    virtualInput:SendMouseButtonEvent(x + inset.X, y + inset.Y, 0, true, game, 0)
    virtualInput:SendMouseButtonEvent(x + inset.X, y + inset.Y, 0, false, game, 0)
end

local function autoClick()
    local shakeUI = playerGui:FindFirstChild("shakeui")
    
    if not shakeUI then
        return
    end

    local button = shakeUI.safezone and shakeUI.safezone:FindFirstChild("button")
    
    if not button then
        return
    end
  
    if button and button:IsA("ImageButton") and isAutoClicking then
        -- Define the offsets (adjust these values as necessary)
        local offsetX = 5  -- Move 5 pixels to the right
        local offsetY = 0  -- No vertical adjustment

        -- Directly click the button using the defined function with offsets
        click_this_gui(button, offsetX, offsetY)
    end
end

-- Set up the Auto Shake toggle
local Toggle = Tabs.Fish:AddToggle("AutoShake", {Title = "Auto Shake", Default = false})

local autoClickCoroutine

Toggle:OnChanged(function(value)
   isAutoClicking = value
    if value then
        autoClickCoroutine = coroutine.create(function()
            while isAutoClicking do
                autoClick()
                task.wait() -- Adjust the wait time if necessary
            end
        end)
        coroutine.resume(autoClickCoroutine)
    else
        isAutoClicking = false
        if autoClickCoroutine then
            autoClickCoroutine = nil
        end
    end
end)

Options.AutoShake:SetValue(false)

-- Reel GUI Path
local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService") 
local isAutoCatch = false

local Toggle = Tabs.Fish:AddToggle("AutoCatch", {Title = "Instant Perfect Catch", Default = false })

 

Toggle:OnChanged(function(value)
    isAutoCatch = value
end)

Toggle:SetValue(false) 

function startCatching()
    local reelBar = player.PlayerGui:FindFirstChild("reel") and player.PlayerGui.reel:FindFirstChild("bar")
    if reelBar == nil then
        return
    end
    if reelBar and isAutoCatch then
        game:GetService("ReplicatedStorage").events.reelfinished:FireServer(100, true)
    end
end

runService.RenderStepped:Connect(startCatching)


-- Auto Cast 
local isAutoCasting = false 
local runService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer

local function isRodEquipped()
    -- Check if the rod is equipped
    if player.Character then
        return player.Character:FindFirstChildWhichIsA("Tool") and player.Character:FindFirstChildWhichIsA("Tool").Name:lower():find("rod")
    end
    return false
end

local function equipRod()
    local backpack = player.Backpack

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and string.find(tool.Name:lower(), "rod", 1, true) then
            -- Equip the tool if it's not already equipped
            if player.Character and player.Character:FindFirstChild(tool.Name) == nil then
                player.Character.Humanoid:EquipTool(tool)
            end
            return tool -- Return the equipped tool
        end
    end
    return nil -- No rod tool was found to equip
end

local function reelCasting()
    if reelBar then
        return
    end

    if isAutoCasting then
        -- Check if the rod is equipped; if not, equip it
        local equippedTool = nil
        if not isRodEquipped() then
            equippedTool = equipRod()
        else
            -- If the rod is already equipped, find it directly
            equippedTool = player.Character:FindFirstChildWhichIsA("Tool")
        end

        -- Proceed with casting regardless of whether we just equipped it or it was already equipped
        if equippedTool then
            local castEvent = equippedTool:FindFirstChild("events") and equippedTool.events:FindFirstChild("cast")
            local resetEvent = equippedTool:FindFirstChild("events") and equippedTool.events:FindFirstChild("reset")
            if castEvent and not button then
                castEvent:FireServer(100, 1) -- Fire the casting event with the equipped tool
               else
                resetEvent:FireServer()
            end
        end
    end
end

local Toggle = Tabs.Fish:AddToggle("AutoCast", {Title = "Auto Reel Cast", Default = false})
local bodyPosition

Toggle:OnChanged(function(value)
    isAutoCasting = value

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    if isAutoCasting then
        -- Store the character's current position
        local lockedPosition = rootPart.Position

        -- Create a BodyPosition to hold the character in place
        bodyPosition = Instance.new("BodyPosition")
        bodyPosition.Position = lockedPosition
        bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)  -- Infinite force to lock position
        bodyPosition.D = 1000  -- High damping to prevent drifting
        bodyPosition.P = 10000 -- Strong force to maintain position
        bodyPosition.Parent = rootPart
    else
        -- Remove BodyPosition to unlock the character's position
        if bodyPosition then
            bodyPosition:Destroy()
            bodyPosition = nil
        end
    end
end)

Options.AutoCast:SetValue(false)

runService.RenderStepped:Connect(reelCasting)


-- Auto Center SHAKE button
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local runService = game:GetService("RunService")

local isAutoShake = false

local Toggle = Tabs.Fish:AddToggle("CenterShake", {Title = "Always Center Shake", Default = false })

Toggle:OnChanged(function(value)
    isAutoShake = value
end)

Options.CenterShake:SetValue(false)

local function centerButton()
    local shakeUI = playerGui:FindFirstChild("shakeui")
    
    if not shakeUI then
        return
    end

    local button = shakeUI.safezone and shakeUI.safezone:FindFirstChild("button")
    
    if not button then
        return
    end

    if isAutoShake then
        if button:IsA("ImageButton") then
            button.AnchorPoint = Vector2.new(0.5, 0.5)
            button.Position = UDim2.new(0.5, 0, 0.5, 0)
            button.Size = UDim2.new(0, 100, 0, 100)
        end
    end
end

runService.RenderStepped:Connect(centerButton)




local EventsSection = Tabs.Fish:AddSection("Notifier")

local Toggle = Tabs.Fish:AddToggle("EventPool", {Title = "Frightful Pool Notifier", Default = false})
local FischFrightPath = workspace.zones.fishing:FindFirstChild("FischFright24")
local notified = false

Toggle:OnChanged(function(value)
    -- This function triggers when the toggle is changed
    if value then
        -- Start listening for FischFright24's existence if the toggle is on
        game:GetService("RunService").Heartbeat:Connect(function()
            -- Continuously check if the toggle is on and FischFright24 exists
            if Toggle.Value then
                local FischFrightExists = workspace.zones.fishing:FindFirstChild("FischFright24")
                
                if FischFrightExists and not notified then
                    -- If FischFright24 exists and has not been notified, send notification
                    SendNotif("Event", "Frightful Pool has appear!! Hurry!!", 10)
                    notified = true
                elseif not FischFrightExists then
                    -- Reset notification status when FischFright24 is not present
                    notified = false
                end
            end
        end)
    else
        -- Reset notified if the toggle is off
        notified = false
    end
end)

Options.EventPool:SetValue(false)

    local AshbornNig = Tabs.Fish:AddSection("Fully developed script by Ashbornn(Rayven)")
    
    --------------------------------------------------------------------------------FISH------------------------------------------------------------------------------------------







--------------------------------------------------------------------------------TELEPORT------------------------------------------------------------------------------------------
local Locations = {
    ["Desolate Deep"] = CFrame.new(-1659, -214, -2847),
    ["Sunstone"] = CFrame.new(-918, 135, -1123),
    ["Statue of Sovereignty"] = CFrame.new(26, 159, -1037),
    ["The Arch"] = CFrame.new(988, 131, -1238),
    ["MushGrove Swamp"] = CFrame.new(2438, 132, -689),
    ["Snowcap"] = CFrame.new(2618, 146, 2402),
    ["Terrapin"] = CFrame.new(-189, 143, 1926),
    ["Roslit"] = CFrame.new(-1482, 138, 738),
    ["MooseWood"] = CFrame.new(384, 134, 232)
}

local subLocations = {
    ["Roslit Volcano"] = CFrame.new(-1907, 165, 316),
    ["Brinepool"] = CFrame.new(-1794, -143, -3315),
    ["Desolate Shop"] = CFrame.new(-994, -245, -2723),
    ["Enchant Altar"] = CFrame.new(1312, -802, -87)
}

local NPCLocations = {
    ["Appraiser"] = CFrame.new(444, 151, 210),
    ["Witch (Event Pot)"] = CFrame.new(405, 135, 317),
    ["Merchant MW"] = CFrame.new(467, 151, 231),
    ["Merlin (Relic Seller)"] = CFrame.new(-932, 224, -988)
}

local subLocationsNames = {}
for name in pairs(subLocations) do
    table.insert(subLocationsNames, name)
end

local LocationNames = {}
for name in pairs(Locations) do
    table.insert(LocationNames, name)
end

local Dropdown = Tabs.Teleport:AddDropdown("TPLocation", {
    Title = "Teleport to Location",
    Values = LocationNames,
    Multi = false,
    Default = "Select Location",
})

Tabs.Teleport:AddButton({
    Title = "Teleport to selected location",
    Description = "",
    Callback = function()
    local selectedLocation = Dropdown.Value
    local PositionLoc = Locations[selectedLocation]
    if PositionLoc then
        TeleportPlayer(PositionLoc, CFrame.new(0, 0, 0)) -- Adjust Offset if needed
    else 
        warn("Invalid location selected.")
    end
            end
        })
      
      local space = Tabs.Teleport:AddSection("")

local SubLocationsDD = Tabs.Teleport:AddDropdown("TPSubLocation", {
    Title = "Teleport to Sub-location",
    Values = subLocationsNames,
    Multi = false,
    Default = "Select Sub Location",
})

Tabs.Teleport:AddButton({
    Title = "Teleport to selected Sub-location",
    Description = "",
    Callback = function()
    local selectedSub = SubLocationsDD.Value
    local Position = subLocations[selectedSub]
    if Position then
        TeleportPlayer(Position, CFrame.new(0, 0, 0)) -- Adjust Offset if needed
    else
        warn("Invalid location selected.")
    end
    end
 })
        
     local space = Tabs.Teleport:AddSection("")

Dropdown:OnChanged(function(Value)
    local PositionLoc = Locations[Value]
    if PositionLoc then
        TeleportPlayer(PositionLoc, CFrame.new(0, 0, 0)) -- Adjust Offset if needed
    else 
        warn("Invalid location selected.")
    end
end)

SubLocationsDD:OnChanged(function(Value)
    local Position = subLocations[Value]
    if Position then
        TeleportPlayer(Position, CFrame.new(0, 0, 0)) -- Adjust Offset if needed
    else
        warn("Invalid location selected.")
    end
end)


local NPCNames = {}
for name in pairs(NPCLocations) do
    table.insert(NPCNames, name)
end



local NPCDrop = Tabs.Teleport:AddDropdown("TPLocation", {
    Title = "Teleport to NPC",
    Values = NPCNames,
    Multi = false,
    Default = "Select NPC",
})

NPCDrop:OnChanged(function(Value)
    local Position = NPCLocations[Value]
    if Position then
        TeleportPlayer(Position, CFrame.new(0, 0, 0)) -- Adjust Offset if needed
    else
        warn("Invalid location selected.")
    end
end)

Tabs.Teleport:AddButton({
    Title = "Teleport to selected NPC",
    Description = "",
    Callback = function()
    local selectedNPC = NPCDrop.Value
    local Position = NPCLocations[selectedNPC]
    if Position then
        TeleportPlayer(Position, CFrame.new(0, 0, 0)) -- Adjust Offset if needed
    else
        warn("Invalid location selected.")
    end
    end
 })


function TPFrightPool()
        local targetZone = workspace:FindFirstChild("zones") and workspace.zones:FindFirstChild("fishing") and workspace.zones.fishing:FindFirstChild("FischFright24")
        
        if targetZone then
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                
                if humanoidRootPart then
                    humanoidRootPart.CFrame = targetZone.CFrame * CFrame.new(0, 50, 0)
                    SendNotif("AshbornnHub", "Sucessfully Teleported", 1)
                else
                    warn("HumanoidRootPart not found.")
                end
            else
                warn("Player character not available.")
            end
        else
            SendNotif("AshbornnHub", "Frightful Pool is not available", 2)
        end
end

Tabs.Teleport:AddButton({
    Title = "Teleport to Frightful Pool",
    Description = "Teleport above Frightful Pool if available",
    Callback = function()
        TPFrightPool()
    end
})

--------------------------------------------------------------------------------TELEPORT------------------------------------------------------------------------------------------







--------------------------------------------------------------------------------MISC------------------------------------------------------------------------------------------

local Toggle = Tabs.Misc:AddToggle("FishingCollide", {Title = "Water Walk", Default = false})

-- Function to update CanCollide property based on toggle
local function updateCanCollide(value)
    local fishingZone = workspace:FindFirstChild("zones"):FindFirstChild("fishing")
    if fishingZone then
        for _, descendant in ipairs(fishingZone:GetDescendants()) do
            if descendant:IsA("Part") then
                descendant.CanCollide = value
            end
        end
    end
end


Toggle:OnChanged(function(value)
    updateCanCollide(value)
end)

Options.FishingCollide:SetValue(false)

Tabs.Misc:AddButton({
    Title = "Unlimited Oxygen",
    Description = "Cannot be undone unless rejoining.",
    Callback = function()
        local playerName = game.Players.LocalPlayer.Name
        
        local oxygenLimiterPath = workspace:FindFirstChild(playerName)
        
        if oxygenLimiterPath then
            local client = oxygenLimiterPath:FindFirstChild("client")
            
            if client then
                local oxygen = client:FindFirstChild("oxygen")
                
                if oxygen then
                    oxygen:Destroy()
                    SendNotif("AshbornnHub", "Oxygen is now unlimited", 2)
                else
                    
                end
            else
                
            end
        else
            
        end
    end
})

--------------------------------------------------------------------------------MISC--------------------------------------------------------------------------------------




------------------------------------------------------------------------SERVER----------------------------------------------------------------------------
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
            task.wait()
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
                                loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/ServerHop.lua", true))()
            task.wait()
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
    
------------------------------------------------------------------------SERVER--------------------------------------------------------------------------
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end
        
-- Create a ScreenGui object to hold the button
local gui = Instance.new("ScreenGui")
gui.Name = "Gui"
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
                description = "Hi " .. LocalPlayer.Name .. " Send a Feedback! in " .. Ash_Device,
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
        SendNotif("Feedback has been sent to Ashbornn", "Thank you", 3)
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

InterfaceManager:SetFolder("")
SaveManager:SetFolder("/Fisch")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()

local TimeEnd = tick()
local TotalTime = string.format("%.2f", math.abs(TimeStart - TimeEnd))
SendNotif("Hub", "Successfully loaded the script in " .. TotalTime .. "s.", 3)
