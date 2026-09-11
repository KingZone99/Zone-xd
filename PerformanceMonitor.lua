--[[
    PERFORMANCE MONITOR GUI - Roblox LocalScript
    ------------------------------------------------
    Fitur:
    - FPS Counter (real-time)
    - Ping / Latency (ms)
    - Memory Usage (MB)
    - Status koneksi (Bagus / Sedang / Buruk) berdasarkan ping
    - Bisa di-drag pindah posisi
    - Bisa di-minimize jadi bulatan kecil bertuliskan "M"
    - Klik lagi bulatan "M" untuk expand balik

    CARA PAKAI:
    1. Taruh script ini di StarterPlayer > StarterPlayerScripts
    2. Pastikan tipe script-nya "LocalScript"
    3. Jalankan game, GUI otomatis muncul di pojok kiri atas
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local settingsSvc = settings()

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============ SETUP GUI ============
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PerformanceMonitor"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Frame utama (panel penuh)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 190, 0, 340)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 80, 90)
stroke.Thickness = 1
stroke.Parent = mainFrame

-- Header (buat drag + tombol minimize)
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 28)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -34, 1, 0)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Monitor"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = header

-- Tombol minimize
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
minimizeBtn.Position = UDim2.new(1, -28, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.Parent = header

local minBtnCorner = Instance.new("UICorner")
minBtnCorner.CornerRadius = UDim.new(0, 6)
minBtnCorner.Parent = minimizeBtn

-- Container isi statistik
local statsHolder = Instance.new("Frame")
statsHolder.Size = UDim2.new(1, -16, 1, -36)
statsHolder.Position = UDim2.new(0, 8, 0, 32)
statsHolder.BackgroundTransparency = 1
statsHolder.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = statsHolder

-- Fungsi bikin baris label statistik
local function createStatLabel(name)
    local lbl = Instance.new("TextLabel")
    lbl.Name = name
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = name .. ": --"
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = statsHolder
    return lbl
end

local fpsLabel = createStatLabel("FPS")
local pingLabel = createStatLabel("Ping")
local memLabel = createStatLabel("Memory")
local statusLabel = createStatLabel("Status")
local playersLabel = createStatLabel("Players")
local timeLabel = createStatLabel("Waktu Main")

-- Baris tombol Low / High Graphics
local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1, 0, 0, 26)
btnRow.BackgroundTransparency = 1
btnRow.Parent = statsHolder

local lowGfxBtn = Instance.new("TextButton")
lowGfxBtn.Size = UDim2.new(0.48, 0, 1, 0)
lowGfxBtn.Position = UDim2.new(0, 0, 0, 0)
lowGfxBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
lowGfxBtn.Text = "Low FPS Boost"
lowGfxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
lowGfxBtn.Font = Enum.Font.GothamBold
lowGfxBtn.TextSize = 11
lowGfxBtn.Parent = btnRow

local lowGfxCorner = Instance.new("UICorner")
lowGfxCorner.CornerRadius = UDim.new(0, 6)
lowGfxCorner.Parent = lowGfxBtn

local highGfxBtn = Instance.new("TextButton")
highGfxBtn.Size = UDim2.new(0.48, 0, 1, 0)
highGfxBtn.Position = UDim2.new(0.52, 0, 0, 0)
highGfxBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
highGfxBtn.Text = "High Graphics"
highGfxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
highGfxBtn.Font = Enum.Font.GothamBold
highGfxBtn.TextSize = 11
highGfxBtn.Parent = btnRow

local highGfxCorner = Instance.new("UICorner")
highGfxCorner.CornerRadius = UDim.new(0, 6)
highGfxCorner.Parent = highGfxBtn

-- Tombol Auto Low Graphics (otomatis nurunin grafik kalau FPS drop)
local autoGfxBtn = Instance.new("TextButton")
autoGfxBtn.Size = UDim2.new(1, 0, 0, 22)
autoGfxBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
autoGfxBtn.Text = "Auto Low Graphics: OFF"
autoGfxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoGfxBtn.Font = Enum.Font.GothamBold
autoGfxBtn.TextSize = 11
autoGfxBtn.Parent = statsHolder

local autoGfxCorner = Instance.new("UICorner")
autoGfxCorner.CornerRadius = UDim.new(0, 6)
autoGfxCorner.Parent = autoGfxBtn

-- Mini grafik history FPS (bar chart sederhana)
local graphFrame = Instance.new("Frame")
graphFrame.Size = UDim2.new(1, 0, 0, 50)
graphFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
graphFrame.BorderSizePixel = 0
graphFrame.Parent = statsHolder

local graphCorner = Instance.new("UICorner")
graphCorner.CornerRadius = UDim.new(0, 6)
graphCorner.Parent = graphFrame

