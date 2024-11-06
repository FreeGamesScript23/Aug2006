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
    Size = UDim2.fromOffset(580, 350),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
        Main = Window:AddTab({ Title = "Main", Icon = "box" }),
        Fish = Window:AddTab({ Title = "Fishing", Icon = "waves" }),
        Purchase = Window:AddTab({ Title = "Auto Buy", Icon = "shopping-cart"}),
        Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
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
        
    else
        
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
local tappingMethod = "Cursor" -- Default tapping method

local function click_this_gui(to_click: GuiObject, offsetX, offsetY)

    -- Check if to_click is valid and visible
    if to_click and to_click:IsA("GuiObject") and to_click.Visible then
        local inset = GuiService:GetGuiInset()
        local absoluteSize = to_click.AbsoluteSize
        local offset = { x = absoluteSize.X / 2, y = absoluteSize.Y / 2 }

        local x = to_click.AbsolutePosition.X + offset.x + offsetX
        local y = to_click.AbsolutePosition.Y + offset.y + offsetY
        -- Use selected tapping method
        if tappingMethod == "Cursor" then
            virtualInput:SendMouseButtonEvent(x + inset.X, y + inset.Y, 0, true, player.PlayerGui, 1)  -- Mouse down
            virtualInput:SendMouseButtonEvent(x + inset.X, y + inset.Y, 0, false, player.PlayerGui, 1) -- Mouse up
        elseif tappingMethod == "UI Nav" then
            GuiService.SelectedObject = to_click    
            -- Check if the SelectedObject is still to_click before sending the key events
            if GuiService.SelectedObject == to_click then
                virtualInput:SendKeyEvent(true, Enum.KeyCode.Return, false, game)  -- Key down
                virtualInput:SendKeyEvent(false, Enum.KeyCode.Return, false, game) -- Key up
            end
        end
    else
        warn("-- Unable to click, to_click is not valid or not visible.")
    end
end


local function autoClick()
    local shakeUI = playerGui:FindFirstChild("shakeui")
    if not shakeUI then return end

    local button = shakeUI.safezone and shakeUI.safezone:FindFirstChild("button")
    if not button then return end
  
    if button:IsA("ImageButton") and isAutoClicking then
        local offsetX, offsetY = 6, 0
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
                task.wait(0.1)  -- Adjust to control click frequency
            end
        end)
        coroutine.resume(autoClickCoroutine)
    else
        isAutoClicking = false
        if autoClickCoroutine then
            autoClickCoroutine = nil  -- Clean up coroutine
        end
    end
end)

Options.AutoShake:SetValue(false)

-- Dropdown for selecting tapping method
local Dropdown = Tabs.Fish:AddDropdown("ShakeTap", {
    Title = "Shake tapping method",
    Values = {"UI Nav", "Cursor"},
    Multi = false,
    Default = "Cursor",
})

Dropdown:OnChanged(function(value)
    tappingMethod = value
end)

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
    
    if player.Character then
        return player.Character:FindFirstChildWhichIsA("Tool") and player.Character:FindFirstChildWhichIsA("Tool").Name:lower():find("rod")
    end
    return false
end

local function equipRod()
    local backpack = player.Backpack

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and string.find(tool.Name:lower(), "rod", 1, true) then
            
            if player.Character and player.Character:FindFirstChild(tool.Name) == nil then
                player.Character.Humanoid:EquipTool(tool)
            end
            return tool 
        end
    end
    return nil 
end

local function reelCasting()
    if reelBar then
        return
    end

    if isAutoCasting then
        
        local equippedTool = nil
        if not isRodEquipped() then
            equippedTool = equipRod()
        else
            
            equippedTool = player.Character:FindFirstChildWhichIsA("Tool")
        end

        
        if equippedTool then
            local castEvent = equippedTool:FindFirstChild("events") and equippedTool.events:FindFirstChild("cast")
            local resetEvent = equippedTool:FindFirstChild("events") and equippedTool.events:FindFirstChild("reset")
            if castEvent and not button then
                castEvent:FireServer(100, 1)
               else
                resetEvent:FireServer()
            end
        end
    end
end

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

local Toggle = Tabs.Fish:AddToggle("AutoCast", {Title = "Auto Reel Cast", Default = false})

local notificationSent = false

Toggle:OnChanged(function(value)
    isAutoCasting = value -- Do not remove and redeclare this 

    if value then
        if not notificationSent and ZoneCasting then
            SendNotif("Auto Casting Notify", "If camera error or being weird just tap the screen to fix it", 5)
            notificationSent = true 
        end
        
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0

        local originalCFrame = rootPart.CFrame
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if isAutoCasting then
                
                rootPart.CFrame = CFrame.new(originalCFrame.Position, originalCFrame.Position + originalCFrame.LookVector)
            else
                humanoid.WalkSpeed = 16 
                humanoid.JumpPower = 50  
                connection:Disconnect()
                notificationSent = false 
            end
        end)
    else
        humanoid.WalkSpeed = 16 
        humanoid.JumpPower = 50  
        notificationSent = false 
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

local WaterZoneNames = {}


