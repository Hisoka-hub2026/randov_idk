-- Очистка старых окон перед запуском
if _G.UltimateLoaded then return end
_G.UltimateLoaded = true

-- Загрузка официальной библиотеки Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

-- Создание главного окна чита
local Window = Rayfield:CreateWindow({
   Name = "ULTIMATE OVERLORD | Hisoka Hub",
   LoadingTitle = "Загрузка меню...",
   LoadingSubtitle = "by AI Developer",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false -- БЕЗ КЛЮЧЕЙ И ПАРОЛЕЙ
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


-- ========================================================
-- ВКЛАДКИ МЕНЮ RAYFIELD
-- ========================================================
local TabMovement = Window:CreateTab("Движение", 4483362458)
local TabCombat = Window:CreateTab("Бой и Визуал", 4483362458)
local TabMisc = Window:CreateTab("Разное", 4483362458)


-- ========================================================
-- ВКЛАДКА: ДВИЖЕНИЕ
-- ========================================================

TabMovement:CreateToggle({
   Name = "Проход сквозь стены (NoClip)",
   CurrentValue = false,
   Callback = function(Value) _G.NoClip = Value end,
})

TabMovement:CreateToggle({
   Name = "Бесконечные прыжки",
   CurrentValue = false,
   Callback = function(Value) _G.InfJump = Value end,
})

TabMovement:CreateToggle({
   Name = "Режим полета (Fly)",
   CurrentValue = false,
   Callback = function(Value) _G.Fly = Value end,
})

TabMovement:CreateButton({
   Name = "Ускорить бег (Speed 60)",
   Callback = function() if hum() then hum().WalkSpeed = 60 end end,
})

TabMovement:CreateButton({
   Name = "Супер прыжок (Jump 120)",
   Callback = function() if hum() then hum().JumpPower = 120 end end,
})

TabMovement:CreateButton({
   Name = "Сбросить настройки тела",
   Callback = function() if hum() then hum().WalkSpeed = 16 hum().JumpPower = 50 end end,
})


-- ========================================================
-- ВКЛАДКА: БОЙ И ВИЗУАЛ
-- ========================================================

TabCombat:CreateToggle({
   Name = "Wallhack (ESP Игроков)",
   CurrentValue = false,
   Callback = function(Value) _G.Esp = Value end,
})

TabCombat:CreateToggle({
   Name = "Aimbot (Зажми ПКМ)",
   CurrentValue = false,
   Callback = function(Value) _G.Aim = Value end,
})


-- ========================================================
-- ВКЛАДКА: РАЗНОЕ
-- ========================================================

TabMisc:CreateToggle({
   Name = "Освещение (FullBright)",
   CurrentValue = false,
   Callback = function(Value) _G.Bright = Value end,
})

TabMisc:CreateToggle({
   Name = "Быстрый автокликер",
   CurrentValue = false,
   Callback = function(Value) _G.Click = Value end,
})

TabMisc:CreateButton({
   Name = "Полностью удалить чит",
   Callback = function()
      _G.UltimateLoaded = nil _G.NoClip, _G.Fly, _G.InfJump, _G.Esp, _G.Aim, _G.Bright, _G.Click = false, false, false, false, false, false, false
      if hum() then hum().WalkSpeed = 16 hum().JumpPower = 50 end
      Rayfield:Destroy()
   end,
})


-- ========================================================
-- ЛОГИКА ФУНКЦИЙ (ОБХОДЫ И СИСТЕМА)
-- ========================================================

-- Логика NoClip
run.Stepped:Connect(function()
    if _G.NoClip and plr.Character then
        for _, p in pairs(plr.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
end)

-- Логика Infinite Jump
uis.JumpRequest:Connect(function()
    if _G.InfJump and hum() then hum():ChangeState("Jumping") end
end)

-- Логика Fly
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

-- Логика Aimbot
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

-- Логика ESP
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

-- Логика FullBright
task.spawn(function()
    local orig = light.Ambient
    while true do
        light.Ambient = _G.Bright and Color3.fromRGB(255,255,255) or orig
        if _G.Bright then light.Brightness = 2 end
        task.wait(1)
    end
end)

-- Логика Автокликера
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

-- Красивое стартовое уведомление Rayfield
Rayfield:Notify({
   Title = "Чит Запущен!",
   Content = "Добро пожаловать в мультихак от Hisoka Hub.",
   Duration = 5,
   Image = 4483362458,
})
