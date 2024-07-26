repeat wait() until game:IsLoaded()

print("[ Hub ]: Murder Mystery 2 loading...")

local TimeStart = tick()
-- Place this LocalScript in StarterPlayerScripts
    
    
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
    -------------------FUNCTION-----------------------
applyesptrans = 0.5
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local N = game:GetService("VirtualInputManager")

local defualtwalkspeed = 16
local defualtjumppower = 50
local defualtgravity = 196.1999969482422
newwalkspeed = defualtwalkspeed
newjumppower = defualtjumppower
antiafk = true

local newflyspeed = 50
local c
local h
local bv
local bav
local cam
local flying
local p = game.Players.LocalPlayer
local buttons = {W = false, S = false, A = false, D = false, Moving = false}

local UIS = game:GetService("UserInputService")
local Touchscreen = UIS.TouchEnabled
getgenv().Ash_Device = Touchscreen and "Mobile" or "PC"
local placeId = game.PlaceId
local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name



local TrapSystem = ReplicatedStorage:WaitForChild("TrapSystem")
local PlaceTrap = TrapSystem:WaitForChild("PlaceTrap")
    
    



    local AntiFlingEnabled = false
    local playerAddedConnection = nil
    local localHeartbeatConnection = nil
    
    
    local ownerUserIds = {
        [129215104] = true,
        [6069697086] = true,
        [4072731377] = true,
        [6150337449] = true,
        [1571371222] = true,
        [2911976621] = true,
        [2729297689] = true,
        [6150320395] = true,
        [301098121] = true,
        [773902683] = true,
        [290931] = true,
        [671905963] = true,
        [3129701628] = true,
        [3063352401] = true,
        [3129413184] = true
    
    }
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
        [7007834038] = true,
        [3129413184] = true
    }

    local monarchs = {
        [129215104] = true,
        [6135258891] = true,
        [290931] = true
    }


    function TeleportPlayer(Position, Offset)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Position * Offset
    end

function EquipTool()
    for _,obj in next, game.Players.LocalPlayer.Backpack:GetChildren() do
        if obj.Name == "Knife" then
            local equip = game.Players.LocalPlayer.Backpack.Knife
            equip.Parent = game.Players.LocalPlayer.Character
        end
    end
end

function Stab()
    game:GetService("Players").LocalPlayer.Character.Knife.Stab:FireServer("Down")
end

local function TeleportToPlayer(playerName)
    local targetPlayer = game.Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
    end
end

function IsAlive(Player)
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

function CreateHighlight()
    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= game:GetService("Players").LocalPlayer and v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") and not v.Character:FindFirstChild("ESP_Highlight") then
            local esphigh = Instance.new("Highlight", v.Character)
            esphigh.Name = "ESP_Highlight"
            esphigh.FillColor = Color3.fromRGB(160, 160, 160)
            esphigh.OutlineTransparency = 0.5
            esphigh.FillTransparency = applyesptrans   
        end
    end
end


local function roleupdaterfix()
    while true do
        roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
        for i, v in pairs(roles) do
            if v.Role == "Murderer" then
                Murder = i
            elseif v.Role == "Sheriff" then
                Sheriff = i
            elseif v.Role == "Hero" then
                Hero = i
            end
        end
        UpdateHighlights() -- Call UpdateHighlights after updating roles
        wait(1) -- Update every second
    end
end

function UpdateHighlights()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game:GetService("Players").LocalPlayer and v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("ESP_Highlight") then
            local Highlight = v.Character:FindFirstChild("ESP_Highlight")
            
            if monarchs[v.UserId] then
                Highlight.FillColor = Color3.fromRGB(128, 0, 128) -- Purple color
                Highlight.FillTransparency = applyesptrans
            elseif premiums[v.UserId] then
                Highlight.FillColor = Color3.fromRGB(0, 255, 255) -- Cyan color
                Highlight.FillTransparency = applyesptrans
            elseif v.Name == Sheriff and IsAlive(v) then
                Highlight.FillColor = Color3.fromRGB(0, 0, 225) -- Blue color
                Highlight.FillTransparency = applyesptrans
            elseif v.Name == Murder and IsAlive(v) then
                Highlight.FillColor = Color3.fromRGB(225, 0, 0) -- Red color
                Highlight.FillTransparency = applyesptrans
            elseif v.Name == Hero and IsAlive(v) and (v.Backpack:FindFirstChild("Gun") or v.Character:FindFirstChild("Gun")) then
                Highlight.FillColor = Color3.fromRGB(255, 255, 0) -- Yellow color
                Highlight.FillTransparency = applyesptrans
            elseif not IsAlive(v) then
                Highlight.FillColor = Color3.fromRGB(100, 100, 100) -- Gray color
                Highlight.FillTransparency = applyesptrans
            else
                Highlight.FillColor = Color3.fromRGB(0, 225, 0) -- Green color
                Highlight.FillTransparency = applyesptrans
            end
        end
    end
end

-- Start the role updater in a separate coroutine
spawn(function()
    pcall(roleupdaterfix)
end)


function HideHighlights()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game:GetService("Players").LocalPlayer and v.Character ~= nil and v.Character:FindFirstChild("ESP_Highlight") then
            v.Character:FindFirstChild("ESP_Highlight"):Destroy()
        end
    end
end



function loadesp()
    if loadespenabled ~= true then
        loadespenabled = true
        AshESP = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/OptiEsp.lua"))()
        AshESP.Names = false
        AshESP.NamesOutline = false
        AshESP.Distance = false
    end
end


function SendNotif(title, content, time)
    Fluent:Notify({
        Title = title,
        Content = content,
        Duration = time
    })
end





function PlayZen()
    game.ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("zen")
end

function PlayHeadless()
    game.ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("headless")
end

function PlayDab()
    game.ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("dab")
end

function PlayFloss()
    game.ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("floss")
end

function PlayZombie()
    game.ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("zombie")
end

function PlayNinja()
    game.ReplicatedStorage.Remotes.PlayEmote:Fire("ninja")
end


-------------------------END FUNCTIONS---------------------------------

local Window = Fluent:CreateWindow({
    Title = "Ashbornn Hub " .. Fluent.Version,
    SubTitle = "by Ashbornn",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when there's no MinimizeKeybind
})

-- Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "box" }),
        Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
        Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
        LPlayer = Window:AddTab({ Title = "Player", Icon = "user" }),
        AutoFarm = Window:AddTab({ Title = "Auto Farm", Icon = "coins" }),
        LEmotes = Window:AddTab({ Title = "Emotes", Icon = "laugh" }),
        Misc = Window:AddTab({ Title = "Misc", Icon = "aperture" }),
        Troll = Window:AddTab({ Title = "Trolling", Icon = "user-x" }),
        Teleport = Window:AddTab({ Title = "Teleport", Icon = "wand" }),
        Server = Window:AddTab({ Title = "Server", Icon = "server" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}



-------------------------EXTRAS---------------------------

--------------------------EXTRAS--------------------------


local Options = Fluent.Options

do


    --------------------------------------------------------------------------------MAIN------------------------------------------------------------------------------------------

        
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

        local function isUnnecessaryPart(part)
            return part:IsA("Decal")
        end

        local function cleanParts(parent)
            for _, child in ipairs(parent:GetChildren()) do
                if child:IsA("Model") and child:FindFirstChildOfClass("Humanoid") then
                    -- Skip player characters or NPCs
                    continue
                end

                if child:IsA("BasePart") then
                    -- Change material to SmoothPlastic
                    child.Material = Enum.Material.SmoothPlastic
                    table.insert(Stuff, 1, child)
                end

                if isUnnecessaryPart(child) then
                    child:Destroy()
                end

                -- Recursively clean children
                cleanParts(child)
            end
        end

        local function isEssentialPart(part)
            -- Define criteria for essential parts here. For example:
            local essentialParts = {
                "Baseplate", -- Common essential part
                -- Add other essential part names or criteria here
            }
            for _, name in ipairs(essentialParts) do
                if part.Name == name then
                    return true
                end
            end
            return false
        end

        local function cleanWorkspace(workspace)
            for _, child in ipairs(workspace:GetChildren()) do
                if not isEssentialPart(child) then
                    cleanParts(child)
                end
            end
        end

        -- Apply to Workspace
        cleanWorkspace(game.Workspace)

        -- Optionally apply to other containers like Lighting, ReplicatedStorage, etc.
        cleanParts(game.Lighting)
        cleanParts(game.ReplicatedStorage)

        -- Additional optimizations
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


    -------------------------------------------COMBAT---------------------------------------

    local SheriffHacks = Tabs.Combat:AddSection("Sheriff Hacks")

    local function IsPlayerEligible()
        if not IsAlive(Player) then
            SendNotif("You're not alive", "Please wait for the new round to grab the gun.", 3)
            return false
        end
    
        if Player.Backpack:FindFirstChild("Gun") or (Player.Character and Player.Character:FindFirstChild("Gun")) then
            SendNotif("You already have a gun", "Lollll.", 3)
            return false
        end
        
        if Player.Backpack:FindFirstChild("Knife") then
            SendNotif("You have a knife", "Auto Grab Gun is disabled because you have a knife.", 3)
            return false
        end
    
        return true
    end
    
    local function GrabGun()
        if not IsPlayerEligible() then return end
    
        if Player.Character then
            local gundr = workspace:FindFirstChild("Normal"):FindFirstChild("GunDrop")
            if gundr then
                local oldpos = Player.Character.HumanoidRootPart.CFrame
                local startTime = os.clock()
    
                repeat
                    Player.Character.HumanoidRootPart.CFrame = gundr.CFrame * CFrame.Angles(math.rad(90), math.rad(0), math.rad(0))
                    task.wait()
                    Player.Character.HumanoidRootPart.CFrame = gundr.CFrame * CFrame.Angles(math.rad(-90), math.rad(0), math.rad(0))
                    task.wait()
                until not gundr:IsDescendantOf(workspace) or (os.clock() - startTime) >= 3
                
                Player.Character.HumanoidRootPart.CFrame = oldpos
                Player.Character.Humanoid:ChangeState(1)
                SendNotif("Grab Gun", "Gotcha.", 3)
            else
                SendNotif("Gun not Found", "Wait for the Sheriff's death to grab the gun.", 3)
            end
        end
    end
    
    Tabs.Combat:AddButton({
        Title = "Grab Gun v2",
        Description = "Teleport to and grab the gun if available",
        Callback = GrabGun
    })        


local AutoGrabEnabled = false

local Toggle = Tabs.Combat:AddToggle("AutoGrab", {Title = "Auto Grab Gun", Default = false })

Toggle:OnChanged(function(value)
AutoGrabEnabled = value
end)

workspace.ChildAdded:Connect(function(child)
if AutoGrabEnabled and child.Name == "GunDrop" then
    GrabGun()
end
end)

Options.AutoGrab:SetValue(false)

-- The original button functionality
local function GrabGunV2()
    local player = game.Players.LocalPlayer

    if not IsAlive(player) then
        SendNotif("You're not alive ", "Please wait for the new round to grab the gun.", 3)
        return
    end

    if player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Gun")) then
        SendNotif("You already have a gun", "Lollll.", 3)
        return
    end

    if player.Character then
        local gundr = workspace:FindFirstChild("Normal"):FindFirstChild("GunDrop")
        if gundr then
            local oldpos = player.Character.HumanoidRootPart.CFrame
            repeat
                player.Character.HumanoidRootPart.CFrame = gundr.CFrame * CFrame.Angles(math.rad(90), math.rad(0), math.rad(0))
                task.wait()
                player.Character.HumanoidRootPart.CFrame = gundr.CFrame * CFrame.Angles(math.rad(-90), math.rad(0), math.rad(0))
                task.wait()
            until not gundr:IsDescendantOf(workspace)
            player.Character.HumanoidRootPart.CFrame = oldpos
            oldpos = false
            player.Character.Humanoid:ChangeState(1)
            button.Text = "Grab Gun (Gotcha)"
        else
            SendNotif("Gun not Found", "Wait for the Sheriff's death to grab the gun.", 3)
        end
    end
end

-- Create the keybind
local Keybind = Tabs.Combat:AddKeybind("GrabGunKeybind", {
    Title = "Grab Gun V2 Keybind",
    Mode = "Toggle", -- Always, Toggle, Hold
    Default = "", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function(Value)
        print("Keybind clicked!", Value)
    end,

    -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
    ChangedCallback = function(New)
        print("Keybind changed!", New)
    end
})

-- OnClick is only fired when you press the keybind and the mode is Toggle
-- Otherwise, you will have to use Keybind:GetState()
Keybind:OnClick(function()
    print("Keybind clicked:", Keybind:GetState())
    if Keybind:GetState() then
        GrabGunV2()
    end
end)

Keybind:OnChanged(function()
    print("Keybind changed:", Keybind.Value)
end)
local player = game.Players.LocalPlayer

-- Function to shoot at the murderer's position
local function shootAtMurderer()
local murderer = game.Players[Murder] -- Assuming Murder is defined elsewhere as a string
local murdererCharacter = murderer and murderer.Character
local playerCharacter = player.Character

if murdererCharacter and murdererCharacter:FindFirstChild("HumanoidRootPart") then
    if playerCharacter:FindFirstChild("Gun") then
        playerCharacter.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, murdererCharacter.HumanoidRootPart.Position, "AH2")
    else
        SendNotif("You don't have a gun", "Wait for the sheriff's death or grab the gun.", 3)
    end
