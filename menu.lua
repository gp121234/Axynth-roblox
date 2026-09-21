print("[Axynth] Loading...")
local ok, err = pcall(function()
local P = game:GetService("Players")
local U = game:GetService("UserInputService")
local R = game:GetService("RunService")
local L = game:GetService("Lighting")
local S = game:GetService("StarterGui")
local RS = game:GetService("ReplicatedStorage")
local CG = game:GetService("CoreGui")
local TW = game:GetService("TweenService")
local W = game:GetService("Workspace")
local LP = P.LocalPlayer
local MS = LP:GetMouse()
local CAM = W.CurrentCamera
print("[Axynth] Services OK")
local AR = RS:FindFirstChild("AdminRemote")
if not AR then AR = Instance.new("RemoteEvent") AR.Name = "AdminRemote" AR.Parent = RS end
local function sf(a, ...) local args = {...} spawn(function() wait(math.random(10,50)/1000) pcall(function() AR:FireServer(a, unpack(args)) end) end) end
local ST = {menuOpen=false,fly=false,noclip=false,clickTP=false,esp=false,spectating=nil,selectedPlayer=nil,flySpeed=50,night=false,bright=false,noFog=false,invisible=false,espList={}}
local CFG = {MenuKey=Enum.KeyCode.F4,ESPKey=Enum.KeyCode.F9,ESPColor=Color3.fromRGB(255,0,0),ESPFillAlpha=0.5}
local TH = {p=Color3.fromRGB(18,18,32),s=Color3.fromRGB(24,24,44),b=Color3.fromRGB(35,35,60),bh=Color3.fromRGB(55,55,85),t=Color3.fromRGB(210,210,230),a=Color3.fromRGB(120,120,255),g=Color3.fromRGB(80,255,120),r=Color3.fromRGB(255,80,80)}
local function tw(o,p,d) local t=TW:Create(o,TweenInfo.new(d or 0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),p) t:Play() return t end
local function mkCorner(p,r) local c=Instance.new("UICorner",p) c.CornerRadius=UDim.new(0,r or 8) return c end
local function mkStroke(p,c,w) local s=Instance.new("UIStroke",p) s.Color=c or Color3.fromRGB(60,60,90) s.Thickness=w or 1 s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border return s end
local function mkPadding(p,t,b,l,r2) local pd=Instance.new("UIPadding",p) pd.PaddingTop=UDim.new(0,t or 4) pd.PaddingBottom=UDim.new(0,b or 4) pd.PaddingLeft=UDim.new(0,l or 6) pd.PaddingRight=UDim.new(0,r2 or 6) return pd end
local function sep(p) local f=Instance.new("Frame") f.Size=UDim2.new(1,-12,0,1) f.Position=UDim2.new(0,6,0,0) f.BackgroundColor3=Color3.fromRGB(50,50,75) f.BorderSizePixel=0 f.Parent=p end
local function lbl(p,t) local l=Instance.new("TextLabel") l.Size=UDim2.new(1,-12,0,24) l.Position=UDim2.new(0,6,0,0) l.BackgroundTransparency=1 l.Text=t l.TextColor3=TH.a l.TextSize=13 l.Font=Enum.Font.GothamBold l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=p return l end
local function btn(p,t,fn)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,-12,0,34)
    b.Position=UDim2.new(0,6,0,0)
    b.BackgroundColor3=TH.b
    b.BorderSizePixel=0
    b.Text="  "..t
    b.TextColor3=TH.t
    b.TextSize=13
    b.Font=Enum.Font.GothamMedium
    b.TextXAlignment=Enum.TextXAlignment.Left
    b.Parent=p
    mkCorner(b,6)
    mkStroke(b,Color3.fromRGB(60,60,90),1)
    b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=TH.bh,TextColor3=Color3.new(1,1,1)},0.15) end)
    b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=TH.b,TextColor3=TH.t},0.15) end)
    b.MouseButton1Click:Connect(function()
        tw(b,{BackgroundColor3=TH.a},0.08)
        wait(0.08)
        tw(b,{BackgroundColor3=TH.bh},0.1)
        pcall(fn)
    end)
    return b
