-- JUMPSCARE GENDERUWO + SUARA AHAHAAAA - ZONE XD V1
-- COPYRIGHT: APIS (USER 01)

local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ==================================================
-- SETUP JUMPSCARE
-- ==================================================
local screen = Instance.new("ScreenGui")
screen.Name = "GENDERUWO_JUMPSCARE"
screen.Parent = gui
screen.Enabled = false
screen.DisplayOrder = 9999
screen.IgnoreGuiInset = true

-- LAYAR MERAH (BERKEDIP)
local redFrame = Instance.new("Frame")
redFrame.Size = UDim2.new(1, 0, 1, 0)
redFrame.BackgroundColor3 = Color3.new(1, 0, 0)
redFrame.BackgroundTransparency = 0.3
redFrame.BorderSizePixel = 0
redFrame.Parent = screen

-- LAYAR HITAM (BUAT KONTRAST)
local blackFrame = Instance.new("Frame")
blackFrame.Size = UDim2.new(1, 0, 1, 0)
blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
blackFrame.BackgroundTransparency = 1
blackFrame.BorderSizePixel = 0
blackFrame.Parent = screen

-- GAMBAR GENDERUWO (PAKE ID YANG UDH GW SEDIAIN)
-- BISA DIGANTI KALO MAU
local image = Instance.new("ImageLabel")
image.Size = UDim2.new(1, 0, 1, 0)
image.Position = UDim2.new(0, 0, 0, 0)
image.BackgroundTransparency = 1
image.Image = "rbxassetid://160486557"  -- GAMBAR SLENDERMAN (BISA DIGANTI)
image.ImageTransparency = 0
image.ScaleType = Enum.ScaleType.Stretch
image.Parent = screen

-- SUARA TERIAKAN "AHAHAAAA" (PAKE ID HORROR JUMPSCARE)
-- ID DARI RUSSIAN SITE [citation:4]
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://6754147732"  -- ID SUARA HORROR JUMPSCARE
sound.Volume = 10
sound.Pitch = 1.2
sound.EmitterSize = 100
sound.PlaybackSpeed = 1
sound.RollOffMode = Enum.RollOffMode.Linear
sound.Parent = workspace

-- KAMERA BUAT EFEK GEMPA
local camera = workspace.CurrentCamera
local originalCF = camera.CFrame

-- ==================================================
-- FUNGSI JUMPSCARE LENGKAP
-- ==================================================
local function triggerJumpscare()
    -- MATIKAN DULU KALO SEDANG JALAN
    screen.Enabled = false
    wait(0.1)
    
    -- RESET TRANSPARANSI
    blackFrame.BackgroundTransparency = 1
    redFrame.BackgroundTransparency = 0.3
    image.ImageTransparency = 0
    
    -- NYALAKAN SCREEN
    screen.Enabled = true
    
    -- MAININ SUARA (KERAS BANGET)
    sound:Play()
    
    -- EFEK KEDIP CEPET (LAYAR MERAH BERKEDIP)
    for i = 1, 5 do
        redFrame.BackgroundTransparency = 0.1
        wait(0.05)
        redFrame.BackgroundTransparency = 0.5
        wait(0.05)
    end
    
    -- EFEK GEMPA (KAMERA GOYANG)
    originalCF = camera.CFrame
    for i = 1, 15 do
        local randomX = math.random(-15, 15) / 10
        local randomY = math.random(-10, 10) / 10
        local randomZ = math.random(-5, 5) / 10
        camera.CFrame = originalCF * CFrame.new(randomX, randomY, randomZ)
        wait(0.03)
    end
    camera.CFrame = originalCF
    
    -- EFEK FADE OUT
    for i = 0, 10 do
        image.ImageTransparency = i / 10
        redFrame.BackgroundTransparency = 0.3 + (i / 10)
        blackFrame.BackgroundTransparency = i / 10
        wait(0.05)
    end
    
    -- MATIKAN SCREEN
    screen.Enabled = false
end

-- ==================================================
-- BEBERAPA OPSI TRIGGER (PILIH SALAH SATU)
-- ==================================================

-- OPSI 1: LANGSUNG PAS EXECUTE (KOMENTARIN KALO GA MAU)
triggerJumpscare()

-- OPSI 2: TEKAN TOMBOL T (HAPUS --[[ DAN ]] KALO MAU PAKE INI)
--[[
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T then
        triggerJumpscare()
    end
end)
--]]

-- OPSI 3: RANDOM SETIAP 30-60 DETIK (HAPUS --[[ DAN ]] KALO MAU PAKE INI)
--[[
while true do
    wait(math.random(30, 60))
    triggerJumpscare()
end
--]]

print("🔥 JUMPSCARE GENDERUWO SIAP - SUARA AHAHAAAA 🔥")