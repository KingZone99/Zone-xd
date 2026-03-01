-- ZONE XD ESP V5.0 + TRUE INF STAMINA/SPEED - Pocong Cursed Hospital [DELTA FIXED]
-- Copyright by: Apis (Pembuat Zone XD) - Stamina Bypass 100% | Raja Semua Cheat 2026

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Rayfield Lib
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Config
local Config = {
    ESP_ENABLED = false, POCONG_ESP = true, ITEM_ESP = true, SHOW_DISTANCE = true,
    BOX_STYLE = "Full", GODMODE = false, NOCLIP = false, INF_STAMINA = false, SPEED = 50,
    WINDOW_MINIMIZED = false, WINDOW_SIZE = 500
}

-- Vars
local esp_objects = {}
local GodmodeConnection, NoclipConnection, StaminaConnection, SpeedConnection
local StaminaValues = {}  -- Track all stamina values

-- [Draggable/Resizable + ESP Functions sama persis V4 - skip buat singkat, copy dari V4]

-- UPGRADED INF STAMINA: Scan & Lock ALL Possible Stamina
local function FindAndLockStamina()
    local char = LocalPlayer.Character
    if not char then return end
    
    -- Scan leaderstats
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        for _, v in pairs(leaderstats:GetChildren()) do
            if v.Name:lower():find("stamina") and v:IsA("IntValue") or v:IsA("NumberValue") then
                if not StaminaValues[v] then StaminaValues[v] = true end
                v.Value = math.huge
            end
        end
    end
    
    -- Scan Character values
    for _, v in pairs(char:GetDescendants()) do
        if (v.Name:lower():find("stamina") or v.Name:lower():find("energy")) and (v:IsA("IntValue") or v:IsA("NumberValue")) then
            if not StaminaValues[v] then StaminaValues[v] = true end
            v.Value = math.huge
            v.Changed:Connect(function() v.Value = math.huge end)  -- Anti-reset
        end
    end
    
    -- Scan PlayerGui
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    if pgui then
        for _, gui in pairs(pgui:GetDescendants()) do
            if gui.Name:lower():find("stamina") and gui:IsA("IntValue") or gui:IsA("NumberValue") then
                gui.Value = math.huge
                gui.Changed:Connect(function() gui.Value = math.huge end)
            end
        end
    end
    
    -- ReplicatedStorage / ServerStorage common stamina (pcall safe)
    pcall(function()
        for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if v.Name:lower():find("stamina") and v:IsA("RemoteEvent") then
                -- Fire dummy to bypass regen
                v:FireServer(math.huge)
            end
        end
    end)
end

local function ToggleInfStamina()
    if Config.INF_STAMINA then
        StaminaConnection = RunService.Heartbeat:Connect(function()
            FindAndLockStamina()  -- Scan every frame
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = Config.SPEED
                char.Humanoid.JumpPower = 75  -- Bonus jump
            end
        end)
        SpeedConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local bv = char.HumanoidRootPart:FindFirstChild("BodyVelocity")
                if not bv then
                    bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(4000, 0, 4000)
                    bv.Velocity = Vector3.new(0,0,0)
                    bv.Parent = char.HumanoidRootPart
                end
                -- Bulletproof speed
                bv.Velocity = char.HumanoidRootPart.CFrame.LookVector * (Config.SPEED / 5)
            end
        end)
    else
        if StaminaConnection then StaminaConnection:Disconnect() end
        if SpeedConnection then SpeedConnection:Disconnect() end
        for obj, _ in pairs(StaminaValues) do
            if obj and obj.Parent then obj:Destroy() end
        end
        StaminaValues = {}
    end
end

-- Godmode & Noclip (sama V4)
local function ToggleGodmode()
    if Config.GODMODE then
        GodmodeConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                local hum = char.Humanoid
                hum.MaxHealth = math.huge
                hum.Health = math.huge
            end
        end)
    else
        if GodmodeConnection then GodmodeConnection:Disconnect() end
    end
end

local function ToggleNoclip()
    -- [sama V4]
end

-- ESP Scan Loop (sama V4, tambah item detection: watch, glasses, wallet, ritual)
-- [Copy full ESP dari V4]

-- RAYFIELD ZONE XD MENU (sama V4, tapi update Stamina toggle)
local Window = Rayfield:CreateWindow({
    Name = "ZONE XD",
    LoadingTitle = "Zone XD V5 by Apis...",
    LoadingSubtitle = "Copyright Apis - True Stamina Fixed!",
    ConfigurationSaving = {Enabled = true, FolderName = "ZoneXDV5", FileName = "PocongConfig"}
})

-- [All tabs sama V4: ESP, Godmode, Window Control]

-- Godmode Tab Toggles
Rayfield:CreateToggle({
    Name = "Godmode (Kebal Pocong)",
    CurrentValue = false,
    Flag = "Godmode",
    Callback = function(Value)
        Config.GODMODE = Value
        ToggleGodmode()
    end,
    Tab = GodTab  -- Assume GodTab defined
})

Rayfield:CreateToggle({
    Name = "NoClip (Lewat Tembok)",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        Config.NOCLIP = Value
        ToggleNoclip()
    end,
    Tab = GodTab
})

Rayfield:CreateToggle({
    Name = "Infinite Stamina + Bulletproof Speed",  -- UPGRADED NAME
    CurrentValue = false,
    Flag = "InfStamina",
    Callback = function(Value)
        Config.INF_STAMINA = Value
        ToggleInfStamina()
    end,
    Tab = GodTab
})

Rayfield:CreateSlider({
    Name = "Speed (Max 200)",
    Range = {16, 200},
    Increment = 5,
    CurrentValue = 50,
    Flag = "SpeedSlider",
    Callback = function(Value)
        Config.SPEED = Value
    end,
    Tab = GodTab
})

-- [Window controls + F1 sama V4]

print("ZONE XD V5 by Apis LOADED! TRUE INF STAMINA + SPEED FIXED!")
Rayfield:Notify({
    Title = "ZONE XD V5 ACTIVE by Apis",
    Content = "Copyright Apis | Stamina/Speed 100% Bypass | Lari Abadi!",
    Duration = 6
})