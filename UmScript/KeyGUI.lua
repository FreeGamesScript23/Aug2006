local Players = game:GetService("Players")
local player = Players.LocalPlayer

local existingGui = player:FindFirstChild("PlayerGui"):FindFirstChild("KeySystemGUI")
if existingGui then
    existingGui:Destroy()
end

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "KeySystemGUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- Create Frame
local Frame = Instance.new("Frame")
Frame.Parent = gui
Frame.BackgroundColor3 = Color3.fromRGB(85, 0, 255)
Frame.BackgroundTransparency = 0.500
Frame.BorderSizePixel = 0
Frame.Size = UDim2.new(0, 376, 0, 256)
Frame.Position = UDim2.new(0.5, -188, 0.5, -128) -- Center of the screen
Frame.ClipsDescendants = true
Frame.Active = true
Frame.Draggable = true

-- Add UICorner to Frame
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = Frame

-- Create Header Frame
local Frame_2 = Instance.new("Frame")
Frame_2.Parent = Frame
Frame_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BackgroundTransparency = 0.800
Frame_2.BorderSizePixel = 0
Frame_2.Size = UDim2.new(1, 0, 0, 29)

-- Create Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "closeButton"
closeButton.Parent = Frame_2
closeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundTransparency = 1.000
closeButton.BorderSizePixel = 0
closeButton.Position = UDim2.new(1, -35, 0, 0)
closeButton.Size = UDim2.new(0, 35, 0, 32)
closeButton.Font = Enum.Font.Ubuntu
closeButton.Text = "x"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 25.000

-- Add UICorner to Close Button
local UICorner_2 = Instance.new("UICorner")
UICorner_2.CornerRadius = UDim.new(0, 5)
UICorner_2.Parent = closeButton

-- Create Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "titleLabel"
titleLabel.Parent = Frame
titleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1.000
titleLabel.Position = UDim2.new(0.237, 0, 0, 0)
titleLabel.Size = UDim2.new(0, 200, 0, 32)
titleLabel.Font = Enum.Font.Ubuntu
titleLabel.Text = "Ashbornn Hub - Key System"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 20.000

-- Create TextBox for Key Entry
local textbox = Instance.new("TextBox")
textbox.Name = "textbox"
textbox.Parent = Frame
textbox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textbox.BackgroundTransparency = 0.500
textbox.BorderSizePixel = 0
textbox.Position = UDim2.new(0, 0, 0.309, 0)
textbox.Size = UDim2.new(1, 0, 0, 37)
textbox.Font = Enum.Font.Ubuntu
textbox.PlaceholderText = "Paste key here"
textbox.Text = ""
textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
textbox.TextSize = 20.000

-- Create Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Name = "getKeyButton"
getKeyButton.Parent = Frame
getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 127)
getKeyButton.BackgroundTransparency = 0.500
getKeyButton.BorderSizePixel = 0
getKeyButton.Position = UDim2.new(0.127, 0, 0.558, 0)
getKeyButton.Size = UDim2.new(0, 113, 0, 55)
getKeyButton.Font = Enum.Font.Ubuntu
getKeyButton.Text = "Get Key"
getKeyButton.TextColor3 = Color3.fromRGB(249, 249, 249)
getKeyButton.TextSize = 20.000

-- Add UICorner to Get Key Button
local UICorner_3 = Instance.new("UICorner")
UICorner_3.CornerRadius = UDim.new(0, 15)
UICorner_3.Parent = getKeyButton

-- Create Check Key Button
local checkKeyButton = Instance.new("TextButton")
checkKeyButton.Name = "checkKeyButton"
checkKeyButton.Parent = Frame
checkKeyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
checkKeyButton.BackgroundTransparency = 0.500
checkKeyButton.BorderSizePixel = 0
checkKeyButton.Position = UDim2.new(0.579, 0, 0.558, 0)
checkKeyButton.Size = UDim2.new(0, 113, 0, 55)
checkKeyButton.Font = Enum.Font.Ubuntu
checkKeyButton.Text = "Check Key"
checkKeyButton.TextColor3 = Color3.fromRGB(249, 249, 249)
checkKeyButton.TextSize = 20.000

