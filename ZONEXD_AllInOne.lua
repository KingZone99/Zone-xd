-- ============================================================
--   ZONEXD ALL-IN-ONE MENU
--   Password Protected | Tab Menu | Minimizable
--   Lever Finder + Troll Tools
--   Copyright © ZONEXD | tele apiszx
-- ============================================================

local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local LocalPlayer  = Players.LocalPlayer
local Camera       = workspace.CurrentCamera

local CORRECT_PASSWORD = "Apis123"

-- Bersihkan GUI lama
local oldGui = LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("ZONEXD_ALL")
if oldGui then oldGui:Destroy() end

local SG = Instance.new("ScreenGui")
SG.Name           = "ZONEXD_ALL"
SG.ResetOnSpawn   = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.IgnoreGuiInset = true
SG.Parent         = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- AUTO CHAT
-- ============================================================
local function sendChat(msg)
    local ok, TextChat = pcall(function() return game:GetService("TextChatService") end)
    if ok and TextChat and TextChat.ChatVersion == Enum.ChatVersion.TextChatService then
        pcall(function()
            local channel = TextChat.TextChannels:FindFirstChild("RBXGeneral")
            if channel then channel:SendAsync(msg) end
        end)
    else
        pcall(function()
            game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {Text = msg, Color = Color3.fromRGB(255,200,0)})
            pcall(function() game:GetService("Chat"):Chat(LocalPlayer.Character.Head, msg) end)
        end)
    end
end

-- ============================================================
-- PASSWORD GATE UI
-- ============================================================
local LOCK = Instance.new("Frame", SG)
LOCK.Name             = "LockScreen"
LOCK.Size             = UDim2.new(0, 260, 0, 150)
LOCK.Position         = UDim2.new(0.5, -130, 0.5, -75)
LOCK.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
LOCK.BorderSizePixel  = 0
Instance.new("UICorner", LOCK).CornerRadius = UDim.new(0, 10)

local lockStroke = Instance.new("UIStroke", LOCK)
lockStroke.Color     = Color3.fromRGB(255, 190, 0)
lockStroke.Thickness = 1.5

local lockTitle = Instance.new("TextLabel", LOCK)
lockTitle.Size     = UDim2.new(1, 0, 0, 36)
lockTitle.Position = UDim2.new(0, 0, 0, 8)
lockTitle.BackgroundTransparency = 1
lockTitle.Text      = "🔒 ZONEXD MENU"
lockTitle.TextSize  = 15
lockTitle.Font      = Enum.Font.GothamBold
lockTitle.TextColor3= Color3.fromRGB(255, 200, 0)

local lockSub = Instance.new("TextLabel", LOCK)
lockSub.Size     = UDim2.new(1, -20, 0, 18)
lockSub.Position = UDim2.new(0, 10, 0, 42)
lockSub.BackgroundTransparency = 1
lockSub.Text      = "Masukkan Password / Enter Password"
lockSub.TextSize  = 11
lockSub.Font      = Enum.Font.Gotham
lockSub.TextColor3= Color3.fromRGB(180, 180, 200)

local passInput = Instance.new("TextBox", LOCK)
passInput.Size             = UDim2.new(1, -20, 0, 32)
passInput.Position         = UDim2.new(0, 10, 0, 65)
passInput.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
passInput.Text             = ""
passInput.PlaceholderText  = "Password..."
passInput.TextSize         = 13
passInput.Font             = Enum.Font.Gotham
passInput.TextColor3       = Color3.fromRGB(255, 255, 255)
passInput.PlaceholderColor3= Color3.fromRGB(120, 120, 120)
passInput.ClearTextOnFocus = false
passInput.BorderSizePixel  = 0
Instance.new("UICorner", passInput).CornerRadius = UDim.new(0, 6)

local passPad = Instance.new("UIPadding", passInput)
passPad.PaddingLeft = UDim.new(0, 10)

local submitBtn = Instance.new("TextButton", LOCK)
submitBtn.Size             = UDim2.new(1, -20, 0, 30)
submitBtn.Position         = UDim2.new(0, 10, 0, 105)
submitBtn.BackgroundColor3 = Color3.fromRGB(255, 190, 0)
submitBtn.Text             = "MASUK / ENTER"
submitBtn.TextSize         = 13
submitBtn.Font             = Enum.Font.GothamBold
submitBtn.TextColor3       = Color3.fromRGB(20, 20, 20)
submitBtn.BorderSizePixel  = 0
Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0, 6)

local errLabel = Instance.new("TextLabel", LOCK)
errLabel.Size     = UDim2.new(1, -20, 0, 16)
errLabel.Position = UDim2.new(0, 10, 0, 102)
errLabel.BackgroundTransparency = 1
errLabel.Text      = ""
errLabel.TextSize  = 10
errLabel.Font      = Enum.Font.GothamBold
errLabel.TextColor3= Color3.fromRGB(255, 80, 80)
errLabel.Visible   = false

