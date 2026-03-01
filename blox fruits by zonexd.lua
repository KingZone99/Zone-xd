-- ZONE XD BLOX FRUITS ULTIMATE - CLEAN VERSION
-- COPYRIGHT: APIS (USER 01)

local plr=game:GetService("Players").LocalPlayer
local gui=plr:WaitForChild("PlayerGui")
local ws=game:GetService("Workspace")
local uis=game:GetService("UserInputService")
local rs=game:GetService("RunService")
local ts=game:GetService("TweenService")
local rs2=game:GetService("ReplicatedStorage")
local vu=game:GetService("VirtualUser")

local set={
    AutoFarm=false, AutoQuest=false, AutoRaid=false, AutoBoss=false,
    FruitSniper=false, FruitESP=false, ESPPlayers=false, ESPEnemies=false,
    ESPChests=false, GodMode=false, AutoStats=false, AutoSkill=false,
    BringMob=false, SpeedBoost=false, SpeedValue=50, JumpBoost=false,
    JumpValue=80, FlyMode=false, NoClip=false, AutoCollectChests=false,
    AntiAFK=false, MenuOpen=true, MenuMin=false
}

local esp={}
local tp=false

local function notif(t)pcall(function()game:GetService("StarterGui"):SetCore("SendNotification",{Title="ZONE XD",Text=t,Duration=2})end)end

local sg=Instance.new("ScreenGui")
sg.Name="ZoneXD"
sg.Parent=gui
sg.ResetOnSpawn=false

local main=Instance.new("Frame")
main.Size=UDim2.new(0,320,0,500)
main.Position=UDim2.new(0.02,0,0.1,0)
main.BackgroundColor3=Color3.fromRGB(15,15,20)
main.BorderColor3=Color3.fromRGB(0,200,255)
main.BorderSizePixel=2
main.Active=true
main.Draggable=true
main.Parent=sg
main.Visible=set.MenuOpen

local mc=Instance.new("UICorner")
mc.CornerRadius=UDim.new(0,8)
mc.Parent=main

local bar=Instance.new("Frame")
bar.Size=UDim2.new(1,0,0,35)
bar.BackgroundColor3=Color3.fromRGB(0,80,160)
bar.Parent=main

local bc=Instance.new("UICorner")
bc.CornerRadius=UDim.new(0,8)
bc.Parent=bar

local title=Instance.new("TextLabel")
title.Size=UDim2.new(1,-70,1,0)
title.Position=UDim2.new(0.05,0,0,0)
title.BackgroundTransparency=1
title.Text=" ZONE XD"
title.TextColor3=Color3.new(1,1,1)
title.TextScaled=true
title.Font=Enum.Font.GothamBlack
title.Parent=bar

local min=Instance.new("TextButton")
min.Size=UDim2.new(0,25,0,25)
min.Position=UDim2.new(1,-60,0,5)
min.BackgroundColor3=Color3.fromRGB(255,150,0)
min.Text=set.Menu and""or""
min.TextColor3=Color3.new(1,1,1)
min.TextScaled=true
min.Font=Enum.Font.GothamBlack
min.BorderSizePixel=0
min.Parent=bar

local close=Instance.new("TextButton")
close.Size=UDim2.new(0,25,0,25)
close.Position=UDim2.new(1,-30,0,5)
close.BackgroundColor3=Color3.fromRGB(255,0,0)
close.Text="X"
close.TextColor3=Color3.new(1,1,1)
close.TextScaled=true
close.Font=Enum.Font.GothamBlack
close.BorderSizePixel=0
close.Parent=bar

local sf=Instance.new("ScrollingFrame")
sf.Size=UDim2.new(1,0,1,-35)
sf.Position=UDim2.new(0,0,0,35)
sf.BackgroundTransparency=1
sf.CanvasSize=UDim2.new(0,0,0,800)
sf.ScrollBarThickness=6
sf.Parent=main

