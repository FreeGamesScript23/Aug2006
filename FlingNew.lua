-- Initialization
getgenv().flingloop = true
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Function to send messages
local function Message(_Title, _Text, Time)
    -- Replace with your notification system or remove if not needed
    print(_Title .. ": " .. _Text)
end

-- Function to teleport, apply force, and return
local function TeleportFlingAndReturn(TargetPlayer)
    if not getgenv().flingloop then return end  -- Exit if flingloop is false

    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart

    if Character and Humanoid and RootPart and TRootPart then
        -- Save the old position
        local OldPos = RootPart.CFrame

        -- Teleport to target
        RootPart.CFrame = TRootPart.CFrame * CFrame.new(0, 5, 0)  -- Adjust position above the target if needed
        Character:SetPrimaryPartCFrame(TRootPart.CFrame * CFrame.new(0, 5, 0))

        -- Create a BodyVelocity to apply a force to the target
        local BV = Instance.new("BodyVelocity")
        BV.Name = "FlingVelocity"
        BV.Parent = TRootPart
        BV.Velocity = Vector3.new()  -- Start with no velocity
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)  -- Infinite force

        local timeToWait = 0.1  -- Adjust as needed
        local flingSpeed = 1000  -- Adjust the fling speed as needed
        local direction = 1  -- 1 for right, -1 for left

        -- Apply force repeatedly until the target is flung
        local startTime = tick()
        while getgenv().flingloop do
            -- Apply force
            BV.Velocity = Vector3.new(direction * flingSpeed, 0, 0)
            task.wait(timeToWait)
            BV.Velocity = Vector3.new()
            task.wait(timeToWait)

            -- Change direction
            direction = -direction

            -- Check if the target has been flung away
            if (TRootPart.Position - RootPart.Position).Magnitude > 50 then  -- Adjust the distance as needed
                break
            end

            -- Check for exit conditions
            if not TargetPlayer.Character or TargetPlayer.Parent ~= Players or Humanoid.Health <= 0 then
                break
            end
        end

        -- Clean up
        BV:Destroy()

        -- Return to original position
        RootPart.CFrame = OldPos
        Character:SetPrimaryPartCFrame(OldPos)

        -- Wait to ensure the force is applied and character is returned
        task.wait(1)

    else
        return Message("Error Occurred", "Character or Target is missing.", 5)
    end
end

-- Main loop
while getgenv().flingloop do
    local function GetPlayer(Name)
        Name = Name:lower()
        if Name == "all" or Name == "others" then
            return Players:GetPlayers()
        elseif Name == "random" then
            local GetPlayers = Players:GetPlayers()
            if table.find(GetPlayers, Player) then table.remove(GetPlayers, table.find(GetPlayers, Player)) end
            return GetPlayers[math.random(#GetPlayers)]
        else
            for _, x in next, Players:GetPlayers() do
                if x.Name:lower():match("^" .. Name) or x.DisplayName:lower():match("^" .. Name) then
                    return x
                end
            end
        end
        return nil
    end

    local function HandleTargets(Targets)
        for _, x in next, Targets do
            if not getgenv().flingloop then return end  -- Exit if flingloop is false

            local TPlayer = GetPlayer(x)
            if TPlayer and TPlayer ~= Player then
                -- Check if the player is whitelisted
                local WhitelistedUserIDs = {
                    [129215104] = true, [6069697086] = true, [4072731377] = true,
                    [6150337449] = true, [1571371222] = true, [2911976621] = true,
                    [2729297689] = true, [6150320395] = true, [301098121] = true,
                    [773902683] = true, [290931] = true, [671905963] = true,
                    [3129701628] = true, [3063352401] = true, [6135258891] = true,
                    [3129413184] = true
                }

                if not WhitelistedUserIDs[TPlayer.UserId] then
                    TeleportFlingAndReturn(TPlayer)
                else
                    Message("Info", "Player is whitelisted and skipped.", 3)
                end
            elseif not TPlayer then
                Message("Error", "Invalid username or player not found.", 3)
            end
        end
    end

    -- Define targets and handle them
    local Targets = {FLINGTARGET}  -- Replace FLINGTARGET with actual target names
    HandleTargets(Targets)

    -- Wait before repeating
    task.wait(5)
end
