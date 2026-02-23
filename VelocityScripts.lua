-- ================================================
--   VelocityScripts | Ultra Universal Script
--   Press INSERT to toggle GUI (PC) | Tap logo (Mobile)
-- ================================================

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local Workspace        = game:GetService("Workspace")
local Lighting         = game:GetService("Lighting")
local HttpService      = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera
local IsMobile    = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

if CoreGui:FindFirstChild("VelocityScripts") then
    CoreGui:FindFirstChild("VelocityScripts"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VelocityScripts"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

-- ================================================
-- THEME
-- ================================================
local C = {
    BG           = Color3.fromRGB(9, 9, 14),
    Secondary    = Color3.fromRGB(14, 14, 22),
    Card         = Color3.fromRGB(18, 16, 28),
    Accent       = Color3.fromRGB(110, 55, 255),
    AccentDark   = Color3.fromRGB(70, 30, 180),
    AccentBright = Color3.fromRGB(160, 110, 255),
    Text         = Color3.fromRGB(240, 240, 255),
    TextDim      = Color3.fromRGB(130, 125, 160),
    Border       = Color3.fromRGB(50, 38, 90),
    On           = Color3.fromRGB(110, 55, 255),
    Off          = Color3.fromRGB(32, 30, 48),
    Red          = Color3.fromRGB(220, 55, 55),
    Green        = Color3.fromRGB(55, 220, 100),
    Yellow       = Color3.fromRGB(255, 200, 50),
    Discord      = Color3.fromRGB(88, 101, 242),
}

-- ================================================
-- UTILITY
-- ================================================
local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj, TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end
local function Corner(p, r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 8); c.Parent=p; return c end
local function Stroke(p, col, thick) local s=Instance.new("UIStroke"); s.Color=col or C.Border; s.Thickness=thick or 1; s.Parent=p; return s end
local function Glow(parent, color, spread)
    local g=Instance.new("ImageLabel"); g.BackgroundTransparency=1; g.Image="rbxassetid://5028857084"
    g.ImageColor3=color or C.Accent; g.ImageTransparency=0.75; spread=spread or 40
    g.Size=UDim2.new(1,spread,1,spread); g.Position=UDim2.new(0,-spread/2,0,-spread/2)
    g.ZIndex=(parent.ZIndex or 1)-1; g.Parent=parent; return g
end
local function Gradient(parent, c0, c1, rot)
    local g=Instance.new("UIGradient"); g.Color=ColorSequence.new(c0,c1); g.Rotation=rot or 90; g.Parent=parent; return g
end

-- ================================================
-- NOTIFICATION SYSTEM
-- ================================================
local NotifFrame = Instance.new("Frame")
NotifFrame.Size = UDim2.new(0, 260, 1, 0)
NotifFrame.Position = UDim2.new(1, -270, 0, 0)
NotifFrame.BackgroundTransparency = 1
NotifFrame.ZIndex = 100
NotifFrame.Parent = ScreenGui
local NL = Instance.new("UIListLayout"); NL.Padding=UDim.new(0,6); NL.VerticalAlignment=Enum.VerticalAlignment.Bottom; NL.Parent=NotifFrame

local function Notify(title, msg, ntype)
    local colMap={info=C.Accent,success=C.Green,warn=C.Yellow,error=C.Red}
    local col=colMap[ntype or "info"] or C.Accent
    local N=Instance.new("Frame"); N.Size=UDim2.new(1,0,0,52); N.BackgroundColor3=Color3.fromRGB(14,12,24)
    N.BackgroundTransparency=0.1; N.BorderSizePixel=0; N.ZIndex=101; N.Parent=NotifFrame
    Corner(N,9); Stroke(N,col,1)
    local Bar=Instance.new("Frame"); Bar.Size=UDim2.new(0,3,1,0); Bar.BackgroundColor3=col; Bar.BorderSizePixel=0; Bar.ZIndex=102; Bar.Parent=N; Corner(Bar,3)
    local T=Instance.new("TextLabel"); T.Size=UDim2.new(1,-18,0,16); T.Position=UDim2.new(0,14,0,8); T.BackgroundTransparency=1
    T.Text=title; T.TextColor3=col; T.TextSize=12; T.Font=Enum.Font.GothamBold; T.TextXAlignment=Enum.TextXAlignment.Left; T.ZIndex=102; T.Parent=N
    local M=Instance.new("TextLabel"); M.Size=UDim2.new(1,-18,0,14); M.Position=UDim2.new(0,14,0,28); M.BackgroundTransparency=1
    M.Text=msg; M.TextColor3=C.TextDim; M.TextSize=10; M.Font=Enum.Font.Gotham; M.TextXAlignment=Enum.TextXAlignment.Left; M.ZIndex=102; M.Parent=N
    N.Position=UDim2.new(1,10,0,0); Tween(N,{Position=UDim2.new(0,0,0,0)},0.35,Enum.EasingStyle.Back)
    task.delay(3.5, function() Tween(N,{Position=UDim2.new(1,10,0,0),BackgroundTransparency=1},0.3); task.wait(0.35); N:Destroy() end)
end

-- ================================================
-- MAIN FRAME (responsive size)
-- ================================================
local GUI_W = IsMobile and 500 or 640
local GUI_H = IsMobile and 380 or 440

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
Main.Position = UDim2.new(0.5, -GUI_W/2, 0.5, -GUI_H/2)
Main.BackgroundColor3 = C.BG
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Corner(Main, 14); Stroke(Main, C.Border, 1.5); Glow(Main, C.Accent, 60)

local TopGlow=Instance.new("Frame"); TopGlow.Size=UDim2.new(1,0,0.25,0); TopGlow.BackgroundColor3=C.Accent
TopGlow.BackgroundTransparency=0.93; TopGlow.BorderSizePixel=0; TopGlow.ZIndex=2; TopGlow.Parent=Main; Corner(TopGlow,14)

-- ================================================
-- HEADER
-- ================================================
local Header=Instance.new("Frame"); Header.Size=UDim2.new(1,0,0,58); Header.BackgroundColor3=C.Secondary
Header.BorderSizePixel=0; Header.ZIndex=10; Header.Parent=Main; Corner(Header,14)
local HFix=Instance.new("Frame"); HFix.Size=UDim2.new(1,0,0.5,0); HFix.Position=UDim2.new(0,0,0.5,0)
HFix.BackgroundColor3=C.Secondary; HFix.BorderSizePixel=0; HFix.ZIndex=9; HFix.Parent=Header
local HLine=Instance.new("Frame"); HLine.Size=UDim2.new(1,0,0,1); HLine.Position=UDim2.new(0,0,1,-1)
HLine.BackgroundColor3=C.Border; HLine.BorderSizePixel=0; HLine.ZIndex=11; HLine.Parent=Header

local LogoLabel=Instance.new("TextLabel"); LogoLabel.Size=UDim2.new(0,220,0,30); LogoLabel.Position=UDim2.new(0,16,0.5,-15)
LogoLabel.BackgroundTransparency=1; LogoLabel.Text="⚡ VelocityScripts"; LogoLabel.TextSize=20; LogoLabel.Font=Enum.Font.GothamBold
LogoLabel.TextColor3=C.Text; LogoLabel.TextXAlignment=Enum.TextXAlignment.Left; LogoLabel.ZIndex=12; LogoLabel.Parent=Header
local LogoGrad=Instance.new("UIGradient")
LogoGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.45,Color3.fromRGB(180,140,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(110,55,255))})
LogoGrad.Parent=LogoLabel

local BadgeFrame=Instance.new("Frame"); BadgeFrame.Size=UDim2.new(0,72,0,18); BadgeFrame.Position=UDim2.new(0,16,1,-22)
BadgeFrame.BackgroundColor3=C.Accent; BadgeFrame.BackgroundTransparency=0.55; BadgeFrame.BorderSizePixel=0; BadgeFrame.ZIndex=12; BadgeFrame.Parent=Header; Corner(BadgeFrame,5)
local BadgeText=Instance.new("TextLabel"); BadgeText.Size=UDim2.new(1,0,1,0); BadgeText.BackgroundTransparency=1
BadgeText.Text="ULTRA v4.0"; BadgeText.TextColor3=C.Text; BadgeText.TextSize=9; BadgeText.Font=Enum.Font.GothamBold; BadgeText.ZIndex=13; BadgeText.Parent=BadgeFrame

local function MakeWinBtn(xOffset, col, icon)
    local btn=Instance.new("TextButton"); btn.Size=UDim2.new(0,28,0,28); btn.Position=UDim2.new(1,xOffset,0.5,-14)
    btn.BackgroundColor3=col; btn.BackgroundTransparency=0.35; btn.Text=icon; btn.TextColor3=C.Text; btn.TextSize=12
    btn.Font=Enum.Font.GothamBold; btn.ZIndex=12; btn.Parent=Header; Corner(btn,7)
    btn.MouseEnter:Connect(function() Tween(btn,{BackgroundTransparency=0},0.12) end)
    btn.MouseLeave:Connect(function() Tween(btn,{BackgroundTransparency=0.35},0.18) end)
    return btn
