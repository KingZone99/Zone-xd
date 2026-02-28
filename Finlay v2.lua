-- COPYRIGHT: APIS (USER 01) - ZONE XD V1
local Players=game:GetService("Players")
local LocalPlayer=Players.LocalPlayer
local Workspace=game:GetService("Workspace")
local UserInputService=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local StarterGui=game:GetService("StarterGui")
local CoreGui=game:GetService("CoreGui")
local Lighting=game:GetService("Lighting")

local Settings={
    Speed=70,
    Jump=100,
    ESP=true,
    God=false,
    Safety=true,
    Radius=35,
    AutoCollect=true,
    MenuOpen=false
}

local ScreenGui
local Frame
local SmallBtn
local ESP_Instances={}
local IsTeleporting=false
local HidePosList={}
local OldHealth=100

local function Notif(t)pcall(function()StarterGui:SetCore("SendNotification",{Title="ZONE XD",Text=t,Duration=2})end)end

-- ==================================================
-- GOD MODE (TAK BISA MATI)
-- ==================================================
local function GodMode()
    if not Settings.God or not LocalPlayer.Character then return end
    local hum=LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then
        hum.MaxHealth=math.huge
        hum.Health=hum.MaxHealth
        hum.BreakJointsOnDeath=false
        hum.PlatformStand=false
        hum.NameOcclusion=Enum.NameOcclusion.AlwaysOnTop
        hum.HealthDisplayDistance=math.huge
        hum.HealthDisplayType=Enum.HumanoidHealthDisplayType.AlwaysOn
        
        for _,v in pairs(LocalPlayer.Character:GetDescendants())do
            if v:IsA("BasePart")then
                v.CanCollide=false
                v.Material=Enum.Material.Neon
                v.BrickColor=BrickColor.new("Bright red")
            end
        end
    end
end

-- ==================================================
-- SCAN SEMUA HIDEPOS
-- ==================================================
local function ScanHidePos()
    HidePosList={}
    for _,v in pairs(Workspace:GetDescendants())do
        if v:IsA("Part")then
            local n=v.Name:lower()
            if n:find("hide")or n:find("safety")or n:find("safe")or n:find("spawn")or n:find("base")then
                table.insert(HidePosList,v.Position+Vector3.new(0,3,0))
            end
        end
    end
    if #HidePosList==0 then table.insert(HidePosList,Vector3.new(0,10,0))end
end

-- ==================================================
-- CARI HIDEPOS TERDEKAT
-- ==================================================
local function GetNearestHidePos(currentPos)
    local nearest=nil
    local minDist=9999
    for _,pos in pairs(HidePosList)do
        local dist=(pos-currentPos).Magnitude
        if dist<minDist then minDist=dist nearest=pos end
    end
    return nearest or HidePosList[1] or Vector3.new(0,10,0)
end

