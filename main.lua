--[[
   Script: Moises mando oi
   Versão: Simples e funcional para Shindo Life
--]]

-- Garantir que carregue
print("Moises mando oi - Carregando...")

-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart") or Character:FindFirstChild("Torso")

-- Criar GUI básica
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoisesMandoOi"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 500, 0, 400)
Frame.Position = UDim2.new(0.5, -250, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Frame.BackgroundTransparency = 0.2
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.Text = "Moises mando oi"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = Frame

-- Toggles (simples, sem scroll)
local toggles = {
    AutoFarm = false,
    AutoBoss = false,
    AutoSpam = false,
    AntiAFK = true,
}

local y = 50
for name, default in pairs(toggles) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 460, 0, 35)
    btn.Position = UDim2.new(0, 20, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = name .. " : " .. tostring(default)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = Frame

    btn.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        btn.Text = name .. " : " .. tostring(toggles[name])
        if toggles[name] then
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
        else
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        end
    end)

    y = y + 45
end

-- Fechar GUI com Insert
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- Loop principal (anti-afk sempre ativo)
spawn(function()
    while task.wait(60) do
        if toggles.AntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0,0))
        end
    end
end)

-- Auto Farm (exemplo básico)
spawn(function()
    while task.wait(0.1) do
        if toggles.AutoFarm then
            pcall(function()
                -- Pressiona tecla de ataque (ex: tecla 1)
                local mouse = Player:GetMouse()
                mouse.KeyDown:Fire("1") -- Simula apertar 1
                task.wait(0.05)
                mouse.KeyDown:Fire("2") -- Simula apertar 2
            end)
        end
    end
end)

-- Auto Boss (apenas teleporta para o boss mais próximo - exemplo)
spawn(function()
    while task.wait(3) do
        if toggles.AutoBoss then
            pcall(function()
                local boss = nil
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name:lower():find("boss") then
                        boss = v
                        break
                    end
                end
                if boss and RootPart then
                    RootPart.CFrame = boss:GetPivot() * CFrame.new(0, 0, -5)
                end
            end)
        end
    end
end)

-- Auto Spam de habilidades (tecla 1,2,3,4...)
spawn(function()
    while task.wait(0.5) do
        if toggles.AutoSpam then
            pcall(function()
                for i = 1, 4 do
                    local mouse = Player:GetMouse()
                    mouse.KeyDown:Fire(tostring(i))
                    task.wait(0.1)
                end
            end)
        end
    end
end)

print("Moises mando oi - Script carregado com sucesso!")