end
local CloseBtn=MakeWinBtn(-40,C.Red,"✕"); local MinBtn=MakeWinBtn(-76,C.Yellow,"–")

-- Touch toggle on logo (mobile)
LogoLabel.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch then
        local guiV = Main.Visible
        if guiV and Main.Size.Y.Offset > 60 then
            Tween(Main,{Size=UDim2.new(0,GUI_W,0,0),Position=UDim2.new(0.5,-GUI_W/2,0.5,0)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In)
            task.wait(0.32); Main.Visible=false
        else
            Main.Visible=true; Tween(Main,{Size=UDim2.new(0,GUI_W,0,GUI_H),Position=UDim2.new(0.5,-GUI_W/2,0.5,-GUI_H/2)},0.35,Enum.EasingStyle.Back)
        end
    end
end)

-- Dragging (mouse + touch)
local dragging,dragStart,startPos
local function StartDrag(pos) dragging=true; dragStart=pos; startPos=Main.Position end
local function EndDrag() dragging=false end
local function MoveDrag(pos)
    if not dragging then return end
    local d=pos-dragStart
    Main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
end
Header.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then StartDrag(i.Position) end
end)
UserInputService.InputChanged:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then MoveDrag(i.Position) end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then EndDrag() end
end)

local minimized=false
MinBtn.MouseButton1Click:Connect(function()
    minimized=not minimized
    Tween(Main,{Size=minimized and UDim2.new(0,GUI_W,0,58) or UDim2.new(0,GUI_W,0,GUI_H)},0.3,Enum.EasingStyle.Quart)
end)
CloseBtn.MouseButton1Click:Connect(function()
    Tween(Main,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)},0.35,Enum.EasingStyle.Back,Enum.EasingDirection.In)
    task.wait(0.4); ScreenGui:Destroy()
end)

-- ================================================
-- SIDEBAR
-- ================================================
local SB_W = IsMobile and 110 or 136
local Sidebar=Instance.new("Frame"); Sidebar.Size=UDim2.new(0,SB_W,1,-58); Sidebar.Position=UDim2.new(0,0,0,58)
Sidebar.BackgroundColor3=C.Secondary; Sidebar.BorderSizePixel=0; Sidebar.ZIndex=8; Sidebar.Parent=Main
local SBL=Instance.new("UIListLayout"); SBL.Padding=UDim.new(0,3); SBL.Parent=Sidebar
local SBP=Instance.new("UIPadding"); SBP.PaddingTop=UDim.new(0,10); SBP.PaddingLeft=UDim.new(0,6); SBP.PaddingRight=UDim.new(0,6); SBP.Parent=Sidebar
local SDiv=Instance.new("Frame"); SDiv.Size=UDim2.new(0,1,1,-58); SDiv.Position=UDim2.new(0,SB_W,0,58)
SDiv.BackgroundColor3=C.Border; SDiv.BorderSizePixel=0; SDiv.ZIndex=9; SDiv.Parent=Main

-- Discord button (bottom sidebar)
local DCFrame=Instance.new("Frame"); DCFrame.Size=UDim2.new(1,-12,0,30); DCFrame.Position=UDim2.new(0,6,1,-38)
DCFrame.BackgroundColor3=C.Discord; DCFrame.BackgroundTransparency=0.55; DCFrame.BorderSizePixel=0; DCFrame.ZIndex=9; DCFrame.Parent=Sidebar
Corner(DCFrame,7); Stroke(DCFrame,C.Discord,1)
local DCLbl=Instance.new("TextLabel"); DCLbl.Size=UDim2.new(1,-8,1,0); DCLbl.Position=UDim2.new(0,8,0,0)
DCLbl.BackgroundTransparency=1; DCLbl.Text="Discord"; DCLbl.TextColor3=Color3.fromRGB(200,200,255)
DCLbl.TextSize=11; DCLbl.Font=Enum.Font.GothamSemibold; DCLbl.TextXAlignment=Enum.TextXAlignment.Left; DCLbl.ZIndex=10; DCLbl.Parent=DCFrame
local DCBtn=Instance.new("TextButton"); DCBtn.Size=UDim2.new(1,0,1,0); DCBtn.BackgroundTransparency=1; DCBtn.Text=""; DCBtn.ZIndex=11; DCBtn.Parent=DCFrame
local DCTip=Instance.new("Frame"); DCTip.Size=UDim2.new(0,152,0,24); DCTip.Position=UDim2.new(1,6,0.5,-12)
DCTip.BackgroundColor3=Color3.fromRGB(14,10,28); DCTip.BorderSizePixel=0; DCTip.ZIndex=20; DCTip.Visible=false; DCTip.Parent=DCFrame; Corner(DCTip,6); Stroke(DCTip,C.Border,1)
local DCTipLbl=Instance.new("TextLabel"); DCTipLbl.Size=UDim2.new(1,-8,1,0); DCTipLbl.Position=UDim2.new(0,6,0,0)
DCTipLbl.BackgroundTransparency=1; DCTipLbl.Text="discord.gg/velocityscripts"; DCTipLbl.TextColor3=Color3.fromRGB(180,160,255)
DCTipLbl.TextSize=10; DCTipLbl.Font=Enum.Font.GothamSemibold; DCTipLbl.TextXAlignment=Enum.TextXAlignment.Left; DCTipLbl.ZIndex=21; DCTipLbl.Parent=DCTip
DCBtn.MouseEnter:Connect(function() Tween(DCFrame,{BackgroundTransparency=0.15},0.15); DCTip.Visible=true end)
DCBtn.MouseLeave:Connect(function() Tween(DCFrame,{BackgroundTransparency=0.55},0.2); DCTip.Visible=false end)
DCBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard("https://discord.gg/velocityscripts") end)
    DCTipLbl.Text="Link kopiert!"; Notify("Discord","Invite-Link kopiert!","info")
    task.wait(2); DCTipLbl.Text="discord.gg/velocityscripts"
end)

-- ================================================
-- CONTENT AREA
-- ================================================
local CW=Instance.new("Frame"); CW.Size=UDim2.new(1,-(SB_W+6),1,-64); CW.Position=UDim2.new(0,SB_W+6,0,60)
CW.BackgroundTransparency=1; CW.ZIndex=8; CW.Parent=Main

-- ================================================
-- TAB SYSTEM
-- ================================================
local TabPages,TabBtns,ActiveTab={},{},nil
local function SwitchTab(name)
    if ActiveTab==name then return end; ActiveTab=name
    for n,data in pairs(TabBtns) do
        if n==name then
            Tween(data.Btn,{BackgroundColor3=Color3.fromRGB(22,16,42)},0.2); Tween(data.Lbl,{TextColor3=C.Text},0.2)
            Tween(data.Bar,{BackgroundTransparency=0},0.18); TabPages[n].Visible=true
        else
            data.Btn.BackgroundTransparency=1; Tween(data.Lbl,{TextColor3=C.TextDim},0.2)
            Tween(data.Bar,{BackgroundTransparency=1},0.18); TabPages[n].Visible=false
        end
    end
end

local function NewTab(name, icon)
    local Btn=Instance.new("TextButton"); Btn.Size=UDim2.new(1,0,0,IsMobile and 40 or 36)
    Btn.BackgroundColor3=Color3.fromRGB(0,0,0); Btn.BackgroundTransparency=1; Btn.Text=""; Btn.ZIndex=9; Btn.Parent=Sidebar; Corner(Btn,8)
    local Bar=Instance.new("Frame"); Bar.Size=UDim2.new(0,3,0.55,0); Bar.Position=UDim2.new(0,0,0.225,0)
    Bar.BackgroundColor3=C.Accent; Bar.BackgroundTransparency=1; Bar.BorderSizePixel=0; Bar.ZIndex=10; Bar.Parent=Btn; Corner(Bar,2)
    local IL=Instance.new("TextLabel"); IL.Size=UDim2.new(0,22,1,0); IL.Position=UDim2.new(0,8,0,0)
    IL.BackgroundTransparency=1; IL.Text=icon; IL.TextSize=IsMobile and 16 or 14; IL.ZIndex=10; IL.Parent=Btn
    local NL2=Instance.new("TextLabel"); NL2.Size=UDim2.new(1,-32,1,0); NL2.Position=UDim2.new(0,30,0,0)
    NL2.BackgroundTransparency=1; NL2.Text=name; NL2.TextColor3=C.TextDim; NL2.TextSize=IsMobile and 11 or 12
    NL2.Font=Enum.Font.GothamSemibold; NL2.TextXAlignment=Enum.TextXAlignment.Left; NL2.ZIndex=10; NL2.Parent=Btn
    Btn.MouseEnter:Connect(function() if ActiveTab~=name then Tween(Btn,{BackgroundTransparency=0,BackgroundColor3=Color3.fromRGB(28,22,46)},0.15); Tween(NL2,{TextColor3=C.Text},0.15) end end)
    Btn.MouseLeave:Connect(function() if ActiveTab~=name then Tween(Btn,{BackgroundTransparency=1},0.2); Tween(NL2,{TextColor3=C.TextDim},0.2) end end)
    Btn.MouseButton1Click:Connect(function() Tween(Btn,{BackgroundColor3=Color3.fromRGB(70,40,160)},0.08); task.wait(0.08); SwitchTab(name) end)
    local Page=Instance.new("ScrollingFrame"); Page.Name=name.."Page"; Page.Size=UDim2.new(1,0,1,0)
    Page.BackgroundTransparency=1; Page.BorderSizePixel=0; Page.ScrollBarThickness=3
    Page.ScrollBarImageColor3=C.Accent; Page.ScrollBarImageTransparency=0.4
    Page.CanvasSize=UDim2.new(0,0,0,0); Page.AutomaticCanvasSize=Enum.AutomaticSize.Y
    Page.Visible=false; Page.ZIndex=9; Page.Parent=CW
    local PL=Instance.new("UIListLayout"); PL.Padding=UDim.new(0,6); PL.Parent=Page
    local PP=Instance.new("UIPadding"); PP.PaddingTop=UDim.new(0,10); PP.PaddingBottom=UDim.new(0,10)
    PP.PaddingLeft=UDim.new(0,8); PP.PaddingRight=UDim.new(0,10); PP.Parent=Page
    TabPages[name]=Page; TabBtns[name]={Btn=Btn,Lbl=NL2,Bar=Bar}; return Page
