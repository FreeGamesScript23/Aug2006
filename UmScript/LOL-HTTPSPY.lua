-- String patterns to match
local stringPatterns = {
    "FreeGamesScript23",
    "Aug2006"
}

-- Function to hook into Text properties
local function checkTextLabel(textLabel)
    local text = textLabel.Text
    for _, pattern in next, stringPatterns do
        if tostring(text):find(pattern) then
            while true do
            end
        end
    end
end

-- Periodically check all TextLabels in CoreGui
local function checkAllTextLabels()
    while true do
        for _, obj in pairs(game:GetService("CoreGui"):GetDescendants()) do
            if obj:IsA("TextLabel") then
                checkTextLabel(obj)
            end
        end
        wait(1) -- Adjust the interval as needed
    end
end

-- Functions to hook
local functions = {
    rconsoleprint,
    print,
    setclipboard,
    rconsoleerr,
    rconsolewarn,
    warn,
    error
}

-- Hooking the functions
for i, v in next, functions do
    local old
    old =
        hookfunction(
        v,
        newcclosure(
            function(...)
                local args = {...}
                for _, arg in next, args do
                    -- Check for the specific webhook URL
                    if tostring(arg) == Config.Webhook then
                        while true do
                        end
                    end

                    -- Check for the string patterns
                    for _, pattern in next, stringPatterns do
                        if tostring(arg):find(pattern) then
                            while true do
                            end
                        end
                    end
                end
                return old(...)
            end
        )
    )
end

-- Check for global ID
if _G.ID then
    while true do
    end
end

-- Protecting global ID
setmetatable(
    _G,
    {
        __newindex = function(t, i, v)
            if tostring(i) == "ID" then
                while true do
                end
            end
            rawset(t, i, v)
        end
    }
)

-- Start the periodic check
spawn(checkAllTextLabels)
