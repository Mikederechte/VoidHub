--[[

██╗   ██╗ ██████╗ ██╗██████╗ ██╗  ██╗██╗   ██╗██████╗     ███████╗ ██████╗██████╗ ██████╗ ██╗████████╗███████╗
██║   ██║██╔═══██╗██║██╔══██╗██║  ██║██║   ██║██╔══██╗    ██╔════╝██╔════╝██╔══██╗██╔══██╗██║╚══██╔══╝██╔════╝
██║   ██║██║   ██║██║██║  ██║███████║██║   ██║██████╔╝    ███████╗██║     ██████╔╝██████╔╝██║   ██║   ███████╗
╚██╗ ██╔╝██║   ██║██║██║  ██║██╔══██║██║   ██║██╔══██╗    ╚════██║██║     ██╔══██╗██╔═══╝ ██║   ██║   ╚════██║
 ╚████╔╝ ╚██████╔╝██║██████╔╝██║  ██║╚██████╔╝██████╔╝    ███████║╚██████╗██║  ██║██║     ██║   ██║   ███████║
  ╚═══╝   ╚═════╝ ╚═╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═════╝     ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚══════╝
                                                                                                              
 
]]



local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Rayfield-Window
local Window = Rayfield:CreateWindow({
    Name = "VoidHub",
    LoadingTitle = "VoidHub Scripts",
    LoadingSubtitle = "by Mikerandom",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "VoidHubData",
        FileName = "Config"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false,
    ToggleUIKeybind = Enum.KeyCode.G -- GUI Toggle mit G
})

-- Tab für Spielerfunktionen
local PlayerTab = Window:CreateTab("Utilities", 4483362458)

-- ESP Toggle
local espEnabled = false
local espLoop

PlayerTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "esp",
    Callback = function(Value)
        espEnabled = Value

        if espEnabled then
            espLoop = RunService.Heartbeat:Connect(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                        -- GUI
                        if not player.Character.Head:FindFirstChild("ESP_Billboard") then
                            local billboard = Instance.new("BillboardGui")
                            billboard.Name = "ESP_Billboard"
                            billboard.Adornee = player.Character.Head
                            billboard.Size = UDim2.new(0, 120, 0, 20)
                            billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                            billboard.AlwaysOnTop = true
                            billboard.Parent = player.Character.Head

                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextColor3 = Color3.new(1, 1, 1)
                            label.TextScaled = true
                            label.Font = Enum.Font.SourceSans
                            label.Text = player.Name
                            label.Parent = billboard

                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                                    label.Text = player.Name .. " | " .. math.floor(humanoid.Health)
                                end)
                                label.Text = player.Name .. " | " .. math.floor(humanoid.Health)
                            end
                        end

                        -- Highlight
                        if not player.Character:FindFirstChild("ESP_Highlight") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "ESP_Highlight"
                            highlight.FillColor = Color3.fromRGB(255, 0, 0)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.4
                            highlight.OutlineTransparency = 0.2
                            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            highlight.Adornee = player.Character
                            highlight.Parent = player.Character
                        end
                    end
                end
            end)
        else
            if espLoop then espLoop:Disconnect() end
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    if head and head:FindFirstChild("ESP_Billboard") then
                        head.ESP_Billboard:Destroy()
                    end
                    local highlight = player.Character:FindFirstChild("ESP_Highlight")
                    if highlight then
                        highlight:Destroy()
                    end
                end
            end
        end
    end
})

-- Click TP Toggle
local clickTPEnabled = false
local inputConnection = nil

local function notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Click TP",
            Text = text,
            Duration = 2,
        })
    end)
end

local function teleportToMouse()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local target = Mouse.Hit
        if target then
            character:MoveTo(target.Position + Vector3.new(0, 5, 0))
            notify("Teleport erfolgreich!")
        end
    end
end

local ctrlHeld = false

local function enableClickTP()
    notify("Click TP aktiviert! STRG + Linksklick zum Teleportieren.")
    inputConnection = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.LeftControl then
            ctrlHeld = true
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 and ctrlHeld then
            teleportToMouse()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftControl then
            ctrlHeld = false
        end
    end)
end

local function disableClickTP()
    notify("Click TP deaktiviert.")
    if inputConnection then
        inputConnection:Disconnect()
        inputConnection = nil
    end
end

PlayerTab:CreateToggle({
    Name = "Click TP (STRG + LMB)",
    CurrentValue = false,
    Flag = "ClickTP",
    Callback = function(Value)
        clickTPEnabled = Value
        if clickTPEnabled then
            enableClickTP()
        else
            disableClickTP()
        end
    end
})
