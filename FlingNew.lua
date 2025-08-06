getgenv().flingloop = true

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local FLINGNAME = tostring(getgenv().FLINGTARGET):lower()
local AllBool = FLINGNAME == "all" or FLINGNAME == "others"

local function Message(title, text, time)
    Fluent:Notify({
        Title = title,
        Content = text,
        Duration = time or 3
    })
end

local function GetPlayer(name)
    name = tostring(name):lower()
    if name == "random" then
        local list = Players:GetPlayers()
        table.remove(list, table.find(list, Player))
        return list[math.random(#list)]
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player then
            if plr.Name:lower():match("^" .. name) or plr.DisplayName:lower():match("^" .. name) then
                return plr
            end
        end
    end
end

local function SkidFling(TargetPlayer)
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter and TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")

    if not (Character and Humanoid and RootPart and TCharacter) then return end

    if RootPart.Velocity.Magnitude < 50 then
        getgenv().OldPos = RootPart.CFrame
    end

    if THumanoid and THumanoid.Sit and not AllBool then
        return Message("Error", "Target is sitting", 3)
    end

    local function FPos(BasePart, Pos, Ang)
        RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
        Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
        RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
        RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end

    local function SFBasePart(BasePart)
        local Time = tick()
        local Angle = 0
        repeat
            if not getgenv().flingloop then return end
            if RootPart and THumanoid then
                if BasePart.Velocity.Magnitude < 50 then
                    Angle += 100
                    FPos(BasePart, CFrame.new(0, 1.5, 0), CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                else
                    FPos(BasePart, CFrame.new(0, 1.5, 10), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                end
            else
                break
            end
        until tick() > Time + 2 or Humanoid.Health <= 0
    end

    workspace.FallenPartsDestroyHeight = 0/0

    local BV = Instance.new("BodyVelocity")
    BV.Name = "EpixVel"
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)

    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    if TRootPart and THead then
        SFBasePart(THead)
    elseif TRootPart then
        SFBasePart(TRootPart)
    elseif THead then
        SFBasePart(THead)
    elseif Handle then
        SFBasePart(Handle)
    else
        Message("Error", "Target has no flingable parts", 3)
    end

    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    workspace.CurrentCamera.CameraSubject = Humanoid

    repeat
        RootPart.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
        Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
        task.wait()
    until (RootPart.Position - getgenv().OldPos.p).Magnitude < 10

    workspace.FallenPartsDestroyHeight = getgenv().FPDH or -500
end

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

pcall(function()
    while getgenv().flingloop do
        if AllBool then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= Player and not WhitelistedUserIDs[plr.UserId] then
                    SkidFling(plr)
                end
            end
        else
            local target = GetPlayer(FLINGNAME)
            if target and not WhitelistedUserIDs[target.UserId] then
                SkidFling(target)
            end
        end
        task.wait()
    end
end)