local y=10
local function sec(t)
    local s=Instance.new("TextLabel")
    s.Size=UDim2.new(0.95,0,0,25)
    s.Position=UDim2.new(0.025,0,0,y)
    s.BackgroundColor3=Color3.fromRGB(0,80,140)
    s.Text=" "..t.." "
    s.TextColor3=Color3.new(1,1,1)
    s.TextScaled=true
    s.Font=Enum.Font.GothamBlack
    s.Parent=sf
    local sc=Instance.new("UICorner")
    sc.CornerRadius=UDim.new(0,5)
    sc.Parent=s
    y=y+30
end

local function tog(t,s,i)
    local bg=Instance.new("Frame")
    bg.Size=UDim2.new(0.95,0,0,35)
    bg.Position=UDim2.new(0.025,0,0,y)
    bg.BackgroundColor3=Color3.fromRGB(30,30,35)
    bg.Parent=sf
    local bgc=Instance.new("UICorner")
    bgc.CornerRadius=UDim.new(0,5)
    bgc.Parent=bg
    local ic=Instance.new("TextLabel")
    ic.Size=UDim2.new(0,25,1,0)
    ic.Position=UDim2.new(0.02,0,0,0)
    ic.BackgroundTransparency=1
    ic.Text=i or ""
    ic.TextColor3=Color3.fromRGB(0,200,255)
    ic.TextScaled=true
    ic.Font=Enum.Font.GothamBlack
    ic.Parent=bg
    local lb=Instance.new("TextLabel")
    lb.Size=UDim2.new(0.5,0,1,0)
    lb.Position=UDim2.new(0.15,0,0,0)
    lb.BackgroundTransparency=1
    lb.Text=t
    lb.TextColor3=Color3.new(1,1,1)
    lb.TextScaled=true
    lb.Font=Enum.Font.Gotham
    lb.Parent=bg
    local btn=Instance.new("TextButton")
    btn.Size=UDim2.new(0.2,0,0.8,0)
    btn.Position=UDim2.new(0.75,0,0.1,0)
    btn.BackgroundColor3=set[s]and Color3.fromRGB(0,180,0)or Color3.fromRGB(180,0,0)
    btn.Text=set[s]and"ON"or"OFF"
    btn.TextColor3=Color3.new(1,1,1)
    btn.TextScaled=true
    btn.Font=Enum.Font.GothamBlack
    btn.Parent=bg
    local btnc=Instance.new("UICorner")
    btnc.CornerRadius=UDim.new(0,5)
    btnc.Parent=btn
    btn.MouseButton1Click:Connect(function()
        set[s]=not set[s]
        btn.BackgroundColor3=set[s]and Color3.fromRGB(0,180,0)or Color3.fromRGB(180,0,0)
        btn.Text=set[s]and"ON"or"OFF"
        notif(t.." "..(set[s]and"ON"or"OFF"))
    end)
    y=y+40
end

