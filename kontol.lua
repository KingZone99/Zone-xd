-- COPYRIGHT: APIS (USER 01) - ZONE XD V1
-- POCONG HUNTER V2 - MENU LENGKAP + ALL FEATURES

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local MarketplaceService = game:GetService("MarketplaceService")

-- ==================================================
-- MENU & SETTINGS - LENGKAP DENGAN TOMBOL
-- ==================================================
local Settings = {
    -- MAIN FEATURES
    TeleportEnabled = true,
    ESPEnabled = true,
    AutoCollectEnabled = true,
    AutoFarmEnabled = false,
    WallhackEnabled = true,
    SpeedEnabled = false,
    JumpEnabled = false,
    NoClipEnabled = false,
    
    -- SETTINGS
    TeleportKey = Enum.KeyCode.T,
    ToggleMenuKey = Enum.KeyCode.M,
    SpeedValue = 50,
    JumpValue = 80,
    
    -- COLORS
    ESPColor_Items = Color3.new(0, 1, 0),      -- HIJAU
    ESPColor_Pocongs = Color3.new(1, 0, 0),    -- MERAH
    ESPColor_Players = Color3.new(0, 0, 1),    -- BIRU
    ESPColor_Storage = Color3.new(1, 1, 0),    -- KUNING
}

local MenuOpen = false
local ScreenGui
local Frame
local ToggleButtons = {}
local StatusLabels = {}

-- ==================================================
-- FUNGSI NOTIFIKASI
-- ==================================================
local function SendNotification(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "ZONE XD",
            Text = text or "",
            Duration = duration or 2
        })
    end)
end

