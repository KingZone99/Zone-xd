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

-- ============ KEY HARIAN (kunci ganti tiap hari) ============
-- Nama hari harus diketik sesuai hari ini (Senin, Selasa, Rabu, dst)
-- Catatan: os.date di Roblox biasanya berbasis waktu server/UTC, jadi kalau
-- lagi mepet tengah malam ada kemungkinan beda 1 hari sama jam HP kamu.
local DAY_NAMES = {
    [1] = "Minggu", [2] = "Senin", [3] = "Selasa", [4] = "Rabu",
    [5] = "Kamis", [6] = "Jumat", [7] = "Sabtu",
}
local todayName = DAY_NAMES[tonumber(os.date("*t").wday)] or "Senin"

local lockOverlay = Instance.new("Frame")
lockOverlay.Name = "LockOverlay"
lockOverlay.Size = UDim2.new(1, 0, 1, 0)
lockOverlay.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
lockOverlay.BackgroundTransparency = 0.15
lockOverlay.ZIndex = 100
lockOverlay.Active = true
lockOverlay.Parent = screenGui

local lockBox = Instance.new("Frame")
lockBox.Size = UDim2.new(0, 220, 0, 150)
lockBox.AnchorPoint = Vector2.new(0.5, 0.5)
lockBox.Position = UDim2.new(0.5, 0, 0.5, 0)
lockBox.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
lockBox.ZIndex = 101
lockBox.Parent = lockOverlay

local lockBoxCorner = Instance.new("UICorner")
lockBoxCorner.CornerRadius = UDim.new(0, 10)
lockBoxCorner.Parent = lockBox

local lockTitle = Instance.new("TextLabel")
lockTitle.Size = UDim2.new(1, -16, 0, 24)
lockTitle.Position = UDim2.new(0, 8, 0, 10)
lockTitle.BackgroundTransparency = 1
lockTitle.Text = "Masukkan Key Hari Ini"
lockTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
lockTitle.Font = Enum.Font.GothamBold
lockTitle.TextSize = 14
lockTitle.ZIndex = 102
lockTitle.Parent = lockBox

local lockHint = Instance.new("TextLabel")
lockHint.Size = UDim2.new(1, -16, 0, 18)
lockHint.Position = UDim2.new(0, 8, 0, 34)
lockHint.BackgroundTransparency = 1
lockHint.Text = "Key = nama hari ini (contoh: Senin)"
lockHint.TextColor3 = Color3.fromRGB(160, 160, 170)
lockHint.Font = Enum.Font.Gotham
lockHint.TextSize = 11
lockHint.ZIndex = 102
lockHint.Parent = lockBox

local lockInput = Instance.new("TextBox")
lockInput.Size = UDim2.new(1, -16, 0, 32)
lockInput.Position = UDim2.new(0, 8, 0, 58)
lockInput.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
lockInput.Text = ""
lockInput.PlaceholderText = "Ketik nama hari..."
lockInput.TextColor3 = Color3.fromRGB(255, 255, 255)
lockInput.PlaceholderColor3 = Color3.fromRGB(140, 140, 150)
lockInput.Font = Enum.Font.Gotham
lockInput.TextSize = 14
lockInput.ClearTextOnFocus = false
lockInput.ZIndex = 102
lockInput.Parent = lockBox

local lockInputCorner = Instance.new("UICorner")
lockInputCorner.CornerRadius = UDim.new(0, 6)
lockInputCorner.Parent = lockInput

local lockError = Instance.new("TextLabel")
lockError.Size = UDim2.new(1, -16, 0, 16)
lockError.Position = UDim2.new(0, 8, 0, 92)
lockError.BackgroundTransparency = 1
lockError.Text = ""
lockError.TextColor3 = Color3.fromRGB(255, 100, 100)
lockError.Font = Enum.Font.Gotham
lockError.TextSize = 11
lockError.ZIndex = 102
lockError.Parent = lockBox

local lockSubmitBtn = Instance.new("TextButton")
lockSubmitBtn.Size = UDim2.new(1, -16, 0, 28)
lockSubmitBtn.Position = UDim2.new(0, 8, 0, 112)
lockSubmitBtn.BackgroundColor3 = Color3.fromRGB(80, 130, 90)
lockSubmitBtn.Text = "Buka"
lockSubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
lockSubmitBtn.Font = Enum.Font.GothamBold
lockSubmitBtn.TextSize = 13
lockSubmitBtn.ZIndex = 102
lockSubmitBtn.Parent = lockBox

local lockSubmitCorner = Instance.new("UICorner")
lockSubmitCorner.CornerRadius = UDim.new(0, 6)
lockSubmitCorner.Parent = lockSubmitBtn

