local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function createESPGui(character, player)
    if not character or not character:FindFirstChild("Head") then return end
    if character.Head:FindFirstChild("ESP_Billboard") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Adornee = character.Head
    billboard.Size = UDim2.new(0, 120, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = character.Head

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1) -- Weiß
    label.TextStrokeTransparency = 0.6
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansSemibold
    label.Text = player.Name
    label.Parent = billboard

    local function updateHealth()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            label.Text = player.Name .. " | " .. math.floor(humanoid.Health)
        end
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:GetPropertyChangedSignal("Health"):Connect(updateHealth)
        updateHealth()
    end
end

local function addHighlight(character)
    if character:FindFirstChild("ESP_Highlight") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.4
    highlight.OutlineTransparency = 0.2
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = character
    highlight.Parent = character
end

local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            createESPGui(player.Character, player)
            addHighlight(player.Character)
        end
    end
end

-- Alle 1 Sekunden neu updaten
while true do
    task.wait(1)
    pcall(updateESP)
end
-- GAY