local function slid(t,s,min,max,u,i)
    local bg=Instance.new("Frame")
    bg.Size=UDim2.new(0.95,0,0,45)
    bg.Position=UDim2.new(0.025,0,0,y)
    bg.BackgroundColor3=Color3.fromRGB(30,30,35)
    bg.Parent=sf
    local bgc=Instance.new("UICorner")
    bgc.CornerRadius=UDim.new(0,5)
    bgc.Parent=bg
    local ic=Instance.new("TextLabel")
    ic.Size=UDim2.new(0,25,1,0)
    ic.Position=UDim2.new(0.02,0,0,0)
    ic.BackgroundTransparency=1
    ic.Text=i or ""
    ic.TextColor3=Color3.fromRGB(0,200,255)
    ic.TextScaled=true
    ic.Font=Enum.Font.GothamBlack
    ic.Parent=bg
    local lb=Instance.new("TextLabel")
    lb.Size=UDim2.new(0.6,0,0.4,0)
    lb.Position=UDim2.new(0.15,0,0.05,0)
    lb.BackgroundTransparency=1
    lb.Text=t..": "..set[s]..(u or"")
    lb.TextColor3=Color3.new(1,1,1)
    lb.TextScaled=true
    lb.Font=Enum.Font.Gotham
    lb.Parent=bg
    local sb=Instance.new("Frame")
    sb.Size=UDim2.new(0.7,0,0.2,0)
    sb.Position=UDim2.new(0.15,0,0.5,0)
    sb.BackgroundColor3=Color3.fromRGB(60,60,70)
    sb.Parent=bg
    local fill=Instance.new("Frame")
    fill.Size=UDim2.new((set[s]-min)/(max-min),0,1,0)
    fill.BackgroundColor3=Color3.fromRGB(0,200,255)
    fill.Parent=sb
    local drag=Instance.new("TextButton")
    drag.Size=UDim2.new(0,10,1,0)
    drag.Position=UDim2.new((set[s]-min)/(max-min),-5,0,0)
    drag.BackgroundColor3=Color3.new(1,1,1)
    drag.Text=""
    drag.Parent=sb
    local drg=false
    drag.MouseButton1Down:Connect(function()drg=true end)
    uis.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then drg=false end end)
    rs.RenderStepped:Connect(function()
        if drg then
            local m=uis:GetMouseLocation()
            local p=sb.AbsolutePosition
            local sz=sb.AbsoluteSize.X
            local rx=math.clamp((m.X-p.X)/sz,0,1)
            local nv=min+(rx*(max-min))
            set[s]=math.floor(nv)
            lb.Text=t..": "..set[s]..(u or"")
            fill.Size=UDim2.new(rx,0,1,0)
            drag.Position=UDim2.new(rx,-5,0,0)
        end
    end)
    y=y+50
end

sec("AUTO FARM")
tog("Auto Farm","AutoFarm","")
tog("Auto Quest","AutoQuest","")
tog("Auto Raid","AutoRaid","")
tog("Auto Boss","AutoBoss","")

sec("FRUIT")
tog("Fruit Sniper","FruitSniper","")
tog("Fruit ESP","FruitESP","")

sec("ESP")
tog("ESP Players","ESPPlayers","")
tog("ESP Enemies","ESPEnemies","")
tog("ESP Chests","ESPChests","")

sec("COMBAT")
tog("God Mode","GodMode","")
tog("Auto Stats","AutoStats","")
tog("Auto Skill","AutoSkill","")
tog("Bring Mob","BringMob","")

sec("MOVEMENT")
tog("Speed Boost","SpeedBoost","")
slid("Speed","SpeedValue",16,200,"","")
tog("Jump Boost","JumpBoost","")
slid("Jump","JumpValue",50,200,"","")
tog("Fly","FlyMode","")
tog("No Clip","NoClip","")

sec("UTILITY")
tog("Auto Collect","AutoCollectChests","")
tog("Anti AFK","AntiAFK","")

sf.CanvasSize=UDim2.new(0,0,0,y+20)

min.MouseButton1Click:Connect(function()
    set.Menu=not set.Menu
    local sz=set.Menu and UDim2.new(0,320,0,35)or UDim2.new(0,320,0,500)
    ts:Create(main,TweenInfo.new(0.3),{Size=sz}):Play()
    min.Text=set.Menu and""or""
    sf.Visible=not set.Menu
end)

close.MouseButton1Click:Connect(function()
    set.MenuOpen=false
    main.Visible=false
end)

uis.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode==Enum.KeyCode.M then
        set.MenuOpen=not set.MenuOpen
        main.Visible=set.MenuOpen
    end
end)

