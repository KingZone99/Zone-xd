-- ZONE XD V14 FULL WORKING - ESP BARANG + CHEAT REAL (BUKAN CASE DOANG)
-- Copyright Apis - Kotak Hijau Item + Kebal Real + Tembus Tembok + Lari Abadi

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Config = {
    ESP_ENABLED = false,
    SHOW_DISTANCE = true,
    GODMODE = false,
    NOCLIP = false,
    INF_STAMINA = false,
    SPEED = 70
}

local esp_objects = {}
local connections = {}

-- Drawing Functions
local function CreateBox(pos, size, color, thickness)
    local box = Drawing.new("Square")
    box.Position = pos
    box.Size = size
    box.Color = color
    box.Thickness = thickness
    box.Filled = false
    box.Transparency = 1
    box.Visible = false
    return box
end

local function CreateText(pos, text, color, size)
    local txt = Drawing.new("Text")
    txt.Position = pos
    txt.Text = text
    txt.Color = color
    txt.Size = size
    txt.Font = 2
    txt.Outline = true
    txt.Transparency = 1
    txt.Visible = false
    return txt
end

local function WorldToScreen(pos)
    local screen, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(screen.X, screen.Y), onScreen
end

-- Add ESP for BARANG (hijau)
local function AddESP(obj)
    if esp_objects[obj] then return end

    local box = CreateBox(Vector2.new(), Vector2.new(), Color3.fromRGB(0,255,0), 3)
    local name_label = CreateText(Vector2.new(), "", Color3.fromRGB(0,255,0), 18)

    local conn = RunService.Heartbeat:Connect(function()
        if not obj.Parent or not Config.ESP_ENABLED then
            box.Visible = false
            name_label.Visible = false
            return
        end

        local root = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
        if not root then return end

        local screenPos, onScreen = WorldToScreen(root.Position)
        if not onScreen then
            box.Visible = false
            name_label.Visible = false
            return
        end

        box.Size = Vector2.new(80, 80)
        box.Position = screenPos - box.Size / 2

        local dist = math.floor((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude) or 0)
        name_label.Text = obj.Name .. (Config.SHOW_DISTANCE and " [" .. dist .. "m]" or "")
        name_label.Position = screenPos + Vector2.new(0, -70)

        box.Visible = true
        name_label.Visible = true
    end)

    esp_objects[obj] = {box = box, name = name_label, conn = conn}
end

local function RemoveESP(obj)
    if esp_objects[obj] then
        esp_objects[obj].box:Remove()
        esp_objects[obj].name:Remove()
        esp_objects[obj].conn:Disconnect()
        esp_objects[obj] = nil
    end
end

-- Scan loop BARANG (keyword lengkap dari walkthrough)
spawn(function()
    while true do
        wait(0.4)
        if Config.ESP_ENABLED then
            for _, obj in pairs(workspace:GetDescendants()) do
                local name = obj.Name:lower()
                if (obj:IsA("Model") or obj:IsA("Part") or obj:IsA("MeshPart")) and (
                    name:find("watch") or name:find("wrist") or name:find("clipboard") or name:find("table") or name:find("desk") or name:find("patient") or name:find("doctor") or name:find("meja") or name:find("pasien") or name:find("kacamata") or name:find("glasses") or name:find("dompet") or name:find("wallet") or name:find("jam") or name:find("tangan") or name:find("key") or name:find("kunci") or name:find("flash") or name:find("senter") or name:find("light") or name:find("battery") or name:find("baterai") or name:find("power") or name:find("stamina") or name:find("ritual") or name:find("item") or name:find("collect") or name:find("tool") or name:find("object") or name:find("prop") or name:find("pickup") or name:find("bed") or name:find("altar") or name:find("desk")
                ) then
                    AddESP(obj)
                end
            end
        else
            for obj, _ in pairs(esp_objects) do RemoveESP(obj) end
            esp_objects = {}
        end
    end
end)

-- Godmode REAL
local function ToggleGodmode()
    if Config.GODMODE then
        connections.god = RunService.Heartbeat:Connect(function()
            pcall(function()
                local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then
                    hum.MaxHealth = math.huge
                    hum.Health = math.huge
                end
            end)
        end)
    else
        if connections.god then connections.god:Disconnect() end
    end
end

-- NoClip REAL
local function ToggleNoClip()
    if Config.NOCLIP then
        connections.noclip = RunService.Stepped:Connect(function()
            pcall(function()
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
        end)
    else
        if connections.noclip then connections.noclip:Disconnect() end
    end
end

-- Inf Stamina + Speed REAL
local function ToggleInfStamina()
    if Config.INF_STAMINA then
        connections.stamina = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum.WalkSpeed = Config.SPEED
                        hum.JumpPower = 80
                    end
                    for _, v in pairs(char:GetDescendants()) do
                        if (v.Name:lower():find("stamina") or v.Name:lower():find("energy")) and v:IsA("ValueBase") then
                            v.Value = math.huge
                        end
                    end
                end
            end)
        end)
    else
        if connections.stamina then connections.stamina:Disconnect() end
    end
end

-- Menu lengkap
local Window = Rayfield:CreateWindow({
    Name = "ZONE XD V14 - ESP BARANG + CHEAT",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Apis - Copyright Apis",
    ConfigurationSaving = {Enabled = true, FolderName = "ZoneXD", FileName = "V14"}
})

local Tab = Window:CreateTab("Cheat")

Rayfield:CreateToggle({
    Name = "Enable ESP Barang (Hijau)",
    CurrentValue = false,
    Callback = function(v) Config.ESP_ENABLED = v end
})

Rayfield:CreateToggle({
    Name = "Tampilkan Jarak",
    CurrentValue = true,
    Callback = function(v) Config.SHOW_DISTANCE = v end
})

Rayfield:CreateToggle({
    Name = "Godmode (Kebal Real)",
    CurrentValue = false,
    Callback = function(v) Config.GODMODE = v ToggleGodmode() end
})

Rayfield:CreateToggle({
    Name = "NoClip (Lewat Tembok)",
    CurrentValue = false,
    Callback = function(v) Config.NOCLIP = v ToggleNoClip() end
})

Rayfield:CreateToggle({
    Name = "Infinite Stamina + Speed",
    CurrentValue = false,
    Callback = function(v) Config.INF_STAMINA = v ToggleInfStamina() end
})

Rayfield:CreateSlider({
    Name = "Speed",
    Range = {16, 200},
    Increment = 5,
    CurrentValue = 60,
    Callback = function(v) Config.SPEED = v end
})

Rayfield:Notify({
    Title = "ZONE XD V14 LOADED",
    Content = "Toggle Enable ESP Barang ON → kotak hijau muncul di item! Godmode real, bukan visual. Copyright Apis",
    Duration = 10
})

print("ZONE XD V14 LOADED - CHEAT REAL JALAN - Copyright Apis")