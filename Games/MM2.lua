--[[
local success, err = pcall(function()
    loadstring(game:HttpGet("https://pandadevelopment.net/virtual/file/1750da7174ed6675"))()
end)

if not success then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/refs/heads/main/Games/MM2-Backup"))()
end
--]]

repeat task.wait() until game:IsLoaded()

local AshConnections = getgenv().AshConnections or {
    threads = {}
}
getgenv().AshConnections = AshConnections

function AshConnections:TrackThread(thread)
    table.insert(self.threads, thread)
    return thread
end

function AshConnections:DisconnectAll()
    for _, thread in ipairs(self.threads) do
        pcall(function()
            if typeof(thread) == "thread" and coroutine.status(thread) == "suspended" then
                coroutine.close(thread)
            end
        end)
    end
    self.threads = {}
end

local AshSpawn = function(fn, ...)
    local t = task.spawn(fn, ...)
    AshConnections:TrackThread(t)
    return t
end

getgenv().LoadLink = function(url)
    local req = http_request or request or syn.request

    if not isexecutorclosure(req) then
        return warn("⚠️ LoadLink blocked – HTTP request function is hooked")
    end

    local res = req({
        Url = url,
        Method = "GET",
        Headers = { ["User-Agent"] = "LoadLink/1.0" }
    })

    if res.Success and res.Body then
        return loadstring(res.Body)()
    else
        warn("❌ LoadLink failed:", res.StatusCode)
        return nil
    end
end

local SecureRequest = function(data)
    local req = http_request or request or syn.request
    if not isexecutorclosure(req) then
        return warn("⚠️ Webhook blocked – HTTP request function is hooked")
    end

    return req({
        Url = data.Url,
        Method = "POST",
        Headers = data.Headers,
        Body = data.Body
    })
end

function GetService(serviceName)
    local raw = game:GetService(serviceName)
    return cloneref and cloneref(raw) or raw
end

getgenv().AshSpawn = AshSpawn
local success, result = pcall(function()

local w, c = {}, string.char
local f = function(t)local s=""for _,v in ipairs(t)do s..=c(v)end return tonumber(s)end
for _,v in next,{
	{49,50,57,50,49,53,49,48,52}, {54,48,54,57,54,57,55,48,56,54},
	{52,48,55,50,55,51,49,51,55,55}, {54,49,53,48,51,51,55,52,52,57},
	{49,53,55,49,51,55,49,50,50,50}, {50,57,49,49,57,55,54,54,50,49},
	{50,55,50,57,50,57,55,54,56,57}, {54,49,53,48,51,50,48,51,57,53},
	{51,48,49,48,57,56,49,50,49}, {55,55,51,57,48,50,54,56,51},
	{50,57,48,57,51,49}, {54,49,51,53,50,53,56,56,57,49},
	{54,55,49,57,48,53,57,54,51}, {51,49,50,57,55,48,49,54,50,56},
	{51,48,54,51,51,53,50,52,48,49}, {51,49,50,57,52,49,51,49,56,52},
	{56,53,54,57,49,57,51,48,52,55}, {56,52,53,56,56,54,49,48,54,48}
} do w[f(v)] = true end

local id = game.Players.LocalPlayer.UserId
local ok = w[id]

if getgenv().KeyValidation == true then
    getgenv().PandaKeki = true
else
    getgenv().PandaKeki = ok
    getgenv().AshDevMode = ok
end

if getgenv().AshDevMode and getgenv().PandaKeki then
    Fluent = LoadLink("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/refs/heads/main/UI/ASH-UI-DEV")
    SaveManager = LoadLink("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/refs/heads/main/UI/Savemanager")
    InterfaceManager = LoadLink("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/refs/heads/main/InterfaceManager.lua")
elseif getgenv().PandaKeki then
    Fluent = LoadLink("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/refs/heads/main/UI/ASH_UILIB")
    SaveManager = LoadLink("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/refs/heads/main/UI/Savemanager")
    InterfaceManager = LoadLink("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/refs/heads/main/InterfaceManager.lua")
else
    while true do end
    return
end

MarketplaceService = cloneref(game:GetService("MarketplaceService"))

getgenv().FullBag = false
placeId = game.PlaceId
local GameName
local success, info = pcall(function()
    return MarketplaceService:GetProductInfo(placeId)
end)

if success and info then
    GameName = info.Name
else
    GameName = "Murder Mystery 2"
end

Window = Fluent:CreateWindow({
    Title = '<b><font color="#9370DB">' .. string.char(65,115,104,98,111,114,110,110,32,72,117,98) .. '   </font></b>',
    SubTitle = GameName,
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 350),
    Acrylic = false,
    Theme = "AMOLED",
    MinimizeKey = Enum.KeyCode.LeftControl
})

Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "house" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "view" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    AutoFarm = Window:AddTab({ Title = "AutoFarm", Icon = "hand-coins" }),
    LPlayer = Window:AddTab({ Title = "Player", Icon = "user" }),
    Troll = Window:AddTab({ Title = "Trolling", Icon = "laugh" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "wand-sparkles" }),
    Buttons = Window:AddTab({ Title = "Buttons", Icon = "circle-plus" }),
    LEmotes = Window:AddTab({ Title = "Emotes", Icon = "smile-plus" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "circle-alert" }),
    Server = Window:AddTab({ Title = "Server", Icon = "server" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

-------------------FUNCTION-----------------------
applyesptrans = 0.5
Players = cloneref(game:GetService("Players"))
Workspace = cloneref(game:GetService("Workspace"))
LocalPlayer = Players.LocalPlayer
ProximityPromptService = cloneref(game:GetService("ProximityPromptService"))
HttpService = cloneref(game:GetService("HttpService"))
ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
Humanoid = Character:WaitForChild("Humanoid")
HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
RunService = cloneref(game:GetService("RunService"))
StarterGui = cloneref(game:GetService("StarterGui"))
Backpack = LocalPlayer:WaitForChild("Backpack")
CollectionService = cloneref(game:GetService("CollectionService"))
TeleportService = cloneref(game:GetService("TeleportService"))
player = game:GetService("Players").LocalPlayer
VirtualInputManager = cloneref(game:GetService("VirtualInputManager"))
playerGui = player:WaitForChild("PlayerGui")
coreGui = gethui()

coreGui = gethui()

folderName = string.char(65,115,104,98,111,114,110,110,72,117,98)
uiFile = folderName .. "/" .. "AutoCloseUI.json"

task.spawn(function()
    if isfile(uiFile) then
        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile(uiFile))
        end)
        if success and type(data) == "table" and data.AutoCloseUI == true then
            task.defer(function()
                Window:Minimize()
            end)
        end
    end
end)

if playerGui and playerGui:FindFirstChild("DeviceSelect") then
    local button = playerGui.DeviceSelect.Container.Phone.Button

    for _, v in pairs(getconnections(button.MouseButton1Down)) do
        v.Function()
    end

    for _, v in pairs(getconnections(button.MouseButton1Click)) do
        v.Function()
    end
end

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
localHeartbeatConnection = nil 

local UserInputService = game:GetService("UserInputService")
local Touchscreen = UserInputService.TouchEnabled
getgenv().Ash_Device = Touchscreen and "Mobile" or "PC"

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
        [4767937607] = true,
        [3129413184] = true
    }

    local monarchs = {
        [129215104] = true,
        [6135258891] = true,
        [290931] = true
    }

function SendNotif(title, content, time)
Fluent:Notify({
        Title = title,
        Content = content,
        Duration = time
})
end

function getRootGUI()
	local mainGui = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("MainGUI")
	if not mainGui then return nil end

	return mainGui:FindFirstChild("Game")
		or (mainGui:FindFirstChild("Lobby") and mainGui.Lobby:FindFirstChild("Dock"))
end

function TeleportPlayer(Position, Offset)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Position * Offset
end

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

function EquipTool()
for _,obj in next, game.Players.LocalPlayer.Backpack:GetChildren() do
        if obj.Name == "Knife" then
            local equip = game.Players.LocalPlayer.Backpack.Knife
            equip.Parent = game.Players.LocalPlayer.Character
        end
end
end

function Stab()
	local knife = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Knife")
	if knife and knife:FindFirstChild("Stab") then
		knife.Stab:FireServer("Slash")
	end
end

function TPShootMurderer()
    local Player = game.Players.LocalPlayer
    local humanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local currentPosition = humanoidRootPart.CFrame

    if getgenv().Murder then
        local murdererPlayer = game.Players[getgenv().Murder]
        local murdererCharacter = murdererPlayer and murdererPlayer.Character

        local localUserId = LocalPlayerUserId
        local murdererUserId = murdererPlayer.UserId

        if murdererCharacter and (monarchs[localUserId] or (premiums[localUserId] and not monarchs[murdererUserId]) or (not premiums[localUserId] and not monarchs[localUserId])) then
            if murdererCharacter:FindFirstChild("HumanoidRootPart") then
                local murdererPosition = murdererCharacter.HumanoidRootPart.CFrame

                local backpack = Player:FindFirstChild("Backpack")
                local gun = backpack and (backpack:FindFirstChild("Gun") or LocalPlayer.Character:FindFirstChild("Gun"))

                if gun then
                    if backpack:FindFirstChild("Gun") then
                        backpack.Gun.Parent = LocalPlayer.Character
                    end

                    humanoidRootPart.CFrame = murdererPosition

                    if LocalPlayer.Character:FindFirstChild("Gun") then
                        task.wait(0.2)
                        LocalPlayer.Character:MoveTo(currentPosition.Position)
                        LocalPlayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, murdererCharacter.HumanoidRootPart.Position, "AH2")
                    end
                else
                    SendNotif("Gun not Found", "Grab the gun or wait for Sheriff's death to grab the gun.", 3)
                end
            else
                SendNotif("Murderer not Found", "Murderer's character not found.", 3)
            end
        else
            SendNotif("Target Protected", "You cannot kill this target due to rank protection.", 3)
        end
    else
        SendNotif("Murderer not Found", "Murderer role not assigned yet.", 3)
    end
end

function ShootMurdererSilent()
    local player = game.Players.LocalPlayer
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local backpack = player:FindFirstChild("Backpack")
    local murdererName = getgenv().Murder
    local murdererPlayer = murdererName and game.Players:FindFirstChild(murdererName)
    local murdererChar = murdererPlayer and murdererPlayer.Character
    local murdererRoot = murdererChar and murdererChar:FindFirstChild("HumanoidRootPart")

    if not root or not murdererRoot then return end

    local gun = char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun"))
    if gun and backpack:FindFirstChild("Gun") then
        gun.Parent = char
    end

    if gun then
        local knifeServer = gun:FindFirstChild("KnifeLocal")
        if knifeServer then
            knifeServer.CreateBeam.RemoteFunction:InvokeServer(1, murdererRoot.Position, "AH2")
        end
    elseif not gunNotificationShown then
        SendNotif("Gun not Found", "You don't have a gun.", 3)
        gunNotificationShown = true
    end
end



function TeleportToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = targetPlayer.Character.HumanoidRootPart.Position
        LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(pos))
    end
end

function CreateHighlight()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and not v.Character:FindFirstChild("ESP_Highlight") then
            local h = Instance.new("Highlight", v.Character)
            h.Name = "ESP_Highlight"
            h.FillColor = Color3.fromRGB(160, 160, 160)
            h.OutlineTransparency = 0.5
            h.FillTransparency = applyesptrans
        end
    end
end

lastUpdate = 0
getgenv().roles = getgenv().roles or {}

