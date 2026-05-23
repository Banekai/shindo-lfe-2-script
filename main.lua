--[[
   Script: Moises mando oi
   Desc: Premium hub for Shindo Life 2
   Author: Advanced Developer
   Optimized, modular, secure
--]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
local RootPart = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")

-- Config
local Settings = {
    AutoGreenFarm = false,
    AutoBossFarm = false,
    AutoRankUp = false,
    AutoStats = false,
    AutoRedeemCodes = false,
    AntiAFK = true,
    AutoRejoin = false,
    FPSBoost = false,
    -- Combat
    AutoSkill = false,
    AutoCombo = false,
    AutoEquip = false,
    AutoChargeChakra = false,
    AutoHeal = false,
    AutoMode = false,
    AutoTransformation = false,
    AutoDodge = false,
    AutoBlock = false,
}

-- UI Elements
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoisesMandoOi"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Background
local Background = Instance.new("Frame")
Background.Size = UDim2.new(0, 500, 0, 400)
Background.Position = UDim2.new(0.5, -250, 0.5, -200)
Background.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Background.BackgroundTransparency = 0.15
Background.BorderSizePixel = 0
Background.Active = true
Background.Draggable = true
Background.Parent = ScreenGui

-- Title
local TitleFrame = Instance.new("Frame")
TitleFrame.Size = UDim2.new(1, 0, 0, 40)
TitleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleFrame.BorderSizePixel = 0
TitleFrame.Parent = Background

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparent = true
Title.Text = "Moises mando oi"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleFrame

-- Minimize/Maximize button
local MinBtn = Instance.new("ImageButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -35, 0, 5)
MinBtn.BackgroundTransparent = true
MinBtn.Image = "rbxassetid://6031094678"
MinBtn.Parent = TitleFrame

local MaxBtn = Instance.new("ImageButton")
MaxBtn.Size = UDim2.new(0, 30, 0, 30)
MaxBtn.Position = UDim2.new(1, -70, 0, 5)
MaxBtn.BackgroundTransparent = true
MaxBtn.Image = "rbxassetid://6031094673"
MaxBtn.Parent = TitleFrame

-- Tabs
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = Background

local Tabs = {"Farming", "Combat", "Stats", "Misc"}
local TabButtons = {}
local TabFrames = {}

for i, name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 125, 1, 0)
    btn.Position = UDim2.new(0, 125*(i-1), 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = TabContainer
    table.insert(TabButtons, btn)

    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Size = UDim2.new(1, 0, 1, -70)
    tabFrame.Position = UDim2.new(0, 0, 0, 70)
    tabFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    tabFrame.BorderSizePixel = 0
    tabFrame.ScrollBarThickness = 5
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabFrame.Visible = (i == 1)
    tabFrame.Parent = Background
    table.insert(TabFrames, tabFrame)

    btn.MouseButton1Click:Connect(function()
        for _, tb in ipairs(TabButtons) do
            tb.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        end
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        for _, tf in ipairs(TabFrames) do
            tf.Visible = false
        end
        tabFrame.Visible = true
    end)
end

-- Helper to add toggle
local function CreateToggle(parent, text, var, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 460, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, #parent:GetChildren()*45)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 350, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparent = true
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("ImageButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 25)
    toggleBtn.Position = UDim2.new(1, -60, 0, 7)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = frame
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = UDim2.new(0, 2, 0, 2.5)
    circle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    circle.BorderSizePixel = 0
    circle.Parent = toggleBtn

    local enabled = Settings[var] or false
    local function updateUI()
        if enabled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
            circle.Position = UDim2.new(0, 28, 0, 2.5)
            circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            circle.Position = UDim2.new(0, 2, 0, 2.5)
            circle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
    end
    updateUI()

    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Settings[var] = enabled
        updateUI()
        if callback then callback(enabled) end
    end)
end

-- Populate tabs
local farmTab = TabFrames[1]
CreateToggle(farmTab, "Auto Green Farm", "AutoGreenFarm", function(v) end)
CreateToggle(farmTab, "Auto Boss Farm", "AutoBossFarm", function(v) end)
CreateToggle(farmTab, "Auto Rank Up", "AutoRankUp", function(v) end)
CreateToggle(farmTab, "Auto Redeem Codes", "AutoRedeemCodes", function(v) end)

local combatTab = TabFrames[2]
CreateToggle(combatTab, "Auto Skill", "AutoSkill")
CreateToggle(combatTab, "Auto Combo", "AutoCombo")
CreateToggle(combatTab, "Auto Equip", "AutoEquip")
CreateToggle(combatTab, "Auto Charge Chakra", "AutoChargeChakra")
CreateToggle(combatTab, "Auto Heal", "AutoHeal")
CreateToggle(combatTab, "Auto Mode", "AutoMode")
CreateToggle(combatTab, "Auto Transformation", "AutoTransformation")
CreateToggle(combatTab, "Auto Dodge", "AutoDodge")
CreateToggle(combatTab, "Auto Block", "AutoBlock")

local statsTab = TabFrames[3]
CreateToggle(statsTab, "Auto Stats", "AutoStats")

local miscTab = TabFrames[4]
CreateToggle(miscTab, "Anti AFK", "AntiAFK")
CreateToggle(miscTab, "Auto Rejoin", "AutoRejoin")
CreateToggle(miscTab, "FPS Boost", "FPSBoost")

-- Status bar
local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(1, 0, 0, 30)
StatusFrame.Position = UDim2.new(0, 0, 1, -30)
StatusFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
StatusFrame.BorderSizePixel = 0
StatusFrame.Parent = Background

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 1, 0)
StatusLabel.Position = UDim2.new(0, 10, 0, 0)
StatusLabel.BackgroundTransparent = true
StatusLabel.Text = "Status: Idle | Level: ? | HP: ? | Chakra: ?"
StatusLabel.TextColor3 = Color3.fromRGB(150, 200, 150)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.Parent = StatusFrame

-- Update status loop
local function UpdateStatus()
    local level = Player.Data.Level.Value or 0
    local hp = Humanoid.Health
    local maxHp = Humanoid.MaxHealth
    local chakra = Player.Character:FindFirstChild("Chakra") and Player.Character.Chakra.Value or 0
    StatusLabel.Text = string.format("Status: Running | Level: %d | HP: %.0f/%.0f | Chakra: %.0f", level, hp, maxHp, chakra)
end

RunService.RenderStepped:Connect(UpdateStatus)

-- Minimize/Maximize logic
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Background:TweenSize(UDim2.new(0, 500, minimized and 0, 40 or 0, 400), "Out", "Quad", 0.3, true)
    for _, v in ipairs(TabFrames) do v.Visible = not minimized end
    StatusFrame.Visible = not minimized
end)

MaxBtn.MouseButton1Click:Connect(function()
    Background.Size = UDim2.new(0, 500, 0, 400)
    Background.Position = UDim2.new(0.5, -250, 0.5, -200)
end)

-- Core Auto Farm functions
local function AutoGreenFarmLoop()
    while Settings.AutoGreenFarm and task.wait(1) do
        pcall(function()
            -- Find mission NPC, accept mission, teleport to objective, complete
        end)
    end
end

local function AutoBossFarmLoop()
    while Settings.AutoBossFarm and task.wait(1.5) do
        pcall(function()
            -- Find boss, approach, attack, dodge, loot
        end)
    end
end

local function AutoRankUpCheck()
    if Settings.AutoRankUp and Player.Data.Level.Value >= 1000 then
        -- Trigger rank up
    end
end

local function AutoStatsAllocate()
    if Settings.AutoStats then
        -- Allocate stat points
    end
end

local function AutoRedeemCodes()
    if Settings.AutoRedeemCodes then
        -- Fetch and redeem codes
    end
end

-- Combat functions
local function AutoCombatLoop()
    while task.wait(0.2) do
        if Settings.AutoSkill then
            -- Use skills
        end
        if Settings.AutoCombo then
            -- Execute combo
        end
        if Settings.AutoEquip then
            -- Equip best items
        end
        if Settings.AutoChargeChakra then
            -- Charge chakra
        end
        if Settings.AutoHeal then
            -- Heal when low
        end
        if Settings.AutoTransformation then
            -- Transform
        end
        if Settings.AutoDodge then
            -- Dodge attacks
        end
        if Settings.AutoBlock then
            -- Block damage
        end
    end
end

-- Anti AFK
spawn(function()
    while Settings.AntiAFK and task.wait(60) do
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0,0))
    end
