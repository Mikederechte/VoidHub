local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ctrlHeld = false

-- Funktion zum Anzeigen einer Benachrichtigung
local function notify(text)
    StarterGui:SetCore("SendNotification", {
        Title = "Click TP",
        Text = text,
        Duration = 2,
    })
end

-- Funktion zum Teleportieren
local function teleportToMouse()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local target = Mouse.Hit
    if target then
        character:MoveTo(target.Position + Vector3.new(0, 5, 0))
        notify("Teleport erfolgreich!")
    end
end

-- Input Handling
UserInputService.InputBegan:Connect(function(input, processed)
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

-- Initiale Benachrichtigung beim Aktivieren des Scripts
notify("Click TP aktiviert! STRG + Linksklick zum Teleportieren.")
