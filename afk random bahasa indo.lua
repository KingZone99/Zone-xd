-- AFK NPC V2 - CHAT BAHASA INDONESIA SUPER RANDOM
-- COPYRIGHT: APIS (USER 01) - ZONE XD V1

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Settings AFK
local afkEnabled = false
local chatEnabled = false
local walkSpeed = 16
local moveRadius = 30
local currentAction = "Idle"
local tableMinimized = false

-- ==================================================
-- CHAT BAHASA INDONESIA SUPER RANDOM (50+ VARIASI)
-- ==================================================
local chatMessages = {
    -- SAPAAN (10)
    "halo semua", "hai gaes", "selamat pagi", "selamat siang", "selamat malam",
    "apa kabar", "hai teman-teman", "halo guys", "selamat datang", "hai semua",
    
    -- NANYA KABAR (10)
    "lagi apa", "lagi ngapain", "main apa", "lagi dimana", "ada apa",
    "kabar baik", "gimana kabarnya", "lagi sibuk", "ada yang bisa dibantu", "lagi santai",
    
    -- PIN / MINTA (10)
    "pin dong", "ada yang punya pin", "minta pin", "pin bos", "share pin",
    "pin dong bang", "ada pin ga", "bagi pin dong", "mau pin", "butuh pin",
    "pin nomor berapa", "pin lu berapa", "kasih pin dong", "tolong pin", "minta tolong pin",
    
    -- RANDOM / GAUL (10)
    "capek main terus", "lagi afk nih", "jangan lupa subscribe", "zone xd terbaik",
    "gass terus", "mantap jiwa", "santuy bro", "gaskeun", "wuih keren", "asik juga",
    "seru abis", "gokil", "wkwkwk", "lucu banget", "geje",
    
    -- TANYA JAWAB (10)
    "udah makan belum", "mandi dulu ah", "main sampai pagi", "seru juga game ini",
    "rame ga", "ada temen ga", "sendirian aja", "join yuk", "mabar yuk", "gabung dong",
    "tungguin gua", "jangan kemana-mana", "gua balik bentar", "afk dulu", "nanti lagi",
    
    -- RANDOM BANGET (10)
    "kopi susu", "indomie goreng", "sate ayam", "bakso malang", "nasi goreng",
    "capek banget", "ngantuk", "makan dulu", "minum dulu", "roko dulu",
    "hujan nih", "panas banget", "angin kencang", "gerimis", "mendung",
    
    -- STATS GAME (10)
    "level berapa", "gear apa", "senjata apa", "skin apa", "item apa",
    "udah berapa jam", "lama main", "baru mulai", "udah pro", "masih newbie",
    
    -- PROMOSI ZONE XD (5)
    "zone xd terbaik", "apis owner zone xd", "zone xd v2", "script zone xd", "zone xd mantap"
}

-- GABUNGIN SEMUA JADI 50+ VARIASI
local allChats = {}
for _, v in pairs(chatMessages) do
    table.insert(allChats, v)
end

local chatInterval = 30 -- detik

-- Bikin ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AFKMenu"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Background menu
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 250, 0, 450)
menuFrame.Position = UDim2.new(0, 20, 0.5, -225)
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
menuFrame.BackgroundTransparency = 0.2
menuFrame.BorderSizePixel = 0
menuFrame.Parent = screenGui
menuFrame.Active = true
menuFrame.Draggable = true

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = menuFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(0, 255, 255)
uiStroke.Thickness = 2
uiStroke.Transparency = 0.5
uiStroke.Parent = menuFrame

-- JUDUL
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ AFK CONTROLLER ⚡"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = menuFrame

-- IMAGE BUTTON
local imageButton = Instance.new("ImageButton")
imageButton.Size = UDim2.new(0.8, 0, 0, 120)
imageButton.Position = UDim2.new(0.1, 0, 0, 70)
imageButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
imageButton.Image = "rbxassetid://1001228856"
imageButton.Parent = menuFrame

