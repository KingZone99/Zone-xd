--[[
    PERFORMANCE MONITOR GUI - Roblox LocalScript (v2 - Compact + Preset Grafik)
    ------------------------------------------------
    Fitur:
    - FPS, Ping, Memory, Status koneksi, jumlah player, waktu main
    - Grafik mini history FPS
    - Auto Low Graphics kalau FPS drop
    - Preset Grafik: Ringan, HD Default, Retro, Sunset, Salju, Malam, Hujan
    - Panel bisa di-drag, di-minimize jadi bulatan "M"
    - Keybind RightShift buat show/hide panel
    - FIX: panel sekarang di bawah topbar Roblox (gak ketutupan lagi)
    - FIX: panel dibikin compact + scrollable biar gak kepanjangan

    CARA PAKAI:
    1. Taruh script ini di StarterPlayer > StarterPlayerScripts
    2. Pastikan tipe script-nya "LocalScript"
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local settingsSvc = settings()

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============ SETUP GUI ============
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PerformanceMonitor"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = false -- FIX: biar otomatis di bawah topbar Roblox, gak ketutupan lagi
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Frame utama (tinggi FIXED, isi di dalamnya scroll)
local PANEL_WIDTH = 190
local PANEL_HEIGHT = 230 -- FIX: tinggi tetap, gak nambah panjang terus

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, PANEL_WIDTH, 0, PANEL_HEIGHT)
mainFrame.Position = UDim2.new(0, 16, 0, 10) -- posisi aman, sudah di bawah topbar karena IgnoreGuiInset=false
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 80, 90)
stroke.Thickness = 1
stroke.Parent = mainFrame

-- Header (drag + tombol minimize) -- ZIndex tinggi biar selalu bisa dipencet
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 28)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
header.BorderSizePixel = 0
header.ZIndex = 5
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
title.ZIndex = 6
title.Parent = header

-- Tombol minimize (diperbesar area klik + ZIndex tinggi biar PASTI kepencet)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -30, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
minimizeBtn.ZIndex = 10
minimizeBtn.AutoButtonColor = true
minimizeBtn.Parent = header

local minBtnCorner = Instance.new("UICorner")
minBtnCorner.CornerRadius = UDim.new(0, 6)
minBtnCorner.Parent = minimizeBtn

-- ============ ISI (SCROLLABLE) ============
local statsHolder = Instance.new("ScrollingFrame")
statsHolder.Size = UDim2.new(1, -12, 1, -34)
statsHolder.Position = UDim2.new(0, 6, 0, 30)
statsHolder.BackgroundTransparency = 1
statsHolder.BorderSizePixel = 0
statsHolder.ScrollBarThickness = 4
statsHolder.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 160)
statsHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
statsHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
statsHolder.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = statsHolder

local orderCounter = 0
local function nextOrder()
    orderCounter = orderCounter + 1
    return orderCounter
end

local function createStatLabel(name)
    local lbl = Instance.new("TextLabel")
    lbl.Name = name
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.Text = name .. ": --"
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = nextOrder()
    lbl.Parent = statsHolder
    return lbl
end

local fpsLabel = createStatLabel("FPS")
local pingLabel = createStatLabel("Ping")
local memLabel = createStatLabel("Memory")
local statusLabel = createStatLabel("Status")
local playersLabel = createStatLabel("Players")
local timeLabel = createStatLabel("Waktu Main")
local deviceLabel = createStatLabel("Device")
local accountAgeLabel = createStatLabel("Main Roblox")
local serverLabel = createStatLabel("Server")

-- Mini grafik history FPS
local graphFrame = Instance.new("Frame")
graphFrame.Size = UDim2.new(1, 0, 0, 40)
graphFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
graphFrame.BorderSizePixel = 0
graphFrame.LayoutOrder = nextOrder()
graphFrame.Parent = statsHolder

local graphCorner = Instance.new("UICorner")
graphCorner.CornerRadius = UDim.new(0, 6)
graphCorner.Parent = graphFrame

local GRAPH_BARS = 18
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