-- Drag lock screen
do
    local dragging, dragInput, dragStart, startPos
    LOCK.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = LOCK.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    LOCK.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            dragInput = inp
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if inp == dragInput and dragging then
            local delta = inp.Position - dragStart
            LOCK.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ============================================================
-- MAIN MENU (hidden until unlocked)
-- ============================================================
local MAIN = Instance.new("Frame", SG)
MAIN.Name             = "Main"
MAIN.Size             = UDim2.new(0, 280, 0, 400)
MAIN.Position         = UDim2.new(0.5, -140, 0.5, -200)
MAIN.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MAIN.BorderSizePixel  = 0
MAIN.ClipsDescendants = true
MAIN.Visible          = false
Instance.new("UICorner", MAIN).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", MAIN)
mainStroke.Color     = Color3.fromRGB(255, 190, 0)
mainStroke.Thickness = 1.5

-- Title Bar
local TITLE = Instance.new("Frame", MAIN)
TITLE.Size             = UDim2.new(1, 0, 0, 34)
TITLE.BackgroundColor3 = Color3.fromRGB(20, 16, 0)
TITLE.BorderSizePixel  = 0
Instance.new("UICorner", TITLE).CornerRadius = UDim.new(0, 10)

local TLBL = Instance.new("TextLabel", TITLE)
TLBL.Size     = UDim2.new(1, -64, 1, 0)
TLBL.Position = UDim2.new(0, 12, 0, 0)
TLBL.BackgroundTransparency = 1
TLBL.Text      = "⚡ ZONEXD MENU"
TLBL.TextSize  = 13
TLBL.Font      = Enum.Font.GothamBold
TLBL.TextColor3= Color3.fromRGB(255, 200, 0)
TLBL.TextXAlignment = Enum.TextXAlignment.Left

local MINBTN = Instance.new("TextButton", TITLE)
MINBTN.Size             = UDim2.new(0, 26, 0, 22)
MINBTN.Position         = UDim2.new(1, -32, 0.5, -11)
MINBTN.BackgroundColor3 = Color3.fromRGB(40, 30, 0)
MINBTN.Text             = "▼"
MINBTN.TextSize         = 11
MINBTN.Font             = Enum.Font.GothamBold
MINBTN.TextColor3       = Color3.fromRGB(255, 200, 0)
MINBTN.BorderSizePixel  = 0
Instance.new("UICorner", MINBTN).CornerRadius = UDim.new(0, 5)

-- ============================================================
-- TAB BAR (scrollable horizontal for many tabs)
-- ============================================================
local TABBAR = Instance.new("ScrollingFrame", MAIN)
TABBAR.Size             = UDim2.new(1, -12, 0, 30)
TABBAR.Position         = UDim2.new(0, 6, 0, 38)
TABBAR.BackgroundTransparency = 1
TABBAR.ScrollBarThickness = 2
TABBAR.ScrollingDirection = Enum.ScrollingDirection.X
TABBAR.CanvasSize       = UDim2.new(0, 0, 0, 0)
TABBAR.AutomaticCanvasSize = Enum.AutomaticSize.X

local TABLAYOUT = Instance.new("UIListLayout", TABBAR)
TABLAYOUT.FillDirection = Enum.FillDirection.Horizontal
TABLAYOUT.Padding       = UDim.new(0, 4)

-- Content area (one frame per tab)
local PAGES = Instance.new("Frame", MAIN)
PAGES.Size             = UDim2.new(1, -12, 1, -98)
PAGES.Position         = UDim2.new(0, 6, 0, 72)
PAGES.BackgroundTransparency = 1

local pageFrames = {}
local tabButtons = {}

local function selectTab(name)
    for n, f in pairs(pageFrames) do
        f.Visible = (n == name)
    end
    for n, b in pairs(tabButtons) do
        if n == name then
            b.BackgroundColor3 = Color3.fromRGB(255, 190, 0)
            b.TextColor3 = Color3.fromRGB(20, 20, 20)
        else
            b.BackgroundColor3 = Color3.fromRGB(25, 22, 10)
            b.TextColor3 = Color3.fromRGB(200, 190, 160)
        end
    end
end

local function createTab(name)
    local btn = Instance.new("TextButton", TABBAR)
    btn.Size             = UDim2.new(0, 64, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 22, 10)
    btn.Text             = name
    btn.TextSize         = 10
    btn.Font             = Enum.Font.GothamBold
    btn.TextColor3       = Color3.fromRGB(200, 190, 160)
    btn.BorderSizePixel  = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    tabButtons[name] = btn

    local page = Instance.new("ScrollingFrame", PAGES)
    page.Size             = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(255, 190, 0)
    page.Visible          = false
    page.CanvasSize       = UDim2.new(0, 0, 0, 0)

    local pl = Instance.new("UIListLayout", page)
    pl.SortOrder = Enum.SortOrder.LayoutOrder
    pl.Padding   = UDim.new(0, 4)

    pl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pl.AbsoluteContentSize.Y + 8)
    end)

    local pp = Instance.new("UIPadding", page)
    pp.PaddingTop = UDim.new(0, 4)
    pp.PaddingLeft = UDim.new(0,2)
    pp.PaddingRight = UDim.new(0,2)

    pageFrames[name] = page

    btn.MouseButton1Click:Connect(function() selectTab(name) end)

    return page
