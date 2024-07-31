local ServiceID = string.char(
    97, 115, 104, 98, 111, 114, 110, 110, 104, 117, 98
)
local PandaAuth = loadstring(game:HttpGet('https://raw.githubusercontent.com/Panda-Repositories/PandaKS_Libraries/main/library/LuaLib/ROBLOX/PandaBetaLib.lua'))()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local AshDirect = string.char(
    65, 115, 104, 98, 111, 114, 110, 110, 72, 117, 98, 47, 115, 97, 118, 101, 100, 95, 107, 101, 121, 46, 116, 120, 116
)

local Valid = false
function loadScript()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/AshMainLite.lua", true))()
end

-- Load KeyGUI.lua with error handling
local function loadKeyGUI()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/UmScript/KeyGUI.lua", true))()
    end)
    if not success then
        error("Failed to load KeyGUI.lua: " .. result)
    end
    return result
end

local KeyGUI = loadKeyGUI()

-- Check if KeyGUI is a function or table and handle accordingly
local AshGUI
if type(KeyGUI) == "function" then
    AshGUI = KeyGUI() -- Call the function to get the GUI instance
elseif type(KeyGUI) == "table" then
    AshGUI = KeyGUI
else
    error("KeyGUI is neither a function nor a table")
end

local titleLabel = KeyGUI.titleLabel

-- Function to update the title label text
local function updateTitleLabel(newText)
    if titleLabel then
        titleLabel.Text = newText
    end
end

local lol = string.char(
    65, 115, 104, 98, 111, 114, 110, 110, 72, 117, 98, 32, 45, 32, 
    75, 101, 121, 32, 83, 121, 115, 116, 101, 109
)

local lollit = string.char(
    65, 115, 104, 98, 111, 114, 110, 110, 72, 117, 98, 32, 76, 105, 116, 101, 32, 45, 32, 
    75, 101, 121, 32, 83, 121, 115, 116, 101, 109
)

updateTitleLabel(lollit)


-- Function to send notifications
function SendNotif(content, duration)
    local duration = tonumber(duration)
    if not duration or duration <= 0 then
        warn("Invalid duration value. Expected a positive number.")
        return
    end

    Fluent:Notify({
        Title = string.char(65, 115, 104, 98, 111, 114, 110, 110, 72, 117, 98),
        Content = content,
        Duration = duration
    })
end

-- Function to destroy the UI
function destroyUI()
    if AshGUI and AshGUI.gui and AshGUI.gui.Parent then
        AshGUI.gui:Destroy()
    end
end

-- Function to handle key validation
function validateKey(key)
    local isRegularKeyValid = PandaAuth:ValidateKey(ServiceID, key)
    local isPremiumKeyValid = PandaAuth:ValidatePremiumKey(ServiceID, key)

    -- Check regular key validation
    if isRegularKeyValid then
        print("Regular Key Authenticated")
        Valid = true
    else
        print("Regular Key Not Authenticated")
    end  

    -- Check premium key validation
    if isPremiumKeyValid then
        print("Premium Key Authenticated")
        Valid = true
    else
        print("Premium Key Not Authenticated")
    end

    -- Set Validated based on either validation being successful
    Validated = isRegularKeyValid or isPremiumKeyValid
end

-- GUI setup
AshGUI.closeButton.MouseButton1Click:Connect(function()
    destroyUI()
end)

AshGUI.getKeyButton.MouseButton1Click:Connect(function()
    setclipboard(PandaAuth:GetKey(ServiceID))
    SendNotif("Key copied to clipboard", 2)
end)

AshGUI.checkKeyButton.MouseButton1Click:Connect(function()
	SendNotif("Authenticating...", 2)
    local key = AshGUI.textbox.Text
    if key == "" then
        SendNotif("Please enter a key", 2)
        return
    end

    validateKey(key) -- Call validateKey to perform all checks

    if Validated then
        -- Write the key to file and check if it's not nil
        local success, errorMessage = pcall(function()
            writefile("AshbornnHub/saved_key.txt", key)
        end)

        if success then
            SendNotif("Checking last key", 2)
        else
            SendNotif("Failed to save key: " .. errorMessage, 2)
        end
        
        destroyUI()
        loadScript()
    else
        SendNotif("Authentication failed", 2)
    end
end)

AshGUI.discordButton.MouseButton1Click:Connect(function()
    setclipboard("https://discord.com/invite/nzXkxej9wa")
    SendNotif("Discord invite copied to clipboard", 2)
end)

-- Attempt to load the saved key
function loadKey()
    local success, keyOrError = pcall(readfile, AshDirect)
    if success and keyOrError and keyOrError ~= "" then
        return keyOrError
    else
        return nil
    end
end

local savedKey = loadKey()
if savedKey then
    SendNotif("Checking last key", 2)

    validateKey(savedKey) -- Validate the saved key

    if Validated then
        destroyUI()
        loadScript()
    else
        SendNotif("Saved key is invalid", 2)
        -- Clear the invalid key
        pcall(function()
            writefile(AshDirect, "")
        end)
    end
else
end

-- Keyless Mode
while not Valid do
    SendNotif("Checking for keyless authorization", 2)
    
    -- Perform keyless authentication
    if PandaAuth:Authenticate_Keyless(ServiceID) then
        SendNotif("Successfully Authorized in Keyless Mode", 2)
        destroyUI()
        loadScript()
        Valid = true
    else
        warn('Hardware ID not Successfully Authorized')
    end

    wait(5) -- Pause execution for 5 seconds before the next iteration
end
