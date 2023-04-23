
local repo = 'https://raw.githubusercontent.com/xQuartyx/UILibrary/main/LinoriaLib/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Zps Hub',
    Center = true, 
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab('Main'), 
}

local Tabsz = {
    Mainz = Window:AddTab('Setting'), 
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Main')

LeftGroupBox:AddToggle('MyToggle', {
    Text = 'Auto Click',
    Default = false, -- Default value (true / false)
    Tooltip = 'Auto Click', -- Information shown when you hover over the toggle
})

Toggles.MyToggle:OnChanged(function(z)
_G.AutoClick = z
end)

        spawn(function()
            while wait() do
                if _G.AutoClick then
                    pcall(function()

                                            game:GetService'VirtualUser':CaptureController()
                                            game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                end)
                end
        end
        end)

local LeftGroupBox1 = Tabsz.Mainz:AddLeftGroupbox('Setting')

LeftGroupBox1:AddLabel('Ui Setting'):AddKeyPicker('KeyPicker', {
    -- SyncToggleState only works with toggles. 
    -- It allows you to make a keybind which has its state synced with its parent toggle

    -- Example: Keybind which you use to toggle flyhack, etc.
    -- Changing the toggle disables the keybind state and toggling the keybind switches the toggle state

    Default = "RightControl", -- String as the name of the keybind (MB1, MB2 for mouse buttons)  
    SyncToggleState = false, 


    -- You can define custom Modes but I have never had a use for it.
    Mode = 'Toggle', -- Modes: Always, Toggle, Hold

    Text = 'Ui Open / OFF', -- Text to display in the keybind menu
    NoUI = false, -- Set to true if you want to hide from the Keybind menu,
})

-- OnClick is only fired when you press the keybind and the mode is Toggle
-- Otherwise, you will have to use Keybind:GetState()
Options.KeyPicker:OnClick(function()
    print('Keybind clicked!', Options.KeyPicker.Value)
end)

task.spawn(function()
    while true do
        wait(1)

        -- example for checking if a keybind is being pressed
        local state = Options.KeyPicker:GetState()
        if state then
            print('KeyPicker is being held down')
        end

        if Library.Unloaded then break end
    end
end)

Options.KeyPicker:SetValue({ 'RightControl', 'Toggle' }) -- Sets keybind to MB2, mode to Hold

-- Library functions
-- Sets the watermark visibility
Library:SetWatermarkVisibility(true)

-- Sets the watermark text
Library:SetWatermark('Zps Hub Developer Thiên#0001 Skider')

Library.KeybindFrame.Visible = true; -- todo: add a function for this

Library:OnUnload(function()
    print('Unloaded!')
    Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

-- I set NoUI so it does not show up in the keybinds menu
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' }) 

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings() 
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' }) 
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs['UI Settings']) 

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs['UI Settings'])