end

-- ============================================================
-- HELPERS
-- ============================================================
local function makeSep(parent, labelTxt)
    local f = Instance.new("Frame", parent)
    f.Size             = UDim2.new(1, 0, 0, 18)
    f.BackgroundColor3 = Color3.fromRGB(30, 24, 0)
    f.BorderSizePixel  = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
    local l = Instance.new("TextLabel", f)
    l.Size     = UDim2.new(1, -6, 1, 0)
    l.Position = UDim2.new(0, 6, 0, 0)
    l.BackgroundTransparency = 1
    l.Text      = labelTxt
    l.TextSize  = 10
    l.Font      = Enum.Font.GothamBold
    l.TextColor3 = Color3.fromRGB(255, 180, 0)
    l.TextXAlignment = Enum.TextXAlignment.Left
    return f
end

local function makeActionBtn(parent, icon, labelID, labelEN, callback)
    local b = Instance.new("TextButton", parent)
    b.Size             = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = Color3.fromRGB(18, 16, 6)
    b.Text             = icon .. "  " .. labelID .. " / " .. labelEN
    b.TextSize         = 11
    b.Font             = Enum.Font.Gotham
    b.TextColor3       = Color3.fromRGB(230, 220, 190)
    b.BorderSizePixel  = 0
    b.TextXAlignment   = Enum.TextXAlignment.Left
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    local pad = Instance.new("UIPadding", b)
    pad.PaddingLeft = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", b)
    stroke.Color = Color3.fromRGB(60, 50, 20)
    stroke.Thickness = 0.8

    b.MouseButton1Click:Connect(callback)
    return b
end

