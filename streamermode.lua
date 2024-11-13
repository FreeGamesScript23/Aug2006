--// services
local players = game:GetService("Players")
local core = game:GetService("CoreGui")
local vim = game:GetService('VirtualInputManager')

local a = core.RoactAppExperimentProvider.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame:GetChildren()
local b = a[math.random(1, #a)]
local c = b:FindFirstChild("ChildrenFrame"):FindFirstChild("NameFrame").BGFrame

local function init()
    vim:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
    vim:SendKeyEvent(false, Enum.KeyCode.Escape, false, game)
    task.wait(.01)
    vim:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
    vim:SendKeyEvent(false, Enum.KeyCode.Escape, false, game)
end
task.wait(.5)
local function init2()
    if c then
        local d = c.AbsolutePosition
        vim:SendMouseButtonEvent(d.X, d.Y, 0, true, game, 1)
        vim:SendMouseButtonEvent(d.X, d.Y, 0, false, game, 1)
        task.wait(0.5)
        vim:SendMouseButtonEvent(d.X, d.Y, 0, true, game, 1)
        vim:SendMouseButtonEvent(d.X, d.Y, 0, false, game, 1)
    else
        warn("failed to fix bug")
    end
end
init()
init2()
 
--// vars
local messages = core.ExperienceChat.appLayout.chatWindow.scrollingView.bottomLockedScrollView.RCTScrollView.RCTScrollContentView
local playerList = players:GetPlayers()
local leaderboard = core.RoactAppExperimentProvider.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame
if core.RoactAppExperimentProvider.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer:FindFirstChild("PlayerDropDown") then
    playerMenu = core.RoactAppExperimentProvider.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer:FindFirstChild("PlayerDropDown")
else
    warn("init failed")
    return
end
local robloxMenu = core.RobloxGui.SettingsClippingShield.SettingsShield
local cages = workspace.active:GetChildren()
local creds = players.LocalPlayer.PlayerGui.hud.safezone.coins
local lvl = players.LocalPlayer.PlayerGui.hud.safezone.lvl

local function dis(player)
    return player.DisplayName or player.Name
end

local o = {
    "[System] Cosin said join ( discord.gg/22sSKf7A5P )",
    "[System] Join the Discord server for more scripts..",
    "[System] Join Lyth's Community Discord server for more scripts.",
    "[System] Buss it down",
    "[System] Brought to you by Cosin",
    "[System] Fisch developers actually stink.",
    "[System] The moderators in Fisch are chronic",
    "[System] Fisch developers are money hungry maggots",
    "[System] blu was here",
    "[System] Fisch is a shit game",
}

local function chatSpoof(child)
    if _G.chatSpoof then
        if child and child:IsA("Frame") then
            local txt = child:FindFirstChild("TextMessage")
            if txt then
                local body = txt:FindFirstChild("BodyText")
                local prefix = txt:FindFirstChild("PrefixText")
                if body then
                    local prev = body.Text
                    if string.match(prev, "%[System%]") then
                        local c = string.match(prev, "color='(.-)'") or "#5400fd"
                        body.Text = "<font color='" .. c .. "'>" .. o[math.random(1, #o)] .. "</font>"
                    else
                        for _, player in ipairs(playerList) do
                            local dn = dis(player)
                            local cm = string.match(prev, "color='(.-)'") or "#5400fd"
                            prev = string.gsub(prev, dn, "<font color='" .. cm .. "'>" .. _G.config.name .. "</font>")
                        end
                        body.Text = prev
                    end
                    if prefix then
                        txt.TextMessageButton.Visible = false
                        local title = string.match(prefix.Text, "%[(.-)%]") or ""
                        if title ~= "" then
                            prefix.Text = "<font color=\"#5400fd\">[ " .. title .. " ]</font><font color=\"#ff0000\">" .. _G.config.name .. ":</font>"
                        else
                            prefix.Text = "<font color=\"#5400fd\">" .. _G.config.name .. ":</font>"
                        end
                    end
                end
            end
        end
    else
        return
    end
end

local function leaderboardSpoof(lbPlayer)
    if _G.leaderboardSpoof then
        local change = lbPlayer:FindFirstChild("ChildrenFrame")
        if change then   
            change.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName.Text = _G.config.discord
            change["GameStat_C$"].OverlayFrame.StatText.Text = _G.config.name
            change["GameStat_Level"].OverlayFrame.StatText.Text = _G.config.level

            change["GameStat_C$"].OverlayFrame.StatText:GetPropertyChangedSignal("Text"):Connect(function() 
                change["GameStat_C$"].OverlayFrame.StatText.Text = _G.config.name  
            end)
            change["GameStat_Level"].OverlayFrame.StatText:GetPropertyChangedSignal("Text"):Connect(function() 
                change["GameStat_Level"].OverlayFrame.StatText.Text = _G.config.level
            end)
        end
    else
        return
    end
end

if _G.leaderboardSpoof then
    for _, row in ipairs(leaderboard:GetChildren()) do
        if row:IsA("Frame") then
            leaderboardSpoof(leaderboard:FindFirstChild(row.Name))
        end
    end
else
    return
end

local function plrMenu()
    local menu = playerMenu.InnerFrame.PlayerHeader
    if menu then
        menu.Background.TextContainerFrame.DisplayName.Text = _G.config.name
        menu.Background.TextContainerFrame.PlayerName.Text = _G.config.message
        menu.AvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=7571173667&w=150&h=150" or _G.headshot
    end
end

robloxMenu.MenuContainer.HubBar.HubBarContainer.ReportAbuseTab.Visible = _G.hidetabs
robloxMenu.MenuContainer.HubBar.HubBarContainer.CapturesTab.Visible = _G.hidetabs
robloxMenu.MenuContainer.HubBar.HubBarContainer.HelpTab.Visible = _G.hidetabs
robloxMenu.MenuContainer.HubBar.HubBarContainer.GameSettingsTab.Visible = _G.hidetabs
robloxMenu.MenuContainer.PageViewClipper.PageView.PageViewInnerFrame.Players.ImageButton.Visible = false

local function menuSpoof()
    if _G.menuSpoof then
        for _, child in pairs(robloxMenu.MenuContainer.PageViewClipper.PageView.PageViewInnerFrame.Players:GetChildren()) do
            if child:IsA("ImageLabel") then
                child.Name = "Player"
                local dn = child:FindFirstChild("DisplayNameLabel")
                local n = child:FindFirstChild("NameLabel")
                local a = child:FindFirstChild("Icon")
                local b = child:FindFirstChild("RightSideButtons")
                if b then b:Destroy() end
                if dn then dn.Text = "@".._G.config.name end
                if n then n.Text = _G.config.discord end
                if a then a.Image = _G.config.thumbnail or "rbxthumb://type=Avatar&id=7571173667&w=100&h=100" end
            end
        end
    else
        return
    end
end

local function cageSpoof(cage)
    if _G.cageSpoof then
        local prompt = cage:FindFirstChild("Prompt")
        if prompt and prompt:IsA("ProximityPrompt") then
            prompt.ObjectText = _G.config.discord
        end
    else
        return
    end
end

if _G.cageSpoof then
    for _, cage in pairs(cages) do
        cageSpoof(cage)
    end
else
    return
end

local function playerSpoof(character)
    if _G.playerSpoof then
            --character.Name = "Cosin"
            for _, bodyParts in ipairs(character:GetChildren()) do
            if bodyParts:IsA("CharacterMesh") then
                bodyParts.BodyPart = "Head"
            elseif bodyParts:IsA("Part") and bodyParts.AssemblyRootPart == character:FindFirstChild("HumanoidRootPart") then
                bodyParts.Color = Color3.fromRGB(63, 16, 229)
            elseif bodyParts:IsA("Accessory") or bodyParts:IsA("Shirt") or bodyParts:IsA("Pants") or bodyParts:IsA("ShirtGraphic") then
                bodyParts:Destroy()
            end
        end
        local head = character:FindFirstChild("Head")
        if head then
            local mesh = head:FindFirstChild("Mesh")
            if mesh then 
                mesh:Destroy() 
            end
            local face = head:FindFirstChild("face")
            if face then 
                face.Texture = "http://www.roblox.com/asset/?id=144080495" 
            end
        end
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            local UI = root:FindFirstChild("user")
            if UI then
                UI.level.Text = "Level: ".._G.config.level
                UI.user.Text = _G.config.name
                UI.streak.Text = _G.config.streak
                UI.title.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Italic)
                UI.title.TextColor3 = Color3.fromRGB(63, 16, 229)
                UI.title.Text = _G.config.discord
            end
        end
    else
        return
    end
end

--[ CHAT ]
if _G.chatSpoof then
    messages.ChildAdded:Connect(function(m1)
        chatSpoof(m1)
    end)

    for _, m2 in ipairs(messages:GetChildren()) do
        chatSpoof(m2)
    end
else
    return
end

--[ LEADERBOARD ]
if _G.leaderboardSpoof then
    leaderboard.ChildAdded:Connect(function(child)
        if child:IsA("Frame") then leaderboardSpoof(child) end
    end)

    if playerMenu and playerMenu.InnerFrame then
        playerMenu.InnerFrame:GetPropertyChangedSignal("Visible"):Connect(function() 
            if playerMenu.InnerFrame.Visible then plrMenu() end 
        end)
    else
        warn("playerMenu or InnerFrame is nil")
    end
else
    return
end

--[ MENU ]
if _G.menuSpoof then
    local plrF = robloxMenu.MenuContainer.PageViewClipper.PageView.PageViewInnerFrame.Players
    plrF:GetPropertyChangedSignal("Visible"):Connect(function() 
        if plrF.Visible then 
            task.wait(0.1)
            menuSpoof()
        end
    end)
else
    return
end

--[ CAGE ]
if _G.cageSpoof then
    game.Workspace.active.ChildAdded:Connect(function(child)
        if child:IsA("Model") and child:FindFirstChild("Prompt") then
            table.insert(cages, child)
            cageSpoof(child)
        end
    end)
else
    return
end

--[ PLAYER ]
if _G.playerSpoof then
    for _, player in pairs(players:GetPlayers()) do
        if player.Character then
            playerSpoof(player.Character)
        end
    end
else
    return
end

if _G.playerSpoof then
    game.Workspace.ChildAdded:Connect(function(child)
        if child:IsA("Model") then
            playerSpoof(child)
        end
    end)
    creds.Text = _G.config.cash
    creds:GetPropertyChangedSignal("Text"):Connect(function()
        creds.Text = _G.config.cash
    end)

    if _G.config.level >= 500 then
        lvl.Text = 'Max Level'
    else
        lvl.Text = tostring(_G.config.level)
    end
    lvl:GetPropertyChangedSignal("Text"):Connect(function()
        if _G.config.level >= 500 then
            lvl.Text = 'Max Level'
        else
            lvl.Text = tostring(_G.config.level)
        end
    end)
else
    return
end

-- from lyth
players.LocalPlayer.PlayerGui.hud.safezone.ChildAdded:Connect(function(ui)
    if ui.Name == "xpup" then
        ui.lvlup.Text = _G.config.name .. " Leveling"
        ui.reward.Text = "-"
        ui.title.Text = _G.config.name .. " Leveling"
        ui.xp.Text = "+9999xp"
    end
    if ui.Name == "lvlup" then
        ui.Visible = false
    end
end)

-- spoof trades
players.LocalPlayer.PlayerGui.hud.safezone.announcements.ChildAdded:Connect(function(v)
    if v.Name == "thought" then
        if v.Main.Text:find("You offered a") then
            local n = v.Main.Text:match("You offered a (.+) to")
            local c = v.Main.Text:match("<font color='(.-)'>")
            v.Main.Text = string.format("You offered a <font color='%s'>%s</font>!", c, n)
        elseif v.Main.Text:find("Item offer to") then
            v.Main.Text = string.format("Item offer to ? was accepted!")
        elseif v.Main.Text:find("Item offer from") then
            v.Main.Text = string.format("Item offered from ? was accepted!")
        end
    end
end)

players.LocalPlayer.PlayerGui.hud.safezone.bodyannouncements.ChildAdded:Connect(function(v)
    if v.Name == "offer" then
        v.question.Text = v.question.Text:gsub(".* is offering you", "")
    end
end)
