--[[
🔥 ZONE XD FLY SCRIPT V4 🔥
FITUR:
- Terbang pake ANALOG (WASD) kaya main game biasa
- Bisa gerak ke segala arah
- Speed bisa diatur (NAIK/TURUN)
- GA NGAWUR, GA GERAK OTOMATIS!
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
frame.Draggable = true

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

-- Label kecepatan
txtSpeed.Parent = frame
txtSpeed.Size = UDim2.new(0, 140, 0, 30)
txtSpeed.Position = UDim2.new(0, 5, 0, 95)
txtSpeed.Text = "⚡ 50"
txtSpeed.BackgroundColor3 = Color3.new(0, 0, 0)
txtSpeed.TextColor3 = Color3.new(1, 1, 0)
txtSpeed.Font = Enum.Font.SourceSansBold
txtSpeed.TextSize = 22

-- Ambil input service
local uis = game:GetService("UserInputService")

-- FUNGSI TERBANG (PAKE ANALOG - GA NGAWUR!)
local function mulaiTerbang()
    humanoid.PlatformStand = true
    loopTerbang = game:GetService("RunService").RenderStepped:Connect(function()
        if not terbang then
            if loopTerbang then loopTerbang:Disconnect() end
            return
        end
        
        -- Hitung arah berdasarkan tombol yang ditekan
        local moveDir = Vector3.new(0, 0, 0)
        
        -- WASD untuk gerak (ANALOG VIRTUAL)
        if uis:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector
        end
        if uis:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector
        end
        if uis:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector
        end
        if uis:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector
        end
        
        -- Naik/Turun
        if uis:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if uis:IsKeyDown(Enum.KeyCode.LeftControl) or uis:IsKeyDown(Enum.KeyCode.C) then
            moveDir = moveDir + Vector3.new(0, -1, 0)
        end
        
        -- Terap kalo ga gerak (biar ga jatuh)
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * kecepatan * 0.1
            character:SetPrimaryPartCFrame(character.PrimaryPart.CFrame + moveDir)
        end
    end)
end

-- Klik TERBANG
btnTerbang.MouseButton1Click:Connect(function()
    terbang = not terbang
    
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

-- Klik NAIK
btnNaik.MouseButton1Click:Connect(function()
    kecepatan = kecepatan + 10
    txtSpeed.Text = "⚡ " .. kecepatan
end)

-- Klik TURUN
btnTurun.MouseButton1Click:Connect(function()
    kecepatan = math.max(10, kecepatan - 10)
    txtSpeed.Text = "⚡ " .. kecepatan
end)

-- Update karakter kalo mati
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    wait(1)
    if terbang then
        humanoid.PlatformStand = true
    end
end)