-- ==================================================
-- CREATE UI MENU LENGKAP DENGAN TOMBOL
-- ==================================================
local function CreateMenu()
    if ScreenGui then ScreenGui:Destroy() end

    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZoneXDMenu"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer.PlayerGui
    end

    -- MAIN FRAME
    Frame = Instance.new("Frame")
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderColor3 = Color3.fromRGB(0, 255, 255)
    Frame.BorderSizePixel = 3
    Frame.Position = UDim2.new(0.02, 0, 0.1, 0)
    Frame.Size = UDim2.new(0, 280, 0, 500)
    Frame.Visible = MenuOpen
    Frame.Active = true
    Frame.Draggable = true

    -- TITLE BAR
    local TitleBar = Instance.new("Frame")
    TitleBar.Parent = Frame
    TitleBar.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BorderSizePixel = 0

    local Title = Instance.new("TextLabel")
    Title.Parent = TitleBar
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Text = "🔥 ZONE XD - POCONG V2"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBlack
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TitleBar
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextScaled = true
    CloseBtn.Font = Enum.Font.GothamBlack
    CloseBtn.BorderSizePixel = 0
    CloseBtn.MouseButton1Click:Connect(function()
        MenuOpen = false
        Frame.Visible = false
    end)

    -- SCROLLING FRAME BUAT TOMBOL
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Parent = Frame
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -45)
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 45)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
    ScrollingFrame.ScrollBarThickness = 8
    ScrollingFrame.BorderSizePixel = 0

    local yPos = 10

    -- FUNCTION BUAT SECTION HEADER
    local function AddSection(text)
        local section = Instance.new("TextLabel")
        section.Parent = ScrollingFrame
        section.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        section.Size = UDim2.new(0.95, 0, 0, 30)
        section.Position = UDim2.new(0.025, 0, 0, yPos)
        section.Text = "⚡ " .. text .. " ⚡"
        section.TextColor3 = Color3.fromRGB(255, 255, 255)
        section.TextScaled = true
        section.Font = Enum.Font.GothamBlack
        section.BorderSizePixel = 2
        section.BorderColor3 = Color3.fromRGB(255, 255, 255)
        yPos = yPos + 35
    end

    -- FUNCTION BUAT TOMBOL TOGGLE
    local function CreateToggle(text, varName, defaultColor)
        local Btn = Instance.new("TextButton")
        Btn.Parent = ScrollingFrame
        Btn.BackgroundColor3 = Settings[varName] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        Btn.Size = UDim2.new(0.9, 0, 0, 40)
        Btn.Position = UDim2.new(0.05, 0, 0, yPos)
        Btn.Text = text .. ": " .. (Settings[varName] and "ON ✅" or "OFF ❌")
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.TextScaled = true
        Btn.Font = Enum.Font.GothamBlack
        Btn.BorderSizePixel = 2
        Btn.BorderColor3 = Color3.fromRGB(255, 255, 255)

        Btn.MouseButton1Click:Connect(function()
            Settings[varName] = not Settings[varName]
            Btn.BackgroundColor3 = Settings[varName] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            Btn.Text = text .. ": " .. (Settings[varName] and "ON ✅" or "OFF ❌")
            SendNotification("ZONE XD", text .. " " .. (Settings[varName] and "ON" or "OFF"), 1)
            
            -- SPECIAL ACTIONS
            if varName == "ESPEnabled" and not Settings.ESPEnabled then
                ESP:Clear()
            end
            if varName == "WallhackEnabled" then
                UpdateWallhack()
            end
        end)

        table.insert(ToggleButtons, Btn)
        yPos = yPos + 45
    end

    -- FUNCTION BUAT SLIDER
    local function CreateSlider(text, varName, min, max)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Parent = ScrollingFrame
        SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        SliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
        SliderFrame.Position = UDim2.new(0.05, 0, 0, yPos)
        yPos = yPos + 55

        local Label = Instance.new("TextLabel")
        Label.Parent = SliderFrame
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.Text = text .. ": " .. Settings[varName]
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextScaled = true
        Label.Font = Enum.Font.Gotham

        local Slider = Instance.new("Frame")
        Slider.Parent = SliderFrame
        Slider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        Slider.Size = UDim2.new(1, 0, 0, 10)
        Slider.Position = UDim2.new(0, 0, 0, 25)

        local Fill = Instance.new("Frame")
        Fill.Parent = Slider
        Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        Fill.Size = UDim2.new((Settings[varName] - min) / (max - min), 0, 1, 0)

        local Drag = Instance.new("TextButton")
        Drag.Parent = Slider
        Drag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Drag.Size = UDim2.new(0, 15, 1, 0)
        Drag.Position = UDim2.new((Settings[varName] - min) / (max - min), -7.5, 0, 0)
        Drag.Text = ""
        Drag.BorderSizePixel = 0

        -- DRAG FUNCTIONALITY
        local dragging = false
        Drag.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        RunService.RenderStepped:Connect(function()
            if dragging then
                local mousePos = UserInputService:GetMouseLocation()
                local absPos = Slider.AbsolutePosition
                local absSize = Slider.AbsoluteSize.X
                local relativeX = math.clamp((mousePos.X - absPos.X) / absSize, 0, 1)
                local newValue = min + (relativeX * (max - min))
                Settings[varName] = math.floor(newValue)
                Label.Text = text .. ": " .. Settings[varName]
                Fill.Size = UDim2.new(relativeX, 0, 1, 0)
                Drag.Position = UDim2.new(relativeX, -7.5, 0, 0)
            end
        end)
    end

    -- ==================================================
    -- BIKIN SEMUA TOMBOL
    -- ==================================================
    AddSection("MAIN FEATURES")
    CreateToggle("⚡ TELEPORT", "TeleportEnabled")
    CreateToggle("👁️ ESP WALLHACK", "ESPEnabled")
    CreateToggle("📦 AUTO COLLECT", "AutoCollectEnabled")
    CreateToggle("🌾 AUTO FARM", "AutoFarmEnabled")
    
    AddSection("VISUAL FEATURES")
    CreateToggle("🧱 WALLHACK", "WallhackEnabled")
    
    AddSection("PLAYER FEATURES")
    CreateToggle("⚡ SPEED BOOST", "SpeedEnabled")
    CreateToggle("🦘 SUPER JUMP", "JumpEnabled")
    CreateToggle("🚪 NOCLIP", "NoClipEnabled")
    
    AddSection("SETTINGS")
    CreateSlider("SPEED VALUE", "SpeedValue", 16, 200)
    CreateSlider("JUMP VALUE", "JumpValue", 50, 200)

    -- INFO TEXT
    local Info = Instance.new("TextLabel")
    Info.Parent = ScrollingFrame
    Info.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Info.Size = UDim2.new(0.9, 0, 0, 70)
    Info.Position = UDim2.new(0.05, 0, 0, yPos + 10)
    Info.Text = "📌 KEYBINDS:\nM = BUKA/TUTUP MENU\nT = TELEPORT MANUAL\n\nCOPYRIGHT: APIS (USER 01)"
    Info.TextColor3 = Color3.fromRGB(255, 255, 255)
    Info.TextScaled = true
    Info.Font = Enum.Font.SourceSans

    -- UPDATE CANVAS SIZE
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 100)
end