end

-- ================================================
-- COMPONENTS
-- ================================================
local function Section(parent, label)
    local F=Instance.new("Frame"); F.Size=UDim2.new(1,0,0,24); F.BackgroundTransparency=1; F.ZIndex=10; F.Parent=parent
    local Line=Instance.new("Frame"); Line.Size=UDim2.new(1,0,0,1); Line.Position=UDim2.new(0,0,0.5,0)
    Line.BackgroundColor3=C.Border; Line.BorderSizePixel=0; Line.ZIndex=10; Line.Parent=F
    local Bg=Instance.new("Frame"); Bg.AutomaticSize=Enum.AutomaticSize.X; Bg.Size=UDim2.new(0,0,1,0)
    Bg.BackgroundColor3=C.Accent; Bg.BackgroundTransparency=0.82; Bg.BorderSizePixel=0; Bg.ZIndex=11; Bg.Parent=F; Corner(Bg,4)
    local Lbl=Instance.new("TextLabel"); Lbl.AutomaticSize=Enum.AutomaticSize.X; Lbl.Size=UDim2.new(0,0,1,0)
    Lbl.BackgroundTransparency=1; Lbl.Text="  "..label.."  "; Lbl.TextColor3=C.AccentBright
    Lbl.TextSize=10; Lbl.Font=Enum.Font.GothamBold; Lbl.ZIndex=12; Lbl.Parent=Bg
    return F
end

local function Toggle(parent, title, desc, default, callback)
    local enabled=default or false
    local hasDesc=(desc~=nil and desc~="")
    local F=Instance.new("Frame"); F.Size=UDim2.new(1,0,0,hasDesc and 54 or 42); F.BackgroundColor3=C.Card
    F.BorderSizePixel=0; F.ZIndex=10; F.Parent=parent; Corner(F,9); Stroke(F,Color3.fromRGB(36,30,58),1)
    local Title=Instance.new("TextLabel"); Title.Size=UDim2.new(1,-60,0,20); Title.Position=UDim2.new(0,12,0,hasDesc and 8 or 11)
    Title.BackgroundTransparency=1; Title.Text=title; Title.TextColor3=C.Text; Title.TextSize=13
    Title.Font=Enum.Font.GothamSemibold; Title.TextXAlignment=Enum.TextXAlignment.Left; Title.ZIndex=11; Title.Parent=F
    if hasDesc then
        local D=Instance.new("TextLabel"); D.Size=UDim2.new(1,-60,0,14); D.Position=UDim2.new(0,12,0,30)
        D.BackgroundTransparency=1; D.Text=desc; D.TextColor3=C.TextDim; D.TextSize=10; D.Font=Enum.Font.Gotham
        D.TextXAlignment=Enum.TextXAlignment.Left; D.ZIndex=11; D.Parent=F
    end
    local Track=Instance.new("Frame"); Track.Size=UDim2.new(0,44,0,24); Track.Position=UDim2.new(1,-56,0.5,-12)
    Track.BackgroundColor3=enabled and C.On or C.Off; Track.BorderSizePixel=0; Track.ZIndex=11; Track.Parent=F; Corner(Track,12)
    local Knob=Instance.new("Frame"); Knob.Size=UDim2.new(0,18,0,18)
    Knob.Position=enabled and UDim2.new(0,23,0.5,-9) or UDim2.new(0,3,0.5,-9)
    Knob.BackgroundColor3=Color3.fromRGB(255,255,255); Knob.BorderSizePixel=0; Knob.ZIndex=12; Knob.Parent=Track; Corner(Knob,9)
    local KG=Instance.new("ImageLabel"); KG.BackgroundTransparency=1; KG.Image="rbxassetid://5028857084"; KG.ImageColor3=C.Accent
    KG.ImageTransparency=enabled and 0.45 or 1; KG.Size=UDim2.new(1,18,1,18); KG.Position=UDim2.new(0,-9,0,-9); KG.ZIndex=11; KG.Parent=Knob
    local function Flip()
        enabled=not enabled
        Tween(Track,{BackgroundColor3=enabled and C.On or C.Off},0.22)
        Tween(Knob,{Position=enabled and UDim2.new(0,23,0.5,-9) or UDim2.new(0,3,0.5,-9)},0.22,Enum.EasingStyle.Back)
        Tween(KG,{ImageTransparency=enabled and 0.45 or 1},0.2)
        Tween(F,{BackgroundColor3=enabled and Color3.fromRGB(20,15,36) or C.Card},0.2)
        if callback then callback(enabled) end
    end
    local HB=Instance.new("TextButton"); HB.Size=UDim2.new(1,0,1,0); HB.BackgroundTransparency=1; HB.Text=""; HB.ZIndex=13; HB.Parent=F
    HB.MouseEnter:Connect(function() Tween(F,{BackgroundColor3=Color3.fromRGB(24,20,40)},0.14) end)
    HB.MouseLeave:Connect(function() if not enabled then Tween(F,{BackgroundColor3=C.Card},0.18) end end)
    HB.MouseButton1Click:Connect(function() Tween(F,{BackgroundColor3=Color3.fromRGB(55,35,110)},0.08); Flip() end)
    enabled=default or false; Track.BackgroundColor3=enabled and C.On or C.Off
    Knob.Position=enabled and UDim2.new(0,23,0.5,-9) or UDim2.new(0,3,0.5,-9)
    KG.ImageTransparency=enabled and 0.45 or 1
    if enabled then F.BackgroundColor3=Color3.fromRGB(20,15,36) end
    return F, function() return enabled end
end

