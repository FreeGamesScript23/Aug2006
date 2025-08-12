local httpService = game:GetService("HttpService")

local InterfaceManager = {
    Folder = "FluentSettings",
    Settings = {
        Theme = "Dark",
        Acrylic = true,
        Transparency = true,
        MenuKeybind = "LeftControl",
    },
}

-- Sets the folder path and builds the folder structure
function InterfaceManager:SetFolder(folder)
    self.Folder = folder
    self:BuildFolderTree()
end

-- Associates a library with the InterfaceManager
function InterfaceManager:SetLibrary(library)
    self.Library = library
end

-- Creates the required folder structure
function InterfaceManager:BuildFolderTree()
    local paths = {}
    for idx = 1, #self.Folder:split("/") do
        table.insert(paths, table.concat(self.Folder:split("/"), "/", 1, idx))
    end

    table.insert(paths, self.Folder)
    table.insert(paths, self.Folder .. "/settings")

    for _, path in ipairs(paths) do
        if not isfolder(path) then
            makefolder(path)
        end
    end
end

-- Saves settings to a JSON file
function InterfaceManager:SaveSettings()
    local success, encoded = pcall(httpService.JSONEncode, httpService, self.Settings)
    if success then
        writefile(self.Folder .. "/options.json", encoded)
    else
        warn("Failed to encode settings")
    end
end

-- Loads settings from a JSON file
function InterfaceManager:LoadSettings()
    local path = self.Folder .. "/options.json"
    if isfile(path) then
        local data = readfile(path)
        local success, decoded = pcall(httpService.JSONDecode, httpService, data)
        if success then
            for key, value in pairs(decoded) do
                self.Settings[key] = value
            end
        else
            warn("Failed to decode settings")
        end
    end
end

-- Builds the interface configuration section
function InterfaceManager:BuildInterfaceSection(tab)
    assert(self.Library, "Library is not set")

    local Library = self.Library
    local Settings = self.Settings

    self:LoadSettings()

    local section = tab:AddSection("Interface")

    -- Theme dropdown
    local themeDropdown = section:AddDropdown("InterfaceTheme", {
        Title = "Theme",
        Description = "Changes the interface theme.",
        Values = Library.Themes,
        Default = Settings.Theme,
        Callback = function(value)
            Library:SetTheme(value)
            Settings.Theme = value
            self:SaveSettings()
        end,
    })
    themeDropdown:SetValue(Settings.Theme)

    -- Acrylic toggle
    if Library.UseAcrylic then
        section:AddToggle("AcrylicToggle", {
            Title = "Acrylic",
            Description = "The blurred background requires graphic quality 8+",
            Default = Settings.Acrylic,
            Callback = function(value)
                Library:ToggleAcrylic(value)
                Settings.Acrylic = value
                self:SaveSettings()
            end,
        })
    end

    -- Transparency toggle
    section:AddToggle("TransparentToggle", {
        Title = "Transparency",
        Description = "Makes the interface transparent.",
        Default = Settings.Transparency,
        Callback = function(value)
            Library:ToggleTransparency(value)
            Settings.Transparency = value
            self:SaveSettings()
        end,
    })

    -- Menu keybind
    local menuKeybind = section:AddKeybind("MenuKeybind", {
        Title = "Minimize Bind",
        Default = Settings.MenuKeybind,
    })
    menuKeybind:OnChanged(function()
        Settings.MenuKeybind = menuKeybind.Value
        self:SaveSettings()
    end)
    Library.MinimizeKeybind = menuKeybind
end

return InterfaceManager
