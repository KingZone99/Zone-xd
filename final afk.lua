-- AFK NPC V3 - PATHFINDING + LOGO M + AUTO BELOK
-- COPYRIGHT: APIS (USER 01) - ZONE XD V1

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Settings AFK
local afkEnabled = false
local chatEnabled = false
local walkSpeed = 16
local currentAction = "Idle"
local menuOpen = false
local chatMessages = {
    "🔥 ZONE XD IS HERE 🔥",
    "⚡ ZONE XD RULES ⚡",
    "👑 ZONE XD - APIS OWNER 👑",
    "🚀 ZONE XD V3 PATHFINDING 🚀",
    "💀 AUTO BELOK KALO NEMU TEMBOK 💀",
    "✨ LOGO M - KLIK BUAT BUKA ✨",
    "🎮 AFK NPC V3 GAMING 🎮",
    "🔮 ZONE XD PREDICTION 🔮",
    "⭐ ZONE XD BEST SCRIPT ⭐",
    "🔥 APIS (USER 01) 🔥"
}
local chatInterval = 30 -- detik

-- Variabel pathfinding
local currentTarget = nil
local currentDirection = Vector3.new(1, 0, 0) -- Awal jalan ke kanan
local checkInterval = 2 -- detik
local pathfindingRunning = false

-- Bikin ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AFKMenu"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- ==================================================
-- LOGO M KECIL (COLLAPSIBLE)
-- ==================================================
local logoM = Instance.new("TextButton")
logoM.Size = UDim2.new(0, 60, 0, 60)
logoM.Position = UDim2.new(0.02, 0, 0.1, 0)
logoM.BackgroundColor3 = Color3.fromRGB(255, 70, 0)
logoM.BackgroundGradientColor = Color3.fromRGB(0, 150, 255)
logoM.BackgroundGradientDirection = Enum.GradientDirection.Horizontal
logoM.BorderColor3 = Color3.fromRGB(0, 255, 255)
logoM.BorderSizePixel = 3
logoM.Text = "M"
logoM.TextColor3 = Color3.new(1, 1, 1)
logoM.TextScaled = true
logoM.Font = Enum.Font.GothamBlack
logoM.Draggable = true
logoM.Active = true
logoM.Parent = screenGui
logoM.Visible = true
logoM.ZIndex = 1000

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 15)
logoCorner.Parent = logoM

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(0, 255, 255)
logoStroke.Thickness = 2
logoStroke.Parent = logoM

-- ==================================================
-- MENU UTAMA (MUNCUL KETIKA LOGO M DI KLIK)
-- ==================================================
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 280, 0, 400)
menuFrame.Position = UDim2.new(0.02, 0, 0.1, 0)
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
menuFrame.BackgroundTransparency = 0.1
menuFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
menuFrame.BorderSizePixel = 3
menuFrame.Visible = false
menuFrame.Active = true
menuFrame.Draggable = true
menuFrame.Parent = screenGui
menuFrame.ZIndex = 1000

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 15)
menuCorner.Parent = menuFrame

local menuStroke = Instance.new("UIStroke")
menuStroke.Color = Color3.fromRGB(0, 255, 255)
menuStroke.Thickness = 2
menuStroke.Parent = menuFrame

-- TITLE BAR
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
titleBar.BackgroundGradientColor = Color3.fromRGB(255, 70, 0)
titleBar.BackgroundGradientDirection = Enum.GradientDirection.Horizontal
titleBar.Parent = menuFrame
titleBar.ZIndex = 1001

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -70, 1, 0)
titleText.Position = UDim2.new(0.05, 0, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🔥 AFK NPC V3 🔥"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBlack
titleText.Parent = titleBar
titleText.ZIndex = 1002

-- CLOSE BUTTON (KEMBALI KE LOGO M)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar
closeBtn.ZIndex = 1002

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

-- SCROLLING FRAME
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, -45)
scrollingFrame.Position = UDim2.new(0, 0, 0, 45)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.Parent = menuFrame
scrollingFrame.ZIndex = 1001

