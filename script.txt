-- COPYRIGHT: APIS (USER 01) - ZONE XD V1

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")

local Settings = {
    ESP_Enabled = true,
    ESP_Color_Items = Color3.new(0, 1, 0),
    ESP_Color_Pocongs = Color3.new(1, 0, 0),
    ESP_Color_Storage = Color3.new(0, 0, 1),
    AutoTeleportToItem = true,
    AutoTeleportToStorage = true,
    TeleportDelay = 0.5,
    CollectionRange = 150,
    ShowTeleportEffect = true,
    IgnorePocongWhenTeleport = true,
    ItemSpawnCount = 50
}

local Items = {}
local StorageLocations = {}
local Pocongs = {}
local CurrentTarget = nil
local IsTeleporting = false
local CollectedItems = 0

local ItemFolder = Workspace:FindFirstChild("Items_XD") or Instance.new("Folder")
ItemFolder.Name = "Items_XD"
ItemFolder.Parent = Workspace

local StorageFolder = Workspace:FindFirstChild("Storage_XD") or Instance.new("Folder")
StorageFolder.Name = "Storage_XD"
StorageFolder.Parent = Workspace

local PocongFolder = Workspace:FindFirstChild("Pocongs_XD") or Instance.new("Folder")
PocongFolder.Name = "Pocongs_XD"
PocongFolder.Parent = Workspace

local function SendNotification(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 2})
    end)
end

