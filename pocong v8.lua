-- COPYRIGHT: APIS (USER 01) - ZONE XD V1
-- POCONG V8 - SAFETY MODE + ESP BAHASA INDONESIA

local Players=game:GetService("Players")
local LocalPlayer=Players.LocalPlayer
local Workspace=game:GetService("Workspace")
local UserInputService=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local StarterGui=game:GetService("StarterGui")
local CoreGui=game:GetService("CoreGui")
local TweenService=game:GetService("TweenService")

-- ==================================================
-- SETTINGS
-- ==================================================
local Settings={
    TeleportEnabled=true,
    ESPEnabled=true,
    AutoCollectEnabled=false,
    AutoFarmEnabled=false,
    SpeedEnabled=false,
    JumpEnabled=false,
    NoClipEnabled=false,
    SafetyEnabled=true,
    SafetyRadius=30,
    SpeedValue=50,
    JumpValue=80
}

local MenuOpen=false
local ScreenGui
local SmallMenu
local BigMenu
local ESP_Instances={}
local IsTeleporting=false
local SafeSpots={}

-- ==================================================
-- NOTIFICATION
-- ==================================================
local function Notif(t,txt)
    pcall(function()StarterGui:SetCore("SendNotification",{Title=t or "ZONE XD",Text=txt or "",Duration=2})end)
end

-- ==================================================
-- CREATE SMALL MENU (LOGO M)
-- ==================================================
local function CreateSmallMenu()
    SmallMenu=Instance.new("TextButton")
    SmallMenu.Parent=ScreenGui
    SmallMenu.BackgroundColor3=Color3.fromRGB(0,100,200)
    SmallMenu.BackgroundTransparency=0.2
    SmallMenu.BorderColor3=Color3.fromRGB(0,255,255)
    SmallMenu.BorderSizePixel=3
    SmallMenu.Position=UDim2.new(0.02,0,0.1,0)
    SmallMenu.Size=UDim2.new(0,50,0,50)
    SmallMenu.Text="M"
    SmallMenu.TextColor3=Color3.new(1,1,1)
    SmallMenu.TextScaled=true
    SmallMenu.Font=Enum.Font.GothamBlack
    SmallMenu.Draggable=true
    SmallMenu.Active=true
    SmallMenu.Visible=not MenuOpen

    SmallMenu.MouseButton1Click:Connect(function()
        MenuOpen=true
        SmallMenu.Visible=false
        BigMenu.Visible=true
    end)
end