-- Mobile-friendly slider with +/- buttons
local function Slider(parent, title, minV, maxV, default, callback)
    local value=default
    local F=Instance.new("Frame"); F.Size=UDim2.new(1,0,0,76); F.BackgroundColor3=C.Card
    F.BorderSizePixel=0; F.ZIndex=10; F.Parent=parent; Corner(F,9); Stroke(F,Color3.fromRGB(36,30,58),1)
    local TL=Instance.new("TextLabel"); TL.Size=UDim2.new(1,-70,0,20); TL.Position=UDim2.new(0,12,0,8)
    TL.BackgroundTransparency=1; TL.Text=title; TL.TextColor3=C.Text; TL.TextSize=13; TL.Font=Enum.Font.GothamSemibold
    TL.TextXAlignment=Enum.TextXAlignment.Left; TL.ZIndex=11; TL.Parent=F
    local VB=Instance.new("Frame"); VB.Size=UDim2.new(0,52,0,20); VB.Position=UDim2.new(1,-64,0,8)
    VB.BackgroundColor3=C.Accent; VB.BackgroundTransparency=0.68; VB.BorderSizePixel=0; VB.ZIndex=11; VB.Parent=F; Corner(VB,5)
    local VL=Instance.new("TextLabel"); VL.Size=UDim2.new(1,0,1,0); VL.BackgroundTransparency=1; VL.Text=tostring(default)
    VL.TextColor3=C.Text; VL.TextSize=11; VL.Font=Enum.Font.GothamBold; VL.ZIndex=12; VL.Parent=VB
    local Track=Instance.new("Frame"); Track.Size=UDim2.new(1,-24,0,6); Track.Position=UDim2.new(0,12,0,40)
    Track.BackgroundColor3=Color3.fromRGB(28,24,46); Track.BorderSizePixel=0; Track.ZIndex=11; Track.Parent=F; Corner(Track,3)
    local Fill=Instance.new("Frame"); Fill.Size=UDim2.new((default-minV)/(maxV-minV),0,1,0); Fill.BackgroundColor3=C.Accent
    Fill.BorderSizePixel=0; Fill.ZIndex=12; Fill.Parent=Track; Corner(Fill,3); Gradient(Fill,C.AccentDark,C.AccentBright,0)
    local Knob=Instance.new("Frame"); Knob.Size=UDim2.new(0,14,0,14); Knob.Position=UDim2.new((default-minV)/(maxV-minV),-7,0.5,-7)
    Knob.BackgroundColor3=Color3.fromRGB(240,240,255); Knob.BorderSizePixel=0; Knob.ZIndex=13; Knob.Parent=Track; Corner(Knob,7); Glow(Knob,C.Accent,14)

    -- Mobile +/- buttons
    local step = math.max(1, math.floor((maxV-minV)/20))
    local MinusBtn=Instance.new("TextButton"); MinusBtn.Size=UDim2.new(0,34,0,22); MinusBtn.Position=UDim2.new(0,12,0,50)
    MinusBtn.BackgroundColor3=C.AccentDark; MinusBtn.Text="−"; MinusBtn.TextColor3=C.Text; MinusBtn.TextSize=16
    MinusBtn.Font=Enum.Font.GothamBold; MinusBtn.ZIndex=12; MinusBtn.BorderSizePixel=0; MinusBtn.Parent=F; Corner(MinusBtn,6)
    local PlusBtn=Instance.new("TextButton"); PlusBtn.Size=UDim2.new(0,34,0,22); PlusBtn.Position=UDim2.new(1,-46,0,50)
    PlusBtn.BackgroundColor3=C.AccentDark; PlusBtn.Text="+"; PlusBtn.TextColor3=C.Text; PlusBtn.TextSize=16
    PlusBtn.Font=Enum.Font.GothamBold; PlusBtn.ZIndex=12; PlusBtn.BorderSizePixel=0; PlusBtn.Parent=F; Corner(PlusBtn,6)

    local function SetValue(v)
        value=math.clamp(v,minV,maxV)
        local t=(value-minV)/(maxV-minV)
        VL.Text=tostring(value)
        Tween(Fill,{Size=UDim2.new(t,0,1,0)},0.05)
        Tween(Knob,{Position=UDim2.new(t,-7,0.5,-7)},0.05)
        if callback then callback(value) end
    end

    MinusBtn.MouseButton1Click:Connect(function() SetValue(value-step) end)
    PlusBtn.MouseButton1Click:Connect(function() SetValue(value+step) end)
    MinusBtn.MouseEnter:Connect(function() Tween(MinusBtn,{BackgroundColor3=C.Accent},0.12) end)
    MinusBtn.MouseLeave:Connect(function() Tween(MinusBtn,{BackgroundColor3=C.AccentDark},0.15) end)
    PlusBtn.MouseEnter:Connect(function() Tween(PlusBtn,{BackgroundColor3=C.Accent},0.12) end)
    PlusBtn.MouseLeave:Connect(function() Tween(PlusBtn,{BackgroundColor3=C.AccentDark},0.15) end)

    local sliding=false
    local function Update(pos)
        local abs=Track.AbsolutePosition; local sz=Track.AbsoluteSize
        local t=math.clamp((pos.X-abs.X)/sz.X,0,1)
        SetValue(math.floor(minV+t*(maxV-minV)))
    end
    Track.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=true; Update(i.Position) end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if sliding and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then Update(i.Position) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=false end
    end)
    return F
end

local function Button(parent, title, desc, callback)
    local F=Instance.new("Frame"); F.Size=UDim2.new(1,0,0,desc and 50 or 42); F.BackgroundColor3=C.Card
    F.BorderSizePixel=0; F.ZIndex=10; F.Parent=parent; Corner(F,9); Stroke(F,Color3.fromRGB(36,30,58),1)
    local T=Instance.new("TextLabel"); T.Size=UDim2.new(1,-32,0,20); T.Position=UDim2.new(0,12,0,desc and 7 or 11)
    T.BackgroundTransparency=1; T.Text=title; T.TextColor3=C.Text; T.TextSize=13; T.Font=Enum.Font.GothamSemibold
    T.TextXAlignment=Enum.TextXAlignment.Left; T.ZIndex=11; T.Parent=F
    if desc then
        local D=Instance.new("TextLabel"); D.Size=UDim2.new(1,-32,0,14); D.Position=UDim2.new(0,12,0,28)
        D.BackgroundTransparency=1; D.Text=desc; D.TextColor3=C.TextDim; D.TextSize=10; D.Font=Enum.Font.Gotham
        D.TextXAlignment=Enum.TextXAlignment.Left; D.ZIndex=11; D.Parent=F
    end
    local Arrow=Instance.new("TextLabel"); Arrow.Size=UDim2.new(0,20,1,0); Arrow.Position=UDim2.new(1,-26,0,0)
    Arrow.BackgroundTransparency=1; Arrow.Text="›"; Arrow.TextColor3=C.Accent; Arrow.TextSize=20; Arrow.Font=Enum.Font.GothamBold; Arrow.ZIndex=11; Arrow.Parent=F
    local Btn=Instance.new("TextButton"); Btn.Size=UDim2.new(1,0,1,0); Btn.BackgroundTransparency=1; Btn.Text=""; Btn.ZIndex=12; Btn.Parent=F
    Btn.MouseEnter:Connect(function() Tween(F,{BackgroundColor3=Color3.fromRGB(26,20,46)},0.14); Tween(Arrow,{Position=UDim2.new(1,-20,0,0),TextColor3=C.AccentBright},0.14) end)
    Btn.MouseLeave:Connect(function() Tween(F,{BackgroundColor3=C.Card},0.18); Tween(Arrow,{Position=UDim2.new(1,-26,0,0),TextColor3=C.Accent},0.18) end)
    Btn.MouseButton1Click:Connect(function() Tween(F,{BackgroundColor3=Color3.fromRGB(65,38,130)},0.08); task.wait(0.12); Tween(F,{BackgroundColor3=C.Card},0.2); if callback then callback() end end)
    return F
end

