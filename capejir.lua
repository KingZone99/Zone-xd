-- COPYRIGHT: APIS (USER 01) - ZONE XD V1
-- STATUS: OVERCLOCK ACTIVATED

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- SETTINGS MASTER (GUE GABUNGIN BIAR GAMPANG)
local XD_Settings = {
    Speed = 70,
    Jump = 100,
    ESP = true,
    Safety = true,
    Radius = 35,
    AutoCollect = true
}

-- [1] ESP SYSTEM (ZONE XD VERSION - LEBIH TERANG & ANTI-LAG)
local function ApplyESP(obj, col, name)
    if not obj:FindFirstChild("ZONE_XD_ESP") then
        local Highlight = Instance.new("Highlight")
        Highlight.Name = "ZONE_XD_ESP"
        Highlight.Parent = obj
        Highlight.FillColor = col
        Highlight.OutlineColor = Color3.new(1, 1, 1)
        Highlight.FillTransparency = 0.4

        local Billboard = Instance.new("BillboardGui", obj)
        Billboard.Size = UDim2.new(0, 100, 0, 30)
        Billboard.AlwaysOnTop = true
        Billboard.StudsOffset = Vector3.new(0, 3, 0)
        
        local Label = Instance.new("TextLabel", Billboard)
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.Text = "[ " .. name .. " ]"
        Label.TextColor3 = col
        Label.BackgroundTransparency = 1
        Label.TextScaled = true
        Label.Font = Enum.Font.GothamBold
    end
end

-- [2] SCANNER ENGINE (ANTI-LAG)
local function ScanWorld()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Model") then
            local n = v.Name:lower()
            -- DETEKSI ITEM LENGKAP (BAHASA)
            if n:find("kaca") or n:find("dompet") or n:find("jam") or n:find("pena") or n:find("kartu") or n:find("medis") then
                ApplyESP(v, Color3.fromRGB(0, 255, 100), "ITEM")
                -- AUTO COLLECT (TELEPORT JARAK DEKAT)
                if XD_Settings.AutoCollect and LocalPlayer.Character then
                    local dist = (v.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 10 then firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0) end
                end
            -- DETEKSI POCONG
            elseif n:find("pocong") or n:find("hantu") or n:find("setan") then
                ApplyESP(v, Color3.fromRGB(255, 0, 0), "POCONG 💀")
            end
        end
    end
end

-- [3] SAFETY ENGINE (RAYCAST PROTECTION)
local function SafetyRun()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or not XD_Settings.Safety then return end

    for _, v in pairs(workspace:GetChildren()) do
        if v.Name:lower():find("pocong") and v:FindFirstChild("HumanoidRootPart") then
            local dist = (v.HumanoidRootPart.Position - root.Position).Magnitude
            if dist < XD_Settings.Radius then
                -- DASH MENJAUH
                local dash = (root.Position - v.HumanoidRootPart.Position).Unit * 50
                root.CFrame = root.CFrame + dash
            end
        end
    end
end

-- [4] MASTER LOOP (EXECUTING)
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = XD_Settings.Speed
        LocalPlayer.Character.Humanoid.JumpPower = XD_Settings.Jump
    end
    SafetyRun()
end)

task.spawn(function()
    while task.wait(2) do ScanWorld() end
end)

print("ZONE XD V1: FULL POWER LOADED!")