local imgCorner = Instance.new("UICorner")
imgCorner.CornerRadius = UDim.new(0, 20)
imgCorner.Parent = imageButton

local imgStroke = Instance.new("UIStroke")
imgStroke.Color = Color3.fromRGB(255, 215, 0)
imgStroke.Thickness = 3
imgStroke.Parent = imageButton

local imageText = Instance.new("TextLabel")
imageText.Size = UDim2.new(1, 0, 0, 30)
imageText.Position = UDim2.new(0, 0, 0, 130)
imageText.BackgroundTransparency = 1
imageText.Text = "🔥 TEKAN UNTUK MENU 🔥"
imageText.TextColor3 = Color3.fromRGB(255, 255, 255)
imageText.TextScaled = true
imageText.Font = Enum.Font.GothamBlack
imageText.Parent = imageButton

-- PANEL STATUS
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(0.9, 0, 0, 60)
statusFrame.Position = UDim2.new(0.05, 0, 0, 210)
statusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statusFrame.BackgroundTransparency = 0.3
statusFrame.Parent = menuFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = statusFrame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.5, 0, 1, 0)
statusText.Position = UDim2.new(0.05, 0, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "AFK:"
statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
statusText.TextScaled = true
statusText.Font = Enum.Font.GothamBold
statusText.Parent = statusFrame

local statusValue = Instance.new("TextLabel")
statusValue.Size = UDim2.new(0.4, 0, 1, 0)
statusValue.Position = UDim2.new(0.55, 0, 0, 0)
statusValue.BackgroundTransparency = 1
statusValue.Text = "🔴 OFF"
statusValue.TextColor3 = Color3.fromRGB(255, 0, 0)
statusValue.TextScaled = true
statusValue.Font = Enum.Font.GothamBlack
statusValue.Parent = statusFrame

-- CHAT STATUS
local chatFrame = Instance.new("Frame")
chatFrame.Size = UDim2.new(0.9, 0, 0, 60)
chatFrame.Position = UDim2.new(0.05, 0, 0, 280)
chatFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
chatFrame.BackgroundTransparency = 0.3
chatFrame.Parent = menuFrame

local chatCorner = Instance.new("UICorner")
chatCorner.CornerRadius = UDim.new(0, 10)
chatCorner.Parent = chatFrame

local chatText = Instance.new("TextLabel")
chatText.Size = UDim2.new(0.5, 0, 1, 0)
chatText.Position = UDim2.new(0.05, 0, 0, 0)
chatText.BackgroundTransparency = 1
chatText.Text = "CHAT:"
chatText.TextColor3 = Color3.fromRGB(200, 200, 200)
chatText.TextScaled = true
chatText.Font = Enum.Font.GothamBold
chatText.Parent = chatFrame

local chatValue = Instance.new("TextLabel")
chatValue.Size = UDim2.new(0.4, 0, 1, 0)
chatValue.Position = UDim2.new(0.55, 0, 0, 0)
chatValue.BackgroundTransparency = 1
chatValue.Text = "🔴 OFF"
chatValue.TextColor3 = Color3.fromRGB(255, 0, 0)
chatValue.TextScaled = true
chatValue.Font = Enum.Font.GothamBlack
chatValue.Parent = chatFrame

-- ACTION PANEL
local actionFrame = Instance.new("Frame")
actionFrame.Size = UDim2.new(0.9, 0, 0, 60)
actionFrame.Position = UDim2.new(0.05, 0, 0, 350)
actionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
actionFrame.BackgroundTransparency = 0.3
actionFrame.Parent = menuFrame

local actionCorner = Instance.new("UICorner")
actionCorner.CornerRadius = UDim.new(0, 10)
actionCorner.Parent = actionFrame

local actionText = Instance.new("TextLabel")
actionText.Size = UDim2.new(0.5, 0, 1, 0)
actionText.Position = UDim2.new(0.05, 0, 0, 0)
actionText.BackgroundTransparency = 1
actionText.Text = "ACTION:"
actionText.TextColor3 = Color3.fromRGB(200, 200, 200)
actionText.TextScaled = true
actionText.Font = Enum.Font.GothamBold
actionText.Parent = actionFrame

local actionValue = Instance.new("TextLabel")
actionValue.Size = UDim2.new(0.4, 0, 1, 0)
actionValue.Position = UDim2.new(0.55, 0, 0, 0)
actionValue.BackgroundTransparency = 1
actionValue.Text = "💤 Idle"
actionValue.TextColor3 = Color3.fromRGB(255, 255, 0)
actionValue.TextScaled = true
actionValue.Font = Enum.Font.GothamBlack
actionValue.Parent = actionFrame

-- TABLE MENU (DENGAN MINIMIZE FEATURE)
local tableMenu = Instance.new("Frame")
tableMenu.Size = UDim2.new(1, 0, 0, 250)
tableMenu.Position = UDim2.new(0, 0, 1, 10)
tableMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
tableMenu.BackgroundTransparency = 0.1
tableMenu.Visible = false
tableMenu.Parent = menuFrame
tableMenu.ClipsDescendants = true

local tableCorner = Instance.new("UICorner")
tableCorner.CornerRadius = UDim.new(0, 15)
tableCorner.Parent = tableMenu

local tableStroke = Instance.new("UIStroke")
tableStroke.Color = Color3.fromRGB(0, 255, 0)
tableStroke.Thickness = 2
tableStroke.Parent = tableMenu

-- HEADER TABLE (BUAT MINIMIZE)
local tableHeader = Instance.new("Frame")
tableHeader.Size = UDim2.new(1, 0, 0, 40)
tableHeader.Position = UDim2.new(0, 0, 0, 0)
tableHeader.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
tableHeader.BackgroundTransparency = 0.3
tableHeader.Parent = tableMenu

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = tableHeader

local tableTitle = Instance.new("TextLabel")
tableTitle.Size = UDim2.new(0.8, 0, 1, 0)
tableTitle.Position = UDim2.new(0.05, 0, 0, 0)
tableTitle.BackgroundTransparency = 1
tableTitle.Text = "📋 AFK SETTINGS 📋"
tableTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
tableTitle.TextScaled = true
tableTitle.Font = Enum.Font.GothamBold
tableTitle.Parent = tableHeader

-- TOMBOL MINIMIZE
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -40, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
minimizeBtn.Text = "🔼"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBlack
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = tableHeader

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = minimizeBtn

-- CONTENT FRAME (ISI TABLE)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = tableMenu

-- FUNGSI BUAT TOGGLE BUTTON
local function createToggleButton(name, posY, defaultState)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0.9, 0, 0, 45)
    bg.Position = UDim2.new(0.05, 0, 0, posY)
    bg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    bg.Parent = contentFrame

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 8)
    bgCorner.Parent = bg

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = bg

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 0.7, 0)
    btn.Position = UDim2.new(0.7, 0, 0.15, 0)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    btn.Text = defaultState and "ON" or "OFF"
    btn.TextColor3 = Color3.new(0, 0, 0)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBlack
    btn.Parent = bg

    local btnCorner2 = Instance.new("UICorner")
    btnCorner2.CornerRadius = UDim.new(0, 10)
    btnCorner2.Parent = btn

    return btn