local function Dropdown(parent, title, options, default, callback)
    local selected=default or options[1]; local open=false
    local Wrap=Instance.new("Frame"); Wrap.Size=UDim2.new(1,0,0,50); Wrap.BackgroundColor3=C.Card
    Wrap.BorderSizePixel=0; Wrap.ClipsDescendants=false; Wrap.ZIndex=10; Wrap.Parent=parent; Corner(Wrap,9); Stroke(Wrap,Color3.fromRGB(36,30,58),1)
    local TL2=Instance.new("TextLabel"); TL2.Size=UDim2.new(1,-30,0,16); TL2.Position=UDim2.new(0,12,0,6)
    TL2.BackgroundTransparency=1; TL2.Text=title; TL2.TextColor3=C.TextDim; TL2.TextSize=10; TL2.Font=Enum.Font.Gotham
    TL2.TextXAlignment=Enum.TextXAlignment.Left; TL2.ZIndex=11; TL2.Parent=Wrap
    local SL=Instance.new("TextLabel"); SL.Size=UDim2.new(1,-34,0,18); SL.Position=UDim2.new(0,12,0,24)
    SL.BackgroundTransparency=1; SL.Text=selected; SL.TextColor3=C.Text; SL.TextSize=13; SL.Font=Enum.Font.GothamSemibold
    SL.TextXAlignment=Enum.TextXAlignment.Left; SL.ZIndex=11; SL.Parent=Wrap
    local Chev=Instance.new("TextLabel"); Chev.Size=UDim2.new(0,22,0,22); Chev.Position=UDim2.new(1,-30,0.5,-11)
    Chev.BackgroundTransparency=1; Chev.Text="▾"; Chev.TextColor3=C.Accent; Chev.TextSize=14; Chev.Font=Enum.Font.GothamBold; Chev.ZIndex=11; Chev.Parent=Wrap
    local DF=Instance.new("Frame"); DF.Size=UDim2.new(1,0,0,0); DF.Position=UDim2.new(0,0,1,4)
    DF.BackgroundColor3=Color3.fromRGB(16,12,30); DF.BorderSizePixel=0; DF.ClipsDescendants=true; DF.ZIndex=25; DF.Parent=Wrap; Corner(DF,8); Stroke(DF,C.Border,1)
    local DL2=Instance.new("UIListLayout"); DL2.Padding=UDim.new(0,2); DL2.Parent=DF
    local DP=Instance.new("UIPadding"); DP.PaddingTop=UDim.new(0,4); DP.PaddingBottom=UDim.new(0,4); DP.PaddingLeft=UDim.new(0,4); DP.PaddingRight=UDim.new(0,4); DP.Parent=DF
    for _,opt in ipairs(options) do
        local OB=Instance.new("TextButton"); OB.Size=UDim2.new(1,0,0,30); OB.BackgroundColor3=Color3.fromRGB(26,20,48); OB.BackgroundTransparency=0.5
        OB.Text=opt; OB.TextColor3=opt==selected and C.Text or C.TextDim; OB.TextSize=12; OB.Font=Enum.Font.GothamSemibold; OB.ZIndex=26; OB.Parent=DF; Corner(OB,5)
        OB.MouseEnter:Connect(function() Tween(OB,{BackgroundTransparency=0,BackgroundColor3=Color3.fromRGB(55,35,110)},0.13); Tween(OB,{TextColor3=C.Text},0.13) end)
        OB.MouseLeave:Connect(function() if opt~=selected then Tween(OB,{BackgroundTransparency=0.5,BackgroundColor3=Color3.fromRGB(26,20,48)},0.18); Tween(OB,{TextColor3=C.TextDim},0.18) end end)
        OB.MouseButton1Click:Connect(function()
            selected=opt; SL.Text=opt; open=false
            Tween(DF,{Size=UDim2.new(1,0,0,0)},0.2,Enum.EasingStyle.Quart); Tween(Chev,{Rotation=0},0.2)
            if callback then callback(opt) end
        end)
    end
    local HB=Instance.new("TextButton"); HB.Size=UDim2.new(1,0,0,50); HB.BackgroundTransparency=1; HB.Text=""; HB.ZIndex=12; HB.Parent=Wrap
    HB.MouseButton1Click:Connect(function()
        open=not open; local h=open and (#options*32+10) or 0
        Tween(DF,{Size=UDim2.new(1,0,0,h)},0.22,Enum.EasingStyle.Quart); Tween(Chev,{Rotation=open and 180 or 0},0.22)
    end)
    return Wrap
end

-- ================================================
-- BUILD TABS
-- ================================================
local PVisuals  = NewTab("Visuals",  "👁")
local PMovement = NewTab("Movement", "⚡")
local PCombat   = NewTab("Combat",   "⚔")
local PWorld    = NewTab("World",    "🌍")
local PTeleport = NewTab("Teleport", "✦")
local PEmotes   = NewTab("Emotes",   "★")
local PMisc     = NewTab("Misc",     "⚙")
SwitchTab("Visuals")

-- ================================================
-- STATE
-- ================================================
local S = {
    espOn=false, nameOn=false, tracerOn=false, healthOn=false, distOn=false,
    espColor=Color3.fromRGB(110,55,255), chamsOn=false, chamsColor=Color3.fromRGB(255,50,50),
    crosshairOn=false, fovCircleOn=false, fovRadius=80,
    speedOn=false, speedVal=40, autoSprintOn=false,
    flyOn=false, flyVal=60, hjOn=false, hjVal=100,
    ijOn=false, noclipOn=false, glideOn=false, lowGravOn=false,
    swimOn=false, swimVal=30,
    aimbotOn=false, aimbotSmooth=0.3, aimbotFOV=200, aimbotBone="Head",
    hitboxOn=false, hitboxSize=6,
    antiKBOn=false, reachOn=false, reachVal=8, fastHitOn=false, godModeOn=false,
    fullbrightOn=false, antiAFKOn=true, timeVal=14,
    rainbowSkyOn=false, gravVal=196, antiVoidOn=false, chatSpyOn=false,
    activeEmote=nil,
}

-- ================================================
-- VISUALS PAGE
-- ================================================
Section(PVisuals,"Player ESP")
Toggle(PVisuals,"ESP Boxes","Show boxes around players",false,function(v) S.espOn=v end)
Toggle(PVisuals,"Name Tags","Player names above head",false,function(v) S.nameOn=v end)
Toggle(PVisuals,"Tracers","Draw lines to players",false,function(v) S.tracerOn=v end)
Toggle(PVisuals,"Health Bars","Show health bars on players",false,function(v) S.healthOn=v end)
Toggle(PVisuals,"Distance","Show distance in metres",false,function(v) S.distOn=v end)
Toggle(PVisuals,"Chams","Color player models",false,function(v)
    S.chamsOn=v
    if not v then
        for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then
            for _,part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then pcall(function() part.Material=Enum.Material.SmoothPlastic end) end
            end
        end end
    end
    Notify("Chams",v and "Aktiviert" or "Deaktiviert",v and "success" or "warn")
end)
Section(PVisuals,"Screen Overlays")
Toggle(PVisuals,"Crosshair","Custom crosshair on screen",false,function(v) S.crosshairOn=v end)
Toggle(PVisuals,"FOV Circle","Show aimbot FOV circle",false,function(v) S.fovCircleOn=v end)
Slider(PVisuals,"FOV Radius",20,300,80,function(v) S.fovRadius=v end)
Section(PVisuals,"Appearance")
Dropdown(PVisuals,"ESP Color",{"Purple","Cyan","Red","Green","White","Gold","Pink"},"Purple",function(v)
    local m={Purple=Color3.fromRGB(130,60,255),Cyan=Color3.fromRGB(0,210,255),Red=Color3.fromRGB(255,60,60),Green=Color3.fromRGB(50,230,100),White=Color3.fromRGB(240,240,255),Gold=Color3.fromRGB(255,210,50),Pink=Color3.fromRGB(255,80,180)}
    S.espColor=m[v] or S.espColor
end)
Dropdown(PVisuals,"Chams Color",{"Red","Blue","Green","Yellow","Pink","Orange"},"Red",function(v)
    local m={Red=Color3.fromRGB(255,50,50),Blue=Color3.fromRGB(50,100,255),Green=Color3.fromRGB(50,230,100),Yellow=Color3.fromRGB(255,220,50),Pink=Color3.fromRGB(255,80,200),Orange=Color3.fromRGB(255,140,30)}
    S.chamsColor=m[v] or S.chamsColor
end)

-- ================================================
-- MOVEMENT PAGE
-- ================================================
Section(PMovement,"Walk & Run")
Toggle(PMovement,"Speed Hack","Increase movement speed",false,function(v)
    S.speedOn=v
    if not v then local c=LocalPlayer.Character; if c then local h=c:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed=16 end end end
    Notify("Speed",v and "Speed: "..S.speedVal or "Zurückgesetzt",v and "success" or "warn")
end)
Slider(PMovement,"Speed Value",16,350,40,function(v) S.speedVal=v end)
Toggle(PMovement,"Auto Sprint","Always sprint automatically",false,function(v) S.autoSprintOn=v end)
Section(PMovement,"Jumping")
Toggle(PMovement,"High Jump","Boost jump power",false,function(v)
    S.hjOn=v; local c=LocalPlayer.Character; if c then local h=c:FindFirstChildOfClass("Humanoid"); if h then h.JumpPower=v and S.hjVal or 50 end end
end)
Slider(PMovement,"Jump Power",50,600,100,function(v)
    S.hjVal=v; if S.hjOn then local c=LocalPlayer.Character; if c then local h=c:FindFirstChildOfClass("Humanoid"); if h then h.JumpPower=v end end end
end)
Toggle(PMovement,"Infinite Jump","Jump again mid-air",false,function(v) S.ijOn=v end)
Toggle(PMovement,"Low Gravity","Reduced gravity feel",false,function(v) S.lowGravOn=v; Workspace.Gravity=v and 50 or S.gravVal end)
Section(PMovement,"Air & Misc")
Toggle(PMovement,"Fly","Free-flight (WASD + Space/Ctrl)",false,function(v) S.flyOn=v end)
Slider(PMovement,"Fly Speed",10,400,60,function(v) S.flyVal=v end)
Toggle(PMovement,"Glide","Slow-fall / glide",false,function(v) S.glideOn=v end)
Toggle(PMovement,"NoClip","Walk through walls",false,function(v) S.noclipOn=v; Notify("NoClip",v and "An" or "Aus",v and "success" or "warn") end)
Toggle(PMovement,"Swim Speed","Faster swimming",false,function(v) S.swimOn=v end)
Slider(PMovement,"Swim Speed Val",10,200,30,function(v) S.swimVal=v end)

-- ================================================
-- COMBAT PAGE
-- ================================================
Section(PCombat,"Aimbot")
Toggle(PCombat,"Aimbot","Auto-aim camera to nearest player",false,function(v)
    S.aimbotOn=v; Notify("Aimbot",v and "Aktiviert" or "Deaktiviert",v and "success" or "warn")
end)
Dropdown(PCombat,"Aimbot Target",{"Head","HumanoidRootPart","Torso","Left Leg","Right Leg"},"Head",function(v) S.aimbotBone=v end)
Slider(PCombat,"Aimbot Smooth (1=fast)",1,10,3,function(v) S.aimbotSmooth=v/10 end)
Slider(PCombat,"Aimbot FOV",20,500,200,function(v) S.aimbotFOV=v end)

Section(PCombat,"Hitbox")
Toggle(PCombat,"Bigger Hitboxes","Expand enemy hit collision boxes",false,function(v)
    S.hitboxOn=v
    if not v then
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                local hrp=p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then pcall(function() hrp.Size=Vector3.new(2,2,1) end) end
            end
        end
    end
    Notify("Hitbox",v and "Expanded: "..S.hitboxSize or "Zurückgesetzt",v and "success" or "warn")
end)
Slider(PCombat,"Hitbox Size",2,20,6,function(v) S.hitboxSize=v end)

Section(PCombat,"Defense")
Toggle(PCombat,"Anti-Knockback","Resist being knocked back",false,function(v) S.antiKBOn=v end)
Toggle(PCombat,"God Mode (Local)","Lock HP – local only",false,function(v)
    S.godModeOn=v; Notify("God Mode",v and "HP wird gelockt" or "Aus",v and "success" or "warn")
end)

Section(PCombat,"Offense")
Toggle(PCombat,"Extended Reach","Hit from further distance",false,function(v) S.reachOn=v end)
Slider(PCombat,"Reach Distance",4,30,8,function(v) S.reachVal=v end)
Toggle(PCombat,"Fast Hit","Reduce attack cooldown",false,function(v) S.fastHitOn=v end)

Section(PCombat,"Utility")
Button(PCombat,"Rejoin Game","Leave and rejoin current game",function()
    pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId,LocalPlayer) end)
    Notify("Rejoin","Rejoining...","info")
