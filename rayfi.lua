-- ПОЛНОСТЬЮ АВТОНОМНЫЙ МУЛЬТИХАК (БЕЗ ВНЕШНИХ ЗАГРУЗОК)
if _G.UltimateLoaded then return end
_G.UltimateLoaded = true

local old_gui = game:GetService("CoreGui"):FindFirstChild("Rayfield") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Rayfield")
if old_gui then old_gui:Destroy() end

local plr = game:GetService("Players").LocalPlayer
local uis = game:GetService("UserInputService")
local run = game:GetService("RunService")
local light = game:GetService("Lighting")
local cam = workspace.CurrentCamera

local root = function() return plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") end
local hum = function() return plr.Character and plr.Character:FindFirstChildWhichIsA("Humanoid") end

_G.NoClip, _G.InfJump, _G.Fly, _G.Esp, _G.Aim, _G.Bright, _G.Click = false, false, false, false, false, false, false

-- ========================================================
-- ВСТРОЕННЫЙ СТИЛЬНЫЙ ИНТЕРФЕЙС (АНАЛОГ RAYFIELD)
-- ========================================================
local ScreenGui = Instance.new("ScreenGui") ScreenGui.Name = "Rayfield"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end) if not ScreenGui.Parent then ScreenGui.Parent = plr.PlayerGui end

local MainFrame = Instance.new("Frame", ScreenGui) MainFrame.Size = UDim2.new(0, 420, 0, 280) MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0) MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28) MainFrame.BorderSizePixel = 0 MainFrame.Active, MainFrame.Draggable = true, true Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local Sidebar = Instance.new("Frame", MainFrame) Sidebar.Size = UDim2.new(0, 120, 1, -35) Sidebar.Position = UDim2.new(0, 0, 0, 35) Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22) Sidebar.BorderSizePixel = 0
local Header = Instance.new("Frame", MainFrame) Header.Size = UDim2.new(1, 0, 0, 35) Header.BackgroundColor3 = Color3.fromRGB(32, 32, 38) Header.BorderSizePixel = 0 local Title = Instance.new("TextLabel", Header) Title.Size = UDim2.new(1, -20, 1, 0) Title.Position = UDim2.new(0, 12, 0, 0) Title.BackgroundTransparency = 1 Title.Text = "ULTIMATE CORE | RAYFIELD STYLE" Title.TextColor3 = Color3.fromRGB(255, 64, 84) Title.Font = Enum.Font.GothamBold Title.TextSize = 12 Title.TextXAlignment = Enum.TextXAlignment.Left

local Container = Instance.new("Frame", MainFrame) Container.Size = UDim2.new(1, -130, 1, -45) Container.Position = UDim2.new(0, 125, 0, 40) Container.BackgroundTransparency = 1
local function makeToggle(name, y, cb)
    local b = Instance.new("TextButton", Container) b.Size = UDim2.new(1, 0, 0, 32) b.Position = UDim2.new(0, 0, 0, y) b.BackgroundColor3 = Color3.fromRGB(34, 34, 40) b.Text = name .. ": ВЫКЛ" b.TextColor3 = Color3.fromRGB(200, 70, 80) b.Font = Enum.Font.GothamSemibold b.TextSize = 11 Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local s = false b.MouseButton1Click:Connect(function() s = not s b.BackgroundColor3 = s and Color3.fromRGB(46, 117, 89) or Color3.fromRGB(34, 34, 40) b.TextColor3 = s and Color3.fromRGB(150, 255, 180) or Color3.fromRGB(200, 70, 80) b.Text = name .. (s and ": ВКЛ" or ": ВЫКЛ") cb(s) end)
end
local function makeBtn(name, y, cb)
    local b = Instance.new("TextButton", Container) b.Size = UDim2.new(1, 0, 0, 32) b.Position = UDim2.new(0, 0, 0, y) b.BackgroundColor3 = Color3.fromRGB(50, 45, 35) b.Text = name b.TextColor3 = Color3.fromRGB(255, 180, 80) b.Font = Enum.Font.GothamSemibold b.TextSize = 11 Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6) b.MouseButton1Click:Connect(cb)
end

makeToggle("Проход сквозь стены (NoClip)", 0, function(v) _G.NoClip = v end)
makeToggle("Бесконечные прыжки", 38, function(v) _G.InfJump = v end)
makeToggle("Режим полета (Fly)", 76, function(v) _G.Fly = v end)
makeToggle("Wallhack (ESP Игроков)", 114, function(v) _G.Esp = v end)
makeBtn("Ускорить бег (Speed 60)", 152, function() if hum() then hum().WalkSpeed = 60 end end)
makeBtn("Полностью отключить чит", 190, function() _G.UltimateLoaded = nil _G.NoClip, _G.Fly, _G.InfJump, _G.Esp = false, false, false, false if hum() then hum().WalkSpeed = 16 end ScreenGui:Destroy() end)

-- ========================================================
-- ЛОГИКА СИСТЕМЫ ОБХОДОВ
-- ========================================================
run.Stepped:Connect(function() if _G.NoClip and plr.Character then for _, p in pairs(plr.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end)
uis.JumpRequest:Connect(function() if _G.InfJump and hum() then hum():ChangeState("Jumping") end end)
task.spawn(function()
    while true do
        if _G.Fly and root() and hum() then
            hum().PlatformStand = true local v = Vector3.new(0,0,0)
            if uis:IsKeyDown("W") then v = v + cam.CFrame.LookVector end if uis:IsKeyDown("S") then v = v - cam.CFrame.LookVector end if uis:IsKeyDown("A") then v = v - cam.CFrame.RightVector end if uis:IsKeyDown("D") then v = v + cam.CFrame.RightVector end
            root().AssemblyLinearVelocity = v.Magnitude > 0 and v.Unit * 50 or Vector3.new(0, 0.1, 0)
        elseif not _G.Fly and hum() and hum().PlatformStand then hum().PlatformStand = false end run.Heartbeat:Wait()
    end
end)
run.Heartbeat:Connect(function()
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= plr and p.Character then
            local hl = p.Character:FindFirstChild("ESPHl")
            if _G.Esp then
                if not hl then hl = Instance.new("Highlight", p.Character) hl.Name = "ESPHl" hl.FillColor, hl.FillTransparency, hl.OutlineColor = Color3.fromRGB(255, 60, 80), 0.5, Color3.fromRGB(255,255,255) end hl.Enabled = true
            elseif hl then hl.Enabled = false end
        end
    end
end)