-- Dropdown for selecting WaterZone
local Dropdown = Tabs.Fish:AddDropdown("WaterZone", {
    Title = "Select location to Fish",
    Values = WaterZoneNames,
    Multi = false,
    Default = "",
})

local selectedZone = nil
Dropdown:OnChanged(function(value)
    selectedZone = workspace.zones.fishing:FindFirstChild(value)
end)


-- Function to refresh WaterZoneNames with unique zones
local function refreshWaterZoneNames()
    -- Clear the existing WaterZoneNames
    WaterZoneNames = {}

    -- Populate WaterZoneNames with unique zones
    local uniqueZones = {}
    for _, zone in ipairs(workspace.zones.fishing:GetChildren()) do
        if not uniqueZones[zone.Name] then
            table.insert(WaterZoneNames, zone.Name)
            uniqueZones[zone.Name] = true
        end
    end

    -- Update the dropdown values
    Dropdown:SetValues(WaterZoneNames)
end

-- Initial call to populate the dropdown
refreshWaterZoneNames()

-- Connect to events for dynamic updates
workspace.zones.fishing.ChildAdded:Connect(refreshWaterZoneNames)
workspace.zones.fishing.ChildRemoved:Connect(refreshWaterZoneNames)

-- Toggle for ZoneFishing
local Toggle = Tabs.Fish:AddToggle("ZoneFishing", {Title = "Enable long distance fishing", Default = false})

-- Variable to store the RenderStepped connection
local renderSteppedConnection

Toggle:OnChanged(function(value)
    ZoneCasting = value
    if value then
        -- Start RenderStepped to manage the bobber
        renderSteppedConnection = game:GetService("RunService").RenderStepped:Connect(function()
            local playerTool = player.Character and player.Character:FindFirstChildWhichIsA("Tool")
            if playerTool then
                local bobber = playerTool:FindFirstChild("bobber")
                if bobber then
                    local ropeConstraint = bobber:FindFirstChild("RopeConstraint")
                    if ropeConstraint then
                        -- Set the rope length
                        ropeConstraint.Length = 999999999999
                        -- Wait for 0.1 seconds before teleporting
                        wait(0.5)
                        -- Teleport the bobber to the center of the selected zone
                        if selectedZone then
                            local centerPosition = selectedZone.Position
                            bobber.Position = centerPosition + Vector3.new(0, 0, 0)
                            wait(1)
                            ropeConstraint.Enabled = false
                        end
                    end
                end
            end
        end)
    else
        -- Disconnect RenderStepped when toggle is turned off
        if renderSteppedConnection then
            renderSteppedConnection:Disconnect()
            renderSteppedConnection = nil
        end
    end
end)



-- Set the default toggle value
Options.ZoneFishing:SetValue(false)

Tabs.Fish:AddButton({
    Title = "Teleport to Safe Zone Fishing",
    Description = "Use this if you don't want to get caught long distance fishing lol",
    Callback = function()
        -- Create a new part
        local newPart = Instance.new("Part")
        newPart.Size = Vector3.new(10, 1, 10) -- Set the size to 10x1x10
        newPart.Position = Vector3.new(-657, 1224, -50) -- Set the position to the specified coordinates
        newPart.Anchored = true -- Prevents the part from falling
        
        -- Set the color to Dark Purple
        newPart.BrickColor = BrickColor.new("Dark purple") -- Or use a specific RGB color
        
        newPart.Parent = workspace -- Parent the part to the Workspace
        
        -- Teleport the player to the top of the new part
        local player = game.Players.LocalPlayer -- Get the local player
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Calculate the position to teleport to (top of the part)
            local teleportPosition = newPart.Position + Vector3.new(0, newPart.Size.Y / 2, 0)
            player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        end
    end
})


local EventsSection = Tabs.Fish:AddSection("Rod")

local player = game:GetService("Players").LocalPlayer
local playerGui = player.PlayerGui
local rodsContainer = playerGui.hud.safezone.equipment.rods.scroll.safezone
local virtualInput = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

local Dropdown = Tabs.Fish:AddDropdown("equipRod", {
    Title = "Equip Rod",
    Values = {},
    Multi = false,
    Default = "",
})

local rodNames = {}
for _, frame in pairs(rodsContainer:GetChildren()) do
    if frame:IsA("Frame") and frame.Name:find("Rod") then
        table.insert(rodNames, frame.Name)
    end
end

Dropdown:SetValues(rodNames)