local y = 10

-- FUNGSI BUAT SECTION
local function AddSection(text, color)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(0.9, 0, 0, 30)
    section.Position = UDim2.new(0.05, 0, 0, y)
    section.BackgroundColor3 = color or Color3.fromRGB(0, 150, 255)
    section.Text = text
    section.TextColor3 = Color3.new(1, 1, 1)
    section.TextScaled = true
    section.Font = Enum.Font.GothamBlack
    section.Parent = scrollingFrame
    section.ZIndex = 1002
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = section
    
    y = y + 35
end

-- FUNGSI BUAT TOGGLE BUTTON
local function createToggleButton(name, posY, defaultState, setting)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0.9, 0, 0, 45)
    bg.Position = UDim2.new(0.05, 0, 0, posY)
    bg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    bg.Parent = scrollingFrame
    bg.ZIndex = 1002

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
    label.ZIndex = 1003

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 0.7, 0)
    btn.Position = UDim2.new(0.7, 0, 0.15, 0)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    btn.Text = defaultState and "ON" or "OFF"
    btn.TextColor3 = Color3.new(0, 0, 0)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBlack
    btn.Parent = bg
    btn.ZIndex = 1003

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    return btn
end

-- FUNGSI BUAT SLIDER
local function createSlider(name, posY, minVal, maxVal, setting)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0.9, 0, 0, 55)
    bg.Position = UDim2.new(0.05, 0, 0, posY)
    bg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    bg.Parent = scrollingFrame
    bg.ZIndex = 1002

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 8)
    bgCorner.Parent = bg

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.8, 0, 0.4, 0)
    label.Position = UDim2.new(0.1, 0, 0.05, 0)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. walkSpeed
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = bg
    label.ZIndex = 1003

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.8, 0, 0.25, 0)
    sliderBg.Position = UDim2.new(0.1, 0, 0.55, 0)
    sliderBg.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    sliderBg.Parent = bg
    sliderBg.ZIndex = 1003

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((walkSpeed - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    fill.Parent = sliderBg
    fill.ZIndex = 1004

    local drag = Instance.new("TextButton")
    drag.Size = UDim2.new(0, 10, 1, 0)
    drag.Position = UDim2.new((walkSpeed - minVal) / (maxVal - minVal), -5, 0, 0)
    drag.BackgroundColor3 = Color3.new(1, 1, 1)
    drag.Text = ""
    drag.Parent = sliderBg
    drag.ZIndex = 1004

    local dragging = false
    drag.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            local m = UserInputService:GetMouseLocation()
            local pos = sliderBg.AbsolutePosition
            local sz = sliderBg.AbsoluteSize.X
            local rx = math.clamp((m.X - pos.X) / sz, 0, 1)
            local newVal = minVal + (rx * (maxVal - minVal))
            walkSpeed = math.floor(newVal)
            label.Text = name .. ": " .. walkSpeed
            fill.Size = UDim2.new(rx, 0, 1, 0)
            drag.Position = UDim2.new(rx, -5, 0, 0)
            
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = walkSpeed
            end
        end
    end)

    return drag
end

-- BUAT SEMUA KONTROL
AddSection("⚡ MAIN CONTROLS")
local toggleAFK = createToggleButton("AFK MODE", y, false, "afk")
y = y + 55
local toggleChat = createToggleButton("AUTO CHAT", y, false, "chat")
y = y + 55
AddSection("⚙️ SETTINGS")
createSlider("WALK SPEED", y, 16, 100, "speed")
y = y + 70

scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, y + 50)

-- EVENT LOGO M KLIK
logoM.MouseButton1Click:Connect(function()
    menuOpen = true
    logoM.Visible = false
    menuFrame.Visible = true
end)

