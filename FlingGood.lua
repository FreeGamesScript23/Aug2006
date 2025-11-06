getgenv().flingloop = false

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

-- Safely stabilize character before disabling physics
function safelyStabilizeCharacter()
	local Character = Player.Character
	if not Character then return end
	
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	local RootPart = Humanoid and Humanoid.RootPart
	
	if not RootPart then return end
	
	-- Remove any existing BodyVelocity
	for _, v in pairs(RootPart:GetChildren()) do
		if v:IsA("BodyVelocity") then
			v:Destroy()
		end
	end
	
	-- Teleport to safe position if we have one stored
	if getgenv().OldPos then
		RootPart.CFrame = getgenv().OldPos * CFrame.new(0, 3, 0)
		Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 3, 0))
	end
	
	-- Stabilization loop - ensure velocity is normalized
	local maxAttempts = 60 -- 3 seconds max
	local attempts = 0
	
	repeat
		attempts = attempts + 1
		
		-- Reset all part velocities
		for _, part in pairs(Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Velocity = Vector3.new(0, 0, 0)
				part.RotVelocity = Vector3.new(0, 0, 0)
				part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			end
		end
		
		-- Get humanoid up
		if Humanoid then
			Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
		
		task.wait(0.05)
		
		-- Check if velocity is normalized
		local currentVelocity = RootPart.Velocity.Magnitude
		local isStable = currentVelocity < 5
		
		if isStable and attempts > 10 then -- Wait at least 0.5 seconds
			break
		end
		
	until attempts >= maxAttempts
	
	-- Final safety check - anchor briefly then unanchor
	RootPart.Anchored = true
	task.wait(0.1)
	RootPart.Anchored = false
	
	-- One more velocity reset
	for _, part in pairs(Character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Velocity = Vector3.new(0, 0, 0)
			part.RotVelocity = Vector3.new(0, 0, 0)
		end
	end
end

-- Monitor for equipped tools and apply physics
local function setupToolMonitor()
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

-- Setup tool monitor on character spawn
Player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	setupToolMonitor()
	if getgenv().flingloop then
		setCharacterPhysics(true)
	end
end)

if Player.Character then
	setupToolMonitor()
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

    local AshFling = function(TargetPlayer)
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
                return
            end
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
                        return
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
                return
            end

            BV:Destroy()
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            workspace.CurrentCamera.CameraSubject = Humanoid

            repeat
                RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                Humanoid:ChangeState("GettingUp")
                table.foreach(Character:GetChildren(), function(_, x)
                    if x:IsA("BasePart") then
                        x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end)
                task.wait()
            until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
            workspace.FallenPartsDestroyHeight = getgenv().FPDH
        else
            return
        end
    end

    if Targets[1] then
        for _, x in next, Targets do
            GetPlayer(x)
        end
    else
        return
    end

    if AllBool then
        for _, x in next, Players:GetPlayers() do
            if x ~= Player then
                AshFling(x)
            end
        end
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

    for _, x in next, Targets do
        local TPlayer = GetPlayer(x)
        if TPlayer and TPlayer ~= Player then
            if x:lower() == "all" then
                for _, player in ipairs(Players:GetPlayers()) do
                    if not WhitelistedUserIDs[player.UserId] then
                        AshFling(player)
                    end
                end
            else
                if not WhitelistedUserIDs[TPlayer.UserId] then
                    AshFling(TPlayer)
                end
            end
        end
    end
end

isFlinging = false
hasStabilized = false

task.spawn(function()
    while not getgenv().AshDestroyed do
        if getgenv().flingloop and not isFlinging then
            isFlinging = true
            hasStabilized = false -- Reset stabilization flag when starting fling
            pcall(flingloopfix)
            isFlinging = false
        elseif not getgenv().flingloop and not hasStabilized then
            -- Stabilize character before restoring physics (only once)
            safelyStabilizeCharacter()
            setCharacterPhysics(false)
            hasStabilized = true
        end
        task.wait(1)
    end
end)
