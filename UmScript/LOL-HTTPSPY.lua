-- String patterns to match
local stringPatterns = {
    "FreeGamesScript23",
    "Aug2006"
}

-- Function to check TextLabel content
local function checkTextLabelContent(textLabel)
    local text = textLabel.Text
    for _, pattern in next, stringPatterns do
        if tostring(text):find(pattern) then
            while true do
            end
        end
    end
end

-- Function to hook into TextLabel objects
local function hookTextLabel(textLabel)
    checkTextLabelContent(textLabel)  -- Check initial content

    local mt = getrawmetatable(textLabel)
    local oldNewIndex = mt.__newindex

    setreadonly(mt, false)

    mt.__newindex = newcclosure(function(t, k, v)
        if k == "Text" then
            for _, pattern in next, stringPatterns do
                if tostring(v):find(pattern) then
                    while true do
                    end
                end
            end
        end
        oldNewIndex(t, k, v)
    end)

    setreadonly(mt, true)
end

-- Hook all existing TextLabels
local function hookAllTextLabels()
    for _, obj in pairs(game:GetService("CoreGui"):GetDescendants()) do
        if obj:IsA("TextLabel") then
            hookTextLabel(obj)
        end
    end

    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("TextLabel") then
            hookTextLabel(obj)
        end
    end
end

-- Hook newly added TextLabels
game:GetService("CoreGui").DescendantAdded:Connect(function(obj)
    if obj:IsA("TextLabel") then
        hookTextLabel(obj)
    end
end)

game.DescendantAdded:Connect(function(obj)
    if obj:IsA("TextLabel") then
        hookTextLabel(obj)
    end
end)

-- Initial hooking
hookAllTextLabels()

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
