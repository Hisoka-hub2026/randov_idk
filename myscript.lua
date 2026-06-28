-- Тестовый скрипт от AI Developer
local LocalPlayer = game:GetService("Players").LocalPlayer
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
    LocalPlayer.Character.Humanoid.WalkSpeed = 32 -- Увеличиваем скорость
    print("Скрипт с GitHub успешно запущен!")
end
