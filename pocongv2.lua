-- COPYRIGHT: APIS (USER 01) - ZONE XD V1
-- POCONG HUNTER - REAL GAME ITEMS + MENU TOGGLE

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

-- ==================================================
-- MENU & SETTINGS
-- ==================================================
local Settings = {
    TeleportEnabled = true,
    ESPEnabled = true,
    AutoCollectEnabled = true,
    TeleportKey = Enum.KeyCode.T,
    ToggleMenuKey = Enum.KeyCode.M
}

local MenuOpen = false
local ScreenGui
local Frame
local ToggleButtons = {}

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
-- CREATE UI MENU
-- ==================================================
local function CreateMenu()
    if ScreenGui then ScreenGui:Destroy() end
    
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZoneXDMenu"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Parent ke CoreGui biar aman
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer.PlayerGui
    end
    
    -- BACKGROUND FRAME
    Frame = Instance.new("Frame")
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BackgroundTransparency = 0.2
    Frame.BorderColor3 = Color3.fromRGB(0, 255, 255)
    Frame.BorderSizePixel = 2
    Frame.Position = UDim2.new(0.02, 0, 0.2, 0)
    Frame.Size = UDim2.new(0, 250, 0, 300)
    Frame.Visible = MenuOpen
    Frame.Active = true
    Frame.Draggable = true
    
    -- TITLE
    local Title = Instance.new("TextLabel")
    Title.Parent = Frame
    Title.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Title.BackgroundTransparency = 0.5
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.Text = "ZONE XD - POCONG HUNTER"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBlack
    Title.BorderSizePixel = 0
    
    -- CLOSE BUTTON
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = Frame
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
    
    local yPos = 50
    
    -- FUNCTION BUAT TOGGLE BUTTON
    local function CreateToggle(text, setting, defaultColor)
        local Btn = Instance.new("TextButton")
        Btn.Parent = Frame
        Btn.BackgroundColor3 = defaultColor or Color3.fromRGB(0, 255, 0)
        Btn.Size = UDim2.new(0.9, 0, 0, 40)
        Btn.Position = UDim2.new(0.05, 0, 0, yPos)
        Btn.Text = text .. ": ON"
        Btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        Btn.TextScaled = true
        Btn.Font = Enum.Font.GothamBlack
        Btn.BorderSizePixel = 2
        Btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
        
        local state = setting
        local color = defaultColor
        
        Btn.MouseButton1Click:Connect(function()
            state = not state
            if text == "Teleport" then Settings.TeleportEnabled = state
            elseif text == "ESP" then Settings.ESPEnabled = state
            elseif text == "Auto Collect" then Settings.AutoCollectEnabled = state
            end
            
            if state then
                Btn.Text = text .. ": ON"
                Btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            else
                Btn.Text = text .. ": OFF"
                Btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
            SendNotification("ZONE XD", text .. " " .. (state and "ON" or "OFF"), 1)
        end)
        
        table.insert(ToggleButtons, Btn)
        yPos = yPos + 45
    end
    
    CreateToggle("Teleport", Settings.TeleportEnabled, Color3.fromRGB(0, 255, 0))
    CreateToggle("ESP", Settings.ESPEnabled, Color3.fromRGB(0, 255, 0))
    CreateToggle("Auto Collect", Settings.AutoCollectEnabled, Color3.fromRGB(0, 255, 0))
    
    -- INFO TEXT
    local Info = Instance.new("TextLabel")
    Info.Parent = Frame
    Info.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Info.Size = UDim2.new(0.9, 0, 0, 60)
    Info.Position = UDim2.new(0.05, 0, 0, yPos + 10)
    Info.Text = "TEKAN M UNTUK BUKA/TUTUP MENU\nT = TELEPORT MANUAL\nR = RESPAWN ITEMS"
    Info.TextColor3 = Color3.fromRGB(255, 255, 255)
    Info.TextScaled = true
    Info.Font = Enum.Font.SourceSans
    Info.BorderSizePixel = 0
end

-- ==================================================
-- ESP FUNCTION (WALLHACK)
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
    if not obj or not obj.Parent then return end
    if not Settings.ESPEnabled then return end
    
    -- HIGHLIGHT
    local highlight = Instance.new("Highlight")
    highlight.Parent = obj
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.3
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    table.insert(ESP_Instances, highlight)
    
    -- BILLBOARD
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
-- DETEKSI BARANG ASLI GAME
-- ==================================================
local function GetRealItems()
    local items = {}
    
    -- CARI BERDASARKAN NAMA OBJECT YANG UMUM DI GAME POCONG
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Model") then
            local name = v.Name:lower()
            
            -- FILTER NAMA BARANG YANG BENERAN ADA DI GAME
            if string.find(name, "coin") or 
               string.find(name, "key") or 
               string.find(name, "kunci") or 
               string.find(name, "uang") or
               string.find(name, "gold") or
               string.find(name, "beras") or
               string.find(name, "sak") or
               string.find(name, "batu") or
               string.find(name, "kayu") or
               string.find(name, "obat") or
               string.find(name, "herbal") or
               string.find(name, "ranting") or
               string.find(name, "daun") or
               string.find(name, "bunga") or
               string.find(name, "bambu") or
               string.find(name, "rotan") or
               string.find(name, "kain") or
               string.find(name, "benang") or
               string.find(name, "paku") or
               string.find(name, "palu") or
               string.find(name, "gergaji") or
               string.find(name, "pisau") or
               string.find(name, "parang") or
               string.find(name, "senter") or
               string.find(name, "lampu") or
               string.find(name, "baterai") or
               string.find(name, "darah") or
               string.find(name, "kertas") or
               string.find(name, "surat") or
               string.find(name, "botol") or
               string.find(name, "kaca") or
               string.find(name, "korek") or
               string.find(name, "lilin") or
               string.find(name, "buku") or
               string.find(name, "kitab") or
               string.find(name, "mustika") or
               string.find(name, "jimat") or
               string.find(name, "azimat") then
               
               table.insert(items, v)
            end
        end
    end
    
    return items