local function tryUnlock()
    local guess = lockInput.Text:gsub("^%s+", ""):gsub("%s+$", "") -- trim spasi
    if guess:lower() == todayName:lower() then
        lockOverlay:Destroy()
    else
        lockError.Text = "Key salah! Hari ini: coba lagi"
        lockInput.Text = ""
    end
end

lockSubmitBtn.MouseButton1Click:Connect(tryUnlock)
lockInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        tryUnlock()
    end
end)

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

-- Daftar umur akun Roblox pemain lain (data publik, bukan cheat/ESP)
local playerListTitle = Instance.new("TextLabel")
playerListTitle.Size = UDim2.new(1, 0, 0, 16)
playerListTitle.BackgroundTransparency = 1
playerListTitle.Text = "Umur Akun Pemain:"
playerListTitle.TextColor3 = Color3.fromRGB(200, 200, 210)
playerListTitle.Font = Enum.Font.GothamBold
playerListTitle.TextSize = 11
playerListTitle.TextXAlignment = Enum.TextXAlignment.Left
playerListTitle.LayoutOrder = nextOrder()
playerListTitle.Parent = statsHolder

local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(1, 0, 0, 0)
playerListFrame.AutomaticSize = Enum.AutomaticSize.Y
playerListFrame.BackgroundTransparency = 1
playerListFrame.LayoutOrder = nextOrder()
playerListFrame.Parent = statsHolder

local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Padding = UDim.new(0, 2)
playerListLayout.Parent = playerListFrame

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

-- Tombol Zoom Unlimited (zoom out sejauh mungkin, gak dibatasi default game)
local zoomBtn = Instance.new("TextButton")
zoomBtn.Size = UDim2.new(1, 0, 0, 22)
zoomBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
zoomBtn.Text = "Zoom Unlimited: OFF"
zoomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
zoomBtn.Font = Enum.Font.GothamBold
zoomBtn.TextSize = 11
zoomBtn.LayoutOrder = nextOrder()
zoomBtn.Parent = statsHolder

local zoomBtnCorner = Instance.new("UICorner")
zoomBtnCorner.CornerRadius = UDim.new(0, 6)
zoomBtnCorner.Parent = zoomBtn

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

-- ============ SOUND EFFECT PER PRESET ============
-- Sound klik/swoosh pas ganti preset (pakai suara bawaan Roblox, dijamin ada & pasti bunyi)
local SoundService = game:GetService("SoundService")

local switchClickSound = Instance.new("Sound")
switchClickSound.Name = "PM_SwitchClick"
switchClickSound.SoundId = "rbxasset://sounds/button.wav"
switchClickSound.Volume = 0.5
switchClickSound.Parent = SoundService

-- Ambience per preset (loop). SoundId sengaja dikosongkan/placeholder karena
-- Asset ID di Roblox Library gampang kena moderasi/dihapus -- kalau aku asal
-- comot nomor, resikonya malah gak bunyi atau ke-report. Silakan isi sendiri
-- SoundId di bawah ini dengan ID dari Toolbox (cari: "rain ambience",
-- "wind loop", "night crickets", "retro chiptune", dst) sesuai selera kamu.
local ambienceSound = Instance.new("Sound")
ambienceSound.Name = "PM_Ambience"
ambienceSound.Looped = true
ambienceSound.Volume = 0.4
ambienceSound.Parent = SoundService

local presetAmbienceIds = {
    ["Ringan (Low)"] = "", -- kosong = senyap (biar hemat performa)
    ["HD Default"] = "",
    ["Retro"] = "", -- isi sendiri ID chiptune/8-bit dari Toolbox Studio (tab Audio)
    ["Sunset"] = "", -- isi sendiri ID ambience sore/burung dari Toolbox Studio
    ["Salju"] = "", -- isi sendiri ID angin salju dari Toolbox Studio
    ["Malam"] = "", -- isi sendiri ID jangkrik malam dari Toolbox Studio
    ["Hujan"] = "1516791621", -- suara hujan resmi dari contoh dokumentasi Roblox (Add 3D Audio)
}

local function playPresetAmbience(presetName)
    local id = presetAmbienceIds[presetName]
    if id and id ~= "" then
        ambienceSound.SoundId = "rbxassetid://" .. id
        ambienceSound:Play()
    else
        ambienceSound:Stop()
    end
end