-- EVENT CLOSE BUTTON
closeBtn.MouseButton1Click:Connect(function()
    menuOpen = false
    menuFrame.Visible = false
    logoM.Visible = true
end)

-- TOGGLE AFK
toggleAFK.MouseButton1Click:Connect(function()
    afkEnabled = not afkEnabled
    toggleAFK.BackgroundColor3 = afkEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggleAFK.Text = afkEnabled and "ON" or "OFF"
end)

-- TOGGLE CHAT
toggleChat.MouseButton1Click:Connect(function()
    chatEnabled = not chatEnabled
    toggleChat.BackgroundColor3 = chatEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggleChat.Text = chatEnabled and "ON" or "OFF"
end)

-- ==================================================
-- FUNGSI PATHFINDING (JALAN TERUS, BELOK OTOMATIS)
-- ==================================================
local function CheckObstacle()
    if not afkEnabled or not player.Character then return end
    
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not root then return end
    
    -- SET WALKSPEED
    humanoid.WalkSpeed = walkSpeed
    
    -- RAYCAST KE DEPAN (DETEKSI TEMBOK/JURANG)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local rayStart = root.Position
    local rayDirection = currentDirection * 10 -- 10 stud ke depan
    
    local raycastResult = workspace:Raycast(rayStart, rayDirection, raycastParams)
    
    -- CEK JURANG (RAYCAST KE BAWAH)
    local groundRay = workspace:Raycast(root.Position + Vector3.new(0, 1, 0), Vector3.new(0, -10, 0), raycastParams)
    
    if raycastResult or not groundRay then
        -- NEMU TEMBOK ATAU JURANG, GANTI ARAH
        local randomAngle = math.random(45, 135) -- Belok 45-135 derajat
        currentDirection = CFrame.Angles(0, math.rad(randomAngle), 0) * currentDirection
        
        -- KASIH EFEK NOTIF
        if raycastResult then
            currentAction = "🧱 NEMU TEMBOK, BELOK"
        else
            currentAction = "🌊 NEMU JURANG, BELOK"
        end
    else
        currentAction = "🚶 JALAN TERUS"
    end
    
    -- MOVE KE ARAH CURRENT DIRECTION
    local targetPos = root.Position + (currentDirection * 20)
    humanoid:MoveTo(targetPos)
end

-- ==================================================
-- FUNGSI CHAT
-- ==================================================
local function sendChat()
    local lastIndex = 1
    while true do
        if chatEnabled and afkEnabled then
            pcall(function()
                local message = chatMessages[lastIndex]
                
                local TextChatService = game:GetService("TextChatService")
                if TextChatService and TextChatService.TextChannels then
                    local general = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                    if general then
                        general:SendAsync(message)
                    end
                end
                
                lastIndex = lastIndex + 1
                if lastIndex > #chatMessages then
                    lastIndex = 1
                end
            end)
        end
        task.wait(chatInterval)
    end
end

-- ==================================================
-- MAIN LOOP (CHECK OBSTACLE EVERY 2 SECONDS)
-- ==================================================
task.spawn(function()
    while true do
        if afkEnabled then
            CheckObstacle()
        else
            currentAction = "💤 Idle"
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:MoveTo(player.Character.HumanoidRootPart.Position)
            end
        end
        task.wait(2)
    end
end)

task.spawn(sendChat)

print([[
╔══════════════════════════════════════════════════════════════╗
║   🔥 ZONE XD - AFK NPC V3 🔥                                 ║
║   ✅ PATHFINDING (AUTO BELOK KALO NEMU TEMBOK/JURANG)        ║
║   ✅ LOGO "M" KECIL, KLIK BUAT BUKA MENU                     ║
║   ✅ JALAN TERUS TERUS SAMPAI DIHENTIKAN                     ║
║   👑 COPYRIGHT: APIS (USER 01) - ZONE XD V1                  ║
╚══════════════════════════════════════════════════════════════╝
]])