end

-- ==================================================
-- DETEKSI POCONG ASLI GAME
-- ==================================================
local function GetRealPocongs()
    local pocongs = {}
    
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") then
            local name = v.Name:lower()
            
            if string.find(name, "pocong") or 
               string.find(name, "hantu") or 
               string.find(name, "ghost") or
               string.find(name, "kuntilanak") or
               string.find(name, "tuyul") or
               string.find(name, "genderuwo") or
               string.find(name, "sundel") or
               string.find(name, "beliau") then
               
               if v:FindFirstChild("Humanoid") or v:FindFirstChild("Body") then
                   table.insert(pocongs, v)
               end
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
    
    -- ESP UNTUK ITEMS
    local items = GetRealItems()
    for _, item in pairs(items) do
        ESP:Add(item, Color3.new(0, 1, 0), "📦 " .. item.Name)
    end
    
    -- ESP UNTUK POCONG
    local pocongs = GetRealPocongs()
    for _, pocong in pairs(pocongs) do
        ESP:Add(pocong, Color3.new(1, 0, 0), "👻 POCONG")
    end
end

-- ==================================================
-- TELEPORT KE ITEM
-- ==================================================
local IsTeleporting = false
local CurrentTarget = nil

local function TeleportToItem(item)
    if not Settings.TeleportEnabled then
        SendNotification("ZONE XD", "Teleport disabled", 1)
        return
    end
    if IsTeleporting then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local root = LocalPlayer.Character.HumanoidRootPart
    local pos = item.Position
    
    IsTeleporting = true
    
    -- EFEK TELEPORT
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
    
    -- TELEPORT
    root.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0))
    SendNotification("ZONE XD", "Teleport ke " .. item.Name, 1)
    
    wait(0.3)
    IsTeleporting = false
end

-- ==================================================
-- AUTO COLLECT (AMBIL ITEM OTOMATIS)
-- ==================================================
local function AutoCollect()
    if not Settings.AutoCollectEnabled then return end
    if not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local items = GetRealItems()
    for _, item in pairs(items) do
        if item:IsA("Part") then
            local dist = (item.Position - root.Position).Magnitude
            if dist < 5 then
                -- SIMULASI "E" ATAU "F" UNTUK AMBIL ITEM
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                
                SendNotification("ZONE XD", "Mengambil " .. item.Name, 1)
                wait(0.5)
                break
            end
        end
    end
end

-- ==================================================
-- TELEPORT KE ITEM TERDEKAT (MANUAL)
-- ==================================================
local function TeleportToNearestItem()
    if not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local items = GetRealItems()
    local nearest = nil
    local nearestDist = 999
    
    for _, item in pairs(items) do
        if item:IsA("Part") then
            local dist = (item.Position - root.Position).Magnitude
            if dist < nearestDist then
                nearest = item
                nearestDist = dist
            end
        end
    end
    
    if nearest then
        TeleportToItem(nearest)
    else
        SendNotification("ZONE XD", "Tidak ada item di sekitar", 1)
    end
end

-- ==================================================
-- INITIALIZATION
-- ==================================================
local function Initialize()
    -- BUAT MENU
    CreateMenu()
    SendNotification("ZONE XD", "Script loaded! Tekan M buka menu", 3)
    
    -- LOOP UPDATE ESP
    coroutine.wrap(function()
        while wait(1) do
            UpdateESP()
        end
    end)()
    
    -- LOOP AUTO COLLECT
    coroutine.wrap(function()
        while wait(0.5) do
            AutoCollect()
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

-- ==================================================
-- START
-- ==================================================
Initialize()

print([[
╔══════════════════════════════════════════════════╗
║   POCONG HUNTER - ZONE XD                        ║
║   ✅ BARANG ASLI GAME                            ║
║   ✅ MENU ON/OFF (TEKAN M)                        ║
║   ✅ ESP WALLHACK                                 ║
║   ✅ AUTO COLLECT                                 ║
║   ✅ TELEPORT MANUAL (T)                          ║
║                                                  ║
║   COPYRIGHT: APIS (USER 01)                       ║
╚══════════════════════════════════════════════════╝
]])