local GRAPH_BARS = 20
local fpsHistory = {}
local graphBars = {}

for i = 1, GRAPH_BARS do
    fpsHistory[i] = 0
    local bar = Instance.new("Frame")
    bar.AnchorPoint = Vector2.new(0, 1)
    bar.Position = UDim2.new((i - 1) / GRAPH_BARS, 1, 1, -2)
    bar.Size = UDim2.new(1 / GRAPH_BARS, -2, 0, 2)
    bar.BackgroundColor3 = Color3.fromRGB(100, 255, 120)
    bar.BorderSizePixel = 0
    bar.Parent = graphFrame
    graphBars[i] = bar
end

local function updateGraph(fps)
    table.remove(fpsHistory, 1)
    table.insert(fpsHistory, fps)

    -- Skala tinggi bar berdasarkan FPS maksimal 60
    for i, value in ipairs(fpsHistory) do
        local heightScale = math.clamp(value / 60, 0.03, 1)
        local bar = graphBars[i]
        bar.Size = UDim2.new(1 / GRAPH_BARS, -2, heightScale, 0)
        if value >= 50 then
            bar.BackgroundColor3 = Color3.fromRGB(100, 255, 120)
        elseif value >= 25 then
            bar.BackgroundColor3 = Color3.fromRGB(255, 220, 100)
        else
            bar.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
end

-- ============ BULATAN MINIMIZE ("M") ============
local bubble = Instance.new("Frame")
bubble.Name = "Bubble"
bubble.Size = UDim2.new(0, 46, 0, 46)
bubble.Position = mainFrame.Position
bubble.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
bubble.Visible = false
bubble.Active = true
bubble.Parent = screenGui

local bubbleCorner = Instance.new("UICorner")
bubbleCorner.CornerRadius = UDim.new(1, 0)
bubbleCorner.Parent = bubble

local bubbleStroke = Instance.new("UIStroke")
bubbleStroke.Color = Color3.fromRGB(90, 90, 100)
bubbleStroke.Thickness = 1
bubbleStroke.Parent = bubble

local bubbleText = Instance.new("TextButton")
bubbleText.Size = UDim2.new(1, 0, 1, 0)
bubbleText.BackgroundTransparency = 1
bubbleText.Text = "M"
bubbleText.TextColor3 = Color3.fromRGB(255, 255, 255)
bubbleText.Font = Enum.Font.GothamBold
bubbleText.TextSize = 20
bubbleText.Parent = bubble

-- ============ FUNGSI DRAG (dipakai di header dan bubble) ============
local function makeDraggable(frameToMove, dragHandle)
    local dragging = false
    local dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frameToMove.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frameToMove.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(mainFrame, header)
makeDraggable(bubble, bubbleText)

-- ============ TOGGLE MINIMIZE / EXPAND ============
local isMinimized = false

local function setMinimized(state)
    isMinimized = state
    if state then
        bubble.Position = mainFrame.Position
        mainFrame.Visible = false
        bubble.Visible = true
    else
        mainFrame.Position = bubble.Position
        bubble.Visible = false
        mainFrame.Visible = true
    end
end

minimizeBtn.MouseButton1Click:Connect(function()
    setMinimized(true)
end)

bubbleText.MouseButton1Click:Connect(function()
    setMinimized(false)
end)

-- ============ KEYBIND SHOW / HIDE PANEL ============
-- Tekan RightShift buat sembunyiin / munculin seluruh panel (termasuk bubble)
local panelHidden = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        panelHidden = not panelHidden
        screenGui.Enabled = not panelHidden
    end
end)

-- ============ FITUR TURUN / NAIKIN GRAFIK ============
-- Simpan setting asli biar bisa dikembalikan pas klik "High Graphics"
local originalQuality = settingsSvc.Rendering.QualityLevel
local originalGlobalShadows = Lighting.GlobalShadows
local originalFogEnd = Lighting.FogEnd
local originalBrightness = Lighting.Brightness

local function setLowGraphics()
    -- Turunin quality level render Roblox ke paling rendah (mengurangi beban GPU)
    pcall(function()
        settingsSvc.Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
    -- Matiin efek berat lain
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000 -- jauhin fog biar ga ganggu jarak pandang
    for _, inst in ipairs(Lighting:GetDescendants()) do
        if inst:IsA("BlurEffect") or inst:IsA("DepthOfFieldEffect")
            or inst:IsA("SunRaysEffect") or inst:IsA("BloomEffect")
            or inst:IsA("ColorCorrectionEffect") then
            inst.Enabled = false
        end
    end
    lowGfxBtn.Text = "Low Graphics: ON"
    lowGfxBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 90)
    highGfxBtn.Text = "High Graphics"
    highGfxBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
end