-- ==================================================
-- ESP SYSTEM (WALLHACK)
-- ==================================================
local ESP = {}
local ESP_Instances = {}

function ESP:Clear()
    for _, v in pairs(ESP_Instances) do
        pcall(function() v:Destroy() end)
    end
    ESP_Instances = {}
end

function ESP:Add(obj, color, text)
    if not obj or not obj.Parent or not Settings.ESPEnabled then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = obj
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.3
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    table.insert(ESP_Instances, highlight)

    local bill = Instance.new("BillboardGui")
    bill.Parent = obj
    bill.Size = UDim2.new(0, 100, 0, 30)
    bill.StudsOffset = Vector3.new(0, 3, 0)
    bill.AlwaysOnTop = true
    table.insert(ESP_Instances, bill)

    local txt = Instance.new("TextLabel")
    txt.Parent = bill
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = text or obj.Name
    txt.TextColor3 = color
    txt.TextStrokeColor3 = Color3.new(0, 0, 0)
    txt.TextStrokeTransparency = 0
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBlack
    table.insert(ESP_Instances, txt)
end

-- ==================================================
-- WALLHACK (TEMBUS DINDING)
-- ==================================================
local function UpdateWallhack()
    if not Settings.WallhackEnabled then return end
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Part") and not v:IsA("Terrain") then
            v.LocalTransparencyModifier = 0.5
        end
    end
end

-- ==================================================
-- DETEKSI BARANG GAME
-- ==================================================
local function GetRealItems()
    local items = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Part") then
            local name = v.Name:lower()
            if string.find(name, "coin") or string.find(name, "key") or string.find(name, "kunci") or
               string.find(name, "uang") or string.find(name, "beras") or string.find(name, "batu") or
               string.find(name, "kayu") or string.find(name, "obat") or string.find(name, "daun") or
               string.find(name, "bunga") or string.find(name, "ranting") then
                table.insert(items, v)
            end
        end
    end
    return items
end

local function GetRealPocongs()
    local pocongs = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and (v:FindFirstChild("Humanoid") or v:FindFirstChild("Body")) then
            local name = v.Name:lower()
            if string.find(name, "pocong") or string.find(name, "hantu") or string.find(name, "ghost") then
                table.insert(pocongs, v)
            end
        end
    end
    return pocongs
end

-- ==================================================
-- UPDATE ESP
-- ==================================================
local function UpdateESP()
    ESP:Clear()
    if not Settings.ESPEnabled then return end
    
    for _, item in pairs(GetRealItems()) do
        ESP:Add(item, Settings.ESPColor_Items, "📦 " .. item.Name)
    end
    for _, pocong in pairs(GetRealPocongs()) do
        ESP:Add(pocong, Settings.ESPColor_Pocongs, "👻 POCONG")
    end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            ESP:Add(player.Character, Settings.ESPColor_Players, "👤 " .. player.Name)
        end
    end
end

-- ==================================================
-- TELEPORT SYSTEM
-- ==================================================
local IsTeleporting = false
local function TeleportToItem(item)
    if not Settings.TeleportEnabled or IsTeleporting or not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    IsTeleporting = true
    local pos = item.Position
    
    local beam = Instance.new("Part")
    beam.Size = Vector3.new(1, 1, (root.Position - pos).Magnitude)
    beam.BrickColor = BrickColor.new("Bright blue")
    beam.Material = Enum.Material.Neon
    beam.Anchored = true
    beam.CanCollide = false
    beam.Transparency = 0.3
    beam.CFrame = CFrame.lookAt((root.Position + pos)/2, pos) * CFrame.new(0, 0, -beam.Size.Z/2)
    beam.Parent = Workspace
    Debris:AddItem(beam, 0.3)
    
    root.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0))
    SendNotification("ZONE XD", "Teleport ke " .. item.Name, 1)
    
    wait(0.3)
    IsTeleporting = false