-- Add UICorner to Check Key Button
local UICorner_4 = Instance.new("UICorner")
UICorner_4.CornerRadius = UDim.new(0, 15)
UICorner_4.Parent = checkKeyButton

-- Create Discord Button
local discordButton = Instance.new("TextButton")
discordButton.Name = "discordButton"
discordButton.Parent = Frame
discordButton.BackgroundColor3 = Color3.fromRGB(170, 85, 255)
discordButton.BackgroundTransparency = 0.500
discordButton.BorderSizePixel = 0
discordButton.Position = UDim2.new(0.351, 0, 0.851, 0)
discordButton.Size = UDim2.new(0, 113, 0, 31)
discordButton.Font = Enum.Font.Ubuntu
discordButton.Text = "Join Discord"
discordButton.TextColor3 = Color3.fromRGB(249, 249, 249)
discordButton.TextSize = 20.000

-- Add UICorner to Discord Button
local UICorner_5 = Instance.new("UICorner")
UICorner_5.CornerRadius = UDim.new(0, 15)
UICorner_5.Parent = discordButton

-- Create Drop Shadow
local DropShadowHolder = Instance.new("Frame")
DropShadowHolder.Name = "DropShadowHolder"
DropShadowHolder.Parent = Frame
DropShadowHolder.BackgroundTransparency = 1.000
DropShadowHolder.BorderSizePixel = 0
DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
DropShadowHolder.ZIndex = 0

local DropShadow = Instance.new("ImageLabel")
DropShadow.Name = "DropShadow"
DropShadow.Parent = DropShadowHolder
DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow.BackgroundTransparency = 1.000
DropShadow.BorderSizePixel = 0
DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
DropShadow.Size = UDim2.new(1, 47, 1, 47)
DropShadow.ZIndex = 0
DropShadow.Image = "rbxassetid://6014261993"
DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
DropShadow.ImageTransparency = 0.500
DropShadow.ScaleType = Enum.ScaleType.Slice
DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

-- Create Info Labels
local titleLabel_2 = Instance.new("TextLabel")
titleLabel_2.Name = "titleLabel"
titleLabel_2.Parent = Frame
titleLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleLabel_2.BackgroundTransparency = 1.000
titleLabel_2.Position = UDim2.new(0.332, 0, 0.125, 0)
titleLabel_2.Size = UDim2.new(0, 128, 0, 20)
titleLabel_2.Font = Enum.Font.Ubuntu
titleLabel_2.Text = 'Click "Get Key" to copy link then paste to your browser.'
titleLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel_2.TextSize = 15.000

local titleLabel_3 = Instance.new("TextLabel")
titleLabel_3.Name = "titleLabel"
titleLabel_3.Parent = Frame
titleLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleLabel_3.BackgroundTransparency = 1.000
titleLabel_3.Position = UDim2.new(0.327, 0, 0.203, 0)
titleLabel_3.Size = UDim2.new(0, 128, 0, 20)
titleLabel_3.Font = Enum.Font.Ubuntu
titleLabel_3.Text = "It contains a lot of ads to support the script developer."
titleLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel_3.TextSize = 10.000

local titleLabel_4 = Instance.new("TextLabel")
titleLabel_4.Name = "titleLabel"
titleLabel_4.Parent = Frame
titleLabel_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleLabel_4.BackgroundTransparency = 1.000
titleLabel_4.Position = UDim2.new(0.333, 0, 0.461, 0)
titleLabel_4.Size = UDim2.new(0, 128, 0, 20)
titleLabel_4.Font = Enum.Font.Ubuntu
titleLabel_4.Text = "⚠ Also, do not download anything for your safety. ⚠"
titleLabel_4.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel_4.TextSize = 10.000

-- Return GUI Components
return {
    gui = gui,
    closeButton = closeButton,
    getKeyButton = getKeyButton,
    checkKeyButton = checkKeyButton,
    discordButton = discordButton,
    textbox = textbox,
    titleLabel = titleLabel,
    titleLabel_2 = titleLabel_2
}