end

-- Bikin toggle buttons
local toggleAFK = createToggleButton("AFK MODE", 10, false)
local toggleChat = createToggleButton("AUTO CHAT", 65, false)
local toggleMove = createToggleButton("RANDOM MOVE", 120, true)

-- TOMBOL MINIMIZE FUNCTION
minimizeBtn.MouseButton1Click:Connect(function()
    tableMinimized = not tableMinimized
    
    local targetSize = tableMinimized and UDim2.new(1, 0, 0, 40) or UDim2.new(1, 0, 0, 250)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(tableMenu, tweenInfo, {Size = targetSize})
    tween:Play()
    
    minimizeBtn.Text = tableMinimized and "🔽" or "🔼"
    contentFrame.Visible = not tableMinimized
end)

-- EVENT UNTUK IMAGE BUTTON
imageButton.MouseButton1Click:Connect(function()
    tableMenu.Visible = not tableMenu.Visible
    if tableMenu.Visible then
        imageButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        imageText.Text = "🔽 TUTUP MENU 🔽"
        tableMinimized = false
        tableMenu.Size = UDim2.new(1, 0, 0, 250)
        contentFrame.Visible = true
        minimizeBtn.Text = "🔼"
    else
        imageButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        imageText.Text = "🔥 TEKAN UNTUK MENU 🔥"
    end
end)