end)

-- ================================================
-- WORLD PAGE
-- ================================================
Section(PWorld,"Lighting")
Toggle(PWorld,"Fullbright","Maximum brightness always",false,function(v)
    S.fullbrightOn=v; Lighting.Brightness=v and 10 or 1; Lighting.GlobalShadows=not v
    Lighting.Ambient=v and Color3.fromRGB(255,255,255) or Color3.fromRGB(127,127,127)
    Lighting.OutdoorAmbient=v and Color3.fromRGB(255,255,255) or Color3.fromRGB(127,127,127)
    Notify("Fullbright",v and "An" or "Aus",v and "success" or "warn")
end)
Toggle(PWorld,"Disable Fog","Remove all fog from the map",false,function(v)
    Lighting.FogEnd=v and 9e8 or 1000; Lighting.FogStart=v and 9e8 or 0
end)
Slider(PWorld,"Time of Day",0,24,14,function(v) S.timeVal=v; Lighting.ClockTime=v end)
Toggle(PWorld,"Rainbow Sky","Cycle sky colors continuously",false,function(v) S.rainbowSkyOn=v end)
Section(PWorld,"Physics")
Slider(PWorld,"Gravity",10,400,196,function(v) S.gravVal=v; if not S.lowGravOn then Workspace.Gravity=v end end)
Toggle(PWorld,"Anti-Void","Teleport up if you fall too far",false,function(v) S.antiVoidOn=v end)
Section(PWorld,"Server")
Toggle(PWorld,"Anti-AFK","Prevent AFK kick",true,function(v) S.antiAFKOn=v end)
Toggle(PWorld,"Chat Spy","See all player chat in output",false,function(v)
    S.chatSpyOn=v; Notify("Chat Spy",v and "Aktiviert" or "Deaktiviert",v and "success" or "warn")
end)
Button(PWorld,"Server Hop","Join a new server of this game",function()
    Notify("Server Hop","Suche neuen Server...","info")
    pcall(function()
        local data=HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _,s in ipairs(data.data) do
            if s.id~=game.JobId and s.playing<s.maxPlayers then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,s.id,LocalPlayer); return
            end
        end
        Notify("Server Hop","Kein freier Server gefunden","warn")
    end)
end)

-- ================================================
-- TELEPORT PAGE
-- ================================================
Section(PTeleport,"Quick Teleport")
Button(PTeleport,"Teleport to Spawn","Go to the spawn location",function()
    local c=LocalPlayer.Character; if c then
        local sp=Workspace:FindFirstChildOfClass("SpawnLocation")
        if sp then c:MoveTo(sp.Position+Vector3.new(0,5,0)); Notify("Teleport","Zur Spawnpoint","success") end
    end
end)
Button(PTeleport,"Teleport to World Center","Move to 0, 0, 0",function()
    local c=LocalPlayer.Character; if c then c:MoveTo(Vector3.new(0,80,0)); Notify("Teleport","Weltmitte","success") end
end)
Button(PTeleport,"Float Up 50 Studs","Teleport upward",function()
    local c=LocalPlayer.Character; if c and c.PrimaryPart then c:MoveTo(c.PrimaryPart.Position+Vector3.new(0,50,0)) end
end)
Button(PTeleport,"Random Teleport","Jump to a random location",function()
    local c=LocalPlayer.Character; if c then
        local x,z=math.random(-500,500),math.random(-500,500)
        c:MoveTo(Vector3.new(x,80,z)); Notify("Teleport","Zufällig: "..x..", "..z,"info")
    end
end)
Section(PTeleport,"Player Teleport")
local pBtns={}
local function RefreshPlayerList()
    for _,b in ipairs(pBtns) do b:Destroy() end; pBtns={}
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer then
            local b=Button(PTeleport,"→  "..p.Name,"Teleport to "..p.Name,function()
                local c=LocalPlayer.Character; local t=p.Character
                if c and t and t.PrimaryPart then c:MoveTo(t.PrimaryPart.Position+Vector3.new(3,2,0)); Notify("Teleport","Zu "..p.Name,"success") end
            end); table.insert(pBtns,b)
        end
    end
end
Button(PTeleport,"Refresh Player List","Update teleport targets",function() RefreshPlayerList() end)
RefreshPlayerList()
Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(function() task.wait(0.5); RefreshPlayerList() end)

-- ================================================
-- EMOTES PAGE
-- ================================================
local function StopEmote()
    S.activeEmote=nil; local c=LocalPlayer.Character; if not c then return end
    local h=c:FindFirstChildOfClass("Humanoid"); if h then h:ChangeState(Enum.HumanoidStateType.GettingUp) end
    for _,p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide=true end
        if p:IsA("BodyPosition") or p:IsA("BodyVelocity") or p:IsA("BodyGyro") then p:Destroy() end
    end
end
Section(PEmotes,"Custom Emotes")
Button(PEmotes,"Helicopter","Spin like a helicopter blade",function()
    StopEmote(); S.activeEmote="heli"
    coroutine.wrap(function() while S.activeEmote=="heli" do local c=LocalPlayer.Character; if c and c.PrimaryPart then c.PrimaryPart.CFrame=c.PrimaryPart.CFrame*CFrame.Angles(0,math.rad(18),0) end; task.wait(0.02) end end)()
end)
Button(PEmotes,"Levitate","Float in the air calmly",function()
    StopEmote(); S.activeEmote="lev"
    coroutine.wrap(function()
        local c=LocalPlayer.Character; if not c or not c.PrimaryPart then return end
        local bp=Instance.new("BodyPosition"); bp.MaxForce=Vector3.new(math.huge,math.huge,math.huge); bp.D=300; bp.P=5000; bp.Parent=c.PrimaryPart
        local base=c.PrimaryPart.Position; local t=0
        while S.activeEmote=="lev" do t=t+0.02; bp.Position=base+Vector3.new(0,math.sin(t)*2.5+4,0); task.wait(0.03) end; bp:Destroy()
    end)()
end)
Button(PEmotes,"The Worm","Do the worm on the floor",function()
    StopEmote(); S.activeEmote="worm"
    coroutine.wrap(function()
        local c=LocalPlayer.Character; if not c or not c.PrimaryPart then return end
        local h=c:FindFirstChildOfClass("Humanoid"); if h then h:ChangeState(Enum.HumanoidStateType.Physics) end
        local t=0
        while S.activeEmote=="worm" do t=t+0.12; if c.PrimaryPart then c.PrimaryPart.CFrame=c.PrimaryPart.CFrame*CFrame.new(0,math.abs(math.sin(t))*0.5,0)*CFrame.Angles(math.sin(t)*0.5,0,0) end; task.wait(0.05) end
    end)()
end)
Button(PEmotes,"Moonwalk","Slide backwards like MJ",function()
    StopEmote(); S.activeEmote="moon"
    coroutine.wrap(function() while S.activeEmote=="moon" do local c=LocalPlayer.Character; if c and c.PrimaryPart then c.PrimaryPart.CFrame=c.PrimaryPart.CFrame*CFrame.new(0,0,0.35) end; task.wait(0.03) end end)()
end)
Button(PEmotes,"Spin Attack","Spin rapidly with arms out",function()
    StopEmote(); S.activeEmote="spin"
    coroutine.wrap(function() while S.activeEmote=="spin" do local c=LocalPlayer.Character; if c and c.PrimaryPart then c.PrimaryPart.CFrame=c.PrimaryPart.CFrame*CFrame.Angles(0,math.rad(22),0) end; task.wait(0.025) end end)()
end)
Button(PEmotes,"Play Dead","Ragdoll on the ground",function()
    StopEmote(); S.activeEmote="dead"; local c=LocalPlayer.Character; if not c then return end
    local h=c:FindFirstChildOfClass("Humanoid"); if h then h:ChangeState(Enum.HumanoidStateType.Physics) end
    for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
end)
Button(PEmotes,"Bounce","Bounce up and down",function()
    StopEmote(); S.activeEmote="bounce"
    coroutine.wrap(function() while S.activeEmote=="bounce" do local c=LocalPlayer.Character; if c then local h=c:FindFirstChildOfClass("Humanoid"); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end; task.wait(0.45) end end)()
end)
Button(PEmotes,"Floaty Idle","Gently float and sway",function()
    StopEmote(); S.activeEmote="floaty"
    coroutine.wrap(function()
        local c=LocalPlayer.Character; if not c or not c.PrimaryPart then return end
        local bp=Instance.new("BodyPosition"); bp.MaxForce=Vector3.new(math.huge,math.huge,math.huge); bp.D=200; bp.P=3000; bp.Parent=c.PrimaryPart
        local base=c.PrimaryPart.Position; local t=0
        while S.activeEmote=="floaty" do t=t+0.015; bp.Position=base+Vector3.new(math.sin(t*0.7)*1.5,math.sin(t)*1.5,math.cos(t*0.5)*1.5); task.wait(0.03) end; bp:Destroy()
    end)()
end)
Section(PEmotes,"Control")
Button(PEmotes,"Stop Emote","Stop current emote",function() StopEmote() end)

