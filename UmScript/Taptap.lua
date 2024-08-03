local button = game:GetService("Players").LocalPlayer.PlayerGui.DeviceSelect.Container.Phone.Button

-- Define the events you want to fire
local events = {"MouseButton1Click", "MouseButton1Down", "Activated"}

function TapUI(button, check, button2)
    if check == "Active Check" then
        if button.Active then
            button = button[button2]
        else
            return
        end
    end
    if check == "Text Check" then
        if button == "^" then
            button = button2
        else
            return
        end
    end
    for i,v in pairs(events) do
        for i,v in pairs(getconnections(button[v])) do
            v:Fire()
        end
    end
end

-- Call the function to tap the button
TapUI(button)