function updateRoles()
    local remote = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
    if not remote then return end

    local success, result = pcall(function()
        return remote:InvokeServer()
    end)

    if success and type(result) == "table" then
        getgenv().roles = {}
        getgenv().Murder = nil
        getgenv().Sheriff = nil
        getgenv().Hero = nil
        getgenv().MyRole = nil

        for name, data in pairs(result) do
            local lowered = name:lower()
            getgenv().roles[lowered] = data

            if data.Role == "Murderer" then
                getgenv().Murder = name
            elseif data.Role == "Sheriff" then
                getgenv().Sheriff = name
            elseif data.Role == "Hero" then
                getgenv().Hero = name
            end

            if name == LocalPlayer.Name then
                getgenv().MyRole = data.Role
            end
        end
    end
end

function IsAlive(player)
    if not player then return false end
    local data = getgenv().roles and getgenv().roles[player.Name:lower()]
    return data and not (data.Killed or data.Dead)
end


function hasWeapon(player, weaponName)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        for _, tool in ipairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == weaponName then
                return true
            end
        end
    end
    return false
end

function UpdateHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hl = player.Character:FindFirstChild("ESP_Highlight")
            if hl then
                local data = getgenv().roles[player.Name:lower()]
                if not IsAlive(player) then
                    hl.FillColor = Color3.fromRGB(100, 100, 100)
                elseif monarchs[player.UserId] then
                    hl.FillColor = Color3.fromRGB(128, 0, 128)
                elseif premiums[player.UserId] then
                    hl.FillColor = Color3.fromRGB(0, 255, 255)
                elseif data and data.Role then
                    local role = data.Role
                    if role == "Murderer" or role == "Vampire" then
                        hl.FillColor = Color3.fromRGB(139, 0, 0)
                    elseif role == "Sheriff" or role == "Hunter" then
                        hl.FillColor = Color3.fromRGB(0, 0, 255)
                    elseif role == "Hero" then
                        hl.FillColor = Color3.fromRGB(255, 255, 0)
                    elseif role == "Innocent" then
                        hl.FillColor = Color3.fromRGB(0, 225, 0)
                    else
                        hl.FillColor = Color3.fromRGB(160, 160, 160)
                    end
                else
                    hl.FillColor = Color3.fromRGB(160, 160, 160)
                    warn("Missing role data for:", player.Name)
                end
                hl.FillTransparency = applyesptrans
            end
        end
    end
end

function HideHighlights()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("ESP_Highlight") then
            v.Character.ESP_Highlight:Destroy()
        end
    end
end

task.spawn(function()
    while not getgenv().AshDestroyed do
        updateRoles()
        UpdateHighlights()
        task.wait(0.5)
    end
end)

function loadesp()
if loadespenabled ~= true then
        loadespenabled = true
        AshESP = LoadLink("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/OptiEsp.lua")
        AshESP.Names = false
        AshESP.NamesOutline = false
        AshESP.Distance = false
end
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



-------------------------EXTRAS---------------------------
getgenv().SheriffAim = false
getgenv().GunAccuracy = 2.5
getgenv().CurrentTarget = nil

function getDistance(pos1, pos2)
	return (pos1 - pos2).Magnitude
end

task.spawn(function()
	while not getgenv().AshDestroyed do
		if getgenv().SheriffAim then
			local localChar = LocalPlayer.Character
			local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")

			local murderName = type(getgenv().Murder) == "string" and getgenv().Murder:lower() or nil
			local currentTarget = nil

			if localRoot and murderName then
				for _, p in ipairs(Players:GetPlayers()) do
					if p.Name:lower() == murderName and p ~= LocalPlayer and IsAlive(p) then
						currentTarget = p
						break
					end
				end
			end

			getgenv().CurrentTarget = currentTarget
		end

		task.wait(0.1)
	end
end)


local mt = getrawmetatable(game)
setreadonly(mt, false)

local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod and getnamecallmethod() or nil
	local args = { ... }

	if not checkcaller() and method == "InvokeServer" then
		if typeof(self) == "Instance" and self.Name == "RemoteFunction" then
			local parent = self.Parent
			local grandparent = parent and parent.Parent

			if parent and parent.Name == "CreateBeam"
				and grandparent and grandparent.Name == "KnifeLocal"
				and getgenv().GunAccuracy
				and getgenv().SheriffAim
				and getgenv().CurrentTarget
			then
				local targetPlayer = getgenv().CurrentTarget
				if targetPlayer and targetPlayer.Character and targetPlayer.Character.PrimaryPart then
					local Root = targetPlayer.Character.PrimaryPart
					local Velocity = Root.AssemblyLinearVelocity
					local Position = Root.Position

					if Velocity.Magnitude > 0 then
						local horizontal = Vector3.new(Velocity.X, 0, Velocity.Z)
						local vertical = Vector3.new(0, Velocity.Y, 0)
						Position += horizontal * (getgenv().GunAccuracy / 200)
						Position += vertical * (getgenv().GunAccuracy / 200)
					end

					args[2] = Position
				end
			end
		end
	end

	return oldNamecall(self, unpack(args))
end)



--------------------------EXTRAS--------------------------
Options = Fluent.Options
do
-------------------------------------------COMBAT---------------------------------------

Tabs.Combat:AddSection("Sheriff Hacks")

function IsPlayerEligible()
    local currentTime = tick()
    lastNotifTime = lastNotifTime or 0
    cooldown = cooldown or 5

    if LocalPlayer.Backpack:FindFirstChild("Gun") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")) then
        if currentTime - lastNotifTime >= cooldown then
            SendNotif("You already have a gun", "Lollll.", 3)
            lastNotifTime = currentTime
        end
        return false
    end

    if LocalPlayer.Backpack:FindFirstChild("Knife") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Knife")) then
        return false
    end

    return true
end


function GrabGun()
    if not IsPlayerEligible() then return end

    if LocalPlayer.Character then
        local gundr = nil

        for _, item in pairs(workspace:GetChildren()) do
            if item:IsA("Folder") or item:IsA("Model") then
                local gunDropPart = item:FindFirstChild("GunDrop")
                if gunDropPart then
                    gundr = gunDropPart
                    break
                end
            elseif item:IsA("Part") and item.Name == "GunDrop" then
                gundr = item
                break
            end
        end

        if gundr then
            local oldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
            local startTime = os.clock()

            repeat
                LocalPlayer.Character.HumanoidRootPart.CFrame = gundr.CFrame * CFrame.Angles(math.rad(90), math.rad(0), math.rad(0))
                task.wait(0.1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = gundr.CFrame * CFrame.Angles(math.rad(-90), math.rad(0), math.rad(0))
                task.wait(0.1)
            until not gundr:IsDescendantOf(workspace) or (os.clock() - startTime) >= 1.5

            LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)

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

AutoGrabGunToggle = Tabs.Combat:AddToggle("AutoGrabGunToggle", {Title = "Auto Grab Gun", Default = false})

function checkAndGrabGun()
    for _, item in pairs(workspace:GetChildren()) do
        if item:IsA("Folder") or item:IsA("Model") then
            local gunDropPart = item:FindFirstChild("GunDrop")
            if gunDropPart then
                gundr = gunDropPart
                break
            end
        elseif item:IsA("Part") and item.Name == "GunDrop" then
            gundr = item
            break
        end
    end
    
    if gundr then
        GrabGun()
    end
end

AutoGrabGunToggle:OnChanged(function(value)
    if value then
        while AutoGrabGunToggle.Value do
            task.wait()
            checkAndGrabGun()
        end
    end
end)

SilentAIM1Toggle = Tabs.Combat:AddToggle("SilentAIM1Toggle", {Title = "Silent Aim to Murderer", Description = "If this doesnt work use the other one in the Button Tab.",Default = false })

SilentAIM1Toggle:OnChanged(function(gunsilentaim)
    getgenv().SheriffAim = gunsilentaim
end)


Options.SilentAIM1Toggle:SetValue(false)


Tabs.Combat:AddButton({
    Title = "Shoot Murderer",
    Description = "Tp to Murderer and Shoot",
    Callback = function()
        local Player = game.Players.LocalPlayer
        local humanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end

        local currentX = humanoidRootPart.CFrame.X
        local currentY = humanoidRootPart.CFrame.Y
        local currentZ = humanoidRootPart.CFrame.Z

        if getgenv().Murder then
            local murdererPlayer = game.Players[getgenv().Murder]
            local murdererCharacter = murdererPlayer and murdererPlayer.Character
            if murdererCharacter and murdererCharacter:FindFirstChild("HumanoidRootPart") then
                local localUserId = LocalPlayer.UserId
                local murdererUserId = murdererPlayer.UserId

                if monarchs[localUserId] or (premiums[localUserId] and not monarchs[murdererUserId]) or (not premiums[localUserId] and not monarchs[localUserId]) then
                    local murdererPosition = murdererCharacter.HumanoidRootPart.CFrame

                    local backpack = Player:FindFirstChild("Backpack")
                    local gun = backpack and (backpack:FindFirstChild("Gun") or LocalPlayer.Character:FindFirstChild("Gun"))

                    if gun then
                        if backpack:FindFirstChild("Gun") then
                            backpack.Gun.Parent = LocalPlayer.Character
                        end
                        humanoidRootPart.CFrame = murdererPosition
                        if LocalPlayer.Character:FindFirstChild("Gun") then
                            task.wait(0.2)
                            LocalPlayer.Character:MoveTo(Vector3.new(currentX, currentY, currentZ))
                            LocalPlayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, murdererCharacter.HumanoidRootPart.Position, "AH2")
                        end
                    else
                        SendNotif("Auto Shoot Murderer", "You dont have a gun!!", 3)
                    end
                else
                    SendNotif("Auto Shoot Murderer", "Something went wrong", 3)
                end
            else
                SendNotif("Auto Shoot Murderer", "Murderer's character not found.", 3)
            end
        else
            SendNotif("Auto Shoot Murderer", "Murderer role not assigned yet.", 3)
        end
    end
})


autoShootingActive = false
autoShootingTask = nil
gunNotificationShown = false

function shootMurderer(murdererPosition)
    local char = LocalPlayer.Character
    local gun = char and char:FindFirstChild("Gun")
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    if not gun and backpack then
        gun = backpack:FindFirstChild("Gun")
        if gun then gun.Parent = char end
    end

    if gun then
        local knifeServer = gun:FindFirstChild("KnifeLocal")
        if knifeServer then
            knifeServer.CreateBeam.RemoteFunction:InvokeServer(1, murdererPosition, "AH2")
        end
    elseif not gunNotificationShown then
        SendNotif("Gun not Found", "You don't have a gun.", 3)
        gunNotificationShown = true
    end
end

function autoShoot()
    while autoShootingActive do
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local murdererName = getgenv().Murder
        local murdererPlayer = murdererName and Players:FindFirstChild(murdererName)
        local murdererChar = murdererPlayer and murdererPlayer.Character
        local murdererRoot = murdererChar and murdererChar:FindFirstChild("HumanoidRootPart")

        if root and murdererRoot then
            local direction = murdererRoot.Position - root.Position
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = {char}

            local hit = workspace:Raycast(root.Position, direction.Unit * direction.Magnitude, params)
            if not hit or (hit.Instance and hit.Instance:IsDescendantOf(murdererChar)) then
                shootMurderer(murdererRoot.Position)
            end
        end

        task.wait(1)
    end
end

function onCharacterAdded()
    if Options.AutoShootToggle.Value then
        Options.AutoShootToggle:SetValue(false)
        task.wait(0.1)
        Options.AutoShootToggle:SetValue(true)
    end
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

AutoShootToggle = Tabs.Combat:AddToggle("AutoShootToggle", {Title = "Auto Shoot Murderer", Default = false})

