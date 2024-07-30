-- Initialization
getgenv().flingloop = true
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Function to send messages
local function Message(_Title, _Text, Time)
    -- Replace with your notification system or remove if not needed
    print(_Title .. ": " .. _Text)
end

-- Function to apply force to the target
local function ApplyForceToTarget(TargetPlayer)
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid
    local TRootPart

    if TCharacter:FindFirstChildOfClass("Humanoid") then
        THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    end
    if THumanoid and THumanoid.RootPart then
        TRootPart = THumanoid.RootPart
    end

    if Character and Humanoid and RootPart and TRootPart then
        -- Save the old position
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end

        -- Error handling
        if THumanoid and THumanoid.Sit then
            return Message("Error Occurred", "Targeting is sitting", 5)
        end

        -- Create a BodyVelocity to apply a large force to the target
        local BV = Instance.new("BodyVelocity")
        BV.Name = "FlingVelocity"
        BV.Parent = TRootPart
        BV.Velocity = (TRootPart.Position - RootPart.Position).unit * 5000 -- Increase force magnitude
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)  -- Infinite force

        -- Function to move towards target
        local function MoveToTarget()
            while Character and RootPart and TargetPlayer.Character and TargetPlayer.Parent do
                local targetPos = TRootPart.Position
                local direction = (targetPos - RootPart.Position).unit
                RootPart.CFrame = CFrame.new(RootPart.Position + direction * 5) -- Move towards target
                task.wait(0.1)  -- Adjust wait time as needed

                -- Check if target is flung or moved out of range
                if (TRootPart.Position - targetPos).Magnitude > 1000 or not TargetPlayer.Character or THumanoid.Health <= 0 then
                    break
                end
            end
        end

        -- Move to the target rapidly
        MoveToTarget()

        -- Ensure target is flung out of the map
        task.wait(2) -- Ensure enough time for the fling to take effect

        -- Clean up
        BV:Destroy()

        -- Restore the character's position
        repeat
            RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
            Humanoid:ChangeState("GettingUp")
            for _, part in pairs(Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Velocity, part.RotVelocity = Vector3.new(), Vector3.new()
                end
            end
            task.wait()
        until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
    else
        return Message("Error Occurred", "Random error", 5)
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
                    ApplyForceToTarget(TPlayer)
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
