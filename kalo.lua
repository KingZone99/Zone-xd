-- SCRIPT UNTUK ROBLOX (LocalScript)
-- Taruh di StarterGui atau di objek pohon

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui

-- Buat kotak prediksi
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 200)
frame.Visible = false -- Sembunyiin dulu
frame.Parent = gui

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🌱 PREDIKSI PANEN"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.TextScaled = true
title.Font = Enum.Font.Bold
title.Parent = frame

-- Text prediksi multiplier
local multLabel = Instance.new("TextLabel")
multLabel.Size = UDim2.new(1, 0, 0, 40)
multLabel.Position = UDim2.new(0, 0, 0, 40)
multLabel.BackgroundTransparency = 1
multLabel.Text = "📈 1.0x"
multLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
multLabel.TextScaled = true
multLabel.Font = Enum.Font.Regular
multLabel.Parent = frame

-- Text risiko
local riskLabel = Instance.new("TextLabel")
riskLabel.Size = UDim2.new(1, 0, 0, 30)
riskLabel.Position = UDim2.new(0, 0, 0, 85)
riskLabel.BackgroundTransparency = 1
riskLabel.Text = "⚡ Risiko: 0%"
riskLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
riskLabel.TextScaled = true
riskLabel.Font = Enum.Font.Regular
riskLabel.Parent = frame

-- Text saran
local saranLabel = Instance.new("TextLabel")
saranLabel.Size = UDim2.new(1, 0, 0, 50)
saranLabel.Position = UDim2.new(0, 0, 0, 120)
saranLabel.BackgroundTransparency = 1
saranLabel.Text = "💡 Tunggu 3 menit lagi"
saranLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
saranLabel.TextScaled = true
saranLabel.Font = Enum.Font.Regular
saranLabel.Parent = frame

-- Timer update tiap detik
local startTime = os.time()

-- TABEL DATA (lo isi sendiri dari observasi)
local DATA = {
    [10] = {mult = 1.2, risk = 0},
    [30] = {mult = 1.8, risk = 0.05},
    [60] = {mult = 2.5, risk = 0.1},
    [120] = {mult = 3.3, risk = 0.2},
    [180] = {mult = 4.0, risk = 0.35},
    [240] = {mult = 4.5, risk = 0.5},
    [300] = {mult = 4.9, risk = 0.65},
    [360] = {mult = 5.2, risk = 0.8},
    [420] = {mult = 5.0, risk = 0.95},
    [480] = {mult = 4.5, risk = 1.0},
}

function getPrediction(elapsed)
    local best = {mult = 1.0, risk = 0}
    for time, data in pairs(DATA) do
        if time <= elapsed then
            best = data
        end
    end
    return best
end

function updateUI()
    local elapsed = os.time() - startTime
    local pred = getPrediction(elapsed)
    
    multLabel.Text = "📈 " .. string.format("%.1f", pred.mult) .. "x"
    riskLabel.Text = "⚡ Risiko: " .. string.format("%.0f", pred.risk * 100) .. "%"
    
    -- Warna berdasarkan risiko
    if pred.risk < 0.3 then
        riskLabel.TextColor3 = Color3.fromRGB(0, 255, 100) -- hijau
        saranLabel.Text = "✅ AMAN – bisa tunggu lebih lama"
    elseif pred.risk < 0.6 then
        riskLabel.TextColor3 = Color3.fromRGB(255, 200, 0) -- kuning
        saranLabel.Text = "⚠️  Lumayan – panen atau tunggu 30s lagi"
    elseif pred.risk < 0.85 then
        riskLabel.TextColor3 = Color3.fromRGB(255, 100, 0) -- orange
        saranLabel.Text = "⚡ RISIKO TINGGI! Panen sekarang!"
    else
        riskLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- merah
        saranLabel.Text = "🔥 BAHAYA! Petir pasti datang!"
    end
end

-- Tampilin kotak pas tanam
frame.Visible = true

-- Update tiap detik
spawn(function()
    while frame.Visible do
        updateUI()
        wait(1)
    end
end)

-- Sembunyiin otomatis pas panen
-- (lo panggil ini pas selesai panen)
-- frame.Visible = false