Tabs.Fish:AddButton({
    Title = "Equip selected Rod",
    Description = "Equipping the selected Rod in the Equip Rod dropdown",
    Callback = function()
        local selectedRodName = Dropdown.Value
        local equipmentBag = player.Backpack:FindFirstChild("Equipment") or player.Backpack:FindFirstChild("Equipment Bag")

        if not selectedRodName or not rodsContainer:FindFirstChild(selectedRodName) then
            return
        end

        if not equipmentBag then
            return
        end

        -- Check and disable AutoCast if it's enabled
        local wasAutoCastEnabled = Options.AutoCast.Value
        if wasAutoCastEnabled then
            Options.AutoCast:SetValue(false)
        end

        -- Equip the Equipment Bag first
        player.Character.Humanoid:EquipTool(equipmentBag)

        local equipRodButton = rodsContainer[selectedRodName]:FindFirstChild("equip")
        if not equipRodButton or not equipRodButton:IsA("TextButton") then
            
            return
        end
        wait(1)  -- Wait before setting SelectedObject
        GuiService.SelectedObject = equipRodButton

        if GuiService.SelectedObject == equipRodButton then
            virtualInput:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            virtualInput:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            
            -- Unequip the Equipment Bag after using it
            player.Character.Humanoid:UnequipTools() -- This will unequip the Equipment Bag
            task.wait(0.5)
           GuiService.SelectedObject = nil
            wait(1)  -- Wait to ensure Equipment Bag is unequipped

            -- Equip the rod after unequipping
            local rodTool = player.Backpack:FindFirstChildWhichIsA("Tool") -- Find the first tool in the backpack
            if rodTool and rodTool.Name:find("Rod") then
                player.Character.Humanoid:EquipTool(rodTool)
            else
                
            end
        else
            
        end
          
        -- Re-enable AutoCast if it was enabled before
        if wasAutoCastEnabled then
            Options.AutoCast:SetValue(true)
        end

    end
})






local CrabRelated = Tabs.Fish:AddSection("Crab")

local Toggle = Tabs.Fish:AddToggle("AutoPlace", {Title = "Auto Place Crab Cage", Default = false})

-- This function equips the Crab Cage only if it’s not already equipped
local function equipCrabCage()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local backpack = player.Backpack
    local crabCage = character:FindFirstChild("Crab Cage") or backpack:FindFirstChild("Crab Cage")

    -- Equip Crab Cage only if it's in the backpack (not already equipped)
    if crabCage and crabCage.Parent == backpack then
        crabCage.Parent = character
    end

    return character:FindFirstChild("Crab Cage")
end

local autoPlaceConnection

Toggle:OnChanged(function(value)
    if value then
        -- Activate auto-deploy loop
        autoPlaceConnection = game:GetService("RunService").RenderStepped:Connect(function()
            local crabCage = equipCrabCage()
            if crabCage and crabCage:FindFirstChild("Deploy") then
                crabCage.Deploy:FireServer() -- Trigger Deploy event using FireServer
            else
                SendNotif("Auto Place Crab Cage", "No more crab cage available turning off toggle", 4)
                Options.AutoPlace:SetValue(false) -- Turn off the toggle automatically
            end
        end)
    else
        -- Disconnect loop when toggled off
        if autoPlaceConnection then
            autoPlaceConnection:Disconnect()
            autoPlaceConnection = nil
        end
    end
end)


local Toggle = Tabs.Fish:AddToggle("CollectCrab", {Title = "Auto Collect Crab Cage", Default = false})

local connection -- Variable to hold the connection
local warnIssued = false -- Flag to prevent warning spam

Toggle:OnChanged(function(value)
    if value then
        -- Reset warning flag when toggled on
        warnIssued = false

        -- Use RenderStepped to sync with the frame rate
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            local player = game.Players.LocalPlayer
            local cageObject = workspace.active:FindFirstChild(player.Name)
            
            -- Early exit with a single warning if cageObject doesn't exist
            if not cageObject then
                if not warnIssued then
                    warnIssued = true -- Set flag to avoid repeated warnings
                end
                return
            end
            
            -- Cache references for performance
            local cage = cageObject:FindFirstChild("Cage")
            local prompt = cageObject:FindFirstChild("Prompt")
            local innerCage = cage and cage:FindFirstChild("cage")
            
            -- Early exit with a single warning if any required component is missing
            if not cage or not prompt or not innerCage then
                if not warnIssued then
                    warnIssued = true -- Set flag to avoid repeated warnings
                end
                return
            end
            
            -- Only proceed if prompt is enabled
            if prompt.Enabled then
                local character = player.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                
                -- Teleport only if rootPart is available
                if rootPart then
                    rootPart.CFrame = innerCage.CFrame -- Teleport to the cage
                    fireproximityprompt(prompt, 1, true) -- Trigger proximity prompt
                end
                -- Reset warning flag after successful interaction
                warnIssued = false
            end
        end)
    else
        -- Disconnect when toggled off
        if connection then
            connection:Disconnect()
            connection = nil 
        end
        warnIssued = false -- Reset the flag when toggling off
    end
end)

Options.CollectCrab:SetValue(false) -- Reset the toggle state

local Sells = Tabs.Fish:AddSection("Sell")

-- Function to find the first NPC with "Merchant" in its name
local function getMerchant()
    for _, npc in ipairs(workspace.world.npcs:GetChildren()) do
        if npc.Name:find("Merchant") and npc:FindFirstChild("merchant") then
            return npc
        end
    end
    return nil -- Return nil if no "Merchant" NPC is found
end

Tabs.Fish:AddButton({
    Title = "Sell Equipped Fish",
    Description = "Please equip a fish to sell just like in Merchant",
    Callback = function()
        Window:Dialog({
            Title = "Sell Equipped Fish?",
            Content = "Do you want to sell this fish?",
            Buttons = {
                {
                    Title = "Yes!",
                    Callback = function()
                        local merchant = getMerchant()
                        if merchant then
                            local success, err = pcall(function()
                                merchant.merchant.sell:InvokeServer() -- Sell Equipped Fish
                            end)

                            if not success then
                                SendNotif("Sell Equipped Fish Notify", "No merchant found nearby.", 3)
                            end
                        else
                            
                        end
                    end
                },
                {
                    Title = "Nuhh Uhh",
                    Callback = function()
                        -- Optional: Code for this button
                    end
                }
            }
        })
    end
})

