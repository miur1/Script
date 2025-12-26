-- Miuhub is only for learning, so don't misuse it.
-- Script by Miu
-- Library by Rayfield



-- library
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/miureals/Library/refs/heads/main/Library.lua"))()

local JumpEnabled = false
local JumpValue = 50


-- window
local Window = Rayfield:CreateWindow({
    Name = "MiuHub",
    Icon = 126331734300608,
    LoadingTitle = "Wellcome To A Miuhub",
    LoadingSubtitle = "This Script only for a learn",
    LoadingSubtitle = "By Miu",
    ShowText = "MiuHub",
    Theme = "Ocean",
    ToggleUIKeybind = "K", -- key open script for Pc
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
        
-- save Configuration 
    ConfigurationSaving = {
      Enabled = false,
      FolderName = MiuHub, -- Create folder for your hub/game
      FileName = "Big Hub"
   },

-- for key sistem (if you want use key for your script change to true in "KeySystem")
    KeySystem = true,
    KeySettings = {
        Title = "miuhub Key, this only lerning",
        Subtitle = "Key System",
        Note = "get in that link",
        FileName = "Key",
        SaveKey = nil,
        GrabKeyFromSite = true,
        Key = "https://pastebin.com/raw/7gRS3EBh"
    }
})

Rayfield:Notify({
   Title = "MiuHub it sucks",
   Content = "Fuck up miu hub",
   Duration = 3,
   Image = nil,
})

local PlayerTab = Window:CreateTab("🏠Home🏠")
local section = PlayerTab:CreateSection("Main")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local SpeedValue = 16
local SpeedEnabled = false
local SmoothFactor = 10 -- nilai smoothing (semakin besar makin responsif)

-- UI
local WalkSpeedSlider = PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = SpeedValue,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        SpeedValue = Value
    end
})

local WalkSpeedToggle = PlayerTab:CreateToggle({
    Name = "Enable WalkSpeed",
    CurrentValue = false,
    Flag = "WalkSpeedToggle",
    Callback = function(Value)
        SpeedEnabled = Value
    end
})

-- ambil bagian karakter
local function getCharParts()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if root and humanoid then
        return char, root, humanoid
    end
end

local velocity = Vector3.zero

-- loop utama
RunService.RenderStepped:Connect(function(dt)
    if not SpeedEnabled then
        velocity = Vector3.zero
        return
    end

    local char, root, humanoid = getCharParts()
    if not (char and root and humanoid) then return end

    local moveDir = humanoid.MoveDirection
    if moveDir.Magnitude > 0 then
        local targetVelocity = moveDir.Unit * SpeedValue
        velocity = velocity:Lerp(targetVelocity, math.clamp(SmoothFactor * dt, 0, 1))
    else
        velocity = velocity:Lerp(Vector3.zero, math.clamp(SmoothFactor * dt * 1.5, 0, 1))
    end

    -- update posisi player
    root.CFrame = root.CFrame + (velocity * dt)
end)

-- reset velocity saat respawn
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    char:WaitForChild("Humanoid")
    velocity = Vector3.zero
end)

-- Jump
local JumpSlider = PlayerTab:CreateSlider({
    Name = "Jump",
    Range = {50, 500},
    Increment = 10,
    Suffix = "Jump",
    CurrentValue = 50,
    Flag = "Slider2",
    Callback = function(Value)
        JumpValue = Value
        local _, _, humanoid = getCharParts()
        if humanoid then
            pcall(function() humanoid.JumpPower = Value end)
        end
    end
})

local JumpToggle = PlayerTab:CreateToggle({
    Name = "Enable Jump",
    CurrentValue = false,
    Flag = "ToggleJump",
    Callback = function(Value)
        JumpEnabled = Value
        local _, _, humanoid = getCharParts()
        if humanoid then
            if Value then
                pcall(function() humanoid.JumpPower = JumpValue end)
            else
                pcall(function() humanoid.JumpPower = 50 end)
            end
        end
    end
})

RunService.Heartbeat:Connect(function()
    if JumpEnabled then
        local _, _, humanoid = getCharParts()
        if humanoid then
	a		a	            pcall(function() humanoid.JumpPower = JumpValue end)
        end
    end
end)

-- ESP TAB
local EspTab = Window:CreateTab("🛠️Misc🛠️")
local SectionMisc = EspTab:CreateSection("Misc")

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
    nameLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextScaled = false
    nameLabel.TextSize = 16
    nameLabel.Text = "[" .. player.Name .. "]"
    nameLabel.Parent = billboard

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0, 20)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.fromRGB(180, 0, 255)
    healthLabel.TextStrokeTransparency = 0.5
    healthLabel.Font = Enum.Font.SourceSansBold
    healthLabel.TextScaled = false
    healthLabel.TextSize = 16
    healthLabel.Text = "[Hp: 0]"
    healthLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0, 20)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
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

local testTab = Window:CreateTab("Bloxfruit Its Sucks")
local test = testTab:CreateSection("test")
local Toggle = testTab:CreateToggle({
   Name = "Toggle Test",
   CurrentValue = false,
   Flag = "test", 
   Callback = function(Value)
            
   end,
})

local play = testTab:CreateSection("main")
local lier = testTab:CreateSlider({
   Name = "Slider Example",
   Range = {0, 100},
   Increment = 10,
   Suffix = "Bananas",
   CurrentValue = 10,
   Flag = "dh", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   -- The function that takes place when the slider changes
   -- The variable (Value) is a number which correlates to the value the slider is currently at
   end,
})
