-- Patterns to match Discord webhook URLs and raw.githubusercontent URLs
local patterns = {
    "https://discord.com/api/webhooks/",
    "https://raw.githubusercontent.com/"
}

-- Function to hook into Text properties
local function hookTextLabel(textLabel)
    local oldText = textLabel.Text
    local mt = getrawmetatable(textLabel)
    local oldIndex = mt.__index
    local oldNewIndex = mt.__newindex

    setreadonly(mt, false)

    mt.__index = newcclosure(function(t, k)
        if k == "Text" then
            return oldText
        end
        return oldIndex(t, k)
    end)

    mt.__newindex = newcclosure(function(t, k, v)
        if k == "Text" then
            for _, pattern in next, patterns do
                if tostring(v):find(pattern) then
                    while true do
                    end
                end
            end
            oldText = v
        end
        oldNewIndex(t, k, v)
    end)

    setreadonly(mt, true)
end

-- Hook into existing TextLabels
local function hookAllTextLabels()
    for _, obj in pairs(game:GetService("CoreGui"):GetDescendants()) do
        if obj:IsA("TextLabel") then
            hookTextLabel(obj)
        end
    end
end

-- Hook into newly added TextLabels
game:GetService("CoreGui").DescendantAdded:Connect(function(obj)
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
                    for _, pattern in next, patterns do
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
        end
    }
)