Tabs.Fish:AddButton({
    Title = "Sell All Fish",
    Description = "Selling all fish in your inventory like Merchant",
    Callback = function()
        Window:Dialog({
            Title = "Sell all your fish??",
            Content = "Do you really want to sell them all??",
            Buttons = {
                {
                    Title = "Yes!",
                    Callback = function()
                        local merchant = getMerchant()
                        if merchant then
                            local success, err = pcall(function()
                                merchant.merchant.sellall:InvokeServer() -- Sell All Inventory
                            end)

                            if not success then
                                SendNotif("This only works if near a merchant.")
                            end
                        else
                            SendNotif("Sell All Notify", "No merchant found nearby.", 3)
                        end
                    end
                },
                {
                    Title = "Nuhh Uhh",
                    Callback = function()
                        -- Optional: Code for this button
                    end
                }
            }
        })
    end
})

Tabs.Fish:AddButton({
            Title = "Appraise Equipped Fish",
            Description = "Appraising your equipped fish",
            Callback = function()
                Window:Dialog({
                    Title = "Appraise Confirming",
                    Content = "Do you really want to appraise it ??",
                    Buttons = {
                        {
                            Title = "Yes!",
                            Callback = function()
                                workspace.world.npcs.Appraiser.appraiser.appraise:InvokeServer()
                            end
                        },
                        {
                            Title = "Nuh Uhh",
                            Callback = function()
                                
                            end
                        }
                    }
                })
            end
        })
    
    --------------------------------------------------------------------------------FISH------------------------------------------------------------------------------------------


     --------------------------------------------------------------------------------AUTOBUY------------------------------------------------------------------------------------------

     Tabs.Purchase:AddParagraph({
        Title = "IMPORTANT: PLEASE READ BEFORE USE",
        Content = "Auto Buying only works if you're near at the Product or Seller use Teleport also this doesnt auto stop your buying process walk away or untoggle to stop auto buying",
        })

     local Toggle = Tabs.Purchase:AddToggle("AutoBuyBait", {Title = "Auto Buy Bait Crate", Default = false})

     local autoBuyConnection
     
     Toggle:OnChanged(function(value)
         if value then
             -- Activate auto-buy loop
             autoBuyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                 -- Get the first Bait Crate model
                 local firstBaitCrate = workspace.world.interactables["Bait Crate"]
                 local baitCratePrompt = nil
                 
                 -- Iterate through the children of the first Bait Crate model
                 for _, child in pairs(firstBaitCrate:GetChildren()) do
                     if child:IsA("Model") and child:FindFirstChild("purchaserompt") then
                         baitCratePrompt = child.purchaserompt
                         break  -- Stop after finding the first purchaserompt
                     end
                 end
                 
                 if baitCratePrompt then
                     fireproximityprompt(baitCratePrompt, 1, true)
                     
                     -- Check if the confirmation button exists
                     local baitPurchaseButton = game:GetService("Players").LocalPlayer.PlayerGui.over.prompt:FindFirstChild("confirm")
                     if baitPurchaseButton then
                         firesignal(baitPurchaseButton.MouseButton1Click, game.Players.LocalPlayer)  -- Pass LocalPlayer as second argument
                     end
                 end
             end)
         else
             -- Disconnect the loop when toggled off
             if autoBuyConnection then
                 autoBuyConnection:Disconnect()
                 autoBuyConnection = nil
             end
         end
     end)
     
     Options.AutoBuyBait:SetValue(false)

     Tabs.Purchase:AddButton({
        Title = "Teleport to Bait seller",
        Description = "",
        Callback = function()
            TeleportPlayer(CFrame.new(386, 137, 332), CFrame.new(0, 0, 0))
        end
    })



     local Toggle = Tabs.Purchase:AddToggle("AutoBuyCrab", {Title = "Auto Buy Crab Cage", Default = false})

local autoBuyConnection

Toggle:OnChanged(function(value)
    if value then
        -- Activate auto-buy loop
        autoBuyConnection = game:GetService("RunService").RenderStepped:Connect(function()
            -- Get the first Crab Cage model
            local firstCrabCage = workspace.world.interactables["Crab Cage"]
            local crabCagePrompt = nil
            
            -- Iterate through the children of the first Crab Cage model
            for _, child in pairs(firstCrabCage:GetChildren()) do
                if child:IsA("Model") and child:FindFirstChild("purchaserompt") then
                    crabCagePrompt = child.purchaserompt
                    break  -- Stop after finding the first purchaserompt
                end
            end
            
            if crabCagePrompt then
                fireproximityprompt(crabCagePrompt, 1, true)
                
                -- Check if the confirmation button exists
                local crabPurchaseButton = game:GetService("Players").LocalPlayer.PlayerGui.over.prompt:FindFirstChild("confirm")
                if crabPurchaseButton then
                    firesignal(crabPurchaseButton.MouseButton1Click, game.Players.LocalPlayer)  -- Pass LocalPlayer as second argument
                end
            end
        end)
    else
        -- Disconnect the loop when toggled off
        if autoBuyConnection then
            autoBuyConnection:Disconnect()
            autoBuyConnection = nil
        end
    end
end)

