-- ESP Toggleable Script (Disable and Re-enable every 1 second)
local ESP_ENABLED = false -- Initial state (ESP is OFF)
local ESP_COLOR = Color3.fromRGB(255, 0, 0) -- Red color for ESP
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- UI Button (Assumes ESPButton exists in UI)
local ESPButton = script.Parent -- Adjust if needed

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

-- Function to enable ESP
local function enableESP()
    for _, player in ipairs(Players:GetPlayers()) do
        createESP(player)
    end
    print("[ESP] Enabled")
end

-- Detect new players joining
Players.PlayerAdded:Connect(createESP)

-- Disable and Re-enable ESP every second
task.spawn(function()
    while true do
        wait(1)  -- Every 1 second
        disableESP()  -- Disable ESP
        wait(0.01)  -- Wait for 1 second before re-enabling
        enableESP()  -- Re-enable ESP
    end
end)

-- Toggle ESP with UI Button (Only turns ON when clicked)
ESPButton.MouseButton1Click:Connect(function()
    enableESP()
    ESPButton.Text = "👁️ ESP: ON"
    ESPButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
end)

print("[ESP Script] ESP will be disabled and re-enabled every second")
