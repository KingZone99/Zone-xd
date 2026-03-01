-- JUMPSCARE INFINITY V2 - FIX GAMBAR GA MUNCUL
-- COPYRIGHT: APIS (USER 01)

local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- ==================================================
-- PILIH SALAH SATU GAMBAR (HAPUS -- DI DEPANNYA)
-- ==================================================

-- OPSI 1: SLENDERMAN (ORI)
local imageId = "rbxassetid://160486557"

-- OPSI 2: WAJAH SEREM (ALTERNATIF)
-- local imageId = "rbxassetid://258422278"

-- OPSI 3: MATA MERAH (SEREM JUGA)
-- local imageId = "rbxassetid://284271050"

-- OPSI 4: GAMBAR HANTU (KUNTILANAK)
-- local imageId = "rbxassetid://4797166046"

-- OPSI 5: GAMBAR POCONG (KALO ADA)
-- local imageId = "rbxassetid://5269326264"

-- ==================================================
-- SETUP JUMPSCARE INFINITY
-- ==================================================
local screen = Instance.new("ScreenGui")
screen.Name = "GENDERUWO_INFINITY"
screen.Parent = gui
screen.Enabled = true
screen.DisplayOrder = 9999
screen.IgnoreGuiInset = true
screen.ResetOnSpawn = false

-- LAYAR MERAH (BERKEDIP TERUS)
local redFrame = Instance.new("Frame")
redFrame.Size = UDim2.new(1, 0, 1, 0)
redFrame.BackgroundColor3 = Color3.new(0.8, 0, 0)
redFrame.BackgroundTransparency = 0.3
redFrame.BorderSizePixel = 0
redFrame.Parent = screen

-- GAMBAR (PAKE ID YANG DIPILIH)
local image = Instance.new("ImageLabel")
image.Size = UDim2.new(1.2, 0, 1.2, 0)
image.Position = UDim2.new(-0.1, 0, -0.1, 0)
image.BackgroundColor3 = Color3.new(0, 0, 0)
image.BackgroundTransparency = 0.5  -- BIAR KALO GAGAL MUNCUL KOTAK HITAM
image.Image = imageId
image.ImageTransparency = 0
image.ScaleType = Enum.ScaleType.Stretch
image.Parent = screen

-- FALLBACK: KALO GAMBAR TETAP GA MUNCUL, PAKE FRAME WARNA
local fallback = Instance.new("Frame")
fallback.Size = UDim2.new(1, 0, 1, 0)
fallback.BackgroundColor3 = Color3.new(0, 0, 0)
fallback.BackgroundTransparency = 1  -- MULAI TRANSPARAN
fallback.BorderSizePixel = 0
fallback.Parent = screen

-- SUARA LOOP TERUS
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://6754147732"
sound.Volume = 10
sound.Pitch = 1
sound.Looped = true
sound.PlaybackSpeed = 1
sound.Parent = workspace
sound:Play()

-- KAMERA BUAT EFEK GEMPA INFINITY
local camera = workspace.CurrentCamera
local originalCF = camera.CFrame

-- ==================================================
-- EFEK GEMPA INFINITY (SETIAP FRAME)
-- ==================================================
RunService.RenderStepped:Connect(function()
    -- GEMPA ACAK
    local randomX = math.random(-20, 20) / 10
    local randomY = math.random(-15, 15) / 10
    local randomZ = math.random(-5, 5) / 10
    camera.CFrame = originalCF * CFrame.new(randomX, randomY, randomZ)
    
    -- KEDIP MERAH ACAK
    redFrame.BackgroundTransparency = 0.2 + math.random() * 0.3
    
    -- GAMBAR GOYANG
    image.Position = UDim2.new(-0.1 + math.random(-10,10)/100, 0, -0.1 + math.random(-10,10)/100, 0)
    
    -- FALLBACK KALO GAMBAR GA MUNCUL (JADI BACKGROUND HITAM)
    if image.ImageTransparency == 1 then
        fallback.BackgroundTransparency = 0
    end
end)

-- ==================================================
-- PASTIKAN GA BISA DI CLOSE
-- ==================================================
screen.Destroying:Connect(function()
    wait(0.1)
    screen.Parent = gui
    screen.Enabled = true
end)

print("🔥 JUMPSCARE INFINITY V2 AKTIF 🔥")
print("💀 PILIHAN GAMBAR: " .. imageId)
print("💀 KALO MASIH GA MUNCUL, COBA OPSI LAIN DI SCRIPT")