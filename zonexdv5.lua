-- ZONE XD ESP BARANG ONLY V5.1 - Pocong Cursed Hospital [DELTA]
-- Copyright by: Apis (Pembuat Zone XD) - Fokus ESP Item Hijau

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Config (Item-focused)
local Config = {
    ESP_ENABLED = false,
    ITEM_ESP = true,          -- default ON buat barang
    POCONG_ESP = false,       -- default OFF biar ga ganggu
    SHOW_DISTANCE = true,
    BOX_STYLE = "Full",
    GODMODE = false,
    NOCLIP = false,
    INF_STAMINA = false,
    SPEED = 50
}

local esp_objects = {}
local GodmodeConnection, NoclipConnection, StaminaConnection

-- Drawing
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

-- AddESP (sama tapi warna hijau buat item)
local function AddESP(obj, esp_type)
    if esp_objects[obj] then return end

    local color = Color3.fromRGB(0,255,0)  -- Hijau untuk semua barang
    local box = CreateBox(Vector2.new(), Vector2.new(), color, 2)
    local name_label = CreateText(Vector2.new(), "", color, 16)
    local dist_label = CreateText(Vector2.new(), "", Color3.fromRGB(255,255,255), 14)

    local conn = RunService.Heartbeat:Connect(function()
        if not obj.Parent or not Config.ESP_ENABLED then
            box.Visible = false
            name_label.Visible = false
            dist_label.Visible = false
            return
        end

        local root = obj:FindFirstChild("PrimaryPart") or obj:FindFirstChild("HumanoidRootPart") or obj
        if not root:IsA("BasePart") then return end

        local screenPos, onScreen = WorldToScreen(root.Position)
        if not onScreen then
            box.Visible = false
            name_label.Visible = false
            dist_label.Visible = false
            return
        end

        box.Size = Vector2.new(40, 40)  -- Kotak kecil biar gampang diliat barang
        box.Position = screenPos - box.Size / 2

        local dist = math.floor((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude) or 0)
        name_label.Text = "Barang [" .. dist .. "m]"
        name_label.Position = screenPos + Vector2.new(0, -30)

        box.Visible = true
        name_label.Visible = true
        dist_label.Visible = Config.SHOW_DISTANCE
    end)

    esp_objects[obj] = {box=box, name=name_label, dist=dist_label, conn=conn}
end

local function RemoveESP(obj)
    if esp_objects[obj] then
        esp_objects[obj].box:Remove()
        esp_objects[obj].name:Remove()
        esp_objects[obj].dist:Remove()
        esp_objects[obj].conn:Disconnect()
        esp_objects[obj] = nil
    end
end

-- Scan khusus BARANG (keyword super luas)
spawn(function()
    while true do
        wait(0.7)
        if Config.ESP_ENABLED and Config.ITEM_ESP then
            for _, obj in pairs(workspace:GetDescendants()) do
                local name = obj.Name:lower()
                if obj:IsA("Model") or obj:IsA("Part") or obj:IsA("MeshPart") then
                    if name:find("meja") or name:find("pasien") or name:find("kacamata") or name:find("glasses") or
                       name:find("dompet") or name:find("wallet") or name:find("jam") or name:find("tangan") or name:find("watch") or
                       name:find("key") or name:find("kunci") or name:find("flash") or name:find("senter") or name:find("light") or
                       name:find("battery") or name:find("baterai") or name:find("power") or name:find("stamina") or
                       name:find("ritual") or name:find("item") or name:find("collect") or name:find("tool") or
                       name:find("object") or name:find("prop") or name:find("pickup") then
                        AddESP(obj, "Barang")
                    end
                end
            end
        else
            for obj, _ in pairs(esp_objects) do RemoveESP(obj) end
            esp_objects = {}
        end
    end
end)

-- Menu (simpel, fokus Item)
local Window = Rayfield:CreateWindow({
    Name = "ZONE XD - ESP BARANG",
    LoadingTitle = "Loading ESP Item...",
    LoadingSubtitle = "by Apis",
    ConfigurationSaving = {Enabled = true, FolderName = "ZoneXDItem", FileName = "Config"}
})

local Tab = Window:CreateTab("ESP Barang")

Rayfield:CreateToggle({Name = "Enable ESP", CurrentValue = false, Callback = function(v) Config.ESP_ENABLED = v end, Tab = Tab})
Rayfield:CreateToggle({Name = "ESP Barang (Hijau)", CurrentValue = true, Callback = function(v) Config.ITEM_ESP = v end, Tab = Tab})
Rayfield:CreateToggle({Name = "Show Distance", CurrentValue = true, Callback = function(v) Config.SHOW_DISTANCE = v end, Tab = Tab})
Rayfield:CreateDropdown({Name = "Box Style", Options = {"Full", "Corner"}, CurrentOption = "Full", Callback = function(v) Config.BOX_STYLE = v end, Tab = Tab})

Rayfield:CreateNotify({Title = "ZONE XD ESP BARANG", Content = "Toggle Enable ESP ON → cari barang, kotak hijau muncul!", Duration = 5})

print("ZONE XD ESP BARANG LOADED - Copyright Apis")