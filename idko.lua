local old = game:GetService("CoreGui"):FindFirstChild("Ult") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Ult")
if old then old:Destroy() end

local plr = game:GetService("Players").LocalPlayer
local uis = game:GetService("UserInputService")
local run = game:GetService("RunService")
local light = game:GetService("Lighting")
local cam = workspace.CurrentCamera

local root = function() return plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") end
local hum = function() return plr.Character and plr.Character:FindFirstChildWhichIsA("Humanoid") end

_G.NoClip, _G.InfJump, _G.Fly, _G.Esp, _G.Aim, _G.Bright, _G.Click = false, false, false, false, false, false, false




local Gui = Instance.new("ScreenGui") Gui.Name = "Ult"
pcall(function() Gui.Parent = game:GetService("CoreGui") end) if not Gui.Parent then Gui.Parent = plr.PlayerGui end

local Frame = Instance.new("Frame", Gui) Frame.Size = UDim2.new(0, 160, 0, 270) Frame.Position = UDim2.new(0.05, 0, 0.2, 0) Frame.BackgroundColor3 = Color3.fromRGB(20,20,20) Frame.Active, Frame.Draggable = true, true Instance.new("UICorner", Frame)

local Scroll = Instance.new("ScrollingFrame", Frame) Scroll.Size = UDim2.new(1, 0, 1, -10) Scroll.Position = UDim2.new(0, 0, 0, 5) Scroll.BackgroundTransparency, Scroll.CanvasSize, Scroll.ScrollBarThickness = 1, UDim2.new(0, 0, 0, 330), 2

local function makeBtn(txt, y, cb)
    local b = Instance.new("TextButton", Scroll) b.Size = UDim2.new(0.9, 0, 0, 28) b.Position = UDim2.new(0.05, 0, 0, y) b.BackgroundColor3 = Color3.fromRGB(40,40,40) b.Text, b.TextColor3, b.Font, b.TextSize = txt, Color3.fromRGB(255,100,100), Enum.Font.GothamBold, 9 Instance.new("UICorner", b)
    local s = false b.MouseButton1Click:Connect(function() s = not s b.BackgroundColor3 = s and Color3.fromRGB(40,100,40) or Color3.fromRGB(40,40,40) b.TextColor3 = s and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100) cb(s) end)
end

makeBtn("NOCLIP", 5, function(v) _G.NoClip = v end)
makeBtn("INF JUMP", 40, function(v) _G.InfJump = v end)
makeBtn("FLY", 75, function(v) _G.Fly = v end)
makeBtn("ESP (WALLHACK)", 110, function(v) _G.Esp = v end)
makeBtn("AIMBOT (RMB)", 145, function(v) _G.Aim = v end)
makeBtn("FULLBRIGHT", 180, function(v) _G.Bright = v end)
makeBtn("AUTOCLICKER", 215, function(v) _G.Click = v end)

local function makeAction(txt, y, cb)
    local b = Instance.new("TextButton", Scroll) b.Size = UDim2.new(0.9, 0, 0, 28) b.Position = UDim2.new(0.05, 0, 0, y) b.BackgroundColor3 = Color3.fromRGB(60,50,40) b.Text, b.TextColor3, b.Font, b.TextSize = txt, Color3.fromRGB(255,200,100), Enum.Font.GothamBold, 9 Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

makeAction("SPEED 60", 250, function() if hum() then hum().WalkSpeed = 60 end end)
makeAction("JUMP 120", 285, function() if hum() then hum().JumpPower = 120 end end)
makeAction("RESET", 320, function() if hum() then hum().WalkSpeed = 16 hum().JumpPower = 50 end end)




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