end
local function tog(p,t,gf,fn)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,-12,0,34)
    b.Position=UDim2.new(0,6,0,0)
    b.BackgroundColor3=TH.b
    b.BorderSizePixel=0
    local st=gf()
    b.Text="  "..t..": "..(st and "ON" or "OFF")
    b.TextColor3=st and TH.g or TH.t
    b.TextSize=13
    b.Font=Enum.Font.GothamMedium
    b.TextXAlignment=Enum.TextXAlignment.Left
    b.Parent=p
    mkCorner(b,6)
    mkStroke(b,st and TH.g or Color3.fromRGB(60,60,90),1)
    b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=TH.bh},0.15) end)
    b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=TH.b},0.15) end)
    b.MouseButton1Click:Connect(function()
        tw(b,{BackgroundColor3=TH.a},0.08)
        wait(0.08)
        fn()
        local s=gf()
        tw(b,{BackgroundColor3=s and Color3.fromRGB(30,60,30) or TH.b},0.15)
        b.Text="  "..t..": "..(s and "ON" or "OFF")
        b.TextColor3=s and TH.g or TH.t
        pcall(function() b.UIStroke.Color = s and TH.g or Color3.fromRGB(60,60,90) end)
    end)
    return b
end
local function ntf(t,x,d) pcall(function() S:SetCore("SendNotification",{Title=t,Text=x,Duration=d or 3}) end) end
print("[Axynth] Helpers OK")
local SG=Instance.new("ScreenGui")
SG.Name="AxynthMenu"
SG.ResetOnSpawn=false
SG.DisplayOrder=1
pcall(function() SG.Parent=CG end)
if not SG.Parent then SG.Parent=LP:WaitForChild("PlayerGui") end
local MF=Instance.new("Frame")
MF.Size=UDim2.new(0,520,0,480)
MF.Position=UDim2.new(0.5,-260,0.5,-240)
MF.BackgroundColor3=TH.p
MF.BackgroundTransparency=0.02
MF.BorderSizePixel=0
MF.Active=true
MF.Draggable=true
MF.Visible=false
MF.Parent=SG
MF.ClipsDescendants=true
mkCorner(MF,12)
mkStroke(MF,TH.a,2)
tw(MF,{BackgroundTransparency=0},0.3)
local TB=Instance.new("Frame")
TB.Size=UDim2.new(1,0,0,40)
TB.BackgroundColor3=TH.s
TB.BorderSizePixel=0
TB.Parent=MF
mkCorner(TB,12)
local TL=Instance.new("TextLabel")
TL.Size=UDim2.new(1,-50,1,0)
TL.Position=UDim2.new(0,16,0,0)
TL.BackgroundTransparency=1
TL.Text="AXYNTH"
TL.TextColor3=TH.a
TL.TextSize=18
TL.Font=Enum.Font.GothamBlack
TL.TextXAlignment=Enum.TextXAlignment.Left
TL.Parent=TB
local XBtn=Instance.new("TextButton")
XBtn.Size=UDim2.new(0,32,0,32)
XBtn.Position=UDim2.new(1,-38,0,4)
XBtn.BackgroundTransparency=1
XBtn.Text="X"
XBtn.TextColor3=TH.r
XBtn.TextSize=20
XBtn.Font=Enum.Font.GothamBold
XBtn.Parent=TB
XBtn.MouseEnter:Connect(function() tw(XBtn,{TextColor3=Color3.new(1,1,1)},0.15) end)
XBtn.MouseLeave:Connect(function() tw(XBtn,{TextColor3=TH.r},0.15) end)
XBtn.MouseButton1Click:Connect(function() ST.menuOpen=false tw(MF,{Position=UDim2.new(0.5,-260,0.5,-240),BackgroundTransparency=1},0.2) wait(0.2) MF.Visible=false MF.Position=UDim2.new(0.5,-260,0.5,-240) MF.BackgroundTransparency=0.02 end)
local CFB=Instance.new("Frame")
CFB.Size=UDim2.new(1,0,0,38)
CFB.Position=UDim2.new(0,0,0,40)
CFB.BackgroundColor3=Color3.fromRGB(20,20,36)
CFB.BorderSizePixel=0
CFB.Parent=MF
print("[Axynth] GUI OK")
local tabs={}
local tF={}
local tNames={{"home","Home"},{"world","World"},{"plr","Players"},{"fun","Fun+Troll"},{"misc","Misc"},{"set","Settings"}}
for i,n in pairs(tNames) do
    local f=Instance.new("TextButton")
    f.Size=UDim2.new(0,78,0,30)
    f.Position=UDim2.new(0,(i-1)*82+4,0,4)
    f.BackgroundColor3=TH.p
    f.BorderSizePixel=0
    f.Text=n[2]
    f.TextColor3=TH.t
    f.TextSize=10
    f.Font=Enum.Font.GothamBold
    f.Parent=CFB
    mkCorner(f,6)
    local fr=Instance.new("ScrollingFrame")
    fr.Size=UDim2.new(1,-16,1,-90)
    fr.Position=UDim2.new(0,8,0,84)
    fr.BackgroundTransparency=1
    fr.BorderSizePixel=0
    fr.ScrollBarThickness=3
    fr.ScrollBarImageColor3=TH.a
    fr.CanvasSize=UDim2.new(0,0,0,0)
    fr.Visible=false
    fr.Parent=MF
    fr.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local layout=Instance.new("UIListLayout",fr)
    layout.Padding=UDim.new(0,4)
    layout.SortOrder=Enum.SortOrder.LayoutOrder
    mkPadding(fr,4,4,2,2)
    tabs[n[1]]={btn=f,frame=fr}
    tF[n[1]]=fr
    f.MouseButton1Click:Connect(function()
        for _,v in pairs(tabs) do v.frame.Visible=false v.btn.BackgroundColor3=TH.p v.btn.TextColor3=TH.t end
        fr.Visible=true
        tw(f,{BackgroundColor3=TH.a,TextColor3=Color3.new(1,1,1)},0.2)
    end)
