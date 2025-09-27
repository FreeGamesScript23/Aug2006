-- GuiToLuaAPI.luau
-- Converts any ScreenGui (and descendants) into Lua code with full properties

local HttpService = game:GetService("HttpService")

-- Fetch API dump once
local function fetchApiDump()
    local dumpRes = request({
        Url = "https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/refs/heads/roblox/API-Dump.json",
        Method = "GET"
    })
    return HttpService:JSONDecode(dumpRes.Body)
end

local Data = fetchApiDump()
local rawClasses = Data.Classes

local Classes = {}
for _, class in ipairs(rawClasses) do
    if class.Tags and (table.find(class.Tags,"NotCreatable") or table.find(class.Tags,"NotScriptable")) then
        -- skip un-creatable classes
    else
        local tab = {}
        local sup = class.Name
        while sup do
            local sc
            for _, c2 in ipairs(rawClasses) do
                if c2.Name == sup then sc = c2 break end
            end
            if not sc then break end
            for _, member in ipairs(sc.Members) do
                if member.MemberType == "Property" then
                    local sec = member.Security
                    local skip = false
                    if type(sec) == "string" and sec ~= "None" then skip = true end
                    if type(sec) == "table" and (sec.Read ~= "None" or sec.Write ~= "None") then skip = true end
                    if not skip then
                        if not member.Tags or (not table.find(member.Tags,"ReadOnly") and not table.find(member.Tags,"Hidden") and not table.find(member.Tags,"Deprecated")) then
                            tab[member.Name] = true
                        end
                    end
                end
            end
            sup = sc.Superclass
        end
        Classes[class.Name] = tab
    end
end

-- whitelist UI classes only
local UIWhitelist = {
    ScreenGui=true, Frame=true, TextLabel=true, TextButton=true,
    ImageLabel=true, ImageButton=true, UIListLayout=true, UIGridLayout=true,
    UIPadding=true, UICorner=true, UIGradient=true, UIScale=true,
    ScrollingFrame=true, ViewportFrame=true, CanvasGroup=true, VideoFrame=true,
    UIAspectRatioConstraint=true, UISizeConstraint=true
}

-- serialize values
local function formatValue(val)
    if val == nil then return "nil" end
    local t = typeof(val)
    if t == "string" then return string.format("%q", val)
    elseif t == "number" or t == "boolean" then return tostring(val)
    elseif t == "Vector2" then return ("Vector2.new(%g,%g)"):format(val.X,val.Y)
    elseif t == "Vector3" then return ("Vector3.new(%g,%g,%g)"):format(val.X,val.Y,val.Z)
    elseif t == "UDim" then return ("UDim.new(%g,%d)"):format(val.Scale,val.Offset)
    elseif t == "UDim2" then return ("UDim2.new(%g,%d,%g,%d)"):format(val.X.Scale,val.X.Offset,val.Y.Scale,val.Y.Offset)
    elseif t == "CFrame" then local c={val:GetComponents()} return ("CFrame.new(%s)"):format(table.concat(c,","))
    elseif t == "Color3" then return ("Color3.fromRGB(%d,%d,%d)"):format(val.R*255,val.G*255,val.B*255)
    elseif t == "EnumItem" then return tostring(val)
    elseif t == "Rect" then return ("Rect.new(%g,%g,%g,%g)"):format(val.Min.X,val.Min.Y,val.Max.X,val.Max.Y)
    elseif t == "NumberRange" then return ("NumberRange.new(%g,%g)"):format(val.Min,val.Max)
    elseif t == "NumberSequence" then
        local pts={} for _,kp in ipairs(val.Keypoints) do
            table.insert(pts, ("NumberSequenceKeypoint.new(%g,%g,%g)"):format(kp.Time,kp.Value,kp.Envelope))
        end return "NumberSequence.new({"..table.concat(pts,",").."})"
    elseif t == "ColorSequence" then
        local pts={} for _,kp in ipairs(val.Keypoints) do
            table.insert(pts, ("ColorSequenceKeypoint.new(%g,Color3.fromRGB(%d,%d,%d))"):format(
                kp.Time,kp.Value.R*255,kp.Value.G*255,kp.Value.B*255))
        end return "ColorSequence.new({"..table.concat(pts,",").."})"
    elseif t == "Font" then
        local weight = "Enum.FontWeight."..tostring(val.Weight):match("%w+$")
        local style = "Enum.FontStyle."..tostring(val.Style):match("%w+$")
        return ("Font.new(%q,%s,%s)"):format(val.Family, weight, style)
    elseif t == "FontFace" then
        return ("Font.new(%q)"):format(val.Family)
    end
    return "nil"
end

-- serializer
local counter = 0
local function nextKey() counter += 1 return tostring(counter) end

local function serializeGui(inst, parentVar, path, depth)
    if not UIWhitelist[inst.ClassName] then return {} end
    local key = nextKey()
    local var = 'ASH["'..key..'"]'
    local lines = {}
    local indent = string.rep("    ", depth or 0)

    table.insert(lines, indent.."-- "..(path or inst.Name))
    table.insert(lines, indent..var..' = Instance.new("'..inst.ClassName..'",'..parentVar..")")

    local propsMap = Classes[inst.ClassName] or {}
    for propName,_ in pairs(propsMap) do
        local ok,val = pcall(function() return inst[propName] end)
        if ok then
            local fv = formatValue(val)
            if fv ~= "nil" then
                table.insert(lines, indent..var..'["'..propName..'"] = '..fv)
            end
        end
    end

    for _,child in ipairs(inst:GetChildren()) do
        for _,l in ipairs(serializeGui(child, var, (path and path.."."..child.Name) or child.Name, (depth or 0)+1)) do
            table.insert(lines,l)
        end
    end
    return lines
end

-- exported API
local function GuiToLua(gui: Instance): string
    counter = 0
    local code = {"local ASH = {}"}
    local body = serializeGui(gui, "game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui')", gui.Name, 0)
    for _, l in ipairs(body) do table.insert(code, l) end
    table.insert(code, 'return ASH["1"]')
    local result = table.concat(code,"\n")
    if setclipboard then setclipboard(result) end
    return result
end

return {
    GuiToLua = GuiToLua
}
