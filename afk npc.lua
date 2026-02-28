-- AFK NPC DENGAN MENU INTERAKTIF
-- Taruh di LocalScript (ScreenGui)

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

-- Settings AFK
local afkEnabled = false
local walkSpeed = 16
local moveRadius = 30
local currentAction = "Idle"

-- Bikin ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AFKMenu"
screenGui.Parent = playerGui

-- Background menu (biar keliatan keren)
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 250, 0, 400)
menuFrame.Position = UDim2.new(0, 20, 0.5, -200)
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
menuFrame.BackgroundTransparency = 0.2
menuFrame.BorderSizePixel = 0
menuFrame.Parent = screenGui

-- Bikin shadow/glow effect
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = menuFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(0, 255, 255)
uiStroke.Thickness = 2
uiStroke.Transparency = 0.5
uiStroke.Parent = menuFrame

-- JUDUL KEREN
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ AFK CONTROLLER ⚡"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = menuFrame

-- IMAGE BUTTON DARI FILE LO!
local imageButton = Instance.new("ImageButton")
imageButton.Size = UDim2.new(0.8, 0, 0, 150)
imageButton.Position = UDim2.new(0.1, 0, 0, 80)
imageButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
imageButton.Image = "rbxassetid://1001228856" -- PAKE ID GAMBAR LO!

-- Bikin image button keren
local imgCorner = Instance.new("UICorner")
imgCorner.CornerRadius = UDim.new(0, 20)
imgCorner.Parent = imageButton

local imgStroke = Instance.new("UIStroke")
imgStroke.Color = Color3.fromRGB(255, 215, 0)
imgStroke.Thickness = 3
imgStroke.Parent = imageButton

-- Teks di bawah gambar
local imageText = Instance.new("TextLabel")
imageText.Size = UDim2.new(1, 0, 0, 30)
imageText.Position = UDim2.new(0, 0, 0, 160)
imageText.BackgroundTransparency = 1
imageText.Text = "🔥 TEKAN UNTUK MENU 🔥"
imageText.TextColor3 = Color3.fromRGB(255, 255, 255)
imageText.TextScaled = true
imageText.Font = Enum.Font.GothamBlack
imageText.Parent = imageButton

imageButton.Parent = menuFrame

-- PANEL STATUS AFK
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(0.9, 0, 0, 80)
statusFrame.Position = UDim2.new(0.05, 0, 0, 250)
statusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statusFrame.BackgroundTransparency = 0.3
statusFrame.Parent = menuFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = statusFrame