-- ==================================================
-- CREATE BIG MENU (TABEL BESAR)
-- ==================================================
local function CreateBigMenu()
    BigMenu=Instance.new("Frame")
    BigMenu.Parent=ScreenGui
    BigMenu.BackgroundColor3=Color3.fromRGB(20,20,20)
    BigMenu.BackgroundTransparency=0.1
    BigMenu.BorderColor3=Color3.fromRGB(0,255,255)
    BigMenu.BorderSizePixel=3
    BigMenu.Position=UDim2.new(0.02,0,0.1,0)
    BigMenu.Size=UDim2.new(0,350,0,550)
    BigMenu.Visible=MenuOpen
    BigMenu.Active=true
    BigMenu.Draggable=true

    local TitleBar=Instance.new("Frame")
    TitleBar.Parent=BigMenu
    TitleBar.BackgroundColor3=Color3.fromRGB(0,100,200)
    TitleBar.Size=UDim2.new(1,0,0,40)
    TitleBar.BorderSizePixel=0

    local Title=Instance.new("TextLabel")
    Title.Parent=TitleBar
    Title.BackgroundTransparency=1
    Title.Size=UDim2.new(1,-40,1,0)
    Title.Text="🔥 ZONE XD - POCONG V8"
    Title.TextColor3=Color3.new(1,1,1)
    Title.TextScaled=true
    Title.Font=Enum.Font.GothamBlack
    Title.TextXAlignment=Enum.TextXAlignment.Left

    local MinBtn=Instance.new("TextButton")
    MinBtn.Parent=TitleBar
    MinBtn.BackgroundColor3=Color3.fromRGB(255,150,0)
    MinBtn.Size=UDim2.new(0,30,0,30)
    MinBtn.Position=UDim2.new(1,-70,0,5)
    MinBtn.Text="_"
    MinBtn.TextColor3=Color3.new(1,1,1)
    MinBtn.TextScaled=true
    MinBtn.Font=Enum.Font.GothamBlack
    MinBtn.BorderSizePixel=0
    MinBtn.MouseButton1Click:Connect(function()
        MenuOpen=false
        BigMenu.Visible=false
        SmallMenu.Visible=true
    end)

    local CloseBtn=Instance.new("TextButton")
    CloseBtn.Parent=TitleBar
    CloseBtn.BackgroundColor3=Color3.fromRGB(255,0,0)
    CloseBtn.Size=UDim2.new(0,30,0,30)
    CloseBtn.Position=UDim2.new(1,-35,0,5)
    CloseBtn.Text="X"
    CloseBtn.TextColor3=Color3.new(1,1,1)
    CloseBtn.TextScaled=true
    CloseBtn.Font=Enum.Font.GothamBlack
    CloseBtn.BorderSizePixel=0
    CloseBtn.MouseButton1Click:Connect(function()
        BigMenu.Visible=false
        SmallMenu.Visible=false
    end)

    local ScrollingFrame=Instance.new("ScrollingFrame")
    ScrollingFrame.Parent=BigMenu
    ScrollingFrame.BackgroundColor3=Color3.fromRGB(30,30,30)
    ScrollingFrame.Size=UDim2.new(1,0,1,-45)
    ScrollingFrame.Position=UDim2.new(0,0,0,45)
    ScrollingFrame.CanvasSize=UDim2.new(0,0,0,700)
    ScrollingFrame.ScrollBarThickness=8

    local y=10

    local function AddSection(t,c)
        local s=Instance.new("TextLabel")
        s.Parent=ScrollingFrame
        s.BackgroundColor3=c or Color3.fromRGB(0,150,255)
        s.Size=UDim2.new(0.95,0,0,30)
        s.Position=UDim2.new(0.025,0,0,y)
        s.Text=t
        s.TextColor3=Color3.new(1,1,1)
        s.TextScaled=true
        s.Font=Enum.Font.GothamBlack
        y=y+35
    end

    local function Toggle(t,v)
        local bg=Instance.new("Frame")
        bg.Parent=ScrollingFrame
        bg.BackgroundColor3=Color3.fromRGB(50,50,50)
        bg.Size=UDim2.new(0.95,0,0,40)
        bg.Position=UDim2.new(0.025,0,0,y)

        local label=Instance.new("TextLabel")
        label.Parent=bg
        label.BackgroundTransparency=1
        label.Size=UDim2.new(0.6,0,1,0)
        label.Position=UDim2.new(0.05,0,0,0)
        label.Text=t
        label.TextColor3=Color3.new(1,1,1)
        label.TextScaled=true
        label.Font=Enum.Font.Gotham
        label.TextXAlignment=Enum.TextXAlignment.Left

        local btn=Instance.new("TextButton")
        btn.Parent=bg
        btn.BackgroundColor3=Settings[v]and Color3.new(0,1,0)or Color3.new(1,0,0)
        btn.Size=UDim2.new(0.25,0,0.8,0)
        btn.Position=UDim2.new(0.7,0,0.1,0)
        btn.Text=Settings[v]and"ON"or"OFF"
        btn.TextColor3=Color3.new(0,0,0)
        btn.TextScaled=true
        btn.Font=Enum.Font.GothamBlack

        btn.MouseButton1Click:Connect(function()
            Settings[v]=not Settings[v]
            btn.BackgroundColor3=Settings[v]and Color3.new(0,1,0)or Color3.new(1,0,0)
            btn.Text=Settings[v]and"ON"or"OFF"
            Notif("ZONE XD",t.." "..(Settings[v]and"ON"or"OFF"))
            if v=="ESPEnabled"and not Settings.ESPEnabled then
                for _,v in pairs(ESP_Instances)do pcall(function()v:Destroy()end)end
                ESP_Instances={}
            end
        end)
        y=y+45
    end

    local function CreateSlider(t,v,min,max)
        local bg=Instance.new("Frame")
        bg.Parent=ScrollingFrame
        bg.BackgroundColor3=Color3.fromRGB(50,50,50)
        bg.Size=UDim2.new(0.95,0,0,60)
        bg.Position=UDim2.new(0.025,0,0,y)

        local label=Instance.new("TextLabel")
        label.Parent=bg
        label.BackgroundTransparency=1
        label.Size=UDim2.new(0.9,0,0.4,0)
        label.Position=UDim2.new(0.05,0,0.05,0)
        label.Text=t..": "..Settings[v]
        label.TextColor3=Color3.new(1,1,1)
        label.TextScaled=true
        label.Font=Enum.Font.Gotham
        label.TextXAlignment=Enum.TextXAlignment.Left

        local slider=Instance.new("Frame")
        slider.Parent=bg
        slider.BackgroundColor3=Color3.fromRGB(80,80,80)
        slider.Size=UDim2.new(0.9,0,0.25,0)
        slider.Position=UDim2.new(0.05,0,0.6,0)

        local fill=Instance.new("Frame")
        fill.Parent=slider
        fill.BackgroundColor3=Color3.fromRGB(0,255,0)
        fill.Size=UDim2.new((Settings[v]-min)/(max-min),0,1,0)

        local drag=Instance.new("TextButton")
        drag.Parent=slider
        drag.BackgroundColor3=Color3.new(1,1,1)
        drag.Size=UDim2.new(0,15,1,0)
        drag.Position=UDim2.new((Settings[v]-min)/(max-min),-7.5,0,0)
        drag.Text=""

        local dragging=false
        drag.MouseButton1Down:Connect(function()dragging=true end)
        UserInputService.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
        RunService.RenderStepped:Connect(function()
            if dragging then
                local m=UserInputService:GetMouseLocation()
                local pos=slider.AbsolutePosition
                local sz=slider.AbsoluteSize.X
                local rx=math.clamp((m.X-pos.X)/sz,0,1)
                local nv=min+(rx*(max-min))
                Settings[v]=math.floor(nv)
                label.Text=t..": "..Settings[v]
                fill.Size=UDim2.new(rx,0,1,0)
                drag.Position=UDim2.new(rx,-7.5,0,0)
            end
        end)
        y=y+70
    end

    AddSection("⚡ MAIN FEATURES",Color3.fromRGB(0,150,255))
    Toggle("TELEPORT","TeleportEnabled")
    Toggle("ESP","ESPEnabled")
    Toggle("AUTO COLLECT","AutoCollectEnabled")
    Toggle("AUTO FARM","AutoFarmEnabled")
    Toggle("SAFETY MODE","SafetyEnabled")

    AddSection("🦾 PLAYER BOOST",Color3.fromRGB(255,150,0))
    Toggle("SPEED BOOST","SpeedEnabled")
    Toggle("SUPER JUMP","JumpEnabled")
    Toggle("NOCLIP","NoClipEnabled")

    AddSection("⚙️ SETTINGS",Color3.fromRGB(200,0,200))
    CreateSlider("SPEED","SpeedValue",16,200)
    CreateSlider("JUMP","JumpValue",50,200)

    local info=Instance.new("TextLabel")
    info.Parent=ScrollingFrame
    info.BackgroundColor3=Color3.fromRGB(0,0,0)
    info.BackgroundTransparency=0.5
    info.Size=UDim2.new(0.95,0,0,80)
    info.Position=UDim2.new(0.025,0,0,y+10)
    info.Text="📌 M = BUKA/TUTUP MENU\n📌 T = TELEPORT MANUAL\n📌 SAFETY = AUTO HINDAR POCONG"
    info.TextColor3=Color3.new(1,1,1)
    info.TextScaled=true
    info.Font=Enum.Font.SourceSans

    ScrollingFrame.CanvasSize=UDim2.new(0,0,0,y+120)