Options.AutoBuyCrab:SetValue(false)
-- Assuming TeleportPlayer is a defined function to teleport the player
Tabs.Purchase:AddButton({
    Title = "Teleport to Crab Cage seller",
    Description = "",
    Callback = function()
        local player = game.Players.LocalPlayer
        local cageObject = workspace.active:FindFirstChild(player.Name)

        local cagePosition -- Variable to hold the position to teleport to

        if cageObject then
            local cage = cageObject:FindFirstChild("Cage")
            local innerCage = cage and cage:FindFirstChild("cage")

            -- Check if innerCage exists and get its position
            if innerCage then
                cagePosition = innerCage.Position -- Use position of the inner cage
            end
        end

        -- If cagePosition is not set, use default CrabPos
        if not cagePosition then
            cagePosition = Vector3.new(474, 151, 234) -- Default CrabPos
        end

        -- Teleport the player to the determined position
        TeleportPlayer(CFrame.new(cagePosition), CFrame.new(0, 0, 0))
    end
})

     

      --------------------------------------------------------------------------------AUTOBUY------------------------------------------------------------------------------------------
    







--------------------------------------------------------------------------------TELEPORT------------------------------------------------------------------------------------------
local space = Tabs.Teleport:AddSection("Custom fishing position")

local savedCFrame = nil
local savedWithPart = false
local saveFileName = "AshbornnHub/Fisch/lastPosition.txt"
local spawnedPart = nil

-- Ensure folder exists
if not isfolder("AshbornnHub/Fisch") then
    makefolder("AshbornnHub/Fisch")
end

-- Function to save the position and part flag to a file
local function writePositionToFile(position, withPart)
    if position then
        local rotX, rotY, rotZ = position:ToOrientation()
        local data = {
            X = position.Position.X,
            Y = position.Position.Y,
            Z = position.Position.Z,
            RotX = rotX,
            RotY = rotY,
            RotZ = rotZ,
            WithPart = withPart
        }
        writefile(saveFileName, game.HttpService:JSONEncode(data))
        SendNotif("Teleport Notify", "Position saved successfully.", 2)
    end
end

-- Function to read the position and part flag from a file
local function readPositionFromFile()
    if isfile(saveFileName) then
        local data = game.HttpService:JSONDecode(readfile(saveFileName))
        return CFrame.new(data.X, data.Y, data.Z) * CFrame.Angles(data.RotX, data.RotY, data.RotZ), data.WithPart
    else
        SendNotif("Teleport Notify", "No saved position file found.", 2)
        return nil, false
    end
end

-- Button to save position with a part
Tabs.Teleport:AddButton({
    Title = "Save Position with Part",
    Description = "Saves the player's position and spawns a 10x1x10 part",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        -- Spawn part if it doesn't exist
        if not spawnedPart then
            spawnedPart = Instance.new("Part")
            spawnedPart.Size = Vector3.new(10, 1, 10)
            spawnedPart.Anchored = true
            spawnedPart.Parent = workspace
        end

        -- Position the part under the player's HumanoidRootPart
        spawnedPart.CFrame = character.HumanoidRootPart.CFrame - Vector3.new(0, character.HumanoidRootPart.Size.Y / 2 + 0.5, 0)
        savedCFrame = spawnedPart.CFrame
        savedWithPart = true

        -- Save the part's position and flag
        writePositionToFile(savedCFrame, savedWithPart)
    end
})

-- Button to save position without a part
Tabs.Teleport:AddButton({
    Title = "Save Position without Part",
    Description = "Saves the player's position without spawning a part",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        -- Save only the player's current position
        savedCFrame = character.HumanoidRootPart.CFrame
        savedWithPart = false

        -- Save the position and flag
        writePositionToFile(savedCFrame, savedWithPart)
    end
})

-- Button to teleport to the last saved position
Tabs.Teleport:AddButton({
    Title = "Teleport to Last Saved Position",
    Description = "Teleports the player to the last saved position",
    Callback = function()
        -- Load the saved position and part flag from the file
        local loadedCFrame, loadedWithPart = readPositionFromFile()

        if loadedCFrame then
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()

            -- Check if the position was saved with or without a part
            if loadedWithPart then
                -- Spawn the part if it doesn't already exist
                if not spawnedPart then
                    spawnedPart = Instance.new("Part")
                    spawnedPart.Size = Vector3.new(10, 1, 10)
                    spawnedPart.Anchored = true
                    spawnedPart.Parent = workspace
                end
                spawnedPart.CFrame = loadedCFrame
            else
                -- Remove the part if it was saved without one
                if spawnedPart then
                    spawnedPart:Destroy()
                    spawnedPart = nil
                end
            end

            -- Teleport the player to the saved position
            character.HumanoidRootPart.CFrame = loadedCFrame + Vector3.new(0, character.HumanoidRootPart.Size.Y / 2 + 0.5, 0)

            SendNotif("Teleport Notify", "Teleported to the last saved position", 2)
        else
            SendNotif("Teleport Notify", "No saved position found.", 2)
        end
    end
})