-- ==================================================
-- CREATE MENU (BAGUS + GRADIEN)
-- ==================================================
local function CreateMenu()
    if ScreenGui then ScreenGui:Destroy()end
    ScreenGui=Instance.new("ScreenGui")
    ScreenGui.Name="ZoneXDMenu"
    ScreenGui.ResetOnSpawn=false
    pcall(function()ScreenGui.Parent=CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent=LocalPlayer:FindFirstChild("PlayerGui")or LocalPlayer.PlayerGui end

    SmallBtn=Instance.new("TextButton")
    SmallBtn.Parent=ScreenGui
    SmallBtn.BackgroundColor3=Color3.fromRGB(255,70,0)
    SmallBtn.BackgroundGradientColor=Color3.fromRGB(0,150,255)
    SmallBtn.BackgroundGradientDirection=Enum.GradientDirection.Horizontal
    SmallBtn.BorderColor3=Color3.fromRGB(0,255,255)
    SmallBtn.BorderSizePixel=3
    SmallBtn.Position=UDim2.new(0.02,0,0.1,0)
    SmallBtn.Size=UDim2.new(0,60,0,60)
    SmallBtn.Text="⚡"
    SmallBtn.TextColor3=Color3.new(1,1,1)
    SmallBtn.TextScaled=true
    SmallBtn.Font=Enum.Font.GothamBlack
    SmallBtn.Draggable=true
    SmallBtn.Visible=not Settings.MenuOpen

    Frame=Instance.new("Frame")
    Frame.Parent=ScreenGui
    Frame.BackgroundColor3=Color3.fromRGB(20,20,20)
    Frame.BackgroundGradientColor=Color3.fromRGB(0,50,100)
    Frame.BackgroundGradientDirection=Enum.GradientDirection.Vertical
    Frame.BorderColor3=Color3.fromRGB(0,255,255)
    Frame.BorderSizePixel=3
    Frame.Position=UDim2.new(0.02,0,0.1,0)
    Frame.Size=UDim2.new(0,300,0,450)
    Frame.Visible=Settings.MenuOpen
    Frame.Active=true
    Frame.Draggable=true

    local TitleBar=Instance.new("Frame")
    TitleBar.Parent=Frame
    TitleBar.BackgroundColor3=Color3.fromRGB(0,100,200)
    TitleBar.BackgroundGradientColor=Color3.fromRGB(255,70,0)
    TitleBar.BackgroundGradientDirection=Enum.GradientDirection.Horizontal
    TitleBar.Size=UDim2.new(1,0,0,45)

    local Title=Instance.new("TextLabel")
    Title.Parent=TitleBar
    Title.BackgroundTransparency=1
    Title.Size=UDim2.new(1,-70,1,0)
    Title.Text="🔥 ZONE XD V2"
    Title.TextColor3=Color3.new(1,1,1)
    Title.TextScaled=true
    Title.Font=Enum.Font.GothamBlack

    local MinBtn=Instance.new("TextButton")
    MinBtn.Parent=TitleBar
    MinBtn.BackgroundColor3=Color3.fromRGB(255,150,0)
    MinBtn.Size=UDim2.new(0,30,0,30)
    MinBtn.Position=UDim2.new(1,-70,0,7.5)
    MinBtn.Text="_"
    MinBtn.TextColor3=Color3.new(1,1,1)
    MinBtn.TextScaled=true
    MinBtn.Font=Enum.Font.GothamBlack
    MinBtn.BorderSizePixel=0
    MinBtn.MouseButton1Click:Connect(function()
        Settings.MenuOpen=false
        Frame.Visible=false
        SmallBtn.Visible=true
    end)

    local CloseBtn=Instance.new("TextButton")
    CloseBtn.Parent=TitleBar
    CloseBtn.BackgroundColor3=Color3.fromRGB(255,0,0)
    CloseBtn.Size=UDim2.new(0,30,0,30)
    CloseBtn.Position=UDim2.new(1,-35,0,7.5)
    CloseBtn.Text="X"
    CloseBtn.TextColor3=Color3.new(1,1,1)
    CloseBtn.TextScaled=true
    CloseBtn.Font=Enum.Font.GothamBlack
    CloseBtn.BorderSizePixel=0
    CloseBtn.MouseButton1Click:Connect(function()
        Frame.Visible=false
        SmallBtn.Visible=false
    end)

    SmallBtn.MouseButton1Click:Connect(function()
        Settings.MenuOpen=true
        SmallBtn.Visible=false
        Frame.Visible=true
    end)

    local ScrollingFrame=Instance.new("ScrollingFrame")
    ScrollingFrame.Parent=Frame
    ScrollingFrame.BackgroundTransparency=1
    ScrollingFrame.Size=UDim2.new(1,0,1,-50)
    ScrollingFrame.Position=UDim2.new(0,0,0,50)
    ScrollingFrame.CanvasSize=UDim2.new(0,0,0,500)
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

    local function Slider(t,v,min,max,ico)
        local bg=Instance.new("Frame")
        bg.Parent=ScrollingFrame
        bg.BackgroundColor3=Color3.fromRGB(40,40,40)
        bg.Size=UDim2.new(0.95,0,0,55)
        bg.Position=UDim2.new(0.025,0,0,y)

        local ic=Instance.new("TextLabel")
        ic.Parent=bg
        ic.BackgroundTransparency=1
        ic.Size=UDim2.new(0,30,1,0)
        ic.Position=UDim2.new(0.02,0,0,0)
        ic.Text=ico or "⚡"
        ic.TextColor3=Color3.new(0,255,255)
        ic.TextScaled=true
        ic.Font=Enum.Font.GothamBlack

        local lbl=Instance.new("TextLabel")
        lbl.Parent=bg
        lbl.BackgroundTransparency=1
        lbl.Size=UDim2.new(0.8,0,0.4,0)
        lbl.Position=UDim2.new(0.15,0,0.05,0)
        lbl.Text=t..": "..Settings[v]
        lbl.TextColor3=Color3.new(1,1,1)
        lbl.TextScaled=true
        lbl.Font=Enum.Font.Gotham

        local sld=Instance.new("Frame")
        sld.Parent=bg
        sld.BackgroundColor3=Color3.fromRGB(80,80,80)
        sld.Size=UDim2.new(0.8,0,0.25,0)
        sld.Position=UDim2.new(0.15,0,0.5,0)

        local fill=Instance.new("Frame")
        fill.Parent=sld
        fill.BackgroundColor3=Color3.fromRGB(0,255,0)
        fill.Size=UDim2.new((Settings[v]-min)/(max-min),0,1,0)

        local drag=Instance.new("TextButton")
        drag.Parent=sld
        drag.BackgroundColor3=Color3.new(1,1,1)
        drag.Size=UDim2.new(0,10,1,0)
        drag.Position=UDim2.new((Settings[v]-min)/(max-min),-5,0,0)
        drag.Text=""

        local dragging=false
        drag.MouseButton1Down:Connect(function()dragging=true end)
        UserInputService.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
        RunService.RenderStepped:Connect(function()
            if dragging then
                local m=UserInputService:GetMouseLocation()
                local pos=sld.AbsolutePosition
                local sz=sld.AbsoluteSize.X
                local rx=math.clamp((m.X-pos.X)/sz,0,1)
                local nv=min+(rx*(max-min))
                Settings[v]=math.floor(nv)
                lbl.Text=t..": "..Settings[v]
                fill.Size=UDim2.new(rx,0,1,0)
                drag.Position=UDim2.new(rx,-5,0,0)
            end
        end)
        y=y+65
    end

    local function Toggle(t,v,ico)
        local bg=Instance.new("Frame")
        bg.Parent=ScrollingFrame
        bg.BackgroundColor3=Color3.fromRGB(40,40,40)
        bg.Size=UDim2.new(0.95,0,0,45)
        bg.Position=UDim2.new(0.025,0,0,y)

        local ic=Instance.new("TextLabel")
        ic.Parent=bg
        ic.BackgroundTransparency=1
        ic.Size=UDim2.new(0,30,1,0)
        ic.Position=UDim2.new(0.02,0,0,0)
        ic.Text=ico or "🔘"
        ic.TextColor3=Color3.new(0,255,255)
        ic.TextScaled=true
        ic.Font=Enum.Font.GothamBlack

        local lbl=Instance.new("TextLabel")
        lbl.Parent=bg
        lbl.BackgroundTransparency=1
        lbl.Size=UDim2.new(0.5,0,1,0)
        lbl.Position=UDim2.new(0.15,0,0,0)
        lbl.Text=t
        lbl.TextColor3=Color3.new(1,1,1)
        lbl.TextScaled=true
        lbl.Font=Enum.Font.Gotham

        local btn=Instance.new("TextButton")
        btn.Parent=bg
        btn.BackgroundColor3=Settings[v]and Color3.fromRGB(0,255,0)or Color3.fromRGB(255,0,0)
        btn.Size=UDim2.new(0.25,0,0.8,0)
        btn.Position=UDim2.new(0.7,0,0.1,0)
        btn.Text=Settings[v]and"ON"or"OFF"
        btn.TextColor3=Color3.new(0,0,0)
        btn.TextScaled=true
        btn.Font=Enum.Font.GothamBlack
        btn.MouseButton1Click:Connect(function()
            Settings[v]=not Settings[v]
            btn.BackgroundColor3=Settings[v]and Color3.fromRGB(0,255,0)or Color3.fromRGB(255,0,0)
            btn.Text=Settings[v]and"ON"or"OFF"
            Notif(t.." "..(Settings[v]and"ON"or"OFF"))
        end)
        y=y+50
    end

    AddSection("🎮 MAIN FEATURES")
    Slider("SPEED","Speed",16,200,"⚡")
    Slider("JUMP","Jump",50,200,"🦘")
    Slider("RADIUS","Radius",10,100,"📡")

    AddSection("⚙️ TOGGLES")
    Toggle("GOD MODE","God","👑")
    Toggle("ESP","ESP","👁️")
    Toggle("SAFETY","Safety","🛡️")
    Toggle("AUTO COLLECT","AutoCollect","📦")

    ScrollingFrame.CanvasSize=UDim2.new(0,0,0,y+50)
end

-- ==================================================
-- ESP FUNCTION
-- ==================================================
local function ClearESP()for _,v in pairs(ESP_Instances)do pcall(function()v:Destroy()end)end ESP_Instances={}end

local function AddESP(obj,color,txt)
    if not Settings.ESP or not obj or not obj.Parent then return end
    if obj:FindFirstChild("ZONE_XD_ESP")then return end
    local h=Instance.new("Highlight")
    h.Name="ZONE_XD_ESP"
    h.Parent=obj
    h.FillColor=color
    h.OutlineColor=Color3.new(1,1,1)
    h.FillTransparency=0.4
    table.insert(ESP_Instances,h)
    local b=Instance.new("BillboardGui")
    b.Parent=obj
    b.Size=UDim2.new(0,150,0,35)
    b.AlwaysOnTop=true
    b.StudsOffset=Vector3.new(0,3,0)
    table.insert(ESP_Instances,b)
    local l=Instance.new("TextLabel")
    l.Parent=b
    l.Size=UDim2.new(1,0,1,0)
    l.Text="✨ "..txt.." ✨"
    l.TextColor3=color
    l.BackgroundTransparency=1
    l.TextStrokeColor3=Color3.new(0,0,0)
    l.TextStrokeTransparency=0
    l.TextScaled=true
    l.Font=Enum.Font.GothamBold
    table.insert(ESP_Instances,l)
end

-- ==================================================
-- DETEKSI ITEM (SUPER LENGKAP - INDONESIA + INGGRIS + KODE GAME)
-- ==================================================
local function IsItem(n)
    return 
           -- INDONESIA
           n:find("kacamata")or n:find("kaca mata")or
           n:find("dompet")or
           n:find("jam")or n:find("arloji")or
           n:find("pena")or n:find("pulpen")or n:find("bolpen")or
           n:find("kartu")or n:find("ktp")or
           n:find("papan")or n:find("klip")or
           n:find("rekam")or n:find("medis")or
           n:find("kunci")or n:find("uang")or n:find("koin")or
           
           -- INGGRIS
           n:find("glasses")or n:find("spectacles")or
           n:find("wallet")or n:find("purse")or
           n:find("watch")or n:find("wristwatch")or
           n:find("pen")or n:find("red pen")or
           n:find("card")or n:find("id")or n:find("identity")or
           n:find("clipboard")or n:find("board")or
           n:find("medical")or n:find("record")or
           n:find("key")or n:find("coin")or n:find("money")or
           
           -- KODE GAME (BIAR AMAN)
           n:find("pickup")or n:find("item")or n:find("collect")or
           n:find("obj")or n:find("prop")or n:find("asset")or
           n:find("box")or n:find("chest")or n:find("crate")or
           n:find("folder")or n:find("part")
end

local function IsPocong(n)
    return n:find("pocong")or n:find("hantu")or n:find("ghost")or
           n:find("setan")or n:find("demon")or n:find("kunti")or
           n:find("sundel")or n:find("tuyul")or n:find("monster")
end

-- ==================================================
-- SCAN WORLD
-- ==================================================
local function ScanWorld()
    ClearESP()
    if not Settings.ESP then return end
    for _,v in pairs(Workspace:GetDescendants())do
        if v:IsA("Part")and v.Parent~=LocalPlayer.Character then
            if IsItem(v.Name:lower())then
                AddESP(v,Color3.fromRGB(0,255,100),v.Name)
            end
        end
        if v:IsA("Model")and v:FindFirstChild("Humanoid")then
            if IsPocong(v.Name:lower())then
                AddESP(v,Color3.fromRGB(255,0,0),"💀 POCONG")
            end
        end
    end
end

-- ==================================================
-- AUTO COLLECT
-- ==================================================
local function AutoCollect()
    if not Settings.AutoCollect or not LocalPlayer.Character then return end
    local root=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _,v in pairs(Workspace:GetDescendants())do
        if v:IsA("Part")and v.Parent~=LocalPlayer.Character and IsItem(v.Name:lower())then
            if(v.Position-root.Position).Magnitude<8 then
                pcall(function()
                    firetouchinterest(root,v,0)
                    task.wait(0.05)
                    firetouchinterest(root,v,1)
                    if v:FindFirstChildOfClass("ClickDetector")then
                        fireclickdetector(v:FindFirstChildOfClass("ClickDetector"))
                    end
                end)
                task.wait(0.3)
                break
            end
        end
    end
end

-- ==================================================
-- SAFETY RUN
-- ==================================================
local function SafetyRun()
    if not Settings.Safety or not LocalPlayer.Character or IsTeleporting then return end
    local root=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _,v in pairs(Workspace:GetDescendants())do
        if v:IsA("Model")and v:FindFirstChild("HumanoidRootPart")and IsPocong(v.Name:lower())then
            local dist=(v.HumanoidRootPart.Position-root.Position).Magnitude
            if dist<Settings.Radius then
                ScanHidePos()
                local target=GetNearestHidePos(root.Position)
                IsTeleporting=true
                root.CFrame=CFrame.new(target)
                Notif("⚠️ SAFETY: LARI KE POS AMAN")
                task.wait(1)
                IsTeleporting=false
                break
            end
        end
    end
end

-- ==================================================
-- TELEPORT MANUAL
-- ==================================================
local function TeleportNearest()
    if not LocalPlayer.Character or IsTeleporting then return end
    local root=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local near,dist=nil,999
    for _,v in pairs(Workspace:GetDescendants())do
        if v:IsA("Part")and v.Parent~=LocalPlayer.Character and IsItem(v.Name:lower())then
            local d=(v.Position-root.Position).Magnitude
            if d<dist then near,dist=v,d end
        end
    end
    if near then
        IsTeleporting=true
        root.CFrame=CFrame.new(near.Position+Vector3.new(0,3,0))
        Notif("📦 Teleport ke "..near.Name)
        task.wait(0.5)
        IsTeleporting=false
    else
        Notif("❌ Tidak ada item")
    end
end

-- ==================================================
-- KEYBINDS
-- ==================================================
UserInputService.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode==Enum.KeyCode.M then
        Settings.MenuOpen=not Settings.MenuOpen
        if Frame and SmallBtn then
            Frame.Visible=Settings.MenuOpen
            SmallBtn.Visible=not Settings.MenuOpen
        end
    elseif i.KeyCode==Enum.KeyCode.T then
        TeleportNearest()
    end
end)

-- ==================================================
-- MAIN LOOP
-- ==================================================
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")then
        LocalPlayer.Character.Humanoid.WalkSpeed=Settings.Speed
        LocalPlayer.Character.Humanoid.JumpPower=Settings.Jump
    end
    GodMode()
    SafetyRun()
end)

task.spawn(function()while task.wait(2)do ScanWorld()end end)
task.spawn(function()while task.wait(1)do AutoCollect()end end)

CreateMenu()
ScanHidePos()
Notif("🔥 ZONE XD V2 LOADED")

print([[
╔══════════════════════════════════════════════════════════════╗
║   🔥 ZONE XD V2 - FINAL 🔥                                   ║
║   ✅ GOD MODE (TAK BISA MATI)                                ║
║   ✅ ESP SUPER LENGKAP (INDONESIA + INGGRIS + KODE GAME)     ║
║   ✅ MENU BAGUS (GRADIEN + ICON)                             ║
║   👑 COPYRIGHT: APIS (USER 01) - ZONE XD V1                  ║
╚══════════════════════════════════════════════════════════════╝
]])