-- Status teks
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 0.5, 0)
statusText.Position = UDim2.new(0, 0, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "AFK STATUS:"
statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
statusText.TextScaled = true
statusText.Font = Enum.Font.GothamBold
statusText.Parent = statusFrame

local statusValue = Instance.new("TextLabel")
statusValue.Size = UDim2.new(1, 0, 0.5, 0)
statusValue.Position = UDim2.new(0, 0, 0.5, 0)
statusValue.BackgroundTransparency = 1
statusValue.Text = "🔴 OFF"
statusValue.TextColor3 = Color3.fromRGB(255, 0, 0)
statusValue.TextScaled = true
statusValue.Font = Enum.Font.GothamBlack
statusValue.Parent = statusFrame

-- ACTION SEKARANG
local actionFrame = Instance.new("Frame")
actionFrame.Size = UDim2.new(0.9, 0, 0, 80)
actionFrame.Position = UDim2.new(0.05, 0, 0, 340)
actionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
actionFrame.BackgroundTransparency = 0.3
actionFrame.Parent = menuFrame

local actionCorner = Instance.new("UICorner")
actionCorner.CornerRadius = UDim.new(0, 10)
actionCorner.Parent = actionFrame

-- Action teks
local actionTitle = Instance.new("TextLabel")
actionTitle.Size = UDim2.new(1, 0, 0.5, 0)
actionTitle.Position = UDim2.new(0, 0, 0, 0)
actionTitle.BackgroundTransparency = 1
actionTitle.Text = "CURRENT ACTION:"
actionTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
actionTitle.TextScaled = true
actionTitle.Font = Enum.Font.GothamBold
actionTitle.Parent = actionFrame

local actionValue = Instance.new("TextLabel")
actionValue.Size = UDim2.new(1, 0, 0.5, 0)
actionValue.Position = UDim2.new(0, 0, 0.5, 0)
actionValue.BackgroundTransparency = 1
actionValue.Text = "💤 Idle"
actionValue.TextColor3 = Color3.fromRGB(255, 255, 0)
actionValue.TextScaled = true
actionValue.Font = Enum.Font.GothamBlack
actionValue.Parent = actionFrame

-- TABLE MENU (MUNCUL KETIKA GAMBAR DI PENCET!)
local tableMenu = Instance.new("Frame")
tableMenu.Size = UDim2.new(1, 0, 0, 300)
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

-- JUDUL TABLE
local tableTitle = Instance.new("TextLabel")
tableTitle.Size = UDim2.new(1, 0, 0, 40)
tableTitle.Position = UDim2.new(0, 0, 0, 0)
tableTitle.BackgroundTransparency = 1
tableTitle.Text = "📋 AFK SETTINGS 📋"
tableTitle.TextColor3 = Color3.fromRGB(0, 255, 0)
tableTitle.TextScaled = true
tableTitle.Font = Enum.Font.GothamBold
tableTitle.Parent = tableMenu

-- FUNGSI BUAT ON/OFF AFK
local function createToggleButton(name, posY, defaultState)
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(0.9, 0, 0, 50)
    btnFrame.Position = UDim2.new(0.05, 0, 0, posY)
    btnFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btnFrame.Parent = tableMenu
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btnFrame
    
    local btnText = Instance.new("TextLabel")
    btnText.Size = UDim2.new(0.7, 0, 1, 0)
    btnText.Position = UDim2.new(0, 10, 0, 0)
    btnText.BackgroundTransparency = 1
    btnText.Text = name
    btnText.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnText.TextXAlignment = Enum.TextXAlignment.Left
    btnText.TextScaled = true
    btnText.Font = Enum.Font.Gotham
    btnText.Parent = btnFrame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.2, 0, 0.7, 0)
    toggleBtn.Position = UDim2.new(0.75, 0, 0.15, 0)
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
local toggleAFK = createToggleButton("AFK MODE", 50, false)
local toggleMove = createToggleButton("RANDOM MOVE", 110, true)
local toggleAnimate = createToggleButton("ANIMATIONS", 170, true)
local togglePath = createToggleButton("PATHFINDING", 230, false)

-- SPEED SLIDER
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(0.9, 0, 0, 60)
speedFrame.Position = UDim2.new(0.05, 0, 0, 290)
speedFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
speedFrame.Parent = tableMenu

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedFrame

local speedText = Instance.new("TextLabel")
speedText.Size = UDim2.new(0.4, 0, 1, 0)
speedText.Position = UDim2.new(0, 10, 0, 0)
speedText.BackgroundTransparency = 1
speedText.Text = "SPEED:"
speedText.TextColor3 = Color3.fromRGB(255, 255, 255)
speedText.TextScaled = true
speedText.Font = Enum.Font.Gotham
speedText.Parent = speedFrame

local speedValue = Instance.new("TextLabel")
speedValue.Size = UDim2.new(0.2, 0, 1, 0)
speedValue.Position = UDim2.new(0.4, 0, 0, 0)
speedValue.BackgroundTransparency = 1
speedValue.Text = tostring(walkSpeed)
speedValue.TextColor3 = Color3.fromRGB(0, 255, 255)
speedValue.TextScaled = true
speedValue.Font = Enum.Font.GothamBlack
speedValue.Parent = speedFrame

local speedUp = Instance.new("TextButton")
speedUp.Size = UDim2.new(0.15, 0, 0.6, 0)
speedUp.Position = UDim2.new(0.65, 0, 0.2, 0)
speedUp.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
speedUp.Text = "+"
speedUp.TextColor3 = Color3.fromRGB(0, 0, 0)
speedUp.TextScaled = true
speedUp.Font = Enum.Font.GothamBlack
speedUp.Parent = speedFrame

