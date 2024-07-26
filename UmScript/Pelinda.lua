local S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11 = "a", "s", "h", "b", "o", "r", "n", "n", "h", "u", "b"
local ServiceID = S1..S2..S3..S4..S5..S6..S7..S8..S9..S10..S11

-- Load external libraries
local function loadLibrary(url)
    local success, library = pcall(loadstring(game:HttpGet(url)))
    if not success then
        error("Failed to load library from URL: " .. url .. " - " .. library)
    end
    return library
end

local PandaAuth = loadLibrary('https://raw.githubusercontent.com/Panda-Repositories/PandaKS_Libraries/main/library/LuaLib/ROBLOX/PandaBetaLib.lua')
local Fluent = loadLibrary("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua")

-- Load KeyGUI.lua and handle errors
local function loadKeyGUI()
    local success, result = pcall(loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/UmScript/KeyGUI.lua", true)))
    if not success then
        error("Failed to load KeyGUI.lua: " .. result)
    end
    return result
end

local KeyGUI = loadKeyGUI()

-- Check if KeyGUI is a function or table
if type(KeyGUI) == "function" then
    KeyGUI = KeyGUI() -- Call the function to get the GUI instance
elseif type(KeyGUI) == "table" then
    -- If KeyGUI is a table, ensure it has the expected fields

else
    error("KeyGUI is neither a function nor a table")
end

local AshGUI = KeyGUI

-- Notification function
function SendNotif(title, content, duration)
    Fluent:Notify({
        Title = title,
        Content = content,
        Duration = duration
    })
end

-- File operations
local function saveKey(key)
    local success, errorMsg = pcall(function() writefile("AshbornnHub/saved_key.txt", key) end)
    if not success then
        error("Failed to save key: " .. errorMsg)
    end
end

local function loadKey()
    local success, keyOrError = pcall(readfile, "AshbornnHub/saved_key.txt")
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
    local success, errorMsg = pcall(function() writefile("AshbornnHub/saved_key.txt", "") end)
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
    SendNotif("Hub", "Key copied to clipboard", 2)
end)

AshGUI.checkKeyButton.MouseButton1Click:Connect(function()
    local key = AshGUI.textbox.Text
    if key == "" then
        SendNotif("AshbornnHub", "Please enter a key", 2)
        return
    end
    
    SendNotif("Authenticating...", "Checking your key, please wait.", 2)

    if PandaAuth:ValidateKey(ServiceID, key) or PandaAuth:ValidatePremiumKey(ServiceID, key) then
        SendNotif("Hub", "Authenticated", 2)
        saveKey(key)
        destroyUI()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/AshMain.lua", true))()
    else
        SendNotif("Hub", "Not authenticated", 2)
    end
end)

AshGUI.discordButton.MouseButton1Click:Connect(function()
    setclipboard("https://discord.com/invite/JzkvpnVVA7")
    SendNotif("Hub", "Discord invite copied to clipboard", 2)
end)

-- Attempt to load the saved key
local savedKey = loadKey()
if savedKey then
    SendNotif("Hub", "Checking saved key", 2)
    if PandaAuth:ValidateKey(ServiceID, savedKey) or PandaAuth:ValidatePremiumKey(ServiceID, savedKey) then
        SendNotif("Hub", "Authenticated with saved key", 2)
        destroyUI()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/AshMain.lua", true))()
    else
        SendNotif("Hub", "Saved key not valid", 2)
        resetKey()
    end
end

-- (Additional) You can loop the Keyless Mode too
while true do
    if PandaAuth:Authenticate_Keyless(ServiceID) then
        destroyUI()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/AshMain.lua", true))()
        break -- Exit the loop if authorization is successful
    else
        warn('Hardware ID not Successfully Authorized')
    end  
    wait(5) -- Pause execution for 5 seconds before the next iteration
end   
