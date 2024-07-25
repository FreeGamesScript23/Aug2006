-- Assuming you have a UI library providing Toggle functionality
local Toggle = Tabs.Buttons:AddToggle("FEInviButtonPerk", {Title = "FE invisible Button + Invisible(Need Ghost Perk) ", Default = false})

-- Variable to hold the ScreenGui and its position
local screenGui
local savedPosition = UDim2.new(0.5, -0.5, 0.5, -37.5)  -- Default position

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
    button.Text = "(Perk)\nFE Invisible is"
    button.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text color
    button.Parent = frame

    -- Function to toggle button text based on Options.FEInvisible value
    game:GetService("ReplicatedStorage").Remotes.Gameplay.Stealth:FireServer(false)
    local function toggleButtonText()
        if Options.FEInvisible.Value then
            button.Text = "(Perk)\nFE Invisible is [ON]"
            game:GetService("ReplicatedStorage").Remotes.Gameplay.Stealth:FireServer(true)
        else
            button.Text = "(Perk)\nFE Invisible is [OFF]"
            game:GetService("ReplicatedStorage").Remotes.Gameplay.Stealth:FireServer(false)
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
Options.Invisible:SetValue(false)


-- Ensure the GUI persists across respawns
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function()
    if Toggle.Value then
        createGui()
    end
end)



local Toggle = Tabs.Buttons:AddToggle("FEInviButton", {Title = "FE invisible Button Only", Default = false})

-- Variable to hold the ScreenGui and its position
local screenGui
local savedPosition = UDim2.new(0.5, -0.5, 0.5, -37.5)  -- Default position

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
    button.Text = "FE Invisible is"
    button.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text color
    button.Parent = frame

    -- Function to toggle button text based on Options.FEInvisible value
    
    local function toggleButtonText()
        if Options.FEInvisible.Value then
            button.Text = "FE Invisible is [ON]"
            
        else
            button.Text = "FE Invisible is [OFF]"
            
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

-- Assuming you have a UI library providing Toggle functionality
local Toggle = Tabs.Buttons:AddToggle("Togglename", {Title = "Silent Aim Button", Default = false})

-- Function to call when button is clicked
local function onButtonClicked()
    -- Define the murderer character
    if Murder then
        local player = game.Players.LocalPlayer
        local murdererCharacter = game.Players[Murder].Character
        
        if murdererCharacter and murdererCharacter:FindFirstChild("HumanoidRootPart") then
            if player.Character:FindFirstChild("Gun") then
                player.Character.Gun.KnifeServer.ShootGun:InvokeServer(1, murdererCharacter.HumanoidRootPart.Position, "AH")
            else
                -- Player doesn't have a gun, show notification
                Fluent:Notify({
                    Title = "You don't have a gun",
                    Content = "Wait for the sheriff death or grab the gun",
                    Duration = 3
                })
            end
        else
            warn("Murderer character or HumanoidRootPart not found!")
        end
    else
        warn("Murderer not defined!")
    end
end

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
    button.Text = "Shoot"
    button.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text color
    button.Parent = frame

    -- Connect the button click event to the function
    button.MouseButton1Click:Connect(onButtonClicked)

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
Options.Togglename:SetValue(false)

-- Ensure the GUI persists across respawns
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function()
    if Toggle.Value then
        createGui()
    end
end)

-- Create the toggle
local Toggle = Tabs.Buttons:AddToggle("GrabButton", {Title = "Grab Gun Button", Default = false })

-- Create a ScreenGui
local screenGui
local savedPosition = UDim2.new(0.5, 75, 0.5, -37.5)  -- Default position

-- Function to create or destroy the GUI based on toggle state
local function toggleGui(value)
    if value then
        -- Create the GUI
        screenGui = Instance.new("ScreenGui")
        screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

        -- Create the Frame
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

        -- Create the Button
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 80, 0, 40) -- Smaller size
        button.Position = UDim2.new(0.5, 0, 0.5, 0) -- Centered in the frame
        button.AnchorPoint = Vector2.new(0.5, 0.5)
        button.BackgroundTransparency = 1 -- Remove background color
        button.Text = "Grab Gun"
        button.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text color
        button.Parent = frame
             local function updateButtonText()
    local gunReady = workspace:FindFirstChild("GunDrop")
    if gunReady then
        button.Text = "Grab Gun (Ready)"
    else
        button.Text = "Grab Gun"
    end
end

-- Connect the function to update the button text
workspace.ChildAdded:Connect(updateButtonText)
workspace.ChildRemoved:Connect(updateButtonText)
        -- Function to handle the button click event

button.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    
    if not IsAlive(player) then
        Fluent:Notify({
            Title = "You're not alive",
            Content = "Please wait for the new round to grab the gun.",
            Duration = 3
        })
        return
    end
    
    if player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Gun")) then
        Fluent:Notify({
            Title = "You already have a gun",
            Content = "Lollll.",
            Duration = 3
        })
        return
    end
    
    if player.Character then
        local gundr = workspace:FindFirstChild("GunDrop")
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
            Fluent:Notify({
                Title = "Gun not Found",
                Content = "Wait for the Sheriff's death to grab the gun.",
                Duration = 3
            })
        end
    end
end)

        -- Function to handle GUI drag on mobile
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

    else
        -- Destroy the GUI if it exists
        if screenGui then
            screenGui:Destroy()
            screenGui = nil
        end
    end
end

-- Connect the toggle's OnChanged event to the function
Toggle:OnChanged(toggleGui)

-- Set the initial state of the toggle
Options.GrabButton:SetValue(false)

-- Ensure the GUI persists across respawns and retains its position
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function()
    if Toggle.Value then
        toggleGui(true)
    end
