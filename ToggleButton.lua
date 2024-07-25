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
button.BackgroundTransparency = 0.3 -- Set transparency to 50%
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
local function setDraggable(draggable)
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
local function toggleButtonVisibility(visible)
    button.Visible = visible
end

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
