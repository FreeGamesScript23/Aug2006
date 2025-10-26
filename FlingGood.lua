getgenv().flingloop = false
getgenv().FlingConnection = nil

Players = cloneref(game:GetService("Players"))
Player = Players.LocalPlayer
OriginalPhysics = {}

function setCharacterPhysics(enabled)
	local Character = Player.Character
	if not Character then return end
	for _, part in pairs(Character:GetDescendants()) do
		if part:IsA("BasePart") then
			if enabled then
				if not OriginalPhysics[part] then
					OriginalPhysics[part] = {CanCollide = part.CanCollide, Massless = part.Massless}
				end
				part.CanCollide, part.Massless = false, true
			else
				if OriginalPhysics[part] then
					part.CanCollide = OriginalPhysics[part].CanCollide
					part.Massless = OriginalPhysics[part].Massless
					OriginalPhysics[part] = nil
				else
					part.CanCollide, part.Massless = true, false
				end
			end
		end
	end
end

local function monitorTools()
	local Character = Player.Character
	if not Character then return end
	
	Character.ChildAdded:Connect(function(child)
		if child:IsA("Tool") and getgenv().flingloop then
			task.wait(0.1)
			for _, part in pairs(child:GetDescendants()) do
				if part:IsA("BasePart") then
					if not OriginalPhysics[part] then
						OriginalPhysics[part] = {CanCollide = part.CanCollide, Massless = part.Massless}
					end
					part.CanCollide, part.Massless = false, true
				end
			end
		end
	end)
end

Player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	monitorTools()
	if getgenv().flingloop then
		setCharacterPhysics(true)
	end
end)

if Player.Character then
	monitorTools()
end

