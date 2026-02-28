-- COPYRIGHT: APIS (USER 01) - ZONE XD V1
local Players=game:GetService("Players")
local LocalPlayer=Players.LocalPlayer
local Workspace=game:GetService("Workspace")
local UserInputService=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local StarterGui=game:GetService("StarterGui")
local TweenService=game:GetService("TweenService")
local Debris=game:GetService("Debris")
local VirtualInputManager=game:GetService("VirtualInputManager")
local CoreGui=game:GetService("CoreGui")
local Settings={TeleportEnabled=true,ESPEnabled=true,AutoCollectEnabled=true,AutoFarmEnabled=false,WallhackEnabled=true,SpeedEnabled=false,JumpEnabled=false,NoClipEnabled=false,TeleportKey=Enum.KeyCode.T,ToggleMenuKey=Enum.KeyCode.M,SpeedValue=50,JumpValue=80,ESPColor_Items=Color3.new(0,1,0),ESPColor_Pocongs=Color3.new(1,0,0),ESPColor_Players=Color3.new(0,0,1),ESPColor_Storage=Color3.new(1,1,0)}
local MenuOpen=false
local ScreenGui
local Frame
local ToggleButtons={}
local ESP={}
local ESP_Instances={}
local IsTeleporting=false
local CurrentTarget=nil

local function SendNotification(t,txt,d)
    pcall(function()StarterGui:SetCore("SendNotification",{Title=t or "ZONE XD",Text=txt or "",Duration=d or 2})end)
end

