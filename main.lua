-- Miuhub (MiuHub) by Miu
-- ⚠️ For learning purpose only

-- // Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/miur1/Library/refs/heads/main/Library.lua'))()

-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- // Utility Function
local function getCharParts()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if root and humanoid then
        return char, root, humanoid
    end
end

-- // Variables
local JumpEnabled = false
local JumpValue = 50

-- // Window
local Window = Rayfield:CreateWindow({
    Name = "MiuHub",
    Icon = 78684919697778,
    LoadingTitle = "Welcome to GraceHub",
    LoadingSubtitle = "By Miu",
    ShowText = "MiuHub",
    Theme = "Amethyst",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = false,
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "Big Hub"
    },
    KeySystem = false,
})

-- 🏠 HOME TAB
local PlayerTab = Window:CreateTab("🏠Home🏠")
PlayerTab:CreateSection("Main")

-- WALK SPEED SYSTEM
local SpeedEnabled = false
local SpeedValue = 16
local DefaultSpeed = 16

local WalkSpeedSlider = PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        SpeedValue = Value
        if SpeedEnabled then
            local _, _, humanoid = getCharParts()
            if humanoid then
                humanoid.WalkSpeed = SpeedValue
            end
        end
    end
})

local WalkSpeedToggle = PlayerTab:CreateToggle({
    Name = "Enable WalkSpeed",
    CurrentValue = false,
    Flag = "WalkSpeedToggle",
    Callback = function(Value)
        SpeedEnabled = Value
        local _, _, humanoid = getCharParts()
        if humanoid then
            if Value then
                humanoid.WalkSpeed = SpeedValue
            else
                humanoid.WalkSpeed = DefaultSpeed
            end
        end
    end
})

RunService.Heartbeat:Connect(function()
    if SpeedEnabled then
        local _, _, humanoid = getCharParts()
        if humanoid and humanoid.WalkSpeed ~= SpeedValue then
            humanoid.WalkSpeed = SpeedValue
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = SpeedEnabled and SpeedValue or DefaultSpeed
    end
end)

--Jump Power System
local JumpSlider = PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 500},
    Increment = 10,
    Suffix = "Jump",
    CurrentValue = 50,
    Flag = "SliderJump",
    Callback = function(Value)
        JumpValue = Value
        local _, _, humanoid = getCharParts()
        if humanoid and JumpEnabled then
            humanoid.JumpPower = Value
        end
    end,
})

local JumpToggle = PlayerTab:CreateToggle({
    Name = "Enable Jump",
    CurrentValue = false,
    Flag = "ToggleJump",
    Callback = function(Value)
        JumpEnabled = Value
        local _, _, humanoid = getCharParts()
        if humanoid then
            humanoid.JumpPower = Value and JumpValue or 50
        end
    end,
})

RunService.Heartbeat:Connect(function()
    if JumpEnabled then
        local _, _, humanoid = getCharParts()
        if humanoid and humanoid.JumpPower ~= JumpValue then
            humanoid.JumpPower = JumpValue
        end
    end
end)


--Fly
local FlyEnabled = false
local FlySpeed = 60

local bv, bg
local FlyUp = 0
local FlyDown = 0


local Function startFly()
    local char, root, humanoid = getCharPartsO()
    if not (char and root and humanoid) then return end

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bg.Velocity = Vector3.zero
    bv.Parent = root

    bg = instace.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.P = 9e4
    bg.CFrame = root.CFrame
    bg.parent = root

    humanoid.PlatformStand = true end

local function stopFly()
    if bv thrn bv:Destroy() bv = nil end
    if bg thrn bg:Destroy() bv = nil end

    local _, _, humanoid = getCharParts()
    if humanoid thrn humanoid.PlatformStand = false
    end
end

local FlyToggle = PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        FlyEnabled = Value
        if FlyEnabled then
            startFly()
        else
            stopfly()
        end
    end
})
 
PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {20, 200},
    Increment = 5,
    Suffix = "Fly",
    CurrentValue = FlySpeed,
    Flag = "FlySpeed",
    Callback = function(Value)
        FlySpeed = Value
    end,
})

local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Space then
        flyUp = 1
    elseif input.KeyCode == Enum.KeyCode.LeftControl then
        flyDown = 1
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        flyUp = 0
    elseif input.KeyCode == Enum.KeyCode.LeftControl then
        flyDown = 0
    end
end)

RunService.RenderStepped:Connect(function()
    if FlyEnabled and bv and bg then
        local char, root, humanoid = getCharParts()
        if not (char and root and humanoid) then return end

        local cam = workspace.CurrentCamera
        local moveDir = humanoid.MoveDirection
        local vertical = Vector3.new(0, flyUp - flyDown, 0)

        bv.Velocity = (cam.CFrame:VectorToWorldSpace(moveDir) + vertical) * FlySpeed
        bg.CFrame = cam.CFrame
    end
end)

player.CharacterAdded:Connect(function()
    FlyEnabled = false
    stopFly()
end)

-- 🛠️ MISC TAB (ESP)
local EspTab = Window:CreateTab("🛠️Misc🛠️")
EspTab:CreateSection("Player ESP")


local localPlayer = Players.LocalPlayer
local nameTags = {}
local showNameTags = false

local function setNameTagsVisible(state)
    showNameTags = state
    for _, gui in pairs(nameTags) do
        if gui and gui:IsA("BillboardGui") then
            gui.Enabled = state
        end
    end
end

local function createNameTag(player)
    if player == localPlayer then return end
    if not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if not head then return end

    if nameTags[player] then
        nameTags[player]:Destroy()
        nameTags[player] = nil
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NameTag"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 70)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = showNameTags
    billboard.Parent = head

    local layout = Instance.new("UIListLayout")
    layout.Parent = billboard
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 15)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextScaled = false
    nameLabel.TextSize = 16
    nameLabel.Text = "[" .. player.Name .. "]"
    nameLabel.Parent = billboard

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0, 20)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.fromRGB(0, 200, 0)
    healthLabel.TextStrokeTransparency = 0.5
    healthLabel.Font = Enum.Font.SourceSansBold
    healthLabel.TextScaled = false
    healthLabel.TextSize = 16
    healthLabel.Text = "[Hp: 0]"
    healthLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0, 20)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    distanceLabel.TextStrokeTransparency = 0.5
    distanceLabel.Font = Enum.Font.SourceSansBold
    distanceLabel.TextScaled = false
    distanceLabel.TextSize = 16
    distanceLabel.Text = "[Jarak: 0 m]"
    distanceLabel.Parent = billboard

    nameTags[player] = billboard

    RunService.Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            healthLabel.Text = string.format("[Hp: %d]", math.floor(humanoid.Health))
        end
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
            local meter = math.floor(dist * 0.28)
            distanceLabel.Text = "[Jarak: ".. meter.."m]"
        end
    end)
end

local function removeNameTag(player)
    if nameTags[player] then
        nameTags[player]:Destroy()
        nameTags[player] = nil
    end
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        createNameTag(player)
    end)
    if player.Character then
        createNameTag(player)
    end
end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= localPlayer then
        onPlayerAdded(p)
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(removeNameTag)

EspTab:CreateToggle({
    Name = "Esp Player",
    CurrentValue = false,
    Flag = "EspPlayer",
    Callback = function(Value)
        setNameTagsVisible(Value)
    end
})