-- HOVER EFFECT
imageButton.MouseEnter:Connect(function()
    if not tableMenu.Visible then
        imageButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        imageButton.Size = UDim2.new(0.82, 0, 0, 125)
    end
end)

imageButton.MouseLeave:Connect(function()
    if not tableMenu.Visible then
        imageButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        imageButton.Size = UDim2.new(0.8, 0, 0, 120)
    end
end)

-- TOGGLE AFK
toggleAFK.MouseButton1Click:Connect(function()
    afkEnabled = not afkEnabled
    toggleAFK.BackgroundColor3 = afkEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggleAFK.Text = afkEnabled and "ON" or "OFF"
    statusValue.Text = afkEnabled and "🟢 ON" or "🔴 OFF"
    statusValue.TextColor3 = afkEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- TOGGLE CHAT
toggleChat.MouseButton1Click:Connect(function()
    chatEnabled = not chatEnabled
    toggleChat.BackgroundColor3 = chatEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggleChat.Text = chatEnabled and "ON" or "OFF"
    chatValue.Text = chatEnabled and "🟢 ON" or "🔴 OFF"
    chatValue.TextColor3 = chatEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- FUNGSI CHAT (RANDOM BENERAN - GAK ITU-ITU AJA)
local function sendChat()
    while true do
        if chatEnabled and afkEnabled then
            pcall(function()
                -- PILIH PESAN RANDOM (BENERAN ACAK)
                local randomIndex = math.random(1, #allChats)
                local message = allChats[randomIndex]
                
                -- METHODE CHAT
                local TextChatService = game:GetService("TextChatService")
                if TextChatService and TextChatService.TextChannels then
                    local general = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                    if general then
                        general:SendAsync(message)
                    end
                end
            end)
        end
        task.wait(chatInterval)
    end
end

-- FUNGSI AFK MOVEMENT
local function startAFK()
    while true do
        if afkEnabled then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                local root = character:FindFirstChild("HumanoidRootPart")

                if humanoid and root and toggleMove.Text == "ON" then
                    currentAction = "🚶 Moving"
                    actionValue.Text = currentAction

                    local targetPos = root.Position + Vector3.new(
                        math.random(-moveRadius, moveRadius),
                        0,
                        math.random(-moveRadius, moveRadius)
                    )

                    humanoid:MoveTo(targetPos)

                    local startTime = tick()
                    while (root.Position - targetPos).Magnitude > 3 and tick() - startTime < 5 do
                        humanoid:MoveTo(targetPos)
                        task.wait(0.5)
                    end
                else
                    currentAction = "💤 Idle"
                    actionValue.Text = currentAction
                    
                    if humanoid then
                        humanoid:MoveTo(root.Position)
                    end
                end
            end
        else
            currentAction = "💤 Idle"
            actionValue.Text = currentAction
        end
        task.wait(3)
    end
end

-- JALANKAN FUNGSI
task.spawn(startAFK)
task.spawn(sendChat)

print([[
╔══════════════════════════════════════════════════════════════╗
║   🔥 ZONE XD - AFK NPC V2 (CHAT SUPER RANDOM) 🔥            ║
║   ✅ 50+ VARIASI BAHASA INDONESIA                            ║
║   ✅ RANDOM SETIAP 30 DETIK (GAK ITU-ITU AJA)                ║
║   👑 COPYRIGHT: APIS (USER 01) - ZONE XD V1                  ║
╚══════════════════════════════════════════════════════════════╝
]])