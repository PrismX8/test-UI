-- ui_script.lua

local function createUI()
    -- Create a simple UI with tabs and buttons
    local ui = {
        tabs = {},
        buttons = {}
    }

    -- Function to add a tab
    function ui:addTab(tabName)
        table.insert(self.tabs, tabName)
        print("Added tab: " .. tabName)
    end

    -- Function to add a button to a specific tab
    function ui:addButton(tabName, buttonName)
        if not self.buttons[tabName] then
            self.buttons[tabName] = {}
        end
        table.insert(self.buttons[tabName], buttonName)
        print("Added button '" .. buttonName .. "' to tab '" .. tabName .. "'")
    end

    -- Function to display the UI
    function ui:display()
        print("\n--- UI Display ---")
        for _, tab in ipairs(self.tabs) do
            print("Tab: " .. tab)
            if self.buttons[tab] then
                for _, button in ipairs(self.buttons[tab]) do
                    print("  Button: " .. button)
                end
            end
        end
    end

    return ui
end

return createUI()
