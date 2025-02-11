-- ESP Toggleable Script
local ESP_ENABLED = false  -- Initial state (ESP is OFF)
local ESP_COLOR = Color3.fromRGB(255, 0, 0) -- Red color for ESP
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- UI Button (Assumes ESPButton exists in UI)
local ESPButton = script.Parent -- Adjust this if needed

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

-- Function to enable ESP
local function enableESP()
    for _, player in ipairs(Players:GetPlayers()) do
        createESP(player)
    end
    print("[ESP] Enabled")
end

-- Function to disable ESP
local function disableESP()
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

-- Toggle ESP function
local function toggleESP()
    ESP_ENABLED = not ESP_ENABLED

    if ESP_ENABLED then
        enableESP()
    else
        disableESP()
    end

    -- Update UI Button
    ESPButton.Text = ESP_ENABLED and "👁️ ESP: ON" or "👁️ ESP: OFF"
    ESPButton.BackgroundColor3 = ESP_ENABLED and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
end

-- Detect new players joining
Players.PlayerAdded:Connect(createESP)

-- Toggle ESP with 'E' key
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.E then
        toggleESP()
    end
end)

-- Toggle ESP with UI Button
ESPButton.MouseButton1Click:Connect(toggleESP)

-- Ensure ESP re-applies after respawn
LocalPlayer.CharacterAdded:Connect(function()
    wait(1) -- Small delay for character loading
    if ESP_ENABLED then
        enableESP()
    end
end)

print("[ESP Script] Press 'E' or Click Button to toggle ESP")