end

-- ==================================================
-- ESP FUNCTION
-- ==================================================
local function ClearESP()
    for _,v in pairs(ESP_Instances)do pcall(function()v:Destroy()end)end
    ESP_Instances={}
end

local function AddESP(obj,color,txt)
    if not obj or not obj.Parent or not Settings.ESPEnabled then return end
    local h=Instance.new("Highlight")
    h.Parent=obj
    h.FillColor=color
    h.OutlineColor=Color3.new(1,1,1)
    h.FillTransparency=0.3
    h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    table.insert(ESP_Instances,h)
    local b=Instance.new("BillboardGui")
    b.Parent=obj
    b.Size=UDim2.new(0,100,0,30)
    b.StudsOffset=Vector3.new(0,3,0)
    b.AlwaysOnTop=true
    table.insert(ESP_Instances,b)
    local l=Instance.new("TextLabel")
    l.Parent=b
    l.Size=UDim2.new(1,0,1,0)
    l.BackgroundTransparency=1
    l.Text=txt or obj.Name
    l.TextColor3=color
    l.TextStrokeColor3=Color3.new(0,0,0)
    l.TextStrokeTransparency=0
    l.TextScaled=true
    table.insert(ESP_Instances,l)
end

-- ==================================================
-- DETEKSI BARANG (BAHASA INDONESIA 100%)
-- ==================================================
local function GetItems()
    local items={}
    for _,v in pairs(Workspace:GetDescendants())do
        if v:IsA("Part")and v.Parent~=LocalPlayer.Character then
            local n=v.Name:lower()
            -- FILTER BAHASA INDONESIA LENGKAP
            if 
               -- Kacamata
               n:find("kacamata")or n:find("kaca mata")or n:find("kacamata baca")or n:find("kacamata hitam")or
               
               -- Dompet
               n:find("dompet")or n:find("dompet kulit")or n:find("dompet kain")or
               
               -- Jam Tangan
               n:find("jam")or n:find("jam tangan")or n:find("arloji")or n:find("jam tangan pria")or n:find("jam tangan wanita")or
               
               -- Pena Merah
               n:find("pena merah")or n:find("pulpen merah")or n:find("bolpen merah")or
               
               -- Kartu ID
               n:find("kartu id")or n:find("kartu identitas")or n:find("ktp")or n:find("kartu mahasiswa")or n:find("kartu pelajar")or
               
               -- Papan Klip
               n:find("papan klip")or n:find("klip board")or n:find("papan catatan")or n:find("papan tulis kecil")or
               
               -- Rekam Medis
               n:find("rekam medis a")or n:find("rekam medis b")or n:find("rekam medis c")or
               n:find("rekam medis")or n:find("berkas medis")or n:find("catatan medis")
            then
                table.insert(items,v)
            end
        end
    end
    return items
