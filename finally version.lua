-- COPYRIGHT: APIS (USER 01) - ZONE XD V1
local Players=game:GetService("Players")
local LocalPlayer=Players.LocalPlayer
local Workspace=game:GetService("Workspace")
local UserInputService=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local StarterGui=game:GetService("StarterGui")
local CoreGui=game:GetService("CoreGui")

local Settings={
    Speed=70,
    Jump=100,
    ESP=true,
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
local HidePos=nil

local function Notif(t)pcall(function()StarterGui:SetCore("SendNotification",{Title="ZONE XD",Text=t,Duration=2})end)end

local function FindHidePos()
    HidePos=nil
    for _,v in pairs(Workspace:GetDescendants())do
        if v:IsA("Part")and(v.Name=="HidePos"or v.Name:lower():find("hide"))then
            HidePos=v.Position+Vector3.new(0,3,0)
            break
        end
    end
    if not HidePos then HidePos=Vector3.new(0,10,0)end
end

local function CreateMenu()
    if ScreenGui then ScreenGui:Destroy()end
    ScreenGui=Instance.new("ScreenGui")
    ScreenGui.Name="ZoneXDMenu"
    ScreenGui.ResetOnSpawn=false
    pcall(function()ScreenGui.Parent=CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent=LocalPlayer:FindFirstChild("PlayerGui")or LocalPlayer.PlayerGui end

    SmallBtn=Instance.new("TextButton")
    SmallBtn.Parent=ScreenGui
    SmallBtn.BackgroundColor3=Color3.fromRGB(0,100,200)
    SmallBtn.BorderColor3=Color3.fromRGB(0,255,255)
    SmallBtn.BorderSizePixel=2
    SmallBtn.Position=UDim2.new(0.02,0,0.1,0)
    SmallBtn.Size=UDim2.new(0,50,0,50)
    SmallBtn.Text="⚡"
    SmallBtn.TextColor3=Color3.new(1,1,1)
    SmallBtn.TextScaled=true
    SmallBtn.Font=Enum.Font.GothamBlack
    SmallBtn.Draggable=true
    SmallBtn.Visible=not Settings.MenuOpen

    Frame=Instance.new("Frame")
    Frame.Parent=ScreenGui
    Frame.BackgroundColor3=Color3.fromRGB(20,20,20)
    Frame.BorderColor3=Color3.fromRGB(0,255,255)
    Frame.BorderSizePixel=3
    Frame.Position=UDim2.new(0.02,0,0.1,0)
    Frame.Size=UDim2.new(0,280,0,380)
    Frame.Visible=Settings.MenuOpen
    Frame.Active=true
    Frame.Draggable=true

    local TitleBar=Instance.new("Frame")
    TitleBar.Parent=Frame
    TitleBar.BackgroundColor3=Color3.fromRGB(0,100,200)
    TitleBar.Size=UDim2.new(1,0,0,40)

    local Title=Instance.new("TextLabel")
    Title.Parent=TitleBar
    Title.BackgroundTransparency=1
    Title.Size=UDim2.new(1,-70,1,0)
    Title.Text="ZONE XD FINAL"
    Title.TextColor3=Color3.new(1,1,1)
    Title.TextScaled=true
    Title.Font=Enum.Font.GothamBlack

    local MinBtn=Instance.new("TextButton")
    MinBtn.Parent=TitleBar
    MinBtn.BackgroundColor3=Color3.fromRGB(255,150,0)
    MinBtn.Size=UDim2.new(0,30,0,30)
    MinBtn.Position=UDim2.new(1,-70,0,5)
    MinBtn.Text="_"
    MinBtn.TextColor3=Color3.new(1,1,1)
    MinBtn.TextScaled=true
    MinBtn.Font=Enum.Font.GothamBlack
    MinBtn.MouseButton1Click:Connect(function()
        Settings.MenuOpen=false
        Frame.Visible=false
        SmallBtn.Visible=true
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
    CloseBtn.MouseButton1Click:Connect(function()
        Frame.Visible=false
        SmallBtn.Visible=false
    end)

    SmallBtn.MouseButton1Click:Connect(function()
        Settings.MenuOpen=true
        SmallBtn.Visible=false
        Frame.Visible=true
    end)

    local y=50
    local function Slider(t,v,min,max)
        local bg=Instance.new("Frame")
        bg.Parent=Frame
        bg.BackgroundColor3=Color3.fromRGB(50,50,50)
        bg.Size=UDim2.new(0.9,0,0,50)
        bg.Position=UDim2.new(0.05,0,0,y)

        local lbl=Instance.new("TextLabel")
        lbl.Parent=bg
        lbl.BackgroundTransparency=1
        lbl.Size=UDim2.new(1,0,0,20)
        lbl.Text=t..": "..Settings[v]
        lbl.TextColor3=Color3.new(1,1,1)
        lbl.TextScaled=true
        lbl.Font=Enum.Font.Gotham

        local sld=Instance.new("Frame")
        sld.Parent=bg
        sld.BackgroundColor3=Color3.fromRGB(80,80,80)
        sld.Size=UDim2.new(0.9,0,0,15)
        sld.Position=UDim2.new(0.05,0,0,25)

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
        y=y+60
    end

    local function Toggle(t,v)
        local bg=Instance.new("Frame")
        bg.Parent=Frame
        bg.BackgroundColor3=Color3.fromRGB(50,50,50)
        bg.Size=UDim2.new(0.9,0,0,40)
        bg.Position=UDim2.new(0.05,0,0,y)

        local lbl=Instance.new("TextLabel")
        lbl.Parent=bg
        lbl.BackgroundTransparency=1
        lbl.Size=UDim2.new(0.6,0,1,0)
        lbl.Position=UDim2.new(0.05,0,0,0)
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
        y=y+45
    end

    Slider("SPEED","Speed",16,200)
    Slider("JUMP","Jump",50,200)
    Slider("RADIUS","Radius",10,100)
    Toggle("ESP","ESP")
    Toggle("SAFETY","Safety")
    Toggle("AUTO COLLECT","AutoCollect")

    local info=Instance.new("TextLabel")
    info.Parent=Frame
    info.BackgroundColor3=Color3.fromRGB(30,30,30)
    info.Size=UDim2.new(0.9,0,0,40)
    info.Position=UDim2.new(0.05,0,0,y+10)
    info.Text="M = MENU | T = TP"
    info.TextColor3=Color3.new(1,1,1)
    info.TextScaled=true
end

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
    b.Size=UDim2.new(0,120,0,30)
    b.AlwaysOnTop=true
    b.StudsOffset=Vector3.new(0,3,0)
    table.insert(ESP_Instances,b)
    local l=Instance.new("TextLabel")
    l.Parent=b
    l.Size=UDim2.new(1,0,1,0)
    l.Text=txt
    l.TextColor3=color
    l.BackgroundTransparency=1
    l.TextStrokeColor3=Color3.new(0,0,0)
    l.TextStrokeTransparency=0
    l.TextScaled=true
    l.Font=Enum.Font.GothamBold
    table.insert(ESP_Instances,l)
end

-- DUA BAHASA: INDONESIA + INGGRIS
local function IsItem(n)
    return n:find("kacamata")or n:find("kaca mata")or n:find("glasses")or
           n:find("dompet")or n:find("wallet")or n:find("purse")or
           n:find("jam")or n:find("watch")or n:find("arloji")or n:find("wristwatch")or
           n:find("pena")or n:find("pulpen")or n:find("pen")or n:find("bolpen")or n:find("merah")or
           n:find("kartu")or n:find("id")or n:find("ktp")or n:find("card")or n:find("identity")or
           n:find("papan")or n:find("klip")or n:find("clipboard")or n:find("board")or
           n:find("rekam")or n:find("medis")or n:find("rekam medis")or n:find("medical")or n:find("record")or
           n:find("key")or n:find("kunci")or n:find("coin")or n:find("uang")
end

local function IsPocong(n)
    return n:find("pocong")or n:find("hantu")or n:find("ghost")or n:find("setan")or
           n:find("demon")or n:find("kunti")or n:find("sundel")or n:find("tuyul")
end

local function ScanWorld()
    ClearESP()
    if not Settings.ESP then return end
    for _,v in pairs(Workspace:GetDescendants())do
        if v:IsA("Part")and v.Parent~=LocalPlayer.Character then
            if IsItem(v.Name:lower())then
                AddESP(v,Color3.fromRGB(0,255,100),"📦 "..v.Name)
            end
        end
        if v:IsA("Model")and v:FindFirstChild("Humanoid")then
            if IsPocong(v.Name:lower())then
                AddESP(v,Color3.fromRGB(255,0,0),"👻 POCONG")
            end
        end
    end
end

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

local function SafetyRun()
    if not Settings.Safety or not LocalPlayer.Character or IsTeleporting then return end
    local root=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _,v in pairs(Workspace:GetDescendants())do
        if v:IsA("Model")and v:FindFirstChild("HumanoidRootPart")and IsPocong(v.Name:lower())then
            local dist=(v.HumanoidRootPart.Position-root.Position).Magnitude
            if dist<Settings.Radius then
                FindHidePos()
                IsTeleporting=true
                root.CFrame=CFrame.new(HidePos)
                Notif("⚠️ SAFETY: TELEPORT KE HIDEPOS")
                task.wait(1)
                IsTeleporting=false
                break
            end
        end
    end
end

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
        Notif("Teleport ke "..near.Name)
        task.wait(0.5)
        IsTeleporting=false
    else
        Notif("Tidak ada item")
    end
end

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

RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")then
        LocalPlayer.Character.Humanoid.WalkSpeed=Settings.Speed
        LocalPlayer.Character.Humanoid.JumpPower=Settings.Jump
    end
    SafetyRun()
end)

task.spawn(function()while task.wait(2)do ScanWorld()end end)
task.spawn(function()while task.wait(1)do AutoCollect()end end)

CreateMenu()
FindHidePos()
Notif("ZONE XD FINAL LOADED")