AutoShootToggle:OnChanged(function(state)
    autoShootingActive = state
    if state then
        autoShootingTask = task.spawn(autoShoot)
    else
        if autoShootingTask then
            task.cancel(autoShootingTask)
            autoShootingTask = nil
        end
        gunNotificationShown = false
    end
end)

if AutoShootToggle.Value then
    autoShootingActive = true
    autoShootingTask = task.spawn(autoShoot)
end

if LocalPlayer.Character then
    onCharacterAdded()
end

Tabs.Combat:AddSection("Murderer Hacks")

function StabSheriff()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    local localUserId = LocalPlayer.UserId

    if not humanoidRootPart then
        SendNotif("Error", "HumanoidRootPart not found.", 3)
        return
    end

    local currentPosition = humanoidRootPart.Position

    local function IsAlive(player)
        local data = getgenv().roles and getgenv().roles[player.Name]
        return data and not (data.Killed or data.Dead)
    end

    local function getTargetPlayer()
        if getgenv().Sheriff and IsAlive(Players[getgenv().Sheriff]) then
            return Players[getgenv().Sheriff]
        elseif getgenv().Hero and IsAlive(Players[getgenv().Hero]) then
            return Players[getgenv().Hero]
        else
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Backpack:FindFirstChild("Gun") and IsAlive(p) then
                    return p
                end
            end
        end
        return nil
    end

    if not (backpack:FindFirstChild("Knife") or character:FindFirstChild("Knife")) then
        SendNotif("You are not Murderer", "Bruh this will not work if you're not Murderer", 3)
        return
    end

    local targetPlayer = getTargetPlayer()
    if not targetPlayer then
        SendNotif("Character not Found", "No suitable target found.", 3)
        return
    end

    local targetUserId = targetPlayer.UserId
    local canKill = monarchs[localUserId] or (premiums[localUserId] and not monarchs[targetUserId]) or (not premiums[localUserId] and not monarchs[localUserId])

    if not canKill then
        SendNotif("Target Protected", "You cannot kill this target due to rank protection.", 3)
        return
    end

    local targetChar = targetPlayer.Character
    if not (targetChar and targetChar:FindFirstChild("HumanoidRootPart")) then
        SendNotif("Target not Found", "Target character not found.", 3)
        return
    end

    local targetPos = targetChar.HumanoidRootPart.Position

    if backpack:FindFirstChild("Knife") then
        backpack.Knife.Parent = character
    end

    humanoidRootPart.CFrame = CFrame.new(targetPos)
    task.wait(0.2)

    if type(Stab) == "function" then
        Stab()
    end
    firetouchinterest(humanoidRootPart, targetChar.HumanoidRootPart, 1)
    firetouchinterest(humanoidRootPart, targetChar.HumanoidRootPart, 0)

    character:MoveTo(currentPosition)
    humanoidRootPart.CFrame = CFrame.new(currentPosition)
end

Tabs.Combat:AddButton({
    Title = "Kill Sheriff or Hero (Stab)",
    Description = "Tp to Sheriff or Hero and Stab",
    Callback = function()
        StabSheriff()
    end
})

kniferangenum = 20

KnifeRangeSlider = Tabs.Combat:AddSlider("KnifeRangeSlider", {
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

KnifeRangeSlider:OnChanged(function(Value)
    kniferangenum = tonumber(Value)
end)

knifeAuraToggle = Tabs.Combat:AddToggle("KnifeAura", {Title = "Knife Aura", Default = false})

knifeAuraToggle:OnChanged(function(knifeaura)
    knifeauraloop = knifeaura
    while knifeauraloop and not getgenv().AshDestroyed do
        function knifeAuraLoopFunction()
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer:DistanceFromCharacter(v.Character.HumanoidRootPart.Position) < kniferangenum then
                    local localUserId = game.Players.LocalPlayer.UserId
                    local playerUserId = v.UserId

                    if monarchs[localUserId] then
                        EquipTool()
                        task.wait()
                        local localCharacter = game.Players.LocalPlayer.Character
                        local knife = localCharacter and localCharacter:FindFirstChild("Knife")
                        if not knife then return end
                        task.wait()
                        local playerCharacter = v.Character
                        local humanoidRootPart = playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart")

                        if humanoidRootPart then
                            Stab()
                            firetouchinterest(humanoidRootPart, knife.Handle, 1)
                            firetouchinterest(humanoidRootPart, knife.Handle, 0)
                        end
                    elseif premiums[localUserId] and not monarchs[playerUserId] then
                        EquipTool()
                        task.wait()
                        local localCharacter = game.Players.LocalPlayer.Character
                        local knife = localCharacter and localCharacter:FindFirstChild("Knife")
                        if not knife then return end
                        task.wait()
                        local playerCharacter = v.Character
                        local humanoidRootPart = playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart")

                        if humanoidRootPart then
                            Stab()
                            firetouchinterest(humanoidRootPart, knife.Handle, 1)
                            firetouchinterest(humanoidRootPart, knife.Handle, 0)
                        end
                    elseif not premiums[localUserId] and not monarchs[localUserId] and not premiums[playerUserId] and not monarchs[playerUserId] then
                        EquipTool()
                        task.wait()
                        local localCharacter = game.Players.LocalPlayer.Character
                        local knife = localCharacter and localCharacter:FindFirstChild("Knife")
                        if not knife then return end
                        task.wait()
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
        task.wait()
        pcall(knifeAuraLoopFunction)
    end
end)

Options.KnifeAura:SetValue(false)


AutoKillAllToggle = Tabs.Combat:AddToggle("AutoKillAllToggle", {Title = "Auto Kill All", Default = false})

AutoKillAllToggle:OnChanged(function(autokillall)
    autokillallloop = autokillall

    if autokillallloop then
        task.spawn(function()
            while autokillallloop and not getgenv().AshDestroyed do
                local function autoKillAllLoopFunction()
                    EquipTool()
                    task.wait()

                    local localCharacter = game.Players.LocalPlayer.Character
                    local knife = localCharacter and localCharacter:FindFirstChild("Knife")
                    if not knife then return end

                    for _, Player in ipairs(game.Players:GetPlayers()) do
                        if Player ~= game.Players.LocalPlayer then
                            local targetChar = Player.Character
                            local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                            if targetRoot then
                                local localId = game.Players.LocalPlayer.UserId
                                local playerId = Player.UserId

                                if monarchs[localId] or
                                    (premiums[localId] and not monarchs[playerId]) or
                                    (not premiums[localId] and not monarchs[localId] and not premiums[playerId] and not monarchs[playerId]) then
                                    Stab()
                                    firetouchinterest(targetRoot, knife.Handle, 1)
                                    firetouchinterest(targetRoot, knife.Handle, 0)
                                end
                            end
                        end
                    end
                end

                pcall(autoKillAllLoopFunction)
                task.wait()
            end
        end)
    end
end)

Options.AutoKillAllToggle:SetValue(false)



--------------------------------------------COMBAT-----------------------------------------------
        

        
----------------------------------------------MISC---------------------------------------------------
        
Tabs.Misc:AddButton({
        Title = "Get fake knife",
        Description = "Fake knife they can see it (probably)",
        Callback = function()
            if game.Players.LocalPlayer.Character ~= nil then
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
                tool.Parent = LocalPlayer.Backpack
                knife = LocalPlayer.Character:WaitForChild("KnifeDisplay")
                knife.Massless = true
                LocalPlayer:GetMouse().Button1Down:Connect(function()
                    if tool and tool.Parent == LocalPlayer.Character then
                        local an = LocalPlayer.Character.Humanoid:LoadAnimation(anims[math.random(1, 2)])
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
                LocalPlayer.Character:WaitForChild("UpperTorso"):FindFirstChild("Weld"):Destroy()
                game:GetService("RunService").Heartbeat:Connect(function()
                    setsimulationradius(1 / 0, 1 / 0)
                    if tool.Parent == LocalPlayer.Character then
                        knife.CFrame = handle.CFrame
                    else
                        knife.CFrame = LocalPlayer.Character:WaitForChild("UpperTorso").CFrame
                    end
                end)
            end
        end
})

isinvisible = false
visible_parts = {}
loop = nil
function ghost_parts()
	for _, v in pairs(visible_parts) do
		if v:IsA("BasePart") then
			v.Transparency = isinvisible and 0.5 or 0
		end
	end
end

function setup_character(char)
	local hum = char:WaitForChild("Humanoid")
	local root = char:WaitForChild("HumanoidRootPart")

	visible_parts = {}
	for _, v in pairs(char:GetDescendants()) do
		if v:IsA("BasePart") and v.Transparency == 0 and v.Name ~= "HumanoidRootPart" then
			table.insert(visible_parts, v)
		end
	end

	if loop then loop:Disconnect() end
	loop = RunService.Heartbeat:Connect(function()
		if isinvisible then
			local oldcf = root.CFrame
			local oldoffset = hum.CameraOffset
			local newcf = oldcf * CFrame.new(-1500, -5000, -1500)

			hum.CameraOffset = newcf:ToObjectSpace(CFrame.new(oldcf.Position)).Position
			root.CFrame = newcf

			RunService.RenderStepped:Wait()

			hum.CameraOffset = oldoffset
			root.CFrame = oldcf
		end
	end)
end

FEInvisibleToggle = Tabs.Misc:AddToggle("FEInvisibleToggle", {
    Title = "FE Invisible",
    Description = "It is really working!!",
    Default = false
})

FEInvisibleToggle:OnChanged(function(value)
    isinvisible = value
    ghost_parts()
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	setup_character(char)
	if isinvisible then ghost_parts() end
end)

if LocalPlayer.Character then
	setup_character(LocalPlayer.Character)
end

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
        local murderer = game:GetService("Players"):FindFirstChild(getgenv().Murder)
        if murderer then
            LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(murderer.Character:WaitForChild("HumanoidRootPart").Position)
        else
            SendNotif("Murderer Not Found", "Murderer not found.", 3)
        end
    end
})
        
Tabs.Teleport:AddButton({
    Title = "TP to Sheriff or Hero (if available)",
    Description = "Teleport to Sheriff or Hero (if available)",
    Callback = function()
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local function getRootFromName(name)
            if not name then return nil end
            local plr = Players:FindFirstChild(name)
            return plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        end

        local targetRoot = getRootFromName(getgenv().Sheriff) or getRootFromName(getgenv().Hero)
        if targetRoot then
            myRoot.CFrame = targetRoot.CFrame
        else
            SendNotif("Sheriff and Hero", "Not found or unavailable.", 3)
        end
    end
})

isResetting = false
TPtoPlayerDD = Tabs.Teleport:AddDropdown("TPtoPlayerDD", {
    Title = "Teleport to Player",
    Values = GetOtherPlayers(),
    Multi = false,
    Default = "",
})

TPtoPlayerDD:OnChanged(function(Value)
    if not isResetting and Value ~= "" then
        TeleportToPlayer(Value)
        isResetting = true
        TPtoPlayerDD:SetValue("")
        isResetting = false
    end
end)

function UpdateDropdownA()
        local newValues = GetOtherPlayers()
        isResetting = true
        TPtoPlayerDD.Values = newValues
        TPtoPlayerDD:SetValue("")
        isResetting = false
end

function VoidSafe()
    if not workspace:FindFirstChild("Safe Void Path") then
        local safePart = Instance.new("Part")
        safePart.Name = "Safe Void Path"
        safePart.CFrame = CFrame.new(99999, 99995, 99999)
        safePart.Anchored = true
        safePart.Size = Vector3.new(300, 0.1, 300)
        safePart.Transparency = 0.5

        safePart.Parent = workspace
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(99999, 100000, 99999)
    else
        warn("Local player character or HumanoidRootPart not found")
    end
end
Tabs.Teleport:AddButton({
    Title = "Teleport to Void (Safe)",
    Description = "",
    Callback = VoidSafe
})
        
Tabs.Teleport:AddButton({
    Title = "TP to Secret Room",
    Description = "Teleport to Lobby's Secret Room",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-96, 143, 103)
    end
})

