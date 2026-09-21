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
local lastFire=0
local actionCount=0
local actionReset=tick()
local function sf(a, ...) local args = {...} spawn(function() local now=tick() if now-lastFire<0.5 then wait(math.random(80,200)/1000) end lastFire=tick()+math.random(50,150)/1000 wait(math.random(50,200)/1000) pcall(function() AR:FireServer(a, unpack(args)) end) end) end
local lastAction=0
local function cd()
    local now=tick()
    if now-actionReset>60 then actionCount=0 actionReset=now end
    if actionCount>=8 then ntf("Rate Limit","Slow down - wait a bit") return false end
    if now-lastAction<2 then ntf("Cooldown","Wait "..string.format("%.1f",2-(now-lastAction)).."s") return false end
    lastAction=now actionCount=actionCount+1 return true
end
local ST = {menuOpen=false,fly=false,noclip=false,clickTP=false,esp=false,spectating=nil,selectedPlayer=nil,flySpeed=50,night=false,bright=false,noFog=false,invisible=false,espList={},serverLag=false}
local CFG = {ESPColor=Color3.fromRGB(255,0,0),ESPFillAlpha=0.5}
local TH = {p=Color3.fromRGB(18,18,32),s=Color3.fromRGB(24,24,44),b=Color3.fromRGB(35,35,60),bh=Color3.fromRGB(55,55,85),t=Color3.fromRGB(210,210,230),a=Color3.fromRGB(120,120,255),g=Color3.fromRGB(80,255,120),r=Color3.fromRGB(255,80,80)}
local KB = {}
local waitingForKey = nil
local function tw(o,p,d) local t=TW:Create(o,TweenInfo.new(d or 0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),p) t:Play() return t end
local function mkCorner(p,r) local c=Instance.new("UICorner",p) c.CornerRadius=UDim.new(0,r or 8) return c end
local function mkStroke(p,c,w) local s=Instance.new("UIStroke",p) s.Color=c or Color3.fromRGB(60,60,90) s.Thickness=w or 1 s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border return s end
local function mkPadding(p,t,b,l,r2) local pd=Instance.new("UIPadding",p) pd.PaddingTop=UDim.new(0,t or 4) pd.PaddingBottom=UDim.new(0,b or 4) pd.PaddingLeft=UDim.new(0,l or 6) pd.PaddingRight=UDim.new(0,r2 or 6) return pd end
local function sep(p) local f=Instance.new("Frame") f.Size=UDim2.new(1,-12,0,1) f.Position=UDim2.new(0,6,0,0) f.BackgroundColor3=Color3.fromRGB(50,50,75) f.BorderSizePixel=0 f.Parent=p end
local function lbl(p,t) local l=Instance.new("TextLabel") l.Size=UDim2.new(1,-12,0,24) l.Position=UDim2.new(0,6,0,0) l.BackgroundTransparency=1 l.Text=t l.TextColor3=TH.a l.TextSize=13 l.Font=Enum.Font.GothamBold l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=p return l end
local function ntf(t,x,d) pcall(function() S:SetCore("SendNotification",{Title=t,Text=x,Duration=d or 3}) end) end
local function getKeyDisplay(key)
    if not key then return "NONE" end
    local s = tostring(key)
    s = s:gsub("Enum.KeyCode.","")
    s = s:gsub("Enum.UserInputType.","")
    return s
end
local function btn(p,t,fn,id)
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
    local kbBtn=Instance.new("TextButton")
    kbBtn.Size=UDim2.new(0,40,0,22)
    kbBtn.Position=UDim2.new(1,-48,0,6)
    kbBtn.BackgroundColor3=TH.p
    kbBtn.BorderSizePixel=0
    kbBtn.Text=getKeyDisplay(KB[id])
    kbBtn.TextColor3=TH.a
    kbBtn.TextSize=9
    kbBtn.Font=Enum.Font.GothamBold
    kbBtn.Parent=b
    mkCorner(kbBtn,4)
    mkStroke(kbBtn,TH.a,1)
    kbBtn.MouseButton1Click:Connect(function()
        waitingForKey=id
        kbBtn.Text="..."
        kbBtn.TextColor3=TH.r
        ntf("Keybind","Press any key for: "..t,5)
    end)
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
local function tog(p,t,gf,fn,id)
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
    local kbBtn=Instance.new("TextButton")
    kbBtn.Size=UDim2.new(0,40,0,22)
    kbBtn.Position=UDim2.new(1,-48,0,6)
    kbBtn.BackgroundColor3=TH.p
    kbBtn.BorderSizePixel=0
    kbBtn.Text=getKeyDisplay(KB[id])
    kbBtn.TextColor3=TH.a
    kbBtn.TextSize=9
    kbBtn.Font=Enum.Font.GothamBold
    kbBtn.Parent=b
    mkCorner(kbBtn,4)
    mkStroke(kbBtn,TH.a,1)
    kbBtn.MouseButton1Click:Connect(function()
        waitingForKey=id
        kbBtn.Text="..."
        kbBtn.TextColor3=TH.r
        ntf("Keybind","Press any key for: "..t,5)
    end)
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
    b._kbBtn=kbBtn
    b._update=function()
        local s=gf()
        b.Text="  "..t..": "..(s and "ON" or "OFF")
        b.TextColor3=s and TH.g or TH.t
        pcall(function() b.UIStroke.Color = s and TH.g or Color3.fromRGB(60,60,90) end)
        kbBtn.Text=getKeyDisplay(KB[id])
    end
    return b