-- Tombol Preset Grafik (cycle: klik buat ganti ke preset berikutnya)
local presetBtn = Instance.new("TextButton")
presetBtn.Size = UDim2.new(1, 0, 0, 24)
presetBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
presetBtn.Text = "Preset: --"
presetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
presetBtn.Font = Enum.Font.GothamBold
presetBtn.TextSize = 12
presetBtn.LayoutOrder = nextOrder()
presetBtn.Parent = statsHolder

local presetBtnCorner = Instance.new("UICorner")
presetBtnCorner.CornerRadius = UDim.new(0, 6)
presetBtnCorner.Parent = presetBtn

-- Baris Favorit Preset: simpan preset sekarang & pakai lagi kapan aja (selama sesi ini)
local favRow = Instance.new("Frame")
favRow.Size = UDim2.new(1, 0, 0, 22)
favRow.BackgroundTransparency = 1
favRow.LayoutOrder = nextOrder()
favRow.Parent = statsHolder

local saveFavBtn = Instance.new("TextButton")
saveFavBtn.Size = UDim2.new(0.48, 0, 1, 0)
saveFavBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
saveFavBtn.Text = "☆ Simpan"
saveFavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveFavBtn.Font = Enum.Font.GothamBold
saveFavBtn.TextSize = 11
saveFavBtn.Parent = favRow

local saveFavCorner = Instance.new("UICorner")
saveFavCorner.CornerRadius = UDim.new(0, 6)
saveFavCorner.Parent = saveFavBtn

local loadFavBtn = Instance.new("TextButton")
loadFavBtn.Size = UDim2.new(0.48, 0, 1, 0)
loadFavBtn.Position = UDim2.new(0.52, 0, 0, 0)
loadFavBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
loadFavBtn.Text = "Pakai Favorit"
loadFavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loadFavBtn.Font = Enum.Font.GothamBold
loadFavBtn.TextSize = 11
loadFavBtn.Parent = favRow

local loadFavCorner = Instance.new("UICorner")
loadFavCorner.CornerRadius = UDim.new(0, 6)
loadFavCorner.Parent = loadFavBtn

-- Tombol Ganti Server (server hop)
local hopServerBtn = Instance.new("TextButton")
hopServerBtn.Size = UDim2.new(1, 0, 0, 22)
hopServerBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
hopServerBtn.Text = "Ganti Server"
hopServerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hopServerBtn.Font = Enum.Font.GothamBold
hopServerBtn.TextSize = 11
hopServerBtn.LayoutOrder = nextOrder()
hopServerBtn.Parent = statsHolder

local hopServerCorner = Instance.new("UICorner")
hopServerCorner.CornerRadius = UDim.new(0, 6)
hopServerCorner.Parent = hopServerBtn

-- Tombol Auto Low Graphics
local autoGfxBtn = Instance.new("TextButton")
autoGfxBtn.Size = UDim2.new(1, 0, 0, 22)
autoGfxBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
autoGfxBtn.Text = "Auto Low Graphics: OFF"
autoGfxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoGfxBtn.Font = Enum.Font.GothamBold
autoGfxBtn.TextSize = 11
autoGfxBtn.LayoutOrder = nextOrder()
autoGfxBtn.Parent = statsHolder

local autoGfxCorner = Instance.new("UICorner")
autoGfxCorner.CornerRadius = UDim.new(0, 6)
autoGfxCorner.Parent = autoGfxBtn

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

-- ============ TOAST NOTIFIKASI FPS DROP ============
local toast = Instance.new("Frame")
toast.Size = UDim2.new(0, 220, 0, 40)
toast.AnchorPoint = Vector2.new(0.5, 0)
toast.Position = UDim2.new(0.5, 0, 0, -50)
toast.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
toast.BackgroundTransparency = 0.1
toast.Visible = false
toast.ZIndex = 20
toast.Parent = screenGui

local toastCorner = Instance.new("UICorner")
toastCorner.CornerRadius = UDim.new(0, 8)
toastCorner.Parent = toast

local toastText = Instance.new("TextLabel")
toastText.Size = UDim2.new(1, -12, 1, 0)
toastText.Position = UDim2.new(0, 6, 0, 0)
toastText.BackgroundTransparency = 1
toastText.Text = "⚠ FPS drop parah!"
toastText.TextColor3 = Color3.fromRGB(255, 255, 255)
toastText.Font = Enum.Font.GothamBold
toastText.TextSize = 13
toastText.TextWrapped = true
toastText.ZIndex = 21
toastText.Parent = toast