end

-- ==================================================
-- DETEKSI POCONG (BAHASA INDONESIA)
-- ==================================================
local function GetPocongs()
    local poc={}
    for _,v in pairs(Workspace:GetDescendants())do
        if v:IsA("Model")and(v:FindFirstChild("Humanoid")or v:FindFirstChild("Body"))then
            local n=v.Name:lower()
            if n:find("pocong")or n:find("hantu")or n:find("genderuwo")or
               n:find("kuntilanak")or n:find("sundel bolong")or n:find("tuyul")or
               n:find("setan")or n:find("jin")or n:find("makhluk halus")
            then
                table.insert(poc,v)
            end
        end
    end
    return poc
end

-- ==================================================
-- UPDATE ESP
-- ==================================================
local function UpdateESP()
    ClearESP()
    if not Settings.ESPEnabled then return end
    
    local items=GetItems()
    for _,i in pairs(items)do
        AddESP(i,Color3.new(0,1,0),"📦 "..i.Name)
    end
    
    local pocongs=GetPocongs()
    for _,p in pairs(pocongs)do
        AddESP(p,Color3.new(1,0,0),"👻 POCONG")
    end
end

-- ==================================================
-- SAFETY MODE - AUTO HINDAR POCONG
-- ==================================================
local function CheckPocongSafety()
    if not Settings.SafetyEnabled or not LocalPlayer.Character then return end
    local root=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local pocongs=GetPocongs()
    for _,p in pairs(pocongs)do
        if p.PrimaryPart then
            local dist=(p.PrimaryPart.Position-root.Position).Magnitude
            if dist<Settings.SafetyRadius then
                -- CARI TEMPAT AMAN (random)
                local safePos=root.Position+Vector3.new(math.random(-50,50),0,math.random(-50,50))
                -- PASTIKAN DI ATAS TANAH
                safePos=Vector3.new(safePos.X, Workspace.Baseplate.Position.Y+5, safePos.Z)
                
                -- TELEPORT KE TEMPAT AMAN
                IsTeleporting=true
                root.CFrame=CFrame.new(safePos)
                Notif("⚠️ SAFETY","Pocong terlalu dekat! Teleport aman",2)
                task.wait(0.5)
                IsTeleporting=false
                break
            end
        end
    end