end
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
local tNames={{"home","Home"},{"world","World"},{"plr","Players"},{"fun","Fun+Troll"},{"exploit","Exploit"},{"set","Settings"}}
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
    fr.Size=UDim2.new(1,-16,1,-86)
    fr.Position=UDim2.new(0,8,0,82)
    fr.BackgroundTransparency=1
    fr.BorderSizePixel=0
    fr.ScrollBarThickness=4
    fr.ScrollBarImageColor3=TH.a
    fr.CanvasSize=UDim2.new(0,0,0,0)
    fr.Visible=false
    fr.Parent=MF
    fr.AutomaticCanvasSize=Enum.AutomaticSize.Y
    fr.ScrollingDirection=Enum.ScrollingDirection.Y
    fr.ElasticBehavior=Enum.ElasticBehavior.Never
    fr.TopImage="rbxasset://textures/ui/Scroll/scroll-middle.png"
    fr.BottomImage="rbxasset://textures/ui/Scroll/scroll-middle.png"
    local layout=Instance.new("UIListLayout",fr)
    layout.Padding=UDim.new(0,4)
    layout.SortOrder=Enum.SortOrder.LayoutOrder
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        fr.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+8)
    end)
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
local allToggles={}
local tH=tF["home"]
lbl(tH,">> SPEED")
btn(tH,"Speed 100",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=100 end end end,"sp100")
btn(tH,"Speed 250",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=250 end end end,"sp250")
btn(tH,"Speed 500",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=500 end end end,"sp500")
btn(tH,"Reset Speed",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=16 end end end,"sprst")
sep(tH)
lbl(tH,">> JUMP")
btn(tH,"Jump 100",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower=true h.JumpPower=100 end end end,"jp100")
btn(tH,"Jump 300",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower=true h.JumpPower=300 end end end,"jp300")
btn(tH,"Jump 500",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower=true h.JumpPower=500 end end end,"jp500")
btn(tH,"Reset Jump",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower=true h.JumpPower=50 end end end,"jprst")
sep(tH)
lbl(tH,">> FLY + NOCLIP")
local tFly=tog(tH,"Fly",function() return ST.fly end,function() ST.fly=not ST.fly if not ST.fly and LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.PlatformStand=false end end end,"fly")
table.insert(allToggles,tFly)
local tNoclip=tog(tH,"Noclip",function() return ST.noclip end,function() ST.noclip=not ST.noclip end,"noclip")
table.insert(allToggles,tNoclip)
local tFC=tog(tH,"Free Cam",function() return ST.freeCam end,function()
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
end,"freecam")
table.insert(allToggles,tFC)
sep(tH)
lbl(tH,">> TELEPORT")
local tCTP=tog(tH,"Click TP",function() return ST.clickTP end,function() ST.clickTP=not ST.clickTP ntf("ClickTP",ST.clickTP and "ON" or "OFF") end,"clicktp")
table.insert(allToggles,tCTP)
btn(tH,"TP Cursor",function() if LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h and MS.Hit then h.CFrame=CFrame.new(MS.Hit.Position+Vector3.new(0,3,0)) end end end,"tpcur")
btn(tH,"TP Forward",function() if LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h then h.CFrame=h.CFrame+CAM.CFrame.LookVector*100 end end end,"tpfwd")
btn(tH,"TP Up",function() if LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h then h.CFrame=h.CFrame+Vector3.new(0,50,0) end end end,"tpup")
btn(tH,"TP Down",function() if LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h then h.CFrame=h.CFrame+Vector3.new(0,-50,0) end end end,"tpdn")
local tW=tF["world"]
lbl(tW,">> WORLD")
local tNight=tog(tW,"Night",function() return ST.night end,function() ST.night=not ST.night if ST.night then L.ClockTime=0 else L.ClockTime=14 end end,"night")
table.insert(allToggles,tNight)
local tBright=tog(tW,"Fullbright",function() return ST.bright end,function() ST.bright=not ST.bright if ST.bright then L.Brightness=2 L.GlobalShadows=false else L.Brightness=1 L.GlobalShadows=true end end,"bright")
table.insert(allToggles,tBright)
local tFog=tog(tW,"No Fog",function() return ST.noFog end,function() ST.noFog=not ST.noFog if ST.noFog then L.FogEnd=999999 else L.FogEnd=100000 end end,"nofog")
table.insert(allToggles,tFog)
sep(tW)
lbl(tW,">> LIGHTING")
btn(tW,"Brightness +1",function() L.Brightness=L.Brightness+1 end,"brup")
btn(tW,"Brightness -1",function() L.Brightness=math.max(0,L.Brightness-1) end,"brdn")
btn(tW,"Reset Lighting",function() L.Brightness=1 L.GlobalShadows=true L.FogEnd=100000 L.ClockTime=14 end,"lgrst")
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
btn(tP,"Refresh Players",function() pDropBtn.Text="  Click to select..." ST.selectedPlayer=nil end,"plrrefresh")
sep(tP)
lbl(tP,">> PLAYER ACTIONS")
btn(tP,"Goto Player",function() if ST.selectedPlayer and ST.selectedPlayer.Character and LP.Character then local t2=ST.selectedPlayer.Character:FindFirstChild("HumanoidRootPart") local m=LP.Character:FindFirstChild("HumanoidRootPart") if t2 and m then m.CFrame=t2.CFrame+Vector3.new(3,0,0) end end end,"goto")
btn(tP,"Bring Player",function() if ST.selectedPlayer and cd() then sf("bring",ST.selectedPlayer.Name) end end,"bring")
btn(tP,"Freeze Player",function() if ST.selectedPlayer and cd() then sf("freeze",ST.selectedPlayer.Name) end end,"freeze")
btn(tP,"Unfreeze Player",function() if ST.selectedPlayer and cd() then sf("unfreeze",ST.selectedPlayer.Name) end end,"unfreeze")
btn(tP,"Kill Player",function() if ST.selectedPlayer and cd() then sf("kill",ST.selectedPlayer.Name) end end,"kill")
btn(tP,"Heal Player",function() if ST.selectedPlayer and cd() then sf("heal",ST.selectedPlayer.Name) end end,"heal")
btn(tP,"Explode Player",function() if ST.selectedPlayer and cd() then sf("explode",ST.selectedPlayer.Name) end end,"expl")
sep(tP)
lbl(tP,">> SPECTATE + ESP")
btn(tP,"Spectate",function() if ST.selectedPlayer and ST.selectedPlayer.Character then local h=ST.selectedPlayer.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h CAM.CameraType=Enum.CameraType.Custom ST.spectating=ST.selectedPlayer end end end,"spec")
btn(tP,"Stop Spectate",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h end CAM.CameraType=Enum.CameraType.Custom ST.spectating=nil end end,"stopspec")
local tESP=tog(tP,"ESP",function() return ST.esp end,function()
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
end,"esp")
table.insert(allToggles,tESP)
local tF2=tF["fun"]
lbl(tF2,">> TROLL ALL")
btn(tF2,"Fire All",function() if cd() then sf("fire",100) end end,"fire")
btn(tF2,"Sparkle All",function() if cd() then sf("sparkle",100) end end,"sparkle")
btn(tF2,"Smoke All",function() if cd() then sf("smoke",100) end end,"smoke")
btn(tF2,"Remove FX",function() if cd() then sf("removefx",100) end end,"rmfx")
btn(tF2,"Big Head All",function() if cd() then sf("bighead",100) end end,"bhead")
btn(tF2,"Small Head All",function() if cd() then sf("smallhead",100) end end,"shead")
btn(tF2,"Spin All",function() if cd() then sf("spin",100) end end,"spin")
btn(tF2,"Stop Spin",function() if cd() then sf("unspin",100) end end,"unspin")
sep(tF2)
lbl(tF2,">> TROLL ACTIONS")
btn(tF2,"Stomp All",function() if cd() then sf("stomp",100) end end,"stomp")
btn(tF2,"Trip All",function() if cd() then sf("trip",100) end end,"trip")
btn(tF2,"Vibrate All",function() if cd() then sf("vibrate",100) end end,"vibrate")
btn(tF2,"Fling All",function() if cd() then sf("fling",100) end end,"fling")
btn(tF2,"Ragdoll All",function() if cd() then sf("ragdoll",100) end end,"ragdoll")
btn(tF2,"Bang All",function() if cd() then sf("bang",100) end end,"bang")
btn(tF2,"Dance All",function() if cd() then sf("dance",100) end end,"dance")
btn(tF2,"Sleep All",function() if cd() then sf("sleep",100) end end,"sleep")
btn(tF2,"Invisible All",function() if cd() then sf("invisible",100) end end,"invis")
btn(tF2,"Visible All",function() sf("visible",100) end,"vis")
sep(tF2)
lbl(tF2,">> SELF FUN")
btn(tF2,"Self Fire",function() sf("fire",1) end,"sfire")
btn(tF2,"Self Sparkle",function() sf("sparkle",1) end,"ssparkle")
btn(tF2,"Self Dance",function() sf("dance",1) end,"sdance")
btn(tF2,"Self Bang",function() sf("bang",1) end,"sbang")
btn(tF2,"Self Sleep",function() sf("sleep",1) end,"ssleep")
btn(tF2,"Self Spin",function() sf("spin",1) end,"sspin")
btn(tF2,"Self Stop Spin",function() sf("unspin",1) end,"sunspin")
local tEx=tF["exploit"]
lbl(tEx,">> SILENT BAN / KICK")
btn(tEx,"Report Spam Target",function() if ST.selectedPlayer and cd() then for i=1,10 do spawn(function() wait(math.random(50,200)/1000) pcall(function() local r=RS:FindFirstChild("ReportPlayer") if r then r:FireServer(ST.selectedPlayer,"Exploiting","Exploiting") end end) pcall(function() local r=RS:FindFirstChild("Report") if r then r:FireServer(ST.selectedPlayer,"Exploiting") end end) pcall(function() local r=RS:FindFirstChild("AntiCheatReport") if r then r:FireServer(ST.selectedPlayer,"cheating") end end) end) end ntf("Report","Spamming reports on "..ST.selectedPlayer.Name) end end,"repspam")
btn(tEx,"Vote Kick Target",function() if ST.selectedPlayer and cd() then pcall(function() local r=RS:FindFirstChild("VoteKick") if r then r:FireServer(ST.selectedPlayer) end end) pcall(function() local r=RS:FindFirstChild("Votekick") if r then r:FireServer(ST.selectedPlayer.Name) end end) pcall(function() local r=RS:FindFirstChild("Kick") if r then r:FireServer(ST.selectedPlayer.Name,"Exploiting") end end) ntf("VoteKick","Trying to kick "..ST.selectedPlayer.Name) end end,"votekick")
btn(tEx,"Trigger Anticheat Target",function() if ST.selectedPlayer and cd() then for i=1,5 do spawn(function() wait(math.random(100,500)/1000) pcall(function() for _,r in pairs(RS:GetDescendants()) do if r:IsA("RemoteEvent") and r.Name:lower():find("anti") then r:FireServer(ST.selectedPlayer,"flag") end end end) end) end ntf("Anticheat","Triggering on "..ST.selectedPlayer.Name) end end,"triganti")
btn(tEx,"Spam Reports All",function() if cd() then for i=1,20 do spawn(function() wait(math.random(100,400)/1000) pcall(function() local r=RS:FindFirstChild("ReportPlayer") if r then r:FireServer(P:GetChildren()[math.random(2,#P:GetChildren())],"Exploiting") end end) end) end ntf("Reports","Spamming all reports") end end,"repall")
sep(tEx)
lbl(tEx,">> SERVER LAG / FREEZE")
local tLag=tog(tEx,"Server Lag",function() return ST.serverLag end,function()
    ST.serverLag=not ST.serverLag
    if ST.serverLag then
        ntf("Server Lag","ON - spamming remotes")
        spawn(function()
            while ST.serverLag do
                pcall(function()
                    for _,r in pairs(RS:GetDescendants()) do
                        if r:IsA("RemoteEvent") then
                            pcall(function() r:FireServer() end)
                            pcall(function() r:FireServer("lag") end)
                            pcall(function() r:FireServer("") end)
                        end
                    end
                end)
                wait(math.random(50,200)/1000)
            end
        end)
    else
        ntf("Server Lag","OFF")
    end
end,"svlag")
table.insert(allToggles,tLag)
btn(tEx,"Spam All Remotes",function() if cd() then spawn(function() for i=1,50 do pcall(function() for _,r in pairs(RS:GetDescendants()) do if r:IsA("RemoteEvent") then pcall(function() r:FireServer(LP) end) end end end) wait(math.random(10,50)/1000) end end) ntf("Spam","Fired 50 rounds of remotes") end end,"spamrem")
btn(tEx,"Touch All Parts",function() if cd() and LP.Character then local hrp=LP.Character:FindFirstChild("HumanoidRootPart") if hrp then spawn(function() for _,obj in pairs(W:GetDescendants()) do if obj:IsA("BasePart") and (obj.Position-hrp.Position).Magnitude<100 then pcall(function() firetouchinterest(hrp,obj,0) end) pcall(function() firetouchinterest(hrp,obj,1) end) wait(math.random(5,30)/1000) end end end) ntf("Touch","Touching nearby parts") end end end,"touchall")
btn(tEx,"Fire All ClickDetectors",function() if cd() then spawn(function() for _,obj in pairs(W:GetDescendants()) do if obj:IsA("ClickDetector") then pcall(function() obj.MouseClick:Fire() end) wait(math.random(10,50)/1000) end end end) ntf("ClickDetectors","Firing all click detectors") end end,"clickdet")
sep(tEx)
lbl(tEx,">> JOB / MONEY EXPLOIT")
btn(tEx,"Spam Job Selection",function() if cd() then spawn(function() for i=1,30 do pcall(function() for _,r in pairs(RS:GetDescendants()) do if r:IsA("RemoteEvent") and (r.Name:lower():find("job") or r.Name:lower():find("work") or r.Name:lower():find("select")) then pcall(function() r:FireServer("police") end) pcall(function() r:FireServer("medic") end) pcall(function() r:FireServer("mechanic") end) end end end) wait(math.random(50,200)/1000) end end) ntf("Jobs","Spamming job selection") end end,"spamjob")
btn(tEx,"Spam Money Remotes",function() if cd() then spawn(function() for i=1,30 do pcall(function() for _,r in pairs(RS:GetDescendants()) do if r:IsA("RemoteEvent") and (r.Name:lower():find("money") or r.Name:lower():find("bank") or r.Name:lower():find("pay") or r.Name:lower():find("cash")) then pcall(function() r:FireServer(999999) end) pcall(function() r:FireServer("deposit",999999) end) pcall(function() r:FireServer("withdraw",999999) end) end end end) wait(math.random(50,200)/1000) end end) ntf("Money","Spamming money remotes") end end,"spammoney")
btn(tEx,"Spam All Game Remotes",function() if cd() then spawn(function() local count=0 for _,r in pairs(RS:GetDescendants()) do if r:IsA("RemoteEvent") then for i=1,5 do spawn(function() wait(math.random(10,100)/1000) pcall(function() r:FireServer() end) pcall(function() r:FireServer("x") end) pcall(function() r:FireServer(1) end) pcall(function() r:FireServer(true) end) pcall(function() r:FireServer({}) end) end) end count=count+1 end end ntf("Remotes","Fired "..count.." remotes x5") end) end end,"spamallrem")
btn(tEx,"Open Remote Scanner",function() if cd() then
    if _G.RemoteScanner then pcall(function() _G.RemoteScanner:Destroy() end) end
    local SG2=Instance.new("ScreenGui")
    SG2.Name="RemoteScanner"
    SG2.ResetOnSpawn=false
    SG2.DisplayOrder=2
    pcall(function() SG2.Parent=CG end)
    if not SG2.Parent then SG2.Parent=LP:WaitForChild("PlayerGui") end
    _G.RemoteScanner=SG2
    local PF=Instance.new("Frame")
    PF.Size=UDim2.new(0,600,0,450)
    PF.Position=UDim2.new(0.5,-300,0.5,-225)
    PF.BackgroundColor3=TH.p
    PF.BorderSizePixel=0
    PF.Active=true
    PF.Draggable=true
    PF.Parent=SG2
    mkCorner(PF,12)
    mkStroke(PF,TH.a,2)
    local PT=Instance.new("Frame")
    PT.Size=UDim2.new(1,0,0,36)
    PT.BackgroundColor3=TH.s
    PT.BorderSizePixel=0
    PT.Parent=PF
    mkCorner(PT,12)
    local PTL=Instance.new("TextLabel")
    PTL.Size=UDim2.new(1,-80,1,0)
    PTL.Position=UDim2.new(0,12,0,0)
    PTL.BackgroundTransparency=1
    PTL.Text="REMOTE SCANNER"
    PTL.TextColor3=TH.a
    PTL.TextSize=14
    PTL.Font=Enum.Font.GothamBlack
    PTL.TextXAlignment=Enum.TextXAlignment.Left
    PTL.Parent=PT
    local PX=Instance.new("TextButton")
    PX.Size=UDim2.new(0,28,0,28)
    PX.Position=UDim2.new(1,-32,0,4)
    PX.BackgroundTransparency=1
    PX.Text="X"
    PX.TextColor3=TH.r
    PX.TextSize=18
    PX.Font=Enum.Font.GothamBold
    PX.Parent=PT
    PX.MouseButton1Click:Connect(function() SG2:Destroy() _G.RemoteScanner=nil end)
    local SC=Instance.new("TextBox")
    SC.Size=UDim2.new(1,-16,0,28)
    SC.Position=UDim2.new(0,8,0,42)
    SC.BackgroundColor3=TH.b
    SC.BorderSizePixel=0
    SC.PlaceholderText="Search remotes..."
    SC.PlaceholderColor3=Color3.fromRGB(100,100,120)
    SC.Text=""
    SC.TextColor3=TH.t
    SC.TextSize=12
    SC.Font=Enum.Font.Gotham
    SC.ClearTextOnFocus=false
    SC.Parent=PF
    mkCorner(SC,6)
    mkStroke(SC,TH.a,1)
    local SF=Instance.new("ScrollingFrame")
    SF.Size=UDim2.new(1,-16,1,-80)
    SF.Position=UDim2.new(0,8,0,76)
    SF.BackgroundTransparency=1
    SF.BorderSizePixel=0
    SF.ScrollBarThickness=4
    SF.ScrollBarImageColor3=TH.a
    SF.CanvasSize=UDim2.new(0,0,0,0)
    SF.Parent=PF
    SF.AutomaticCanvasSize=Enum.AutomaticSize.Y
    SF.ScrollingDirection=Enum.ScrollingDirection.Y
    SF.ElasticBehavior=Enum.ElasticBehavior.Never
    local SL=Instance.new("UIListLayout",SF)
    SL.Padding=UDim.new(0,3)
    SL.SortOrder=Enum.SortOrder.LayoutOrder
    SL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SF.CanvasSize=UDim2.new(0,0,0,SL.AbsoluteContentSize.Y+8)
    end)
    mkPadding(SF,4,4,2,2)
    local function loadRemotes(filter)
        for _,c in pairs(SF:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        local all={}
        local function scan(parent)
            for _,r in pairs(parent:GetDescendants()) do
                if r:IsA("RemoteEvent") then
                    table.insert(all,{name=r.Name,Type="Event",Obj=r})
                elseif r:IsA("RemoteFunction") then
                    table.insert(all,{name=r.Name,Type="Function",Obj=r})
                end
            end
        end
        scan(RS)
        scan(W)
        pcall(function() scan(CG) end)
        local count=0
        for i,info in pairs(all) do
            if not filter or filter=="" or info.name:lower():find(filter:lower()) then
                count=count+1
                local RF=Instance.new("Frame")
                RF.Size=UDim2.new(1,-4,0,30)
                RF.BackgroundColor3=TH.b
                RF.BorderSizePixel=0
                RF.LayoutOrder=count
                RF.Parent=SF
                mkCorner(RF,4)
                local RL=Instance.new("TextLabel")
                RL.Size=UDim2.new(0.45,0,1,0)
                RL.Position=UDim2.new(0,8,0,0)
                RL.BackgroundTransparency=1
                RL.Text=info.name
                RL.TextColor3=TH.t
                RL.TextSize=11
                RL.Font=Enum.Font.GothamMedium
                RL.TextXAlignment=Enum.TextXAlignment.Left
                RL.TextTruncate=Enum.TextTruncate.AtEnd
                RL.Parent=RF
                local RT=Instance.new("TextLabel")
                RT.Size=UDim2.new(0,50,0,18)
                RT.Position=UDim2.new(0.46,0,0,6)
                RT.BackgroundColor3=info.Type=="Event" and Color3.fromRGB(40,60,40) or Color3.fromRGB(60,40,40)
                RT.BorderSizePixel=0
                RT.Text=info.Type
                RT.TextColor3=info.Type=="Event" and TH.g or TH.r
                RT.TextSize=9
                RT.Font=Enum.Font.GothamBold
                RT.Parent=RF
                mkCorner(RT,3)
                local CB=Instance.new("TextButton")
                CB.Size=UDim2.new(0,50,0,22)
                CB.Position=UDim2.new(0.55,4,0,4)
                CB.BackgroundColor3=Color3.fromRGB(50,50,80)
                CB.BorderSizePixel=0
                CB.Text="Copy"
                CB.TextColor3=TH.t
                CB.TextSize=10
                CB.Font=Enum.Font.GothamBold
                CB.Parent=RF
                mkCorner(CB,4)
                CB.MouseButton1Click:Connect(function()
                    pcall(function() setclipboard(info.name) end)
                    CB.Text="Copied!"
                    CB.BackgroundColor3=TH.g
                    wait(1)
                    CB.Text="Copy"
                    CB.BackgroundColor3=Color3.fromRGB(50,50,80)
                end)
                local FB=Instance.new("TextButton")
                FB.Size=UDim2.new(0,50,0,22)
                FB.Position=UDim2.new(0.55+0.1,8,0,4)
                FB.BackgroundColor3=Color3.fromRGB(80,40,40)
                FB.BorderSizePixel=0
                FB.Text="Fire"
                FB.TextColor3=TH.t
                FB.TextSize=10
                FB.Font=Enum.Font.GothamBold
                FB.Parent=RF
                mkCorner(FB,4)
                FB.MouseButton1Click:Connect(function()
                    pcall(function() info.Obj:FireServer() end)
                    FB.Text="Fired!"
                    FB.BackgroundColor3=TH.g
                    wait(0.5)
                    FB.Text="Fire"
                    FB.BackgroundColor3=Color3.fromRGB(80,40,40)
                end)
            end
        end
        local CL=Instance.new("TextLabel")
        CL.Size=UDim2.new(0.4,0,0,18)
        CL.Position=UDim2.new(0.56,40,0,0)
        CL.BackgroundTransparency=1
        CL.Text="Found: "..count.." remotes"
        CL.TextColor3=TH.a
        CL.TextSize=10
        CL.Font=Enum.Font.GothamBold
        CL.TextXAlignment=Enum.TextXAlignment.Right
        CL.Parent=PF
    end
    loadRemotes("")
    SC:GetPropertyChangedSignal("Text"):Connect(function() loadRemotes(SC.Text) end)
    ntf("Remote Scanner","Opened! "..#RS:GetDescendants().." remotes found")
end end,"scanrem")
sep(tEx)
lbl(tEx,">> SELF EXPLOIT")
btn(tEx,"Full Heal",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.MaxHealth=math.huge h.Health=math.huge end end sf("godmode",1) end,"fheal")
btn(tEx,"Max Armor",function() sf("godmode",1) pcall(function() LP.Character:FindFirstChildOfClass("Humanoid").MaxHealth=math.huge LP.Character:FindFirstChildOfClass("Humanoid").Health=math.huge end) end,"marmor")
btn(tEx,"TP All To Me",function() if cd() then sf("bring",100) end end,"tpall")
btn(tEx,"Kill All",function() if cd() then sf("kill",100) end end,"killall")
btn(tEx,"Freeze All",function() if cd() then sf("freeze",100) end end,"frall")
btn(tEx,"Explode All",function() if cd() then sf("explode",100) end end,"expall")
local tMi=tF["misc"]
lbl(tMi,">> MISC")
btn(tMi,"Reset Character",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=0 end end end,"reset")
btn(tMi,"God Mode",function() sf("godmode",1) end,"godmode")
btn(tMi,"Anti-AFK",function() pcall(function() LP.Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Running) end) end,"antiafk")
btn(tMi,"Third Person",function() pcall(function() LP.CameraMinZoomDistance=10 LP.CameraMaxZoomDistance=10 end) end,"3rdperson")
btn(tMi,"First Person",function() pcall(function() LP.CameraMinZoomDistance=0.5 LP.CameraMaxZoomDistance=0.5 end) end,"1stperson")
sep(tMi)
lbl(tMi,">> SERVER ACTIONS")
btn(tMi,"Kill All",function() if cd() then sf("kill",100) end end,"svkill")
btn(tMi,"Heal All",function() if cd() then sf("heal",100) end end,"svheal")
btn(tMi,"Freeze All",function() if cd() then sf("freeze",100) end end,"svfreeze")
btn(tMi,"Unfreeze All",function() if cd() then sf("unfreeze",100) end end,"svunfreeze")
btn(tMi,"Explode All",function() if cd() then sf("explode",100) end end,"svexplode")
local tSe=tF["set"]
lbl(tSe,">> THEME")
btn(tSe,"Dark Purple",function() TH.p=Color3.fromRGB(18,18,32) TH.s=Color3.fromRGB(24,24,44) TH.b=Color3.fromRGB(35,35,60) TH.bh=Color3.fromRGB(55,55,85) TH.a=Color3.fromRGB(120,120,255) MF.BackgroundColor3=TH.p end,"thpurple")
btn(tSe,"Dark Red",function() TH.p=Color3.fromRGB(28,12,12) TH.s=Color3.fromRGB(38,16,16) TH.b=Color3.fromRGB(55,25,25) TH.bh=Color3.fromRGB(75,35,35) TH.a=Color3.fromRGB(255,80,80) MF.BackgroundColor3=TH.p end,"thred")
btn(tSe,"Dark Green",function() TH.p=Color3.fromRGB(12,24,12) TH.s=Color3.fromRGB(16,32,16) TH.b=Color3.fromRGB(25,50,25) TH.bh=Color3.fromRGB(35,70,35) TH.a=Color3.fromRGB(80,255,120) MF.BackgroundColor3=TH.p end,"thgreen")
btn(tSe,"Midnight",function() TH.p=Color3.fromRGB(8,8,20) TH.s=Color3.fromRGB(12,12,28) TH.b=Color3.fromRGB(20,20,40) TH.bh=Color3.fromRGB(30,30,55) TH.a=Color3.fromRGB(100,180,255) MF.BackgroundColor3=TH.p end,"thmid")
sep(tSe)
lbl(tSe,">> KEYBINDS INFO")
lbl(tSe,"Click the small box on any button")
lbl(tSe,"then press a key to set hotkey.")
lbl(tSe,"All features = click OR hotkey.")
print("[Axynth] All tabs OK")
U.InputBegan:Connect(function(inp,gpe)
    if gpe then return end
    if waitingForKey then
        local key = inp.KeyCode ~= Enum.KeyCode.Unknown and inp.KeyCode or inp.UserInputType
        KB[waitingForKey] = key
        waitingForKey = nil
        ntf("Keybind","Key assigned! Press F4 to reopen menu.")
        for _,t in pairs(allToggles) do
            if t._update then t._update() end
        end
        if tF["set"] then
            for _,c in pairs(tF["set"]:GetDescendants()) do
                if c:IsA("TextButton") and c.Text:find("NONE") then
                    c.Text = getKeyDisplay(KB[c.Parent._bindId]) or "NONE"
                end
            end
        end
        return
    end
    if inp.KeyCode==(KB["menu"] or Enum.KeyCode.F4) then
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
    end
    for id,key in pairs(KB) do
        if inp.KeyCode == key or inp.UserInputType == key then
            if id=="fly" then ST.fly=not ST.fly if not ST.fly and LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.PlatformStand=false end end for _,t in pairs(allToggles) do if t._update then t._update() end end
            elseif id=="noclip" then ST.noclip=not ST.noclip for _,t in pairs(allToggles) do if t._update then t._update() end end
            elseif id=="freecam" then ST.freeCam=not ST.freeCam if ST.freeCam then ST.freeCamPos=CAM.CFrame CAM.CameraType=Enum.CameraType.Scriptable else CAM.CameraType=Enum.CameraType.Custom if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h end end end for _,t in pairs(allToggles) do if t._update then t._update() end end
            elseif id=="clicktp" then ST.clickTP=not ST.clickTP for _,t in pairs(allToggles) do if t._update then t._update() end end
            elseif id=="esp" then ST.esp=not ST.esp if ST.esp then for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and not pp.Character:FindFirstChild("AxESP") then local hl=Instance.new("Highlight") hl.Name="AxESP" hl.FillColor=CFG.ESPColor hl.FillTransparency=CFG.ESPFillAlpha hl.OutlineColor=Color3.new(1,1,1) hl.OutlineTransparency=0 hl.Parent=pp.Character ST.espList[pp.UserId]=hl end end else for uid,hl in pairs(ST.espList) do if hl and hl.Parent then hl:Destroy() end ST.espList[uid]=nil end end for _,t in pairs(allToggles) do if t._update then t._update() end end
            elseif id=="night" then ST.night=not ST.night if ST.night then L.ClockTime=0 else L.ClockTime=14 end for _,t in pairs(allToggles) do if t._update then t._update() end end
            elseif id=="bright" then ST.bright=not ST.bright if ST.bright then L.Brightness=2 L.GlobalShadows=false else L.Brightness=1 L.GlobalShadows=true end for _,t in pairs(allToggles) do if t._update then t._update() end end
            elseif id=="nofog" then ST.noFog=not ST.noFog if ST.noFog then L.FogEnd=999999 else L.FogEnd=100000 end for _,t in pairs(allToggles) do if t._update then t._update() end end
            elseif id=="svlag" then ST.serverLag=not ST.serverLag if ST.serverLag then spawn(function() while ST.serverLag do pcall(function() for _,r in pairs(RS:GetDescendants()) do if r:IsA("RemoteEvent") then pcall(function() r:FireServer() end) pcall(function() r:FireServer("lag") end) end end end) wait(math.random(50,200)/1000) end end) end for _,t in pairs(allToggles) do if t._update then t._update() end end
            end
        end
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
