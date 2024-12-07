repeat task.wait() until game:IsLoaded()

TimeStart = tick()

local Fluent = loadstring(game:HttpGet("https://pastebin.com/raw/tiNshBCS"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local cloneref = cloneref or function(o) return o end

Player = cloneref(game:GetService("Players"))
Workspace = cloneref(game:GetService("Workspace"))
StarterGui = cloneref(game:GetService("StarterGui"))
LocalPlayer = cloneref(game.Players.LocalPlayer)
Player = cloneref(game.Players.LocalPlayer)
HttpService = cloneref(game:GetService("HttpService"))
ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
UserInputService = cloneref(game:GetService("UserInputService"))
virtualInput = cloneref(game:GetService("VirtualInputManager"))
Character = cloneref(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
Humanoid = cloneref(Character:WaitForChild("Humanoid"))
HumanoidRootPart = cloneref(Character:WaitForChild("HumanoidRootPart"))
runService = cloneref(game:GetService("RunService"))

player = cloneref(game:GetService("Players").LocalPlayer)
playerGui = cloneref(player:WaitForChild("PlayerGui"))
GuiService = cloneref(game:GetService("GuiService"))
coreGui = cloneref(game:GetService("CoreGui"))


VirtualUser = cloneref(game:GetService("VirtualUser"))
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

function randomString()
	local length = math.random(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

character = player.Character or player.CharacterAdded:Wait()

queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)

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
        Main = Window:AddTab({ Title = "Main", Icon = "house" }),
        Fish = Window:AddTab({ Title = "Fishing", Icon = "fish" }),
        Purchase = Window:AddTab({ Title = "Purchase", Icon = "shopping-cart"}),
        Teleport = Window:AddTab({ Title = "Teleport", Icon = "wand-sparkles" }),
        Appraise = Window:AddTab({ Title = "NPC" , Icon = "user"}),
        Misc = Window:AddTab({ Title = "Misc", Icon = "circle-alert" }),
        Server = Window:AddTab({ Title = "Server", Icon = "server" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

Window:Minimize()

function SendNotif(title, content, time)
    Fluent:Notify({
            Title = title,
            Content = content,
            Duration = time
    })
    end

Options = Fluent.Options

do

    function TeleportToPlayer(playerName)
        local targetPlayer = game.Players:FindFirstChild(playerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
        end
end

function isReelBarActive()
    local reel = player.PlayerGui:FindFirstChild("reel")
    if reel then
        return reel:FindFirstChild("bar") ~= nil
    end
    return false
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

function isShakeUIActive()
    local shakeui = player.PlayerGui:FindFirstChild("shakeui")
    if shakeui then
        return shakeui ~= nil
    end
    return false
end

local noclip = false
function toggleNoclip()
    noclip = not noclip
    local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    if character then
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not noclip 
            end
        end
    end
end
runService.RenderStepped:Connect(function()
    if noclip then
        local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        if character then
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

AutoFreeze = false
function rememberPosition()
    if AutoFreeze then
        local rootPart = character:WaitForChild("HumanoidRootPart")
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Parent = rootPart
        end
        if not bodyGyro then
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyGyro.D = 100
            bodyGyro.P = 10000
            bodyGyro.Parent = rootPart
        end
        if not initialCFrame then
            initialCFrame = rootPart.CFrame
            bodyGyro.CFrame = initialCFrame
        end
        rootPart.CFrame = initialCFrame
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
        initialCFrame = nil
    end
end

runService.RenderStepped:Connect(rememberPosition)

local velocityHandlerName = "VelocityHandler"
local gyroHandlerName = "GyroHandler"
local flySpeed = 1 
local isFlying = false
local mfly1, mfly2 

function getRoot(character)
    return character:FindFirstChild("HumanoidRootPart")
end

function startFlying()
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

	mfly2 = runService.RenderStepped:Connect(function()
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

function startHovering()
	isFlying = true
	FLYING = true
	local root = getRoot(LocalPlayer.Character)
	local v3none = Vector3.new()
	local v3zero = Vector3.new(0, 0, 0)
	local v3inf = Vector3.new(9e9, 9e9, 9e9)

	local controlModule = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
	local bv = Instance.new("BodyVelocity")
	bv.Name = velocityHandlerName
	bv.Parent = root
	bv.MaxForce = v3zero
	bv.Velocity = v3none

	local bg = Instance.new("BodyGyro")
	bg.Name = gyroHandlerName
	bg.Parent = root
	bg.MaxTorque = v3inf
	bg.P = 1000
	bg.D = 50
	bg.CFrame = root.CFrame -- Keep character orientation static

	mfly1 = LocalPlayer.CharacterAdded:Connect(function()
		local bv = Instance.new("BodyVelocity")
		bv.Name = velocityHandlerName
		bv.Parent = root
		bv.MaxForce = v3zero
		bv.Velocity = v3none

		local bg = Instance.new("BodyGyro")
		bg.Name = gyroHandlerName
		bg.Parent = root
		bg.MaxTorque = v3inf
		bg.P = 1000
		bg.D = 50
		bg.CFrame = root.CFrame
	end)

	mfly2 = runService.RenderStepped:Connect(function()
		root = getRoot(LocalPlayer.Character)
		if LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") and root:FindFirstChild(velocityHandlerName) and root:FindFirstChild(gyroHandlerName) then
			local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
			local VelocityHandler = root:FindFirstChild(velocityHandlerName)
			local GyroHandler = root:FindFirstChild(gyroHandlerName)

			VelocityHandler.MaxForce = v3inf
			GyroHandler.MaxTorque = v3inf
			if not vfly then humanoid.PlatformStand = true end
			VelocityHandler.Velocity = v3none
			GyroHandler.CFrame = root.CFrame
		end
	end)
end



function stopFlying()
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


local teleportMethod = "Instant"
local moveSpeed = 100
local arrivalThreshold = 1
local slowDownDistance = 20
local isTeleporting = false

function TeleportPlayer(TargetCFrame)
    local wasAutoFreezeEnabled = AutoFreeze
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if rootPart then
        local targetPosition = TargetCFrame.Position + Vector3.new(0, 3, 0)

        isTeleporting = true

        if wasAutoFreezeEnabled then
            AutoFreeze = false
        end

        if teleportMethod == "Instant" then
            rootPart.CFrame = CFrame.new(targetPosition)
        else
            repeat
                local distance = (targetPosition - rootPart.Position).Magnitude
                local speed = distance < slowDownDistance and math.clamp(distance, 50, moveSpeed) or moveSpeed
                local direction = (targetPosition - rootPart.Position).Unit
                rootPart.CFrame = CFrame.new(rootPart.Position + direction * speed * game:GetService("RunService").Heartbeat:Wait())
            until (targetPosition - rootPart.Position).Magnitude <= arrivalThreshold
        end

        task.wait(0.1)
        isTeleporting = false

        if wasAutoFreezeEnabled then
            AutoFreeze = true
        end
    end
end
local bodyVelocity, bodyGyro, initialCFrame

    --------------------------------------------------------------------------------FISH------------------------------------------------------------------------------------------

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
            setclipboard("https://discord.com/invite/nzXkxej9wa")
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

-- OptimizeGame function
function OptimizeGame()
    local decalsyeeted = false
    local g = game
    local w = g.Workspace
    local l = g.Lighting
    local t = w.Terrain
    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 1
    l.GlobalShadows = false
    l.FogEnd = 9e9
    l.Brightness = 0
    settings().Rendering.QualityLevel = "Level01"
    for i, v in pairs(g:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") then
            v.Enabled = false
        elseif v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.TextureID = 10385902758728957
        end
    end
    for i, e in pairs(l:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
            e.Enabled = false
        end
    end
end

Tabs.Main:AddButton({
    Title = "Anti-Lag V2",
    Callback = function()
        OptimizeGame()
    end
})

Tabs.Main:AddButton({
    Title = "Anti-Lag",
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

local isAutoClicking = false
local tappingMethod = "UI Nav"  -- Set default to UI Nav for this version

function click_this_gui(to_click)
    if to_click and to_click:IsA("GuiObject") and to_click.Visible then
        if tappingMethod == "Cursor" then
            -- Cursor method (using mouse click positions)
            local inset = GuiService:GetGuiInset()
            local absoluteSize = to_click.AbsoluteSize
            local offset = { x = absoluteSize.X / 2, y = absoluteSize.Y / 2 }

            local x = to_click.AbsolutePosition.X + offset.x
            local y = to_click.AbsolutePosition.Y + offset.y
            
            
            to_click.Size = UDim2.new(0, 150, 0, 150)

            virtualInput:SendMouseButtonEvent(x + inset.X, y + inset.Y, 0, true, playerGui, 1)  -- Mouse down
            virtualInput:SendMouseButtonEvent(x + inset.X, y + inset.Y, 0, false, playerGui, 1) -- Mouse up

        elseif tappingMethod == "UI Nav" then
            -- UI Nav method (using SelectedObject and Return key)
            if to_click and to_click:IsA("GuiObject") then
            GuiService.SelectedObject = to_click
            end
            if GuiService.SelectedObject == to_click and to_click and to_click.Visible then
                virtualInput:SendKeyEvent(true, Enum.KeyCode.Return, false, game)  -- Key down
                virtualInput:SendKeyEvent(false, Enum.KeyCode.Return, false, game) -- Key up
            end
        end
    else
        warn("-- Unable to click, to_click is not valid or not visible.")
    end
end

function autoClick()
    local shakeUI = playerGui:FindFirstChild("shakeui")
    if not shakeUI then return end

    local button = shakeUI.safezone and shakeUI.safezone:FindFirstChild("button")
    if button and button:IsA("ImageButton") and isAutoClicking then
        click_this_gui(button)
    end
end

-- Set up the Auto Shake toggle
AutoShakeToggle = Tabs.Fish:AddToggle("AutoShake", {Title = "Auto Shake", Default = false})
local autoClickCoroutine

AutoShakeToggle:OnChanged(function(value)
    isAutoClicking = value
    if value then
        autoClickCoroutine = coroutine.create(function()
            while isAutoClicking do
                autoClick()
                if tappingMethod == "Cursor" then
                task.wait(0.05)  -- Fast click rate
                elseif tappingMethod == "UI Nav" then
                task.wait()
                end
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

-- Dropdown for selecting tapping method
ShakeTap = Tabs.Fish:AddDropdown("ShakeTap", {
    Title = "Shake tapping method",
    Values = {"UI Nav", "Cursor"},
    Multi = false,
    Default = "UI Nav",
})

ShakeTap:OnChanged(function(value)
    tappingMethod = value
end)

-- Define player


-- Initial reeling method selection
local reelingmethod = "Safe Reeling"

-- Dropdown for selecting tapping method
local ReelingDropdown = Tabs.Fish:AddDropdown("ReelingMethod", {
    Title = "Reeling Method",
    Values = {"Safe Reeling","Safe Reeling Perfect","Instant Perfect", "Instant not perfect"},
    Multi = false,
    Default = "Safe Reeling",
})

ReelingDropdown:OnChanged(function(value)
    reelingmethod = value
end)

-- Reel GUI Path
local isAutoCatch = false
AutoCatching = Tabs.Fish:AddToggle("AutoCatch", {Title = "Auto Reel", Default = false })
AutoCatching:OnChanged(function(value)
    isAutoCatch = value
end)

Options.AutoCatch:SetValue(false)

function startCatching()
    local reelBar = player.PlayerGui:FindFirstChild("reel") and player.PlayerGui.reel:FindFirstChild("bar")
    if reelBar and isAutoCatch then
        game:GetService("ReplicatedStorage").events.reelfinished:FireServer(100, true)
    end
end

function startCatchingNot() 
    local reelBar = player.PlayerGui:FindFirstChild("reel") and player.PlayerGui.reel:FindFirstChild("bar")
    if reelBar and isAutoCatch then
        game:GetService("ReplicatedStorage").events.reelfinished:FireServer(100, false)
    end
end

function syncPositions() 
    local reel = player.PlayerGui:FindFirstChild("reel")
    if not reel then return end 

    local bar = reel:FindFirstChild("bar")
    if not bar then return end

    local fish = bar:FindFirstChild("fish")
    local playerBar = bar:FindFirstChild("playerbar")

    if fish and playerBar and isAutoCatch then
        task.wait(3)
        playerBar.Position = fish.Position 
    end
end

function syncPositionsPerfect() 
    local reel = player.PlayerGui:FindFirstChild("reel")
    if not reel then return end 

    local bar = reel:FindFirstChild("bar")
    if not bar then return end

    local fish = bar:FindFirstChild("fish")
    local playerBar = bar:FindFirstChild("playerbar")

    if fish and playerBar and isAutoCatch then
        playerBar.Position = fish.Position 
    end
end

local lastCatchTime = 0
local delayBetweenCatches = 2

runService.RenderStepped:Connect(function()
    if isAutoCatch then
        if reelingmethod == "Safe Reeling" then
            syncPositions()
        elseif reelingmethod == "Safe Reeling Perfect" then
            syncPositionsPerfect()
        elseif reelingmethod == "Instant Perfect" or reelingmethod == "Instant not perfect" then
            local currentTime = os.clock()
            if currentTime - lastCatchTime >= delayBetweenCatches then
                lastCatchTime = currentTime
                
                if reelingmethod == "Instant Perfect" then
                    startCatching()
                elseif reelingmethod == "Instant not perfect" then
                    startCatchingNot()
                end
            end
        end
    end
end)


local targetPositionX = 55
local targetPositionY = 208
local stopCasting, isAutoCasting = false, false
local castDelay = 2

-- Check if a rod is equipped
function isRodEquipped()
    if player.Character then
        local tool = player.Character:FindFirstChildWhichIsA("Tool")
        return tool and tool.Name:lower():find("rod")
    end
    return false
end

-- Equip a rod from the backpack
function equipRod()
    local backpack = player.Backpack
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("rod") then
            if player.Character and not player.Character:FindFirstChild(tool.Name) then
                player.Character.Humanoid:EquipTool(tool)
            end
            return tool
        end
    end
    return nil
end

-- Ensure the rod is always equipped during auto-casting
function ensureRodEquipped()
    while isAutoCasting do
        if not isRodEquipped() then
            equipRod()
        end
        task.wait(0.1) -- Check frequently to maintain the rod's equipped state
    end
end

-- Simulate cursor-based casting
function simulateCasting()
    virtualInput:SendMouseButtonEvent(targetPositionX, targetPositionY, 0, true, player.PlayerGui, 1) -- Mouse down
    wait(math.random(1, 2.5))
    virtualInput:SendMouseButtonEvent(targetPositionX, targetPositionY, 0, false, player.PlayerGui, 1) -- Mouse up
end

-- Dropdown to select casting method
local castingMethod = "Cursor"
local CastingMethodDropDown = Tabs.Fish:AddDropdown("ReelCastingMethod", {
    Title = "Select Casting Method",
    Values = {"Cursor", "Instant"},
    Multi = false,
    Default = "Cursor",
})

CastingMethodDropDown:OnChanged(function(value)
    castingMethod = value
end)

function reelCasting()
    while isAutoCasting do
        repeat task.wait() until not isShakeUIActive()

        if not stopCasting then
            local equippedTool = player.Character:FindFirstChildWhichIsA("Tool")

            if not equippedTool or not string.find(equippedTool.Name:lower(), "rod") then
                equippedTool = equipRod()
            end

            if equippedTool and string.find(equippedTool.Name:lower(), "rod") then
                if castingMethod == "Cursor" then
                    simulateCasting()
                elseif castingMethod == "Instant" then
                    local events = equippedTool:FindFirstChild("events")
                    if events then
                        local castEvent = events:FindFirstChild("cast")
                        if castEvent then
                            pcall(function()
                                castEvent:FireServer(100, 1)
                            end)
                        end
                    end
                end
            end

            task.wait(castDelay)
        else
            task.wait(0.1)
        end
    end
end

-- Monitor UI changes
function monitorUIChanges()
    playerGui.DescendantAdded:Connect(function(descendant)
        if descendant.Name == "playerbar" or descendant.Name == "reel" or descendant.Name == "shakeui" then
            stopCasting = true
        end
    end)

    playerGui.DescendantRemoving:Connect(function(descendant)
        if descendant.Name == "playerbar" or descendant.Name == "reel" or descendant.Name == "shakeui" then
            stopCasting = false
        end
    end)
end

AutoCastToggle = Tabs.Fish:AddToggle("AutoCast", {Title = "Auto Rod Casting", Default = false})

AutoCastToggle:OnChanged(function(value)
    isAutoCasting = value
    AutoFreeze = value
    if value then
        monitorUIChanges()
        coroutine.wrap(reelCasting)()
        coroutine.wrap(ensureRodEquipped)() -- Ensure the rod is always equipped during auto-casting
    else
        repeat task.wait() until not isReelBarActive()
    end
end)

Options.AutoCast:SetValue(false)



local isAutoShake = false

CenterShakeToggle = Tabs.Fish:AddToggle("CenterShake", {Title = "Always Center Shake", Default = false})

CenterShakeToggle:OnChanged(function(value)
    isAutoShake = value
end)

Options.CenterShake:SetValue(false)

FreezeCharacterToggle = Tabs.Fish:AddToggle("FreezeCharacter", {Title = "Freeze Character", Default = false})

rememberConnection = nil 
FreezeCharacterToggle:OnChanged(function(value)
    AutoFreeze = value
end)



-- Function to center and resize the button
function centerButton(button)
    if isAutoShake and button:IsA("ImageButton") then
        button.AnchorPoint = Vector2.new(0.5, 0.5)
        button.Position = UDim2.new(0.5, 0, 0.5, 0)
        button.Size = UDim2.new(0, 100, 0, 100)
    end
end

-- Set up listener for when 'shakeui' is added
playerGui.ChildAdded:Connect(function(child)
    if child.Name == "shakeui" then
        local safezone = child:WaitForChild("safezone", 5)  -- Optional timeout for safety
        if safezone then
            -- Listen for 'button' being added inside 'safezone'
            safezone.ChildAdded:Connect(function(newChild)
                if newChild.Name == "button" then
                    centerButton(newChild)
                end
            end)
        end
    end
end)

-- Check if 'shakeui' and 'button' already exist on script load
local shakeUI = playerGui:FindFirstChild("shakeui")
if shakeUI then
    local button = shakeUI:FindFirstChild("safezone") and shakeUI.safezone:FindFirstChild("button")
    if button then
        centerButton(button)
    end
end

local zonecastingParag = Tabs.Fish:AddSection("Zone Casting")

Tabs.Fish:AddParagraph({
    Title = "PLEASE READ !!!",
    Content = "This zone casting is not stable so it is possible to have a bugs so if ever you found one let me know."
})

local Ycoord = 20
local Direction = "Up"
local bobberOffset = 5
local selectedZone, zoneName, overrideZoneName = nil, nil, nil
local ZoneFishing, renderSteppedConnection, heartbeatConnection = false, nil, nil
local isOverridingZone = false
local WaterZoneNames = {}
local OverrideZoneValues = {"The Depths - Serpent", "Whale Shark", "Great White Shark", "Great Hammer Head Shark", "Isonade", "Megalodon Default"}

-- Dropdown for Water Zone Selection
local WaterZoneDropdown = Tabs.Fish:AddDropdown("WaterZone", {
    Title = "Select Water Zone to Fish",
    Values = WaterZoneNames,
    Multi = false,
    Default = "",
})

-- Dropdown for Override Zone
local OverrideZoneDropdown = Tabs.Fish:AddDropdown("OverrideZone", {
    Title = "Select Override Zone",
    Values = OverrideZoneValues,
    Multi = false,
    Default = "",
})

-- Toggle for Zone Fishing
local ZoneFishingToggle = Tabs.Fish:AddToggle("ZoneFishing", {
    Title = "Enable Zone Casting",
    Default = false,
})

-- Slider for Adjusting Y Coordinate
local Slider = Tabs.Fish:AddSlider("YCoordFish", {
    Title = "Adjust Y Position",
    Default = 20,
    Min = 0,
    Max = 300,
    Rounding = 1,
    Callback = function(value)
        Ycoord = value
        if ZoneFishing then
            updateSelectedZone()
        end
    end,
})

-- Dropdown for Y Coordinate Direction
local DropdownDirection = Tabs.Fish:AddDropdown("DirectionSelect", {
    Title = "Y Coordinate Direction",
    Values = {"Up", "Down"},
    Default = "Up",
    Callback = function(value)
        Direction = value
    end,
})


OverrideZoneDropdown:OnChanged(function(value)
    overrideZoneName = value
    selectedZone = workspace.zones.fishing:FindFirstChild(value)
    if selectedZone then
        if isOverridingZone then
            TeleportPlayer(CFrame.new(selectedZone.Position + Vector3.new(0, directionOffset, 0)))
        else
            SendNotif("Override Notify", "Overriding Zone is not active. Waiting for it.", 2)
        end
    end
end)

function updateSelectedZone()
    repeat task.wait() until not isReelBarActive()
    local directionOffset = (Direction == "Up") and Ycoord or -Ycoord
    local targetZone

    if isOverridingZone and overrideZoneName then
        targetZone = workspace.zones.fishing:FindFirstChild(overrideZoneName)
        if targetZone then
        print("Targeted Zone Found")
        end
    end

    if not targetZone and zoneName then
        targetZone = workspace.zones.fishing:FindFirstChild(zoneName)
    end

    if targetZone and Options.ZoneFishing.Value then
        selectedZone = targetZone
        TeleportPlayer(CFrame.new(targetZone.Position + Vector3.new(0, directionOffset, 0)))
    else
        selectedZone = nil
    end
end

WaterZoneDropdown:OnChanged(function(value)
    zoneName = value
    selectedZone = workspace.zones.fishing:FindFirstChild(value)
    updateSelectedZone()
end)

function refreshWaterZoneNames()
    WaterZoneNames = {}
    for _, zone in ipairs(workspace.zones.fishing:GetChildren()) do
        if not table.find(WaterZoneNames, zone.Name) then
            table.insert(WaterZoneNames, zone.Name)
        end
    end
    table.sort(WaterZoneNames)
    WaterZoneDropdown:SetValues(WaterZoneNames)
    OverrideZoneDropdown:SetValues(OverrideZoneValues)
    updateSelectedZone()
end

function enableNoclip()
    if heartbeatConnection then return end
    local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()

    heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not Options.ZoneFishing.Value then return end
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end

function disableNoclip()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
    local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()

    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local initialPlayerCFrame = nil -- Store the initial CFrame outside the function

ZoneFishingToggle:OnChanged(function(value)
    ZoneFishing = value
    isOverridingZone = value

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if value then
        -- Update the player's position each time the toggle is turned on
        if rootPart then
            initialPlayerCFrame = rootPart.CFrame
        end

        Options.AutoCast:SetValue(true)
        Options.AutoCatch:SetValue(true)
        startHovering()
        noclip = true
        updateSelectedZone()

        renderSteppedConnection = game:GetService("RunService").RenderStepped:Connect(function()
            local success, err = pcall(function()
                local playerTool = character and character:FindFirstChildWhichIsA("Tool")
                if playerTool then
                    local bobber = playerTool:FindFirstChild("bobber")
                    if bobber then
                        local ropeConstraint = bobber:FindFirstChild("RopeConstraint")
                        if ropeConstraint then
                            ropeConstraint.Length = 500
                            if selectedZone then
                                bobber.Position = selectedZone.Position + Vector3.new(0, bobberOffset, 0)
                            end
                        end
                    end
                end
            end)
            if not success then
                warn("Error in RenderStepped: ", err)
            end
        end)
    else
        stopFlying()
        noclip = false
        Options.AutoCast:SetValue(false)
        Options.AutoCatch:SetValue(false)

        if renderSteppedConnection then
            renderSteppedConnection:Disconnect()
            renderSteppedConnection = nil
        end

        -- Return the player to their initial position if it was stored
        if initialPlayerCFrame and rootPart then
            rootPart.CFrame = initialPlayerCFrame
        end
    end
end)


refreshWaterZoneNames()

workspace.zones.fishing.ChildAdded:Connect(refreshWaterZoneNames)
workspace.zones.fishing.ChildRemoved:Connect(refreshWaterZoneNames)








local EventsSection = Tabs.Fish:AddSection("Rod")

local rodsContainer = playerGui.hud.safezone.equipment.rods.scroll.safezone

local Dropdown = Tabs.Fish:AddDropdown("equipRod", {
    Title = "Equip Rod",
    Values = {},
    Multi = false,
    Default = "",
})

-- Function to update the dropdown
function updateDropdown()
    repeat task.wait() until game:IsLoaded()
    local rodNames = {}
    for _, frame in pairs(rodsContainer:GetChildren()) do
        if frame:IsA("Frame") and frame.Name:find("Rod") then
            table.insert(rodNames, frame.Name)
        end
    end
    Dropdown:SetValues(rodNames)
end

updateDropdown()

rodsContainer.ChildAdded:Connect(function()
    updateDropdown()
end)

rodsContainer.ChildRemoved:Connect(function()
    updateDropdown()
end)

Tabs.Fish:AddButton({
    Title = "Equip selected Rod",
    Description = "Equipping the selected Rod in the Equip Rod dropdown",
    Callback = function()
        local selectedRodName = Dropdown.Value
        if not selectedRodName or not rodsContainer:FindFirstChild(selectedRodName) then
            warn("Invalid rod selection")
            return
        end
        local args = {
            [1] = selectedRodName
        }

        local equipRodEvent = game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("equiprod")
        if equipRodEvent then
            equipRodEvent:FireServer(unpack(args))
            SendNotif("Rod Equip Notify", selectedRodName .. " has been Equipped", 3)
        else
            warn("Equip rod event not found")
        end
    end
})
local SelectedBait = nil
local EquipRandomBait = false

-- Required services
local RunService = game:GetService("RunService")
local HeartbeatConnection

RodSelectionDropdown = Tabs.Fish:AddDropdown("SelectRod", {
    Title = "Select Rod to Spam",
    Values = {
        "Wisdom Rod",
        "Rod Of The Eternal King",
        "Rod Of The Forgotten Fang",
    },
    Default = "",
})

-- AddToggle UI for Spamming Rod Equip
SpamEquipRodToggle = Tabs.Fish:AddToggle("SpamEquipRod", {
    Title = "Spam Equip Rods",
    Default = false,
})


-- Function to equip a specific rod
function EquipRod(rodName)
    local args = {
        [1] = rodName
    }
    game:GetService("ReplicatedStorage").events.equiprod:FireServer(unpack(args))
end

-- Handle changes to the toggle
SpamEquipRodToggle:OnChanged(function(value)
    if value then
        -- Start spamming the selected rod using Heartbeat
        -- Start spamming both the selected rod and "Rod Of The Depths"
HeartbeatConnection = RunService.Heartbeat:Connect(function()
    EquipRod("Rod Of The Depths") -- Always equip "Rod Of The Depths"
    local selectedRod = RodSelectionDropdown.Value -- Retrieve the selected rod
    if selectedRod then
        EquipRod(selectedRod) -- Equip the selected rod
    end
end)
    else
        -- Stop spamming
        if HeartbeatConnection then
            HeartbeatConnection:Disconnect()
            HeartbeatConnection = nil
        end
    end
end)

local CrabRelated = Tabs.Fish:AddSection("Bait")
local dropdown = Tabs.Fish:AddDropdown("SelectBaitEquip", {
    Title = "Select Bait to Equip",
    Values = {},
    Multi = false,
    Default = "",
})

-- Set the SelectedBait variable when dropdown value changes
dropdown:OnChanged(function(value)
    SelectedBait = value
end)

-- Initialize the Toggle for Auto Equip Random Bait
AutoEquipBaitToggle = Tabs.Fish:AddToggle("AutoEquipBait", {
    Title = "Equip Random Bait",
    Default = false,
})

AutoEquipBaitToggle:OnChanged(function(value)
    EquipRandomBait = value
end)

-- Populate the dropdown with available baits
function populateBaits()
    local baitFrame = game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.equipment.bait.scroll.safezone
    local baitNames = {}

    -- Loop through the bait frames and get their names
    for _, bait in pairs(baitFrame:GetChildren()) do
        if bait:IsA("Frame") then
            table.insert(baitNames, bait.Name)  -- Assuming the bait name is stored as the frame name
        end
    end

    -- Update the dropdown values
    dropdown:SetValues(baitNames)
end

-- Function to select a random bait from the list
function selectRandomBait()
    local baitFrame = game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.equipment.bait.scroll.safezone
    local baitNames = {}

    -- Get all available baits
    for _, bait in pairs(baitFrame:GetChildren()) do
        if bait:IsA("Frame") then
            table.insert(baitNames, bait.Name)
        end
    end

    -- Pick a random bait if available
    if #baitNames > 0 then
        local randomBait = baitNames[math.random(1, #baitNames)]
        return randomBait
    else
        return nil
    end
end

-- Monitor the selected bait and equip random bait if it disappears
game:GetService("RunService").RenderStepped:Connect(function()
    if EquipRandomBait then
        if SelectedBait and not game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.equipment.bait.scroll.safezone:FindFirstChild(SelectedBait) then
            -- If the selected bait is not found, equip a random bait
            local randomBait = selectRandomBait()
            if randomBait then
                SelectedBait = randomBait
                -- Fire the server with the random bait
                local args = { [1] = SelectedBait }
                game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.equipment.bait.scroll.safezone.e:FireServer(unpack(args))
                print("Equipped random bait: " .. SelectedBait)
            end
        end
    end
end)

-- Call the function to populate the baits when the UI is loaded or at the start
populateBaits()

-- Add the button to equip the selected bait
Tabs.Fish:AddButton({
    Title = "Equip selected bait",
    Description = "Equipping the selected bait from dropdown",
    Callback = function()
        if SelectedBait and SelectedBait ~= "" then
            -- Fire the server with the selected bait name
            local args = { [1] = SelectedBait }
            game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.equipment.bait.scroll.safezone.e:FireServer(unpack(args))
        else
            print("Please select a bait.")
        end
    end
})

local CrabRelated = Tabs.Fish:AddSection("Crab")

AutoPlaceCrabToggle = Tabs.Fish:AddToggle("AutoPlace", {Title = "Auto Place Crab Cage", Default = false})

function equipCrabCage()

    
    local backpack = player.Backpack
    local crabCage = character:FindFirstChild("Crab Cage") or backpack:FindFirstChild("Crab Cage")

    if crabCage and crabCage.Parent == backpack then
        crabCage.Parent = character
    end

    return character:FindFirstChild("Crab Cage")
end

function getCageCFrame()
    local meshPart = workspace.Camera.Cage:FindFirstChild("MeshPart")
    if meshPart then
        return meshPart.CFrame
    else
        return nil
    end
end

local autoPlaceConnection

AutoPlaceCrabToggle:OnChanged(function(value)
    if value then
        autoPlaceConnection = game:GetService("RunService").RenderStepped:Connect(function()
            local crabCage = equipCrabCage()
            local cageCFrame = getCageCFrame()

            if crabCage and cageCFrame then
                local args = {
                    [1] = cageCFrame -- Includes both position and angles from the CFrame
                }
                crabCage.Deploy:FireServer(unpack(args))
            else
                SendNotif("Auto Place Crab Cage", "No crab cage or target location found, turning off toggle.", 4)
                Options.AutoPlace:SetValue(false) 
            end
        end)
    else
        if autoPlaceConnection then
            autoPlaceConnection:Disconnect()
            autoPlaceConnection = nil
        end
    end
end)


CollectCrabToggle = Tabs.Fish:AddToggle("CollectCrab", {Title = "Auto Collect Crab Cage", Default = false})

local connection

CollectCrabToggle:OnChanged(function(value)
    if value then
        local plr = game.Players.LocalPlayer

            while value do
               for i, v in pairs(workspace.active:GetChildren()) do
                   if v.Name == plr.Name then
                        fireproximityprompt(v.Prompt)
                        task.wait()
                   end
               end
              task.wait(1)
           end

        connection = game:GetService("RunService").RenderStepped:Connect(function()
        
            local cageObject = workspace.active:FindFirstChild(player.Name)
            
            if cageObject then
                local cage = cageObject:FindFirstChild("Cage")
                local prompt = cageObject:FindFirstChild("Prompt")
                local innerCage = cage and cage:FindFirstChild("cage")
                
                if cage and prompt and innerCage and prompt.Enabled then
                    local character = player.Character
                    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                    
                    if rootPart then
                        rootPart.CFrame = innerCage.CFrame
                    end
                end
            end
        end)
    else
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end)

Options.CollectCrab:SetValue(false)


    
    --------------------------------------------------------------------------------FISH------------------------------------------------------------------------------------------


     --------------------------------------------------------------------------------AUTOBUY------------------------------------------------------------------------------------------
     local space = Tabs.Purchase:AddSection("Buy Totems")  
-- Data for Totems and Items
local TotemList = {
    ["Aurora Totem"] = 500000,
    ["Eclipse Totem"] = 250000,
    ["Smokescreen Totem"] = 2000,
    ["Sundial Totem"] = 2000,
    ["Tempest Totem"] = 2000,
    ["Windset Totem"] = 2000,
    ["Meteor Totem"] = 75000,
    ["Crab Cage"] = 45
}
local ItemList = {
    ["Bait Crate"] = 120,
    ["Common Crate"] = 128,
    ["Coral Geode"] = 600,
    ["Volcanic Geode"] = 600,
    ["Carbon Crate"] = 490,
    ["Quality Bait Crate"] = 525,
    ["Fish Barrel"] = 80
}

-- Helper function to extract keys
function extractKeys(data)
    local keys = {}
    for key, _ in pairs(data) do
        table.insert(keys, key)
    end
    return keys
end

local TotemKeys = extractKeys(TotemList)
local ItemKeys = extractKeys(ItemList)

-- Initial variables
local selectedTotem = TotemKeys[1] -- Default to first totem
local selectedItem = ItemKeys[1] -- Default to first item
local totemPurchaseAmount = 1
local itemPurchaseAmount = 1

-- Function to format numbers with commas
function formatWithCommas(number)
    return string.format("%s", tostring(number):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

-- Button references for dynamic updates
local TotemPurchaseButton
local ItemPurchaseButton

-- Totem Purchase Section
Tabs.Purchase:AddDropdown("TotemListDropdown", {
    Title = "Select Totem to Purchase",
    Values = TotemKeys,
    Multi = false,
    Default = selectedTotem,
    Callback = function(selected)
        selectedTotem = selected
        -- Update button description
        TotemPurchaseButton:SetDesc("Purchase " .. totemPurchaseAmount .. " " .. selectedTotem .. "(s) for " .. formatWithCommas(TotemList[selectedTotem] * totemPurchaseAmount) .. " C$")
    end
})

Tabs.Purchase:AddInput("TotemAmountInput", {
    Title = "How many totems to purchase",
    Default = tostring(totemPurchaseAmount),
    Placeholder = "Input number",
    Numeric = true,
    Finished = true,
    Callback = function(value)
        totemPurchaseAmount = tonumber(value) or 1
        -- Update button description
        TotemPurchaseButton:SetDesc("Purchase " .. totemPurchaseAmount .. " " .. selectedTotem .. "(s) for " .. formatWithCommas(TotemList[selectedTotem] * totemPurchaseAmount) .. " C$")
    end
})

TotemPurchaseButton = Tabs.Purchase:AddButton({
    Title = "Purchase Selected Totem",
    Description = "Purchase " .. totemPurchaseAmount .. " " .. selectedTotem .. "(s) for " .. formatWithCommas(TotemList[selectedTotem] * totemPurchaseAmount) .. " C$",
    Callback = function()
        Window:Dialog({
            Title = "Confirm Purchase",
            Content = "Do you want to purchase " .. totemPurchaseAmount .. " " .. selectedTotem .. "(s) for " .. formatWithCommas(TotemList[selectedTotem] * totemPurchaseAmount) .. " C$?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        game:GetService('ReplicatedStorage').events.purchase:FireServer(selectedTotem, 'Item', nil, totemPurchaseAmount)
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function() end
                }
            }
        })
    end
})
local space = Tabs.Purchase:AddSection("Buy Crates")
-- Item Purchase Section
Tabs.Purchase:AddDropdown("ItemListDropdown", {
    Title = "Select Crate to Purchase",
    Values = ItemKeys,
    Multi = false,
    Default = selectedItem,
    Callback = function(selected)
        selectedItem = selected
        -- Update button description
        ItemPurchaseButton:SetDesc("Purchase " .. itemPurchaseAmount .. " " .. selectedItem .. "(s) for " .. formatWithCommas(ItemList[selectedItem] * itemPurchaseAmount) .. " C$")
    end
})

Tabs.Purchase:AddInput("ItemAmountInput", {
    Title = "How many Crate to purchase",
    Default = tostring(itemPurchaseAmount),
    Placeholder = "Input number",
    Numeric = true,
    Finished = true,
    Callback = function(value)
        itemPurchaseAmount = tonumber(value) or 1
        -- Update button description
        ItemPurchaseButton:SetDesc("Purchase " .. itemPurchaseAmount .. " " .. selectedItem .. "(s) for " .. formatWithCommas(ItemList[selectedItem] * itemPurchaseAmount) .. " C$")
    end
})

ItemPurchaseButton = Tabs.Purchase:AddButton({
    Title = "Purchase Selected Crate",
    Description = "Purchase " .. itemPurchaseAmount .. " " .. selectedItem .. "(s) for " .. formatWithCommas(ItemList[selectedItem] * itemPurchaseAmount) .. " C$",
    Callback = function()
        Window:Dialog({
            Title = "Confirm Purchase",
            Content = "Do you want to purchase " .. itemPurchaseAmount .. " " .. selectedItem .. "(s) for " .. formatWithCommas(ItemList[selectedItem] * itemPurchaseAmount) .. " C$?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        game:GetService('ReplicatedStorage').events.purchase:FireServer(selectedItem, 'Fish', nil, itemPurchaseAmount)
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function() end
                }
            }
        })
    end
})

        
      --------------------------------------------------------------------------------AUTOBUY------------------------------------------------------------------------------------------

      --------------------------------------------------------------------------------APPRAISE------------------------------------------------------------------------------------------

      --------------------------------------------------------------------------------APPRAISE------------------------------------------------------------------------------------------
    







--------------------------------------------------------------------------------TELEPORT------------------------------------------------------------------------------------------
local space = Tabs.Teleport:AddSection("Custom fishing position")
local savedPositions = {}
local saveFileName = "AshbornnHub/Fisch/positions.json"
local spawnedPart = nil

if not isfolder("AshbornnHub/Fisch") then
    makefolder("AshbornnHub/Fisch")
end

function writePositionsToFile()
    local data = game.HttpService:JSONEncode(savedPositions)
    writefile(saveFileName, data)
end

function loadPositionsFromFile()
    if isfile(saveFileName) then
        local data = readfile(saveFileName)
        local success, decodedData = pcall(function()
            return game.HttpService:JSONDecode(data)
        end)

        if success then
            return decodedData
        else
            return {}
        end
    else
        return {}
    end
end

savedPositions = loadPositionsFromFile()

function savePosition(name, position, withPart)
    local posData = {
        Name = name,
        Position = {
            X = position.Position.X,
            Y = position.Position.Y,
            Z = position.Position.Z,
        },
        Rot = { position:ToOrientation() },
        WithPart = withPart
    }

    local positionExists = false
    for i, pos in ipairs(savedPositions) do
        if pos.Name == name then
            savedPositions[i] = posData
            positionExists = true
            break
        end
    end

    if not positionExists then
        table.insert(savedPositions, posData)
    end

    writePositionsToFile()
    updatePositionDropdown()
    SendNotif("Teleport Notify", "Position '" .. name .. "' saved/updated successfully.", 2)
end

function updatePositionDropdown()
    local TPPosData = {}
    for _, pos in ipairs(savedPositions) do
        table.insert(TPPosData, pos.Name)
    end

    if SelectTPPosName then
        SelectTPPosName:SetValues(TPPosData)
    end
end

SelectTPPosName = Tabs.Teleport:AddDropdown("SelectTPPosName", {
    Title = "Select Teleport Position",
    Values = {},
    Multi = false,
})

updatePositionDropdown()

Tabs.Teleport:AddButton({
    Title = "Teleport to Saved Position",
    Description = "Teleports the player to the selected saved position",
    Callback = function()
        local selectedName = SelectTPPosName.Value
        if not selectedName or selectedName == "" then
            SendNotif("Teleport Notify", "Please select a valid position to teleport to.", 2)
            return
        end

        local selectedPosition = nil
        for _, pos in ipairs(savedPositions) do
            if pos.Name == selectedName then
                if #pos.Rot == 3 then
                    selectedPosition = CFrame.new(pos.Position.X, pos.Position.Y, pos.Position.Z) * CFrame.Angles(unpack(pos.Rot))
                else
                    selectedPosition = CFrame.new(pos.Position.X, pos.Position.Y, pos.Position.Z)
                end
                break
            end
        end

        if selectedPosition then
            if savedPositions[1].WithPart then
                if not spawnedPart then
                    spawnedPart = Instance.new("Part")
                    spawnedPart.Size = Vector3.new(10, 1, 10)
                    spawnedPart.Anchored = true
                    spawnedPart.Parent = workspace
                end
                spawnedPart.CFrame = selectedPosition
            else
                if spawnedPart then
                    spawnedPart:Destroy()
                    spawnedPart = nil
                end
            end

            TeleportPlayer(selectedPosition)
            SendNotif("Teleport Notify", "Teleported to position: " .. selectedName, 2)
        else
            SendNotif("Teleport Notify", "Position not found.", 2)
        end
    end
})

FavoriteFish = Tabs.Teleport:AddInput("TeleportPosName", {
    Title = "Teleport Position Name",
    Default = "",
    Placeholder = "Enter a position name",
    Numeric = false,
    Finished = true,
    Callback = function(Value)
        TPPosName = Value
    end
})

Tabs.Teleport:AddButton({
    Title = "Save Position with Part",
    Description = "Saves the player's position and spawns a 10x1x10 part",
    Callback = function()
        local name = TPPosName
        if name == "" then
            SendNotif("Teleport Notify", "Please enter a valid name.", 2)
            return
        end

        if not spawnedPart then
            spawnedPart = Instance.new("Part")
            spawnedPart.Size = Vector3.new(10, 1, 10)
            spawnedPart.Anchored = true
            spawnedPart.Parent = workspace
        end

        spawnedPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, -character.HumanoidRootPart.Size.Y / 2 - 0.5, 0)
        savePosition(name, spawnedPart.CFrame, true)
    end
})

Tabs.Teleport:AddButton({
    Title = "Save Position without Part",
    Description = "Saves the player's position without spawning a part",
    Callback = function()
        local name = TPPosName
        if name == "" then
            SendNotif("Teleport Notify", "Please enter a valid name.", 2)
            return
        end

        savePosition(name, character.HumanoidRootPart.CFrame, false)
    end
})

Tabs.Teleport:AddButton({
    Title = "Delete Saved Position",
    Description = "Deletes the selected saved position",
    Callback = function()
        local selectedName = SelectTPPosName.Value
        if not selectedName or selectedName == "" then
            SendNotif("Teleport Notify", "Please select a valid position to delete.", 2)
            return
        end

        local positionFound = false
        for i, pos in ipairs(savedPositions) do
            if pos.Name == selectedName then
                table.remove(savedPositions, i)
                positionFound = true
                break
            end
        end

        if positionFound then
            writePositionsToFile()
            updatePositionDropdown()
            SendNotif("Teleport Notify", "Position '" .. selectedName .. "' deleted successfully.", 2)
        else
            SendNotif("Teleport Notify", "Position not found.", 2)
        end
    end
})
local Input = Tabs.Teleport:AddInput("TeleportCord", { 
    Title = "Teleport to Coordinates", 
    Default = "",
    Placeholder = "0, 0, 0", 
    Numeric = false, 
    Finished = true, 
    Callback = function(value)
        local x, y, z
        if value:find(",") then
            local coords = string.split(value, ",")
            x, y, z = tonumber(coords[1]), tonumber(coords[2]), tonumber(coords[3])
        elseif value:find("CFrame.new") then
            local success, cframeValue = pcall(loadstring("return " .. value))
            if success and typeof(cframeValue) == "CFrame" then
                return TeleportPlayer(cframeValue)
            end
        end

        if x and y and z then
            TeleportPlayer(CFrame.new(x, y, z))
        else
            SendNotif("Teleport Notify","Invalid input! Use 'X, Y, Z' or 'CFrame.new(x, y, z)'.", 4)
        end
    end
})


local Locations = {
    ["Ancient Isles"] = CFrame.new(6055, 197, 316),
    ["Brinepool"] = CFrame.new(-1794, -143, -3315),
    ["Deep Ocean"] = CFrame.new(-4665, 135, 1758),
    ["Desolate Deep"] = CFrame.new(-1659, -214, -2847),
    ["Forsaken Shores"] = CFrame.new(-2655, 183, 1671),
    ["Keepers Altar"] = CFrame.new(1297, -805, -298),
    ["MooseWood"] = CFrame.new(384, 134, 232),
    ["Mushgrove Swamp"] = CFrame.new(2438, 132, -689),
    ["Roslit"] = CFrame.new(-1482, 138, 738),
    ["Roslit Volcano"] = CFrame.new(-1907, 165, 316),
    ["Snowcap"] = CFrame.new(2618, 146, 2402),
    ["Statue of Sovereignty"] = CFrame.new(26, 159, -1037),
    ["Sunstone"] = CFrame.new(-918, 135, -1123),
    ["Terrapin"] = CFrame.new(-189, 143, 1926),
    ["The Depths"] = CFrame.new(925, -722, 1262),
    ["Vertigo"] = CFrame.new(-117, -515, 1138)
}

local subLocations = {
    ["Desolate Shop"] = CFrame.new(-994, -245, -2723),
    ["Enchant Altar"] = CFrame.new(1312, -802, -87),
    ["Gamma"] = CFrame.new(2231, -792, 1012),
    ["Rod Crafting"] = CFrame.new(-3164, -745, 1681)
}

local NPCLocations = {
    ["Appraiser"] = CFrame.new(444, 151, 210),
    ["Jack Marrow"] = CFrame.new(-2825, 214, 1516),
    ["Lantern Guy"] = CFrame.new(-39, -247, 199),
    ["Merchant"] = CFrame.new(467, 151, 231),
    ["Merlin (Relic Seller)"] = CFrame.new(-932, 224, -988),
    ["Witch (Event Pot)"] = CFrame.new(405, 135, 317)
}

local RodLocation = {
    ["Carbon Rod(2k)"] = CFrame.new(450, 151, 224),
    ["Destiny Rod(190k)"] = CFrame.new(988, 131, -1238),
    ["Kings Rod(120k)"] = CFrame.new(1379, -807, -302),
    ["Magma Rod(need pufferfish)"] = CFrame.new(-1847, 166, 161),
    ["Magnet Rod(15k)"] = CFrame.new(-197, 133, 1932),
    ["Nocturnal Rod(11k)"] = CFrame.new(-144, -515, 1142),
    ["Phoenix Rod(40k)"] = CFrame.new(5969, 272, 852),
    ["Reinforced Rod(20k)"] = CFrame.new(-991, -244, -2693),
    ["Relic Rod(4k)"] = CFrame.new(4097, 40, 30),
    ["Rod of the Depths (750k)"] = CFrame.new(1701, -903, 1445),
    ["Steady Rod(7k)"] = CFrame.new(-1511, 142, 762),
    ["Trident Rod(150k)"] = CFrame.new(-1484, -226, -2202),
    ["Aurora Rod(90k)"] = CFrame.new(-144, -515, 1134),
    ["Stone Rod(3k)"] = CFrame.new(5498, 147, -313)
}

local TotemLocation = {
    ["Aurora Totem(Luck)"] = CFrame.new(-1811, -137, -3282),
    ["Eclipse (Eclipse)"] = CFrame.new(5966, 274, 841),
    ["Smokescreen (Fog)"] = CFrame.new(2793, 140, -629),
    ["Sundial (Day/Night)"] = CFrame.new(-1147, 135, -1074),
    ["Tempest (Rainy)"] = CFrame.new(36, 135, 1946),
    ["Windset (Windy)"] = CFrame.new(2852, 180, 2703),
    ["Meteor (Meteor)"] = CFrame.new(-1948, 275, 231)
}

-- Function to extract and sort location names alphabetically from each table
function extractLocationNames(locations)
    local names = {}
    for name in pairs(locations) do
        table.insert(names, name)
    end
    table.sort(names)  -- Sort the names alphabetically
    return names
end

local LocationNames = extractLocationNames(Locations)
local subLocationsNames = extractLocationNames(subLocations)
local NPCLocationNames = extractLocationNames(NPCLocations)
local RodLocationNames = extractLocationNames(RodLocation)
local TotemLocationNames = extractLocationNames(TotemLocation)


local space = Tabs.Teleport:AddSection("TP Settings")

local TeleportMethodDD = Tabs.Teleport:AddDropdown("TPMethod", {
    Title = "Teleport Method",
    Values = {"Tween", "Instant"},
    Multi = false,
    Default = teleportMethod,
})

TeleportMethodDD:OnChanged(function(value)
    teleportMethod = value
end)

local Slider = Tabs.Teleport:AddSlider("TweenSpeed", {
    Title = "Change Tween Speed",
    Description = "Change tween teleporting speed",
    Default = moveSpeed,
    Min = 10,
    Max = 1000,
    Rounding = 1,
    Callback = function(Value)
        moveSpeed = Value
    end
})

Slider:SetValue(moveSpeed)
local space = Tabs.Teleport:AddSection("Locations")

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
        TeleportPlayer(PositionLoc) 
    else 
  end
        if selectedLocation == "Deep Ocean" and not spawnedPart then 
            local part = Instance.new("Part")
            part.Size = Vector3.new(10, 1, 10) 
            part.Position = Vector3.new(-4665, 131, 1758) 
            part.Anchored = true 
            part.Parent = workspace 
    
            spawnedPart = true 
            TeleportPlayer(Locations[Value])
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
        TeleportPlayer(Position) 
    else

    end
    end
 })
        
     local space = Tabs.Teleport:AddSection("")


    local spawnedPart = false
Dropdown:OnChanged(function(Value)
 
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


Tabs.Teleport:AddButton({
    Title = "Teleport to selected NPC",
    Description = "",
    Callback = function()
    local selectedNPC = NPCDrop.Value
    local Position = NPCLocations[selectedNPC]
    if Position then
        TeleportPlayer(Position) 
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

Tabs.Teleport:AddButton({
    Title = "Teleport to selected Rod Location",
    Description = "",
    Callback = function()
    local selectedLocation = RodDD.Value
    local RodLoc = RodLocation[selectedLocation]
    if RodLoc then
        TeleportPlayer(RodLoc) 
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



Tabs.Teleport:AddButton({
    Title = "Teleport to selected Totem Location",
    Description = "",
    Callback = function()
    local selectedLocation = TotemDD.Value
    local TotemLoc = TotemLocation[selectedLocation]
    if TotemLoc then
        TeleportPlayer(TotemLoc) 
    else 

    end
            end
        })
--------------------------------------------------------------------------------TELEPORT------------------------------------------------------------------------------------------







--------------------------------------------------------------------------------MISC------------------------------------------------------------------------------------------

FishingCollidingToggle = Tabs.Misc:AddToggle("FishingCollide", {Title = "Water Walk", Default = false})

function updateCanCollide(value)
    local fishingZone = workspace:FindFirstChild("zones"):FindFirstChild("fishing")
    if fishingZone then
        for _, descendant in ipairs(fishingZone:GetDescendants()) do
            if descendant:IsA("Part") then
                descendant.CanCollide = value
            end
        end
    end
end


FishingCollidingToggle:OnChanged(function(value)
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

local connection
local isUsingCrate = false

-- Dropdown for selecting tool to activate
ActivateTools = Tabs.Misc:AddDropdown("SelectActivateTools", {
    Title = "Select Item to Activate",
    Values = {"Coral Geode", "Bait Crate", "Common Crate", "Quality Bait Crate", "Volcanic Geode", "Fish Barrel", "Carbon Crate"},
    Multi = false,
    Default = 1,
})

-- Define the function to use the crate (or tool) after selecting it from the dropdown
function UseCrate()
    if isUsingCrate then return end
    isUsingCrate = true

    local selectedTool = ActivateTools.Value  -- Get the selected value from the dropdown
    local backpack = player.Backpack

    -- Look for the tool in the backpack
    local tool = backpack:FindFirstChild(selectedTool)
    if tool and tool:IsA("Tool") then
        -- Equip the tool
        tool.Parent = character

        -- Activate the tool immediately after equipping
        if tool.Activate and tool then
            tool:Activate()  -- Call the Activate method on the tool
        end

        -- Fast activation loop
        while character:FindFirstChild(tool.Name) do
            if tool.Activate then
                tool:Activate()  -- Call the Activate method
            end
            task.wait(0.01)  -- Fast activation delay
        end
    else
        
    end

    isUsingCrate = false
end

-- Add a toggle for automatically using the crate
AutoUseCrate = Tabs.Misc:AddToggle("AutoUseCrate", {Title = "Auto Use Selected Tool", Default = false})

AutoUseCrate:OnChanged(function(Value)
    if Value then
        if not connection then
            connection = runService.RenderStepped:Connect(UseCrate)
        end
    else
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end)

Options.AutoUseCrate:SetValue(false)


local WannaBeYours = Tabs.Misc:AddSection("Totem")

local AutoAuroraTotem = false
local AuroraActive = false

function totems()
    local sundialTotem, auroraTotem = nil, nil
    for _, item in ipairs(player.Backpack:GetChildren()) do
        if item:IsA("Tool") then
            if item.Name == "Sundial Totem" then
                sundialTotem = item
            elseif item.Name == "Aurora Totem" then
                auroraTotem = item
            end
        end
    end
    return sundialTotem, auroraTotem
end

function begin()
    local wasAutoCastEnabled = Options.AutoCast.Value
    if wasAutoCastEnabled and not isReelBarActive() and AutoAuroraTotem then
        Options.AutoCast:SetValue(false)
    end

    while AutoAuroraTotem do
        local sundialTotem, auroraTotem = totems()

        if not auroraTotem then
            SendNotif("Totem Notify", "Aurora Totem not found. Disabling AutoTotem.", 3)
            Options.AutoTotem:SetValue(false)
            if wasAutoCastEnabled then
                Options.AutoCast:SetValue(true)
            end
            return
        end

        if not sundialTotem then
            SendNotif("Totem Notify", "Sundial Totem not found. Disabling AutoTotem.", 3)
            Options.AutoTotem:SetValue(false)
            if wasAutoCastEnabled then
                Options.AutoCast:SetValue(true)
            end
            return
        end

        local weather = player.PlayerGui.hud.safezone.worldstatuses["2_weather"].label.Text
        local cycle = player.PlayerGui.hud.safezone.worldstatuses["3_cycle"].label.Text

        if cycle == "Day" then
            repeat task.wait() until not isReelBarActive()
            Humanoid:EquipTool(sundialTotem)
            sundialTotem:Activate()
            SendNotif("Totem Notify", "Sundial Totem Popped!!", 3)

            while cycle == "Day" do
                task.wait(1)
                cycle = player.PlayerGui.hud.safezone.worldstatuses["3_cycle"].label.Text
            end
        end

        if cycle == "Night" and weather ~= "Aurora Borealis" then
            repeat task.wait() until not isReelBarActive()
            Humanoid:EquipTool(auroraTotem)
            auroraTotem:Activate()
            SendNotif("Totem Notify", "Aurora Totem Popped!! 🌌", 3)
            AuroraActive = true

            while weather ~= "Aurora Borealis" do
                task.wait(1)
                weather = player.PlayerGui.hud.safezone.worldstatuses["2_weather"].label.Text
            end

            SendNotif("Totem Notify", "Aurora Borealis Active. Waiting for Day...", 3)
            if wasAutoCastEnabled then
                Options.AutoCast:SetValue(true)
            end
            while cycle ~= "Day" do
                task.wait(1)
                cycle = player.PlayerGui.hud.safezone.worldstatuses["3_cycle"].label.Text
            end
        end

        task.wait(1)
    end
end

local AutoTotemToggle = Tabs.Misc:AddToggle("AutoTotem", {Title = "Auto Aurora Totem", Default = false})

AutoTotemToggle:OnChanged(function(value)
    AutoAuroraTotem = value
    if AutoAuroraTotem then
        begin()
    end
end)

local AutoSundialTotem = false
local pickedCycle = "Day" -- Default to Day

-- Function to find Sundial Totem in the backpack or character
function getSundialTotem()
    -- Check in the backpack
    for _, item in ipairs(player.Backpack:GetChildren()) do
        if item:IsA("Tool") and item.Name == "Sundial Totem" then
            return item
        end
    end
    -- Check if it's equipped
    if player.Character then
        for _, item in ipairs(player.Character:GetChildren()) do
            if item:IsA("Tool") and item.Name == "Sundial Totem" then
                return item
            end
        end
    end
    return nil
end

function maintainCycle()
    local wasAutoCastEnabled = Options.AutoCast.Value
    if wasAutoCastEnabled and not isReelBarActive() and AutoSundialTotem then
        Options.AutoCast:SetValue(false)
    end

    local lastCycle = nil

    while AutoSundialTotem do
        local sundialTotem = getSundialTotem()
        if not sundialTotem then
            SendNotif("Totem Notify", "Sundial Totem not found. Disabling AutoSundialTotem.", 3)
            Options.AutoSundialTotem:SetValue(false)
            if wasAutoCastEnabled then
                Options.AutoCast:SetValue(true)
            end
            return
        end

        local currentCycle = player.PlayerGui.hud.safezone.worldstatuses["3_cycle"].label.Text

        -- If the current cycle doesn't match the picked cycle and hasn't been handled already
        if currentCycle ~= pickedCycle and currentCycle ~= lastCycle then
            repeat task.wait() until not isReelBarActive()
            Humanoid:EquipTool(sundialTotem)
            sundialTotem:Activate()
            SendNotif("Totem Notify", "Sundial Totem used to make it " .. pickedCycle .. "!", 1)
            lastCycle = pickedCycle
            task.wait(10) 
        end

        task.wait(1)
    end
    if wasAutoCastEnabled then
        Options.AutoCast:SetValue(true)
    end
end

local CycleDropdown = Tabs.Misc:AddDropdown("CycleDropdown", {
    Title = "Desired Cycle",
    Values = {"Day", "Night"},
    Default = "Day",
    Multi = false
})

CycleDropdown:OnChanged(function(value)
    pickedCycle = value
end)

local AutoSundialTotemToggle = Tabs.Misc:AddToggle("AutoSundialTotem", {
    Title = "Auto Sundial Totem",
    Default = false
})

AutoSundialTotemToggle:OnChanged(function(value)
    AutoSundialTotem = value
    if AutoSundialTotem then
        task.spawn(maintainCycle)
    end
end)


local AutoWeatherCycle = false
local pickedWeather = "Foggy"

function getWeatherTotem()
    local totemMapping = {
        ["Foggy"] = "Smokescreen Totem",
        ["Rainy"] = "Tempest Totem",
        ["Windy"] = "Windset Totem"
    }
    local totemName = totemMapping[pickedWeather]

    for _, item in ipairs(player.Backpack:GetChildren()) do
        if item:IsA("Tool") and item.Name == totemName then
            return item
        end
    end

    if player.Character then
        for _, item in ipairs(player.Character:GetChildren()) do
            if item:IsA("Tool") and item.Name == totemName then
                return item
            end
        end
    end
    return nil
end

function maintainWeather()
    local wasAutoCastEnabled = Options.AutoCast.Value
    if wasAutoCastEnabled and not isReelBarActive() and AutoWeatherCycle then
        Options.AutoCast:SetValue(false)
    end

    while AutoWeatherCycle do
        local weatherTotem = getWeatherTotem()
        if not weatherTotem then
            SendNotif("Totem Notify", "Required Weather Totem not found. Disabling AutoWeatherCycle.", 3)
            Options.AutoWeatherCycle:SetValue(false)
            if wasAutoCastEnabled then
                Options.AutoCast:SetValue(true)
            end
            return
        end

        local currentWeather = player.PlayerGui.hud.safezone.worldstatuses["2_weather"].label.Text

        if currentWeather ~= pickedWeather then
            repeat task.wait() until not isReelBarActive()
            Humanoid:EquipTool(weatherTotem)
            weatherTotem:Activate()
            SendNotif("Totem Notify", weatherTotem.Name .. " used to make it " .. pickedWeather .. "!", 3)
            task.wait(3)
        end

        task.wait(1)
    end

    if wasAutoCastEnabled then
        Options.AutoCast:SetValue(true)
    end
end

local WeatherDropdown = Tabs.Misc:AddDropdown("WeatherDropdown", {
    Title = "Desired Weather",
    Values = {"Foggy", "Rainy", "Windy"},
    Default = "Foggy",
    Multi = false
})

WeatherDropdown:OnChanged(function(value)
    pickedWeather = value
end)

local AutoWeatherCycleToggle = Tabs.Misc:AddToggle("AutoWeatherCycle", {
    Title = "Auto Weather Cycle",
    Default = false
})

AutoWeatherCycleToggle:OnChanged(function(value)
    AutoWeatherCycle = value
    if AutoWeatherCycle then
        task.spawn(maintainWeather)
    end
end)





local WannaBeYours = Tabs.Misc:AddSection("Favorite")

function favoriteFish(inputName)
    local backpack = player.Backpack
    local lowerInputName = inputName:lower()

    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find(lowerInputName) then
            game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.backpack.events.favourite:FireServer(tool)
        end
    end
end

local favorite = nil
local FavoriteFish = Tabs.Misc:AddInput("AutoFavorite", {
    Title = "Favorite Fish",
    Default = "",
    Placeholder = "Input name",
    Numeric = false,
    Finished = true,
    Callback = function(Value)
        favorite = Value
    end
})

Tabs.Misc:AddButton({
    Title = "Favorite All",
    Description = "Favorites the fish that contain the name you input (case-insensitive)",
    Callback = function()
        local inputName = favorite or ""
        if inputName ~= "" then
            favoriteFish(inputName)
        else
            SendNotif("Favorite Notify", "Please input a valid name", 3)
        end
    end
})




local WannaBeYours = Tabs.Misc:AddSection("Performance ")

Tabs.Misc:AddButton({
    Title = "Remove Cages from Sight",
    Description = "Click to make all Cage parts invisible and reduce performance impact",
    Callback = function()
        for _, player in pairs(workspace.active:GetChildren()) do
            if player:IsA("Model") and player:FindFirstChild("Cage") then
                local playerCage = player.Cage
                
                spawn(function()
                    for _, child in pairs(playerCage:GetChildren()) do
                        if child.Name == "cage" or child.Name == "Part" then
                            child.Transparency = 1
                            child.CanCollide = false
                            child.CanTouch = false
                            child.Anchored = true
                            child.Material = Enum.Material.SmoothPlastic
                        end
                    end
                end)
            end
        end
    end
})
-- Flag to track the blackscreen state
local isBlackscreenActive = false

-- Add Toggle for black screen and 3D rendering
ToggleMainName = Tabs.Misc:AddToggle("BlackScreenToggle", {Title = "Toggle Blackscreen", Description = "Disable 3D Rendering to optimize GPU", Default = false})

ToggleMainName:OnChanged(function(value)
    if value then
        -- Show black screen and disable 3D rendering
        if not isBlackscreenActive then
            -- Create the blackscreen GUI
            local blackScreenGui = Instance.new("ScreenGui")
            blackScreenGui.Name = "BlackScreenGui"
            blackScreenGui.ResetOnSpawn = false
            blackScreenGui.DisplayOrder = -10  -- Keep it in the background
            blackScreenGui.IgnoreGuiInset = true -- Ensure full coverage
            blackScreenGui.Parent = coreGui

            -- Create a ViewportFrame as a black overlay
            local viewport = Instance.new("ViewportFrame")
            viewport.Size = UDim2.new(1, 0, 1, 0)
            viewport.BackgroundColor3 = Color3.new(0, 0, 0) -- Pure black
            viewport.BorderSizePixel = 0
            viewport.BackgroundTransparency = 0 -- Fully opaque
            viewport.Parent = blackScreenGui

            -- Disable 3D rendering
            runService:Set3dRenderingEnabled(false)
            isBlackscreenActive = true
        end
    else
        -- Remove black screen and enable 3D rendering
        if isBlackscreenActive then
            coreGui:FindFirstChild("BlackScreenGui"):Destroy()
            runService:Set3dRenderingEnabled(true)
            isBlackscreenActive = false
        end
    end
end)

Options.BlackScreenToggle:SetValue(false)

local Lighting = game:GetService("Lighting")

ToggleFullBright = Tabs.Misc:AddToggle("LoopFB", {Title = "FullBright", Description = "Enable FullBright", Default = false})

local brightLoop

ToggleFullBright:OnChanged(function(value)
    if value then
        function brightFunc()
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end
        brightLoop = runService.RenderStepped:Connect(brightFunc)
    else
        if brightLoop then
            brightLoop:Disconnect()
            brightLoop = nil
        end
    end
end)

Options.LoopFB:SetValue(false) 





local WannaBeYours = Tabs.Misc:AddSection("Trading Misc")

-- Define the toggle for "Auto Accept Trade"
AutoAccept = Tabs.Misc:AddToggle("AutoAccept", {Title = "Auto Accept Trade", Default = false})

-- Listen for toggle changes
AutoAccept:OnChanged(function(value)
    if value then
        -- If enabled, start continuous checking on every frame
        autoAcceptConnection = game:GetService("RunService").RenderStepped:Connect(function()
            local hud = playerGui and playerGui:FindFirstChild("hud")
            local safezone = hud and hud:FindFirstChild("safezone")
            local bodyAnnouncements = safezone and safezone:FindFirstChild("bodyannouncements")
            local offer = bodyAnnouncements and bodyAnnouncements:FindFirstChild("offer")
            local confirmButton = offer and offer:FindFirstChild("confirm")

            -- If the confirm button is available and visible, auto-accept the trade
            if confirmButton and confirmButton.Visible then
                firesignal(confirmButton.MouseButton1Click, player)
            end
        end)
    else
        -- If disabled, stop the continuous checking
        if autoAcceptConnection then
            autoAcceptConnection:Disconnect()
            autoAcceptConnection = nil
        end
    end
end)

local blacklistedKeywords = {"Rod", "Bag", "Radar", "GPS", "Gear", "Flipper", "Cage", "Bestiary", "Glider"}
local priorityKeywords = {"Shiny", "Sparkling", "Mythical", "Aurora", "Relic"}

function isBlacklisted(itemName)
    for _, keyword in ipairs(blacklistedKeywords) do
        if itemName:find(keyword) then return true end
    end
    return false
end

function isPriorityItem(itemName)
    for _, keyword in ipairs(priorityKeywords) do
        if itemName:find(keyword) then return true end
    end
    return false
end

local LocalPlayer = game:GetService("Players").LocalPlayer
local previousTool, tradeOfferConnection, offerSpamConnection = nil, nil, nil

local Dropdown = Tabs.Misc:AddDropdown("SelectPlayerOFFER", {
    Title = "Select Player",
    Values = GetOtherPlayers(),
    Multi = false,
    Default = "",
})

AutoTradeOffer = Tabs.Misc:AddToggle("AutoTrade", {Title = "Auto Trade Selected Player (all items)", Default = false})

AutoTradeOffer:OnChanged(function(value)
    if value then
        previousTool = nil
        tradeOfferConnection = runService.RenderStepped:Connect(function()
            local selectedPlayer = Dropdown.Value
            if selectedPlayer and selectedPlayer ~= "" then
                local backpack = LocalPlayer.Backpack
                local validTools = {}

                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and not isBlacklisted(tool.Name) then
                        if isPriorityItem(tool.Name) then
                            table.insert(validTools, tool)
                        elseif tool.Name ~= previousTool then
                            table.insert(validTools, tool)
                        end
                    end
                end

                if #validTools > 0 then
                    local characterTools = LocalPlayer.Character:GetChildren()
                    local currentEquippedTool = nil
                    for _, tool in ipairs(characterTools) do
                        if tool:IsA("Tool") then
                            currentEquippedTool = tool
                            break
                        end
                    end
                    
                    if currentEquippedTool then
                        currentEquippedTool.Parent = backpack
                    end

                    local randomTool = validTools[math.random(1, #validTools)]
                    randomTool.Parent = LocalPlayer.Character

                    local offerEvent = LocalPlayer.Character:FindFirstChild(randomTool.Name) and LocalPlayer.Character[randomTool.Name]:FindFirstChild("offer")
                    if offerEvent then
                        local args = {
                            [1] = game:GetService("Players"):WaitForChild(selectedPlayer)
                        }

                        offerSpamConnection = runService.RenderStepped:Connect(function()
                            local equippedTool = LocalPlayer.Character:FindFirstChild(randomTool.Name)
                            local toolInBackpack = backpack:FindFirstChild(randomTool.Name)
                            if equippedTool then
                                offerEvent:FireServer(unpack(args))
                            elseif not equippedTool and not toolInBackpack then
                                if offerSpamConnection then
                                    offerSpamConnection:Disconnect()
                                    offerSpamConnection = nil
                                end
                                previousTool = randomTool.Name
                                AutoTradeOffer:Set(true)
                            end
                        end)

                        previousTool = randomTool.Name
                    end
                end
            end
        end)
    else
        previousTool = nil
        if tradeOfferConnection then
            tradeOfferConnection:Disconnect()
            tradeOfferConnection = nil
        end
        if offerSpamConnection then
            offerSpamConnection:Disconnect()
            offerSpamConnection = nil
        end
    end
end)

local WannaBeYours = Tabs.Misc:AddSection("Character Misc")

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

FlyToggle = Tabs.Misc:AddToggle("Fly", {Title = "Fly", Default = false})

FlyToggle:OnChanged(function(value)
	if value then
		startFlying()
	else
		stopFlying()
	end
end)

Options.Fly:SetValue(false)


NoclipToggle = Tabs.Misc:AddToggle("Noclip", {Title = "Noclip", Default = false})

NoclipToggle:OnChanged(function(noclip)
    if LocalPlayer.Character then
        for _, v in ipairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = not noclip 
            end
        end
        LocalPlayer.Character.ChildAdded:Connect(function(child)
            if child:IsA("BasePart") then
                child.CanCollide = not noclip
            end
        end)
    end
end)

Options.Noclip:SetValue(false)




--------------------------------------------------------------------------------MISC--------------------------------------------------------------------------------------


------------------------------APPRAISE

Tabs.Appraise:AddParagraph({
        Title = "IMPORTANT: PLEASE READ BEFORE USE",
        Content = "To use Auto Appraise and More like Buy Relic or Luck Selling Fish you need to use Infinite Range NPC Below or just go to npcs lol ",
        })

        ToggleRefreshedNpc = Tabs.Appraise:AddToggle("RefreshedNpc", {Title = "Infinite Range NPC", Description = "Use this to be able to Use NPC Functions anywhere for Appraise, Merchant, Merlin, Jack Marrow", Default = false})

        ToggleRefreshedNpc:OnChanged(function(isEnabled)
            if isEnabled then
                task.spawn(function()
                    local NPCLocations = {
                        ["Merlin"] = CFrame.new(-932, 224, -988),
                        ["Jack Marrow"] = CFrame.new(-2825, 214, 1516),
                        ["Appraiser"] = CFrame.new(444, 151, 210),
                        ["Marc Merchant"] = CFrame.new(467, 151, 231)
                    }
        
                    local rootPart = character:WaitForChild("HumanoidRootPart")
                    local originalPosition = rootPart.CFrame
        
                    -- Proximity prompt trigger function
                    function triggerProximityPrompt(pp)
                        local camera = workspace.CurrentCamera
                        local targetPart = pp.Parent:IsA("Model") and pp.Parent:FindFirstChild("Head") or pp.Parent:IsA("Part") and pp.Parent
                        if not targetPart then return end
        
                        local originalProps = {Enabled = pp.Enabled, HoldDuration = pp.HoldDuration, RequiresLineOfSight = pp.RequiresLineOfSight, MaxActivationDistance = pp.MaxActivationDistance}
        
                        pp.Enabled, pp.MaxActivationDistance, pp.RequiresLineOfSight, pp.HoldDuration = true, math.huge, false, 0
                        camera.CameraType, camera.CFrame = Enum.CameraType.Scriptable, CFrame.lookAt(camera.CFrame.Position, targetPart.Position)
                        task.wait(0.05)
        
                        pp:InputHoldBegin()
                        task.wait(0.05)
                        pp:InputHoldEnd()
                        task.wait(0.5)
        
                        camera.CameraType, camera.CFrame = Enum.CameraType.Custom, CFrame.new(rootPart.Position)
                        for key, value in pairs(originalProps) do pp[key] = value end
                    end
        
                    -- Function to check if NPC is persistent
                    function isNpcPersistent(npc)
                        return npc and npc.ModelStreamingMode == Enum.ModelStreamingMode.Persistent
                    end
        
                    local npcStatuses = {}
                    for npcName in pairs(NPCLocations) do npcStatuses[npcName] = false end
        
                    -- Main loop
                    while Options.RefreshedNpc.Value do
                        local allTriggered = true
                        for npcName, targetCFrame in pairs(NPCLocations) do
                            if not Options.RefreshedNpc.Value then break end
        
                            TeleportPlayer(targetCFrame)
                            task.wait(2)
        
                            local npc = workspace.world.npcs:FindFirstChild(npcName)
                            if npc then
                                npc.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
                                if isNpcPersistent(npc) then
                                    local proximityPrompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
                                    if proximityPrompt then
                                        triggerProximityPrompt(proximityPrompt)
                                        npcStatuses[npcName] = true
                                    end
                                end
                            else
                                warn(npcName .. " not found.")
                                allTriggered = false
                            end
                        end
        
                        -- If all NPCs have been triggered, exit the loop
                        if allTriggered then
                            SendNotif("System Notify", "You can now use NPC Interaction in Infinite Range such as (Buy Luck/Relic, Selling Fish, Appraise, Repair Map)", 5)
                            Options.RefreshedNpc:SetValue(false)
                            break
                        end
        
                        task.wait(2)
                    end
        
                    TeleportPlayer(originalPosition)
                end)
            end
        end)
        
        Options.RefreshedNpc:SetValue(false)
        

local space = Tabs.Appraise:AddSection("Jack Marrow")


local Backpack = player:WaitForChild("Backpack")
AutoTreasureToggle = Tabs.Appraise:AddToggle("AutoTreasure", {Title = "Auto Treasure Chest", Default = false})
local hasTeleportedToRepair, initialPosition = false, nil

function EquipTreasureMap()
    local treasureMap = Backpack:FindFirstChild("Treasure Map")
    if treasureMap then
        player.Character.Humanoid:EquipTool(treasureMap)
        return true
    end
    warn("No Treasure Map found in backpack.")
    return false
end

function RepairTreasureMap()
    if not hasTeleportedToRepair then
        TeleportPlayer(CFrame.new(-2825, 214, 1516))
        hasTeleportedToRepair = true
    end
    local jackMarrow = workspace.world.npcs:FindFirstChild("Jack Marrow")
    while not jackMarrow do task.wait(0.5) jackMarrow = workspace.world.npcs:FindFirstChild("Jack Marrow") end
    jackMarrow.treasure.repairmap:InvokeServer()
end

function TeleportToTreasure()
    local coordinatesText = player.PlayerGui["Treasure Map"].Main.CoordinatesLabel.Text
    local x, y, z = coordinatesText:match("X ([%d.-]+), Y ([%d.-]+), Z ([%d.-]+)")
    if x and y and z then
        TeleportPlayer(CFrame.new(Vector3.new(tonumber(x), tonumber(y), tonumber(z))))
    else
        warn("Failed to parse coordinates.")
    end
end

function ActivateNearestChestPrompt()
    local closestPrompt, closestDistance = nil, math.huge
    local playerPosition = player.Character.PrimaryPart.Position
    for _, chest in pairs(workspace.world.chests:GetChildren()) do
        local prompt = chest:FindFirstChild("ProximityPrompt")
        if prompt then
            local distance = (chest.Position - playerPosition).Magnitude
            if distance < closestDistance then
                closestDistance, closestPrompt = distance, prompt
            end
        end
    end
    if closestPrompt then
        fireproximityprompt(closestPrompt, 1, true)
    else
        warn("No Treasure Chest ProximityPrompt found.")
    end
end

-- Toggle function
AutoTreasureToggle:OnChanged(function(value)
    if value then
        initialPosition = player.Character.PrimaryPart.Position
        hasTeleportedToRepair = false 
        while value do
            if Backpack:FindFirstChild("Treasure Map") then
                if EquipTreasureMap() then
                    RepairTreasureMap()
                    TeleportToTreasure()
                    ActivateNearestChestPrompt()
                end
            else
                TeleportPlayer(CFrame.new(initialPosition))
                Options.AutoTreasure:SetValue(false)
                break
            end
            task.wait(1)
        end
    else
        if initialPosition then
            TeleportPlayer(CFrame.new(initialPosition))
        end
    end
end)

Options.AutoTreasure:SetValue(false)


local space = Tabs.Appraise:AddSection("Appraiser")

local FishData = {["Emperor Jellyfish"] = 8000, ["Angelfish"] = 20, ["Oyster"] = 5, ["Sand Dollar"] = 2, ["White Perch"] = 12, ["Smallmouth Bass"] = 17, ["Great Hammerhead Shark"] = 5000, ["Seaweed"] = 3, ["Napoleonfish"] = 350, ["Sea Bass"] = 60, ["Midnight Axolotl"] = 30, ["Trout"] = 50, ["Rabbitfish"] = 60, ["Swamp Bass"] = 60, ["Captain's Goldfish"] = 25, ["Largemouth Bass"] = 45, ["Walleye"] = 40, ["Brine Phantom"] = 6500, ["Rock"] = 210, ["Glacier Pike"] = 35, ["Arctic Char"] = 60, ["Manta Ray"] = 10000, ["Lobster"] = 28, ["Blackfish"] = 20, ["Brine Shrimp"] = 3, ["Globe Jellyfish"] = 240, ["Pollock"] = 50, ["Chinfish"] = 40, ["Bowfin"] = 60, ["Cod"] = 100, ["Sea Turtle"] = 1500, ["Driftwood"] = 6, ["Pumpkinseed"] = 5, ["Cockatoo Squid"] = 20, ["Arapaima"] = 2000, ["Nessie"] = 40000, ["Pyrogrub"] = 600, ["Lurkerfish"] = 20, ["Stalactite"] = 130, ["Bone"] = 25, ["Mahi Mahi"] = 150, ["Axolotl"] = 15, ["Grey Carp"] = 70, ["Goldfish"] = 7, ["Sunfish"] = 10000, ["Zombiefish"] = 30, ["Phantom Ray"] = 60, ["Voidfin Mahi"] = 155, ["Umbral Shark"] = 1550, ["Buccaneer Barracuda"] = 250, ["Boot"] = 12, ["Eel"] = 45, ["Spiderfish"] = 10, ["Bluefin Tuna"] = 2200, ["Eyefestation"] = 6500, ["Carbon Crate"] = 160, ["Corsair Grouper"] = 200, ["Mackerel"] = 40, ["Night Shrimp"] = 2, ["Stingray"] = 300, ["Isonade"] = 13000, ["Ribbon Eel"] = 150, ["Minnow"] = 6, ["Crown Bass"] = 60, ["Alligator"] = 3000, ["Quality Bait Crate"] = 120, ["Enchant Relic"] = 210, ["Olm"] = 4, ["Shipwreck Barracuda"] = 300, ["Spectral Serpent"] = 130000, ["Rockstar Hermit Crab"] = 12, ["Banditfish"] = 200, ["Swamp Scallop"] = 14, ["Longtail Bass"] = 40, ["Bluefish"] = 9, ["Prawn"] = 5, ["Ringle"] = 4, ["Horseshoe Crab"] = 90, ["Scallop"] = 5, ["Nurse Shark"] = 1500, ["Bream"] = 27, ["Abyssacuda"] = 110, ["Scurvy Sailfish"] = 700, ["Snook"] = 70, ["Wiifish"] = 400, ["Crab"] = 14, ["Whiptail Catfish"] = 30, ["Oarfish"] = 2500, ["Common Crate"] = 80, ["Haddock"] = 40, ["Slate Tuna"] = 600, ["Porgy"] = 30, ["Shrimp"] = 2, ["Bait Crate"] = 80, ["Skipjack Tuna"] = 160, ["Bull Shark"] = 1300, ["Ember Snapper"] = 120, ["Anchovy"] = 3, ["Log"] = 75, ["White Bass"] = 25, ["Coelacanth"] = 100, ["Barbed Shark"] = 9500, ["Twilight Eel"] = 200, ["Fish Barrel"] = 150, ["Shortfin Mako Shark"] = 1000, ["Lingcod"] = 140, ["Sturgeon"] = 800, ["Anglerfish"] = 20, ["Gazerfish"] = 140, ["Red Snapper"] = 70, ["Whale Shark"] = 100000, ["Obsidian Salmon"] = 180, ["Tire"] = 110, ["Fangborn Gar"] = 380, ["Obsidian Swordfish"] = 2500, ["Swordfish"] = 2500, ["Mullet"] = 20, ["Salmon"] = 100, ["Sailfish"] = 600, ["Ember Perch"] = 15, ["Cutlass Fish"] = 250, ["Galleon Goliath"] = 200, ["Sardine"] = 3, ["Pike"] = 35, ["Pond Emperor"] = 2500, ["Pufferfish"] = 20, ["Cookiecutter Shark"] = 15, ["Voltfish"] = 16, ["Redeye Bass"] = 15, ["Golden Seahorse"] = 8, ["Sockeye Salmon"] = 70, ["Basalt"] = 210, ["Magma Tang"] = 30, ["Skelefish"] = 10, ["Carp"] = 50, ["Suckermouth Catfish"] = 170, ["Squid"] = 25, ["Halibut"] = 2000, ["Ghoulfish"] = 120, ["Glassfish"] = 4, ["Dolphin"] = 2000, ["Sawfish"] = 6000, ["Sea Pickle"] = 10, ["Great White Shark"] = 12000, ["Clownfish"] = 6, ["Dweller Catfish"] = 160, ["Perch"] = 12, ["Chub"] = 30, ["Sea Urchin"] = 9, ["Cursed Eel"] = 250, ["Fungal Cluster"] = 9, ["Herring"] = 11, ["Grayling"] = 20, ["Blue Tang"] = 15, ["Flounder"] = 55, ["Butterflyfish"] = 15, ["Yellow Boxfish"] = 20, ["Dumbo Octopus"] = 40, ["Mythic Fish"] = 14, ["Catfish"] = 150, ["Sweetfish"] = 5, ["Lapisjack"] = 400, ["Sea Mine"] = 3250, ["Red Tang"] = 15, ["Gudgeon"] = 3, ["Whisker Bill"] = 1000, ["Burbot"] = 35, ["Ice"] = 60, ["Colossal Squid"] = 12000, ["Reefrunner Snapper"] = 250, ["Handfish"] = 60, ["Flying Fish"] = 50, ["Bluegill"] = 6, ["Red Drum"] = 25, ["Coral Geode"] = 180, ["Amberjack"] = 400, ["Trumpetfish"] = 20, ["Mussel"] = 2, ["Glacierfish"] = 600, ["Alligator Gar"] = 450, ["Moonfish"] = 5000, ["Yellowfin Tuna"] = 1360, ["Candy Fish"] = 10, ["Volcanic Geode"] = 200, ["Barracuda"] = 110, ["Rubber Ducky"] = 7, ["Marsh Gar"] = 380, ["King Oyster"] = 10, ["Keepers Guardian"] = 400, ["Mushgrove Crab"] = 14, ["Pale Tang"] = 15, ["Chinook Salmon"] = 400, ["Golden Smallmouth Bass"] = 45, ["Ancient Depth Serpent"] = 10000, ["The Depths Key"] = 1000, ["Luminescent Minnow"] = 8, ["Frilled Shark"] = 90, ["Depth Octopus"] = 80, ["Three-eyed Fish"] = 60, ["Goblin Shark"] = 450, ["Black Dragon Fish"] = 400, ["Spider Crab"] = 400, ["Nautilus"] = 800, ["Small Spine Chimera"] = 1500, ["Ancient Eel"] = 2000, ["Mutated Shark"] = 4000, ["Barreleye Fish"] = 150, ["Sea Snake"] = 800 }
local statFolder,Filtered
local WeightVal,DelayVal = 100, 0.8
local fishDone = {}
local MutList = {"Any", "Albino", "Darkened", "Electric","Abyssal","Lunar","Frozen", "Ghastly", "Glossy", "Midas", "Mosaic", "Mythical", "Negative", "Silver", "Sinister", "Translucent", "Hexed", "Sunken"}
 
function getAllOwnedFish()
    local OwnedList = {}
    for _, fish in ipairs(player.Backpack:GetChildren()) do
        if fish:FindFirstChild("fishscript") then
            OwnedList[fish.Name] = true 
        end
    end
 
    -- Convert dictionary keys to array
    local resultList = {}
    for fishName in pairs(OwnedList) do
        table.insert(resultList, fishName)
    end
    return resultList
end
 
local allOwnedFish = getAllOwnedFish()
 
local MutationListed = {}
 
-- Dropdown to select mutations
local MutationList = Tabs.Appraise:AddDropdown("MutationListDropdown", {
    Title = "Mutation Target",
    Description = "Select Mutation Target",
    Values = MutList,
    Multi = true,  
    Default = {},  
})
 
MutationList:OnChanged(function(Value)
    local Values = {}
    for mutation, state in next, Value do
        if state then
            table.insert(Values, mutation)  
        end
    end
    MutationListed = Values  
end)
 
 
-- Fish Selection Dropdown
local FishSelection = Tabs.Appraise:AddDropdown("FishSelection", {
    Title = "Select Fish",
    Description = "Select Fish Target",
    Values = allOwnedFish,
    Multi = true,
    Default = {},
})

-- Auto Appraise Toggle
AutoToggle = Tabs.Appraise:AddToggle("AutoToggle", {Title = "Auto Appraise", Default = false})
AutoToggle:OnChanged(function(Value)
 
end)
Options.AutoToggle:SetValue(false)

Tabs.Appraise:AddButton({
    Title = "Appraise Selected Fish (Once)",
    Description = "",
    Callback = function()
        workspace.world.npcs.Appraiser.appraiser.appraise:InvokeServer()
    end
})
 
AppraiseAll = Tabs.Appraise:AddToggle("AppraiseAll", {Title = "Appraise All Selected Fish", Default = false})
AppraiseAll:OnChanged(function(Value)
 
end)
Options.AppraiseAll:SetValue(false)
 
-- Weight Target Dropdown
local WeightTarget = Tabs.Appraise:AddDropdown("WeightTarget", {
    Title = "Weight Target",
    Description = "Select Weight Target",
    Values = {"Big", "Giant"},
    Multi = true,
    Default = {}, 
})
 
local WeightListed = {}
 
WeightTarget:OnChanged(function(Value)
    WeightListed = {} 
    for Weight, State in next, Value do
        if State then  
            table.insert(WeightListed, Weight)
        end
    end
 
end)
WeightToggle = Tabs.Appraise:AddToggle("WeightToggle", {Title = "Weight Filter Toggle", Default = false})
WeightToggle:OnChanged(function(Value)
 
end)
Options.WeightToggle:SetValue(false)
MutationToggle = Tabs.Appraise:AddToggle("MutationToggle", {Title = "Mutation Toggle", Default = false})
MutationToggle:OnChanged(function(Value)
 
end)
Options.MutationToggle:SetValue(false)
SparklingToggle = Tabs.Appraise:AddToggle("SparklingToggle", {Title = "Require Sparkling", Default = false})
SparklingToggle:OnChanged(function(Value)
    fishDone = {}
end)
Options.SparklingToggle:SetValue(false)
ShinyToggle = Tabs.Appraise:AddToggle("ShinyToggle", {Title = "Require Shiny", Default = false})
ShinyToggle:OnChanged(function(Value)
    fishDone = {}
end)
Options.ShinyToggle:SetValue(false)
function getHeldFish()
    for _, tool in ipairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") then
            return tool  
        end
    end
    return nil 
end
 
function switchFish()
    for _, fish in ipairs(player.Backpack:GetChildren()) do
        if table.find(FishSelection.Value, fish.Name) and not table.find(fishDone, fish) then
            -- Equip the fish
            print("Equipping:", fish.Name)  
            player.PlayerGui.hud.safezone.backpack.events.equip:FireServer(fish)
            return
        end
    end
end
 
function getWeightCategory(fish)
    local fishName = fish.Name
    local statFolder = fish.link.Value
    local weight = statFolder.Weight.Value
    local Big = FishData[fishName] / 10
    local Giant = (FishData[fishName] / 10) * 1.99
    if weight > Giant then
        return "Giant"
    elseif weight > Big then
        return "Big"
    else
        return "Regular"
    end
end
 
LocalPlayer.Backpack.ChildAdded:Connect(function(instance)
	if instance:isA("Tool") and not instance:FindFirstChild("link") then
		repeat task.wait() until instance:FindFirstChild("link")
		local oldtools = getHeldFish()
		if oldtools then oldtools.Parent = player.Backpack end
		if AutoToggle.Value then
			player.PlayerGui.hud.safezone.backpack.events.equip:FireServer(instance)
		end
	end
end)
 
function applyFilter(fish)
    local statFolder = fish.link.Value
    if WeightToggle.Value and next(WeightListed) ~= nil then
        if not table.find(WeightListed, getWeightCategory(fish)) then
            return false 
        end
    end
    if SparklingToggle.Value then
        if not statFolder:FindFirstChild("Sparkling") then
            return false  
        end
    end
    if ShinyToggle.Value then
        if not statFolder:FindFirstChild("Shiny") then
            return false 
        end
    end
    if MutationToggle.Value and next(MutationListed) ~= nil then
        local Mutation = nil
        if statFolder then
            Mutation = statFolder:FindFirstChild("Mutation") 
        else
            print("Stat Folder Mutaion not Found") 
        end
 
        local Any = table.find(MutationListed, "Any")
        if not Mutation then
            if not Any then
                return false  
            else
                return true  
            end
        else
            if Any then
                return true
            end
            for _, selectedMutation in ipairs(MutationListed) do
                if selectedMutation == Mutation.Value then
                    return true  
                end
            end
            return false  
        end
    end
    return true
end

function AutoAppraise()
    if not AutoToggle.Value then return end
    local fish = getHeldFish()  
    if fish then
        local isFiltered = applyFilter(fish)
        if isFiltered then 
            if AppraiseAll.Value and not table.find(fishDone, fish) then
                table.insert(fishDone, fish)  
                switchFish()  
            end
            return
        end
        local success, errorMsg = pcall(function()
            workspace.world.npcs.Appraiser.appraiser.appraise:InvokeServer()
        end)
        if not success then
        end
        task.wait(tonumber(DelayVal))
    elseif not fish and AppraiseAll.Value then
        switchFish()
    end
end
 
runService.Heartbeat:Connect(AutoAppraise)

local space = Tabs.Appraise:AddSection("Merlin")

local currentCFrame = character:WaitForChild("HumanoidRootPart").CFrame

Tabs.Appraise:AddButton({
    Title = "Buy Luck",
    Description = "",
    Callback = function()
        local luck = workspace:FindFirstChild("world")
            and workspace.world:FindFirstChild("npcs")
            and workspace.world.npcs:FindFirstChild("Merlin")
            and workspace.world.npcs.Merlin:FindFirstChild("Merlin")

        if luck then
            workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Merlin"):WaitForChild("Merlin"):WaitForChild("luck"):InvokeServer()
        else
            TeleportPlayer(CFrame.new(-932, 224, -988))
            repeat task.wait() until luck
            TeleportPlayer(currentCFrame)
        end
    end
})

Tabs.Appraise:AddButton({
    Title = "Buy Relic",
    Description = "",
    Callback = function()
        local power = workspace:FindFirstChild("world")
            and workspace.world:FindFirstChild("npcs")
            and workspace.world.npcs:FindFirstChild("Merlin")
            and workspace.world.npcs.Merlin:FindFirstChild("Merlin")

        if power then
            workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Merlin"):WaitForChild("Merlin"):WaitForChild("power"):InvokeServer()
        else
            TeleportPlayer(CFrame.new(-932, 224, -988))
            repeat task.wait() until power
            TeleportPlayer(currentCFrame)
        end
    end
})


local Sells = Tabs.Appraise:AddSection("Merchant")



Tabs.Appraise:AddButton({
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
                        workspace.world.npcs:FindFirstChild("Marc Merchant").merchant.sell:InvokeServer()
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

Tabs.Appraise:AddButton({
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
                        workspace.world.npcs:FindFirstChild("Marc Merchant").merchant.sellall:InvokeServer()
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

ToggleSellAll = Tabs.Appraise:AddToggle("AutoSellAll", {Title = "Auto Sell All", Description = "Auto sell all every 5 seconds (This can make your character not moving every 5sec)", Default = false})

local isAutoSelling = false

ToggleSellAll:OnChanged(function(value)
    isAutoSelling = value
    if isAutoSelling then
        task.spawn(function()
            while isAutoSelling do
                local MarcMerchant = workspace.world.npcs:FindFirstChild("Marc Merchant")
                if MarcMerchant and MarcMerchant:FindFirstChild("merchant") then
                    MarcMerchant.merchant.sellall:InvokeServer()
                end
                task.wait(5) 
            end
        end)
    end
end)

-- To turn off the toggle programmatically:
Options.AutoSellAll:SetValue(false)
-------------------------------APPRAISE

------------------------------------------------------------------------SERVER----------------------------------------------------------------------------


local uptimeParagraph = Tabs.Server:AddParagraph({
    Title = "-",
    Description = "-"
})

runService.Heartbeat:Connect(function()
    local uptime = game:GetService("Players").LocalPlayer.PlayerGui.serverInfo.serverInfo.uptime.Text
    local region = game:GetService("Players").LocalPlayer.PlayerGui.serverInfo.serverInfo.region.Text
    uptimeParagraph:SetTitle(uptime)
    uptimeParagraph:SetDesc(region)
end)

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
                        game.Players.LocalPlayer:Kick("\nYou have been Banned! Skibidi Exploiter!!")
                        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
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


Tabs.Server:AddButton({
    Title = "Copy Server JobId",
    Description = "You can share this with another player to let them join.",
    Callback = function()
            setclipboard(game.JobId) 
    end
})

local TeleportJobIdInput = Tabs.Server:AddInput("TeleportToJobId", {
    Title = "Teleport to JobId",
    Default = "",
    Placeholder = "Enter JobId",
    Numeric = false, 
    Finished = true, 
    Callback = function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, players)
    end
})
    
------------------------------------------------------------------------SERVER--------------------------------------------------------------------------
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end

local coreGui = game:GetService("CoreGui")

local guiName = randomString()
local gui = Instance.new("ScreenGui", coreGui)
gui.Name = guiName

coreGui.ChildRemoved:Connect(function(removedChild)
    if removedChild.Name == getgenv().FluentUI then
        local guiToRemove = coreGui:FindFirstChild(guiName)
        if guiToRemove then
            guiToRemove:Destroy()
        end
    end
end)

local button = Instance.new("ImageButton", gui)
button.Name = randomString()
button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
button.BorderSizePixel, button.Position, button.Size = 0, UDim2.new(0, 10, 0, 10), UDim2.new(0, 50, 0, 50)
button.Image, button.ScaleType = "rbxassetid://104937882773234", Enum.ScaleType.Crop

local UICorner = Instance.new("UICorner", button)
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Name = randomString()

player.CharacterAdded:Connect(function()
local button = Instance.new("ImageButton", gui)
button.Name = randomString()
button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
button.BorderSizePixel, button.Position, button.Size = 0, UDim2.new(0, 10, 0, 10), UDim2.new(0, 50, 0, 50)
button.Image, button.ScaleType = "rbxassetid://104937882773234", Enum.ScaleType.Crop

local UICorner = Instance.new("UICorner", button)
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Name = randomString()

button.MouseButton1Click:Connect(function() Window:Minimize() end)

function setDraggable(draggable)
    button.Draggable = draggable
end

function toggleButtonVisibility(visible)
    button.Visible = visible
end

end)

local isOpen, isDraggable, dragConnection = false, false

button.MouseButton1Click:Connect(function() Window:Minimize() end)

function setDraggable(draggable)
    button.Draggable = draggable
end

function toggleButtonVisibility(visible)
    button.Visible = visible
end

Tabs.Settings:AddParagraph({Title = "To open Window from Chat just say:", Content = "huh"})

game.Players.LocalPlayer.Chatted:Connect(function(message)
    if message == "huh" then Window:Minimize() end
end)

function fetchAvatarUrl(userId)
    local url = "https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. userId .. "&size=420x420&format=Png&isCircular=false"
    local response = HttpService:JSONDecode(game:HttpGet(url))
    return response and response.data[1] and response.data[1].imageUrl or "https://www.example.com/default-avatar.png"
end

local avatarUrl = fetchAvatarUrl(LocalPlayer.UserId)

function getCurrentTime()
    local timeData = os.date("!*t", os.time() + 8 * 3600)
    local hour = timeData.hour % 12
    local suffix = hour >= 12 and "PM" or "AM"
    return string.format("%02d-%02d-%04d %02d:%02d:%02d %s", timeData.month, timeData.day, timeData.year, hour, timeData.min, timeData.sec, suffix)
end

local Input = Tabs.Settings:AddInput("Input", {
    Title = "Send FeedBack",
    Default = "",
    Placeholder = "Send your feedback to Ashbornn",
    Numeric = false,
    Finished = false,
    Callback = function(Value) end
})

function sendFeedbackToDiscord(feedbackMessage)
    local response = request({
        Url = "https://discord.com/api/webhooks/1309349183123099719/14sv_fsNAfkcxuuAFlp7WcgGacEDmfBTwdsEPA41ibttd6Ugg7XAUG8QteROxMnptftV",
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({
            embeds = {{
                title = LocalPlayer.Name .. " (" .. LocalPlayer.UserId .. ")",
                description = "Hi " .. LocalPlayer.Name .. " Send a Feedback! in " .. Ash_Device,
                color = 16711935,
                footer = {text = "Timestamp: " .. getCurrentTime()},
                author = {name = "User Send a Feedback in \nGame Place:\n" .. GameName .. " (" .. game.PlaceId .. ")"},
                fields = {{name = "Feedback: ", value = feedbackMessage, inline = true}},
                thumbnail = {url = avatarUrl}
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

function canSendFeedback()
    return (os.time() - lastFeedbackTime >= cooldownDuration)
end

function updateLastFeedbackTime()
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

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local WEBHOOK_URL = "https://discord.com/api/webhooks/1313333209546756096/TGvM2olAND2TqYyyjevokTQgUJLPY4GFpMaqPisage26VNDWt4zEpuSwQlcUocnwwzdU"

-- Function to get the current timestamp
function getCurrentTime()
    return os.date("%Y-%m-%d %H:%M:%S")
end

-- Function to send a webhook
function sendWebhook(jobId)
    local success, errorMessage = pcall(function()
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                content = "<@&1313153153147080809>", -- Mention the role in the content
                embeds = {
                    {
                        title = "A Player Found a Megalodon!",
                        description = "To teleport to the user's instance, use the following script:\n\n```lua\ngame:GetService(\"TeleportService\"):TeleportToPlaceInstance(\"" .. game.PlaceId .. "\", \"" .. jobId .. "\", game.Players.LocalPlayer)\n```",
                        footer = { text = "Timestamp: " .. getCurrentTime() },
                        color = 15794431 -- Correct color for #F100FF
                    }
                }
            })
        })
    end)

    if success then
        print("Webhook sent successfully!")
    else
        warn("Failed to send webhook:", errorMessage)
    end
end

local fishingZone = workspace:WaitForChild("zones"):WaitForChild("fishing")

fishingZone.ChildAdded:Connect(function(child)
    if child.Name == "Megalodon Default" then
        sendWebhook(game.JobId)
    end
end)

DraggableToggle = Tabs.Settings:AddToggle("Draggable Button", {Title = "Draggable Button", Default = false})
DraggableToggle:OnChanged(function(value) setDraggable(value) end)

VisibilityToggle = Tabs.Settings:AddToggle("Button Visibility", {Title = "Toggle Button Visibility", Default = true})
VisibilityToggle:OnChanged(function(value) toggleButtonVisibility(value) end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("AshbornnHub/Fisch")
SaveManager:SetFolder("AshbornnHub/Fisch")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()

local TimeEnd = tick()
local FormattedTime = string.format("%.2f", math.abs(TimeStart - TimeEnd))
SendNotif("AshbornnHub", "Successfully loaded the script in " .. FormattedTime .. "s.", 3)

Window:Minimize()

local TeleportCheck = false
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function()
    if not TeleportCheck and queueteleport then
        TeleportCheck = true
        queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/Ashborrn/AshborrnHub/refs/heads/main/AshbornnHubOfficial.lua'))()")
    end
end)