local function CreateESP(obj, color, text)
    if not obj or not obj.Parent then return end
    local highlight = Instance.new("Highlight")
    highlight.Parent = obj
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.3
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    local billboard = Instance.new("BillboardGui")
    billboard.Parent = obj
    billboard.Size = UDim2.new(0, 120, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text or obj.Name
    textLabel.TextColor3 = color
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBlack
end

local function CreateStoragePoints()
    for _, child in pairs(StorageFolder:GetChildren()) do child:Destroy() end
    
    local storageTypes = {
        {name = "Storage_Common", color = BrickColor.new("Bright blue"), pos = Vector3.new(-30, 5, -30)},
        {name = "Storage_Rare", color = BrickColor.new("Bright red"), pos = Vector3.new(30, 5, -30)},
        {name = "Storage_Epic", color = BrickColor.new("Bright violet"), pos = Vector3.new(-30, 5, 30)},
        {name = "Storage_Legendary", color = BrickColor.new("Bright yellow"), pos = Vector3.new(30, 5, 30)},
        {name = "Storage_Mythic", color = BrickColor.new("Bright orange"), pos = Vector3.new(0, 5, 50)}
    }
    
    for _, data in ipairs(storageTypes) do
        local storage = Instance.new("Part")
        storage.Name = data.name
        storage.Size = Vector3.new(10, 2, 10)
        storage.BrickColor = data.color
        storage.Material = Enum.Material.Neon
        storage.Anchored = true
        storage.CanCollide = true
        storage.Position = data.pos
        storage.Parent = StorageFolder
        
        local light = Instance.new("PointLight")
        light.Parent = storage
        light.Brightness = 5
        light.Range = 15
        light.Color = data.color.Color
        
        if Settings.ESP_Enabled then
            CreateESP(storage, data.color.Color, data.name)
        end
        
        table.insert(StorageLocations, {part = storage, color = data.color.Color})
    end
    SendNotification("ZONE XD", #StorageLocations .. " Storage dibuat")
end

local function SpawnItems()
    for _, child in pairs(ItemFolder:GetChildren()) do child:Destroy() end
    Items = {}
    
    local itemTypes = {
        {name = "Coin", color = BrickColor.new("Bright yellow")},
        {name = "Key", color = BrickColor.new("Bright red")},
        {name = "Gem", color = BrickColor.new("Bright blue")},
        {name = "Crystal", color = BrickColor.new("Cyan")},
        {name = "Scroll", color = BrickColor.new("Brown")},
        {name = "Potion", color = BrickColor.new("Bright green")},
        {name = "Sword", color = BrickColor.new("Bright gray")},
        {name = "Shield", color = BrickColor.new("Dark stone grey")},
        {name = "Ring", color = BrickColor.new("Gold")},
        {name = "Amulet", color = BrickColor.new("Bright violet")}
    }
    
    for i = 1, Settings.ItemSpawnCount do
        local data = itemTypes[math.random(1, #itemTypes)]
        local item = Instance.new("Part")
        item.Name = data.name
        item.Size = Vector3.new(2, 2, 2)
        item.BrickColor = data.color
        item.Material = Enum.Material.Neon
        item.Anchored = true
        item.CanCollide = false
        item.Position = Vector3.new(math.random(-80, 80), math.random(5, 30), math.random(-80, 80))
        item.Parent = ItemFolder
        
        local light = Instance.new("PointLight")
        light.Parent = item
        light.Brightness = 3
        light.Range = 8
        light.Color = data.color.Color
        
        if Settings.ESP_Enabled then
            CreateESP(item, data.color.Color, data.name)
        end
        
        table.insert(Items, item)
    end
    SendNotification("ZONE XD", #Items .. " Items spawn")
end

local function CreatePocongs()
    for _, child in pairs(PocongFolder:GetChildren()) do child:Destroy() end
    Pocongs = {}
    
    for i = 1, 3 do
        local model = Instance.new("Model")
        model.Name = "Pocong"
        model.Parent = PocongFolder
        
        local body = Instance.new("Part")
        body.Name = "Body"
        body.Size = Vector3.new(3, 5, 2)
        body.BrickColor = BrickColor.new("White")
        body.Anchored = true
        body.CanCollide = false
        body.Position = Vector3.new(math.random(-60, 60), 2, math.random(-60, 60))
        body.Parent = model
        
        local head = Instance.new("Part")
        head.Name = "Head"
        head.Size = Vector3.new(2, 2, 2)
        head.BrickColor = BrickColor.new("White")
        head.Anchored = true
        head.CanCollide = false
        head.Position = body.Position + Vector3.new(0, 3, 0)
        head.Parent = model
        
        if Settings.ESP_Enabled then
            CreateESP(model, Color3.new(1, 0, 0), "👻 POCONG")
        end
        
        table.insert(Pocongs, model)
    end
end

local function TeleportToTarget(pos, msg)
    if IsTeleporting or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    IsTeleporting = true
    local root = LocalPlayer.Character.HumanoidRootPart
    
    if Settings.ShowTeleportEffect then
        local beam = Instance.new("Part")
        beam.Size = Vector3.new(1, 1, (root.Position - pos).Magnitude)
        beam.BrickColor = BrickColor.new("Bright blue")
        beam.Material = Enum.Material.Neon
        beam.Anchored = true
        beam.CanCollide = false
        beam.Transparency = 0.3
        beam.CFrame = CFrame.lookAt((root.Position + pos)/2, pos) * CFrame.new(0, 0, -beam.Size.Z/2)
        beam.Parent = Workspace
        Debris:AddItem(beam, 0.5)
    end
    
    root.CFrame = CFrame.new(pos)
    if msg then SendNotification("ZONE XD", msg) end
    wait(Settings.TeleportDelay)
    IsTeleporting = false
end

local function TeleportToNearestItem()
    if not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local nearest, dist = nil, Settings.CollectionRange
    for _, item in pairs(ItemFolder:GetChildren()) do
        if item:IsA("Part") then
            local d = (item.Position - root.Position).Magnitude
            if d < dist then
                local pocongNear = false
                for _, p in pairs(Pocongs) do
                    if p.PrimaryPart and (p.PrimaryPart.Position - item.Position).Magnitude < 20 then
                        pocongNear = true
                        break
                    end
                end
                if not pocongNear then
                    nearest, dist = item, d
                end
            end
        end
    end
    
    if nearest then
        CurrentTarget = nearest
        TeleportToTarget(nearest.Position + Vector3.new(0, 3, 0), "📦 " .. nearest.Name)
        wait(0.3)
        if Settings.AutoTeleportToStorage and #StorageLocations > 0 then
            local storage = StorageLocations[math.random(1, #StorageLocations)]
            TeleportToTarget(storage.part.Position + Vector3.new(0, 5, 0), "🏪 Ke Storage")
            nearest:Destroy()
            CollectedItems = CollectedItems + 1
            SendNotification("ZONE XD", "Item disimpan! Total: " .. CollectedItems)
        end
    end
end

local function CheckNearbyItem()
    if not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    for _, item in pairs(ItemFolder:GetChildren()) do
        if item:IsA("Part") and (item.Position - root.Position).Magnitude < 5 then
            if Settings.AutoTeleportToStorage and #StorageLocations > 0 then
                local storage = StorageLocations[math.random(1, #StorageLocations)]
                TeleportToTarget(storage.part.Position + Vector3.new(0, 5, 0), "🏪 Auto simpan")
                item:Destroy()
                CollectedItems = CollectedItems + 1
                SendNotification("ZONE XD", "Item disimpan! Total: " .. CollectedItems)
            end
            break
        end
    end
end

local function StartGame()
    CreateStoragePoints()
    SpawnItems()
    CreatePocongs()
    
    coroutine.wrap(function()
        while wait(2) do
            if Settings.AutoTeleportToItem then
                TeleportToNearestItem()
            end
        end
    end)()
    
    coroutine.wrap(function()
        while wait(0.5) do
            CheckNearbyItem()
        end
    end)()
    
    SendNotification("ZONE XD", "Game siap! Tekan T untuk teleport")
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.T then
        TeleportToNearestItem()
    elseif input.KeyCode == Enum.KeyCode.R then
        SpawnItems()
        SendNotification("ZONE XD", "Items respawn")
    elseif input.KeyCode == Enum.KeyCode.Y then
        if CurrentTarget and CurrentTarget.Parent then
            if #StorageLocations > 0 then
                local storage = StorageLocations[math.random(1, #StorageLocations)]
                TeleportToTarget(storage.part.Position + Vector3.new(0, 5, 0), "🏪 Manual simpan")
                CurrentTarget:Destroy()
                CollectedItems = CollectedItems + 1
            end
        end
    end
end)

StartGame()

print([[ 
╔══════════════════════════════════════════╗
║   POCONG HUNTER - ZONE XD               ║
║   COPYRIGHT: APIS (USER 01)              ║
║   TEKAN T = Teleport ke item             ║
║   TEKAN Y = Simpan item ke storage       ║
║   TEKAN R = Respawn items                ║
╚══════════════════════════════════════════╝
]])