end

-- ==================================================
-- TELEPORT
-- ==================================================
local function TeleportToItem(item)
    if not Settings.TeleportEnabled or IsTeleporting or not LocalPlayer.Character then return end
    local root=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    IsTeleporting=true
    root.CFrame=CFrame.new(item.Position+Vector3.new(0,3,0))
    Notif("ZONE XD","Teleport ke "..item.Name)
    task.wait(0.3)
    IsTeleporting=false
end

local function TeleportNearest()
    if not LocalPlayer.Character then return end
    local root=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local items=GetItems()
    local near,dist=nil,999
    for _,i in pairs(items)do
        local d=(i.Position-root.Position).Magnitude
        if d<dist then near,dist=i,d end
    end
    if near then TeleportToItem(near)else Notif("ZONE XD","Tidak ada item")end
end

-- ==================================================
-- AUTO COLLECT
-- ==================================================
local function AutoCollect()
    if not Settings.AutoCollectEnabled or not LocalPlayer.Character then return end
    local root=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _,i in pairs(GetItems())do
        if(i.Position-root.Position).Magnitude<5 then
            local remote=game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")or
                        game:GetService("ReplicatedStorage"):FindFirstChild("Events")
            if remote then pcall(function()remote:FireServer(i)end)end
            task.wait(0.5)
            break
        end
    end
end

-- ==================================================
-- PLAYER STATS
-- ==================================================
local function UpdateStats()
    if not LocalPlayer.Character then return end
    local hum=LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed=Settings.SpeedEnabled and Settings.SpeedValue or 16
        hum.JumpPower=Settings.JumpEnabled and Settings.JumpValue or 50
    end
    if Settings.NoClipEnabled and LocalPlayer.Character then
        for _,v in pairs(LocalPlayer.Character:GetDescendants())do
            if v:IsA("Part")then v.CanCollide=false end
        end
    end
end

-- ==================================================
-- KEYBINDS
-- ==================================================
UserInputService.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode==Enum.KeyCode.M then
        MenuOpen=not MenuOpen
        if SmallMenu and BigMenu then
            SmallMenu.Visible=not MenuOpen
            BigMenu.Visible=MenuOpen
        end
    elseif i.KeyCode==Enum.KeyCode.T then
        TeleportNearest()
    end
end)

-- ==================================================
-- INIT
-- ==================================================
ScreenGui=Instance.new("ScreenGui")
ScreenGui.Name="ZoneXDMenu"
ScreenGui.ResetOnSpawn=false
ScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
pcall(function()ScreenGui.Parent=CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent=LocalPlayer:FindFirstChild("PlayerGui")or LocalPlayer.PlayerGui end

CreateSmallMenu()
CreateBigMenu()
Notif("ZONE XD","POCONG V8 LOADED! Tekan M",3)

coroutine.wrap(function()while task.wait(1)do UpdateESP()end end)()
coroutine.wrap(function()while task.wait(0.5)do UpdateStats()if Settings.AutoFarmEnabled then TeleportNearest()end end end)()
coroutine.wrap(function()while task.wait(1)do AutoCollect()end end)()
coroutine.wrap(function()while task.wait(0.5)do CheckPocongSafety()end end)()

print([[
╔══════════════════════════════════════════════════════════════╗
║   🔥 ZONE XD - POCONG V8 🔥                                  ║
║   ✅ BAHASA INDONESIA 100%                                   ║
║   ✅ SAFETY MODE (AUTO HINDAR POCONG)                        ║
║   ✅ ITEM: Kacamata, Dompet, Jam, Pena, Kartu, Papan, Rekam  ║
║   👑 COPYRIGHT: APIS (USER 01) - ZONE XD V1                  ║
╚══════════════════════════════════════════════════════════════╝
]])