else
    SendNotif("Murderer or HumanoidRootPart not found", "Character or root part missing.", 3)
end
end

-- Function to update shoot key based on keybind change
local function updateShootKey(newKey)
shootKey = newKey
print("Shoot key updated to:", shootKey.Name)  -- Use .Name to get the string representation of the key
end

-- Listen for the shoot key press
game:GetService("UserInputService").InputBegan:Connect(function(input, isProcessed)
if not isProcessed and input.KeyCode == shootKey then
    print(shootKey.Name.." key pressed")  -- Use .Name to get the string representation of the key
    
    -- Check if the player has a gun
    local playerCharacter = player.Character
    if playerCharacter then
        local gun = playerCharacter:FindFirstChild("Gun")
        if gun then
            shootAtMurderer()
        else
            SendNotif("You don't have a Gun", "Grab the gun or wait for Sheriff Death.", 3)
        end
    end
end
end)

-- Adding the Keybind to change shoot key
local Keybind = Tabs.Combat:AddKeybind("Keybind", {
Title = "Silent Aim Keybind",
Mode = "Always", -- Allow the keybind to always be active
Default = "", -- Default to current shoot key
-- Occurs when the keybind is clicked, Value is `true`/`false`
Callback = function(Value)
    local newKey = Enum.KeyCode[Value]
    if newKey then
        updateShootKey(newKey)
        SendNotif("Shoot Keybind Changed", "New keybind set to "..newKey.Name, 3)
    else
        SendNotif("Invalid Keybind", "Please choose a valid keybind. ", 3)
    end
end,
-- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
ChangedCallback = function(New)
    local newKey = New
    updateShootKey(newKey)
    SendNotif("Shoot Keybind Changed", "New keybind set to "..newKey.Name, 3)
end
})


    

Tabs.Combat:AddButton({
    Title = "Shoot Murderer",
    Description = "Tp to Murderer and Shoot",
    Callback = function()
        local player = game.Players.LocalPlayer
        local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end

        local currentX = humanoidRootPart.CFrame.X
        local currentY = humanoidRootPart.CFrame.Y
        local currentZ = humanoidRootPart.CFrame.Z

        if Murder then
            local murdererPlayer = game.Players[Murder]
            local murdererCharacter = murdererPlayer and murdererPlayer.Character
            if murdererCharacter and murdererCharacter:FindFirstChild("HumanoidRootPart") then
                -- Check if the murderer is in the owner user IDs table
                if ownerUserIds[murdererPlayer.UserId] then
                    SendNotif("You're trying to kill the Whitelisted Player", "Nuhh uhh", 3)
                    return
                end

                local murdererPosition = murdererCharacter.HumanoidRootPart.CFrame

                -- Check if the player has a gun in their backpack or equipped
                local backpack = player:FindFirstChild("Backpack")
                local gun = backpack and (backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun"))

                if gun then
                    -- Equip the gun if not already equipped
                    if backpack:FindFirstChild("Gun") then
                        backpack.Gun.Parent = player.Character
                    end

                    -- Teleport to the murderer
                    humanoidRootPart.CFrame = murdererPosition

                    -- Shoot the gun at the murderer's position
                    if player.Character:FindFirstChild("Gun") then
                        wait(0.2)
                        player.Character:MoveTo(Vector3.new(currentX, currentY, currentZ))
                        player.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, murdererCharacter.HumanoidRootPart.Position, "AH2")
                    end
                else
                    SendNotif("You don't have a Gun", "Grab the gun or wait for Sheriff Death.", 3)
                end
            else
                SendNotif("Murderer not Found", "Murderer's character not found.", 3)
            end
        else
            SendNotif("Murderer not Found", "Murderer not assigned yet.", 3)
        end
    end
})

local autoShootingActive = false
local autoShootingTask = nil
local gunNotificationShown = false -- Flag to track if the gun notification has been shown