-- ================================================
-- MISC PAGE
-- ================================================
Section(PMisc,"Character")
Button(PMisc,"Reset Character","Respawn your character",function()
    local c=LocalPlayer.Character; if c then local h=c:FindFirstChildOfClass("Humanoid"); if h then h.Health=0 end end
end)
Button(PMisc,"Local Invisible","Make yourself transparent",function()
    local c=LocalPlayer.Character; if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.LocalTransparencyModifier=0.96 end end; Notify("Invisible","Lokal unsichtbar","success") end
end)
Button(PMisc,"Restore Visibility","Make yourself visible again",function()
    local c=LocalPlayer.Character; if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.LocalTransparencyModifier=0 end end; Notify("Visible","Sichtbar","success") end
end)
Section(PMisc,"UI & Display")
Toggle(PMisc,"Fullbright","Maximum brightness",false,function(v)
    Lighting.Brightness=v and 10 or 1; Lighting.GlobalShadows=not v
    Lighting.Ambient=v and Color3.fromRGB(255,255,255) or Color3.fromRGB(127,127,127)
end)
Toggle(PMisc,"Anti-AFK","Prevent AFK kick",true,function(v) S.antiAFKOn=v end)
Button(PMisc,"Screenshot Flash","Flash for screenshot moment",function()
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,1,0); f.BackgroundColor3=Color3.fromRGB(255,255,255)
    f.BackgroundTransparency=0; f.ZIndex=999; f.BorderSizePixel=0; f.Parent=ScreenGui
    Tween(f,{BackgroundTransparency=1},0.6); task.wait(0.65); f:Destroy()
end)

-- ================================================
-- MOBILE FLY CONTROLS
-- ================================================
local MobileFlyPanel = Instance.new("Frame")
MobileFlyPanel.Size = UDim2.new(0, 200, 0, 140)
MobileFlyPanel.Position = UDim2.new(0, 10, 1, -160)
MobileFlyPanel.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
MobileFlyPanel.BackgroundTransparency = 0.3
MobileFlyPanel.BorderSizePixel = 0
MobileFlyPanel.ZIndex = 50
MobileFlyPanel.Visible = false
MobileFlyPanel.Parent = ScreenGui
Corner(MobileFlyPanel, 12); Stroke(MobileFlyPanel, C.Border, 1)

local flyKeys = {W=false,A=false,S=false,D=false,UP=false,DOWN=false}
local function MakeFlyBtn(label, x, y, w, h, keyName)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, w, 0, h); b.Position = UDim2.new(0, x, 0, y)
    b.BackgroundColor3 = C.AccentDark; b.BackgroundTransparency = 0.3
    b.Text = label; b.TextColor3 = C.Text; b.TextSize = 14; b.Font = Enum.Font.GothamBold
    b.ZIndex = 51; b.BorderSizePixel = 0; b.Parent = MobileFlyPanel; Corner(b, 6)
    b.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then flyKeys[keyName]=true; Tween(b,{BackgroundColor3=C.Accent},0.1) end end)
    b.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then flyKeys[keyName]=false; Tween(b,{BackgroundColor3=C.AccentDark},0.15) end end)
end
MakeFlyBtn("▲",75,5,50,38,"W")
MakeFlyBtn("◄",5,48,50,38,"A")
MakeFlyBtn("▼",75,48,50,38,"S")
MakeFlyBtn("►",140,48,50,38,"D")
MakeFlyBtn("↑",5,95,90,38,"UP")
MakeFlyBtn("↓",105,95,90,38,"DOWN")

-- ================================================
-- ESP DRAWING
-- ================================================
local ESPData={}
local CrosshairLines={}
local FOVCircle=nil

local function MakeESP(player)
    if player==LocalPlayer then return end; local d={}
    d.Box=Drawing.new("Square"); d.Box.Visible=false; d.Box.Thickness=1.8; d.Box.Filled=false
    d.BoxFill=Drawing.new("Square"); d.BoxFill.Visible=false; d.BoxFill.Thickness=0; d.BoxFill.Filled=true; d.BoxFill.Transparency=0.88
    d.Name=Drawing.new("Text"); d.Name.Visible=false; d.Name.Size=13; d.Name.Center=true; d.Name.Outline=true; d.Name.Font=2
    d.Tracer=Drawing.new("Line"); d.Tracer.Visible=false; d.Tracer.Thickness=1
    d.HpBG=Drawing.new("Square"); d.HpBG.Visible=false; d.HpBG.Filled=true; d.HpBG.Color=Color3.fromRGB(0,0,0); d.HpBG.Transparency=0.55
    d.HpFill=Drawing.new("Square"); d.HpFill.Visible=false; d.HpFill.Filled=true
    d.Dist=Drawing.new("Text"); d.Dist.Visible=false; d.Dist.Size=11; d.Dist.Center=true; d.Dist.Outline=true; d.Dist.Font=2
    ESPData[player]=d
end
local function KillESP(player)
    local d=ESPData[player]; if d then for _,v in pairs(d) do pcall(function() v:Remove() end) end; ESPData[player]=nil end
end
for _,p in ipairs(Players:GetPlayers()) do MakeESP(p) end
Players.PlayerAdded:Connect(MakeESP); Players.PlayerRemoving:Connect(KillESP)

-- ================================================
-- FLY SYSTEM
-- ================================================
local flyBV,flyBG
local function StartFly()
    local c=LocalPlayer.Character; if not c or not c.PrimaryPart then return end
    flyBV=Instance.new("BodyVelocity"); flyBV.MaxForce=Vector3.new(math.huge,math.huge,math.huge); flyBV.Velocity=Vector3.new(0,0,0); flyBV.Parent=c.PrimaryPart
    flyBG=Instance.new("BodyGyro"); flyBG.MaxTorque=Vector3.new(math.huge,math.huge,math.huge); flyBG.D=120; flyBG.Parent=c.PrimaryPart
end
local function StopFly()
    if flyBV then flyBV:Destroy(); flyBV=nil end
    if flyBG then flyBG:Destroy(); flyBG=nil end
end

-- ================================================
-- INFINITE JUMP
-- ================================================
UserInputService.JumpRequest:Connect(function()
    if S.ijOn then local c=LocalPlayer.Character; if c then local h=c:FindFirstChildOfClass("Humanoid"); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end
end)

-- ================================================
-- ANTI-AFK
-- ================================================
task.spawn(function()
    while true do task.wait(55)
        if S.antiAFKOn then pcall(function()
            local vim=game:GetService("VirtualInputManager")
            vim:SendKeyEvent(true,"ButtonR3",false,game); task.wait(0.1); vim:SendKeyEvent(false,"ButtonR3",false,game)
        end) end
    end
end)

-- ================================================
-- CHAT SPY
-- ================================================
local function HookChat(p)
    p.Chatted:Connect(function(msg) if S.chatSpyOn and p~=LocalPlayer then print("[ChatSpy] "..p.Name..": "..msg) end end)
end
for _,p in ipairs(Players:GetPlayers()) do HookChat(p) end
Players.PlayerAdded:Connect(HookChat)

