local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()


local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = game.Players.LocalPlayer
local Player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local N = game:GetService("VirtualInputManager")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")


local Window = Fluent:CreateWindow({
    Title = "AshbornnHub " .. Fluent.Version,
    SubTitle = "BlackHawk Rescue Mission 5",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
        Main = Window:AddTab({ Title = "Main", Icon = "box" }),
        Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
        Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
local Options = Fluent.Options

do

    --------------------------------------------------------------------------------MAIN------------------------------------------------------------------------------------------

        
local discord = "https://discord.com/invite/nzXkxej9wa"


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
            setclipboard(discord)
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end
        
-- Create a ScreenGui object to hold the button
local gui = Instance.new("ScreenGui")
gui.Name = "AshbornnHubGui"
gui.Parent = game.CoreGui

-- Create the button as a TextButton
local button = Instance.new("TextButton")
button.Name = "ToggleButton"
button.Text = "Close" -- Initial text set to "Close"
button.Size = UDim2.new(0, 70, 0, 30) -- Adjust the size as needed
button.Position = UDim2.new(0, 10, 0, 10) -- Position at top left with 10px offset
button.BackgroundTransparency = 0.7 -- Set transparency to 50%
button.BackgroundColor3 = Color3.fromRGB(97, 62, 167) -- Purple background color
button.BorderSizePixel = 2 -- Add black stroke
button.BorderColor3 = Color3.new(0, 0, 0) -- Black stroke color
button.TextColor3 = Color3.new(1, 1, 1) -- White text color
button.FontSize = Enum.FontSize.Size12 -- Adjust text size
button.TextScaled = false -- Allow text to scale with button size
button.TextWrapped = true -- Wrap text if it's too long
button.TextStrokeTransparency = 0 -- Make text fully visible
button.TextStrokeColor3 = Color3.new(0, 0, 0) -- Black text stroke color
button.Parent = gui

-- Apply blur effect
local blur = Instance.new("BlurEffect")
blur.Parent = button
blur.Size = 5 -- Adjust blur size as needed

-- Variable to keep track of button state
local isOpen = false
local isDraggable = false
local dragConnection

-- Functionality for the button
button.MouseButton1Click:Connect(function()
        isOpen = not isOpen -- Toggle button state
        
        if isOpen then
            button.Text = "Open"
        else
            button.Text = "Close"
        end
        
        Window:Minimize()
end)

-- Function to make the button draggable
function setDraggable(draggable)
        if draggable then
            -- Connect events for dragging
            dragConnection = button.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    local dragStart = input.Position
                    local startPos = button.Position
                    local dragInput = input

                    local function onInputChanged(input)
                        if input == dragInput then
                            local delta = input.Position - dragStart
                            button.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                        end
                    end

                    local function onInputEnded(input)
                        if input == dragInput then
                            dragInput = nil
                            game:GetService("UserInputService").InputChanged:Disconnect(onInputChanged)
                            input.Changed:Disconnect(onInputEnded)
                        end
                    end

                    game:GetService("UserInputService").InputChanged:Connect(onInputChanged)
                    input.Changed:Connect(onInputEnded)
                end
            end)
        else
            -- Disconnect events if not draggable
            if dragConnection then
                dragConnection:Disconnect()
                dragConnection = nil -- Reset dragConnection
            end
        end
end

-- Function to toggle button visibility
function toggleButtonVisibility(visible)
        button.Visible = visible
end

Tabs.Settings:AddParagraph({
            Title = "To open Window from Chat just say:",
            Content = "/e ash"
        })


        -- Function to fetch avatar URL using Roblox API
local function fetchAvatarUrl(userId)
    local url = "https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. userId .. "&size=420x420&format=Png&isCircular=false"
    local response = HttpService:JSONDecode(game:HttpGet(url))
    if response and response.data and #response.data > 0 then
        return response.data[1].imageUrl
    else
        return "https://www.example.com/default-avatar.png"  -- Replace with a default avatar URL
    end
    end
    
    -- Fetch avatar URL for LocalPlayer
    local avatarUrl = fetchAvatarUrl(LocalPlayer.UserId)
    
    -- Function to get current timestamp in a specific format
    local function getCurrentTime()
    local hour = tonumber(os.date("!%H", os.time() + 8 * 3600)) -- Convert to Philippine Standard Time (UTC+8)
    local minute = os.date("!%M", os.time() + 8 * 3600)
    local second = os.date("!%S", os.time() + 8 * 3600)
    local day = os.date("!%d", os.time() + 8 * 3600)
    local month = os.date("!%m", os.time() + 8 * 3600)
    local year = os.date("!%Y", os.time() + 8 * 3600)
    
    local suffix = "AM"
    if hour >= 12 then
        suffix = "PM"
        if hour > 12 then
            hour = hour - 12
        end
    elseif hour == 0 then
        hour = 12
    end
    
    return string.format("%02d-%02d-%04d %02d:%02d:%02d %s", month, day, year, hour, minute, second, suffix)
    end
    
    -- Define the Input field for user feedback
    local Input = Tabs.Settings:AddInput("Input", {
    Title = "Send FeedBack",
    Default = "",
    Placeholder = "Send your feedback to Ashbornn",
    Numeric = false, -- Only allows numbers
    Finished = false, -- Only calls callback when you press enter
    Callback = function(Value)
        -- This function can be used for validation or other callback logic if needed
    end
    })
    
    -- Define the function to send feedback to Discord
    local function sendFeedbackToDiscord(feedbackMessage)
    local response = request({
        Url = "https://discord.com/api/webhooks/1255142396639973377/91po7RwMaLiXYgeerK6KCFRab6h20xHy_WepLYJvIjcTxiv_kwAyJBa9DnPDJjc0F-ga",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode({
            embeds = {{
                title = LocalPlayer.Name .. " (" .. LocalPlayer.UserId .. ")",
                description = "Hi " .. LocalPlayer.Name .. " Send a Feedback! in " .. Ash_Device,
                color = 16711935,
                footer = { text = "Timestamp: " .. getCurrentTime() },
                author = { name = "User Send a Feedback in \nGame Place:\n" .. GameName .. " (" .. game.PlaceId .. ")" },  -- Replace with actual identification method
                fields = {
                    { name = "Feedback: ", value = feedbackMessage, inline = true }
                },
                thumbnail = {
                    url = avatarUrl
                }
            }}
        })
    })
    
    if response and response.StatusCode == 204 then
        SendNotif("Feedback has been sent to Ashbornn", "Thank you", 3)
    else
        warn("Failed to send feedback to Discord:", response)
    end
    end
    
    -- Define a variable to track the last time feedback was sent
    local lastFeedbackTime = 0
    local cooldownDuration = 60  -- Cooldown period in seconds (1 minute)
    
    -- Function to check if enough time has passed since last feedback
    local function canSendFeedback()
    local currentTime = os.time()
    return (currentTime - lastFeedbackTime >= cooldownDuration)
    end
    
    -- Update lastFeedbackTime after sending feedback
    local function updateLastFeedbackTime()
    lastFeedbackTime = os.time()
    end
    
    -- Define the button to send feedback
    Tabs.Settings:AddButton({
    Title = "Send FeedBack",
    Description = "Tap to Send",
    Callback = function()
        if not canSendFeedback() then
            SendNotif("You cant spam this message", "Try again Later Lol", 3)
            return
        end
        
        local feedbackMessage = Input.Value  -- Get the value directly from Input
        
        -- Check if feedbackMessage is non-empty before sending
        if feedbackMessage and feedbackMessage ~= "" then
            sendFeedbackToDiscord(feedbackMessage)
            updateLastFeedbackTime()  -- Update cooldown timestamp
        else
            SendNotif("You cant send empty feedback loll", "Try again later", 3)
        end
    end
    })
    


-- Create the toggle for draggable button
local DraggableToggle = Tabs.Settings:AddToggle("Draggable Button", {Title = "Draggable Button", Default = false})

DraggableToggle:OnChanged(function(value)
        isDraggable = value
        setDraggable(isDraggable)
end)

-- Create another toggle for button visibility
local VisibilityToggle = Tabs.Settings:AddToggle("Button Visibility", {Title = "Toggle Window Visibility", Default = true})

VisibilityToggle:OnChanged(function(value)
        toggleButtonVisibility(value)
end)
        

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("AshbornnHub")
SaveManager:SetFolder("AshbornnHub/MM2")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()

local TimeEnd = tick()
local TotalTime = string.format("%.2f", math.abs(TimeStart - TimeEnd))
SendNotif("AshbornnHub", "Successfully loaded the script in " .. TotalTime .. "s.", 3)