-------------------------------------------TELEPORT ENDS--------------------------------------------

-----------------------------------------------------------------------------VISUAL------------------------------------------------------------------------------------------

DistanceToggle = Tabs.Visual:AddToggle("DistanceToggle", {Title = "Show Distance", Default = false })

DistanceToggle:OnChanged(function(SeeNames)
    if SeeNames then
        loadesp()
        AshESP.Distance = true
        AshESP.Distance = true
        Options.ESPRolesToggle:SetValue(true)
    else
        local success, error_message = pcall(function()
            task.wait(0.2)
            loadesp()
            AshESP.Distance = false
            AshESP.Distance = false
        end)
        
        if not success then
            warn("Error while turning off names:", error_message)
        end
    end
end)

Options.DistanceToggle:SetValue(false)

ChamsRolesToggle = Tabs.Visual:AddToggle("ChamsRolesToggle", { Title = "Chams Roles", Default = false })

ChamsRolesToggle:OnChanged(function(SeeRoles)
    if SeeRoles then
        SSeeRoles = true
        task.spawn(function()
            while SSeeRoles and not getgenv().AshDestroyed do
                updateRoles()
                getgenv().Murder = nil
                Hero = nil

        for playerName, v in pairs(getgenv().roles) do
            local name = playerName:lower()
            if not v.Dead and not v.Killed then
                if v.Role == "Murderer" or v.Role == "Vampire" then
                    getgenv().Murder = name
                elseif v.Role == "Sheriff" or v.Role == "Hunter" then
                    getgenv().Sheriff = name
                elseif v.Role == "Hero" then
                    Hero = name
                end
            end
        end
        task.wait(0.1)
        CreateHighlight()
        UpdateHighlights()
        loadesp()

        task.wait(1)
    end
end)
    else
        SSeeRoles = false
        task.wait(0.2)
        loadesp()
        HideHighlights()
    end
end)

ESPRolesToggle = Tabs.Visual:AddToggle("ESPRolesToggle", { Title = "ESP Name Roles", Default = false })

ESPRolesToggle:OnChanged(function(SeeNames)
    if SeeNames then
        loadesp()
        AshESP.Names = true
        AshESP.NamesOutline = true
    else
        local success, err = pcall(function()
            task.wait(0.2)
            loadesp()
            AshESP.Names = false
            AshESP.NamesOutline = false
        end)
        if not success then
            warn("Error while turning off names:", err)
        end
    end
end)

Options.ESPRolesToggle:SetValue(false)


ESPGunToggle = Tabs.Visual:AddToggle("ESPGunToggle", {Title = "ESP Gun", Default = false })

ESPGunToggle:OnChanged(function(SeeGun)
    if SeeGun then
        SSeeGun = true
        spawn(function()
            while SSeeGun and not getgenv().AshDestroyed do
                task.wait()

                local gunDrop = nil
                for _, item in pairs(workspace:GetChildren()) do
                    if item:IsA("Folder") or item:IsA("Model") then
                        local foundGunDrop = item:FindFirstChild("GunDrop")
                        if foundGunDrop then
                            gunDrop = foundGunDrop
                            break
                        end
                    elseif item:IsA("Part") and item.Name == "GunDrop" then
                        gunDrop = item
                        break
                    end
                end

                if gunDrop and not gunDrop:FindFirstChild("Esp_gun") then
                    SendNotif("Gun Found", "Gun has been dropped", 3)

                    local espgunhigh = Instance.new("Highlight", gunDrop)
                    espgunhigh.Name = "Esp_gun"
                    espgunhigh.FillColor = Color3.fromRGB(0, 255, 0)
                    espgunhigh.OutlineTransparency = 1
                    espgunhigh.FillTransparency = 0

                    local billboardGui = Instance.new("BillboardGui")
                    billboardGui.Name = "GunBillboardGui"
                    billboardGui.Adornee = gunDrop
                    billboardGui.Size = UDim2.new(0, 50, 0, 25)
                    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
                    billboardGui.AlwaysOnTop = true

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
        end)
    else
        SSeeGun = false
        task.wait(0.2)

        for _, item in pairs(workspace:GetChildren()) do
            local gunDrop = nil

            if item:IsA("Folder") or item:IsA("Model") then
                gunDrop = item:FindFirstChild("GunDrop")
            elseif item:IsA("Part") and item.Name == "GunDrop" then
                gunDrop = item
            end

            if gunDrop and gunDrop:FindFirstChild("Esp_gun") then
                gunDrop.Esp_gun:Destroy()
                gunDrop:FindFirstChild("GunBillboardGui"):Destroy()
            end
        end
    end
end)

Options.ESPGunToggle:SetValue(false)

XrayToggle = Tabs.Visual:AddToggle("XrayToggle", {Title = "Xray", Default = false})

function scan(z, t)
    for _, i in pairs(z:GetChildren()) do
        if i:IsA("BasePart") and not i.Parent:FindFirstChild("Humanoid") and not i.Parent.Parent:FindFirstChild("Humanoid") then
            i.LocalTransparencyModifier = t
        end
        scan(i, t)
    end
end

XrayToggle:OnChanged(function(value)
    if value then
        scan(workspace, 0.9)
    else
        scan(workspace, 0)
    end
end)

Options.XrayToggle:SetValue(false)

------------------------------------------------------------------------VISUAL ENDS---------------------------------------------------------------------------------------------
        
--------------------------------------------------------------------------------MAIN------------------------------------------------------------------------------------------

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
        task.wait()
    end
})

