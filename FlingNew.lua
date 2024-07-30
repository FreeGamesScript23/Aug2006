-- I DID NOT MAKE THIS SCRIPT ALL CREDITS GOES TO THE OWNER

getgenv().flingloop = true
while getgenv().flingloop do
function flingloopfix()

local Targets = {FLINGTARGET}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local AllBool = false

local GetPlayer = function(Name)
    Name = Name:lower()
    if Name == "all" or Name == "others" then
        AllBool = true
        return
    elseif Name == "random" then
        local GetPlayers = Players:GetPlayers()
        if table.find(GetPlayers,Player) then table.remove(GetPlayers,table.find(GetPlayers,Player)) end
        return GetPlayers[math.random(#GetPlayers)]
    elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
        for _,x in next, Players:GetPlayers() do
            if x ~= Player then
                if x.Name:lower():match("^"..Name) then
                    return x;
                elseif x.DisplayName:lower():match("^"..Name) then
                    return x;
                end
            end
        end
    else
        return
    end
end

local Message = function(_Title, _Text, Time)
            Fluent:Notify({
                Title = _Title,
                Content = _Text,
                Duration = Time
            })
end

local SkidFling = function(TargetPlayer)
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid
    local TRootPart
    local THead
    local Accessory
    local Handle

    if TCharacter:FindFirstChildOfClass("Humanoid") then
        THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    end
    if THumanoid and THumanoid.RootPart then
        TRootPart = THumanoid.RootPart
    end
    if TCharacter:FindFirstChild("Head") then
        THead = TCharacter.Head
    end
    if TCharacter:FindFirstChildOfClass("Accessory") then
        Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    end
    if Accessory and Accessory:FindFirstChild("Handle") then
        Handle = Accessory.Handle
    end

    if Character and Humanoid and RootPart then
        -- Save the old position
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        
        -- Error handling
        if THumanoid and THumanoid.Sit and not AllBool then
            return Message("Error Occurred", "Targeting is sitting", 5)
        end
        
        -- Set camera subject
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif not THead and Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end

        -- Define circular movement
        local function CircularMovement(BasePart, Radius, Speed)
            local Angle = 0
            local MaxDistance = 500 -- Set a large value to ensure the target is flung out
            while true do
                if RootPart and THumanoid then
                    local X = Radius * math.cos(Angle)
                    local Z = Radius * math.sin(Angle)
                    local TargetPosition = BasePart.Position + Vector3.new(X, 0, Z)
                    RootPart.CFrame = CFrame.new(TargetPosition) * CFrame.Angles(0, math.rad(Angle), 0)
                    Character:SetPrimaryPartCFrame(RootPart.CFrame)
                    Angle = Angle + Speed
                    
                    -- Check if the target is far from the map
                    if (TargetPlayer.Character.PrimaryPart.Position - Vector3.new(0, 0, 0)).Magnitude > MaxDistance then
                        return
                    end
                    
                    task.wait()
                else
                    break
                end
            end
        end
        
        -- Fling logic
        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)

        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                CircularMovement(THead, 10, 1)  -- Adjust radius and speed as needed
            else
                CircularMovement(TRootPart, 10, 1)  -- Adjust radius and speed as needed
            end
        elseif TRootPart and not THead then
            CircularMovement(TRootPart, 10, 1)  -- Adjust radius and speed as needed
        elseif not TRootPart and THead then
            CircularMovement(THead, 10, 1)  -- Adjust radius and speed as needed
        elseif not TRootPart and not THead and Accessory and Handle then
            CircularMovement(Handle, 10, 1)  -- Adjust radius and speed as needed
        else
            return Message("Error Occurred", "Target is missing everything", 5)
        end
        
        -- Restore the character's position
        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid

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
        workspace.FallenPartsDestroyHeight = getgenv().FPDH
    else
        return Message("Error Occurred", "Random error", 5)
    end
end


if not Welcome then Message("Hub Says:","Fling Script has been loaded",3) end
getgenv().Welcome = true
if Targets[1] then for _,x in next, Targets do GetPlayer(x) end else return end

if AllBool then
    for _,x in next, Players:GetPlayers() do
        SkidFling(x)
    end
end

-- Whitelisted User IDs
local WhitelistedUserIDs = {
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
    [6135258891] = true,
    [3129413184] = true

}


-- Inside your loop where you decide whom to target
for _, x in next, Targets do
    local TPlayer = GetPlayer(x)
    if TPlayer and TPlayer ~= Player then
        if x:lower() == "all" then
            -- Targeting all players except whitelisted ones
            for _, player in ipairs(Players:GetPlayers()) do
                if not WhitelistedUserIDs[player.UserId] then
                    SkidFling(player)
                end
            end
        else
            -- Targeting a specific player
            if not WhitelistedUserIDs[TPlayer.UserId] then
                SkidFling(TPlayer)
            else
                Message("Info", "Player is whitelisted and skipped.", 3)
            end
        end
    elseif not TPlayer and not AllBool then
        Message("Error", "Invalid username or player not found.", 3)
    end
end
task.wait()
end
wait()
pcall(flingloopfix)
end
