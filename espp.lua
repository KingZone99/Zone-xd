-- ZONE XD V13 TEST - CHEAT REAL JALAN (BUKAN MENU DOANG)
-- Copyright Apis - Kotak Hijau Item + Kebal + Stamina Abadi

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Config = {
    ESP = false,
    GOD = false,
    STAMINA = false,
    SPEED = 70
}

local esp_objects = {}

-- Drawing simple
local function CreateBox(pos, size, color)
    local box = Drawing.new("Square")
    box.Position = pos
    box.Size = size
    box.Color = color
    box.Thickness = 3
    box.Filled = false
    box.Visible = false
    return box
end

local function CreateText(pos, text, color)
    local txt = Drawing.new("Text")
    txt.Position = pos
    txt.Text = text
    txt.Color = color
    txt.Size = 18
    txt.Outline = true
    txt.Visible = false
    return txt
end

local function WorldToScreen(pos)
    local screen, onScreen = workspace.CurrentCamera:WorldToViewportPoint(pos)
    return Vector2.new(screen.X, screen.Y), onScreen
end

-- Add ESP Barang (hijau)
local function AddESP(obj)
    if esp_objects[obj] then return end

    local box = CreateBox(Vector2.new(), Vector2.new(), Color3.fromRGB(0,255,0))
    local label = CreateText(Vector2.new(), "", Color3.fromRGB(0,255,0))

    local conn = game:GetService("RunService").Heartbeat:Connect(function()
        if not Config.ESP or not obj.Parent then
            box.Visible = false
            label.Visible = false
            return
        end

        local root = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
        if not root then return end

        local screenPos, onScreen = WorldToScreen(root.Position)
        if not onScreen then return end

        box.Size = Vector2.new(80, 80)  -- Kotak BESAR biar keliatan
        box.Position = screenPos - box.Size / 2

        local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude)
        label.Text = obj.Name .. " [" .. dist .. "m]"
        label.Position = screenPos + Vector2.new(0, -70)

        box.Visible = true
        label.Visible = true
    end)

    esp_objects[obj] = {box = box, label = label, conn = conn}
end

-- Scan BARANG (keyword lengkap)
spawn(function()
    while wait(0.4) do
        if Config.ESP then
            for _, obj in pairs(workspace:GetDescendants()) do
                local name = obj.Name:lower()
                if obj:IsA("Model") or obj:IsA("Part") then
                    if name:find("watch") or name:find("wrist") or name:find("clipboard") or name:find("table") or name:find("desk") or name:find("patient") or name:find("doctor") or name:find("meja") or name:find("pasien") or name:find("kacamata") or name:find("glasses") or name:find("dompet") or name:find("wallet") or name:find("jam") or name:find("tangan") or name:find("key") or name:find("flash") or name:find("battery") or name:find("stamina") or name:find("ritual") or name:find("item") or name:find("collect") then
                        AddESP(obj)
                    end
                end
            end
        end
    end
end)

-- Godmode REAL
spawn(function()
    while wait() do
        if Config.GOD then
            pcall(function()
                local hum = LocalPlayer.Character.Humanoid
                hum.MaxHealth = math.huge
                hum.Health = math.huge
            end)
        end
    end
end)

-- Inf Stamina + Speed REAL
spawn(function()
    while wait() do
        if Config.STAMINA then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local hum = char.Humanoid
                    hum.WalkSpeed = Config.SPEED
                    hum.JumpPower = 80
                    for _, v in pairs(char:GetDescendants()) do
                        if v.Name:lower():find("stamina") or v.Name:lower():find("energy") then
                            v.Value = math.huge
                        end
                    end
                end
            end)
        end
    end
end)

-- Menu simple tapi bener
local Window = Rayfield:CreateWindow({
    Name = "ZONE XD V13 TEST",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Apis"
})

local Tab = Window:CreateTab("Cheat")

Rayfield:CreateToggle({
    Name = "ESP Barang (Hijau)",
    CurrentValue = false,
    Callback = function(v) Config.ESP = v end
})

Rayfield:CreateToggle({
    Name = "Godmode (Kebal Real)",
    CurrentValue = false,
    Callback = function(v) Config.GOD = v end
})

Rayfield:CreateToggle({
    Name = "Infinite Stamina + Speed",
    CurrentValue = false,
    Callback = function(v) Config.STAMINA = v end
})

Rayfield:CreateSlider({
    Name = "Speed",
    Range = {16, 200},
    Increment = 5,
    CurrentValue = 60,
    Callback = function(v) Config.SPEED = v end
})

Rayfield:Notify({
    Title = "V13 TEST LOADED",
    Content = "Toggle ESP Barang ON → kotak hijau muncul di item. Godmode & Stamina REAL. Test sekarang!",
    Duration = 10
})

print("ZONE XD V13 TEST LOADED - CHEAT REAL - Toggle ON/OFF langsung!")