local function makeToggleBtn(parent, icon, labelID, labelEN, callback)
    local row = Instance.new("Frame", parent)
    row.Size             = UDim2.new(1, 0, 0, 28)
    row.BackgroundColor3 = Color3.fromRGB(18, 16, 6)
    row.BorderSizePixel  = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size     = UDim2.new(1, -52, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text      = icon .. "  " .. labelID .. " / " .. labelEN
    lbl.TextSize  = 11
    lbl.Font      = Enum.Font.Gotham
    lbl.TextColor3= Color3.fromRGB(230, 220, 190)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local tog = Instance.new("TextButton", row)
    tog.Size             = UDim2.new(0, 44, 0, 20)
    tog.Position         = UDim2.new(1, -48, 0.5, -10)
    tog.BackgroundColor3 = Color3.fromRGB(130, 30, 30)
    tog.Text             = "OFF"
    tog.TextSize         = 10
    tog.Font             = Enum.Font.GothamBold
    tog.TextColor3       = Color3.fromRGB(255,255,255)
    tog.BorderSizePixel  = 0
    Instance.new("UICorner", tog).CornerRadius = UDim.new(0, 4)

    local state = false
    tog.MouseButton1Click:Connect(function()
        state = not state
        tog.Text = state and "ON" or "OFF"
        tog.BackgroundColor3 = state and Color3.fromRGB(30,160,60) or Color3.fromRGB(130,30,30)
        callback(state)
    end)
    return row
end

-- ============================================================
-- ===================  TAB 1: LEVER FINDER  ===================
-- ============================================================
local pageLever = createTab("Tuas")

local LEVER_KEYWORDS = {
    "lever","tuas","switch","button","handle","valve","knob",
    "trigger","gear","crank","latch","pull","push","activate",
    "interact","mechanic","key","lock","unlock","door","gate",
    "hidden","secret","underground","bawah","tersembunyi","rahasia"
}

local espState = { lever = true, tree = false }
local highlights = {}

local function getChar() return LocalPlayer.Character end
local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function nameMatch(obj, list)
    local low = obj.Name:lower()
    for _, k in ipairs(list) do
        if low:find(k, 1, true) then return true end
    end
    return false
end

local function runESP()
    for _, h in pairs(highlights) do pcall(function() h:Destroy() end) end
    highlights = {}

    local function addSel(obj, fill, outline)
        if not obj or not obj.Parent then return end
        if obj:FindFirstChild("_ZX_HL") then return end
        local s = Instance.new("SelectionBox")
        s.Name              = "_ZX_HL"
        s.Adornee           = obj
        s.Color3            = outline
        s.LineThickness     = 0.05
        s.SurfaceColor3     = fill
        s.SurfaceTransparency = 0.55
        s.Parent            = obj
        table.insert(highlights, s)
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if espState.lever and nameMatch(obj, LEVER_KEYWORDS) then
                addSel(obj, Color3.fromRGB(255, 200, 0), Color3.fromRGB(255, 255, 0))
            end
            if espState.tree and nameMatch(obj, {"tree","pohon","oak","spruce","birch","bush","plant"}) then
                addSel(obj, Color3.fromRGB(0, 200, 80), Color3.fromRGB(100, 255, 100))
            end
        end
    end
end

makeSep(pageLever, "── ESP TOGGLE ──")

do
    local row = Instance.new("Frame", pageLever)
    row.Size             = UDim2.new(1, 0, 0, 28)
    row.BackgroundColor3 = Color3.fromRGB(18, 16, 6)
    row.BorderSizePixel  = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size     = UDim2.new(1, -52, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text      = "🔧 Tuas Tersembunyi / Hidden Lever"
    lbl.TextSize  = 11
    lbl.Font      = Enum.Font.Gotham
    lbl.TextColor3= Color3.fromRGB(230, 220, 190)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local tog = Instance.new("TextButton", row)
    tog.Size             = UDim2.new(0, 44, 0, 20)
    tog.Position         = UDim2.new(1, -48, 0.5, -10)
    tog.BackgroundColor3 = Color3.fromRGB(30,160,60)
    tog.Text             = "ON"
    tog.TextSize         = 10
    tog.Font             = Enum.Font.GothamBold
    tog.TextColor3       = Color3.fromRGB(255,255,255)
    tog.BorderSizePixel  = 0
    Instance.new("UICorner", tog).CornerRadius = UDim.new(0, 4)
    tog.MouseButton1Click:Connect(function()
        espState.lever = not espState.lever
        tog.Text = espState.lever and "ON" or "OFF"
        tog.BackgroundColor3 = espState.lever and Color3.fromRGB(30,160,60) or Color3.fromRGB(130,30,30)
        runESP()
    end)
end

makeToggleBtn(pageLever, "🌲", "Pohon", "Tree ESP", function(state)
    espState.tree = state
    runESP()
end)

makeActionBtn(pageLever, "🔄", "Refresh ESP", "Scan Ulang", function()
    runESP()
end)

makeSep(pageLever, "── TELEPORT TUAS ──")

makeActionBtn(pageLever, "⚡", "Tuas Terdekat", "Nearest Lever", function()
    local hrp = getHRP()
    if not hrp then return end
    local best, bd = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and nameMatch(obj, LEVER_KEYWORDS) then
            local d = (obj.Position - hrp.Position).Magnitude
            if d < bd then best, bd = obj, d end
        end
    end
    if best then
        hrp.CFrame = CFrame.new(best.Position + Vector3.new(0, 5, 0))
        local n = Instance.new("TextLabel", SG)
        n.Size     = UDim2.new(0, 260, 0, 28)
        n.Position = UDim2.new(0.5, -130, 0, 10)
        n.BackgroundColor3 = Color3.fromRGB(20, 50, 10)
        n.Text     = "✅ Teleport ke tuas: " .. best.Name
        n.TextColor3 = Color3.fromRGB(120, 255, 80)
        n.TextSize = 11
        n.Font     = Enum.Font.GothamBold
        n.BorderSizePixel = 0
        Instance.new("UICorner", n).CornerRadius = UDim.new(0, 5)
        task.delay(2.5, function() n:Destroy() end)
    else
        local n = Instance.new("TextLabel", SG)
        n.Size     = UDim2.new(0, 260, 0, 28)
        n.Position = UDim2.new(0.5, -130, 0, 10)
        n.BackgroundColor3 = Color3.fromRGB(50, 10, 10)
        n.Text     = "❌ Tuas tidak ditemukan / Not found"
        n.TextColor3 = Color3.fromRGB(255, 80, 80)
        n.TextSize = 11
        n.Font     = Enum.Font.GothamBold
        n.BorderSizePixel = 0
        Instance.new("UICorner", n).CornerRadius = UDim.new(0, 5)
        task.delay(2.5, function() n:Destroy() end)
    end
end)

makeActionBtn(pageLever, "📋", "Daftar Semua Tuas", "List All Levers", function()
    local hrp = getHRP()
    if not hrp then return end

    local found = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and nameMatch(obj, LEVER_KEYWORDS) then
            local d = math.floor((obj.Position - hrp.Position).Magnitude)
            table.insert(found, {obj=obj, dist=d})
        end
    end
    table.sort(found, function(a,b) return a.dist < b.dist end)

    local old = SG:FindFirstChild("LeverList")
    if old then old:Destroy() end

    local popup = Instance.new("Frame", SG)
    popup.Name  = "LeverList"
    popup.Size  = UDim2.new(0, 240, 0, math.min(#found, 8) * 26 + 36)
    popup.Position = UDim2.new(0, 290, 0, 60)
    popup.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    popup.BorderSizePixel = 0
    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 8)
    local pStroke = Instance.new("UIStroke", popup)
    pStroke.Color = Color3.fromRGB(255, 190, 0)
    pStroke.Thickness = 1

    local pTitle = Instance.new("TextLabel", popup)
    pTitle.Size     = UDim2.new(1, -30, 0, 28)
    pTitle.Position = UDim2.new(0, 6, 0, 4)
    pTitle.BackgroundTransparency = 1
    pTitle.Text      = "🔧 Tuas Ditemukan: " .. #found
    pTitle.TextSize  = 11
    pTitle.Font      = Enum.Font.GothamBold
    pTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
    pTitle.TextXAlignment = Enum.TextXAlignment.Left

    local closeP = Instance.new("TextButton", popup)
    closeP.Size     = UDim2.new(0, 22, 0, 22)
    closeP.Position = UDim2.new(1, -26, 0, 3)
    closeP.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
    closeP.Text     = "✕"
    closeP.TextSize = 10
    closeP.Font     = Enum.Font.GothamBold
    closeP.TextColor3 = Color3.fromRGB(255,255,255)
    closeP.BorderSizePixel = 0
    Instance.new("UICorner", closeP).CornerRadius = UDim.new(0, 4)
    closeP.MouseButton1Click:Connect(function() popup:Destroy() end)

    local scroll = Instance.new("ScrollingFrame", popup)
    scroll.Size     = UDim2.new(1, -4, 1, -34)
    scroll.Position = UDim2.new(0, 2, 0, 32)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 180, 0)
    scroll.CanvasSize = UDim2.new(0, 0, 0, #found * 26)

    local sl = Instance.new("UIListLayout", scroll)
    sl.SortOrder = Enum.SortOrder.LayoutOrder
    sl.Padding   = UDim.new(0, 2)

    local sp = Instance.new("UIPadding", scroll)
    sp.PaddingLeft  = UDim.new(0, 4)
    sp.PaddingRight = UDim.new(0, 4)

    for i, item in ipairs(found) do
        local rb = Instance.new("TextButton", scroll)
        rb.Size             = UDim2.new(1, 0, 0, 22)
        rb.BackgroundColor3 = Color3.fromRGB(20, 18, 6)
        rb.Text             = i .. ". " .. item.obj.Name .. "  (" .. item.dist .. " studs)"
        rb.TextSize         = 9
        rb.Font             = Enum.Font.Gotham
        rb.TextColor3       = Color3.fromRGB(255, 220, 120)
        rb.BorderSizePixel  = 0
        rb.TextXAlignment   = Enum.TextXAlignment.Left
        Instance.new("UICorner", rb).CornerRadius = UDim.new(0, 4)

        local rp = Instance.new("UIPadding", rb)
        rp.PaddingLeft = UDim.new(0, 6)

        rb.MouseButton1Click:Connect(function()
            local h2 = getHRP()
            if h2 and item.obj and item.obj.Parent then
                h2.CFrame = CFrame.new(item.obj.Position + Vector3.new(0, 5, 0))
                popup:Destroy()
            end
        end)
    end

    if #found == 0 then
        local nl = Instance.new("TextLabel", scroll)
        nl.Size     = UDim2.new(1, 0, 0, 22)
        nl.BackgroundTransparency = 1
        nl.Text     = "Tidak ada tuas ditemukan"
        nl.TextSize = 10
        nl.Font     = Enum.Font.Gotham
        nl.TextColor3 = Color3.fromRGB(200, 100, 100)
    end
end)

makeSep(pageLever, "── TELEPORT WARNA ──")

local COLORS = {
    {"Merah","Red",    Color3.fromRGB(255,0,0),     Color3.fromRGB(255,80,80)},
    {"Hijau","Green",  Color3.fromRGB(0,255,0),     Color3.fromRGB(80,255,80)},
    {"Biru","Blue",    Color3.fromRGB(0,0,255),     Color3.fromRGB(80,80,255)},
    {"Kuning","Yellow",Color3.fromRGB(255,255,0),   Color3.fromRGB(255,255,80)},
    {"Ungu","Purple",  Color3.fromRGB(128,0,128),   Color3.fromRGB(200,80,200)},
    {"Oranye","Orange",Color3.fromRGB(255,165,0),   Color3.fromRGB(255,180,80)},
    {"Pink","Pink",    Color3.fromRGB(255,105,180), Color3.fromRGB(255,160,200)},
    {"Cyan","Cyan",    Color3.fromRGB(0,255,255),   Color3.fromRGB(80,255,255)},
    {"Putih","White",  Color3.fromRGB(255,255,255), Color3.fromRGB(240,240,255)},
    {"Hitam","Black",  Color3.fromRGB(0,0,0),       Color3.fromRGB(100,100,100)},
}

for _, cd in ipairs(COLORS) do
    makeActionBtn(pageLever, "⟶", cd[1], cd[2], function()
        local hrp = getHRP()
        if not hrp then return end
        local best, bd = nil, math.huge
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local tc = cd[3]
                if math.abs(obj.Color.R-tc.R)+math.abs(obj.Color.G-tc.G)+math.abs(obj.Color.B-tc.B) < 0.3 then
                    local d = (obj.Position - hrp.Position).Magnitude
                    if d < bd then best, bd = obj, d end
                end
            end
        end
        if best then hrp.CFrame = CFrame.new(best.Position + Vector3.new(0, 5, 0)) end
    end)
end

-- ============================================================
-- ===================  TAB 2: GERAK (MOVEMENT TROLL) =========
-- ============================================================
local pageMove = createTab("Gerak")
local trollLoops = {}

makeToggleBtn(pageMove, "🤸", "Goyang Random", "Random Shake", function(state)
    if state then
        trollLoops.shake = true
        task.spawn(function()
            while trollLoops.shake do
                local hrp = getHRP()
                if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.random(-5,5)/10, 0) end
                task.wait(0.1)
            end
        end)
    else
        trollLoops.shake = false
    end
end)

makeToggleBtn(pageMove, "🌀", "Spin Karakter", "Spin Character", function(state)
    if state then
        trollLoops.spin = true
        task.spawn(function()
            while trollLoops.spin do
                local hrp = getHRP()
                if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(15), 0) end
                task.wait(0.03)
            end
        end)
    else
        trollLoops.spin = false
    end
end)

makeToggleBtn(pageMove, "🦘", "Auto Lompat", "Auto Jump", function(state)
    if state then
        trollLoops.jump = true
        task.spawn(function()
            while trollLoops.jump do
                local c = getChar()
                local hum = c and c:FindFirstChildOfClass("Humanoid")
                if hum then hum.Jump = true end
                task.wait(0.5)
            end
        end)
    else
        trollLoops.jump = false
    end
end)

makeActionBtn(pageMove, "💀", "Jatuh ke Void", "Fall to Void", function()
    local hrp = getHRP()
    if hrp then hrp.CFrame = CFrame.new(hrp.Position.X, -500, hrp.Position.Z) end
end)

makeActionBtn(pageMove, "☁️", "Lempar ke Langit", "Launch to Sky", function()
    local hrp = getHRP()
    if hrp then hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 300, 0)) end
