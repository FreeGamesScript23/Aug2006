local httpService = game:GetService("HttpService")

local SaveManager = {} do
    SaveManager.Folder = "FluentSettings"
    SaveManager.Ignore = {}
    SaveManager.Parser = {
        Toggle = {
            Save = function(idx, object) 
                return { type = "Toggle", idx = idx, value = object.Value } 
            end,
            Load = function(idx, data)
                SaveManager.Options[idx]:SetValue(data.value)
            end,
        },
        Slider = {
            Save = function(idx, object)
                return { type = "Slider", idx = idx, value = tostring(object.Value) }
            end,
            Load = function(idx, data)
                SaveManager.Options[idx]:SetValue(data.value)
            end,
        },
        Dropdown = {
            Save = function(idx, object)
                return { type = "Dropdown", idx = idx, value = object.Value, multi = object.Multi }
            end,
            Load = function(idx, data)
                SaveManager.Options[idx]:SetValue(data.value)
            end,
        },
        Colorpicker = {
            Save = function(idx, object)
                return { type = "Colorpicker", idx = idx, value = object.Value:ToHex(), transparency = object.Transparency }
            end,
            Load = function(idx, data)
                SaveManager.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
            end,
        },
        Keybind = {
            Save = function(idx, object)
                return { type = "Keybind", idx = idx, mode = object.Mode, key = object.Value }
            end,
            Load = function(idx, data)
                SaveManager.Options[idx]:SetValue(data.key, data.mode)
            end,
        },
        Input = {
            Save = function(idx, object)
                return { type = "Input", idx = idx, text = object.Value }
            end,
            Load = function(idx, data)
                if type(data.text) == "string" then
                    SaveManager.Options[idx]:SetValue(data.text)
                end
            end,
        },
    }

    function SaveManager:SetIgnoreIndexes(list)
        for _, key in ipairs(list) do
            self.Ignore[key] = true
        end
    end

    function SaveManager:SetFolder(folder)
        self.Folder = folder
        self:BuildFolderTree()
    end

    function SaveManager:Save(name)
        if not name then
            return false, "No config file selected"
        end

        local fullPath = self.Folder .. "/settings/" .. name .. ".json"
        local data = { objects = {} }

        for idx, option in pairs(self.Options) do
            if self.Parser[option.Type] and not self.Ignore[idx] then
                table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
            end
        end

        local success, encoded = pcall(httpService.JSONEncode, httpService, data)
        if not success then
            return false, "Failed to encode data"
        end

        writefile(fullPath, encoded)
        return true
    end

    function SaveManager:Load(name)
        if not name then
            return false, "No config file selected"
        end

        local file = self.Folder .. "/settings/" .. name .. ".json"
        if not isfile(file) then
            return false, "Invalid file"
        end

        local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
        if not success then
            return false, "Decode error"
        end

        for _, option in ipairs(decoded.objects) do
            if self.Parser[option.type] then
                task.spawn(function() self.Parser[option.type].Load(option.idx, option) end)
            end
        end

        return true
    end

    function SaveManager:IgnoreThemeSettings()
        self:SetIgnoreIndexes({ "InterfaceTheme", "AcrylicToggle", "TransparentToggle", "MenuKeybind" })
    end

    function SaveManager:BuildFolderTree()
        for _, path in ipairs({ self.Folder, self.Folder .. "/settings" }) do
            if not isfolder(path) then
                makefolder(path)
            end
        end
    end

    function SaveManager:RefreshConfigList()
        local out = {}
        for _, file in ipairs(listfiles(self.Folder .. "/settings")) do
            if file:sub(-5) == ".json" then
                local name = file:match("([^/\\]+)%.json$")
                if name and name ~= "options" then
                    table.insert(out, name)
                end
            end
        end
        return out
    end

    function SaveManager:SetLibrary(library)
        self.Library = library
        self.Options = library.Options
    end

    function SaveManager:LoadAutoloadConfig()
        local autoloadFile = self.Folder .. "/settings/autoload.txt"
        if isfile(autoloadFile) then
            local name = readfile(autoloadFile)
            local success, err = self:Load(name)

            self.Library:Notify({
                Title = "Interface",
                Content = "Config loader",
                SubContent = success and ("Auto loaded config " .. name) or ("Failed to load autoload config: " .. err),
                Duration = 7
            })
        end
    end

    function SaveManager:BuildConfigSection(tab)
        assert(self.Library, "Must set SaveManager.Library")

        local section = tab:AddSection("Configuration")

        section:AddInput("SaveManager_ConfigName", { Title = "Config name" })
        section:AddDropdown("SaveManager_ConfigList", { Title = "Config list", Values = self:RefreshConfigList(), AllowNull = true })

        local function notify(title, subContent)
            self.Library:Notify({
                Title = "Interface",
                Content = "Config loader",
                SubContent = subContent,
                Duration = 7
            })
        end

        section:AddButton({
            Title = "Create config",
            Callback = function()
                local name = self.Options.SaveManager_ConfigName.Value
                if name:match("^%s*$") then
                    return notify("Interface", "Invalid config name (empty)")
                end

                local success, err = self:Save(name)
                notify("Interface", success and ("Created config " .. name) or ("Failed to save config: " .. err))
                self.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
            end
        })

        section:AddButton({
            Title = "Load config",
            Callback = function()
                local name = self.Options.SaveManager_ConfigList.Value
                local success, err = self:Load(name)
                notify("Interface", success and ("Loaded config " .. name) or ("Failed to load config: " .. err))
            end
        })

        section:AddButton({
            Title = "Overwrite config",
            Callback = function()
                local name = self.Options.SaveManager_ConfigList.Value
                local success, err = self:Save(name)
                notify("Interface", success and ("Overwrote config " .. name) or ("Failed to overwrite config: " .. err))
            end
        })

        section:AddButton({
            Title = "Refresh list",
            Callback = function()
                self.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
            end
        })

        local AutoloadButton = section:AddButton({
            Title = "Set as autoload",
            Description = "Current autoload config: none",
            Callback = function()
                local name = self.Options.SaveManager_ConfigList.Value
                writefile(self.Folder .. "/settings/autoload.txt", name)
                AutoloadButton:SetDesc("Current autoload config: " .. name)
                notify("Interface", "Set " .. name .. " to auto load")
            end
        })

        local autoloadFile = self.Folder .. "/settings/autoload.txt"
        if isfile(autoloadFile) then
            AutoloadButton:SetDesc("Current autoload config: " .. readfile(autoloadFile))
        end

        self:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })
    end

    SaveManager:BuildFolderTree()
end

return SaveManager