local function clr()for _,v in pairs(esp)do pcall(function()v:Destroy()end)end esp={}end
local function add(o,c,t)
    if not o or not o.Parent then return end
    local h=Instance.new("Highlight")
    h.Parent=o
    h.FillColor=c
    h.OutlineColor=Color3.new(1,1,1)
    h.FillTransparency=0.4
    table.insert(esp,h)
    local b=Instance.new("BillboardGui")
    b.Parent=o
    b.Size=UDim2.new(0,100,0,25)
    b.AlwaysOnTop=true
    b.StudsOffset=Vector3.new(0,3,0)
    table.insert(esp,b)
    local l=Instance.new("TextLabel")
    l.Parent=b
    l.Size=UDim2.new(1,0,1,0)
    l.BackgroundTransparency=1
    l.Text=t
    l.TextColor3=c
    l.TextStrokeColor3=Color3.new(0,0,0)
    l.TextStrokeTransparency=0
    l.TextScaled=true
    l.Font=Enum.Font.GothamBold
    table.insert(esp,l)
end

local function upd()
    clr()
    if not set.ESPPlayers and not set.ESPEnemies and not set.ESPChests and not set.FruitESP then return end
    for _,v in pairs(ws:GetDescendants())do
        if set.ESPPlayers and v:IsA("Model")and v:FindFirstChild("Humanoid")and game.Players:GetPlayerFromCharacter(v)then
            add(v,Color3.fromRGB(0,100,255)," "..v.Name)
        end
        if set.ESPEnemies and v:IsA("Model")and v:FindFirstChild("Humanoid")and not game.Players:GetPlayerFromCharacter(v)then
            add(v,Color3.fromRGB(255,50,50)," "..v.Name)
        end
        if set.ESPChests and v:IsA("Part")and(v.Name:lower():find("chest")or v.Name:lower():find("box"))then
            add(v,Color3.fromRGB(255,255,0)," CHEST")
        end
        if set.FruitESP and v:IsA("Tool")and v.Name:lower():find("fruit")then
            add(v,Color3.fromRGB(255,0,255)," "..v.Name)
        end
    end
end

local function god()
    if not set.GodMode or not plr.Character then return end
    local h=plr.Character:FindFirstChild("Humanoid")
    if h then h.MaxHealth=math.huge h.Health=h.MaxHealth h.BreakJointsOnDeath=false end
end

local function afk()
    if not set.AntiAFK then return end
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end

local function farm()
    if not set.AutoFarm or not plr.Character then return end
    local c=plr.Character
    local h=c:FindFirstChild("Humanoid")
    local r=c:FindFirstChild("HumanoidRootPart")
    if not h or not r then return end
    local ne,nd=nil,9999
    for _,v in pairs(ws:GetDescendants())do
        if v:IsA("Model")and v:FindFirstChild("Humanoid")and v.Humanoid.Health>0 then
            if not game.Players:GetPlayerFromCharacter(v) and v.HumanoidRootPart then
                local d=(v.HumanoidRootPart.Position-r.Position).Magnitude
                if d<nd then ne,nd=v,d end
            end
        end
    end
    if ne and ne.HumanoidRootPart then
        h:MoveTo(ne.HumanoidRootPart.Position)
        local rem=rs2:FindFirstChild("Remotes")or rs2:FindFirstChild("Combat")
        if rem then rem:FireServer("Attack",ne.HumanoidRootPart.Position)end
    end
end

rs.RenderStepped:Connect(function()
    if set.AutoFarm then farm()end
    if set.GodMode then god()end
    if plr.Character and plr.Character:FindFirstChild("Humanoid")then
        plr.Character.Humanoid.WalkSpeed=set.SpeedBoost and set.SpeedValue or 16
        plr.Character.Humanoid.JumpPower=set.JumpBoost and set.JumpValue or 50
    end
    if set.NoClip and plr.Character then
        for _,v in pairs(plr.Character:GetDescendants())do
            if v:IsA("BasePart")then v.CanCollide=false end
        end
    end
end)

coroutine.wrap(function()while task.wait(2)do upd()end end)()
coroutine.wrap(function()while task.wait(300)do afk()end end)()

notif(" ZONE XD LOADED")
notif(" Tekan M buka/tutup menu")

print("ZONE XD BLOX FRUITS - COPYRIGHT: APIS (USER 01)")