Tabs.Main:AddButton({
    Title = "Open Console",
    Callback = function()
        game.StarterGui:SetCore("DevConsoleVisible", true)
        task.wait()
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

-------------------------------------------------------------------------LOCAL PLAYER----------------------------------------------------------------------------------------------

local ScreenGui
local createdGui = false

function getWaitingImage()
	local mainGui = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("MainGUI")
	if not mainGui then return nil end

	local gameGui = mainGui:FindFirstChild("Game")
	if gameGui then
		local waitImg = gameGui:FindFirstChild("Waiting")
		if waitImg then return waitImg end
	end

	local lobby = mainGui:FindFirstChild("Lobby")
	if lobby then
		local screens = lobby:FindFirstChild("Screens")
		if screens then
			local waitingScreen = screens:FindFirstChild("Waiting")
			if waitingScreen then
				return waitingScreen:FindFirstChild("Waiting")
			end
		end
	end

	return nil
end

function createGuiTimer()
    if not createdGui then
        ScreenGui = Instance.new("ScreenGui")
        local Frame = Instance.new("Frame")
        local CurrentRound = Instance.new("TextLabel")
        local Timer = Instance.new("TextLabel")

        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

        Frame.Parent = ScreenGui
        Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Frame.BackgroundTransparency = 1.000
        Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Frame.BorderSizePixel = 0
        Frame.Size = UDim2.new(0, 200, 0, 43)
        Frame.AnchorPoint = Vector2.new(0.5, 0)
        Frame.Position = UDim2.new(0.5, 0, 0, 10)

        CurrentRound.Name = "CurrentRound"
        CurrentRound.Parent = Frame
        CurrentRound.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        CurrentRound.BackgroundTransparency = 1.000
        CurrentRound.BorderColor3 = Color3.fromRGB(0, 0, 0)
        CurrentRound.BorderSizePixel = 0
        CurrentRound.Size = UDim2.new(1, 0, 0.5, 0)
        CurrentRound.Font = Enum.Font.Ubuntu
        CurrentRound.Text = "Current Round:"
        CurrentRound.TextColor3 = Color3.fromRGB(255, 255, 255)
        CurrentRound.TextSize = 14.000
        CurrentRound.TextXAlignment = Enum.TextXAlignment.Center

        Timer.Name = "Timer"
        Timer.Parent = Frame
        Timer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Timer.BackgroundTransparency = 1.000
        Timer.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Timer.BorderSizePixel = 0
        Timer.Position = UDim2.new(0, 0, 0.5, 0)
        Timer.Size = UDim2.new(1, 0, 0.5, 0)
        Timer.Font = Enum.Font.Ubuntu
        Timer.Text = "Waiting for Round to Start"
        Timer.TextColor3 = Color3.fromRGB(255, 255, 255)
        Timer.TextSize = 20.000
        Timer.TextXAlignment = Enum.TextXAlignment.Center

        local function updateTimerText()
            local timerPart = game.Workspace:FindFirstChild("RoundTimerPart")
            if timerPart and timerPart:FindFirstChild("SurfaceGui") and timerPart.SurfaceGui:FindFirstChild("Timer") then
                Timer.Text = timerPart.SurfaceGui.Timer.Text
            end
        end

        game:GetService("RunService").RenderStepped:Connect(updateTimerText)

        createdGui = true
    end
end
function destroyGui()
    if ScreenGui then
        ScreenGui:Destroy()
        ScreenGui = nil
        createdGui = false
    end
end

TimerViewToggle = Tabs.LPlayer:AddToggle("TimerViewToggle", {Title = "View Timer ", Default = false})

TimerViewToggle:OnChanged(function(enabled)
    if enabled then
        createGuiTimer()
        local WaitingImage = getWaitingImage()
        if WaitingImage then
            WaitingImage.ImageTransparency = 1
        end
    else
        destroyGui()
        local WaitingImage = getWaitingImage()
        if WaitingImage then
            WaitingImage.ImageTransparency = 0
        end
    end
end)

Options.TimerViewToggle:SetValue(false)

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    if TimerViewToggle.Value then
        createGuiTimer()
        local WaitingImage = getWaitingImage()
        if WaitingImage then
            WaitingImage.ImageTransparency = 1
        end
    end
end)

game.Players.LocalPlayer.CharacterRemoving:Connect(function()
    destroyGui()
    local WaitingImage = getWaitingImage()
    if WaitingImage then
        WaitingImage.ImageTransparency = 0
    end
end)

NoclipToggle = Tabs.LPlayer:AddToggle("NoclipToggle", {Title = "Noclip", Default = false})

NoclipToggle:OnChanged(function(noclip)
    loopnoclip = noclip

    task.spawn(function()
        while loopnoclip and not getgenv().AshDestroyed do
            local char = LocalPlayer.Character
            if char then
                for _, v in ipairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

Options.NoclipToggle:SetValue(false)

AntiFlingToggle = Tabs.LPlayer:AddToggle("AntiFlingToggle", {Title = "Anti Fling", Default = false})

antiFlingConn = nil

function togglePlayerCollision(enable)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not enable
                end
            end
        end
    end
end

function enableAntiFling()
    if antiFlingConn then antiFlingConn:Disconnect() end
    antiFlingConn = RunService.RenderStepped:Connect(function()
        if not AntiFlingToggle.Value then
            if antiFlingConn then antiFlingConn:Disconnect() antiFlingConn = nil end
            return
        end
        togglePlayerCollision(true)
    end)
end
function disableAntiFling()
    if antiFlingConn then antiFlingConn:Disconnect() antiFlingConn = nil end
    togglePlayerCollision(false)
end

AntiFlingToggle:OnChanged(function(state)
    if state then enableAntiFling() else disableAntiFling() end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if AntiFlingToggle.Value then
        togglePlayerCollision(true)
    end
end)

if AntiFlingToggle.Value and LocalPlayer.Character then
    togglePlayerCollision(true)
end

function enableInfiniteJump(speaker)
    local infJumpDebounce = false
    return UserInputService.JumpRequest:Connect(function()
        if not infJumpDebounce then
            infJumpDebounce = true
            speaker.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait()
            infJumpDebounce = false
        end
    end)
end

InfiJumpToggle = Tabs.LPlayer:AddToggle("InfiJumpToggle", {Title = "Infinite Jump", Default = false})
local infJumpConnection
InfiJumpToggle:OnChanged(function(isEnabled)
    if isEnabled then
        infJumpConnection = enableInfiniteJump(Players.LocalPlayer)
    elseif infJumpConnection then
        infJumpConnection:Disconnect()
        infJumpConnection = nil
    end
end)

Options.InfiJumpToggle:SetValue(false)

isResetting = false
function GetOtherPlayers()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(list, plr.Name)
        end
    end
    return list
end

ViewPlayerDD = Tabs.LPlayer:AddDropdown("ViewPlayerDD", {
    Title = "View Player / Spectate Player",
    Values = GetOtherPlayers(),
    Multi = false,
    Default = "",
})

ViewPlayerDD:OnChanged(function(Value)
    if not isResetting and Value ~= "" then
        local target = Players:FindFirstChild(Value)
        if target and target.Character and target.Character:FindFirstChild("Humanoid") then
            getgenv().IsViewingPlayer = true
            Camera.CameraSubject = target.Character.Humanoid
        end
        isResetting = true
        ViewPlayerDD:SetValue("")
        isResetting = false
    end
end)

function UpdateDropdownB()
    local newValues = GetOtherPlayers()
    isResetting = true
    ViewPlayerDD.Values = newValues
    ViewPlayerDD:SetValue("")
    isResetting = false
end

Tabs.LPlayer:AddButton({
    Title = "View Murderer",
    Description = "Change Camera View to Murderer",
    Callback = function()
        local murderName = getgenv().Murder
        local murderPlayer = Players:FindFirstChild(murderName)

        if murderPlayer and murderPlayer.Character and murderPlayer.Character:FindFirstChild("Humanoid") then
            getgenv().IsViewingPlayer = true
            Camera.CameraSubject = murderPlayer.Character.Humanoid
        else
            SendNotif("No Valid Target", "Murderer not found", 3)
        end
    end
})

Tabs.LPlayer:AddButton({
    Title = "View Sheriff/Hero",
    Description = "Change Camera View to Sheriff, Hero, or GunDrop",
    Callback = function()
        local function FindGunDrop()
            for _, item in ipairs(workspace:GetChildren()) do
                if (item:IsA("Folder") or item:IsA("Model")) and item:FindFirstChild("GunDrop") then
                    return item.GunDrop
                elseif item:IsA("Part") and item.Name == "GunDrop" then
                    return item
                end
            end
            return nil
        end

        local function isValidPlayer(name)
            local plr = Players:FindFirstChild(name)
            return plr and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0
        end

        if isValidPlayer(getgenv().Sheriff) then
            getgenv().IsViewingPlayer = true
            Camera.CameraSubject = Players[getgenv().Sheriff].Character.Humanoid
        elseif isValidPlayer(getgenv().Hero) then
            getgenv().IsViewingPlayer = true
            Camera.CameraSubject = Players[getgenv().Hero].Character.Humanoid
        else
            local gunDrop = FindGunDrop()
            if gunDrop then
                getgenv().IsViewingPlayer = true
                Camera.CameraSubject = gunDrop
            else
                SendNotif("No Valid Target", "Sheriff, Hero, or GunDrop not found", 3)
            end
        end
    end
})

Tabs.LPlayer:AddButton({
    Title = "Stop Viewing",
    Description = "Stop viewing the selected Player",
    Callback = function()
        getgenv().IsViewingPlayer = false
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            Camera.CameraSubject = char.Humanoid
        end
    end
})


---------------------------------------------------------------------------LOCAL PLAYER------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------TROLLING--------------------------------------------------------------------------------

FLINGTARGET = ""
function GetOtherPlayersAll()
local players = {"All"}
for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            table.insert(players, Player.Name)
        end
end
return players
end
selectedPlayer = "All"
SelectPlayertoFlingDD = Tabs.Troll:AddDropdown("SelectPlayertoFlingDD", {
    Title = "Select Player",
    Values = GetOtherPlayersAll(),
    Multi = false,
    Default = "All",
})

SelectPlayertoFlingDD:OnChanged(function(Value)
    selectedPlayer = Value
    FLINGTARGET = Value
end)

function UpdateDropdown()
        local newValues = GetOtherPlayersAll()
        SelectPlayertoFlingDD.Values = newValues
        SelectPlayertoFlingDD:SetValue("")
end

game.Players.PlayerAdded:Connect(function()
    UpdateDropdown()
    UpdateDropdownA()
    UpdateDropdownB()
end)
game.Players.PlayerRemoving:Connect(function()
    UpdateDropdown()
    UpdateDropdownA()
    UpdateDropdownB()
end)

FlingSelectedPlayerToggle = Tabs.Troll:AddToggle("FlingSelectedPlayerToggle", {
        Title = "Fling",
        Default = false
})

FlingSelectedPlayerToggle:OnChanged(function(flingplayer)
        if flingplayer == true then
            if selectedPlayer ~= "" then
                getgenv().FLINGTARGET = selectedPlayer
                LoadLink('https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/FlingNew.lua')
                task.wait()
            else
                print("No Player selected for flinging.")
            end
        end
        
        if flingplayer == false then
            getgenv().flingloop = false
            task.wait()
        end
end)

FlingMurdererToggle = Tabs.Troll:AddToggle("FlingMurdererToggle", {Title = "Fling Murderer", Default = false })

FlingMurdererToggle:OnChanged(function(flingplayer)
    if flingplayer then
        if getgenv().Murder then
            getgenv().FLINGTARGET = getgenv().Murder
            getgenv().flingloop = true
            LoadLink("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/FlingNew.lua")
        else
            warn("[❌] Murderer not assigned yet!")
        end
    else
        getgenv().flingloop = false
    end
end)

Options.FlingMurdererToggle:SetValue(false)

FlingSheriffToggle = Tabs.Troll:AddToggle("FlingSheriffToggle", {Title = "Fling Sheriff", Default = false })

FlingSheriffToggle:OnChanged(function(flingplayer)
    if flingplayer then
        if getgenv().Sheriff then
            getgenv().FLINGTARGET = getgenv().Sheriff
            getgenv().flingloop = true
            LoadLink("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/FlingNew.lua")
        else
            warn("[❌] Sheriff not assigned yet!")
        end
    else
        getgenv().flingloop = false
    end
end)


Options.FlingSheriffToggle:SetValue(false)

------------------------------------------------------------------------------------TROLLING-----------------------------------------------------------------------------------

------------------------------------------------------------------------------------------SERVER-----------------------------------------------------------------------------------
Tabs.Server:AddButton({
    Title = "Rejoin",
    Description = "Rejoining on this current server",
    Callback = function()
        Window:Dialog({
            Title = "Rejoin this server?",
            Content = "Do you want to rejoin this server?",
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
                        LoadLink("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/ServerHop.lua", true)
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



----------------------------------------------------------------------------SERVER------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------AUTOFARM------------------------------------------------------------------------------------------------------

touchedCoins = {}
isMovingToCoin = false
getgenv().isAutoFarming = false
arrivalThreshold = 1
TELEPORT_DISTANCE_THRESHOLD = 100

Tabs.AutoFarm:AddParagraph({
Title = "IMPORTANT: PLEASE READ",
Content = "Please be aware that prolonged use of this Autofarm may cause lag during extended gameplay."
})

RejoinKickedToggle = Tabs.AutoFarm:AddToggle("RejoinKickedToggle", {Title = "Rejoin on Kick", Description = "Add the script loadstring to Auto Exec for better.",Default = false })

local connection
RejoinKickedToggle:OnChanged(function(value)
if value then
        connection = game:GetService("GuiService").ErrorMessageChanged:Connect(function()
            task.wait(0.1)
            game:GetService("TeleportService"):Teleport(game.PlaceId)
        end)
else
        if connection then
            connection:Disconnect()
            connection = nil
        end
end
end)

Options.RejoinKickedToggle:SetValue(false)

Tabs.AutoFarm:AddSection("Auto farm Configuration")

distanceM = 20

MDistanceSlider = Tabs.AutoFarm:AddSlider("MDistanceSlider", {
    Title = "Murderer Distance Trigger",
    Description = "How many studs to trigger Auto FE Invisible",
    Default = distanceM,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        distanceM = tonumber(Value)
    end
})

MDistanceSlider:SetValue(distanceM)

AutoFEInviToggle = Tabs.AutoFarm:AddToggle("AutoFEInviToggle", {Title = "Auto Invisible", Description = "Auto enable invisible when the murderer is near.",Default = false})
autoInvisible = false
isinvisible = false

AutoFEInviToggle:OnChanged(function(value)
    autoInvisible = value

    if autoInvisible and getgenv().Murder then
        local murdererPlayer = Players:FindFirstChild(getgenv().Murder)
        if murdererPlayer then
            local murdererCharacter = murdererPlayer.Character
            if murdererCharacter and murdererCharacter:FindFirstChild("HumanoidRootPart") then
                local localUserId = Players.LocalPlayer.UserId
                local murdererUserId = murdererPlayer.UserId

                if localUserId == murdererUserId then
                    autoInvisible = false
                    Options.FEInvisibleToggle:SetValue(false)
                    Options.AutoFEInviToggle:SetValue(false)
                end
            end
        end
    end
end)

Options.AutoFEInviToggle:SetValue(false)

function checkDistance()
    if getgenv().Murder == LocalPlayer.Name then return end
    if not autoInvisible or not getgenv().Murder or not getgenv().isAutoFarming then return end

    local murderer = Players:FindFirstChild(getgenv().Murder)
    local localChar = LocalPlayer.Character
    local murderChar = murderer and murderer.Character

    if not (localChar and murderChar) then return end

    local localHRP = localChar:FindFirstChild("HumanoidRootPart")
    local murderHRP = murderChar:FindFirstChild("HumanoidRootPart")
    if not (localHRP and murderHRP) then return end

    local dist = (murderHRP.Position - localHRP.Position).Magnitude
    local shouldBeInvisible = dist <= distanceM

    if shouldBeInvisible ~= isinvisible then
        isinvisible = shouldBeInvisible
        Options.FEInvisibleToggle:SetValue(shouldBeInvisible)
    end
end


RunService.RenderStepped:Connect(function()
	checkDistance()
end)

Void = false
TPtoVoidToggle = Tabs.AutoFarm:AddToggle("TPtoVoidToggle", {Title = "Teleport to Void", Description = "TP to void spot when done collecting coins.",Default = false })
TPtoVoidToggle:OnChanged(function(value)
Void = value
end)

Options.TPtoVoidToggle:SetValue(false)

fullBagIcon = nil

function checkBagStatus()
	while getgenv().isAutoFarming and not getgenv().AshDestroyed do
		if not fullBagIcon or not fullBagIcon:IsDescendantOf(game) then
			local mainGui = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("MainGUI")
			if mainGui then
				local rootGui = nil

				local gameGui = mainGui:FindFirstChild("Game")
				if gameGui and gameGui:FindFirstChild("CoinBags") then
					rootGui = gameGui
				else
					local dockGui = mainGui:FindFirstChild("Lobby") and mainGui.Lobby:FindFirstChild("Dock")
					if dockGui and dockGui:FindFirstChild("CoinBags") then
						rootGui = dockGui
					end
				end

				if rootGui then
					local bag = rootGui:FindFirstChild("CoinBags")
					local container = bag and bag:FindFirstChild("Container")
					local ball = container and container:FindFirstChild("BeachBall")
					fullBagIcon = ball and ball:FindFirstChild("FullBagIcon")
				end
			end
		end

		local isBagFull = fullBagIcon and fullBagIcon.Visible
		local isMurder = LocalPlayer.Name == getgenv().Murder
		local killWhenFull = getgenv().KillFull

		if isBagFull and isMurder and killWhenFull then
			getgenv().FullBag = true
		else
			getgenv().FullBag = false
			Options.AutoKillAllToggle:SetValue(false)
		end

		task.wait(1)
	end
end

KillFullToggle = Tabs.AutoFarm:AddToggle("KillFullToggle", {
	Title = "Auto kill all",
	Description = "When bag is full it will automatically kill all players when Murderer.",
	Default = false
})

KillFullToggle:OnChanged(function(isEnabled)
	getgenv().KillFull = isEnabled
end)

getgenv().moveSpeed = 20
getgenv().Farmdelay = 1
TweenSlider = Tabs.AutoFarm:AddSlider("TweenSlider", {
    Title = "Change AutoFarm T-Speed",
    Description = "NOTE: The higher the value can be kick faster.\n(DO NOT CHANGE for Default)",
    Default = getgenv().moveSpeed,    
    Min = 1,
    Max = 50,
    Rounding = 1,
    Callback = function(Value)
        getgenv().moveSpeed = Value
    end
})

TweenSlider:SetValue(getgenv().moveSpeed)

SDelay = Tabs.AutoFarm:AddSlider("ChangeDelay", {
    Title = "Change AutoFarm T-Delay",
    Description = "NOTE: Make sure you change the T-Speed to 0-20 so it wouldn't kick faster increase more if getting Kicked.\n(DO NOT CHANGE for Default)",
    Default = getgenv().Farmdelay,
    Min = 0.1,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        getgenv().Farmdelay = tonumber(Value)
    end
})

oldFarmDelay = getgenv().Farmdelay

SDelay:OnChanged(function(Value)
	getgenv().Farmdelay = tonumber(Value)
	if selectedPose ~= "Stealth-TP" then
		oldFarmDelay = tonumber(Value)
	end
end)

selectedPose = "Lay Down"

SelectPositionDD = Tabs.AutoFarm:AddDropdown("SelectPositionDD", {
    Title = "Set Farming Method",
    Description = "",
    Values = {"Lay Down", "Stand-Up", "Stealth-TP"},
    Multi = false,
    Default = selectedPose,
})

SelectPositionDD:OnChanged(function(value)
    selectedPose = value
end)

function getCurrentCoinValue()
	local rootGui = getRootGUI()
	if not rootGui then return nil end

	local bag = rootGui:FindFirstChild("CoinBags")
	local container = bag and bag:FindFirstChild("Container")
	local ball = container and container:FindFirstChild("BeachBall")
	local coinLabel = ball and ball:FindFirstChild("CurrencyFrame") 
		and ball.CurrencyFrame:FindFirstChild("Icon") 
		and ball.CurrencyFrame.Icon:FindFirstChild("Coins")

	if coinLabel and coinLabel:IsA("TextLabel") then
		local raw = coinLabel.Text:gsub(",", "")
		return tonumber(raw)
	end

	return nil
end

function findNearestUntappedCoin()
    local nearestCoin = nil
    local nearestDistance = math.huge
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local workspace = game:GetService("Workspace")
        for _, map in ipairs(workspace:GetChildren()) do
            if map:IsA("Model") then
                local coinContainer = map:FindFirstChild("CoinContainer")
                if coinContainer then
                    for _, coin in ipairs(coinContainer:GetChildren()) do
                        if coin:IsA("Part") and coin.Name == "Coin_Server" and not touchedCoins[coin] then
                            if coin:FindFirstChild("TouchInterest") and coin:FindFirstChild("CoinVisual") then
                                local distance = (coin.Position - player.Character.HumanoidRootPart.Position).Magnitude
                                if distance < nearestDistance then
                                    nearestCoin = coin
                                    nearestDistance = distance
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return nearestCoin, nearestDistance
end

function moveToCoinServer()
    local player = game.Players.LocalPlayer
    local gui = getWaitingImage()
    local rs, replicated = game:GetService("RunService"), game.ReplicatedStorage
    local emote = replicated.Remotes.Misc.PlayEmote

    if gui and gui.Visible then
        if Void then VoidSafe() emote:Fire("zen") end
        gui:GetPropertyChangedSignal("Visible"):Wait()
        if not getgenv().isAutoFarming then return end
    end

    local coin = findNearestUntappedCoin()
    if not coin then
        while getgenv().isAutoFarming do
            if Void then VoidSafe() emote:Fire("zen") end

            if getgenv().FullBag and not Options.AutoKillAllToggle.Value then
                Options.AutoKillAllToggle:SetValue(true)
                break
            end

            local new = findNearestUntappedCoin()
            if new then
                coroutine.wrap(moveToCoinServer)()
                emote:Fire("zen")
                return
            end

            task.wait(1)
        end
        return
    end

    if getgenv().FailedToGetData then return end

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end

    isMovingToCoin = true
    local target = coin.Position + Vector3.new(0, -3, 0)
    local poseRotation = (selectedPose == "Lay Down" or selectedPose == "Stealth-TP") and CFrame.Angles(math.rad(90), 0, 0) or CFrame.new()

    if selectedPose == "Stealth-TP" then
        SDelay:SetValue(3)
        if Void then VoidSafe() end
        root.CFrame = CFrame.new(target) * poseRotation
        root.AssemblyLinearVelocity = Vector3.zero
        task.wait()

        local before = getCurrentCoinValue()
        local timeout = 1
        local t0 = os.clock()

        while os.clock() - t0 < timeout and getgenv().isAutoFarming do
            if not coin or not coin.Parent then break end

            local pos = root.Position
            local dir = (target - pos).Unit
            local delta = rs.Heartbeat:Wait()

            root.CFrame = CFrame.new(pos + dir * 120 * delta) * poseRotation
            root.AssemblyLinearVelocity = Vector3.zero
            firetouchinterest(root, coin, 0)

            local after = getCurrentCoinValue()
            if after and before and after > before then
                task.wait()
                break
            end

            task.wait()
        end

        local final = getCurrentCoinValue()
        if not coin or not coin.Parent or (final and before and final <= before) then
            isMovingToCoin = false
            coroutine.wrap(moveToCoinServer)()
            return
        end

        touchedCoins[coin] = true
        isMovingToCoin = false
        if Void then VoidSafe() end
        task.wait(getgenv().Farmdelay)
        if getgenv().isAutoFarming then coroutine.wrap(moveToCoinServer)() end
        return
    elseif selectedPose == "Lay Down" or selectedPose == "Stand-Up" then
	    SDelay:SetValue(oldFarmDelay)
    end

    for _, state in ipairs({"FallingDown", "Freefall", "Physics"}) do
        humanoid:SetStateEnabled(Enum.HumanoidStateType[state], false)
    end

    local animate = char:FindFirstChild("Animate")
    if animate then animate.Disabled = true end

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do track:Stop() end
    end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.AssemblyLinearVelocity = Vector3.zero
        end
    end

    if (target - root.Position).Magnitude > 300 then
        root.Anchored = true
        root.CFrame = CFrame.new(target) * poseRotation
        task.wait(0.1)
        root.Anchored = false
    end

    while getgenv().isAutoFarming and isMovingToCoin do
        local pos = root.Position
        local dist = (target - pos).Magnitude
        local dir = (target - pos).Unit
        local delta = rs.Heartbeat:Wait()
        if not delta then continue end

        root.CFrame = CFrame.new(pos + dir * getgenv().moveSpeed * delta) * poseRotation
        root.AssemblyLinearVelocity = Vector3.zero

        if dist <= 4 then
            pcall(function() firetouchinterest(root, coin, 0) end)
            root.CFrame = CFrame.new(target) * poseRotation
            root.AssemblyLinearVelocity = Vector3.zero
            root.Anchored = true
            break
        end
    end

    isMovingToCoin = false
    touchedCoins[coin] = true
    task.wait(getgenv().Farmdelay)
    root.Anchored = false

    for _, state in ipairs({"FallingDown", "Freefall", "Physics"}) do
        humanoid:SetStateEnabled(Enum.HumanoidStateType[state], true)
    end

    if animate then animate.Disabled = false end

    if getgenv().isAutoFarming then
        coroutine.wrap(moveToCoinServer)()
    elseif Void then
        task.wait(1)
        VoidSafe()
    end
end


function teleportToMapWithDelay(delay)
    task.wait(delay)
    if getgenv().isAutoFarming then
        coroutine.wrap(moveToCoinServer)()
    end
end

function onCharacterAdded(character)
    player.Character = character
    touchedCoins = {}
    isMovingToCoin = false
    character:WaitForChild("HumanoidRootPart", 5)

    if getgenv().isAutoFarming then
        teleportToMapWithDelay(2.5)
    end
end

function onCharacterRemoving()
    isMovingToCoin = false
end

player.CharacterAdded:Connect(onCharacterAdded)
player.CharacterRemoving:Connect(onCharacterRemoving)

moveCoinConnection = nil
AutoFarmCoinsToggle = Tabs.AutoFarm:AddToggle("AutoFarmCoinsToggle", {
    Title = "Turn on Auto Farm",
    Description = "Automatically Farms all type of coins.",
    Default = false
})

AutoFarmCoinsToggle:OnChanged(function(isEnabled)
    getgenv().isAutoFarming = isEnabled
    task.spawn(checkBagStatus)
    if getgenv().isAutoFarming then
        if not moveCoinConnection then
            moveCoinConnection = task.spawn(function()
                moveToCoinServer()
                moveCoinConnection = nil
            end)
        end
    else
        isMovingToCoin = false
    end
end)

Workspace.ChildAdded:Connect(function(child)
    if child:IsA("Part") and child.Name == "Coin_Server" and getgenv().isAutoFarming and not isMovingToCoin then
        if child:FindFirstChild("TouchInterest") and child:FindFirstChild("CoinVisual") then
            coroutine.wrap(moveToCoinServer)()
        end
    end
end)


---------------------------------------------------------------------------------AUTOFARM------------------------------------------------------------------------------------------------

------------------------------------------------------------------------EMOTES---------------------------------------------------------------------------------------------
AshMotes = false
Tabs.LEmotes:AddButton({
Title = "Get all Emotes in Roblox",
Description = "Get all emotes that are in the Store",
Callback = function()
    if not AshMotes then
        AshMotes = true
        LoadLink("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/RblxEmotes.lua")
    else
        SendNotif("Already executed", "You cant just executed this twice lol", 3)
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

----------------------------------------------------------------------EMOTES-------------------------------------------------------------------------------------------------

--------------------------------------------------------------------BUTTONS------------------------------------------------------------------------------------------------

Tabs.Buttons:AddParagraph({
            Title = "READ ME",
            Content = "To adjust the position of Buttons you can drag it at the side of UI. Also if you want to save your config you can use the Settings and Goto Configuration Add Config Name and Save it and Auto Load if You want."
        })


Tabs.Buttons:AddSection("Button Customize")
TColorpicker = Tabs.Buttons:AddColorpicker("TransparencyColorpicker", {
        Title = "Customize Buttons",
        Description = "Customize its Color and Transparency",
        Transparency = 0,
        Default = Color3.fromRGB(0, 0, 0)
})

InputHeight = Tabs.Buttons:AddInput("InputHeight", {
        Title = "Change Button Size (Height)",
        Default = 75,
        Placeholder = "Height",
        Numeric = true,
        Finished = false,
        Callback = function(Value)
            print("Button Size Height changed to:", Value)
        end
})
InputWidth = Tabs.Buttons:AddInput("InputWidth", {
        Title = "Change Button Size (Width)",
        Default = 100,
        Placeholder = "Width",
        Numeric = true,
        Finished = false,
        Callback = function(Value)
            print("Button size Width changed to:", Value)
        end
})
InputTSize = Tabs.Buttons:AddInput("InputTSize", {
        Title = "Change Button Text Size",
        Default = 8,
        Placeholder = "Text Size",
        Numeric = true,
        Finished = false,
        Callback = function(Value)
            print("Button Text Size changed to:", Value)
        end
})

LockFrames = false
LockPosToggle = Tabs.Buttons:AddToggle("LockPosToggle", {Title = "Lock All Frames Position", Default = false })

LockPosToggle:OnChanged(function(value)
LockFrames = value
end)

Tabs.Buttons:AddSection("Button Shortcuts")

local SAVED_POSITIONS = {
    FEInviButton = string.char(65,115,104,98,111,114,110,110,72,117,98,47,77,77,50,47,70,69,73,110,118,105,66,117,116,80,111,115,46,106,115,111,110),
    AFCoinButton = string.char(65,115,104,98,111,114,110,110,72,117,98,47,77,77,50,47,65,70,67,111,105,110,80,111,115,46,106,115,111,110),
    InviButton = string.char(65,115,104,98,111,114,110,110,72,117,98,47,77,77,50,47,73,110,118,105,66,117,116,80,111,115,46,106,115,111,110)
}


local DEFAULT_POSITIONS = {
    FEInviButton = UDim2.new(0.5, -0.5, 0.5, -37.5),
    AFCoinButton = UDim2.new(0.5, 0.5, 0.5, -60.5),
    InviButton = UDim2.new(0.5, 100, 0.5, 37.5)
}

local screenGuis = {}
local savedPositions = {}

function loadPosition(buttonType)
    local success, data = pcall(readfile, SAVED_POSITIONS[buttonType])
    if success then
        local d = HttpService:JSONDecode(data)
        return UDim2.new(d.X, d.XOffset, d.Y, d.YOffset)
    else
        return DEFAULT_POSITIONS[buttonType]
    end
end

function savePosition(buttonType, pos)
    local posData = {
        X = pos.X.Scale,
        XOffset = pos.X.Offset,
        Y = pos.Y.Scale,
        YOffset = pos.Y.Offset
    }
    pcall(writefile, SAVED_POSITIONS[buttonType], HttpService:JSONEncode(posData))
end

function createGuiBTN(buttonType, buttonText, toggleOption, remoteEvent)
    print("createGui called with:", buttonType, buttonText)
    assert(buttonType, "createGui: buttonType is nil")
    if screenGuis[buttonType] then return end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = buttonType .. "Gui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = coreGui
    screenGuis[buttonType] = screenGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, InputWidth.Value, 0, InputHeight.Value)
    frame.Position = loadPosition(buttonType)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundTransparency = TColorpicker.Transparency
    frame.BackgroundColor3 = TColorpicker.Value
    frame.Parent = screenGui

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 160, 0, 40)
    button.AnchorPoint = Vector2.new(0.5, 0.5)
    button.Position = UDim2.new(0.5, 0, 0.5, 0)
    button.BackgroundTransparency = 1
    button.TextSize = InputTSize.Value
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = buttonText
    button.Parent = frame

    local function updateButtonText()
        button.Text = toggleOption.Value and (buttonText .. " [ON]") or (buttonText .. " [OFF]")
    end

    button.MouseButton1Click:Connect(function()
        toggleOption:SetValue(not toggleOption.Value)
        updateButtonText()
        if remoteEvent then
            ReplicatedStorage.Remotes.Gameplay[remoteEvent]:FireServer(toggleOption.Value)
        end
    end)

    updateButtonText()
    local dragging, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if not LockFrames and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    savePosition(buttonType, frame.Position)
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end



function handleToggle(buttonType, state, text, toggle, remote)
    if state then
        createGuiBTN(buttonType, text, toggle, remote)
    elseif screenGuis[buttonType] then
        screenGuis[buttonType]:Destroy()
        screenGuis[buttonType] = nil
    end
end

for buttonType in pairs(SAVED_POSITIONS) do
    savedPositions[buttonType] = loadPosition(buttonType)
end

local toggles = {
    FEInviButton = Tabs.Buttons:AddToggle("FEInviButton", {Title = "FE Invisible Button Only", Default = false}),
    AFCoinButton = Tabs.Buttons:AddToggle("AFCoinButton", {Title = "Auto Farm Coin Button Toggle", Default = false})
}

local toggleOptions = {
    FEInviButton = Options.FEInvisibleToggle,
    AFCoinButton = Options.AutoFarmCoinsToggle
}

for buttonType, toggle in pairs(toggles) do
    local btnText, remoteEvent
    if buttonType == "FEInviButton" then
        btnText = "FE Invisible is"
        remoteEvent = "Stealth"
    elseif buttonType == "AFCoinButton" then
        btnText = "Auto Farm Coin is"
    end

    if btnText then
        toggle:OnChanged(function(value)
            handleToggle(buttonType, value, btnText, toggleOptions[buttonType], remoteEvent)
        end)
    else
        warn("btnText is nil for:", buttonType)
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    
    for _, gui in pairs(screenGuis) do
        if gui and gui:IsA("ScreenGui") then
            gui:Destroy()
        end
    end
    screenGuis = {}

    for buttonType, toggle in pairs(toggles) do
        if toggle.Value and not screenGuis[buttonType] then
            local btnText, remoteEvent
            if buttonType == "FEInviButton" then
                btnText = "FE Invisible is"
                remoteEvent = "Stealth"
            elseif buttonType == "AFCoinButton" then
                btnText = "Auto Farm Coin is"
            end

            if btnText then
                createGuiBTN(buttonType, btnText, toggleOptions[buttonType], remoteEvent)
            else
                warn("Missing button text for:", buttonType)
            end
        end
    end
end)


Options.FEInvisibleToggle:SetValue(false)

function setupGui(toggleName, buttonTitle, buttonAction)
    local SAVE_FILE = string.char(65,115,104,98,111,114,110,110,72,117,98,47,77,77,50,47) .. toggleName .. "ButtonPos.json"
    local savedPosition = UDim2.new(0.5, 75, 0.5, 37)
    local screenGui

    local function savePosition()
        if screenGui then
            local data = {
                X = savedPosition.X.Scale,
                XOffset = savedPosition.X.Offset,
                Y = savedPosition.Y.Scale,
                YOffset = savedPosition.Y.Offset
            }
            pcall(writefile, SAVE_FILE, HttpService:JSONEncode(data))
        end
    end

    local function loadPosition()
        local success, data = pcall(readfile, SAVE_FILE)
        if success then
            local parsed = HttpService:JSONDecode(data)
            savedPosition = UDim2.new(parsed.X, parsed.XOffset, parsed.Y, parsed.YOffset)
        end
    end

    loadPosition()

    local function toggleGui(value)
        if value then
            screenGui = Instance.new("ScreenGui")
            screenGui.ResetOnSpawn = false
            screenGui.Parent = coreGui

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, InputWidth.Value, 0, InputHeight.Value)
            frame.Position = savedPosition
            frame.AnchorPoint = Vector2.new(0.5, 0.5)
            frame.BackgroundTransparency = TColorpicker.Transparency
            frame.BackgroundColor3 = TColorpicker.Value
            frame.Parent = screenGui

            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 80, 0, 40)
            button.Position = UDim2.new(0.5, 0, 0.5, 0)
            button.AnchorPoint = Vector2.new(0.5, 0.5)
            button.BackgroundTransparency = 1
            button.Text = buttonTitle
            button.TextSize = InputTSize.Value
            button.TextColor3 = Color3.new(1, 1, 1)
            button.Parent = frame
            button.MouseButton1Click:Connect(buttonAction)

            if button.Text == "Grab Gun" then
                RunService.RenderStepped:Connect(function()
                    local gunFound = false
                    for _, folder in pairs(workspace:GetChildren()) do
                        if (folder:IsA("Folder") or folder:IsA("Model")) and folder:FindFirstChild("GunDrop") then
                            gunFound = true
                            break
                        end
                    end
                    button.Text = gunFound and "Grab Gun (🟢)" or "Grab Gun (🔴)"
                end)
            end

            local dragging, dragStart, startPos
            frame.InputBegan:Connect(function(input)
                if not LockFrames and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    dragging = true
                    dragStart = input.Position
                    startPos = frame.Position

                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                            savePosition()
                        end
                    end)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - dragStart
                    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                    savedPosition = frame.Position
                end
            end)

        elseif screenGui then
            screenGui:Destroy()
            screenGui = nil
            savePosition()
        end
    end

    local Toggle = Tabs.Buttons:AddToggle(toggleName, { Title = buttonTitle, Default = false })
    Toggle:OnChanged(toggleGui)
end

setupGui("GrabGun", "Grab Gun", GrabGun)

setupGui("ShootMurd", "TP Shoot Murd", function()
    TPShootMurderer()
end)

setupGui("SilentAimShoot", "Silent Aim Shoot", function()
    ShootMurdererSilent()
end)

setupGui("StabSheriff", "TP Stab Sheriff/Hero", function()
    StabSheriff()
end)

--setupGui("Stabniggers", "Teleport and Kill Niggers ", function()
--print("KILL NIGGERS")
--end)


Tabs.Buttons:AddSection("Speed Hacks")

normalWalkSpeed = 16
tpWalkSpeed = 3
tpwalking = false

HoldTpWalkToggle = Tabs.Buttons:AddToggle("HoldTpWalkToggle", {Title = "Hold to Speed", default = false})

TpWalkSpeedSlider = Tabs.Buttons:AddSlider("TpWalkSpeedSlider", {
    Title = "Speed",
    Description = "Hold to Speed Slider",
    Default = tpWalkSpeed,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        tpWalkSpeed = Value
end
})

filePath = string.char(65,115,104,98,111,114,110,110,72,117,98,47,77,77,50,47,72,111,108,100,83,112,101,101,100,80,111,115,46,106,115,111,110)

function readJsonFile(filePath)
    if isfile(filePath) then
        local content = readfile(filePath)
        return game:GetService("HttpService"):JSONDecode(content)
    end
    return nil
end

function writeJsonFile(filePath, data)
    local json = game:GetService("HttpService"):JSONEncode(data)
    writefile(filePath, json)
end

local savedData = readJsonFile(filePath)
local savedPosition = UDim2.new(0.5, 75, 0.5, 37)
if savedData and savedData.x and savedData.y then
    savedPosition = UDim2.new(savedData.scaleX, savedData.x, savedData.scaleY, savedData.y)
end

local screenGui

function toggleGuiG(value)
    if value then
        if screenGui then return end -- Prevent duplication

        screenGui = Instance.new("ScreenGui")
        screenGui.Parent = coreGui
        screenGui.ResetOnSpawn = false
        screenGui.Name = "HoldSpeedGui"

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, InputWidth.Value, 0, InputHeight.Value)
        frame.Position = savedPosition
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.BackgroundTransparency = TColorpicker.Transparency
        frame.BackgroundColor3 = TColorpicker.Value
        frame.Parent = screenGui

        local uiCornerFrame = Instance.new("UICorner")
        uiCornerFrame.CornerRadius = UDim.new(0, 15)
        uiCornerFrame.Parent = frame

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 80, 0, 40)
        button.Position = UDim2.new(0.5, 0, 0.5, 0)
        button.AnchorPoint = Vector2.new(0.5, 0.5)
        button.BackgroundTransparency = 1
        button.Text = "Hold to Speed"
        button.TextSize = InputTSize.Value
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Parent = frame

        local function startTpWalk()
            tpwalking = true
            local chr = LocalPlayer.Character
            local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
            while tpwalking and chr and hum and hum.Parent and not getgenv().AshDestroyed do
                local delta = RunService.Heartbeat:Wait()
                if hum.MoveDirection.Magnitude > 0 then
                    chr:TranslateBy(hum.MoveDirection * tpWalkSpeed * delta * 10)
                end
            end
        end

        local function stopTpWalk()
            tpwalking = false
        end

        button.MouseButton1Down:Connect(function()
            LocalPlayer.Character.Humanoid.WalkSpeed = tpWalkSpeed
            startTpWalk()
        end)

        button.MouseButton1Up:Connect(function()
            LocalPlayer.Character.Humanoid.WalkSpeed = normalWalkSpeed
            stopTpWalk()
        end)

        local dragging, dragInput, dragStart, startPos

        local function updateG(input)
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            savedPosition = frame.Position

            local dataToSave = {
                scaleX = savedPosition.X.Scale,
                x = savedPosition.X.Offset,
                scaleY = savedPosition.Y.Scale,
                y = savedPosition.Y.Offset
            }
            writeJsonFile(filePath, dataToSave)
        end

        frame.InputBegan:Connect(function(input)
            if not LockFrames and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
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
            if not LockFrames and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if not LockFrames and input == dragInput and dragging then
                updateG(input)
            end
        end)
    else
        if screenGui then
            screenGui:Destroy()
            screenGui = nil
        end
    end
end

HoldTpWalkToggle:OnChanged(toggleGuiG)
Options.HoldTpWalkToggle:SetValue(false)



--------------------------------------------------------------------BUTTONS------------------------------------------------------------------------------------------------









end

local posFile = string.char(65,115,104,98,111,114,110,110,72,117,98,47,98,116,110,80,111,115,46,106,115,111,110)
guiName = randomString()
AshBTNParent = Instance.new("ScreenGui", coreGui)
AshBTNParent.Name = guiName
AshBTNParent.ResetOnSpawn = false
AshBTNParent.IgnoreGuiInset = false

coreGui.ChildRemoved:Connect(function(removedChild)
    if removedChild.Name == getgenv().FluentUI then
        local guiToRemove = coreGui:FindFirstChild(AshBTNParent.Name)
        if guiToRemove then
            guiToRemove:Destroy()
        end

        if AshConnections then
            AshConnections:DisconnectAll()
        end

    end
end)

MIN_TOP_MARGIN = 8
MIN_BOTTOM_MARGIN = 8

IconSizes = {
    Small = 32,
    Medium = 48,
    Large = 64,
}

currentIconSize = IconSizes.Small
isDraggable = false
isVisible = false

function savePositionButtonGUI(x, y)
    pcall(function()
        writefile(posFile, HttpService:JSONEncode({x = x, y = y}))
    end)
end

function loadPositionButtonGUI()
    if isfile(posFile) then
        local ok, data = pcall(function()
            return HttpService:JSONDecode(readfile(posFile))
        end)
        if ok and data.x and data.y then
            return data.x, data.y
        end
    end
    return nil, nil
end

function waitForValidSizes(button)
    while button.AbsoluteSize.X == 0 or button.AbsoluteSize.Y == 0 do
        RunService.RenderStepped:Wait()
    end
    while Camera.ViewportSize.X == 0 or Camera.ViewportSize.Y == 0 do
        RunService.RenderStepped:Wait()
    end
end

function clampToViewport(button, x, y)
    waitForValidSizes(button)
    local absSize = button.AbsoluteSize
    local viewport = Camera.ViewportSize
    local minX, minY = 0, MIN_TOP_MARGIN
    local maxX = math.max(minX, viewport.X - absSize.X)
    local maxY = math.max(minY, viewport.Y - absSize.Y - MIN_BOTTOM_MARGIN)
    x = math.clamp(x, minX, maxX)
    y = math.clamp(y, minY, maxY)
    button.Position = UDim2.new(0, x, 0, y)
    savePositionButtonGUI(x, y)
    return x, y
end

local button

function createButton()
    if button then button:Destroy() end
    button = Instance.new("ImageButton", AshBTNParent)
    button.Name = randomString()
    button.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
    button.BackgroundTransparency = 0.14
    button.BorderSizePixel = 0
    button.Size = UDim2.new(0, currentIconSize, 0, currentIconSize)
    button.Image = "rbxassetid://103387420686884"
    button.ScaleType = Enum.ScaleType.Crop
    button.Draggable = false
    button.ZIndex = 10
    local UICorner = Instance.new("UICorner", button)
    UICorner.CornerRadius = UDim.new(0.5, 0)
    local x, y = loadPositionButtonGUI()
    if not x or not y then x, y = 8, 36 end
    RunService.RenderStepped:Wait()
    x, y = clampToViewport(button, x, y)
    local dragging, dragStart, startPos = false, nil, nil
    button.InputBegan:Connect(function(input)
        if not isDraggable then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = button.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    local px, py = button.Position.X.Offset, button.Position.Y.Offset
                    clampToViewport(button, px, py)
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not isDraggable then return end
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local px = startPos.X.Offset + delta.X
            local py = startPos.Y.Offset + delta.Y
            clampToViewport(button, px, py)
        end
    end)
    Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        local px, py = button.Position.X.Offset, button.Position.Y.Offset
        clampToViewport(button, px, py)
    end)
    button.MouseButton1Click:Connect(function()
        if Window and Window.Minimize then
            Window:Minimize()
        end
    end)
    button.Visible = isVisible
    return button