local space = Tabs.Teleport:AddSection("Locations")

local Locations = {
    ["Brinepool"] = CFrame.new(-1794, -143, -3315),
    ["Desolate Deep"] = CFrame.new(-1659, -214, -2847),
    ["Keepers Altar"] = CFrame.new(1297, -805, -298),
    ["MooseWood"] = CFrame.new(384, 134, 232),
    ["Mushgrove Swamp"] = CFrame.new(2438, 132, -689),
    ["Deep Ocean"] = CFrame.new(-4665, 135, 1758),
    ["Roslit"] = CFrame.new(-1482, 138, 738),
    ["Roslit Volcano"] = CFrame.new(-1907, 165, 316),
    ["Snowcap"] = CFrame.new(2618, 146, 2402),
    ["Sunstone"] = CFrame.new(-918, 135, -1123),
    ["Terrapin"] = CFrame.new(-189, 143, 1926),
    ["Vertigo"] = CFrame.new(-117, -515, 1138),
    ["Statue of Sovereignty"] = CFrame.new(26, 159, -1037)
}

local subLocations = {
    ["Desolate Shop"] = CFrame.new(-994, -245, -2723),
    ["Enchant Altar"] = CFrame.new(1312, -802, -87),
    ["Gamma"] = CFrame.new(2231, -792, 1012)
}

local NPCLocations = {
    ["Appraiser"] = CFrame.new(444, 151, 210),
    ["Witch (Event Pot)"] = CFrame.new(405, 135, 317),
    ["Merchant"] = CFrame.new(467, 151, 231),
    ["Merlin (Relic Seller)"] = CFrame.new(-932, 224, -988),
    ["Lantern Guy"] = CFrame.new(-39, -247, 199)
}

local RodLocation = {
    ["Trident Rod(150k)"] = CFrame.new(-1484, -226, -2202),
    ["Kings Rod(120k)"] = CFrame.new(1379, -807, -302),
    ["Magma Rod(need pufferfish)"] = CFrame.new(-1847, 166, 161),
    ["Destiny Rod(190k)"] = CFrame.new(988, 131, -1238),
    ["Nocturnal Rod(11k)"] = CFrame.new(-144, -515, 1142),
    ["Reinforced Rod(20k)"] = CFrame.new(-991, -244, -2693),
    ["Magnet Rod(15k)"] = CFrame.new(-197, 133, 1932),
    ["Carbon Rod(2k)"] = CFrame.new(450, 151, 224),
    ["Steady Rod(7k)"] = CFrame.new(-1511, 142, 762)
}

local TotemLocation = {
    ["Sundial (Day/Night)"] = CFrame.new(-1147, 135, -1074),
    ["Smokescreen (Fog)"] = CFrame.new(2793, 140, -629),
    ["Windset (Windy)"] = CFrame.new(2852, 180, 2703),
    ["Aurora Totem(Luck)"] = CFrame.new(-1811, -137, -3282),
    ["Tempest (Rainy)"] = CFrame.new(36, 135, 1946)
}


--Combining both Names and Value of Names...
local TotemLocationNames = {}
for name in pairs(TotemLocation) do
    table.insert(TotemLocationNames, name)
end

local RodLocationNames = {}
for name in pairs(RodLocation) do
    table.insert(RodLocationNames, name)
end


local RodLocationNames = {}
for name in pairs(RodLocation) do
    table.insert(RodLocationNames, name)
end


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
        TeleportPlayer(PositionLoc, CFrame.new(0, 0, 0)) 
    else 
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
        TeleportPlayer(Position, CFrame.new(0, 0, 0)) 
    else

    end
    end
 })
        
     local space = Tabs.Teleport:AddSection("")


    local spawnedPart = false
Dropdown:OnChanged(function(Value)
 local selectedLocation = Dropdown.Value
    local PositionLoc = Locations[selectedLocation]
    if PositionLoc then
        TeleportPlayer(PositionLoc, CFrame.new(0, 0, 0)) 
    else 

            end

        if Value == "Deep Ocean" and not spawnedPart then 
            local part = Instance.new("Part")
            part.Size = Vector3.new(10, 1, 10) 
            part.Position = Vector3.new(-4665, 131, 1758) 
            part.Anchored = true 
            part.Parent = workspace 
    
            spawnedPart = true 
            TeleportPlayer(Locations[Value], CFrame.new(0, 0, 0))
        else 

        end
    end)
    

SubLocationsDD:OnChanged(function(Value)
    local Position = subLocations[Value]
    if Position then
        TeleportPlayer(Position, CFrame.new(0, 0, 0)) 
    else

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
        TeleportPlayer(Position, CFrame.new(0, 0, 0)) 
    else

    end
end)



Tabs.Teleport:AddButton({
    Title = "Teleport to selected NPC",
    Description = "",
    Callback = function()
    local selectedNPC = NPCDrop.Value
    local Position = NPCLocations[selectedNPC]
    if Position then
        TeleportPlayer(Position, CFrame.new(0, 0, 0)) 
    else

    end
    end
 })

 local space = Tabs.Teleport:AddSection("")

 local RodDD = Tabs.Teleport:AddDropdown("TPRods", {
    Title = "Teleport to Rod Location",
    Values = RodLocationNames,
    Multi = false,
    Default = "Select Rod",
})