end
tabs["home"].frame.Visible=true
tw(tabs["home"].btn,{BackgroundColor3=TH.a,TextColor3=Color3.new(1,1,1)},0.2)
print("[Axynth] Tabs OK")
local tH=tF["home"]
lbl(tH,">> SPEED")
btn(tH,"Speed 100",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=100 end end end)
btn(tH,"Speed 250",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=250 end end end)
btn(tH,"Speed 500",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=500 end end end)
btn(tH,"Reset Speed",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=16 end end end)
sep(tH)
lbl(tH,">> JUMP")
btn(tH,"Jump 100",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower=true h.JumpPower=100 end end end)
btn(tH,"Jump 300",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower=true h.JumpPower=300 end end end)
btn(tH,"Jump 500",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower=true h.JumpPower=500 end end end)
btn(tH,"Reset Jump",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower=true h.JumpPower=50 end end end)
sep(tH)
lbl(tH,">> FLY + NOCLIP")
tog(tH,"Fly [F7]",function() return ST.fly end,function() ST.fly=not ST.fly if not ST.fly and LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.PlatformStand=false end end end)
tog(tH,"Noclip [F5]",function() return ST.noclip end,function() ST.noclip=not ST.noclip end)
tog(tH,"Free Cam [F8]",function() return ST.freeCam end,function()
    ST.freeCam=not ST.freeCam
    if ST.freeCam then
        ST.freeCamPos=CAM.CFrame
        ST.freeCamVel=Vector3.new(0,0,0)
        CAM.CameraType=Enum.CameraType.Scriptable
        ntf("FreeCam","ON - WASD + Mouse")
    else
        CAM.CameraType=Enum.CameraType.Custom
        if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h end end
        ntf("FreeCam","OFF")
    end
end)
sep(tH)
lbl(tH,">> TELEPORT")
tog(tH,"Click TP [F6]",function() return ST.clickTP end,function() ST.clickTP=not ST.clickTP ntf("ClickTP",ST.clickTP and "ON" or "OFF") end)
btn(tH,"TP Cursor",function() if LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h and MS.Hit then h.CFrame=CFrame.new(MS.Hit.Position+Vector3.new(0,3,0)) end end end)
btn(tH,"TP Forward",function() if LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h then h.CFrame=h.CFrame+CAM.CFrame.LookVector*100 end end end)
btn(tH,"TP Up",function() if LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h then h.CFrame=h.CFrame+Vector3.new(0,50,0) end end end)
btn(tH,"TP Down",function() if LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h then h.CFrame=h.CFrame+Vector3.new(0,-50,0) end end end)
local tW=tF["world"]
lbl(tW,">> WORLD")
tog(tW,"Night",function() return ST.night end,function() ST.night=not ST.night if ST.night then L.ClockTime=0 else L.ClockTime=14 end end)
tog(tW,"Fullbright",function() return ST.bright end,function() ST.bright=not ST.bright if ST.bright then L.Brightness=2 L.GlobalShadows=false else L.Brightness=1 L.GlobalShadows=true end end)
tog(tW,"No Fog",function() return ST.noFog end,function() ST.noFog=not ST.noFog if ST.noFog then L.FogEnd=999999 else L.FogEnd=100000 end end)
sep(tW)
lbl(tW,">> LIGHTING")
btn(tW,"Brightness +1",function() L.Brightness=L.Brightness+1 end)
btn(tW,"Brightness -1",function() L.Brightness=math.max(0,L.Brightness-1) end)
btn(tW,"Reset Lighting",function() L.Brightness=1 L.GlobalShadows=true L.FogEnd=100000 L.ClockTime=14 end)
local tP=tF["plr"]
lbl(tP,">> SELECT PLAYER")
local pDropBtn=Instance.new("TextButton")
pDropBtn.Size=UDim2.new(1,-12,0,34)
pDropBtn.Position=UDim2.new(0,6,0,0)
pDropBtn.BackgroundColor3=TH.b
pDropBtn.BorderSizePixel=0
pDropBtn.Text="  Click to select..."
pDropBtn.TextColor3=TH.t
pDropBtn.TextSize=13
pDropBtn.Font=Enum.Font.GothamMedium
pDropBtn.TextXAlignment=Enum.TextXAlignment.Left
pDropBtn.Parent=tP
mkCorner(pDropBtn,6)
mkStroke(pDropBtn,TH.a,1)
local pDropOpen=false local pDropdown=nil
pDropBtn.MouseButton1Click:Connect(function()
    pDropOpen=not pDropOpen
    if pDropOpen then
        if pDropdown then pDropdown:Destroy() end
        pDropdown=Instance.new("ScrollingFrame")
        pDropdown.Size=UDim2.new(1,-12,0,140)
        pDropdown.Position=UDim2.new(0,6,0,38)
        pDropdown.BackgroundColor3=TH.s
        pDropdown.BorderSizePixel=0
        pDropdown.ScrollBarThickness=3
        pDropdown.ScrollBarImageColor3=TH.a
        pDropdown.Parent=tP
        mkCorner(pDropdown,6)
        mkStroke(pDropdown,TH.a,1)
        Instance.new("UIListLayout",pDropdown).Padding=UDim.new(0,2)
        mkPadding(pDropdown,2,2,4,4)
        local pl=P:GetPlayers()
        pDropdown.CanvasSize=UDim2.new(0,0,0,#pl*28)
        for _,pp in pairs(pl) do
            if pp~=LP then
                local o=Instance.new("TextButton")
                o.Size=UDim2.new(1,-8,0,26)
                o.BackgroundColor3=TH.p
                o.BorderSizePixel=0
                o.Text="  "..pp.DisplayName
                o.TextColor3=TH.t
                o.TextXAlignment=Enum.TextXAlignment.Left
                o.TextSize=12
                o.Font=Enum.Font.Gotham
                o.Parent=pDropdown
                mkCorner(o,4)
                o.MouseEnter:Connect(function() tw(o,{BackgroundColor3=TH.bh},0.1) end)
                o.MouseLeave:Connect(function() tw(o,{BackgroundColor3=TH.p},0.1) end)
                o.MouseButton1Click:Connect(function()
                    ST.selectedPlayer=pp
                    pDropBtn.Text="  > "..pp.DisplayName
                    pDropOpen=false
                    if pDropdown then pDropdown:Destroy() pDropdown=nil end
                end)
            end
        end
    else
        if pDropdown then pDropdown:Destroy() pDropdown=nil end
    end
end)
btn(tP,"Refresh Players",function() pDropBtn.Text="  Click to select..." ST.selectedPlayer=nil end)
sep(tP)
lbl(tP,">> PLAYER ACTIONS")
btn(tP,"Goto Player",function() if ST.selectedPlayer and ST.selectedPlayer.Character and LP.Character then local t2=ST.selectedPlayer.Character:FindFirstChild("HumanoidRootPart") local m=LP.Character:FindFirstChild("HumanoidRootPart") if t2 and m then m.CFrame=t2.CFrame+Vector3.new(3,0,0) end end end)
btn(tP,"Bring Player",function() if ST.selectedPlayer then sf("bring",ST.selectedPlayer.Name) end end)
btn(tP,"Freeze Player",function() if ST.selectedPlayer then sf("freeze",ST.selectedPlayer.Name) end end)
btn(tP,"Unfreeze Player",function() if ST.selectedPlayer then sf("unfreeze",ST.selectedPlayer.Name) end end)
btn(tP,"Kill Player",function() if ST.selectedPlayer then sf("kill",ST.selectedPlayer.Name) end end)
btn(tP,"Heal Player",function() if ST.selectedPlayer then sf("heal",ST.selectedPlayer.Name) end end)
sep(tP)
lbl(tP,">> SPECTATE + ESP")
btn(tP,"Spectate",function() if ST.selectedPlayer and ST.selectedPlayer.Character then local h=ST.selectedPlayer.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h CAM.CameraType=Enum.CameraType.Custom ST.spectating=ST.selectedPlayer end end end)
btn(tP,"Stop Spectate",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h end CAM.CameraType=Enum.CameraType.Custom ST.spectating=nil end end)
tog(tP,"ESP [F9]",function() return ST.esp end,function()
    ST.esp=not ST.esp
    if ST.esp then
        for _,pp in pairs(P:GetPlayers()) do
            if pp~=LP and pp.Character and not pp.Character:FindFirstChild("AxESP") then
                local hl=Instance.new("Highlight")
                hl.Name="AxESP"
                hl.FillColor=CFG.ESPColor
                hl.FillTransparency=CFG.ESPFillAlpha
                hl.OutlineColor=Color3.new(1,1,1)
                hl.OutlineTransparency=0
                hl.Parent=pp.Character
                ST.espList[pp.UserId]=hl
            end
        end
    else
        for id,hl in pairs(ST.espList) do
            if hl and hl.Parent then hl:Destroy() end
            ST.espList[id]=nil
        end
    end
end)
local tF2=tF["fun"]
lbl(tF2,">> TROLL ALL")
btn(tF2,"Fire All",function() sf("fire",100) end)
btn(tF2,"Sparkle All",function() sf("sparkle",100) end)
btn(tF2,"Smoke All",function() sf("smoke",100) end)
btn(tF2,"Remove FX",function() sf("removefx",100) end)
btn(tF2,"Big Head All",function() sf("bighead",100) end)
btn(tF2,"Small Head All",function() sf("smallhead",100) end)
btn(tF2,"Spin All",function() sf("spin",100) end)
btn(tF2,"Stop Spin",function() sf("unspin",100) end)
sep(tF2)
lbl(tF2,">> TROLL ACTIONS")
btn(tF2,"Stomp All",function() sf("stomp",100) end)
btn(tF2,"Trip All",function() sf("trip",100) end)
btn(tF2,"Vibrate All",function() sf("vibrate",100) end)
btn(tF2,"Fling All",function() sf("fling",100) end)
btn(tF2,"Ragdoll All",function() sf("ragdoll",100) end)
btn(tF2,"Bang All",function() sf("bang",100) end)
btn(tF2,"Dance All",function() sf("dance",100) end)
btn(tF2,"Sleep All",function() sf("sleep",100) end)
btn(tF2,"Invisible All",function() sf("invisible",100) end)
btn(tF2,"Visible All",function() sf("visible",100) end)
sep(tF2)
lbl(tF2,">> SELF FUN")
btn(tF2,"Self Fire",function() sf("fire",1) end)
btn(tF2,"Self Sparkle",function() sf("sparkle",1) end)
btn(tF2,"Self Dance",function() sf("dance",1) end)
btn(tF2,"Self Bang",function() sf("bang",1) end)
btn(tF2,"Self Sleep",function() sf("sleep",1) end)
btn(tF2,"Self Spin",function() sf("spin",1) end)
btn(tF2,"Self Stop Spin",function() sf("unspin",1) end)
local tMi=tF["misc"]
lbl(tMi,">> MISC")
btn(tMi,"Reset Character",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=0 end end end)
btn(tMi,"God Mode",function() sf("godmode",1) end)
btn(tMi,"Anti-AFK",function() pcall(function() LP.Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Running) end) end)
btn(tMi,"Third Person",function() pcall(function() LP.CameraMinZoomDistance=10 LP.CameraMaxZoomDistance=10 end) end)
btn(tMi,"First Person",function() pcall(function() LP.CameraMinZoomDistance=0.5 LP.CameraMaxZoomDistance=0.5 end) end)
sep(tMi)
lbl(tMi,">> SERVER ACTIONS")
btn(tMi,"Kill All",function() sf("kill",100) end)
btn(tMi,"Heal All",function() sf("heal",100) end)
btn(tMi,"Freeze All",function() sf("freeze",100) end)
btn(tMi,"Unfreeze All",function() sf("unfreeze",100) end)
btn(tMi,"Explode All",function() sf("explode",100) end)
local tSe=tF["set"]
lbl(tSe,">> THEME")
btn(tSe,"Dark Purple",function() TH.p=Color3.fromRGB(18,18,32) TH.s=Color3.fromRGB(24,24,44) TH.b=Color3.fromRGB(35,35,60) TH.bh=Color3.fromRGB(55,55,85) TH.a=Color3.fromRGB(120,120,255) MF.BackgroundColor3=TH.p end)
btn(tSe,"Dark Red",function() TH.p=Color3.fromRGB(28,12,12) TH.s=Color3.fromRGB(38,16,16) TH.b=Color3.fromRGB(55,25,25) TH.bh=Color3.fromRGB(75,35,35) TH.a=Color3.fromRGB(255,80,80) MF.BackgroundColor3=TH.p end)
btn(tSe,"Dark Green",function() TH.p=Color3.fromRGB(12,24,12) TH.s=Color3.fromRGB(16,32,16) TH.b=Color3.fromRGB(25,50,25) TH.bh=Color3.fromRGB(35,70,35) TH.a=Color3.fromRGB(80,255,120) MF.BackgroundColor3=TH.p end)
btn(tSe,"Midnight",function() TH.p=Color3.fromRGB(8,8,20) TH.s=Color3.fromRGB(12,12,28) TH.b=Color3.fromRGB(20,20,40) TH.bh=Color3.fromRGB(30,30,55) TH.a=Color3.fromRGB(100,180,255) MF.BackgroundColor3=TH.p end)
sep(tSe)
lbl(tSe,">> HOTKEYS")
btn(tSe,"Show All Keys",function() ntf("F4=Menu F5=Noclip F6=ClickTP","F7=Fly F8=FreeCam F9=ESP") end)
print("[Axynth] All tabs OK")
U.InputBegan:Connect(function(inp,gpe)
    if gpe then return end
    if inp.KeyCode==CFG.MenuKey then
        ST.menuOpen=not ST.menuOpen
        if ST.menuOpen then
            MF.Visible=true
            MF.BackgroundTransparency=1
            tw(MF,{BackgroundTransparency=0.02},0.25)
        else
            tw(MF,{BackgroundTransparency=1},0.2)
            wait(0.2)
            MF.Visible=false
            MF.BackgroundTransparency=0.02
        end
    elseif inp.KeyCode==Enum.KeyCode.F5 then ST.noclip=not ST.noclip ntf("Noclip",ST.noclip and "ON" or "OFF")
    elseif inp.KeyCode==Enum.KeyCode.F6 then ST.clickTP=not ST.clickTP ntf("ClickTP",ST.clickTP and "ON" or "OFF")
    elseif inp.KeyCode==Enum.KeyCode.F7 then ST.fly=not ST.fly if not ST.fly and LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.PlatformStand=false end end ntf("Fly",ST.fly and "ON" or "OFF")
    elseif inp.KeyCode==Enum.KeyCode.F8 then
        ST.freeCam=not ST.freeCam
        if ST.freeCam then
            ST.freeCamPos=CAM.CFrame
            ST.freeCamVel=Vector3.new(0,0,0)
            CAM.CameraType=Enum.CameraType.Scriptable
ntf("FreeCam","ON - WASD + Shift")
        else
            CAM.CameraType=Enum.CameraType.Custom
            if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h end end
            ntf("FreeCam","OFF")
        end
    elseif inp.KeyCode==CFG.ESPKey then
        ST.esp=not ST.esp
        if ST.esp then for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and not pp.Character:FindFirstChild("AxESP") then local hl=Instance.new("Highlight") hl.Name="AxESP" hl.FillColor=CFG.ESPColor hl.FillTransparency=CFG.ESPFillAlpha hl.OutlineColor=Color3.new(1,1,1) hl.OutlineTransparency=0 hl.Parent=pp.Character ST.espList[pp.UserId]=hl end end else for id,hl in pairs(ST.espList) do if hl and hl.Parent then hl:Destroy() end ST.espList[id]=nil end end ntf("ESP",ST.esp and "ON" or "OFF")
    end
end)
MS.Button1Down:Connect(function() if ST.clickTP and LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h and MS.Hit then h.CFrame=CFrame.new(MS.Hit.Position+Vector3.new(0,3,0)) end end end)
print("[Axynth] Events OK")
R.RenderStepped:Connect(function()
    if ST.fly and LP.Character then
        local h=LP.Character:FindFirstChild("HumanoidRootPart")
        if h then
            h.Velocity=Vector3.new(0,0,0)
            h.RotVelocity=Vector3.new(0,0,0)
            local dir=Vector3.new(0,0,0)
            if U:IsKeyDown(Enum.KeyCode.W) then dir=dir+CAM.CFrame.LookVector end
            if U:IsKeyDown(Enum.KeyCode.S) then dir=dir-CAM.CFrame.LookVector end
            if U:IsKeyDown(Enum.KeyCode.A) then dir=dir-CAM.CFrame.RightVector end
            if U:IsKeyDown(Enum.KeyCode.D) then dir=dir+CAM.CFrame.RightVector end
            if U:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
            if U:IsKeyDown(Enum.KeyCode.LeftShift) then dir=dir-Vector3.new(0,1,0) end
            if dir.Magnitude>0 then dir=dir.Unit end
            h.CFrame=h.CFrame+dir*ST.flySpeed*R.RenderStepped:Wait()
        end
    end
    if ST.noclip and LP.Character then
        for _,p2 in pairs(LP.Character:GetDescendants()) do
            if p2:IsA("BasePart") then p2.CanCollide=false end
        end
    end
    if ST.freeCam then
        CAM.CameraType=Enum.CameraType.Scriptable
        local dir=Vector3.new(0,0,0)
        local sp=1
        if U:IsKeyDown(Enum.KeyCode.LeftShift) then sp=2 end
        if U:IsKeyDown(Enum.KeyCode.W) then dir=dir+CAM.CFrame.LookVector end
        if U:IsKeyDown(Enum.KeyCode.S) then dir=dir-CAM.CFrame.LookVector end
        if U:IsKeyDown(Enum.KeyCode.A) then dir=dir-CAM.CFrame.RightVector end
        if U:IsKeyDown(Enum.KeyCode.D) then dir=dir+CAM.CFrame.RightVector end
        CAM.CFrame=CAM.CFrame+dir*sp
    end
end)
P.PlayerAdded:Connect(function(pp)
    pp.CharacterAdded:Connect(function(ch)
        wait(1)
        if ST.esp and pp~=LP then
            local hl=Instance.new("Highlight")
            hl.Name="AxESP"
            hl.FillColor=CFG.ESPColor
            hl.FillTransparency=CFG.ESPFillAlpha
            hl.OutlineColor=Color3.new(1,1,1)
            hl.OutlineTransparency=0
            hl.Parent=ch
            ST.espList[pp.UserId]=hl
        end
    end)
end)
P.PlayerRemoving:Connect(function(pp)
    if ST.espList[pp.UserId] then ST.espList[pp.UserId]:Destroy() ST.espList[pp.UserId]=nil end
end)
print("[Axynth] MENU LOADED! Press F4!")
end)
if not ok then print("[Axynth] ERROR: "..tostring(err)) end
