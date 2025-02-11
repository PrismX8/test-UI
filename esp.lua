
-- ESP Toggleable Script
local ESP_ENABLED = false  -- Initial state (ESP is OFF)
local ESP_COLOR = Color3.fromRGB(255, 0, 0) -- Red color for ESP
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Function to create ESP for a character
local function createESP(player)
    if player == LocalPlayer then return end -- Ignore local player

    local function applyESP(character)
        if not character then return end
        
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") and not part:FindFirstChild("ESPBox") then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESPBox"
                box.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
                box.Adornee = part
                box.Color3 = ESP_COLOR
                box.Transparency = 0.5
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Parent = part
            end
        end
    end

    -- Apply ESP immediately if character exists
    if player.Character then
        applyESP(player.Character)
    end

    -- Apply ESP when the player respawns
    player.CharacterAdded:Connect(applyESP)
end

-- Function to toggle ESP
local function toggleESP()
    ESP_ENABLED = not ESP_ENABLED

    if ESP_ENABLED then
        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end
        print("[ESP] Enabled")
    else
        -- Remove all ESP boxes
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                for _, part in ipairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        local box = part:FindFirstChild("ESPBox")
                        if box then box:Destroy() end
                    end
                end
            end
        end
        print("[ESP] Disabled")
    end
end

-- Detect new players joining
Players.PlayerAdded:Connect(createESP)

-- Keybind to toggle ESP (Change "E" to your preferred key)
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.E then
        toggleESP()
    end
end)

print("[ESP Script] Press 'E' to toggle ESP")
