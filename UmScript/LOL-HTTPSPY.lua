local functions = {
    rconsoleprint,
    print,
    setclipboard,
    rconsoleerr,
    rconsolewarn,
    warn,
    error
}

-- Patterns to match Discord webhook URLs and raw.githubusercontent URLs
local patterns = {
    "https://discord.com/api/webhooks/",
    "https://raw.githubusercontent.com/"
}

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

if _G.ID then
    while true do
    end
end

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
