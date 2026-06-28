-- Очистка старых окон перед запуском
if _G.UltimateLoaded then return end
_G.UltimateLoaded = true

-- Загрузка Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com"))()

-- Создание окна софта
local Window = Fluent:CreateWindow({
    Title = "ULTIMATE OVERLORD",
    SubTitle = "by Hisoka Hub",
    TabWidth = 140,
    Size = UDim2.fromOffset(480, 340),
    Acrylic = true, -- Размытие фона
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Переменные Roblox
local plr = game:GetService("Players").LocalPlayer
local uis = game:GetService("UserInputService")
local run = game:GetService("RunService")
local light = game:GetService("Lighting")
local cam = workspace.CurrentCamera

local root = function() return plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") end
local hum = function() return plr.Character and plr.Character:FindFirstChildWhichIsA("Humanoid") end

_G.NoClip, _G.InfJump, _G.Fly, _G.Esp, _G.Aim, _G.Bright, _G.Click = false, false, false, false, false, false, false

-- ВКЛАДКИ
local Tabs = {
    Main = Window:AddTab({ Title = "Движение", Icon = "run" }),
    Combat = Window:AddTab({ Title = "Бой и Визуал", Icon = "shield" }),
    Misc = Window:AddTab({ Title = "Разное", Icon = "settings" })
}

-- КНОПКИ: ДВИЖЕНИЕ
Tabs.Main:AddToggle("NoClip", {Title = "Проход сквозь стены (NoClip)", Default = false}):OnChanged(function(v) _G.NoClip = v end)
Tabs.Main:AddToggle("InfJump", {Title = "Бесконечные прыжки", Default = false}):OnChanged(function(v) _G.InfJump = v end)
Tabs.Main:AddToggle("Fly", {Title = "Режим полета (Fly)", Default = false}):OnChanged(function(v) _G.Fly = v end)

Tabs.Main:AddButton({Title = "Скорость 60", Callback = function() if hum() then hum().WalkSpeed = 60 end end})
Tabs.Main:AddButton({Title = "Прыжок 120", Callback = function() if hum() then hum().JumpPower = 120 end end})
Tabs.Main:AddButton({Title = "Сброс", Callback = function() if hum() then hum().WalkSpeed = 16 hum().JumpPower = 50 end end})

-- КНОПКИ: БОЙ
Tabs.Combat:AddToggle("Esp", {Title = "Wallhack (ESP Игроков)", Default = false}):OnChanged(function(v) _G.Esp = v end)
Tabs.Combat:AddToggle("Aim", {Title = "Aimbot (Зажми ПКМ / Экран)", Default = false}):OnChanged(function(v) _G.Aim = v end)

-- КНОПКИ: РАЗНОЕ
Tabs.Misc:AddToggle("Bright", {Title = "Освещение (FullBright)", Default = false}):OnChanged(function(v) _G.Bright = v end)
Tabs.Misc:AddToggle("Click", {Title = "Автокликер (Левая кнопка)", Default = false}):OnChanged(function(v) _G.Click = v end)

Tabs.Misc:AddButton({
    Title = "Удалить чит",
    Callback = function()
        _G.UltimateLoaded = nil _G.NoClip, _G.Fly, _G.InfJump, _G.Esp, _G.Aim, _G.Bright, _G.Click = false, false, false, false, false, false, false
        if hum() then hum().WalkSpeed = 16 hum().JumpPower = 50 end
        Fluent:Destroy()
    end
})

-- ЛОГИКА ФУНКЦИЙ
run.Stepped:Connect(function()
    if _G.NoClip and plr.Character then
        for _, p in pairs(plr.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
end)

uis.JumpRequest:Connect(function()
    if _G.InfJump and hum() then hum():ChangeState("Jumping") end
end)

task.spawn(function()
    while true do
        if _G.Fly and root() and hum() then
            hum().PlatformStand = true
            local v = Vector3.new(0,0,0)
            if uis:IsKeyDown("W") then v = v + cam.CFrame.LookVector end
            if uis:IsKeyDown("S") then v = v - cam.CFrame.LookVector end
            if uis:IsKeyDown("A") then v = v - cam.CFrame.RightVector end
            if uis:IsKeyDown("D") then v = v + cam.CFrame.RightVector end
            root().AssemblyLinearVelocity = v.Magnitude > 0 and v.Unit * 50 or Vector3.new(0, 0.1, 0)
        elseif not _G.Fly and hum() and hum().PlatformStand then hum().PlatformStand = false end
        run.Heartbeat:Wait()
    end
end)

run.RenderStepped:Connect(function()
    if _G.Aim and uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t, c = nil, math.huge
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pr = p.Character.HumanoidRootPart
                local pos, on = cam:WorldToViewportPoint(pr.Position)
                if on then
                    local m = (Vector2.new(pos.X, pos.Y) - uis:GetMouseLocation()).Magnitude
                    if m < c then c, t = m, pr end
                end
            end
        end
        if t then cam.CFrame = CFrame.new(cam.CFrame.Position, t.Position) end
    end
end)

run.Heartbeat:Connect(function()
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= plr and p.Character then
            local hl = p.Character:FindFirstChild("ESPHl")
            if _G.Esp then
                if not hl then
                    hl = Instance.new("Highlight", p.Character) hl.Name = "ESPHl"
                    hl.FillColor, hl.FillTransparency, hl.OutlineColor = Color3.fromRGB(255, 60, 80), 0.5, Color3.fromRGB(255,255,255)
                end
                hl.Enabled = true
            elseif hl then hl.Enabled = false end
        end
    end
end)

task.spawn(function()
    local orig = light.Ambient
    while true do
        light.Ambient = _G.Bright and Color3.fromRGB(255,255,255) or orig
        if _G.Bright then light.Brightness = 2 end
        task.wait(1)
    end
end)

task.spawn(function()
    while true do
        if _G.Click then
            pcall(function()
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), cam.CFrame)
                task.wait(0.01)
                game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0), cam.CFrame)
            end)
        end
        task.wait(0.05)
    end
end)

pcall(function() plr.Idled:Connect(function() game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), cam.CFrame) task.wait(0.5) game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), cam.CFrame) end) end)

Fluent:Notify({ Title = "Запущено!", Content = "Премиум чит Hisoka Hub активен.", Duration = 4 })