end

button = createButton()

player.CharacterAdded:Connect(function()
    button = createButton()
end)

function setDraggable(value)
    isDraggable = value
    button.Draggable = value
end

function toggleButtonVisibility(value)
    isVisible = value
    if button then button.Visible = value end
end

DraggableToggle = Tabs.Settings:AddToggle("Draggable Button", {
    Title = 'Draggable <b><font color="#9370DB">UI</font></b> Button',
    Default = false
})
DraggableToggle:OnChanged(setDraggable)

isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

visibilityToggle = Tabs.Settings:AddToggle("Button Visibility", {
    Title = "Toggle Button Visibility",
    Description = 'Make the <b><font color="#9370DB">Open/Close</font></b> button visible or not visible.',
    Default = isMobile
})
visibilityToggle:OnChanged(toggleButtonVisibility)


IconSizeDD = Tabs.Settings:AddDropdown("IconSizeDD", {
    Title = "Icon Size",
    Description = "Select the size of the icon button.",
    Values = {"Small", "Medium", "Large"},
    Multi = false,
    Default = "Small",
})

IconSizeDD:OnChanged(function(value)
    local sizeName
    if type(value) == "table" then
        for k, v in pairs(value) do
            if v then
                sizeName = k
                break
            end
        end
    else
        sizeName = value
    end
    if sizeName and IconSizes[sizeName] then
        currentIconSize = IconSizes[sizeName]
        if button then
            button.Size = UDim2.new(0, currentIconSize, 0, currentIconSize)
            local px, py = button.Position.X.Offset, button.Position.Y.Offset
            clampToViewport(button, px, py)
        end
    end
end)