local function playSwitchClick()
    switchClickSound:Play()
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
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
            atmosphere.Density = 0.3
            atmosphere.Haze = 1
            atmosphere.Color = Color3.fromRGB(199, 199, 199)
            atmosphere.Decay = Color3.fromRGB(92, 60, 13)
            atmosphere.Glare = 0.1
            resetEffectsOff()
            bloom.Enabled = true
            bloom.Intensity = 0.6
            bloom.Size = 24
            sunRays.Enabled = true
            sunRays.Intensity = 0.2
            sunRays.Spread = 0.6
            colorCorrect.Enabled = true
            colorCorrect.Saturation = 0.1
            colorCorrect.Contrast = 0.1
            depthOfField.Enabled = true
            depthOfField.FarIntensity = 0.15
            depthOfField.InFocusRadius = 60
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
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
            atmosphere.Density = 0.4
            atmosphere.Haze = 2
            atmosphere.Color = Color3.fromRGB(255, 170, 120)
            atmosphere.Decay = Color3.fromRGB(150, 70, 40)
            atmosphere.Glare = 0.3
            resetEffectsOff()
            bloom.Enabled = true
            bloom.Intensity = 0.9
            bloom.Size = 32
            sunRays.Enabled = true
            sunRays.Intensity = 0.5
            sunRays.Spread = 0.8
            colorCorrect.Enabled = true
            colorCorrect.TintColor = Color3.fromRGB(255, 200, 160)
            colorCorrect.Saturation = 0.2
            colorCorrect.Contrast = 0.1
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
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
            atmosphere.Density = 0.5
            atmosphere.Haze = 3
            atmosphere.Color = Color3.fromRGB(240, 245, 255)
            atmosphere.Decay = Color3.fromRGB(210, 220, 230)
            atmosphere.Glare = 0.1
            resetEffectsOff()
            bloom.Enabled = true
            bloom.Intensity = 0.5
            bloom.Size = 20
            colorCorrect.Enabled = true
            colorCorrect.TintColor = Color3.fromRGB(220, 235, 255)
            colorCorrect.Brightness = 0.08
            colorCorrect.Saturation = -0.1
            depthOfField.Enabled = true
            depthOfField.FarIntensity = 0.1
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
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
            atmosphere.Density = 0.35
            atmosphere.Haze = 1
            atmosphere.Color = Color3.fromRGB(80, 90, 120)
            atmosphere.Decay = Color3.fromRGB(20, 25, 40)
            atmosphere.Glare = 0
            resetEffectsOff()
            bloom.Enabled = true
            bloom.Intensity = 0.7
            bloom.Size = 28
            colorCorrect.Enabled = true
            colorCorrect.TintColor = Color3.fromRGB(180, 190, 255)
            colorCorrect.Brightness = -0.1
            colorCorrect.Contrast = 0.15
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
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
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
            depthOfField.FarIntensity = 0.35
            depthOfField.InFocusRadius = 40
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
    playSwitchClick()
    playPresetAmbience(presets[index].name)
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

-- ============ ZOOM UNLIMITED ============
local originalMaxZoom = player.CameraMaxZoomDistance
local zoomUnlimited = false
local ZOOM_UNLIMITED_VALUE = 100000 -- jauh lebih dari cukup, dijaga finite biar kamera gak error

zoomBtn.MouseButton1Click:Connect(function()
    zoomUnlimited = not zoomUnlimited
    if zoomUnlimited then
        player.CameraMaxZoomDistance = ZOOM_UNLIMITED_VALUE
        zoomBtn.Text = "Zoom Unlimited: ON"
        zoomBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 90)
    else
        player.CameraMaxZoomDistance = originalMaxZoom
        zoomBtn.Text = "Zoom Unlimited: OFF"
        zoomBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    end
end)

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

-- ============ DAFTAR UMUR AKUN PEMAIN LAIN ============
-- AccountAge itu properti PUBLIK yang direplikasi Roblox ke semua client,
-- bukan data rahasia/hidden -- makanya ini bisa dibaca tanpa server script,
-- beda sama FPS/ping yang emang cuma ada di device masing-masing.
local playerRowLabels = {}

local function refreshPlayerList()
    -- Bersihin label lama
    for _, lbl in pairs(playerRowLabels) do
        lbl:Destroy()
    end
    playerRowLabels = {}

    for _, ply in ipairs(Players:GetPlayers()) do
        local row = Instance.new("TextLabel")
        row.Size = UDim2.new(1, 0, 0, 16)
        row.BackgroundTransparency = 1
        row.Text = ply.Name .. ": " .. formatAccountAge(ply.AccountAge)
        row.TextColor3 = Color3.fromRGB(190, 190, 200)
        row.Font = Enum.Font.Gotham
        row.TextSize = 11
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.TextTruncate = Enum.TextTruncate.AtEnd
        row.Parent = playerListFrame
        table.insert(playerRowLabels, row)
    end
end

refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
task.spawn(function()
    while true do
        task.wait(5)
        refreshPlayerList() -- refresh berkala biar umur akun kebaca kalau ada yg baru masuk
    end
end)

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
