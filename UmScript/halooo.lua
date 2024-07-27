-- Encrypt the directory path "/saved_key.txt"
local S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20, S21, S22 = 
    65, 115, 104, 98, 111, 114, 110, 110, 72, 117, 98, 47, 115, 97, 118, 101, 100, 95, 107, 101, 121, 46, 116, 120, 116
local Directory = string.char(S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20, S21, S22)

-- Function to load and execute a script from a URL
function loadscript()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/AshMain.lua",true))()
end

-- Decrypt the string ""
local S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11 = "a", "s", "h", "b", "o", "r", "n", "n", "h", "u", "b"
local ServiceID = S1 .. S2 .. S3 .. S4 .. S5 .. S6 .. S7 .. S8 .. S9 .. S10 .. S11

-- Load external libraries with error handling
local function loadLibrary(url)
    local success, library = pcall(loadstring(game:HttpGet(url)))
    if not success then
        error("Failed to load library from URL: " .. url .. " - " .. library)
    end
    return library
end

local PandaAuth = loadLibrary('https://raw.githubusercontent.com/Panda-Repositories/PandaKS_Libraries/main/library/LuaLib/ROBLOX/PandaBetaLib.lua')
local Fluent = loadLibrary("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua")

-- Load KeyGUI.lua with error handling
local function loadKeyGUI()
    local success, result = pcall(loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/UmScript/KeyGUI.lua", true)))
    if not success then
        error("Failed to load KeyGUI.lua: " .. result)
    end
    return result
end

local KeyGUI = loadKeyGUI()

-- Check if KeyGUI is a function or table and handle accordingly
if type(KeyGUI) == "function" then
    KeyGUI = KeyGUI() -- Call the function to get the GUI instance
elseif type(KeyGUI) == "table" then
    -- If KeyGUI is a table, ensure it has the expected fields
else
    error("KeyGUI is neither a function nor a table")
end

local AshGUI = KeyGUI

-- Notification function
function SendNotif(content, duration)
    Fluent:Notify({
        Title = string.char(65, 115, 104, 98, 111, 114, 110, 110, 72, 117, 98, 98), -- ""
        Content = content or "No content provided",
        Duration = duration or 3 -- Default to 3 seconds
    })
end


-- File operations with encrypted path
local function saveKey(key)
    local success, errorMsg = pcall(function() writefile(Directory, key) end)
    if not success then
        error("Failed to save key: " .. errorMsg)
    end
end

local function loadKey()
    local success, keyOrError = pcall(readfile, Directory)
    if success and keyOrError then
        return keyOrError
    else
        return nil
    end
end

-- Access the ScreenGui instance
local screenGui = AshGUI.gui
if not screenGui then
    error("ScreenGui not found in KeyGUI.lua")
end

-- Function to destroy the UI
local function destroyUI()
    if screenGui and screenGui.Parent then
        screenGui:Destroy()
    end
end

-- Function to reset the key
local function resetKey()
    local success, errorMsg = pcall(function() writefile(Directory, "") end)
    if not success then
        error("Failed to reset key: " .. errorMsg)
    end
end

-- Connect button events
AshGUI.closeButton.MouseButton1Click:Connect(function()
    destroyUI()
end)

AshGUI.getKeyButton.MouseButton1Click:Connect(function()
    setclipboard(PandaAuth:GetKey(ServiceID))
    SendNotif("Key copied to clipboard", 2)
end)

AshGUI.checkKeyButton.MouseButton1Click:Connect(function()
    local key = AshGUI.textbox.Text
    if key == "" then
        SendNotif("Please enter a key", 2)
        return
    end
    
    SendNotif("Authenticating...", "Checking your key, please wait.", 2)

    -- Implement the new validation checks
    local PandaAuth = loadstring(game:HttpGet("https://raw.githubusercontent.com/Panda-Repositories/PandaKS_Libraries/main/library/LuaLib/ROBLOX/VAL", true))()
    local InternalTable = {
        Service = ServiceID,
        APIToken = "(YjhH38CIa4ZZVLvf)",
        VigenereKey = tostring(game:GetService('Workspace')["GetServerTimeNow" .. string.rep("\0", math.random(2, 32))](game:GetService('Workspace')) + math.random(os.clock(), 999999999 or os.time())) .. string.rep("\0", math.random(2, 32) % os.time() + os.clock()),
        TrueEndpoint = tostring(game:GetService('Workspace')["GetServerTimeNow" .. string.rep("\0", math.random(2, 32))](game:GetService('Workspace')) + math.random(os.clock(), 999999999 or os.time())) .. string.rep("\0", math.random(2, 32) % os.time() + os.clock()),
        FalseEndpoint = tostring(game:GetService('Workspace')["GetServerTimeNow" .. string.rep("\0", math.random(2, 32))](game:GetService('Workspace')) + math.random(os.clock(), 999999999 or os.time())) .. string.rep("\0", math.random(2, 32) % os.time() + os.clock()),
        Webhook = nil,
        Debug = false
    }

    local Internal = setmetatable({}, {
        __index = function(self, key)
            return rawget(InternalTable, key)
        end,
        __newindex = function(self, key, value)
            while true do end; repeat until false; print(debug.traceback()) return
        end,
        __tostring = function(self)
            while true do end; repeat until false; print(debug.traceback()) return
        end
    })

    PandaAuth:SetInternal(Internal)

    -- Validate Start
    local result = PandaAuth:ValidateKey(isfile(Directory) and readfile(Directory) or Directory)
    local Crypt = PandaAuth:GetInternal().Crypt
    local SyncTrue = Crypt:EncryptC(Crypt:SHA256(Internal.TrueEndpoint, Internal.VigenereKey, nil, nil), Internal.VigenereKey, nil)

    if result and result["KEY"] and result["ENV"] == getfenv(1) and result["Raw"] == Internal.TrueEndpoint and result["Encry"] == SyncTrue and type(result["Premium"]) == "boolean" and PandaAuth.Validated[1] == Internal.TrueEndpoint and PandaAuth.Validated[2] == true then
        writefile(Directory, result["KEY"])
        print("Key is valid:")
        print("Is key premium: " .. result["Premium"])
        saveKey(key)
        SendNotif("Authenticated, Enjoy the Script 🥰", 3)
        destroyUI()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/AshMain.lua", true))()
    elseif result and result["Raw"] == Internal.FalseEndpoint and PandaAuth.Validated[1] == Internal.FalseEndpoint and PandaAuth.Validated[2] == false then
        print("Key is invalid.")
        SendNotif("Not authenticated", 2)
    else
        while true do end -- Infinite loop to halt execution if validation fails
    end
end)

AshGUI.discordButton.MouseButton1Click:Connect(function()
    setclipboard("https://discord.com/invite/JzkvpnnVVA7")
    SendNotif("Discord invite copied to clipboard", 2)
end)

-- Attempt to load the saved key
local savedKey = loadKey()
if savedKey then
    SendNotif("Checking saved key", 2)

    local PandaAuth = loadstring(game:HttpGet("https://raw.githubusercontent.com/Panda-Repositories/PandaKS_Libraries/main/library/LuaLib/ROBLOX/VAL", true))()
    local InternalTable = {
        Service = ServiceID,
        APIToken = "(YjhH38CIa4ZZVLvf)",
        VigenereKey = tostring(game:GetService('Workspace')["GetServerTimeNow" .. string.rep("\0", math.random(2, 32))](game:GetService('Workspace')) + math.random(os.clock(), 999999999 or os.time())) .. string.rep("\0", math.random(2, 32) % os.time() + os.clock()),
        TrueEndpoint = tostring(game:GetService('Workspace')["GetServerTimeNow" .. string.rep("\0", math.random(2, 32))](game:GetService('Workspace')) + math.random(os.clock(), 999999999 or os.time())) .. string.rep("\0", math.random(2, 32) % os.time() + os.clock()),
        FalseEndpoint = tostring(game:GetService('Workspace')["GetServerTimeNow" .. string.rep("\0", math.random(2, 32))](game:GetService('Workspace')) + math.random(os.clock(), 999999999 or os.time())) .. string.rep("\0", math.random(2, 32) % os.time() + os.clock()),
        Webhook = nil,
        Debug = false
    }

    local Internal = setmetatable({}, {
        __index = function(self, key)
            return rawget(InternalTable, key)
        end,
        __newindex = function(self, key, value)
            while true do end; repeat until false; print(debug.traceback()) return
        end,
        __tostring = function(self)
            while true do end; repeat until false; print(debug.traceback()) return
        end
    })

    PandaAuth:SetInternal(Internal)

    -- Validate Start
    local result = PandaAuth:ValidateKey(isfile(Directory) and readfile(Directory) or Directory)
    local Crypt = PandaAuth:GetInternal().Crypt
    local SyncTrue = Crypt:EncryptC(Crypt:SHA256(Internal.TrueEndpoint, Internal.VigenereKey, nil, nil), Internal.VigenereKey, nil)

    if result and result["KEY"] and result["ENV"] == getfenv(1) and result["Raw"] == Internal.TrueEndpoint and result["Encry"] == SyncTrue and type(result["Premium"]) == "boolean" and PandaAuth.Validated[1] == Internal.TrueEndpoint and PandaAuth.Validated[2] == true then
        writefile(Directory, result["KEY"])
        print("Key is valid:")
        print("Is key premium: " .. result["Premium"])
        destroyUI()
        loadscript()
    elseif result and result["Raw"] == Internal.FalseEndpoint and PandaAuth.Validated[1] == Internal.FalseEndpoint and PandaAuth.Validated[2] == false then
        
        resetKey()
    else
        while true do end -- Infinite loop to halt execution if validation fails
    end
end

-- Keyless Mode
while true do
    SendNotif("Checking for key", 2)
    if PandaAuth:Authenticate_Keyless(ServiceID) then
        destroyUI()
        loadscript()
        break -- Exit the loop if authorization is successful
    else
        warn('Hardware ID not Successfully Authorized')
    end  
    wait(5) -- Pause execution for 5 seconds before the next iteration
end
