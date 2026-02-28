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

local Settings={
    TeleportEnabled=true,
    ESPEnabled=true,
    AutoCollectEnabled=true,
    AutoFarmEnabled=false,
    SpeedEnabled=false,
    JumpEnabled=false,
    NoClipEnabled=false,
    SpeedValue=50,
    JumpValue=80
}

local MenuOpen=false
local ScreenGui
local Frame
local ESP={}
local ESP_Instances={}
local IsTeleporting=false

local function Notif(t,txt)
    pcall(function()StarterGui:SetCore("SendNotification",{Title=t or "ZONE XD",Text=txt or "",Duration=2})end)
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
    Frame.Size=UDim2.new(0,250,0,400)
    Frame.Visible=MenuOpen
    Frame.Active=true
    Frame.Draggable=true
    
    local Title=Instance.new("TextLabel")
    Title.Parent=Frame
    Title.BackgroundColor3=Color3.fromRGB(0,100,200)
    Title.Size=UDim2.new(1,0,0,40)
    Title.Text="ZONE XD - POCONG V2"
    Title.TextColor3=Color3.new(1,1,1)
    Title.TextScaled=true
    Title.Font=Enum.Font.GothamBlack
    
    local Close=Instance.new("TextButton")
    Close.Parent=Frame
    Close.BackgroundColor3=Color3.fromRGB(255,0,0)
    Close.Size=UDim2.new(0,30,0,30)
    Close.Position=UDim2.new(1,-35,0,5)
    Close.Text="X"
    Close.TextColor3=Color3.new(1,1,1)
    Close.TextScaled=true
    Close.Font=Enum.Font.GothamBlack
    Close.MouseButton1Click:Connect(function()MenuOpen=false;Frame.Visible=false end)
    
    local y=50
    local function Toggle(t,v)
        local btn=Instance.new("TextButton")
        btn.Parent=Frame
        btn.BackgroundColor3=Settings[v]and Color3.new(0,1,0)or Color3.new(1,0,0)
        btn.Size=UDim2.new(0.9,0,0,35)
        btn.Position=UDim2.new(0.05,0,0,y)
        btn.Text=t..": "..(Settings[v]and"ON"or"OFF")
        btn.TextColor3=Color3.new(1,1,1)
        btn.TextScaled=true
        btn.Font=Enum.Font.GothamBlack
        btn.MouseButton1Click:Connect(function()
            Settings[v]=not Settings[v]
            btn.BackgroundColor3=Settings[v]and Color3.new(0,1,0)or Color3.new(1,0,0)
            btn.Text=t..": "..(Settings[v]and"ON"or"OFF")
            Notif("ZONE XD",t.." "..(Settings[v]and"ON"or"OFF"))
            if v=="ESPEnabled"and not Settings.ESPEnabled then
                for _,v in pairs(ESP_Instances)do pcall(function()v:Destroy()end)end
                ESP_Instances={}
            end
        end)
        y=y+40
    end
    
    Toggle("TELEPORT","TeleportEnabled")
    Toggle("ESP","ESPEnabled")
    Toggle("AUTO COLLECT","AutoCollectEnabled")
    Toggle("AUTO FARM","AutoFarmEnabled")
    Toggle("SPEED","SpeedEnabled")
    Toggle("JUMP","JumpEnabled")
    Toggle("NOCLIP","NoClipEnabled")
    
    local info=Instance.new("TextLabel")
    info.Parent=Frame
    info.BackgroundColor3=Color3.fromRGB(50,50,50)
    info.Size=UDim2.new(0.9,0,0,60)
    info.Position=UDim2.new(0.05,0,0,y+10)
    info.Text="M = MENU\nT = TELEPORT"
    info.TextColor3=Color3.new(1,1,1)
    info.TextScaled=true
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

local function GetItems()
    local items={}
    for _,v in pairs(Workspace:GetDescendants())do
        if v:IsA("Part")then
            local n=v.Name:lower()
            if n:find("coin")or n:find("key")or n:find("kunci")or n:find("uang")or n:find("beras")or n:find("batu")or n:find("kayu")then
                table.insert(items,v)
            end
        end
    end
    return items
end

local function GetPocongs()
    local poc={}
    for _,v in pairs(Workspace:GetDescendants())do
        if v:IsA("Model")and v:FindFirstChild("Humanoid")then
            local n=v.Name:lower()
            if n:find("pocong")or n:find("hantu")then
                table.insert(poc,v)
            end
        end
    end
    return poc
end

local function UpdateESP()
    ESP:Clear()
    if not Settings.ESPEnabled then return end
    for _,i in pairs(GetItems())do ESP:Add(i,Color3.new(0,1,0),"📦"..i.Name)end
    for _,p in pairs(GetPocongs())do ESP:Add(p,Color3.new(1,0,0),"👻POCONG")end
end

local function TeleportToItem(item)
    if not Settings.TeleportEnabled or IsTeleporting or not LocalPlayer.Character then return end
    local root=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    IsTeleporting=true
    root.CFrame=CFrame.new(item.Position+Vector3.new(0,3,0))
    Notif("ZONE XD","Teleport ke "..item.Name)
    wait(0.5)
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

local function AutoCollect()
    if not Settings.AutoCollectEnabled or not LocalPlayer.Character then return end
    local root=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _,i in pairs(GetItems())do
        if(i.Position-root.Position).Magnitude<5 then
            VirtualInputManager:SendKeyEvent(true,Enum.KeyCode.E,false,game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(false,Enum.KeyCode.E,false,game)
            wait(0.5)
            break
        end
    end
end

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

UserInputService.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode==Enum.KeyCode.M then
        MenuOpen=not MenuOpen
        if Frame then Frame.Visible=MenuOpen end
        Notif("ZONE XD",MenuOpen and"Menu ON"or"Menu OFF")
    elseif i.KeyCode==Enum.KeyCode.T then
        TeleportNearest()
    end
end)

CreateMenu()
Notif("ZONE XD","LOADED! Tekan M",3)

coroutine.wrap(function()while wait(1)do UpdateESP()end end)()
coroutine.wrap(function()while wait(0.5)do AutoCollect()UpdateStats()if Settings.AutoFarmEnabled then TeleportNearest()end end end)()

print("ZONE XD - POCONG V2 READY")