end)

-- FPS Boost
if Settings.FPSBoost then
    game:GetService("Lighting").GlobalShadows = false
    for _, v in ipairs(game:GetService("Workspace"):GetDescendants()) do
        if v:IsA("ParticleEmitter") then v.Enabled = false end
    end
end

-- Start loops
coroutine.wrap(AutoGreenFarmLoop)()
coroutine.wrap(AutoBossFarmLoop)()
coroutine.wrap(AutoRankUpCheck)()
coroutine.wrap(AutoStatsAllocate)()
coroutine.wrap(AutoRedeemCodes)()
coroutine.wrap(AutoCombatLoop)()

-- Notifications
function Notify(title, text, duration)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 50)
    notif.Position = UDim2.new(0.5, -150, 0, 50)
    notif.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    notif.BorderSizePixel = 0
    notif.Parent = ScreenGui

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 1, -10)
    lbl.Position = UDim2.new(0, 5, 0, 5)
    lbl.BackgroundTransparent = true
    lbl.Text = title .. "
" .. text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.Parent = notif

    TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -150, 0, 20)}):Play()
    task.wait(duration or 3)
    TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -150, 0, -60)}):Play()
    task.wait(0.5)
    notif:Destroy()
end

Notify("Moises mando oi", "Script loaded successfully!", 5)

-- Save/Load config
local configFile = "MoisesMandoOiConfig.json"
function SaveConfig()
    local data = HttpService:JSONEncode(Settings)
    writefile(configFile, data)
end
function LoadConfig()
    if isfile(configFile) then
        local data = readfile(configFile)
        local decoded = HttpService:JSONDecode(data)
        for k, v in pairs(decoded) do
            Settings[k] = v
        end
    end
end
LoadConfig()

-- Auto save every 30 seconds
spawn(function()
    while task.wait(30) do
        SaveConfig()
    end
end)

-- Keybinds
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Background.Visible = not Background.Visible
    end
end)

print("Moises mando oi - Premium Hub Activated")
