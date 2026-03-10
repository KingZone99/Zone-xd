--[[
🔥 ZONE XD FLY SCRIPT MOBILE V3 🔥
CARA PAKE:
- Klik "TERBANG" = ON (mulai terbang)
- Klik "TERBANG" lagi = OFF (turun ke tanah)
- Klik "NAIK" = tambah kecepatan
- Klik "TURUN" = kurang kecepatan
--]]

-- Ambil player
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Setting awal
local terbang = false
local kecepatan = 50
local loopTerbang = nil

-- Buat GUI (tombol di layar)
local gui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local btnTerbang = Instance.new("TextButton")
local btnNaik = Instance.new("TextButton")
local btnTurun = Instance.new("TextButton")
local txtSpeed = Instance.new("TextLabel")

-- Setting GUI
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

frame.Parent = gui
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.3
frame.Position = UDim2.new(0.7, 0, 0.7, 0)
frame.Size = UDim2.new(0, 150, 0, 150)
frame.Active = true
frame.Draggable = true  -- Bisa digeser kalo ganggu

-- Tombol TERBANG (ON/OFF)
btnTerbang.Parent = frame
btnTerbang.Size = UDim2.new(0, 140, 0, 40)
btnTerbang.Position = UDim2.new(0, 5, 0, 5)
btnTerbang.Text = "🔴 TERBANG"
btnTerbang.BackgroundColor3 = Color3.new(1, 0, 0)
btnTerbang.TextColor3 = Color3.new(1, 1, 1)
btnTerbang.Font = Enum.Font.SourceSansBold
btnTerbang.TextSize = 20

-- Tombol NAIK (tambah kecepatan)
btnNaik.Parent = frame
btnNaik.Size = UDim2.new(0, 68, 0, 40)
btnNaik.Position = UDim2.new(0, 5, 0, 50)
btnNaik.Text = "➕ NAIK"
btnNaik.BackgroundColor3 = Color3.new(0, 1, 0)
btnNaik.TextColor3 = Color3.new(0, 0, 0)
btnNaik.Font = Enum.Font.SourceSansBold
btnNaik.TextSize = 18

-- Tombol TURUN (kurang kecepatan)
btnTurun.Parent = frame
btnTurun.Size = UDim2.new(0, 68, 0, 40)
btnTurun.Position = UDim2.new(0, 77, 0, 50)
btnTurun.Text = "➖ TURUN"
btnTurun.BackgroundColor3 = Color3.new(1, 1, 0)
btnTurun.TextColor3 = Color3.new(0, 0, 0)
btnTurun.Font = Enum.Font.SourceSansBold
btnTurun.TextSize = 18

-- Label buat nunjukkin kecepatan
txtSpeed.Parent = frame
txtSpeed.Size = UDim2.new(0, 140, 0, 30)
txtSpeed.Position = UDim2.new(0, 5, 0, 95)
txtSpeed.Text = "⚡ 50"
txtSpeed.BackgroundColor3 = Color3.new(0, 0, 0)
txtSpeed.TextColor3 = Color3.new(1, 1, 0)
txtSpeed.Font = Enum.Font.SourceSansBold
txtSpeed.TextSize = 22

-- FUNGSI TERBANG
local function mulaiTerbang()
    humanoid.PlatformStand = true
    loopTerbang = game:GetService("RunService").RenderStepped:Connect(function()
        if not terbang then
            if loopTerbang then loopTerbang:Disconnect() end
            return
        end
        
        -- Gerak maju terus (biar gak diam di tempat)
        local arah = workspace.CurrentCamera.CFrame.LookVector
        character:SetPrimaryPartCFrame(character.PrimaryPart.CFrame + (arah * kecepatan * 0.1))
    end)
end

-- KETIKA TOMBOL TERBANG DI KLIK
btnTerbang.MouseButton1Click:Connect(function()
    terbang = not terbang  -- ganti status (on/off)
    
    if terbang then
        btnTerbang.Text = "🟢 TERBANG"
        btnTerbang.BackgroundColor3 = Color3.new(0, 1, 0)
        mulaiTerbang()
    else
        btnTerbang.Text = "🔴 TERBANG"
        btnTerbang.BackgroundColor3 = Color3.new(1, 0, 0)
        humanoid.PlatformStand = false
        if loopTerbang then loopTerbang:Disconnect() end
    end
end)

-- KETIKA TOMBOL NAIK DI KLIK
btnNaik.MouseButton1Click:Connect(function()
    kecepatan = kecepatan + 10
    txtSpeed.Text = "⚡ " .. kecepatan
end)

-- KETIKA TOMBOL TURUN DI KLIK
btnTurun.MouseButton1Click:Connect(function()
    kecepatan = math.max(10, kecepatan - 10)  -- minimal 10 biar gak 0
    txtSpeed.Text = "⚡ " .. kecepatan
end)

-- Biar karakter selalu update (antisipasi mati)
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    wait(1)
    if terbang then
        humanoid.PlatformStand = true
    end
end)