local toastShowing = false
local function showToast(message)
    if toastShowing then return end
    toastShowing = true
    toastText.Text = message
    toast.Visible = true
    toast.Position = UDim2.new(0.5, 0, 0, -50)

    local slideIn = TweenService:Create(toast, TweenInfo.new(0.3), { Position = UDim2.new(0.5, 0, 0, 10) })
    slideIn:Play()

    task.delay(2.5, function()
        local slideOut = TweenService:Create(toast, TweenInfo.new(0.3), { Position = UDim2.new(0.5, 0, 0, -50) })
        slideOut:Play()
        slideOut.Completed:Wait()
        toast.Visible = false
        toastShowing = false
    end)
end

-- ============ FUNGSI DRAG ============
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
local panelHidden = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        panelHidden = not panelHidden
        screenGui.Enabled = not panelHidden
    end
end)

-- ============ PRESET GRAFIK (Ringan, HD, Retro, Sunset, Salju, Malam, Hujan) ============
-- Pastikan ada Atmosphere buat kontrol fog/kabut yang lebih modern
local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
if not atmosphere then
    atmosphere = Instance.new("Atmosphere")
    atmosphere.Parent = Lighting
end

-- Simpan efek visual (Bloom, SunRays, dll) atau bikin baru kalau belum ada
local function getOrCreateEffect(className, effectName)
    local existing = Lighting:FindFirstChild(effectName)
    if existing then return existing end
    local eff = Instance.new(className)
    eff.Name = effectName
    eff.Parent = Lighting
    return eff
end

local bloom = getOrCreateEffect("BloomEffect", "PM_Bloom")
local sunRays = getOrCreateEffect("SunRaysEffect", "PM_SunRays")
local colorCorrect = getOrCreateEffect("ColorCorrectionEffect", "PM_ColorCorrection")
local depthOfField = getOrCreateEffect("DepthOfFieldEffect", "PM_DepthOfField")

local function resetEffectsOff()
    bloom.Enabled = false
    sunRays.Enabled = false
    colorCorrect.Enabled = false
    depthOfField.Enabled = false
    colorCorrect.TintColor = Color3.new(1, 1, 1)
    colorCorrect.Saturation = 0
    colorCorrect.Contrast = 0
    colorCorrect.Brightness = 0
end