local function setHighGraphics()
    -- Balikin ke quality level tertinggi yang didukung device
    pcall(function()
        settingsSvc.Rendering.QualityLevel = Enum.QualityLevel.Level21
    end)
    Lighting.GlobalShadows = true
    Lighting.FogEnd = originalFogEnd
    for _, inst in ipairs(Lighting:GetDescendants()) do
        if inst:IsA("BlurEffect") or inst:IsA("DepthOfFieldEffect")
            or inst:IsA("SunRaysEffect") or inst:IsA("BloomEffect")
            or inst:IsA("ColorCorrectionEffect") then
            inst.Enabled = true
        end
    end
    highGfxBtn.Text = "High Graphics: ON"
    highGfxBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 90)
    lowGfxBtn.Text = "Low FPS Boost"
    lowGfxBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
end

lowGfxBtn.MouseButton1Click:Connect(setLowGraphics)
highGfxBtn.MouseButton1Click:Connect(setHighGraphics)

-- ============ AUTO LOW GRAPHICS ============
local autoGfxEnabled = false
local autoGfxActive = false -- lagi aktif nurunin grafik gara-gara FPS drop
local AUTO_GFX_THRESHOLD = 25 -- kalau FPS di bawah ini, otomatis turunin grafik
local AUTO_GFX_RECOVER = 40   -- kalau FPS udah di atas ini lagi, boleh balik ke high

autoGfxBtn.MouseButton1Click:Connect(function()
    autoGfxEnabled = not autoGfxEnabled
    if autoGfxEnabled then
        autoGfxBtn.Text = "Auto Low Graphics: ON"
        autoGfxBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 90)
    else
        autoGfxBtn.Text = "Auto Low Graphics: OFF"
        autoGfxBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        autoGfxActive = false
    end
end)

local function checkAutoGraphics(fps)
    if not autoGfxEnabled then return end

    if fps < AUTO_GFX_THRESHOLD and not autoGfxActive then
        autoGfxActive = true
        setLowGraphics()
    elseif fps > AUTO_GFX_RECOVER and autoGfxActive then
        autoGfxActive = false
        setHighGraphics()
    end
end

-- ============ LOGIKA UPDATE STATISTIK ============

-- FPS
local frameCount = 0
local fpsTimer = 0
local currentFPS = 0

RunService.RenderStepped:Connect(function(dt)
    frameCount = frameCount + 1
    fpsTimer = fpsTimer + dt
    if fpsTimer >= 1 then
        currentFPS = frameCount
        frameCount = 0
        fpsTimer = 0
    end
end)

-- Waktu main (dari script mulai jalan)
local sessionStartTime = os.clock()

local function formatPlayTime(seconds)
    local totalSec = math.floor(seconds)
    local h = math.floor(totalSec / 3600)
    local m = math.floor((totalSec % 3600) / 60)
    local s = totalSec % 60
    if h > 0 then
        return string.format("%dj %02dm %02ds", h, m, s)
    else
        return string.format("%02dm %02ds", m, s)
    end
end

-- Update semua label tiap 0.5 detik
task.spawn(function()
    while true do
        -- FPS
        fpsLabel.Text = "FPS: " .. tostring(currentFPS)
        if currentFPS >= 50 then
            fpsLabel.TextColor3 = Color3.fromRGB(100, 255, 120)
        elseif currentFPS >= 25 then
            fpsLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
        else
            fpsLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end

        updateGraph(currentFPS)
        checkAutoGraphics(currentFPS)

        -- Ping
        local ping = 0
        local success = pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        if not success then ping = -1 end

        pingLabel.Text = "Ping: " .. (ping >= 0 and (tostring(ping) .. " ms") or "N/A")

        -- Memory (MB)
        local memMB = math.floor(Stats:GetTotalMemoryUsageMb())
        memLabel.Text = "Memory: " .. tostring(memMB) .. " MB"

        -- Status koneksi berdasarkan ping
        local statusText, statusColor
        if ping < 0 then
            statusText, statusColor = "Unknown", Color3.fromRGB(180, 180, 180)
        elseif ping <= 80 then
            statusText, statusColor = "Bagus", Color3.fromRGB(100, 255, 120)
        elseif ping <= 200 then
            statusText, statusColor = "Sedang", Color3.fromRGB(255, 220, 100)
        else
            statusText, statusColor = "Buruk", Color3.fromRGB(255, 100, 100)
        end
        statusLabel.Text = "Status: " .. statusText
        statusLabel.TextColor3 = statusColor

        -- Jumlah player & waktu main
        playersLabel.Text = "Players: " .. tostring(#Players:GetPlayers())
        timeLabel.Text = "Waktu: " .. formatPlayTime(os.clock() - sessionStartTime)

        task.wait(0.5)
    end
end)