local function autoShoot()
    while autoShootingActive do
        local player = game.Players.LocalPlayer
        local characterRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not characterRootPart then return end
        
        if Murder then
            local murdererPlayer = game.Players[Murder]
            local murdererCharacter = murdererPlayer and murdererPlayer.Character
            if murdererCharacter and murdererCharacter:FindFirstChild("HumanoidRootPart") then
                -- Calculate direction to murderer
                local murdererPosition = murdererCharacter.HumanoidRootPart.Position
                local rayDirection = murdererPosition - characterRootPart.Position
                
                -- Perform a raycast to check for obstacles between player and murderer
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                raycastParams.FilterDescendantsInstances = {player.Character}
                
                local hit = workspace:Raycast(characterRootPart.Position, rayDirection.Unit * rayDirection.Magnitude, raycastParams)
                
                -- Check if the raycast did not hit anything or if it hit the murderer
                if not hit or (hit.Instance and hit.Instance.Parent == murdererCharacter) then
                    -- Check if the player has a gun in their backpack or equipped
                    local backpack = player:FindFirstChild("Backpack")
                    local gun = backpack and (backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun"))
                    
                    if gun then
                        -- Equip the gun if not already equipped
                        if not player.Character:FindFirstChild("Gun") then
                            backpack.Gun.Parent = player.Character
                        end
                        
                        -- Loop to continuously shoot the gun until the player no longer has it
                        while autoShootingActive and (player.Character:FindFirstChild("Gun")) do
                            -- Shoot the gun at the murderer's position
                            local gunObject = player.Character:FindFirstChild("Gun")
                            if gunObject then
                                local knifeServer = gunObject:FindFirstChild("KnifeServer")
                                if knifeServer then
                                    knifeServer:FindFirstChild("ShootGun"):InvokeServer(1, murdererPosition, "AH")
                                else
                                    warn("KnifeServer not found in Gun.")
                                end
                            else
                                warn("Gun not found in character.")
                                break
                            end
                            task.wait(0.1) -- Short delay between shots
                        end
                    else
                        -- Notify about the absence of a gun, if not already notified
                        if not gunNotificationShown then
                            SendNotif("Gun not found", "You dont have a Gun loll.", 3)
                            gunNotificationShown = true -- Set flag to true to prevent further notifications
                        end
                    end
                else
                    -- If the raycast hit an obstacle, do nothing (optional notification removed)
                end
            else
                -- If murderer's character not found, handle this situation (optional)
                -- Optional notification or debugging message can be added here
            end
        else
            -- If Murder is not defined or found, handle this situation (optional)
            -- Optional notification or debugging message can be added here
        end
        
        -- Wait for the cooldown interval before checking again
        wait(2) -- Cooldown before checking the murderer's presence and line of sight again
    end
end

local function onCharacterAdded(character)
if Options.AutoShoot.Value == true then
    Options.AutoShoot:SetValue(false)
    wait(0.1)
    Options.AutoShoot:SetValue(true)
end
end



local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(onCharacterAdded)

local Toggle = Tabs.Combat:AddToggle("AutoShoot", {Title = "Auto Shoot Murderer", Default = false})

Toggle:OnChanged(function()
    autoShootingActive = Toggle.Value
    if autoShootingActive then
        autoShootingTask = task.spawn(autoShoot)
        
    else
        autoShootingActive = false
        if autoShootingTask then
            task.cancel(autoShootingTask)
            autoShootingTask = nil
        end
        gunNotificationShown = false -- Reset the flag when auto shooting is disabled
    end
end)

-- Initialize auto shooting if the toggle is already enabled
if Toggle.Value then
    autoShootingActive = true
    autoShootingTask = task.spawn(autoShoot)
end

-- Ensure auto-shoot starts if the character is already loaded
if player.Character then
    onCharacterAdded(player.Character)
end
    

        
        local MurderHacks = Tabs.Combat:AddSection("Murderer Hacks")
    
Tabs.Combat:AddButton({
    Title = "Kill Sheriff or Hero (Stab)",
    Description = "Tp to Sheriff or Hero and Stab",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart then
            SendNotif("Error body not Found", "No body found", 3)
            return
        end

        local currentPosition = humanoidRootPart.Position

        local function IsAlive(Player)
            for i, v in pairs(roles) do
                if Player.Name == i then
                    return not v.Killed and not v.Dead
                end
            end
            return false
        end

        local function getTargetPlayer()
            if Sheriff and IsAlive(game.Players[Sheriff]) then
                return game.Players[Sheriff]
            elseif Hero and IsAlive(game.Players[Hero]) then
                return game.Players[Hero]
            else
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p.Backpack:FindFirstChild("Gun") and IsAlive(p) then
                        return p
                    end
                end
            end
            return nil
        end

        -- Check if the player has a knife
        local backpack = player.Backpack
        if not (backpack:FindFirstChild("Knife") or character:FindFirstChild("Knife")) then
            SendNotif("You are not Murderer", "Bruh this will not work if you're not Murderer", 3)
            return
        end

        local targetPlayer = getTargetPlayer()

        if targetPlayer then
            -- Check if the target player is in the owner user IDs table
            if ownerUserIds[targetPlayer.UserId] then
                SendNotif("You cant kill Whitelisted Player", "Nuhh uhh", 3)
                return
            end

            local targetCharacter = targetPlayer.Character
            if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
                local targetPosition = targetCharacter.HumanoidRootPart.Position

                -- Equip the knife if not already equipped
                if backpack:FindFirstChild("Knife") then
                    backpack.Knife.Parent = character
                end

                humanoidRootPart.CFrame = CFrame.new(targetPosition)

                -- Stab the target
                if character:FindFirstChild("Knife") then
                    wait(0.2)
                    character:MoveTo(currentPosition)
                    if type(Stab) == "function" then
                        Stab()
                    end
                    firetouchinterest(humanoidRootPart, targetCharacter.HumanoidRootPart, 1)
                    firetouchinterest(humanoidRootPart, targetCharacter.HumanoidRootPart, 0)

                    -- Force teleport to original position
                    humanoidRootPart.CFrame = CFrame.new(currentPosition)
                end
            else
        SendNotif("Target not Found", "Target Character not found.", 3)
            end
        else
            SendNotif("Character not Found", "Target not found", 3)
        end
    end
})

    local kniferangenum = 20

    -- Slider Definition
    local Slider = Tabs.Combat:AddSlider("SLIDER", {
        Title = "Knife Range",
        Description = "Adjust the range of the knife (Turn on Kill Aura) ",
        Default = 20,
        Min = 5,
        Max = 100,
        Rounding = 1,
        Callback = function(Value)
            kniferangenum = tonumber(Value)
        end
    })

    Slider:OnChanged(function(Value)
        kniferangenum = tonumber(Value)
    end)

    Slider:SetValue(20)

    

    local knifeAuraToggle = Tabs.Combat:AddToggle("KnifeAura", {Title = "Knife Aura", Default = false})

    knifeAuraToggle:OnChanged(function(knifeaura)
        knifeauraloop = knifeaura
        while knifeauraloop do
            function knifeAuraLoopFunction()
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer:DistanceFromCharacter(v.Character.HumanoidRootPart.Position) < kniferangenum then
                        local localUserId = game.Players.LocalPlayer.UserId
                        local playerUserId = v.UserId
    
                        if monarchs[localUserId] then
                            -- Monarch can kill everyone, including premiums
                            EquipTool()
                            wait()
                            local localCharacter = game.Players.LocalPlayer.Character
                            local knife = localCharacter and localCharacter:FindFirstChild("Knife")
                            if not knife then return end
                            wait()
                            local playerCharacter = v.Character
                            local humanoidRootPart = playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart")
    
                            if humanoidRootPart then
                                Stab()
                                firetouchinterest(humanoidRootPart, knife.Handle, 1)
                                firetouchinterest(humanoidRootPart, knife.Handle, 0)
                            end
                        elseif premiums[localUserId] and not monarchs[playerUserId] then
                            -- Premium can kill others but not Monarchs
                            EquipTool()
                            wait()
                            local localCharacter = game.Players.LocalPlayer.Character
                            local knife = localCharacter and localCharacter:FindFirstChild("Knife")
                            if not knife then return end
                            wait()
                            local playerCharacter = v.Character
                            local humanoidRootPart = playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart")
    
                            if humanoidRootPart then
                                Stab()
                                firetouchinterest(humanoidRootPart, knife.Handle, 1)
                                firetouchinterest(humanoidRootPart, knife.Handle, 0)
                            end
                        elseif not premiums[localUserId] and not monarchs[playerUserId] then
                            -- Normal users can kill others but not Monarchs or Premiums
                            EquipTool()
                            wait()
                            local localCharacter = game.Players.LocalPlayer.Character
                            local knife = localCharacter and localCharacter:FindFirstChild("Knife")
                            if not knife then return end
                            wait()
                            local playerCharacter = v.Character
                            local humanoidRootPart = playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart")
    
                            if humanoidRootPart then
                                Stab()
                                firetouchinterest(humanoidRootPart, knife.Handle, 1)
                                firetouchinterest(humanoidRootPart, knife.Handle, 0)
                            end
                        end
                    end
                end
            end
            wait()
            pcall(knifeAuraLoopFunction)
        end
    end)
    
    Options.KnifeAura:SetValue(false)
    
    local autoKillAllToggle = Tabs.Combat:AddToggle("AutoKillAll", {Title = "Auto Kill All", Default = false})
    
    autoKillAllToggle:OnChanged(function(autokillall)
        autokillallloop = autokillall
        while autokillallloop do
            function autoKillAllLoopFunction()
                EquipTool()
                wait()
                local localCharacter = game.Players.LocalPlayer.Character
                local knife = localCharacter and localCharacter:FindFirstChild("Knife")
                if not knife then return end
                wait()
                for _, Player in ipairs(game.Players:GetPlayers()) do
                    if Player ~= game.Players.LocalPlayer then
                        local playerCharacter = Player.Character
                        local humanoidRootPart = playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart")
                        
                        if humanoidRootPart then
                            local localUserId = game.Players.LocalPlayer.UserId
                            local playerUserId = Player.UserId
    
                            if monarchs[localUserId] then
                                -- Monarch can kill everyone, including premiums
                                Stab()
                                firetouchinterest(humanoidRootPart, knife.Handle, 1)
                                firetouchinterest(humanoidRootPart, knife.Handle, 0)
                            elseif premiums[localUserId] and not monarchs[playerUserId] then
                                -- Premium can kill others but not Monarchs
                                Stab()
                                firetouchinterest(humanoidRootPart, knife.Handle, 1)
                                firetouchinterest(humanoidRootPart, knife.Handle, 0)
                            elseif not premiums[localUserId] and not monarchs[playerUserId] then
                                -- Normal users can kill others but not Monarchs or Premiums
                                Stab()
                                firetouchinterest(humanoidRootPart, knife.Handle, 1)
                                firetouchinterest(humanoidRootPart, knife.Handle, 0)
                            end
                        end
                    end
                end
                wait()
            end
            wait()
            pcall(autoKillAllLoopFunction)
        end
    end)
    
    Options.AutoKillAll:SetValue(false)







    --------------------------------------------COMBAT-----------------------------------------------
----------------------------------------------MISC---------------------------------------------------

Tabs.Misc:AddButton({
    Title = "Expose Roles",
    Description = "",
    Callback = function()
        SayMessageRequest:FireServer("Murderer Is: " .. Murder, "normalchat")
        SayMessageRequest:FireServer("Sheriff Is: " .. Sheriff, "normalchat")
        
    end
})
    
    local Toggle = Tabs.Misc:AddToggle("AlwaysAliveChat", {Title = "Always Alive Chat", Default = false})

Toggle:OnChanged(function(alwaysalive)
    if alwaysalive == true then
        alwaysalivechat = true
        wait()
    end
    if alwaysalive == false then
        alwaysalivechat = false
        wait()
    end
end)

Options.AlwaysAliveChat:SetValue(false)

-- Initialize the seedeadchat variable
local seedeadchat = false

-- Define a function to handle the Fade event
local function handleFadeEvent()
    game:GetService("ReplicatedStorage").Remotes.Gameplay.Fade.OnClientEvent:Connect(function()
        if seedeadchat then
            task.wait(0.5)
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/join Dead", "normalchat")
        end
    end)
end

-- Create the toggle and handle its change event
local Toggle = Tabs.Misc:AddToggle("SeeDeadChat", {Title = "See dead chat", Default = false})

Toggle:OnChanged(function(value)
    seedeadchat = value
    if seedeadchat then
        handleFadeEvent()
    end
end)

Options.SeeDeadChat:SetValue(false)

    
Tabs.Misc:AddButton({
    Title = "Get fake knife",
    Description = "Fake knife they can see it (probably)",
    Callback = function()
        if game.Players.LocalPlayer.Character ~= nil then
            local lp = game.Players.LocalPlayer
            local tool;local handle;local knife;
            local animation1 = Instance.new("Animation")
            animation1.AnimationId = "rbxassetid://2467567750"
            local animation2 = Instance.new("Animation")
            animation2.AnimationId = "rbxassetid://1957890538"
            local anims = {animation1, animation2}
            tool = Instance.new("Tool")
            tool.Name = "Fake Knife"
            tool.Grip = CFrame.new(0, -1.16999984, 0.0699999481, 1, 0, 0, 0, 1, 0, 0, 0, 1)
            tool.GripForward = Vector3.new(-0, -0, -1)
            tool.GripPos = Vector3.new(0, -1.17, 0.0699999)
            tool.GripRight = Vector3.new(1, 0, 0)
            tool.GripUp = Vector3.new(0, 1, 0)
            handle = Instance.new("Part")
            handle.Size = Vector3.new(0.310638815, 3.42103457, 1.08775854)
            handle.Name = "Handle"
            handle.Transparency = 1
            handle.Parent = tool
            tool.Parent = lp.Backpack
            knife = lp.Character:WaitForChild("KnifeDisplay")
            knife.Massless = true
            lp:GetMouse().Button1Down:Connect(function()
                if tool and tool.Parent == lp.Character then
                    local an = lp.Character.Humanoid:LoadAnimation(anims[math.random(1, 2)])
                    an:Play()
                end
            end)
            local aa = Instance.new("Attachment", handle)
            local ba = Instance.new("Attachment", knife)
            local hinge = Instance.new("HingeConstraint", knife)
            hinge.Attachment0 = aa 
            hinge.Attachment1 = ba
            hinge.LimitsEnabled = true
            hinge.LowerAngle = 0
            hinge.Restitution = 0
            hinge.UpperAngle = 0
            lp.Character:WaitForChild("UpperTorso"):FindFirstChild("Weld"):Destroy()
            game:GetService("RunService").Heartbeat:Connect(function()
                setsimulationradius(1 / 0, 1 / 0)
                if tool.Parent == lp.Character then
                    knife.CFrame = handle.CFrame
                else
                    knife.CFrame = lp.Character:WaitForChild("UpperTorso").CFrame
                end
            end)
        end
    end
})

Tabs.Misc:AddButton({
    Title = "Anti Fake Lag(Delete Chroma)",
    Description = "",
    Callback = function()
        for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v.Name == "LugerChroma" then
                if v:FindFirstChild("Handle"):FindFirstChild("Chroma") then
                    v.Handle:FindFirstChild("Chroma"):Destroy()
                end
                if v:FindFirstChild("Handle"):FindFirstChild("Mesh") then
                    v.Handle:FindFirstChild("Mesh"):Destroy()
                end
                if v:FindFirstChild("Handle").Transparency == 0 then
                    v.Handle.Transparency = 1
                    v.GripPos = Vector3.new(0, -5, 0)
                end
            end
        end
    end
})

Tabs.Misc:AddButton({
    Title = "Anti Fake Lag 2(Delete LugerChroma)",
    Description = "",
    Callback = function()
        for i, v in pairs(workspace:GetDescendants()) do
            if v.Name == "LugerChroma" then
                if v:FindFirstChild("Handle"):FindFirstChild("Mesh") then
                    v:FindFirstChild("Handle"):FindFirstChild("Chroma"):Destroy()
                    v:FindFirstChild("Handle"):FindFirstChild("Mesh"):Destroy()
                end
            end
        end
        for i, v in pairs(game.Players:GetPlayers()) do
            if v.Backpack:FindFirstChild("LugerChroma") then
                if v.Backpack:FindFirstChild("LugerChroma"):FindFirstChild("Handle"):FindFirstChild("Chroma") then
                    v.Backpack:FindFirstChild("LugerChroma").Handle:FindFirstChild("Chroma"):Destroy()
                end
                if v.Backpack:FindFirstChild("LugerChroma"):FindFirstChild("Handle"):FindFirstChild("Mesh") then
                    v.Backpack:FindFirstChild("LugerChroma").Handle:FindFirstChild("Mesh"):Destroy()
                end
            end
        end
    end
})

----------------------------------------------------MISC---------------------------------------------------


    
    
--------------------------------------------------------MISC ENDS--------------------------------------------------

    -------------------------------------------------------------------------------------TROLLING--------------------------------------------------------------------------------

    
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
            game:GetService("ReplicatedStorage").Remotes.Gameplay.Stealth:FireServer(true)
        end
    end)

    local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