-- ================================================
-- MAIN LOOPS
-- ================================================
local rbHue=0
RunService.RenderStepped:Connect(function(dt)
    -- NoClip
    if S.noclipOn then local c=LocalPlayer.Character; if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end
    -- Glide
    if S.glideOn then local c=LocalPlayer.Character; if c and c.PrimaryPart then local v=c.PrimaryPart.Velocity; if v.Y<-2 then c.PrimaryPart.Velocity=Vector3.new(v.X,math.max(v.Y,-7),v.Z) end end end
    -- Rainbow Sky
    if S.rainbowSkyOn then rbHue=(rbHue+dt*0.06)%1; Lighting.Ambient=Color3.fromHSV(rbHue,0.5,1); Lighting.OutdoorAmbient=Color3.fromHSV((rbHue+0.3)%1,0.4,1) end
    -- Anti-Void
    if S.antiVoidOn then local c=LocalPlayer.Character; if c and c.PrimaryPart and c.PrimaryPart.Position.Y<-200 then c:MoveTo(Vector3.new(c.PrimaryPart.Position.X,50,c.PrimaryPart.Position.Z)); Notify("Anti-Void","Void erkannt!","warn") end end
    -- God Mode
    if S.godModeOn then local c=LocalPlayer.Character; if c then local h=c:FindFirstChildOfClass("Humanoid"); if h and h.Health<h.MaxHealth then h.Health=h.MaxHealth end end end
    -- Chams
    if S.chamsOn then for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then for _,part in ipairs(p.Character:GetDescendants()) do if part:IsA("BasePart") then pcall(function() part.Color=S.chamsColor; part.Material=Enum.Material.Neon end) end end end end end
    -- Hitbox Expander
    if S.hitboxOn then for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then local hrp=p.Character:FindFirstChild("HumanoidRootPart"); if hrp then pcall(function() hrp.Size=Vector3.new(S.hitboxSize,S.hitboxSize,S.hitboxSize) end) end end end end
    -- Aimbot (camera-based)
    if S.aimbotOn then
        local nearestTarget=nil; local nearestDist=S.aimbotFOV
        local center=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                local bone=p.Character:FindFirstChild(S.aimbotBone) or p.Character.PrimaryPart
                if bone then
                    local sp,onScreen=Camera:WorldToViewportPoint(bone.Position)
                    if onScreen and sp.Z>0 then
                        local d=(Vector2.new(sp.X,sp.Y)-center).Magnitude
                        if d<nearestDist then nearestDist=d; nearestTarget=bone end
                    end
                end
            end
        end
        if nearestTarget then
            local targetCF=CFrame.new(Camera.CFrame.Position,nearestTarget.Position)
            Camera.CFrame=Camera.CFrame:Lerp(targetCF,math.clamp(S.aimbotSmooth,0.05,1))
        end
    end
    -- Crosshair
    for _,l in ipairs(CrosshairLines) do pcall(function() l.Visible=S.crosshairOn end) end
    if S.crosshairOn and #CrosshairLines==0 then
        local cx=Camera.ViewportSize.X/2; local cy=Camera.ViewportSize.Y/2
        local pts={{Vector2.new(cx-12,cy),Vector2.new(cx-4,cy)},{Vector2.new(cx+4,cy),Vector2.new(cx+12,cy)},{Vector2.new(cx,cy-12),Vector2.new(cx,cy-4)},{Vector2.new(cx,cy+4),Vector2.new(cx,cy+12)}}
        for _,p2 in ipairs(pts) do local l=Drawing.new("Line"); l.From=p2[1]; l.To=p2[2]; l.Color=Color3.fromRGB(255,255,255); l.Thickness=1.5; l.Visible=true; table.insert(CrosshairLines,l) end
    end
    -- FOV Circle
    if S.fovCircleOn then
        if not FOVCircle then FOVCircle=Drawing.new("Circle"); FOVCircle.Thickness=1; FOVCircle.Transparency=0.3; FOVCircle.Filled=false; FOVCircle.Color=Color3.fromRGB(255,255,255) end
        FOVCircle.Visible=true; FOVCircle.Radius=S.fovRadius; FOVCircle.Position=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
    elseif FOVCircle then FOVCircle.Visible=false end
    -- ESP
    for player,d in pairs(ESPData) do
        local any=S.espOn or S.nameOn or S.tracerOn or S.healthOn or S.distOn
        local c=player.Character
        if any and c and c.PrimaryPart then
            local pp=c.PrimaryPart.Position
            local pos3,onScreen=Camera:WorldToViewportPoint(pp)
            local head3=Camera:WorldToViewportPoint(pp+Vector3.new(0,3.2,0))
            local feet3=Camera:WorldToViewportPoint(pp-Vector3.new(0,3.2,0))
            if onScreen then
                local h2=math.abs(head3.Y-feet3.Y); local w=h2*0.55; local bx=pos3.X-w/2; local by=head3.Y
                local col=S.espColor; local dist=math.floor((pp-Camera.CFrame.Position).Magnitude)
                if S.espOn then d.Box.Visible=true; d.Box.Position=Vector2.new(bx,by); d.Box.Size=Vector2.new(w,h2); d.Box.Color=col; d.BoxFill.Visible=true; d.BoxFill.Position=Vector2.new(bx,by); d.BoxFill.Size=Vector2.new(w,h2); d.BoxFill.Color=col else d.Box.Visible=false; d.BoxFill.Visible=false end
                if S.nameOn then d.Name.Visible=true; d.Name.Position=Vector2.new(pos3.X,head3.Y-16); d.Name.Text=player.Name; d.Name.Color=col else d.Name.Visible=false end
                if S.tracerOn then d.Tracer.Visible=true; d.Tracer.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y); d.Tracer.To=Vector2.new(pos3.X,pos3.Y); d.Tracer.Color=col else d.Tracer.Visible=false end
                if S.healthOn then local hum=c:FindFirstChildOfClass("Humanoid"); if hum then local r=math.clamp(hum.Health/hum.MaxHealth,0,1); d.HpBG.Visible=true; d.HpBG.Position=Vector2.new(bx-7,by); d.HpBG.Size=Vector2.new(4,h2); d.HpFill.Visible=true; d.HpFill.Color=Color3.fromRGB(255*(1-r),255*r,60); d.HpFill.Position=Vector2.new(bx-7,by+h2*(1-r)); d.HpFill.Size=Vector2.new(4,h2*r) end else d.HpBG.Visible=false; d.HpFill.Visible=false end
                if S.distOn then d.Dist.Visible=true; d.Dist.Position=Vector2.new(pos3.X,feet3.Y+5); d.Dist.Text=dist.."m"; d.Dist.Color=Color3.fromRGB(200,200,255) else d.Dist.Visible=false end
            else for _,v in pairs(d) do pcall(function() v.Visible=false end) end end
        else for _,v in pairs(d) do pcall(function() v.Visible=false end) end end
    end
end)

RunService.Heartbeat:Connect(function()
    -- Speed (persistent)
    if S.speedOn then local c=LocalPlayer.Character; if c then local h=c:FindFirstChildOfClass("Humanoid"); if h and h.WalkSpeed~=S.speedVal then h.WalkSpeed=S.speedVal end end end
    -- Auto Sprint
    if S.autoSprintOn then local c=LocalPlayer.Character; if c then local h=c:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed=math.max(h.WalkSpeed,24) end end end
    -- Swim Speed
    if S.swimOn then local c=LocalPlayer.Character; if c then local h=c:FindFirstChildOfClass("Humanoid"); if h and h:GetState()==Enum.HumanoidStateType.Swimming then h.WalkSpeed=S.swimVal end end end
    -- Fly
    if S.flyOn then
        if not flyBV then StartFly() end
        local c=LocalPlayer.Character
        if c and c.PrimaryPart then
            MobileFlyPanel.Visible=true
            local dir=Vector3.new(0,0,0)
            -- PC keys
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end
            -- Mobile buttons
            if flyKeys.W then dir=dir+Camera.CFrame.LookVector end
            if flyKeys.S then dir=dir-Camera.CFrame.LookVector end
            if flyKeys.A then dir=dir-Camera.CFrame.RightVector end
            if flyKeys.D then dir=dir+Camera.CFrame.RightVector end
            if flyKeys.UP then dir=dir+Vector3.new(0,1,0) end
            if flyKeys.DOWN then dir=dir-Vector3.new(0,1,0) end
            flyBV.Velocity=dir.Magnitude>0 and dir.Unit*S.flyVal or Vector3.new(0,0,0)
            flyBG.CFrame=Camera.CFrame
        end
    else
        if flyBV then StopFly() end
        MobileFlyPanel.Visible=false
    end
    -- Anti-Knockback
    if S.antiKBOn then local c=LocalPlayer.Character; if c and c.PrimaryPart then local v=c.PrimaryPart.Velocity; c.PrimaryPart.Velocity=Vector3.new(v.X*0.3,v.Y,v.Z*0.3) end end
end)

-- ================================================
-- LOGO ANIMATION
-- ================================================
local logoAngle=0
RunService.RenderStepped:Connect(function(dt) logoAngle=(logoAngle+dt*45)%360; LogoGrad.Rotation=logoAngle end)

-- ================================================
-- OPEN ANIMATION
-- ================================================
Main.Size=UDim2.new(0,0,0,0); Main.Position=UDim2.new(0.5,0,0.5,0)
Tween(Main,{Size=UDim2.new(0,GUI_W,0,GUI_H),Position=UDim2.new(0.5,-GUI_W/2,0.5,-GUI_H/2)},0.55,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
task.wait(0.7); Notify("VelocityScripts","Geladen! INSERT oder Logo antippen.","success")

-- ================================================
-- INSERT KEY TOGGLE (PC)
-- ================================================
local guiVisible=true
UserInputService.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode==Enum.KeyCode.Insert then
        guiVisible=not guiVisible
        if guiVisible then Main.Visible=true; Tween(Main,{Size=UDim2.new(0,GUI_W,0,GUI_H)},0.35,Enum.EasingStyle.Back)
        else Tween(Main,{Size=UDim2.new(0,0,0,0)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In); task.wait(0.32); Main.Visible=false end
    end
end)

print("[ VelocityScripts ] Loaded. Press INSERT to toggle.")