local speedDown = Instance.new("TextButton")
speedDown.Size = UDim2.new(0.15, 0, 0.6, 0)
speedDown.Position = UDim2.new(0.82, 0, 0.2, 0)
speedDown.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
speedDown.Text = "-"
speedDown.TextColor3 = Color3.fromRGB(0, 0, 0)
speedDown.TextScaled = true
speedDown.Font = Enum.Font.GothamBlack
speedDown.Parent = speedFrame

-- EVENT UNTUK IMAGE BUTTON (MUNCULIN TABLE)
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

-- ANIMASI KETIKA HOVER
imageButton.MouseEnter:Connect(function()
    imageButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    imageButton.Size = UDim2.new(0.82, 0, 0, 155)
end)

imageButton.MouseLeave:Connect(function()
    imageButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    imageButton.Size = UDim2.new(0.8, 0, 0, 150)
end)

-- FUNGSI AFK MOVEMENT
local function startAFK()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    while afkEnabled do
        -- Random action based on settings
        local action = math.random(1, 4)
        
        if toggleMove.Text == "ON" and action <= 2 then
            -- Random move
            currentAction = "🚶 Moving"
            local randomX = math.random(-moveRadius, moveRadius)
            local randomZ = math.random(-moveRadius, moveRadius)
            humanoid:MoveTo(character.PrimaryPart.Position + Vector3.new(randomX, 0, randomZ))
            wait(3)
            
        elseif toggleAnimate.Text == "ON" and action == 3 then
            -- Idle with animation
            currentAction = "💃 Dancing"
            -- Play dance animation here kalo ada
            wait(2)
            
        else
            -- Just idle
            currentAction = "💤 Idle"
            wait(2)
        end
        
        -- Update action display
        actionValue.Text = currentAction
    end
end

-- EVENT UNTUK TOGGLE AFK
toggleAFK.MouseButton1Click:Connect(function()
    afkEnabled = not afkEnabled
    
    if afkEnabled then
        toggleAFK.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        toggleAFK.Text = "ON"
        statusValue.Text = "🟢 ON"
        statusValue.TextColor3 = Color3.fromRGB(0, 255, 0)
        startAFK()
    else
        toggleAFK.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        toggleAFK.Text = "OFF"
        statusValue.Text = "🔴 OFF"
        statusValue.TextColor3 = Color3.fromRGB(255, 0, 0)
        currentAction = "💤 Idle"
        actionValue.Text = currentAction
    end
end)

-- SPEED CONTROLS
speedUp.MouseButton1Click:Connect(function()
    walkSpeed = math.min(100, walkSpeed + 5)
    speedValue.Text = tostring(walkSpeed)
    
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = walkSpeed
    end
end)

speedDown.MouseButton1Click:Connect(function()
    walkSpeed = math.max(10, walkSpeed - 5)
    speedValue.Text = tostring(walkSpeed)
    
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = walkSpeed
    end
end)

-- TOGGLE BUTTONS UPDATE
toggleMove.MouseButton1Click:Connect(function()
    if toggleMove.Text == "ON" then
        toggleMove.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        toggleMove.Text = "OFF"
    else
        toggleMove.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        toggleMove.Text = "ON"
    end
end)

toggleAnimate.MouseButton1Click:Connect(function()
    if toggleAnimate.Text == "ON" then
        toggleAnimate.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        toggleAnimate.Text = "OFF"
    else
        toggleAnimate.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        toggleAnimate.Text = "ON"
    end
end)

togglePath.MouseButton1Click:Connect(function()
    if togglePath.Text == "ON" then
        togglePath.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        togglePath.Text = "OFF"
    else
        togglePath.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        togglePath.Text = "ON"
    end
end)

-- MAKE MENU DRAGGABLE
local dragging = false
local dragInput
local dragStart
local startPos

menuFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = menuFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

menuFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        menuFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

print("🔥 AFK MENU DENGAN IMAGE BUTTON SIAP DIGUNAKAN! 🔥")