local visible_parts = {}

local function ghost_parts()
if lp.Character then
    for _, v in pairs(lp.Character:GetChildren()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            table.insert(visible_parts, v)
            v.Transparency = 0.5
            ReplicatedStorage.Remotes.Gameplay.Stealth:FireServer(true)
        end
    end
end
end

local FEInviToggle = Tabs.Troll:AddToggle("FEInvisible", {Title = "FE Invisible", Default = false})

FEInviToggle:OnChanged(function(value)
isinvisible = value
if lp.Character then
    if not isinvisible then
        -- Restore visibility
        for _, v in pairs(visible_parts) do
            v.Transparency = 0
            ReplicatedStorage.Remotes.Gameplay.Stealth:FireServer(false)
        end
        visible_parts = {}  -- Clear the table after restoring visibility
    else
        ghost_parts()
    end
end
end)

Options.FEInvisible:SetValue(false)

if lp.Character then
setup_character(lp.Character)
if isinvisible then
    ghost_parts()
end
end


    
    

        
    local FLINGTARGET = "" -- Initialize FLINGTARGET variable

    -- Function to get other players, including an "All" option
    local function GetOtherPlayersAll()
    local players = {"all"}
    for _, Player in ipairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer then
                table.insert(players, Player.Name)
            end
    end
    return players
    end
    
    local selectedPlayer = "all"  -- Default to "All"
    local Dropdown
    local FLINGTARGET = ""  -- Variable to store the fling target

    local function CreateDropdown()
        Dropdown = Tabs.Troll:AddDropdown("Select Player to Fling", {
            Title = "Select Player",
            Values = GetOtherPlayersAll(),
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
        local newValues = GetOtherPlayersAll()
        Dropdown.Values = newValues  -- Update the dropdown values
        Dropdown:SetValue("")  -- Reset selected value to default
    end

    -- Connect to PlayerAdded and PlayerRemoving events to update the dropdown
    game.Players.PlayerAdded:Connect(UpdateDropdown)
    game.Players.PlayerRemoving:Connect(UpdateDropdown)

    local Toggle = Tabs.Troll:AddToggle("Fling", {
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

        
        
        local Toggle = Tabs.Troll:AddToggle("Fling", {Title = "Fling Murderer", Default = false })

    Toggle:OnChanged(function(flingplayer)
    getgenv().FLINGTARGET = Murder
        if flingplayer then
            loadstring(game:HttpGet('https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/FlingGood.lua'))()
            wait()
        else
            getgenv().flingloop = false
            wait()
        end
    end)

    Options.Fling:SetValue(false)

    local Toggle = Tabs.Troll:AddToggle("Fling", {Title = "Fling Sheriff", Default = false })

    Toggle:OnChanged(function(flingplayer)
    getgenv().FLINGTARGET = Sheriff
        if flingplayer then
            loadstring(game:HttpGet('https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/FlingGood.lua'))()
            wait()
        else
            getgenv().flingloop = false
            wait()
        end
    end)

    Options.Fling:SetValue(false)

    local TrapSec = Tabs.Troll:AddSection("Trap Trolling (Not Working)")


-- Function to update roles
local function updateRoles()
    while true do
        roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
        for i, v in pairs(roles) do
            if v.Role == "Murderer" then
                Murder = i
            elseif v.Role == "Sheriff" then
                Sheriff = i
            elseif v.Role == "Hero" then
                Hero = i
            end
        end
        wait(1)  -- Update every second
    end
end


-- Function to get other players, including an "All" option
local function GetOtherPlayers()
    local players = {"All"}
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            table.insert(players, Player.Name)
        end
    end
    return players
end

local selectedPlayer = "All"  -- Default to "All"
local Dropdown

-- Function to create the dropdown menu
local function CreateDropdown()
    Dropdown = Tabs.Troll:AddDropdown("Select Loop Target Player", {
        Title = "Select Player",
        Values = GetOtherPlayers(),
        Multi = false,
        Default = "All",
    })

    Dropdown:OnChanged(function(Value)
        selectedPlayer = Value  -- Update selectedPlayer when selection changes
        ChangeLoopTarget = Value  -- Update ChangeLoopTarget when selection changes
    end)
end

-- Initial creation of the dropdown
CreateDropdown()

-- Function to update the dropdown values
function UpdateDropdown()
    local newValues = GetOtherPlayers()
    Dropdown.Values = newValues  -- Update the dropdown values
    Dropdown:SetValue("All")  -- Reset selected value to default
end

-- Connect to PlayerAdded and PlayerRemoving events to update the dropdown
Players.PlayerAdded:Connect(UpdateDropdown)
Players.PlayerRemoving:Connect(UpdateDropdown)

local ToggleTrapAll = Tabs.Troll:AddToggle("TrapAll", {Title = "Loop Trap Selected Player", Default = false })
local ToggleTrapSheriff = Tabs.Troll:AddToggle("TrapSheriff", {Title = "Loop Trap Sheriff", Default = false })
local ToggleTrapMurderer = Tabs.Troll:AddToggle("TrapMurderer", {Title = "Loop Trap Murderer", Default = false })

function placeTrapForPlayer(Player)
    if ownerUserIds[Player.UserId] then
        return  -- Do not place trap if the player is in the exempt list
    end
    
    local HumanoidRootPart = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart then
        pcall(function()
            PlaceTrap:InvokeServer(CFrame.new(HumanoidRootPart.Position))
        end)
    end
end

function ChangeLoopTrapPlayerFix()
    if ChangeLoopTarget == "All" then
        for _, v in pairs(Players:GetChildren()) do
            if v ~= LocalPlayer then
                placeTrapForPlayer(v)
            end
        end
    else
        local Target = Players:FindFirstChild(ChangeLoopTarget)
        if Target then
            placeTrapForPlayer(Target)
        end
    end
end

function ChangeLoopTrapSheriffFix()
    if Sheriff then
        local SheriffPlayer = Players:FindFirstChild(Sheriff)
        if SheriffPlayer and not ownerUserIds[SheriffPlayer.UserId] then
            placeTrapForPlayer(SheriffPlayer)
        end
    end
end

function ChangeLoopTrapMurdererFix()
    if Murder then
        local MurderPlayer = Players:FindFirstChild(Murder)
        if MurderPlayer and not ownerUserIds[MurderPlayer.UserId] then
            placeTrapForPlayer(MurderPlayer)
        end
    end
end

ToggleTrapAll:OnChanged(function(Value)
    ChangeLoopTrapPlayer = Value

    spawn(function()
        while ChangeLoopTrapPlayer do
            pcall(ChangeLoopTrapPlayerFix)
            task.wait(0.1)  -- Reduce wait time for faster trap placement
        end
    end)
end)

ToggleTrapSheriff:OnChanged(function(Value)
    ChangeLoopTrapSheriff = Value

    spawn(function()
        while ChangeLoopTrapSheriff do
            pcall(ChangeLoopTrapSheriffFix)
            task.wait(0.1)  -- Reduce wait time for faster trap placement
        end
    end)
end)

ToggleTrapMurderer:OnChanged(function(Value)
    ChangeLoopTrapMurderer = Value

    spawn(function()
        while ChangeLoopTrapMurderer do
            pcall(ChangeLoopTrapMurdererFix)
            task.wait(0.1)  -- Reduce wait time for faster trap placement
        end
    end)
end)

Options.TrapAll:SetValue(false)
Options.TrapSheriff:SetValue(false)
Options.TrapMurderer:SetValue(false)

-- Start role updater in a separate thread
spawn(updateRoles)

Tabs.Troll:AddButton({
        Title = "Get Trap Tool",
        Description = "Give you trap tool that u can place anywhere you want loll",
        Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/LordRayven/UmF5dmVuScript/main/TrapTool",true))()
end
    })

local ToggleAntiTrap = Tabs.Troll:AddToggle("AntiTrap", {Title = "Anti Trap", Default = false})

function AntiTrapFix()
    local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if Humanoid and Humanoid.WalkSpeed == 0.009999999776482582 then
        Humanoid.WalkSpeed = 16
    end
end

ToggleAntiTrap:OnChanged(function(Value)
    ChangeAntiTrap = Value

    spawn(function()
        while ChangeAntiTrap do
            pcall(AntiTrapFix)
            task.wait(0.1)  -- Check more frequently for traps
        end
    end)
end)

Options.AntiTrap:SetValue(false)
        
------------------------------------------------------------------------------------TROLLING-----------------------------------------------------------------------------------
        

    -------------------------------------------------------------------------LOCAL PLAYER----------------------------------------------------------------------------------------------




    
    local Toggle = Tabs.LPlayer:AddToggle("Invisible", {Title = "Invisible (Not work)", Default = false})

    Toggle:OnChanged(function(invis)
        game:GetService("ReplicatedStorage").Remotes.Gameplay.Stealth:FireServer(invis)
    end)

    Options.Invisible:SetValue(false)

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

    local function CreateDropdownB()
        local Dropdown = Tabs.LPlayer:AddDropdown("ViewPlayer", {
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

    Tabs.LPlayer:AddButton({
        Title = "View Murderer",
        Description = "Change Camera View to Murderer",
        Callback = function()
            local Players = game:GetService("Players")
            local camera = workspace.Camera
    
            if Murder and Players:FindFirstChild(Murder) then
                camera.CameraSubject = Players[Murder].Character:WaitForChild("Humanoid")
            else
                SendNotif("No Valid Target", "Murderer not Found", 3)
            end
        end
    })
    




-- Create the button to view the Sheriff, Hero, or GunDrop
Tabs.LPlayer:AddButton({
    Title = "View Sheriff/Hero",
    Description = "Change Camera View to Sheriff, Hero, or GunDrop",
    Callback = function()
        local Players = game:GetService("Players")
        local camera = workspace.Camera

        local SheriffExists = Sheriff and Players:FindFirstChild(Sheriff) and IsAlive(Players[Sheriff])
        local HeroExists = Hero and Players:FindFirstChild(Hero) and IsAlive(Players[Hero])
        local GunDropObject = workspace:FindFirstChild("Normal"):FindFirstChild("GunDrop")
        if SheriffExists then
            camera.CameraSubject = Players[Sheriff].Character:WaitForChild("Humanoid")
        elseif HeroExists then
            camera.CameraSubject = Players[Hero].Character:WaitForChild("Humanoid")
        elseif GunDropObject then
            camera.CameraSubject = GunDropObject
        else
            SendNotif("No Valid Target", "Sheriff, Hero, Or Gun not Found", 3)
        end
    end
})

Tabs.LPlayer:AddButton({
    Title = "Stop Viewing",
    Description = "Stop viewing the selected player",
    Callback = function()
        workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
    end
})


---------------------------------------------------------------------------------LOCAL PLAYER------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------AUTOFARM------------------------------------------------------------------------------------------------------
Tabs.AutoFarm:AddParagraph({
    Title = "IMPORTANT: PLEASE READ",
    Content = "Please be aware that prolonged use of this Autofarm may cause lag during extended gameplay."
    })
    local Toggle = Tabs.AutoFarm:AddToggle("RejoinKicked", {Title = "Rejoin on Kick", Default = false })
    
    local connection -- Declare a variable to hold the connection
    
    Toggle:OnChanged(function(value)
    if value then
            -- Connect to the ErrorMessageChanged event
            connection = game:GetService("GuiService").ErrorMessageChanged:Connect(function()
                wait(0.1)
                game:GetService("TeleportService"):Teleport(game.PlaceId)
            end)
    else
            -- Disconnect from the event if it was previously connected
            if connection then
                connection:Disconnect()
                connection = nil
            end
    end
    end)
    
    Options.RejoinKicked:SetValue(false)
    local Toggle = Tabs.AutoFarm:AddToggle("AntiAFK", {Title = "Anti AFK", Default = false })
    
    local antiAfkConnection -- Declare a variable to hold the connection for anti-AFK
    
    Toggle:OnChanged(function(value)
    if value then
            -- Connect to the Idled event for anti-AFK
            local LocalPlayer = game:GetService("Players").LocalPlayer
            local VirtualUser = game:GetService("VirtualUser")
            
            antiAfkConnection = LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
    else
            -- Disconnect from the Idled event if it was previously connected
            if antiAfkConnection then
                antiAfkConnection:Disconnect()
                antiAfkConnection = nil
            end
    end
    end)
    
    Options.AntiAFK:SetValue(false)
    local AutoFarmConfig = Tabs.AutoFarm:AddSection("Auto farm Configuration")
    
    local distanceM = 0
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    
    local lp = Players.LocalPlayer
    
    local Slider1 = Tabs.AutoFarm:AddSlider("MDistance", {
        Title = "Murderer Distance Trigger",
        Description = "How many studs to trigger Auto FE Invisible",
        Default = distanceM,
        Min = 0,
        Max = 100,
        Rounding = 1,
        Callback = function(Value)
            distanceM = tonumber(Value) -- ensure distanceM is a number
        end
    })
    
    Slider1:SetValue(distanceM)
    
    -- Initialize the AutoToggle for "AutoFEInvi"
    local AutoToggle = Tabs.AutoFarm:AddToggle("AutoFEInvi", {Title = "Auto FE Invisible if Murderer is near", Default = false})
    local autoInvisible = false
    local isinvisible = false -- assuming this variable controls invisibility
    
    AutoToggle:OnChanged(function(value)
        autoInvisible = value
    
        if autoInvisible and Murder then
            local murdererPlayer = Players:FindFirstChild(Murder)
            if murdererPlayer then
                local murdererCharacter = murdererPlayer.Character
                if murdererCharacter and murdererCharacter:FindFirstChild("HumanoidRootPart") then
                    local localUserId = Players.LocalPlayer.UserId
                    local murdererUserId = murdererPlayer.UserId
    
                    -- Check if the local player is the murderer
                    if localUserId == murdererUserId then
                        autoInvisible = false
                        Options.AutoFEInvi:SetValue(false)
                        Options.FEInvisible:SetValue(false)
                    end
                end
            end
        end
    end)
    
    Options.AutoFEInvi:SetValue(false)
    
    -- Function to check if the local player has a knife or the role of Murderer
    local function checkLocalPlayerRole()
        local character = Players.LocalPlayer.Character
        if character then
            -- Check if the local player has a knife
            local hasKnife = character:FindFirstChild("Knife") ~= nil
            -- Check if the local player's role is Murderer
            local isMurderer = Murder == Players.LocalPlayer.Name
    
            if hasKnife or isMurderer then
                autoInvisible = false
                Options.AutoFEInvi:SetValue(false)
                Options.FEInvisible:SetValue(false)
            else
                -- Enable AutoFEInvi if AutoFarmCoin or AutoFarmEggs is true
                if Options.AutoFarmCoin.Value or Options.AutoFarmEggs.Value then
                    autoInvisible = true
                    Options.AutoFEInvi:SetValue(true)
                end
            end
        end
    end
    
    -- Function to check the distance between the local player and the murderer
    local function checkDistance()
        if autoInvisible and Murder then
            local murdererPlayer = Players:FindFirstChild(Murder)
            local localCharacter = Players.LocalPlayer.Character
    
            if murdererPlayer and murdererPlayer.Character and localCharacter then
                local murdererRootPart = murdererPlayer.Character:FindFirstChild("HumanoidRootPart")
                local localRootPart = localCharacter:FindFirstChild("HumanoidRootPart")
    
                if murdererRootPart and localRootPart then
                    local distance = (murdererRootPart.Position - localRootPart.Position).Magnitude
                    if distance <= distanceM then -- ensure distanceM is a number
                        if not isinvisible then
                            isinvisible = true
                            Options.FEInvisible:SetValue(true)
                            print("Turning FEInvisible ON")
                        end
                    else
                        if isinvisible then
                            isinvisible = false
                            Options.FEInvisible:SetValue(false)
                            print("Turning FEInvisible OFF")
                        end
                    end
                end
            end
        end
    end
    
    -- Call the role check function initially after a short delay to ensure Options are initialized
    delay(0.1, function()
        checkLocalPlayerRole()
    end)
    
    -- Connect the distance check function to RenderStepped
    RunService.RenderStepped:Connect(checkDistance)
    
    -- Periodically check the local player's role
    RunService.RenderStepped:Connect(checkLocalPlayerRole)

    
        
    
            
    
    
    local Void = false
    local Toggle = Tabs.AutoFarm:AddToggle("TPtoVoid", {Title = "Teleport to Void if done collecting Coins \n(Only for Coin or Egg only)", Default = false })
    
    Toggle:OnChanged(function(value)
    Void = value
    
    end)
    
    Options.TPtoVoid:SetValue(false)
    
    local moveSpeed = 50
    local delay = math.random(1.7, 2.1)
    
    -- Create a slider for teleport walk speed
    local Slider = Tabs.AutoFarm:AddSlider("TweenSpeed", {
        Title = "Change AutoFarm Speed",
        Description = "NOTE: The higher the value can be kick faster.",
        Default = moveSpeed,
        Min = 10,
        Max = 100,
        Rounding = 1,
        Callback = function(Value)
            moveSpeed = Value
        end
    })
    
    -- Ensure slider initial value is set correctly
    Slider:SetValue(moveSpeed)
    
    -- Create a slider for teleport walk speed
    local SDelay = Tabs.AutoFarm:AddSlider("ChangeDelay", {
        Title = "Change AutoFarm Delay",
        Description = "NOTE: Make sure you change the tween speed to 10-20 so it wouldn't kick faster",
        Default = delay,
        Min = 0.1,
        Max = 10,
        Rounding = 1,
        Callback = function(Value)
            delay = tonumber(Value)  -- Ensure the delay is treated as a number
            if delay < 1.5 then
                moveSpeed = math.random(10, 20)
            else
                moveSpeed = 50  -- or whatever your default value should be
            end
        end
    })
    
    -- Ensure slider initial value is set correctly
    SDelay:SetValue(delay)
    
    local FarmingMethod = Tabs.AutoFarm:AddSection("Select Farming Method")
    
    
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    -- Movement parameters
      -- Adjusted move speed for faster movement
    local arrivalThreshold = 1  -- Distance threshold to stop moving
    local touchedCoins = {}  -- Table to track touched Coin_Server parts
    local isAutoFarming = false  -- Flag to track if auto farming is enabled
    local TELEPORT_DISTANCE_THRESHOLD = 1000
    local isMovingToCoin = false  -- Flag to track if currently moving towards a coin
    local characterAddedConnection = nil  -- Variable to store the CharacterAdded connection
    local characterRemovingConnection = nil  -- Variable to store the CharacterRemoving connection
    
    -- Function to find the nearest untapped Coin_Server part
    local function findNearestUntappedCoin()
        local nearestCoin = nil
        local nearestDistance = math.huge
    
        -- Check if player and player.Character are valid
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local workspace = game:GetService("Workspace")
            local normalContainer = workspace:FindFirstChild("Normal")
            if normalContainer then
                local coinContainer = normalContainer:FindFirstChild("CoinContainer")
                if coinContainer then
                    local coins = coinContainer:GetChildren()
    
                    -- Find the nearest "Coin_Server" part that hasn't been touched yet
                    for i, coin in ipairs(coins) do
                        if coin:IsA("Part") and coin.Name == "Coin_Server" and not touchedCoins[coin] then
                            local distance = (coin.Position - player.Character.HumanoidRootPart.Position).magnitude
                            if distance < nearestDistance then
                                nearestCoin = coin
                                nearestDistance = distance
                            end
                        end
                    end
                end
            end
        end
    
        return nearestCoin
    end
    
    -- Function to move to the nearest untapped Coin_Server part with smooth transition
    local function moveToCoinServer()
        -- Find the nearest untapped Coin_Server part
        local nearestCoin = findNearestUntappedCoin()
    
        if nearestCoin then
            print("Moving towards Coin or BeachBall.")
            isMovingToCoin = true
    
            local targetPosition = nearestCoin.Position + Vector3.new(0, 0, 0)  -- Target slightly above the part
    
            -- Teleport if too far
            if (nearestCoin.Position - player.Character.HumanoidRootPart.Position).magnitude > TELEPORT_DISTANCE_THRESHOLD then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(nearestCoin.Position)
                wait(0.1)  -- Wait briefly to ensure character updates position
            end
    
            -- Move the character towards the nearest untapped "Coin_Server" part gradually
            while isAutoFarming and isMovingToCoin do
                if not player.Character or not player.Character.HumanoidRootPart then
                    isMovingToCoin = false  -- Stop moving if character or HumanoidRootPart is nil
                    break
                end
    
                local currentPos = player.Character.HumanoidRootPart.Position
                local direction = (targetPosition - currentPos).unit
                local distanceToTarget = (targetPosition - currentPos).magnitude
    
                if distanceToTarget <= arrivalThreshold then
                    print("Arrived at Coin or BeachBall")
                    isMovingToCoin = false
                    break
                end
    
                -- Move towards the target
                player.Character.HumanoidRootPart.CFrame = CFrame.new(currentPos + direction * moveSpeed * RunService.Heartbeat:Wait())
            end
    
            -- Mark the coin as touched
            touchedCoins[nearestCoin] = true
    
            wait(delay)
    
            -- Move to the next nearest untapped Coin_Server part if auto farming is enabled
            if isAutoFarming and not isMovingToCoin then
                -- Use coroutine to prevent blocking
                coroutine.wrap(moveToCoinServer)()
                
            end
        else
            print("Coin not found. Searching for Coin_Server...")
            isMovingToCoin = false
            
            wait(1)  -- Wait for a short period before searching again (customize as needed)
    
            -- If auto farming is enabled and not currently moving towards a coin, continue searching for the nearest coin
            if isAutoFarming and not isMovingToCoin then
                coroutine.wrap(moveToCoinServer)()
                
            end
        end
    end
    
    -- Function to teleport the player to the map with a delay
    local function teleportToMapWithDelay(delay)
    wait(delay)
    coroutine.wrap(moveToCoinServer)()
    end
    -- Function to handle character added (when player respawns)
    local function onCharacterAdded(character)
    player.Character = character
    touchedCoins = {}  -- Reset touchedCoins table when character resets
    isMovingToCoin = false  -- Reset moving to coin flag
    if isAutoFarming then
            -- Teleport to the map with a delay before starting auto farming again
            teleportToMapWithDelay(5)  -- Adjust the delay to 5 seconds as required
            if not isMovingToCoin then
                coroutine.wrap(moveToCoinServer)()
            end
    end
    end
    
    -- Function to handle character removing (when player dies)
    local function onCharacterRemoving()
    if isAutoFarming then
            print("Character removed. Stopping auto farming and teleporting to map...")
            isAutoFarming = false  -- Stop auto farming when character dies
            isMovingToCoin = false  -- Stop moving towards the coin
            teleportToMapWithDelay(5)  -- Teleport to map with a delay of 5 seconds
            isAutoFarming = true  -- Resume auto farming after teleporting (if toggle is still on)
            if not isMovingToCoin then
                coroutine.wrap(moveToCoinServer)()
            end
    end
    end
    
    -- Example toggle integration
    local Toggle = Tabs.AutoFarm:AddToggle("AutoFarmCoinEggs", {Title = "Auto Farm Coin and BeachBall", Default = false })
    
    Toggle:OnChanged(function(isEnabled)
    isAutoFarming = isEnabled
    if isAutoFarming then
            print("Auto Farm Coin enabled.")
            -- Connect the character added event handler only when auto farming is enabled
            characterAddedConnection = Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
            -- Connect the character removing event handler only when auto farming is enabled
            characterRemovingConnection = Players.LocalPlayer.CharacterRemoving:Connect(onCharacterRemoving)
            if not isMovingToCoin then
                coroutine.wrap(moveToCoinServer)()
            end
    else
            print("Auto Farm Coin disabled.")
            isMovingToCoin = false  -- Stop moving towards the coin if auto farming is disabled
            -- Disconnect the character added event handler when auto farming is disabled
            if characterAddedConnection then
                characterAddedConnection:Disconnect()
                characterAddedConnection = nil
            end
            -- Disconnect the character removing event handler when auto farming is disabled
            if characterRemovingConnection then
                characterRemovingConnection:Disconnect()
                characterRemovingConnection = nil
            end
            -- Optionally, you could stop the character here
    end
    end)
    
    -- Listen for new coins spawning
    local workspace = game:GetService("Workspace")
    workspace.ChildAdded:Connect(function(child)
    if child:IsA("Part") and child.Name == "Coin_Server" and isAutoFarming and not isMovingToCoin then
            coroutine.wrap(moveToCoinServer)()
    end
    end)
    
    
    
    -- Function to find the nearest untapped Coin_Server
    local function findNearestUntappedCoin()
        local nearestCoin = nil
        local nearestDistance = math.huge
    
        -- Check if player and player.Character are valid
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local normalContainer = game.Workspace:FindFirstChild("Normal")
            if normalContainer then
                local coinContainer = normalContainer:FindFirstChild("CoinContainer")
                if coinContainer then
                    local coins = coinContainer:GetChildren()
    
                    -- Find the nearest "Coin_Server" part that has "MainCoin" child and hasn't been touched yet
                    for _, coinServer in ipairs(coins) do
                        if coinServer:IsA("Part") and coinServer.Name == "Coin_Server" then
                            local coinVisual = coinServer:FindFirstChild("CoinVisual")
                            if coinVisual and coinVisual:FindFirstChild("MainCoin") and not touchedCoins[coinVisual.MainCoin] then
                                local distance = (coinVisual.MainCoin.Position - player.Character.HumanoidRootPart.Position).Magnitude
                                if distance < nearestDistance then
                                    nearestCoin = coinVisual.MainCoin
                                    nearestDistance = distance
                                end
                            end
                        end
                    end
                end
            end
        end
    
        return nearestCoin, nearestDistance
    end
    
    -- Function to move to the nearest untapped Coin_Server part with smooth transition
    local function moveToCoinServer()
        -- Find the nearest untapped Coin_Server part with MainCoin child
        local nearestCoin, nearestDistance = findNearestUntappedCoin()
    
        if nearestCoin then
            if nearestDistance > TELEPORT_DISTANCE_THRESHOLD then
                -- Teleport to the nearest coin if it's too far away
                player.Character.HumanoidRootPart.CFrame = CFrame.new(nearestCoin.Position)
                wait(0.1)  -- Wait briefly to ensure character updates position
            end
    
            -- Check again if auto farming is still enabled after teleportation
            if isAutoFarming then
                print("Moving towards Coin")
                isMovingToCoin = true
    
                local targetPosition = nearestCoin.Position
    
                -- Move the character towards the nearest untapped "Coin_Server" part gradually
                while isAutoFarming and isMovingToCoin do
                    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                        isMovingToCoin = false  -- Stop moving if character or HumanoidRootPart is nil
                        break
                    end
    
                    local currentPos = player.Character.HumanoidRootPart.Position
                    local direction = (targetPosition - currentPos).Unit
                    local distanceToTarget = (targetPosition - currentPos).Magnitude
    
                    if distanceToTarget <= arrivalThreshold then
                        print("Arrived at Coin")
                        isMovingToCoin = false
                        break
                    end
    
                    -- Move towards the target
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(currentPos + direction * moveSpeed * RunService.Heartbeat:Wait())
                end
    
                -- Mark the coin as touched
                touchedCoins[nearestCoin] = true
    
                wait(delay)
    
                -- Move to the next nearest untapped Coin_Server part if auto farming is enabled
                if isAutoFarming and not isMovingToCoin then
                    -- Use coroutine to prevent blocking
                    coroutine.wrap(moveToCoinServer)()
                end
            end
        else
            print("[ Hub ] Coin not Found.. Searching again...")
            isMovingToCoin = false
            
            if Void then
            wait(1)
            VoidSafe()
            end
            wait(1)  -- Wait for a short period before searching again (customize as needed)
    
            -- If auto farming is enabled and not currently moving towards a coin, continue searching for the nearest coin
            if isAutoFarming and not isMovingToCoin then
                coroutine.wrap(moveToCoinServer)()
            end
        end
    end
    
    -- Function to teleport the player to the map with a delay
    local function teleportToMapWithDelay(delay)
    wait(delay)
    coroutine.wrap(moveToCoinServer)()
    end
    
    -- Function to handle character added (when player respawns)
    local function onCharacterAdded(character)
    player.Character = character
    touchedCoins = {}  -- Reset touchedCoins table when character resets
    isMovingToCoin = false  -- Reset moving to coin flag
    if isAutoFarming then
            -- Teleport to the map with a delay before starting auto farming again
            teleportToMapWithDelay(5)  -- Adjust the delay to 5 seconds as required
            if not isMovingToCoin then
                coroutine.wrap(moveToCoinServer)()
            end
    end
    end
    
    -- Function to handle character removing (when player dies)
    local function onCharacterRemoving()
    if isAutoFarming then
            print("Character removed. Stopping auto farming and teleporting to map...")
            isAutoFarming = false  -- Stop auto farming when character dies
            isMovingToCoin = false  -- Stop moving towards the coin
            teleportToMapWithDelay(5)  -- Teleport to map with a delay of 5 seconds
            isAutoFarming = true  -- Resume auto farming after teleporting (if toggle is still on)
            if not isMovingToCoin then
                coroutine.wrap(moveToCoinServer)()
            end
    end
    end
    
    -- Example toggle integration
    local Toggle = Tabs.AutoFarm:AddToggle("AutoFarmCoin", {Title = "Auto Farm Coin Only", Default = false })
    
    Toggle:OnChanged(function(isEnabled)
    isAutoFarming = isEnabled
    if isAutoFarming then
            print("Auto Farm Coin enabled.")
            -- Connect the character added event handler only when auto farming is enabled
            characterAddedConnection = Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
            -- Connect the character removing event handler only when auto farming is enabled
            characterRemovingConnection = Players.LocalPlayer.CharacterRemoving:Connect(onCharacterRemoving)
            if not isMovingToCoin then
                coroutine.wrap(moveToCoinServer)()
            end
    else
            print("Auto Farm Coin disabled.")
            isMovingToCoin = false  -- Stop moving towards the coin if auto farming is disabled
            -- Disconnect the character added event handler when auto farming is disabled
            if characterAddedConnection then
                characterAddedConnection:Disconnect()
                characterAddedConnection = nil
            end
            -- Disconnect the character removing event handler when auto farming is disabled
            if characterRemovingConnection then
                characterRemovingConnection:Disconnect()
                characterRemovingConnection = nil
            end
            -- Optionally, you could stop the character here
    end
    end)
    
    -- Listen for new Coin_Server parts spawning
    local workspace = game:GetService("Workspace")
    workspace.ChildAdded:Connect(function(child)
    if child:IsA("Part") and child.Name == "Coin_Server" and child:FindFirstChild("CoinVisual") and child.CoinVisual:FindFirstChild("MainCoin") and isAutoFarming and not isMovingToCoin then
            coroutine.wrap(moveToCoinServer)()
    end
    end)
    
    
    -- Function to check if a part has TouchInterest and CoinVisual with WeldConstraint, and ignore parts with MainCoin
    local function hasTouchInterestAndCoinVisualWithWeldConstraint(part)
        if part:IsA("Part") then
            local touchInterest = part:FindFirstChild("TouchInterest")
            local coinVisual = part:FindFirstChild("CoinVisual")
            if touchInterest and coinVisual then
                local weldConstraint = coinVisual:FindFirstChild("WeldConstraint")
                local mainCoin = coinVisual:FindFirstChild("MainCoin")
                return weldConstraint ~= nil and mainCoin == nil
            end
        end
        return false
    end
    
    -- Function to find the nearest untapped Coin_Server part with TouchInterest and empty CoinVisual
    local function findNearestUntappedCoin()
        local nearestCoin = nil
        local nearestDistance = math.huge
    
        -- Check if player and player.Character are valid
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local normalContainer = game.Workspace:FindFirstChild("Normal")
            if normalContainer then
                local coinContainer = normalContainer:FindFirstChild("CoinContainer")
                if coinContainer then
                    local coins = coinContainer:GetChildren()
    
                    -- Find the nearest "Coin_Server" part with TouchInterest and empty CoinVisual
                    for _, coinServer in ipairs(coins) do
                        if hasTouchInterestAndCoinVisualWithWeldConstraint(coinServer) and not touchedCoins[coinServer] then
                            local distance = (coinServer.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if distance < nearestDistance then
                                nearestCoin = coinServer
                                nearestDistance = distance
                            end
                        end
                    end
                end
            end
        end
    
        return nearestCoin
    end
    
    -- Function to move to the nearest untapped Coin_Server part with smooth transition
    local function moveToCoinServer()
        -- Find the nearest untapped Coin_Server part with TouchInterest and empty CoinVisual
        local nearestCoin = findNearestUntappedCoin()
    
        if nearestCoin then
            print("Moving towards to the BeachBall")
            isMovingToCoin = true
    
            local targetPosition = nearestCoin.Position
    
            -- Teleport if too far
            if (nearestCoin.Position - player.Character.HumanoidRootPart.Position).Magnitude > TELEPORT_DISTANCE_THRESHOLD then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(nearestCoin.Position)
                wait(0.1)  -- Wait briefly to ensure character updates position
            end
    
            -- Move the character towards the nearest untapped "Coin_Server" part gradually
            while isAutoFarming and isMovingToCoin do
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                    isMovingToCoin = false  -- Stop moving if character or HumanoidRootPart is nil
                    break
                end
    
                local currentPos = player.Character.HumanoidRootPart.Position
                local direction = (targetPosition - currentPos).Unit
                local distanceToTarget = (targetPosition - currentPos).Magnitude
    
                if distanceToTarget <= arrivalThreshold then
                    print("Arrived at the Egg")
                    isMovingToCoin = false
                    break
                end
    
                -- Move towards the target
                player.Character.HumanoidRootPart.CFrame = CFrame.new(currentPos + direction * moveSpeed * RunService.Heartbeat:Wait())
            end
    
            -- Mark the coin as touched
            touchedCoins[nearestCoin] = true
    
            wait(delay)
    
            -- Move to the next nearest untapped Coin_Server part if auto farming is enabled
            if isAutoFarming and not isMovingToCoin then
                -- Use coroutine to prevent blocking
                coroutine.wrap(moveToCoinServer)()
            end
        else
            print("[ Hub ] Searching for BeachBall...")
            isMovingToCoin = false
            if Void then
            wait(1)
            VoidSafe()
            end
            wait(1)  -- Wait for a short period before searching again (customize as needed)
    
            -- If auto farming is enabled and not currently moving towards a coin, continue searching for the nearest coin
            if isAutoFarming and not isMovingToCoin then
                coroutine.wrap(moveToCoinServer)()
            end
        end
    end
    
    -- Function to teleport the player to the map with a delay
    local function teleportToMapWithDelay(delay)
    wait(delay)
    coroutine.wrap(moveToCoinServer)()
    end
    
    -- Function to handle character added (when player respawns)
    local function onCharacterAdded(character)
    player.Character = character
    touchedCoins = {}  -- Reset touchedCoins table when character resets
    isMovingToCoin = false  -- Reset moving to coin flag
    if isAutoFarming then
            -- Teleport to the map with a delay before starting auto farming again
            teleportToMapWithDelay(5)  -- Adjust the delay to 5 seconds as required
            if not isMovingToCoin then
                coroutine.wrap(moveToCoinServer)()
            end
    end
    end
    
    -- Function to handle character removing (when player dies)
    local function onCharacterRemoving()
    if isAutoFarming then
            print("Character removed. Stopping auto farming and teleporting to map...")
            isAutoFarming = false  -- Stop auto farming when character dies
            isMovingToCoin = false  -- Stop moving towards the coin
            teleportToMapWithDelay(5)  -- Teleport to map with a delay of 5 seconds
            isAutoFarming = true  -- Resume auto farming after teleporting (if toggle is still on)
            if not isMovingToCoin then
                coroutine.wrap(moveToCoinServer)()
            end
    end
    end
    
    -- Example toggle integration
    local Toggle = Tabs.AutoFarm:AddToggle("AutoFarmEggs", {Title = "Auto Farm BeachBall Only ", Default = false })
    
    Toggle:OnChanged(function(isEnabled)
    isAutoFarming = isEnabled
    if isAutoFarming then
            print("Auto Farm BeachBall enabled.")
            -- Connect the character added event handler only when auto farming is enabled
            characterAddedConnection = Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
            -- Connect the character removing event handler only when auto farming is enabled
            characterRemovingConnection = Players.LocalPlayer.CharacterRemoving:Connect(onCharacterRemoving)
            if not isMovingToCoin then
                coroutine.wrap(moveToCoinServer)()
            end
    else
            print("Auto Farm BeachBall disabled.")
            isMovingToCoin = false  -- Stop moving towards the coin if auto farming is disabled
            -- Disconnect the character added event handler when auto farming is disabled
            if characterAddedConnection then
                characterAddedConnection:Disconnect()
                characterAddedConnection = nil
            end
            -- Disconnect the character removing event handler when auto farming is disabled
            if characterRemovingConnection then
                characterRemovingConnection:Disconnect()
                characterRemovingConnection = nil
            end
            -- Optionally, you could stop the character here
    end
    end)
    
    -- Listen for new Coin_Server parts spawning
    local workspace = game:GetService("Workspace")
    workspace.ChildAdded:Connect(function(child)
    if child:IsA("Part") and child.Name == "Coin_Server" and isAutoFarming and not isMovingToCoin then
            coroutine.wrap(moveToCoinServer)()
    end
    end)
    
    
    
    
    
    Tabs.AutoFarm:AddParagraph({
                Title = "Scrolling Only",
                Content = "Ignore this is just for scrolling"
            })
            Tabs.AutoFarm:AddParagraph({
                Title = "Scrolling Only",
                Content = "Ignore this is just for scrolling"
            })
            Tabs.Main:AddParagraph({
                Title = "READ THIS",
                Content = "Because of New Update alot of script/hacks has been fix so im fixing a lot of it right now "
            })
    
    
    ---------------------------------------------------------------------------------AUTOFARM------------------------------------------------------------------------------------------------


    ---------------------------------EMOTES------------------------------------

    local AshMotes = false

Tabs.LEmotes:AddButton({
    Title = "Get all Emotes in Roblox",
    Description = "Get all emotes that are in the Store",
    Callback = function()
        if not AshMotes then
            AshMotes = true
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/RblxEmotes.lua", true))()
        else
            
            SendNotif("Already executed lol", "You Clicked this earlier lolll", 3)
        end
    end
})

Tabs.LEmotes:AddButton({

    Title = "Play Zen",
    Description = "",
    Callback = function()
        PlayZen()
    end
})

Tabs.LEmotes:AddButton({

    Title = "Play Dab",
    Description = "",
    Callback = function()
        PlayDab()
    end
})
Tabs.LEmotes:AddButton({

    Title = "Play Zombie",
    Description = "",
    Callback = function()
        PlayZombie()
    end
})
Tabs.LEmotes:AddButton({

    Title = "Play Floss",
    Description = "",
    Callback = function()
        PlayFloss()
    end
})
Tabs.LEmotes:AddButton({

    Title = "Play Headless",
    Description = "",
    Callback = function()
        PlayHeadless()
    end
})


    ------------------------------------EMOTES----------------------------------

    -----------------------------------SERVER------------------------------------

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
                            loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/ServerHop.lua", true))()
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



    ------------------------------------SERVER----------------------------------
    -------------------------------------------------------TELEPORTS---------------------------------------------------





    Tabs.Teleport:AddButton({
        Title = "TP to Lobby",
        Description = "Teleport to Spawn/ Lobby",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-108.5, 145, 0.6)
        end
    })
    
    Tabs.Teleport:AddButton({
        Title = "TP to Map",
        Description = "Teleport to map",
        Callback = function()
            for i,v in pairs(workspace:GetDescendants()) do
                if v.Name == "Spawn" then
                    TeleportPlayer(CFrame.new(v.Position), CFrame.new(0,2.5,0))
                elseif v.Name == "SpawnLocation" then
                    TeleportPlayer(CFrame.new(v.Position), CFrame.new(0,2.5,0))
                end
            end
        end
    })
    

    
    
    Tabs.Teleport:AddButton({
        Title = "TP to Murderer",
        Description = "Teleport to Murderer",
        Callback = function()
            local murderer = Players:FindFirstChild(Murder)
            if murderer then
                LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(murderer.Character:WaitForChild("HumanoidRootPart").Position)
            else
                print("Murderer not found.")
            end
        end
    })
    
    Tabs.Teleport:AddButton({
        Title = "TP to Sheriff or Hero (if available)",
        Description = "Teleport to Sheriff or Hero (if available)",
        Callback = function()
            local sheriff = Players:FindFirstChild(Sheriff)
            local hero = Players:FindFirstChild(Hero)
    
            if sheriff then
                LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(sheriff.Character:WaitForChild("HumanoidRootPart").Position)
            elseif hero then
                LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(hero.Character:WaitForChild("HumanoidRootPart").Position)
            else
                print("Sheriff and Hero not found or unavailable.")
            end
        end
    })
    
    
    
local Dropdown
local isResetting = false

function CreateDropdown()
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

function UpdateDropdownA()
    local newValues = GetOtherPlayers()
    isResetting = true
    Dropdown.Values = newValues  -- Update the dropdown values
    Dropdown:SetValue("")  -- Reset selected value to default
    isResetting = false
end

-- Connect to PlayerAdded and PlayerRemoving events to update the dropdown
game.Players.PlayerAdded:Connect(UpdateDropdownA)
game.Players.PlayerRemoving:Connect(UpdateDropdownA)

local lp = game.Players.LocalPlayer

-- Define the VoidSafe function
function VoidSafe()
-- Check if the "Safe Void Path" part already exists in the workspace
if not workspace:FindFirstChild("Safe Void Path") then
    -- Create and configure the part
    local safePart = Instance.new("Part")
    safePart.Name = "Safe Void Path"
    safePart.CFrame = CFrame.new(99999, 99995, 99999)
    safePart.Anchored = true
    safePart.Size = Vector3.new(300, 0.1, 300)
    safePart.Transparency = 0.5

    -- Parent the part to the workspace
    safePart.Parent = workspace
else
    
end

-- Teleport the local player to the specified coordinates
local lp = game.Players.LocalPlayer
if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
    lp.Character.HumanoidRootPart.CFrame = CFrame.new(99999, 100000, 99999)
else
    warn("Local player character or HumanoidRootPart not found")
end
end

-- Add a button to the teleport tab with the VoidSafe callback
Tabs.Teleport:AddButton({
Title = "Void (Safe)",
Description = "",
Callback = VoidSafe
})
    
Tabs.Teleport:AddButton({
        Title = "TP to Secret Room",
        Description = "Teleport to Lobby's Secret Room",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-152, 153, 113)
        end
    })





-------------------------------------------TELEPORT ENDS--------------------------------------------
    
    



-----------------------------------------------------------------------------VISUAL------------------------------------------------------------------------------------------





local DistanceTogg = Tabs.Visual:AddToggle("DistanceTog", {Title = "Show Distance", Default = false })

DistanceTogg:OnChanged(function(SeeNames)
if SeeNames then
    loadesp()
    AshESP.Distance = true
    AshESP.Distance = true
    Options.ESPRoles:SetValue(true)
else
    local success, error_message = pcall(function()
        task.wait(0.2) -- Wait for ESP to update (if necessary)
        loadesp()
        AshESP.Distance = false
        AshESP.Distance = false
    end)
    
    if not success then
        warn("Error while turning off names:", error_message)
    end
end
end)

Options.DistanceTog:SetValue(false)
    


        
local Toggle = Tabs.Visual:AddToggle("ChamsRoles", {Title = "Chams Roles", Default = false })
local Toggle1 = Tabs.Visual:AddToggle("ESPRoles", {Title = "ESP Name Roles", Default = false })

Toggle:OnChanged(function(SeeRoles)
if SeeRoles then
    SSeeRoles = true
    while SSeeRoles == true do
        rolesAsh = game:GetService("ReplicatedStorage"):FindFirstChild("GetPlayerData", true):InvokeServer()
        for i, v in pairs(rolesAsh) do
            if v.Role == "Murderer" then
                Murder = i
            elseif v.Role == "Sheriff" then
                Sheriff = i
            elseif v.Role == "Hero" then
                Hero = i
            end
        end
        CreateHighlight()
        UpdateHighlights()
        loadesp()
    
    end
else
    SSeeRoles = false
    task.wait(0.2)
    loadesp()
    
    HideHighlights()
end
end)

Toggle1:OnChanged(function(SeeNames)
if SeeNames then
    loadesp()
    AshESP.Names = true
    AshESP.NamesOutline = true
else
    local success, error_message = pcall(function()
        task.wait(0.2) -- Wait for ESP to update (if necessary)
        loadesp()
        AshESP.Names = false
        AshESP.NamesOutline = false
    end)
    
    if not success then
        warn("Error while turning off names:", error_message)
    end
end
end)



Options.ESPRoles:SetValue(false)
Options.ChamsRoles:SetValue(false)

local Toggle = Tabs.Visual:AddToggle("ESPGun", {Title = "ESP Gun", Default = false })

Toggle:OnChanged(function(SeeGun)
    if SeeGun then
        SSeeGun = true
        spawn(function()
            while SSeeGun do
                repeat wait() until workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("GunDrop")
                local normal = workspace:FindFirstChild("Normal")
                if normal then
                    local gunDrop = normal:FindFirstChild("GunDrop")
                    if gunDrop and not gunDrop:FindFirstChild("Esp_gun") then
                        SendNotif("Gun Found", "Gun has been Drop", 3)
                        
                        -- Create the Highlight instance
                        local espgunhigh = Instance.new("Highlight", gunDrop)
                        espgunhigh.Name = "Esp_gun"
                        espgunhigh.FillColor = Color3.fromRGB(0, 255, 0)
                        espgunhigh.OutlineTransparency = 1
                        espgunhigh.FillTransparency = 0

                        -- Create the BillboardGui instance
                        local billboardGui = Instance.new("BillboardGui")
                        billboardGui.Name = "GunBillboardGui"
                        billboardGui.Adornee = gunDrop
                        billboardGui.Size = UDim2.new(0, 50, 0, 25)
                        billboardGui.StudsOffset = Vector3.new(0, 2, 0)
                        billboardGui.AlwaysOnTop = true

                        -- Create a TextLabel for the BillboardGui
                        local textLabel = Instance.new("TextLabel")
                        textLabel.Size = UDim2.new(1, 0, 1, 0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.Text = "Gun Here"
                        textLabel.TextColor3 = Color3.fromRGB(97, 62, 167)
                        textLabel.TextScaled = true
                        textLabel.Font = Enum.Font.SourceSansBold
                        textLabel.TextStrokeTransparency = 0
                        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        textLabel.Parent = billboardGui

                        billboardGui.Parent = gunDrop
                    end
                end
            end
        end)
    else
        SSeeGun = false
        task.wait(0.2)
        local normal = workspace:FindFirstChild("Normal")
        if normal then
            local gunDrop = normal:FindFirstChild("GunDrop")
            if gunDrop and gunDrop:FindFirstChild("Esp_gun") then
                gunDrop.Esp_gun:Destroy()
            end
        end
    end
end)

Options.ESPGun:SetValue(false)


local Toggle = Tabs.Visual:AddToggle("Xray", {Title = "Xray", Default = false})

local function scan(z, t)
for _, i in pairs(z:GetChildren()) do
    if i:IsA("BasePart") and not i.Parent:FindFirstChild("Humanoid") and not i.Parent.Parent:FindFirstChild("Humanoid") then
        i.LocalTransparencyModifier = t
    end
    scan(i, t)
end
end

Toggle:OnChanged(function(value)
if value then
    scan(workspace, 0.9)
else
    scan(workspace, 0)
end
end)

Options.Xray:SetValue(false)




------------------------------------------------------------------------VISUAL ENDS---------------------------------------------------------------------------------------------
    
    
    
    



































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
local function setDraggable(draggable)
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
local function toggleButtonVisibility(visible)
    button.Visible = visible
end

Tabs.Settings:AddParagraph({
        Title = "To open Window from Chat just say:",
        Content = ".ash"
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
    SendNotif("Feedback has been sent to Ashbornn Thank you.", "Thank you for giving feedback", 3)
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

local player = game.Players.LocalPlayer

-- Define the function you want to execute when ".ash" is typed
local function openWindow()
Window:Minimize()
end

local function notifyAndSet(option, value, title, content)
option:SetValue(value)
Fluent:Notify({
    Title = title,
    Content = content,
    Duration = 3
})
end

local function executeCommand(command)
local commands = {
    ["/e ash"] = openWindow,
    ["/e c1"] = function() notifyAndSet(Options.ChamsRoles, true, "Chams Turned On", "Chams has been turned on.") end,
    ["/e c0"] = function() notifyAndSet(Options.ChamsRoles, false, "Chams Turned Off", "Chams has been turned off.") end,
    ["/e e1"] = function() notifyAndSet(Options.ESPRoles, true, "ESPRoles Turned On", "ESPRoles has been turned on.") end,
    ["/e e0"] = function() notifyAndSet(Options.ESPRoles, false, "ESPRoles Turned Off", "ESPRoles has been turned off.") end,
    ["/e s1"] = function() notifyAndSet(Options.SilentAIM1, true, "Silent Aim Turned On", "Silent Aim has been turned on.") end,
    ["/e s0"] = function() notifyAndSet(Options.SilentAIM1, false, "Silent Aim Turned Off", "Silent Aim has been turned off.") end,
    ["/e ka1"] = function() notifyAndSet(Options.KnifeAura, true, "Knife Aura Turned On", "Knife Aura has been turned on.") end,
    ["/e ka0"] = function() notifyAndSet(Options.KnifeAura, false, "Knife Aura Turned Off", "Knife Aura has been turned off.") end,
    ["/e k1"] = function() notifyAndSet(Options.AutoKillAll, true, "Auto Kill All Turned On", "Auto Kill All has been turned on.") end,
    ["/e k0"] = function() notifyAndSet(Options.AutoKillAll, false, "Auto Kill All Turned Off", "Auto Kill All has been turned off.") end,
    ["/e eg1"] = function() notifyAndSet(Options.ESPGun, true, "ESP Gun Turned On", "ESP Gun has been turned on.") end,
    ["/e eg2"] = function() notifyAndSet(Options.ESPGun, false, "ESP Gun Turned Off", "ESP Gun has been turned off.") end,
    ["/e gg"] = function() 
        local player = game.Players.LocalPlayer

        if not IsAlive(player) then
            SendNotif("You're not alive.", "Please wait for the new round to grab the gun.", 3)
            return
        end

        if player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Gun")) then
            SendNotif("You already have the Gun Lolll", "Bruhh really??", 3)
            return
        end

        if player.Character then
            local gundr = workspace:FindFirstChild("GunDrop")
            if gundr then
                local oldpos = player.Character.HumanoidRootPart.CFrame
                game:GetService("ReplicatedStorage").Remotes.Gameplay.Stealth:FireServer(true)
                wait(2)
                repeat
                    player.Character.HumanoidRootPart.CFrame = gundr.CFrame * CFrame.Angles(math.rad(90), math.rad(0), math.rad(0))
                    task.wait()
                    player.Character.HumanoidRootPart.CFrame = gundr.CFrame * CFrame.Angles(math.rad(-90), math.rad(0), math.rad(0))
                    task.wait()
                until not gundr:IsDescendantOf(workspace)
                game:GetService("ReplicatedStorage").Remotes.Gameplay.Stealth:FireServer(false)
                player.Character.HumanoidRootPart.CFrame = oldpos
                oldpos = false
                player.Character.Humanoid:ChangeState(1)
            else
                SendNotif("Gun not Found", "Wait for the Sheriff's death to grab the Gun.", 3)
            end
        end
    end,
    ["lol"] = function()
        print("lol")
    end,
    ["huh"] = function()
        print("He said Huh lollll")
    end
}

if commands[command] then
    commands[command]()
end
end

-- Listen for chat messages
local debounce = {}  -- Table to track if each command is currently debounced
player.Chatted:Connect(function(message)
if not debounce[message] then
    debounce[message] = true
    executeCommand(message)
    wait(1)  -- Adjust the delay if needed
    debounce[message] = false  -- Reset debounce after a delay
end
end)

-- Addons:
    -- SaveManager (Allows you to have a configuration system)
    -- InterfaceManager (Allows you to have an interface management system)

    -- Hand the library over to our managers
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)

    -- Ignore keys that are used by ThemeManager.
    -- (we don't want configs to save themes, do we?)
    SaveManager:IgnoreThemeSettings()

    -- You can add indexes of elements the save manager should ignore
    SaveManager:SetIgnoreIndexes({})

    -- use case for doing it this way:
    -- a script hub could have themes in a global folder
    -- and game configs in a separate folder per game
    InterfaceManager:SetFolder("Hub")
    SaveManager:SetFolder("Hub/MM2")

    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)

    Window:SelectTab(1)

    -- You can use the SaveManager:LoadAutoloadConfig() to load a config
    -- which has been marked to be one that auto loads!
    SaveManager:LoadAutoloadConfig()
    

local TimeEnd = tick()
local TotalTime = string.format("%.2f", math.abs(TimeStart - TimeEnd))
SendNotif("Hub", "Successfully loaded the script in " .. TotalTime .. "s.", 3)