RodDD:OnChanged(function(Value)
    local selectedLocation = RodDD.Value
    local RodLoc = RodLocation[selectedLocation]
    if RodLoc then
        TeleportPlayer(RodLoc, CFrame.new(0, 0, 0)) 
    else 

    end
end)

Tabs.Teleport:AddButton({
    Title = "Teleport to selected Rod Location",
    Description = "",
    Callback = function()
    local selectedLocation = RodDD.Value
    local RodLoc = RodLocation[selectedLocation]
    if RodLoc then
        TeleportPlayer(RodLoc, CFrame.new(0, 0, 0)) 
    else 

    end
            end
        })
        
        local space = Tabs.Teleport:AddSection("")
        
      local TotemDD = Tabs.Teleport:AddDropdown("TPTotem", {
    Title = "Teleport to Totem Location",
    Values = TotemLocationNames,
    Multi = false,
    Default = "Select Totem",
})

TotemDD:OnChanged(function(Value)
    local selectedLocation = TotemDD.Value
    local TotemLoc = TotemLocation[selectedLocation]
    if TotemLoc then
        TeleportPlayer(TotemLoc, CFrame.new(0, 0, 0)) 
    else 

    end
end)

Tabs.Teleport:AddButton({
    Title = "Teleport to selected Totem Location",
    Description = "",
    Callback = function()
    local selectedLocation = TotemDDValue
    local TotemLoc = TotemLocation[selectedLocation]
    if TotemLoc then
        TeleportPlayer(TotemLoc, CFrame.new(0, 0, 0)) 
    else 

    end
            end
        })

--------------------------------------------------------------------------------TELEPORT------------------------------------------------------------------------------------------







--------------------------------------------------------------------------------MISC------------------------------------------------------------------------------------------

local Toggle = Tabs.Misc:AddToggle("FishingCollide", {Title = "Water Walk", Default = false})

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

local WannaBeYours = Tabs.Misc:AddSection("Character Misc")

local LocalPlayer = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local velocityHandlerName = "VelocityHandler"
local gyroHandlerName = "GyroHandler"
local flySpeed = 1 -- Default fly speed

-- Fly speed input
Tabs.Misc:AddInput("FlySpeed", {
    Title = "Change Fly Speed",
    Default = "1",
    Placeholder = "Enter Fly Speed",
    Numeric = true, 
    Finished = true, 
    Callback = function(Value)
        flySpeed = tonumber(Value) or flySpeed
    end
})

local Toggle = Tabs.Misc:AddToggle("Fly", {Title = "Fly", Default = false})
local isFlying = false
local mfly1, mfly2 -- Event connections

-- Define getRoot function
local function getRoot(character)
    return character:FindFirstChild("HumanoidRootPart")
end

-- Define fly start function
local function startFlying()
	isFlying = true
	FLYING = true
	local root = getRoot(LocalPlayer.Character)
	local camera = workspace.CurrentCamera
	local v3none = Vector3.new()
	local v3zero = Vector3.new(0, 0, 0)
	local v3inf = Vector3.new(9e9, 9e9, 9e9)

	local controlModule = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
	local bv = Instance.new("BodyVelocity")
	bv.Name = velocityHandlerName
	bv.Parent = root
	bv.MaxForce = v3zero
	bv.Velocity = v3zero

	local bg = Instance.new("BodyGyro")
	bg.Name = gyroHandlerName
	bg.Parent = root
	bg.MaxTorque = v3inf
	bg.P = 1000
	bg.D = 50

	mfly1 = LocalPlayer.CharacterAdded:Connect(function()
		local bv = Instance.new("BodyVelocity")
		bv.Name = velocityHandlerName
		bv.Parent = root
		bv.MaxForce = v3zero
		bv.Velocity = v3zero

		local bg = Instance.new("BodyGyro")
		bg.Name = gyroHandlerName
		bg.Parent = root
		bg.MaxTorque = v3inf
		bg.P = 1000
		bg.D = 50
	end)

	mfly2 = RunService.RenderStepped:Connect(function()
		root = getRoot(LocalPlayer.Character)
		camera = workspace.CurrentCamera
		if LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") and root:FindFirstChild(velocityHandlerName) and root:FindFirstChild(gyroHandlerName) then
			local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
			local VelocityHandler = root:FindFirstChild(velocityHandlerName)
			local GyroHandler = root:FindFirstChild(gyroHandlerName)

			VelocityHandler.MaxForce = v3inf
			GyroHandler.MaxTorque = v3inf
			if not vfly then humanoid.PlatformStand = true end
			GyroHandler.CFrame = camera.CFrame
			VelocityHandler.Velocity = v3none

			local direction = controlModule:GetMoveVector()

			if direction.X ~= 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * direction.X * flySpeed * 50
			end
			if direction.Z ~= 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * direction.Z * flySpeed * 50
			end
		end
	end)
end