end)

makeToggleBtn(pageMove, "👻", "Tembus Tembok (Noclip)", "Noclip", function(state)
    if state then
        trollLoops.noclip = true
        task.spawn(function()
            while trollLoops.noclip do
                local c = getChar()
                if c then
                    for _, part in ipairs(c:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
                task.wait(0.2)
            end
        end)
    else
        trollLoops.noclip = false
        local c = getChar()
        if c then
            for _, part in ipairs(c:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end)

-- ===== NEW TROLL 1: FOLLOW PLAYER =====
makeToggleBtn(pageMove, "🎯", "Ikuti Player (Stalker)", "Follow Player", function(state)
    if state then
        -- ambil player random selain diri sendiri
        local targets = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(targets, p) end
        end
        if #targets == 0 then
            trollLoops.follow = false
            return
        end
        local target = targets[math.random(1, #targets)]
        trollLoops.follow = true
        task.spawn(function()
            while trollLoops.follow do
                local hrp = getHRP()
                local tChar = target.Character
                local tHrp = tChar and tChar:FindFirstChild("HumanoidRootPart")
                if hrp and tHrp then
                    local offset = tHrp.CFrame.LookVector * -3
                    hrp.CFrame = CFrame.new(tHrp.Position + offset + Vector3.new(0, 0, 0), tHrp.Position)
                end
                task.wait(0.1)
            end
        end)
        sendChat("👀 Stalking " .. target.Name .. "...")
    else
        trollLoops.follow = false
    end
end)

-- ============================================================
-- ===================  TAB 3: VISUAL TROLL  ===================
-- ============================================================
local pageVisual = createTab("Visual")

makeToggleBtn(pageVisual, "🌈", "Char Warna-warni", "Rainbow Body", function(state)
    if state then
        trollLoops.rainbow = true
        task.spawn(function()
            local hue = 0
            while trollLoops.rainbow do
                local c = getChar()
                if c then
                    hue = (hue + 0.02) % 1
                    local col = Color3.fromHSV(hue, 1, 1)
                    for _, part in ipairs(c:GetDescendants()) do
                        if part:IsA("BasePart") then part.Color = col end
                    end
                end
                task.wait(0.05)
            end
        end)
    else
        trollLoops.rainbow = false
    end
end)

makeToggleBtn(pageVisual, "👤", "Invisible (Transparan)", "Invisible", function(state)
    local c = getChar()
    if not c then return end
    for _, part in ipairs(c:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = state and 1 or 0
        end
    end
end)

makeToggleBtn(pageVisual, "🐢", "Karakter Mini", "Tiny Character", function(state)
    local c = getChar()
    if c then
        for _, part in ipairs(c:GetDescendants()) do
            if part:IsA("NumberValue") and (part.Name == "BodyHeightScale" or part.Name == "BodyWidthScale" or part.Name == "BodyDepthScale" or part.Name == "HeadScale") then
                part.Value = state and 0.3 or 1
            end
        end
    end
end)

makeToggleBtn(pageVisual, "🗿", "Karakter Raksasa", "Giant Character", function(state)
    local c = getChar()
    if c then
        for _, part in ipairs(c:GetDescendants()) do
            if part:IsA("NumberValue") and (part.Name == "BodyHeightScale" or part.Name == "BodyWidthScale" or part.Name == "BodyDepthScale" or part.Name == "HeadScale") then
                part.Value = state and 3 or 1
            end
        end
    end
end)

makeActionBtn(pageVisual, "💥", "Efek Fireworks", "Fireworks Effect", function()
    local hrp = getHRP()
    if not hrp then return end
    for i = 1, 10 do
        task.spawn(function()
            local p = Instance.new("Part")
            p.Shape = Enum.PartType.Ball
            p.Size = Vector3.new(1,1,1)
            p.Position = hrp.Position + Vector3.new(math.random(-5,5), math.random(0,5), math.random(-5,5))
            p.Color = Color3.fromHSV(math.random(), 1, 1)
            p.Material = Enum.Material.Neon
            p.Anchored = true
            p.CanCollide = false
            p.Parent = workspace
            task.delay(1.5, function() p:Destroy() end)
        end)
    end
end)

-- ===== NEW TROLL 2: SCREEN FLASH / JUMPSCARE =====
makeActionBtn(pageVisual, "😱", "Screen Jumpscare", "Flash Jumpscare", function()
    local flash = Instance.new("Frame", SG)
    flash.Size = UDim2.new(1, 0, 1, 0)
    flash.Position = UDim2.new(0, 0, 0, 0)
    flash.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    flash.BorderSizePixel = 0
    flash.ZIndex = 999

    local txt = Instance.new("TextLabel", flash)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = "👻 BOO! 👻"
    txt.TextSize = 60
    txt.Font = Enum.Font.GothamBold
    txt.TextColor3 = Color3.fromRGB(255,255,255)
    txt.ZIndex = 1000

    -- flicker effect
    task.spawn(function()
        for i = 1, 6 do
            flash.Visible = true
            task.wait(0.08)
            flash.Visible = false
            task.wait(0.08)
        end
        flash:Destroy()
    end)
end)

-- ============================================================
-- ===================  TAB 4: SUARA / SOUND  ==================
-- ============================================================
local pageSound = createTab("Suara")

local SOUND_IDS = {
    {"Air Horn", "rbxassetid://5345731940"},
    {"Vine Boom", "rbxassetid://5153734023"},
    {"Bruh", "rbxassetid://2920959024"},
    {"Anime Wow", "rbxassetid://9046182403"},
}

for _, s in ipairs(SOUND_IDS) do
    makeActionBtn(pageSound, "🔊", s[1], "Play Sound", function()
        local snd = Instance.new("Sound")
        snd.SoundId = s[2]
        snd.Volume  = 5
        snd.Parent  = workspace
        snd:Play()
        game:GetService("Debris"):AddItem(snd, 5)
    end)
end

local CHAT_SPAM = {
    {"GG EZ", "GG EZ"},
    {"Skill Issue", "Skill Issue"},
    {"Maaf Lag", "Sorry Lag"},
}

for _, c in ipairs(CHAT_SPAM) do
    makeActionBtn(pageSound, "💬", c[1], c[2], function()
        sendChat(c[1])
    end)
end

-- ===== NEW TROLL 3: FAKE ERROR POPUP =====
makeActionBtn(pageSound, "⚠️", "Fake Error Popup", "Fake Roblox Error", function()
    local old = SG:FindFirstChild("FakeError")
    if old then old:Destroy() end

    local err = Instance.new("Frame", SG)
    err.Name             = "FakeError"
    err.Size             = UDim2.new(0, 320, 0, 140)
    err.Position         = UDim2.new(0.5, -160, 0.5, -70)
    err.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    err.BorderSizePixel  = 0
    err.ZIndex           = 999
    Instance.new("UICorner", err).CornerRadius = UDim.new(0, 6)

    local bar = Instance.new("Frame", err)
    bar.Size             = UDim2.new(1, 0, 0, 28)
    bar.BackgroundColor3 = Color3.fromRGB(0, 90, 200)
    bar.BorderSizePixel  = 0
    bar.ZIndex           = 999
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 6)

    local barTxt = Instance.new("TextLabel", bar)
    barTxt.Size = UDim2.new(1, -10, 1, 0)
    barTxt.Position = UDim2.new(0, 10, 0, 0)
    barTxt.BackgroundTransparency = 1
    barTxt.Text = "Roblox"
    barTxt.TextColor3 = Color3.fromRGB(255,255,255)
    barTxt.Font = Enum.Font.SourceSansBold
    barTxt.TextSize = 14
    barTxt.TextXAlignment = Enum.TextXAlignment.Left
    barTxt.ZIndex = 999

    local msg = Instance.new("TextLabel", err)
    msg.Size = UDim2.new(1, -20, 0, 70)
    msg.Position = UDim2.new(0, 10, 0, 36)
    msg.BackgroundTransparency = 1
    msg.Text = "⚠️ Error Code: 524\nDisconnected from the experience.\nID=17 ConnectionFailure"
    msg.TextColor3 = Color3.fromRGB(20,20,20)
    msg.Font = Enum.Font.SourceSans
    msg.TextSize = 14
    msg.TextWrapped = true
    msg.TextXAlignment = Enum.TextXAlignment.Left
    msg.TextYAlignment = Enum.TextYAlignment.Top
    msg.ZIndex = 999

    local okBtn = Instance.new("TextButton", err)
    okBtn.Size = UDim2.new(0, 80, 0, 26)
    okBtn.Position = UDim2.new(1, -90, 1, -34)
    okBtn.BackgroundColor3 = Color3.fromRGB(0, 90, 200)
    okBtn.Text = "OK"
    okBtn.TextColor3 = Color3.fromRGB(255,255,255)
    okBtn.Font = Enum.Font.SourceSansBold
    okBtn.TextSize = 14
    okBtn.ZIndex = 999
    Instance.new("UICorner", okBtn).CornerRadius = UDim.new(0, 4)

    okBtn.MouseButton1Click:Connect(function() err:Destroy() end)
end)

-- ============================================================
-- ===================  TAB 5: INFO  ==========================
-- ============================================================
local pageInfo = createTab("Info")

local infoLbl = Instance.new("TextLabel", pageInfo)
infoLbl.Size             = UDim2.new(1, 0, 0, 260)
infoLbl.BackgroundTransparency = 1
infoLbl.Text = "⚡ ZONEXD ALL-IN-ONE ⚡\n\nTab Tuas: Lever Finder + Teleport warna\nTab Gerak: Movement troll + Stalker\nTab Visual: Rainbow, Invisible, Jumpscare\nTab Suara: Sound, chat spam, fake error\n\nPassword: Apis123\n\nGunakan dengan bijak!"
infoLbl.TextSize  = 11
infoLbl.Font      = Enum.Font.Gotham
infoLbl.TextColor3= Color3.fromRGB(200, 190, 170)
infoLbl.TextWrapped = true
infoLbl.TextYAlignment = Enum.TextYAlignment.Top

-- ============================================================
-- FOOTER COPYRIGHT
-- ============================================================
local FOOTER = Instance.new("TextLabel", MAIN)
FOOTER.Size             = UDim2.new(1, -12, 0, 18)
FOOTER.Position         = UDim2.new(0, 6, 1, -22)
FOOTER.BackgroundColor3 = Color3.fromRGB(16, 12, 0)
FOOTER.Text             = "© ZONEXD | tele apiszx"
FOOTER.TextSize         = 9
FOOTER.Font             = Enum.Font.Gotham
FOOTER.TextColor3       = Color3.fromRGB(160, 130, 50)
FOOTER.BorderSizePixel  = 0
Instance.new("UICorner", FOOTER).CornerRadius = UDim.new(0, 4)

-- ============================================================
-- MINIMIZE LOGIC
-- ============================================================
local minimized = false
local fullSize = UDim2.new(0, 280, 0, 400)
local miniSize = UDim2.new(0, 280, 0, 34)

MINBTN.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MAIN.Size = miniSize
        TABBAR.Visible = false
        PAGES.Visible = false
        FOOTER.Visible = false
        MINBTN.Text = "▲"
    else
        MAIN.Size = fullSize
        TABBAR.Visible = true
        PAGES.Visible = true
        FOOTER.Visible = true
        MINBTN.Text = "▼"
    end
end)

-- ============================================================
-- DRAG MAIN
-- ============================================================
do
    local dragging, dragInput, dragStart, startPos
    TITLE.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = MAIN.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    TITLE.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            dragInput = inp
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if inp == dragInput and dragging then
            local delta = inp.Position - dragStart
            MAIN.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ============================================================
-- UNLOCK LOGIC
-- ============================================================
local function tryUnlock()
    if passInput.Text == CORRECT_PASSWORD then
        LOCK:Destroy()
        MAIN.Visible = true
        selectTab("Tuas")
        task.spawn(function()
            task.wait(0.5)
            sendChat("Copyright ZONEXD")
        end)
        -- Initial ESP scan
        task.spawn(function()
            task.wait(1)
            runESP()
            while true do
                task.wait(15)
                runESP()
            end
        end)
    else
        errLabel.Text = "❌ Password Salah / Wrong Password"
        errLabel.Visible = true
        passInput.Text = ""
        task.delay(2, function() errLabel.Visible = false end)
    end
end

submitBtn.MouseButton1Click:Connect(tryUnlock)
passInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then tryUnlock() end
end)

print("⚡ ZONEXD ALL-IN-ONE loaded | Masukkan password untuk akses | Copyright © ZONEXD")