local function CreateMenu()
    if ScreenGui then ScreenGui:Destroy()end
    ScreenGui=Instance.new("ScreenGui")
    ScreenGui.Name="ZoneXDMenu"
    ScreenGui.ResetOnSpawn=false
    ScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    pcall(function()ScreenGui.Parent=CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent=LocalPlayer:FindFirstChild("PlayerGui")or LocalPlayer.PlayerGui end
    Frame=Instance.new("Frame")
    Frame.Parent=ScreenGui
    Frame.BackgroundColor3=Color3.fromRGB(20,20,20)
    Frame.BackgroundTransparency=0.1
    Frame.BorderColor3=Color3.fromRGB(0,255,255)
    Frame.BorderSizePixel=3
    Frame.Position=UDim2.new(0.02,0,0.1,0)
    Frame.Size=UDim2.new(0,280,0,500)
    Frame.Visible=MenuOpen
    Frame.Active=true
    Frame.Draggable=true
    local TitleBar=Instance.new("Frame")
    TitleBar.Parent=Frame
    TitleBar.BackgroundColor3=Color3.fromRGB(0,100,200)
    TitleBar.Size=UDim2.new(1,0,0,40)
    TitleBar.BorderSizePixel=0
    local Title=Instance.new("TextLabel")
    Title.Parent=TitleBar
    Title.BackgroundTransparency=1
    Title.Size=UDim2.new(1,-40,1,0)
    Title.Text="ZONE XD - POCONG V2"
    Title.TextColor3=Color3.fromRGB(255,255,255)
    Title.TextScaled=true
    Title.Font=Enum.Font.GothamBlack
    Title.TextXAlignment=Enum.TextXAlignment.Left
    local CloseBtn=Instance.new("TextButton")
    CloseBtn.Parent=TitleBar
    CloseBtn.BackgroundColor3=Color3.fromRGB(255,50,50)
    CloseBtn.Size=UDim2.new(0,30,0,30)
    CloseBtn.Position=UDim2.new(1,-35,0,5)
    CloseBtn.Text="X"
    CloseBtn.TextColor3=Color3.fromRGB(255,255,255)
    CloseBtn.TextScaled=true
    CloseBtn.Font=Enum.Font.GothamBlack
    CloseBtn.BorderSizePixel=0
    CloseBtn.MouseButton1Click:Connect(function()MenuOpen=false;Frame.Visible=false end)
    local ScrollingFrame=Instance.new("ScrollingFrame")
    ScrollingFrame.Parent=Frame
    ScrollingFrame.BackgroundColor3=Color3.fromRGB(30,30,30)
    ScrollingFrame.Size=UDim2.new(1,0,1,-45)
    ScrollingFrame.Position=UDim2.new(0,0,0,45)
    ScrollingFrame.CanvasSize=UDim2.new(0,0,0,600)
    ScrollingFrame.ScrollBarThickness=8
    ScrollingFrame.BorderSizePixel=0
    local yPos=10
    local function AddSection(t)
        local s=Instance.new("TextLabel")
        s.Parent=ScrollingFrame
        s.BackgroundColor3=Color3.fromRGB(0,150,255)
        s.Size=UDim2.new(0.95,0,0,30)
        s.Position=UDim2.new(0.025,0,0,yPos)
        s.Text=t
        s.TextColor3=Color3.fromRGB(255,255,255)
        s.TextScaled=true
        s.Font=Enum.Font.GothamBlack
        yPos=yPos+35
    end
    local function CreateToggle(t,v)
        local btn=Instance.new("TextButton")
        btn.Parent=ScrollingFrame
        btn.BackgroundColor3=Settings[v]and Color3.fromRGB(0,255,0)or Color3.fromRGB(255,0,0)
        btn.Size=UDim2.new(0.9,0,0,40)
        btn.Position=UDim2.new(0.05,0,0,yPos)
        btn.Text=t..": "..(Settings[v]and"ON"or"OFF")
        btn.TextColor3=Color3.fromRGB(255,255,255)
        btn.TextScaled=true
        btn.Font=Enum.Font.GothamBlack
        btn.MouseButton1Click:Connect(function()
            Settings[v]=not Settings[v]
            btn.BackgroundColor3=Settings[v]and Color3.fromRGB(0,255,0)or Color3.fromRGB(255,0,0)
            btn.Text=t..": "..(Settings[v]and"ON"or"OFF")
            SendNotification("ZONE XD",t.." "..(Settings[v]and"ON"or"OFF"),1)
            if v=="ESPEnabled"and not Settings.ESPEnabled then for _,v in pairs(ESP_Instances)do pcall(function()v:Destroy()end)end ESP_Instances={}end end
        end)
        table.insert(ToggleButtons,btn)
        yPos=yPos+45
    end
    local function CreateSlider(t,v,min,max)
        local sf=Instance.new("Frame")
        sf.Parent=ScrollingFrame
        sf.BackgroundColor3=Color3.fromRGB(50,50,50)
        sf.Size=UDim2.new(0.9,0,0,50)
        sf.Position=UDim2.new(0.05,0,0,yPos)
        yPos=yPos+55
        local lbl=Instance.new("TextLabel")
        lbl.Parent=sf
        lbl.BackgroundTransparency=1
        lbl.Size=UDim2.new(1,0,0,20)
        lbl.Text=t..": "..Settings[v]
        lbl.TextColor3=Color3.fromRGB(255,255,255)
        lbl.TextScaled=true
        local sld=Instance.new("Frame")
        sld.Parent=sf
        sld.BackgroundColor3=Color3.fromRGB(100,100,100)
        sld.Size=UDim2.new(1,0,0,10)
        sld.Position=UDim2.new(0,0,0,25)
        local fill=Instance.new("Frame")
        fill.Parent=sld
        fill.BackgroundColor3=Color3.fromRGB(0,255,0)
        fill.Size=UDim2.new((Settings[v]-min)/(max-min),0,1,0)
        local drag=Instance.new("TextButton")
        drag.Parent=sld
        drag.BackgroundColor3=Color3.fromRGB(255,255,255)
        drag.Size=UDim2.new(0,15,1,0)
        drag.Position=UDim2.new((Settings[v]-min)/(max-min),-7.5,0,0)
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
                drag.Position=UDim2.new(rx,-7.5,0,0)
            end
        end)
    end
    AddSection("MAIN FEATURES")
    CreateToggle("TELEPORT","TeleportEnabled")
    CreateToggle("ESP","ESPEnabled")
    CreateToggle("AUTO COLLECT","AutoCollectEnabled")
    CreateToggle("AUTO FARM","AutoFarmEnabled")
    AddSection("VISUAL")
    CreateToggle("WALLHACK","WallhackEnabled")
    AddSection("PLAYER")
    CreateToggle("SPEED BOOST","SpeedEnabled")
    CreateToggle("SUPER JUMP","JumpEnabled")
    CreateToggle("NOCLIP","NoClipEnabled")
    AddSection("SETTINGS")
    CreateSlider("SPEED","SpeedValue",16,200)
    CreateSlider("JUMP","JumpValue",50,200)
    local inf=Instance.new("TextLabel")
    inf.Parent=ScrollingFrame
    inf.BackgroundColor3=Color3.fromRGB(50,50,50)
    inf.Size=UDim2.new(0.9,0,0,50)
    inf.Position=UDim2.new(0.05,0,0,yPos+10)
    inf.Text="M = MENU\nT = TELEPORT"
    inf.TextColor3=Color3.fromRGB(255,255,255)
    inf.TextScaled=true
    ScrollingFrame.CanvasSize=UDim2.new(0,0,0,yPos+100)
end