function cleanup()
	setCharacterPhysics(false)

	local Character = Player.Character
	if Character then
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		if Humanoid then
			workspace.CurrentCamera.CameraSubject = Humanoid
			workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
			
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
		end
		
		local RootPart = Humanoid and Humanoid.RootPart
		if RootPart then
			local BV = RootPart:FindFirstChild("EpixVel")
			if BV then
				BV:Destroy()
			end
			
			for _, part in pairs(Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Velocity = Vector3.new()
					part.RotVelocity = Vector3.new()
				end
			end
		end
	end
	
	if getgenv().FPDH ~= nil then
		workspace.FallenPartsDestroyHeight = getgenv().FPDH
	end
end

function flingloopfix()
    local Targets = {getgenv().FLINGTARGET}

    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer

    local AllBool = false

    setCharacterPhysics(true)

    local GetPlayer = function(Name)
        Name = Name:lower()
        if Name == "all" or Name == "others" then
            AllBool = true
            return
        elseif Name == "random" then
            local GetPlayers = Players:GetPlayers()
            if table.find(GetPlayers, Player) then table.remove(GetPlayers, table.find(GetPlayers, Player)) end
            return GetPlayers[math.random(#GetPlayers)]
        elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
            for _, x in next, Players:GetPlayers() do
                if x ~= Player then
                    if x.Name:lower():match("^" .. Name) then
                        return x
                    elseif x.DisplayName:lower():match("^" .. Name) then
                        return x
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
            if RootPart.Velocity.Magnitude < 50 then
                getgenv().OldPos = RootPart.CFrame
            end
            if THumanoid and THumanoid.Sit and not AllBool then
                return Message("Error Occurred", "Targeting is sitting", 5)
            end
            if THumanoid and THumanoid.Health > 0 then
                if THead then
                    workspace.CurrentCamera.CameraSubject = THead
                elseif not THead and Handle then
                    workspace.CurrentCamera.CameraSubject = Handle
                elseif THumanoid and TRootPart then
                    workspace.CurrentCamera.CameraSubject = THumanoid
                end
            end
            if not TCharacter:FindFirstChildWhichIsA("BasePart") then
                return
            end

            local FPos = function(BasePart, Pos, Ang)
                RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
            end

            getgenv().FPDH = getgenv().FPDH or workspace.FallenPartsDestroyHeight
            
            local SFBasePart = function(BasePart)
                local TimeToWait = 2
                local Time = tick()
                local Angle = 0

                repeat
                    if not getgenv().flingloop then
                        break
                    end

                    if not THumanoid or THumanoid.Health <= 0 then
                        workspace.CurrentCamera.CameraSubject = Humanoid
                        break
                    end

                    if RootPart and THumanoid then
                        if BasePart.Velocity.Magnitude < 50 then
                            Angle = Angle + 100

                            FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                        else
                            FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                            task.wait()
                        end
                    else
                        break
                    end
                until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
            end

            workspace.FallenPartsDestroyHeight = 0/0

            local BV = Instance.new("BodyVelocity")
            BV.Name = "EpixVel"
            BV.Parent = RootPart
            BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
            BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)

            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

            if TRootPart and THead then
                if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                    SFBasePart(THead)
                else
                    SFBasePart(TRootPart)
                end
            elseif TRootPart and not THead then
                SFBasePart(TRootPart)
            elseif not TRootPart and THead then
                SFBasePart(THead)
            elseif not TRootPart and not THead and Accessory and Handle then
                SFBasePart(Handle)
            else
                return Message("Error Occurred", "Target is missing everything", 5)
            end

            BV:Destroy()
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            
            workspace.CurrentCamera.CameraSubject = Humanoid
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

            if getgenv().OldPos and RootPart then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Velocity = Vector3.new()
                        part.RotVelocity = Vector3.new()
                        part.AssemblyLinearVelocity = Vector3.new()
                        part.AssemblyAngularVelocity = Vector3.new()
                    end
                end
                
                task.wait(0.1)
                
                repeat
                    if RootPart and getgenv().OldPos then
                        RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                        Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                        Humanoid:ChangeState("GettingUp")
                        
                        for _, x in pairs(Character:GetChildren()) do
                            if x:IsA("BasePart") then
                                x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                            end
                        end
                        
                        workspace.CurrentCamera.CameraSubject = Humanoid
                    end
                    task.wait()
                until not RootPart or (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
            end
            
            workspace.CurrentCamera.CameraSubject = Humanoid
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            
            workspace.FallenPartsDestroyHeight = (getgenv().FPDH ~= nil) and getgenv().FPDH or 0
        else
            return Message("Error Occurred", "Random error", 5)
        end
    end

    if not Welcome then
        Message("Hub Says:", "Fling Script has been loaded", 3)
    end
    getgenv().Welcome = true

    if Targets[1] then
        for _, x in next, Targets do
            if x:lower() == "all" or x:lower() == "others" then
                AllBool = true
                break
            else
                GetPlayer(x)
            end
        end
    else
        return
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

    if AllBool then
        for _, player in next, Players:GetPlayers() do
            if player ~= Player and not WhitelistedUserIDs[player.UserId] then
                if not getgenv().flingloop then break end
                SkidFling(player)
                task.wait(0.5)
            end
        end
    else
        for _, x in next, Targets do
            if not getgenv().flingloop then break end
            local TPlayer = GetPlayer(x)
            if TPlayer and TPlayer ~= Player then
                if not WhitelistedUserIDs[TPlayer.UserId] then
                    SkidFling(TPlayer)
                    task.wait(0.5)
                else
                    Message("Info", "Player is whitelisted and skipped.", 3)
                end
            elseif not TPlayer then
                Message("Error", "Invalid username or player not found.", 3)
            end
        end
    end
end

function disconnectFling()
	if getgenv().FlingConnection then
		task.cancel(getgenv().FlingConnection)
		getgenv().FlingConnection = nil
		cleanup()
		print("Fling loop disconnected")
	end
end

function connectFling()
	if not getgenv().FlingConnection then
		getgenv().FlingConnection = task.spawn(function()
			while not getgenv().AshDestroyed do
				if getgenv().flingloop then
					pcall(flingloopfix)
				else
					cleanup()
				end
				task.wait(1)
			end
		end)
		print("Fling loop connected")
	end
end

task.spawn(function()
	local lastState = getgenv().flingloop
	
	if getgenv().flingloop then
		connectFling()
	end
	
	while not getgenv().AshDestroyed do
		if getgenv().flingloop ~= lastState then
			if getgenv().flingloop then
				connectFling()
			else
				disconnectFling()
			end
			lastState = getgenv().flingloop
		end
		task.wait(0.1)
	end
	disconnectFling()
end)