local presets = {
    {
        name = "Ringan (Low)",
        apply = function()
            pcall(function() settingsSvc.Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
            Lighting.Technology = Enum.Technology.Compatibility
            Lighting.GlobalShadows = false
            atmosphere.Density = 0
            atmosphere.Haze = 0
            resetEffectsOff()
            Lighting.ClockTime = 14
            Lighting.Brightness = 2
            Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
        end,
    },
    {
        name = "HD Default",
        apply = function()
            pcall(function() settingsSvc.Rendering.QualityLevel = Enum.QualityLevel.Level21 end)
            Lighting.Technology = Enum.Technology.Future
            Lighting.GlobalShadows = true
            atmosphere.Density = 0.3
            atmosphere.Haze = 1
            atmosphere.Color = Color3.fromRGB(199, 199, 199)
            atmosphere.Decay = Color3.fromRGB(92, 60, 13)
            atmosphere.Glare = 0.1
            resetEffectsOff()
            bloom.Enabled = true
            bloom.Intensity = 0.4
            sunRays.Enabled = true
            sunRays.Intensity = 0.15
            colorCorrect.Enabled = true
            colorCorrect.Saturation = 0.05
            colorCorrect.Contrast = 0.05
            Lighting.ClockTime = 14
            Lighting.Brightness = 3
            Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
        end,
    },
    {
        name = "Retro",
        apply = function()
            pcall(function() settingsSvc.Rendering.QualityLevel = Enum.QualityLevel.Level10 end)
            Lighting.Technology = Enum.Technology.Compatibility
            Lighting.GlobalShadows = false
            atmosphere.Density = 0
            atmosphere.Haze = 0
            resetEffectsOff()
            colorCorrect.Enabled = true
            colorCorrect.Saturation = -0.4
            colorCorrect.TintColor = Color3.fromRGB(255, 235, 200)
            colorCorrect.Contrast = 0.15
            Lighting.ClockTime = 14
            Lighting.Brightness = 2.5
            Lighting.OutdoorAmbient = Color3.fromRGB(160, 150, 130)
        end,
    },
    {
        name = "Sunset",
        apply = function()
            pcall(function() settingsSvc.Rendering.QualityLevel = Enum.QualityLevel.Level21 end)
            Lighting.Technology = Enum.Technology.Future
            Lighting.GlobalShadows = true
            atmosphere.Density = 0.4
            atmosphere.Haze = 2
            atmosphere.Color = Color3.fromRGB(255, 170, 120)
            atmosphere.Decay = Color3.fromRGB(150, 70, 40)
            atmosphere.Glare = 0.3
            resetEffectsOff()
            bloom.Enabled = true
            bloom.Intensity = 0.7
            sunRays.Enabled = true
            sunRays.Intensity = 0.35
            colorCorrect.Enabled = true
            colorCorrect.TintColor = Color3.fromRGB(255, 200, 160)
            colorCorrect.Saturation = 0.15
            Lighting.ClockTime = 18
            Lighting.Brightness = 2
            Lighting.OutdoorAmbient = Color3.fromRGB(180, 120, 90)
        end,
    },
    {
        name = "Salju",
        apply = function()
            pcall(function() settingsSvc.Rendering.QualityLevel = Enum.QualityLevel.Level21 end)
            Lighting.Technology = Enum.Technology.Future
            Lighting.GlobalShadows = true
            atmosphere.Density = 0.5
            atmosphere.Haze = 3
            atmosphere.Color = Color3.fromRGB(240, 245, 255)
            atmosphere.Decay = Color3.fromRGB(210, 220, 230)
            atmosphere.Glare = 0.1
            resetEffectsOff()
            bloom.Enabled = true
            bloom.Intensity = 0.3
            colorCorrect.Enabled = true
            colorCorrect.TintColor = Color3.fromRGB(220, 235, 255)
            colorCorrect.Brightness = 0.05
            colorCorrect.Saturation = -0.1
            Lighting.ClockTime = 12
            Lighting.Brightness = 3
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 210, 220)
        end,
    },
    {
        name = "Malam",
        apply = function()
            pcall(function() settingsSvc.Rendering.QualityLevel = Enum.QualityLevel.Level21 end)
            Lighting.Technology = Enum.Technology.Future
            Lighting.GlobalShadows = true
            atmosphere.Density = 0.35
            atmosphere.Haze = 1
            atmosphere.Color = Color3.fromRGB(80, 90, 120)
            atmosphere.Decay = Color3.fromRGB(20, 25, 40)
            atmosphere.Glare = 0
            resetEffectsOff()
            bloom.Enabled = true
            bloom.Intensity = 0.5
            colorCorrect.Enabled = true
            colorCorrect.TintColor = Color3.fromRGB(180, 190, 255)
            colorCorrect.Brightness = -0.1
            colorCorrect.Contrast = 0.1
            Lighting.ClockTime = 0
            Lighting.Brightness = 1
            Lighting.OutdoorAmbient = Color3.fromRGB(40, 45, 70)
        end,
    },
    {
        name = "Hujan",
        apply = function()
            pcall(function() settingsSvc.Rendering.QualityLevel = Enum.QualityLevel.Level21 end)
            Lighting.Technology = Enum.Technology.Future
            Lighting.GlobalShadows = true
            atmosphere.Density = 0.6
            atmosphere.Haze = 4
            atmosphere.Color = Color3.fromRGB(130, 140, 150)
            atmosphere.Decay = Color3.fromRGB(80, 85, 95)
            atmosphere.Glare = 0
            resetEffectsOff()
            colorCorrect.Enabled = true
            colorCorrect.TintColor = Color3.fromRGB(190, 200, 210)
            colorCorrect.Saturation = -0.25
            colorCorrect.Brightness = -0.05
            depthOfField.Enabled = true
            depthOfField.FarIntensity = 0.3
            Lighting.ClockTime = 15
            Lighting.Brightness = 1.5
            Lighting.OutdoorAmbient = Color3.fromRGB(110, 115, 125)
        end,
    },
}

local currentPresetIndex = 2 -- default "HD Default"