end)


local Toggle = Tabs.Buttons:AddToggle("ShootMurd", {Title = "TP Shoot Murd", default = false })

-- Create a ScreenGui
local screenGui
local savedPosition = UDim2.new(0.5, 75, 0.5, 37)  -- Default position

-- Function to create or destroy the GUI based on toggle state
local function toggleGui(value)
    if value then
        -- Create the GUI
        screenGui = Instance.new("ScreenGui")
        screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

        -- Create the Frame
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

        -- Create the Button
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 80, 0, 40) -- Smaller size
        button.Position = UDim2.new(0.5, 0, 0.5, 0) -- Centered in the frame
        button.AnchorPoint = Vector2.new(0.5, 0.5)
        button.BackgroundTransparency = 0.8 -- Remove background color
        button.Text = "TP Shoot Murd"
        button.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text color
        button.Parent = frame

button.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local currentPosition = humanoidRootPart.CFrame

    if Murder then
        local murdererCharacter = game.Players[Murder] and game.Players[Murder].Character
        if murdererCharacter and murdererCharacter:FindFirstChild("HumanoidRootPart") then
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
                    player.Character:MoveTo(currentPosition.Position)
                    player.Character.Gun.KnifeServer.ShootGun:InvokeServer(1, murdererCharacter.HumanoidRootPart.Position, "AH")
                end
            else
                Fluent:Notify({
                    Title = "You don't have a Gun",
                    Content = "Grab the gun or wait for Sheriff Death.",
                    Duration = 3
                })
            end
        else
            Fluent:Notify({
                Title = "Murderer not Found",
                Content = "Murderer's character not found.",
                Duration = 3
            })
        end
    else
        Fluent:Notify({
            Title = "Murderer not Found",
            Content = "Murderer role not assigned yet.",
            Duration = 3
        })
    end
end)

        -- Function to handle GUI drag on mobile
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

    else
        -- Destroy the GUI if it exists
        if screenGui then
            screenGui:Destroy()
            screenGui = nil
        end
    end
end

-- Connect the toggle's OnChanged event to the function
Toggle:OnChanged(toggleGui)

-- Set the initial state of the toggle
Options.ShootMurd:SetValue(false) ----CHANGE THIS

-- Ensure the GUI persists across respawns and retains its position
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function()
    if Toggle.Value then
        toggleGui(true)
    end
end)

local Toggle = Tabs.Buttons:AddToggle("StabSheriff", {Title = "TP Stab Sheriff/Hero", default = false })

-- Create a ScreenGui
local screenGui
local savedPosition = UDim2.new(0.5, 75, 0.5, 37)  -- Default position

-- Function to create or destroy the GUI based on toggle state
local function toggleGui(value)
    if value then
        -- Create the GUI
        screenGui = Instance.new("ScreenGui")
        screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

        -- Create the Frame
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

        -- Create the Button
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 80, 0, 40) -- Smaller size
        button.Position = UDim2.new(0.5, 0, 0.5, 0) -- Centered in the frame
        button.AnchorPoint = Vector2.new(0.5, 0.5)
        button.BackgroundTransparency = 0.8 -- Remove background color
        button.Text = "TP Stab Sheriff/Hero"
        button.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text color
        button.Parent = frame

button.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not humanoidRootPart then
        Fluent:Notify({
            Title = "Error",
            Content = "HumanoidRootPart not found.",
            Duration = 3
        })
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
        Fluent:Notify({
            Title = "You are not Murderer",
            Content = "Bruh will not work if you're not Murderer",
            Duration = 3
        })
        return
    end

    local targetPlayer = getTargetPlayer()

    if targetPlayer then
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
            Fluent:Notify({
                Title = "Target not Found",
                Content = "Target character not found.",
                Duration = 3
            })
        end
    else
        Fluent:Notify({
            Title = "Character not Found",
            Content = "No suitable target found.",
            Duration = 3
        })
    end
end)

        -- Function to handle GUI drag on mobile
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

    else
        -- Destroy the GUI if it exists
        if screenGui then
            screenGui:Destroy()
            screenGui = nil
        end
    end
end

-- Connect the toggle's OnChanged event to the function
Toggle:OnChanged(toggleGui)

-- Set the initial state of the toggle
Options.StabSheriff:SetValue(false) ----CHANGE THIS

-- Ensure the GUI persists across respawns and retains its position
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function()
    if Toggle.Value then
        toggleGui(true)
    end
end)


local Toggle = Tabs.Buttons:AddToggle("InviButton", {Title = "Invisible Button (Need Ghost Perk)", Default = false})

-- Variable to hold the ScreenGui and its position
local screenGui
local savedPosition = UDim2.new(0.5, 100, 0.5, 37.5)  -- Default position

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
    button.Text = "Invisible is"
    button.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text color
    button.Parent = frame

    -- Function to toggle button text based on Options.FEInvisible value
    game:GetService("ReplicatedStorage").Remotes.Gameplay.Stealth:FireServer(false)
    local function toggleButtonText()
        if Options.Invisible.Value then
            button.Text = "Invisible is [ON]"
            game:GetService("ReplicatedStorage").Remotes.Gameplay.Stealth:FireServer(true)
        else
            button.Text = "Invisible is [OFF]"
            game:GetService("ReplicatedStorage").Remotes.Gameplay.Stealth:FireServer(false)
        end
    end

    -- Connect the button click event to the toggle function
    button.MouseButton1Click:Connect(function()
        Options.Invisible:SetValue(not Options.Invisible.Value)
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
Options.Invisible:SetValue(false)

-- Ensure the GUI persists across respawns
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function()
    if Toggle.Value then
        createGui()
    end
end)