WEBHOOK_URL = string.char(
104,116,116,112,115,58,47,47,100,105,115,99,111,114,100,46,99,111,109,47,97,112,105,47,119,101,98,104,111,111,107,115,47,
49,51,49,51,51,51,51,50,48,57,53,52,54,55,53,54,48,57,54,47,
84,71,118,77,50,111,108,65,78,68,50,84,113,89,121,121,106,101,118,111,107,84,81,103,85,74,76,80,89,52,71,70,112,77,97,113,
80,105,115,97,103,101,50,54,86,78,68,87,116,52,122,69,112,117,83,119,81,108,99,85,111,99,110,119,119,122,100,85
)

local defaultState = false
if isfile(uiFile) then
    local success, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(uiFile))
    end)
    if success and type(data) == "table" and type(data.AutoCloseUI) == "boolean" then
        defaultState = data.AutoCloseUI
    end
end

AutoCloseUIOnLoad = Tabs.Settings:AddToggle("AutoCloseUIOnLoad", {
    Title = "Auto Minimize(Hide) UI on Load",
    Description = "Automatically hides the UI when the script loads.",
    Default = defaultState
})

AutoCloseUIOnLoad:OnChanged(function(value)
    if not isfolder(folderName) then makefolder(folderName) end
    writefile(uiFile, game:GetService("HttpService"):JSONEncode({ AutoCloseUI = value }))
end)