local function applyPresetByIndex(index)
    currentPresetIndex = index
    presets[index].apply()
    presetBtn.Text = "Preset: " .. presets[index].name
end

presetBtn.MouseButton1Click:Connect(function()
    local nextIndex = (currentPresetIndex % #presets) + 1
    applyPresetByIndex(nextIndex)
end)

applyPresetByIndex(currentPresetIndex) -- set HD Default pas awal jalan

-- ============ AUTO LOW GRAPHICS ============
local autoGfxEnabled = false
local autoGfxActive = false
local presetBeforeAuto = currentPresetIndex
local AUTO_GFX_THRESHOLD = 25
local AUTO_GFX_RECOVER = 40

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
        presetBeforeAuto = currentPresetIndex
        applyPresetByIndex(1) -- "Ringan (Low)"
    elseif fps > AUTO_GFX_RECOVER and autoGfxActive then
        autoGfxActive = false
        applyPresetByIndex(presetBeforeAuto)
    end
end

-- ============ FAVORIT PRESET (tersimpan selama sesi ini berjalan) ============
local favoritePresetIndex = nil

saveFavBtn.MouseButton1Click:Connect(function()
    favoritePresetIndex = currentPresetIndex
    saveFavBtn.Text = "☆ Tersimpan!"
    task.delay(1, function()
        saveFavBtn.Text = "☆ Simpan"
    end)
end)

loadFavBtn.MouseButton1Click:Connect(function()
    if favoritePresetIndex then
        applyPresetByIndex(favoritePresetIndex)
    else
        loadFavBtn.Text = "Belum ada!"
        task.delay(1, function()
            loadFavBtn.Text = "Pakai Favorit"
        end)
    end
end)

-- ============ GANTI SERVER (server hop) ============
hopServerBtn.MouseButton1Click:Connect(function()
    hopServerBtn.Text = "Mencari server..."
    local success = pcall(function()
        TeleportService:Teleport(game.PlaceId, player)
    end)
    if not success then
        hopServerBtn.Text = "Gagal, coba lagi"
        task.delay(2, function()
            hopServerBtn.Text = "Ganti Server"
        end)
    end
end)

-- ============ INFO DEVICE ============
local function getDeviceType()
    if GuiService:IsTenFootInterface() then
        return "Console"
    elseif UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        return "Mobile/Tablet"
    elseif UserInputService.TouchEnabled and UserInputService.KeyboardEnabled then
        return "Hybrid (Touch+KB)"
    else
        return "PC/Desktop"
    end
end
deviceLabel.Text = "Device: " .. getDeviceType()

-- ============ UMUR AKUN ROBLOX (sudah berapa lama main Roblox) ============
local function formatAccountAge(days)
    local years = math.floor(days / 365)
    local months = math.floor((days % 365) / 30)
    if years > 0 then
        return string.format("%d thn %d bln (%d hari)", years, months, days)
    elseif months > 0 then
        return string.format("%d bulan (%d hari)", months, days)
    else
        return string.format("%d hari", days)
    end
end
accountAgeLabel.Text = "Main Roblox: " .. formatAccountAge(player.AccountAge)

-- ============ INFO SERVER ============
local shortJobId = game.JobId ~= "" and string.sub(game.JobId, 1, 8) or "Studio"
serverLabel.Text = "Server: " .. shortJobId

-- ============ LOGIKA UPDATE STATISTIK ============
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

task.spawn(function()
    while true do
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

        -- Notifikasi kalau FPS anjlok parah
        if currentFPS > 0 and currentFPS < 12 then
            showToast("⚠ FPS drop parah! Sekarang " .. currentFPS .. " FPS")
        end

        local ping = 0
        local success = pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        if not success then ping = -1 end
        pingLabel.Text = "Ping: " .. (ping >= 0 and (tostring(ping) .. " ms") or "N/A")

        local memMB = math.floor(Stats:GetTotalMemoryUsageMb())
        memLabel.Text = "Memory: " .. tostring(memMB) .. " MB"

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

        playersLabel.Text = "Players: " .. tostring(#Players:GetPlayers())
        timeLabel.Text = "Waktu: " .. formatPlayTime(os.clock() - sessionStartTime)

        task.wait(0.5)
    end
end)