end

local function TeleportToNearestItem()
    if not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local items = GetRealItems()
    local nearest, nearestDist = nil, 999
    for _, item in pairs(items) do
        local dist = (item.Position - root.Position).Magnitude
        if dist < nearestDist then
            nearest, nearestDist = item, dist
        end
    end
    if nearest then
        TeleportToItem(nearest)
    else
        SendNotification("ZONE XD", "Tidak ada item", 1)
    end
end

-- ==================================================
-- AUTO COLLECT
-- ==================================================
local function AutoCollect()
    if not Settings.AutoCollectEnabled or not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    for _, item in pairs(GetRealItems()) do
        if (item.Position - root.Position).Magnitude < 5 then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            SendNotification("ZONE XD", "Mengambil " .. item.Name, 1)
            wait(0.5)
            break
        end
    end
end

-- ==================================================
-- AUTO FARM
-- ==================================================
local function AutoFarm()
    if not Settings.AutoFarmEnabled then return end
    TeleportToNearestItem()
end

-- ==================================================
-- SPEED & JUMP BOOST
-- ==================================================
local function UpdatePlayerStats()
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if Settings.SpeedEnabled then
        humanoid.WalkSpeed = Settings.SpeedValue
    else
        humanoid.WalkSpeed = 16
    end
    
    if Settings.JumpEnabled then
        humanoid.JumpPower = Settings.JumpValue
    else
        humanoid.JumpPower = 50
    end
end

-- ==================================================
-- NOCLIP
-- ==================================================
local function NoClip()
    if not Settings.NoClipEnabled or not LocalPlayer.Character then return end
    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
        if v:IsA("Part") then
            v.CanCollide = false
        end
    end
end

-- ==================================================
-- INITIALIZATION
-- ==================================================
local function Initialize()
    CreateMenu()
    SendNotification("ZONE XD", "POCONG V2 LOADED! Tekan M buka menu", 3)
    
    -- ESP UPDATE LOOP
    coroutine.wrap(function()
        while wait(1) do 
            UpdateESP()
        end
    end)()
    
    -- AUTO COLLECT LOOP
    coroutine.wrap(function()
        while wait(0.5) do 
            AutoCollect()
            UpdatePlayerStats()
            NoClip()
            if Settings.AutoFarmEnabled then
                AutoFarm()
            end
            if Settings.WallhackEnabled then
                UpdateWallhack()
            end
        end
    end)()
end

-- ==================================================
-- KEYBINDS
-- ==================================================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    
    -- TOGGLE MENU (M)
    if input.KeyCode == Enum.KeyCode.M then
        MenuOpen = not MenuOpen
        if Frame then
            Frame.Visible = MenuOpen
        end
        SendNotification("ZONE XD", MenuOpen and "Menu dibuka" or "Menu ditutup", 1)
    end
    
    -- TELEPORT MANUAL (T)
    if input.KeyCode == Enum.KeyCode.T then
        TeleportToNearestItem()
    end
end)

Initialize()

print([[
╔══════════════════════════════════════════════════════════════╗
║   🔥 POCONG HUNTER V2 - MENU LENGKAP 🔥                      ║
╠══════════════════════════════════════════════════════════════╣
║   ✅ TELEPORT ON/OFF                                         ║
║   ✅ ESP WALLHACK ON/OFF                                     ║
║   ✅ AUTO COLLECT ON/OFF                                     ║
║   ✅ AUTO FARM ON/OFF                                        ║
║   ✅ WALLHACK ON/OFF                                         ║
║   ✅ SPEED BOOST ON/OFF + SLIDER                             ║
║   ✅ SUPER JUMP ON/OFF + SLIDER                              ║
║   ✅ NOCLIP ON/OFF                                           ║
╠══════════════════════════════════════════════════════════════╣
║   📌 TEKAN M UNTUK BUKA/TUTUP MENU
║
║   📌 TEKAN T UNTUK TELEPORT MANUAL                          ║
╠══════════════════════════════════════════════════════════════╣
║   👑 COPYRIGHT: APIS (USER 01) - ZONE XD V1                 ║
╚══════════════════════════════════════════════════════════════╝
]])