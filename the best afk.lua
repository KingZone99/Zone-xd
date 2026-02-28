-- AFK NPC DENGAN MENU INTERAKTIF + AUTO CHAT
-- COPYRIGHT: APIS (USER 01) - ZONE XD V1

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Settings AFK
local afkEnabled = false
local chatEnabled = false
local walkSpeed = 16
local moveRadius = 30
local currentAction = "Idle"
local chatMessage = "ZONE XD IS HERE"
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

-- TABLE MENU
local tableMenu = Instance.new("Frame")
tableMenu.Size = UDim2.new(1, 0, 0, 200)
tableMenu.Position = UDim2.new(0, 0, 1, 10)
tableMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
tableMenu.BackgroundTransparency = 0.1
tableMenu.Visible = false
tableMenu.Parent = menuFrame

local tableCorner = Instance.new("UICorner")
tableCorner.CornerRadius = UDim.new(0, 15)
tableCorner.Parent = tableMenu

local tableStroke = Instance.new("UIStroke")
tableStroke.Color = Color3.fromRGB(0, 255, 0)
tableStroke.Thickness = 2
tableStroke.Parent = tableMenu

local tableTitle = Instance.new("TextLabel")
tableTitle.Size = UDim2.new(1, 0, 0, 40)
tableTitle.Position = UDim2.new(0, 0, 0, 0)
tableTitle.BackgroundTransparency = 1
tableTitle.Text = "📋 AFK SETTINGS 📋"
tableTitle.TextColor3 = Color3.fromRGB(0, 255, 0)
tableTitle.TextScaled = true
tableTitle.Font = Enum.Font.GothamBold
tableTitle.Parent = tableMenu

-- FUNGSI BUAT TOGGLE BUTTON
local function createToggleButton(name, posY, defaultState, setting)
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(0.9, 0, 0, 45)
    btnFrame.Position = UDim2.new(0.05, 0, 0, posY)
    btnFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btnFrame.Parent = tableMenu

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btnFrame

    local btnText = Instance.new("TextLabel")
    btnText.Size = UDim2.new(0.6, 0, 1, 0)
    btnText.Position = UDim2.new(0, 10, 0, 0)
    btnText.BackgroundTransparency = 1
    btnText.Text = name
    btnText.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnText.TextXAlignment = Enum.TextXAlignment.Left
    btnText.TextScaled = true
    btnText.Font = Enum.Font.Gotham
    btnText.Parent = btnFrame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
    toggleBtn.Position = UDim2.new(0.7, 0, 0.15, 0)
    toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggleBtn.Text = defaultState and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = btnFrame

    local btnCorner2 = Instance.new("UICorner")
    btnCorner2.CornerRadius = UDim.new(0, 10)
    btnCorner2.Parent = toggleBtn

    return toggleBtn
end

-- Bikin toggle buttons
local toggleAFK = createToggleButton("AFK MODE", 50, false, "afk")
local toggleChat = createToggleButton("AUTO CHAT", 100, false, "chat")
local toggleMove = createToggleButton("RANDOM MOVE", 150, true, "move")

-- EVENT UNTUK IMAGE BUTTON
imageButton.MouseButton1Click:Connect(function()
    tableMenu.Visible = not tableMenu.Visible
    if tableMenu.Visible then
        imageButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        imageText.Text = "🔽 TUTUP MENU 🔽"
    else
        imageButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        imageText.Text = "🔥 TEKAN UNTUK MENU 🔥"
    end
end)

-- HOVER EFFECT
imageButton.MouseEnter:Connect(function()
    imageButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    imageButton.Size = UDim2.new(0.82, 0, 0, 125)
end)

imageButton.MouseLeave:Connect(function()
    imageButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    imageButton.Size = UDim2.new(0.8, 0, 0, 120)
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

-- FUNGSI CHAT (30 DETIK SEKALI)
local function sendChat()
    while true do
        if chatEnabled and afkEnabled then
            pcall(function()
                -- COBA BEBERAPA METHODE CHAT
                local args = {
                    [1] = chatMessage,
                    [2] = "All"
                }
                
                -- METHODE 1: PAKE REPLICATED STORAGE
                local chatRemote = ReplicatedStorage:FindFirstChild("Chat") or 
                                   ReplicatedStorage:FindFirstChild("SayMessage") or
                                   ReplicatedStorage:FindFirstChild("MainChat")
                if chatRemote then
                    chatRemote:FireServer(unpack(args))
                end
                
                -- METHODE 2: PAKE TEXTCHAT SERVICE
                local TextChatService = game:GetService("TextChatService")
                if TextChatService and TextChatService.TextChannels then
                    local general = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                    if general then
                        general:SendAsync(chatMessage)
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
                    
                    -- RANDOM MOVE
                    local targetPos = root.Position + Vector3.new(
                        math.random(-moveRadius, moveRadius),
                        0,
                        math.random(-moveRadius, moveRadius)
                    )
                    
                    humanoid:MoveTo(targetPos)
                    
                    -- TUNGGU SAMPAI SAMPAI ATAU 5 DETIK
                    local startTime = tick()
                    while (root.Position - targetPos).Magnitude > 3 and tick() - startTime < 5 do
                        humanoid:MoveTo(targetPos)
                        task.wait(0.5)
                    end
                else
                    currentAction = "💤 Idle"
                    actionValue.Text = currentAction
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
║   🔥 ZONE XD - AFK NPC + AUTO CHAT 🔥                        ║
║   ✅ AUTO CHAT "ZONE XD IS HERE" SETIAP 30 DETIK             ║
║   ✅ BISA ON/OFF DARI MENU                                   ║
║   👑 COPYRIGHT: APIS (USER 01) - ZONE XD V1                  ║
╚══════════════════════════════════════════════════════════════╝
]])