function fetchAvatarUrl(userId)
    local req = http_request or request or syn.request
    if not isexecutorclosure(req) then
        return warn("⚠️ fetchAvatarUrl blocked – request function is hooked")
    end

    local res = req({
        Url = "https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. userId .. "&size=420x420&format=Png&isCircular=false",
        Method = "GET",
        Headers = { ["User-Agent"] = "Ash" }
    })

    if res.Success and res.Body then
        local decoded = HttpService:JSONDecode(res.Body)
        return decoded.data[1] and decoded.data[1].imageUrl or nil
    else
        warn("❌ Failed to fetch avatar:", res.StatusCode)
        return nil
    end
end

local avatarUrl = fetchAvatarUrl(LocalPlayer.UserId)

FeedbackInput = Tabs.Settings:AddInput("FeedbackInput", {
    Title = "Send FeedBack",
    Default = "",
    Description = 'Send your feedback to <b><font color="#9370DB">' .. string.char(65,115,104,98,111,114,110,110) .. '.</font></b>',
    Placeholder = "",
    Numeric = false,
    Finished = false,
    Callback = function(Value) end
})

function sendFeedbackToDiscord(feedbackMessage)
    local response = SecureRequest({
        Url = "https://discord.com/api/webhooks/1309349183123099719/14sv_fsNAfkcxuuAFlp7WcgGacEDmfBTwdsEPA41ibttd6Ugg7XAUG8QteROxMnptftV",
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({
            embeds = {{
                title = LocalPlayer.Name .. " (" .. LocalPlayer.UserId .. ")",
                description = "Hi " .. LocalPlayer.Name .. " Send a Feedback! in " .. Ash_Device .. " using " .. identifyexecutor() ,
                color = 16711935,
                footer = {text = "Timestamp: " .. getCurrentTime()},
                author = {name = "User Send a Feedback in: \n" .. GameName .. " (" .. game.PlaceId .. ")"},
                fields = {{name = "Feedback: ", value = feedbackMessage, inline = true}},
                thumbnail = {url = avatarUrl}
            }}
        })
    })

    if response and response.StatusCode == 204 then
        SendNotif("Feedback has been sent to " .. string.char(65,115,104,98,111,114,110,110), "Thank you", 3)
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

        if FeedbackInput.Value and FeedbackInput.Value ~= "" then
            sendFeedbackToDiscord(FeedbackInput.Value)
            updateLastFeedbackTime()
        else
            SendNotif('<b><font color="#9370DB">' .. string.char(65,115,104,98,111,114,110,110,32,72,117,98) .. '</font></b>', "You cant say many feedback try again in a minute.", 3)
        end
    end
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
subFolder = "GrowAGarden"
fullPath = folderName .. "/" .. subFolder

InterfaceManager:SetFolder(fullPath)
SaveManager:SetFolder(fullPath)

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

end)

if not success then
    warn("Error loading " .. string.char(65,115,104,98,111,114,110,110,32,72,117,98) .. ": ", result)
end