function ESP:Clear()for _,v in pairs(ESP_Instances)do pcall(function()v:Destroy()end)end ESP_Instances={}end
function ESP:Add(obj,color,txt)
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
    local t=Instance.new("TextLabel")
    t.Parent=b
    t.Size=UDim2.new(1,0,1,0)
    t.BackgroundTransparency=1
    t.Text=txt or obj.Name
    t.TextColor3=color
    t.TextStrokeColor3=Color3.new(0,0,0)
    t.TextStrokeTransparency=0
    t.TextScaled=true
    table.insert(ESP_Instances,t)
end

local function GetItems()
    local it={}
    for _,v in pairs(Workspace:GetDescendants())do
        if v:IsA("Part")then
            local n=v.Name:lower()
            if n:find("coin")or n:find("key")or n:find("kunci")or n:find("uang")or n:find("beras")or n:find("batu")or n:find("kayu")or n:find("obat")or n:find("daun")then table.insert(it,v)end
        end
    end
    return it
end

local function GetPocongs()
    local p={}
    for _,v in pairs(Workspace:GetDescendants())do
        if v:IsA("Model")and(v:FindFirstChild("Humanoid")or v:FindFirstChild("Body"))then
            local n=v.Name:lower()
            if n:find("pocong")or n:find("hantu")or n:find("ghost")then table.insert(p,v)end
        end
    end
    return p
end

local function UpdateESP()
    ESP:Clear()
    if not Settings.ESPEnabled then return end
    for _,i in pairs(GetItems())do ESP:Add(i,Settings.ESPColor_Items,"📦"..i.Name)end
    for _,p in pairs(GetPocongs())do ESP:Add(p,Settings.ESPColor_Pocongs,"👻POCONG")end
end

local function TeleportToItem(it)
    if not Settings.TeleportEnabled or IsTeleporting or not LocalPlayer.Character then return end
    local r=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not r then return end
    IsTeleporting=true
    local pos=it.Position
    local b=Instance.new("Part")
    b.Size=Vector3.new(1,1,(r.Position-pos).Magnitude)
    b.BrickColor=BrickColor.new("Bright blue")
    b.Material=Enum.Material.Neon
    b.Anchored=true
    b.CanCollide=false
    b.Transparency=0.3
    b.CFrame=CFrame.lookAt((r.Position+pos)/2,pos)*CFrame.new(0,0,-b.Size.Z/2)
    b.Parent=Workspace
    Debris:AddItem(b,0.3)
    r.CFrame=CFrame.new(pos+Vector3.new(0,2,0))
    SendNotification("ZONE XD","Teleport ke "..it.Name,1)
    wait(0.3)
    IsTeleporting=false
end

local function TeleportNearest()
    if not LocalPlayer.Character then return end
    local r=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local items=GetItems()
    local near,dist=nil,999
    for _,i in pairs(items)do
        local d=(i.Position-r.Position).Magnitude
        if d<dist then near,dist=i,d end
    end
    if near then TeleportToItem(near)else SendNotification("ZONE XD","Tidak ada item",1)end
end

local function AutoCollect()
    if not Settings.AutoCollectEnabled or not LocalPlayer.Character then return end
    local r=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not r then return end
    for _,i in pairs(GetItems())do
        if(i.Position-r.Position).Magnitude<5 then
            VirtualInputManager:SendKeyEvent(true,Enum.KeyCode.E,false,game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(false,Enum.KeyCode.E,false,game)
            SendNotification("ZONE XD","Ambil "..i.Name,1)
            wait(0.5)
            break
        end
    end
end

local function UpdateStats()
    if not LocalPlayer.Character then return end
    local h=LocalPlayer.Character:FindFirstChild("Humanoid")
    if h then
        h.WalkSpeed=Settings.SpeedEnabled and Settings.SpeedValue or 16
        h.JumpPower=Settings.JumpEnabled and Settings.JumpValue or 50
    end
    if Settings.NoClipEnabled and LocalPlayer.Character then
        for _,v in pairs(LocalPlayer.Character:GetDescendants())do if v:IsA("Part")then v.CanCollide=false end end
    end
end

local function Init()
    CreateMenu()
    SendNotification("ZONE XD","LOADED! Tekan M",2)
    coroutine.wrap(function()while wait(1)do UpdateESP()end end)()
    coroutine.wrap(function()while wait(0.5)do AutoCollect()UpdateStats()if Settings.AutoFarmEnabled then TeleportNearest()end end end)()
end

UserInputService.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode==Enum.KeyCode.M then
        MenuOpen=not MenuOpen
        if Frame then Frame.Visible=MenuOpen end
        SendNotification("ZONE XD",MenuOpen and"Menu dibuka"or"Menu ditutup",1)
    elseif i.KeyCode==Enum.KeyCode.T then
        TeleportNearest()
    end
end)

Init()
print("ZONE XD - POCONG V2 LOADED")