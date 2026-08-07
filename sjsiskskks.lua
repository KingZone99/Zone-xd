-- SCRIPT PREDIKSI PANEN - FIXED FOR DELTA
-- https://raw.githubusercontent.com/KingZone99/Zone-xd/refs/heads/KingZone99-patch-1/kalo.lua

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "PrediksiPanen"
gui.Parent = player.PlayerGui

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 240)
frame.Position = UDim2.new(0.5, -170, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(8, 8, 20)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 200)
frame.Visible = true
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🌱 PREDIKSI PANEN"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.TextScaled = true
title.Font = Enum.Font.Bold
title.Parent = frame

-- Nama pohon
local treeName = Instance.new("TextLabel")
treeName.Size = UDim2.new(1, 0, 0, 30)
treeName.Position = UDim2.new(0, 0, 0, 40)
treeName.BackgroundTransparency = 1
treeName.Text = "🌳 " .. (player.Character and player.Character.Name or "Pohon")
treeName.TextColor3 = Color3.fromRGB(200, 200, 255)
treeName.TextScaled = true
treeName.Font = Enum.Font.Regular
treeName.Parent = frame

-- Multiplier
local multLabel = Instance.new("TextLabel")
multLabel.Size = UDim2.new(1, 0, 0, 45)
multLabel.Position = UDim2.new(0, 0, 0, 75)
multLabel.BackgroundTransparency = 1
multLabel.Text = "📈 1.0x"
multLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
multLabel.TextScaled = true
multLabel.Font = Enum.Font.Bold
multLabel.Parent = frame

-- Risk
local riskLabel = Instance.new("TextLabel")
riskLabel.Size = UDim2.new(1, 0, 0, 35)
riskLabel.Position = UDim2.new(0, 0, 0, 125)
riskLabel.BackgroundTransparency = 1
riskLabel.Text = "⚡ Risiko: 0%"
riskLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
riskLabel.TextScaled = true
riskLabel.Font = Enum.Font.Regular
riskLabel.Parent = frame

-- Saran
local saranLabel = Instance.new("TextLabel")
saranLabel.Size = UDim2.new(1, 0, 0, 50)
saranLabel.Position = UDim2.new(0, 0, 0, 165)
saranLabel.BackgroundTransparency = 1
saranLabel.Text = "💡 Tunggu 3 menit lagi"
saranLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
saranLabel.TextScaled = true
saranLabel.Font = Enum.Font.Regular
saranLabel.Parent = frame

-- Tombol Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.Bold
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- DATA PREDIKSI
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

local startTime = os.time()

function getPrediction(elapsed)
    local best = {mult = 1.0, risk = 0}
    for time, data in pairs(DATA) do
        if time <= elapsed and data.mult > best.mult then
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
    
    if pred.risk < 0.3 then
        riskLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        saranLabel.Text = "✅ AMAN – bisa tunggu lebih lama"
    elseif pred.risk < 0.6 then
        riskLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        saranLabel.Text = "⚠️  Lumayan – panen atau tunggu 30s lagi"
    elseif pred.risk < 0.85 then
        riskLabel.TextColor3 = Color3.fromRGB(255, 100, 0)
        saranLabel.Text = "⚡ RISIKO TINGGI! Panen sekarang!"
    else
        riskLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        saranLabel.Text = "🔥 BAHAYA! Petir pasti datang!"
    end
end

-- UPDATE LOOP (pake task.wait biar kompatibel Delta)
game:GetService("RunService").Heartbeat:Connect(function()
    updateUI()
end)

print("✅ PREDIKSI PANEN LOADED!")