-- Define fly stop function
local function stopFlying()
	FLYING = false
	isFlying = false

	local root = getRoot(LocalPlayer.Character)
	if root:FindFirstChild(velocityHandlerName) then
		root:FindFirstChild(velocityHandlerName):Destroy()
	end
	if root:FindFirstChild(gyroHandlerName) then
		root:FindFirstChild(gyroHandlerName):Destroy()
	end
	
	local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
	if humanoid then humanoid.PlatformStand = false end
	
	if mfly1 then mfly1:Disconnect() end
	if mfly2 then mfly2:Disconnect() end
end

-- Toggle flying based on the toggle value
Toggle:OnChanged(function(value)
	if value then
		startFlying()
	else
		stopFlying()
	end
end)

Options.Fly:SetValue(false) -- Ensures that fly is off by default


local Toggle = Tabs.Misc:AddToggle("Noclip", {Title = "Noclip", Default = false })

Toggle:OnChanged(function(noclip)
    loopnoclip = noclip
    local function loopnoclipfix()
        if LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end

    while loopnoclip do
        pcall(loopnoclipfix)
        task.wait(0.1) -- Slight delay to reduce load
    end
end)

Options.Noclip:SetValue(false)



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
                                
                            end
                        }
                    }
                })
            end
        })
    
------------------------------------------------------------------------SERVER--------------------------------------------------------------------------
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end
        

local gui = Instance.new("ScreenGui")
gui.Name = "Gui"
gui.Parent = game.CoreGui


local button = Instance.new("TextButton")
button.Name = "ToggleButton"
button.Text = "Close" 
button.Size = UDim2.new(0, 70, 0, 30) 
button.Position = UDim2.new(0, 10, 0, 10) 
button.BackgroundTransparency = 0.7 
button.BackgroundColor3 = Color3.fromRGB(97, 62, 167) 
button.BorderSizePixel = 2 
button.BorderColor3 = Color3.new(0, 0, 0) 
button.TextColor3 = Color3.new(1, 1, 1) 
button.FontSize = Enum.FontSize.Size12
button.TextScaled = false 
button.TextWrapped = true 
button.TextStrokeTransparency = 0 
button.TextStrokeColor3 = Color3.new(0, 0, 0) 
button.Parent = gui

local blur = Instance.new("BlurEffect")
blur.Parent = button
blur.Size = 5 

local isOpen = false
local isDraggable = false
local dragConnection

button.MouseButton1Click:Connect(function()
        isOpen = not isOpen 
        
        if isOpen then
            button.Text = "Open"
        else
            button.Text = "Close"
        end
        
        Window:Minimize()
end)

function setDraggable(draggable)
        if draggable then
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
            
            if dragConnection then
                dragConnection:Disconnect()
                dragConnection = nil 
            end
        end
end

function toggleButtonVisibility(visible)
        button.Visible = visible
end

Tabs.Settings:AddParagraph({
            Title = "To open Window from Chat just say:",
            Content = "/e ash"
        })



local function fetchAvatarUrl(userId)
    local url = "https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. userId .. "&size=420x420&format=Png&isCircular=false"
    local response = HttpService:JSONDecode(game:HttpGet(url))
    if response and response.data and #response.data > 0 then
        return response.data[1].imageUrl
    else
        return "https://www.example.com/default-avatar.png" 
    end
    end
    

    local avatarUrl = fetchAvatarUrl(LocalPlayer.UserId)
    

    local function getCurrentTime()
    local hour = tonumber(os.date("!%H", os.time() + 8 * 3600)) 
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
    

    local Input = Tabs.Settings:AddInput("Input", {
    Title = "Send FeedBack",
    Default = "",
    Placeholder = "Send your feedback to Ashbornn",
    Numeric = false, 
    Finished = false, 
    Callback = function(Value)
        
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
                author = { name = "User Send a Feedback in \nGame Place:\n" .. GameName .. " (" .. game.PlaceId .. ")" },  
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
    

    local lastFeedbackTime = 0
    local cooldownDuration = 60  
    

    local function canSendFeedback()
    local currentTime = os.time()
    return (currentTime - lastFeedbackTime >= cooldownDuration)
    end
    

    local function updateLastFeedbackTime()
    lastFeedbackTime = os.time()
    end
    

    Tabs.Settings:AddButton({
    Title = "Send FeedBack",
    Description = "Tap to Send",
    Callback = function()
        if not canSendFeedback() then
            SendNotif("You cant spam this message", "Try again Later Lol", 3)
            return
        end
        
        local feedbackMessage = Input.Value  
        

        if feedbackMessage and feedbackMessage ~= "" then
            sendFeedbackToDiscord(feedbackMessage)
            updateLastFeedbackTime()  
        else
            SendNotif("You cant send empty feedback loll", "Try again later", 3)
        end
    end
    })
    
local DraggableToggle = Tabs.Settings:AddToggle("Draggable Button", {Title = "Draggable Button", Default = false})

DraggableToggle:OnChanged(function(value)
        isDraggable = value
        setDraggable(isDraggable)
end)

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
local TotalTime = math.abs(TimeStart - TimeEnd)
local FormattedTime = string.format("%.2f", TotalTime)
SendNotif("AshbornnHub", "Successfully loaded the script in " .. FormattedTime .. "s.", 3)
