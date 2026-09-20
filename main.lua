-- RP ADMIN v5 - ALL IN ONE
-- CLIENT: Copy everything below to ServerScriptService > Script
-- SERVER: Copy from "-- SERVER SCRIPT" line to ServerScriptService > Script

-- ============================================================
-- CLIENT SCRIPT (StarterPlayerScripts > LocalScript)
-- ============================================================

print("[A] Part 1: Core")
local ok,err=pcall(function()
local P=game:GetService("Players") local U=game:GetService("UserInputService") local R=game:GetService("RunService") local L=game:GetService("Lighting") local S=game:GetService("StarterGui") local RS=game:GetService("ReplicatedStorage") local CG=game:GetService("CoreGui") local TW=game:GetService("TweenService") local W=game:GetService("Workspace")
local LP=P.LocalPlayer local MS=LP:GetMouse() local CAM=W.CurrentCamera
local log=function(m) print("[A] "..m) end
local function ntf(t,x,d) pcall(function() S:SetCore("SendNotification",{Title=t,Text=x,Duration=d or 3}) end) end
_G.AMENU={P=P,U=U,R=R,L=L,S=S,RS=RS,CG=CG,TW=TW,W=W,LP=LP,MS=MS,CAM=CAM,log=log,ntf=ntf}
_G.AMENU.ST={menuOpen=false,fly=false,noclip=false,clickTP=false,infJump=false,godMode=false,invisible=false,esp=false,nameTags=false,spectating=nil,selectedPlayer=nil,flySpeed=50,flyDir=Vector3.new(0,0,0),espList={},nameTagList={}}
_G.AMENU.CFG={MenuKey=Enum.KeyCode.F4,NoclipKey=Enum.KeyCode.F5,ClickTPKey=Enum.KeyCode.F6,FlyKey=Enum.KeyCode.F7,InfJumpKey=Enum.KeyCode.F8,ESPKey=Enum.KeyCode.F9,GodModeKey=Enum.KeyCode.F10,InvisibleKey=Enum.KeyCode.F11,ESPColor=Color3.fromRGB(255,0,0),ESPFillAlpha=0.5,ThemePrimary=Color3.fromRGB(15,15,25),ThemeSecondary=Color3.fromRGB(22,22,40),ThemeButton=Color3.fromRGB(30,30,50),ThemeButtonHover=Color3.fromRGB(50,50,80),ThemeText=Color3.fromRGB(200,200,220),ThemeAccent=Color3.fromRGB(100,100,255)}
local AR=RS:WaitForChild("AdminRemote",5)
if not AR then AR=Instance.new("RemoteEvent") AR.Name="AdminRemote" AR.Parent=RS end
_G.AMENU.AR=AR
local function fireServer(a,...) if AR then pcall(function() AR:FireServer(a,...) end) end end
local function safeFire(a,...) spawn(function() wait(math.random(10,50)/1000) fireServer(a,...) end) end
_G.AMENU.fireServer=fireServer _G.AMENU.safeFire=safeFire
local function tw(o,p,d) local t=TW:Create(o,TweenInfo.new(d or 0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),p) t:Play() return t end
local function sep(p) local f=Instance.new("Frame") f.Size=UDim2.new(1,-10,0,1) f.BackgroundColor3=Color3.fromRGB(40,40,60) f.BorderSizePixel=0 f.Parent=p end
local function lbl(p,t) local l=Instance.new("TextLabel") l.Size=UDim2.new(1,-10,0,22) l.BackgroundTransparency=1 l.Text=t l.TextColor3=_G.AMENU.CFG.ThemeAccent l.TextSize=12 l.Font=Enum.Font.GothamBold l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=p end
local function btn(p,t,fn) local b=Instance.new("TextButton") b.Size=UDim2.new(1,-10,0,30) b.BackgroundColor3=_G.AMENU.CFG.ThemeButton b.BorderSizePixel=0 b.Text="  "..t b.TextColor3=_G.AMENU.CFG.ThemeText b.TextSize=12 b.Font=Enum.Font.GothamBold b.TextXAlignment=Enum.TextXAlignment.Left b.Parent=p Instance.new("UICorner",b).CornerRadius=UDim.new(0,6) b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=_G.AMENU.CFG.ThemeButtonHover},0.15) end) b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=_G.AMENU.CFG.ThemeButton},0.15) end) b.MouseButton1Click:Connect(function() pcall(fn) end) return b end
local function tog(p,t,gf,fn) local b=Instance.new("TextButton") b.Size=UDim2.new(1,-10,0,30) b.BackgroundColor3=_G.AMENU.CFG.ThemeButton b.BorderSizePixel=0 local st=gf() b.Text="  "..t..": "..(st and "ON" or "OFF") b.TextColor3=st and Color3.fromRGB(100,255,100) or _G.AMENU.CFG.ThemeText b.TextSize=12 b.Font=Enum.Font.GothamBold b.TextXAlignment=Enum.TextXAlignment.Left b.Parent=p Instance.new("UICorner",b).CornerRadius=UDim.new(0,6) b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=_G.AMENU.CFG.ThemeButtonHover},0.15) end) b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=_G.AMENU.CFG.ThemeButton},0.15) end) b.MouseButton1Click:Connect(function() fn() local s=gf() b.Text="  "..t..": "..(s and "ON" or "OFF") b.TextColor3=s and Color3.fromRGB(100,255,100) or _G.AMENU.CFG.ThemeText end) return b end
local function inp(p,t,fn) local b=Instance.new("TextButton") b.Size=UDim2.new(1,-10,0,30) b.BackgroundColor3=_G.AMENU.CFG.ThemeButton b.BorderSizePixel=0 b.Text="  "..t b.TextColor3=_G.AMENU.CFG.ThemeText b.TextSize=12 b.Font=Enum.Font.GothamBold b.TextXAlignment=Enum.TextXAlignment.Left b.Parent=p Instance.new("UICorner",b).CornerRadius=UDim.new(0,6) b.MouseButton1Click:Connect(function() local sg=Instance.new("ScreenGui") pcall(function() sg.Parent=CG end) if not sg.Parent then sg.Parent=LP:WaitForChild("PlayerGui") end local mf=Instance.new("Frame") mf.Size=UDim2.new(0,300,0,80) mf.Position=UDim2.new(0.5,-150,0.5,-40) mf.BackgroundColor3=_G.AMENU.CFG.ThemeSecondary mf.BorderSizePixel=0 mf.Parent=sg Instance.new("UICorner",mf).CornerRadius=UDim.new(0,8) local tb=Instance.new("TextBox") tb.Size=UDim2.new(1,-20,0,30) tb.Position=UDim2.new(0,10,0,5) tb.BackgroundColor3=_G.AMENU.CFG.ThemeButton tb.BorderSizePixel=0 tb.Text="" tb.PlaceholderText=t tb.TextColor3=_G.AMENU.CFG.ThemeText tb.PlaceholderColor3=Color3.fromRGB(120,120,120) tb.TextSize=13 tb.Font=Enum.Font.Gotham tb.ClearTextOnFocus=false tb.Parent=mf Instance.new("UICorner",tb).CornerRadius=UDim.new(0,6) local ok2=Instance.new("TextButton") ok2.Size=UDim2.new(0.45,0,0,28) ok2.Position=UDim2.new(0.025,5,0,42) ok2.BackgroundColor3=_G.AMENU.CFG.ThemeAccent ok2.BorderSizePixel=0 ok2.Text="OK" ok2.TextColor3=Color3.new(1,1,1) ok2.TextSize=13 ok2.Font=Enum.Font.GothamBold ok2.Parent=mf Instance.new("UICorner",ok2).CornerRadius=UDim.new(0,6) local cl=Instance.new("TextButton") cl.Size=UDim2.new(0.45,0,0,28) cl.Position=UDim2.new(0.525,0,0,42) cl.BackgroundColor3=Color3.fromRGB(80,30,30) cl.BorderSizePixel=0 cl.Text="Cancel" cl.TextColor3=Color3.new(1,1,1) cl.TextSize=13 cl.Font=Enum.Font.GothamBold cl.Parent=mf Instance.new("UICorner",cl).CornerRadius=UDim.new(0,6) ok2.MouseButton1Click:Connect(function() pcall(function() fn(tb.Text) end) sg:Destroy() end) cl.MouseButton1Click:Connect(function() sg:Destroy() end) tb.FocusLost:Connect(function(en) if en then pcall(function() fn(tb.Text) end) sg:Destroy() end end) end) return b end
_G.AMENU.sep=sep _G.AMENU.lbl=lbl _G.AMENU.btn=btn _G.AMENU.tog=tog _G.AMENU.inp=inp _G.AMENU.tw=tw
log("Part 1: Helpers loaded")
end)
if not ok then print("[A] ERROR Part1: "..tostring(err)) end

print("[A] Part 2: GUI + Tabs")
local ok,err=pcall(function()
local A=_G.AMENU if not A then print("[A] ERROR: Run Part 1 first!") return end
local P=A.P local LP=A.LP local MS=A.MS local CAM=A.CAM local L=A.L local CG=A.CG
local log=A.log ntf=A.ntf ST=A.ST CFG=A.CFG
local sep=A.sep lbl=A.lbl btn=A.btn tog=A.tog inp=A.inp tw=A.tw
local SG=Instance.new("ScreenGui") SG.Name="AM" SG.ResetOnSpawn=false SG.DisplayOrder=1
pcall(function() SG.Parent=CG end) if not SG.Parent then SG.Parent=LP:WaitForChild("PlayerGui") end
local MF=Instance.new("Frame") MF.Size=UDim2.new(0,560,0,500) MF.Position=UDim2.new(0.5,-280,0.5,-250) MF.BackgroundColor3=CFG.ThemePrimary MF.BorderSizePixel=0 MF.Active=true MF.Draggable=true MF.Visible=false MF.Parent=SG MF.ClipsDescendants=true
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,12)
local TB=Instance.new("Frame") TB.Size=UDim2.new(1,0,0,35) TB.BackgroundColor3=CFG.ThemeSecondary TB.BorderSizePixel=0 TB.Parent=MF
local TL=Instance.new("TextLabel") TL.Size=UDim2.new(1,-50,1,0) TL.BackgroundTransparency=1 TL.Text="RP ADMIN v5" TL.TextColor3=CFG.ThemeAccent TL.TextSize=15 TL.Font=Enum.Font.GothamBold TL.TextXAlignment=Enum.TextXAlignment.Left TL.Parent=TB TL.Position=UDim2.new(0,12,0,0)
local XBtn=Instance.new("TextButton") XBtn.Size=UDim2.new(0,30,0,30) XBtn.Position=UDim2.new(1,-35,0,2) XBtn.BackgroundTransparency=1 XBtn.Text="X" XBtn.TextColor3=Color3.fromRGB(200,80,80) XBtn.TextSize=18 XBtn.Font=Enum.Font.GothamBold XBtn.Parent=TB
XBtn.MouseButton1Click:Connect(function() ST.menuOpen=false MF.Visible=false end)
local CF=Instance.new("Frame") CF.Size=UDim2.new(1,0,0,35) CF.Position=UDim2.new(0,0,0,35) CF.BackgroundColor3=Color3.fromRGB(18,18,30) CF.BorderSizePixel=0 CF.Parent=MF
local tabs={} local tF={}
local tNames={{"move","Move"},{"world","World"},{"plr","Players"},{"fun","Fun"},{"troll","Troll"},{"net","Net"},{"misc","Misc"},{"cars","Cars"},{"money","Money"},{"set","Set"}}
for i,n in pairs(tNames) do
local f=Instance.new("TextButton") f.Size=UDim2.new(0,54,0,30) f.Position=UDim2.new(0,(i-1)*56+2,0,2) f.BackgroundColor3=CFG.ThemePrimary f.BorderSizePixel=0 f.Text=n[2] f.TextColor3=CFG.ThemeText f.TextSize=9 f.Font=Enum.Font.GothamBold f.Parent=CF Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
local fr=Instance.new("ScrollingFrame") fr.Size=UDim2.new(1,-10,1,-75) fr.Position=UDim2.new(0,5,0,72) fr.BackgroundTransparency=1 fr.BorderSizePixel=0 fr.ScrollBarThickness=4 fr.CanvasSize=UDim2.new(0,0,0,0) fr.Visible=false fr.Parent=MF fr.AutomaticCanvasSize=Enum.AutomaticSize.Y Instance.new("UIListLayout",fr).Padding=UDim.new(0,3) Instance.new("UIPadding",fr).PaddingTop=UDim.new(0,2) Instance.new("UIPadding",fr).PaddingLeft=UDim.new(0,2)
tabs[n[1]]={btn=f,frame=fr} tF[n[1]]=fr
f.MouseButton1Click:Connect(function() for _,v in pairs(tabs) do v.frame.Visible=false v.btn.BackgroundColor3=CFG.ThemePrimary v.btn.TextColor3=CFG.ThemeText end fr.Visible=true f.BackgroundColor3=CFG.ThemeAccent f.TextColor3=Color3.new(1,1,1) end)
end
tabs["move"].frame.Visible=true tabs["move"].btn.BackgroundColor3=CFG.ThemeAccent tabs["move"].btn.TextColor3=Color3.new(1,1,1)

-- MOVE
local tM=tF["move"]
lbl(tM,">> SPEED")
inp(tM,"Speed value",function(t) local v=tonumber(t) if v and LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=v end ntf("Speed",t) end end)
inp(tM,"JumpPower",function(t) local v=tonumber(t) if v and LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower=true h.JumpPower=v end ntf("Jump",t) end end)
sep(tM) lbl(tM,">> FLY")
tog(tM,"Fly",function() return ST.fly end,function() ST.fly=not ST.fly if not ST.fly and LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.PlatformStand=false end end end)
inp(tM,"Fly Speed",function(t) local v=tonumber(t) if v then ST.flySpeed=v end end)
sep(tM) lbl(tM,">> NOCLIP")
tog(tM,"Noclip",function() return ST.noclip end,function() ST.noclip=not ST.noclip end)
sep(tM) lbl(tM,">> TELEPORT")
tog(tM,"Click TP",function() return ST.clickTP end,function() ST.clickTP=not ST.clickTP ntf("ClickTP",ST.clickTP and "ON" or "OFF") end)
btn(tM,"TP Cursor",function() if LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h and MS.Hit then h.CFrame=CFrame.new(MS.Hit.Position+Vector3.new(0,3,0)) end end end)
btn(tM,"TP Forward 100",function() if LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h then h.CFrame=h.CFrame+CAM.CFrame.LookVector*100 end end end)
btn(tM,"TP Up 50",function() if LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h then h.CFrame=h.CFrame+Vector3.new(0,50,0) end end end)
btn(tM,"TP Down 50",function() if LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h then h.CFrame=h.CFrame+Vector3.new(0,-50,0) end end end)

-- WORLD
local tW=tF["world"]
tog(tW,"Night",function() return ST.night end,function() ST.night=not ST.night if ST.night then L.ClockTime=0 else L.ClockTime=14 end end)
tog(tW,"Fullbright",function() return ST.bright end,function() ST.bright=not ST.bright if ST.bright then L.Brightness=2 L.GlobalShadows=false else L.Brightness=1 L.GlobalShadows=true end end)
tog(tW,"No Fog",function() return ST.noFog end,function() ST.noFog=not ST.noFog if ST.noFog then L.FogEnd=999999 else L.FogEnd=100000 end end)
inp(tW,"Brightness",function(t) local v=tonumber(t) if v then L.Brightness=v ntf("Brightness",t) end end)

-- PLAYERS
local tP=tF["plr"]
lbl(tP,">> SELECT PLAYER")
local pDropBtn=Instance.new("TextButton") pDropBtn.Size=UDim2.new(1,-10,0,30) pDropBtn.BackgroundColor3=CFG.ThemeButton pDropBtn.BorderSizePixel=0 pDropBtn.Text="  Click to select..." pDropBtn.TextColor3=CFG.ThemeText pDropBtn.TextSize=12 pDropBtn.Font=Enum.Font.GothamBold pDropBtn.TextXAlignment=Enum.TextXAlignment.Left pDropBtn.Parent=tP Instance.new("UICorner",pDropBtn).CornerRadius=UDim.new(0,6)
local pDropOpen=false local pDropdown=nil
pDropBtn.MouseButton1Click:Connect(function() pDropOpen=not pDropOpen if pDropOpen then if pDropdown then pDropdown:Destroy() end pDropdown=Instance.new("ScrollingFrame") pDropdown.Size=UDim2.new(1,-10,0,150) pDropdown.Position=UDim2.new(0,5,0,32) pDropdown.BackgroundColor3=CFG.ThemeSecondary pDropdown.BorderSizePixel=0 pDropdown.ScrollBarThickness=4 pDropdown.Parent=tP Instance.new("UICorner",pDropdown).CornerRadius=UDim.new(0,6) Instance.new("UIListLayout",pDropdown).Padding=UDim.new(0,2) local pl=P:GetPlayers() pDropdown.CanvasSize=UDim2.new(0,0,0,#pl*28) for _,pp in pairs(pl) do if pp~=LP then local o=Instance.new("TextButton") o.Size=UDim2.new(1,-4,0,26) o.BackgroundColor3=CFG.ThemePrimary o.BorderSizePixel=0 o.Text="  "..pp.DisplayName o.TextColor3=CFG.ThemeText o.TextXAlignment=Enum.TextXAlignment.Left o.TextSize=12 o.Font=Enum.Font.Gotham o.Parent=pDropdown Instance.new("UICorner",o).CornerRadius=UDim.new(0,4) o.MouseButton1Click:Connect(function() ST.selectedPlayer=pp pDropBtn.Text="  > "..pp.DisplayName pDropOpen=false if pDropdown then pDropdown:Destroy() pDropdown=nil end end) end end else if pDropdown then pDropdown:Destroy() pDropdown=nil end end end)
btn(tP,"Refresh",function() pDropBtn.Text="  Click to select..." ST.selectedPlayer=nil end)
sep(tP) lbl(tP,">> ACTIONS")
local safeFire=A.safeFire
btn(tP,"Goto",function() if ST.selectedPlayer and ST.selectedPlayer.Character and LP.Character then local t=ST.selectedPlayer.Character:FindFirstChild("HumanoidRootPart") local m=LP.Character:FindFirstChild("HumanoidRootPart") if t and m then m.CFrame=t.CFrame+Vector3.new(3,0,0) end end end)
btn(tP,"Bring",function() if ST.selectedPlayer then safeFire("bring",ST.selectedPlayer.Name) end end)
btn(tP,"Freeze",function() if ST.selectedPlayer then safeFire("freeze",ST.selectedPlayer.Name) end end)
btn(tP,"Unfreeze",function() if ST.selectedPlayer then safeFire("unfreeze",ST.selectedPlayer.Name) end end)
btn(tP,"Kill",function() if ST.selectedPlayer then safeFire("kill",ST.selectedPlayer.Name) end end)
btn(tP,"Heal",function() if ST.selectedPlayer then safeFire("heal",ST.selectedPlayer.Name) end end)
btn(tP,"Kick AC",function() if ST.selectedPlayer then safeFire("silentKick",ST.selectedPlayer.Name) end end)
btn(tP,"Jail",function() if ST.selectedPlayer then safeFire("jail",ST.selectedPlayer.Name) end end)
btn(tP,"Unjail",function() if ST.selectedPlayer then safeFire("unjail",ST.selectedPlayer.Name) end end)
sep(tP) lbl(tP,">> SPECTATE")
btn(tP,"Spec 3rd",function() if ST.selectedPlayer and ST.selectedPlayer.Character then local h=ST.selectedPlayer.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h CAM.CameraType=Enum.CameraType.Custom ST.spectating=ST.selectedPlayer end end end)
btn(tP,"Spec 1st",function() if ST.selectedPlayer and ST.selectedPlayer.Character then local h=ST.selectedPlayer.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h CAM.CameraType=Enum.CameraType.Watch ST.spectating=ST.selectedPlayer end end end)
btn(tP,"Stop Spec",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h end CAM.CameraType=Enum.CameraType.Custom ST.spectating=nil end end)
btn(tP,"Spec Next",function() local pl=P:GetPlayers() if #pl<=1 then return end local ci=nil for i,pp in pairs(pl) do if pp==ST.spectating then ci=i break end end local ni=ci and ((ci%#pl)+1) or 1 if pl[ni]==LP then ni=(ni%#pl)+1 end if pl[ni] and pl[ni]~=LP and pl[ni].Character then ST.selectedPlayer=pl[ni] local h=pl[ni].Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h CAM.CameraType=Enum.CameraType.Custom ST.spectating=pl[ni] end end end)
sep(tP) lbl(tP,">> ESP")
tog(tP,"ESP",function() return ST.esp end,function() ST.esp=not ST.esp if ST.esp then for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and not pp.Character:FindFirstChild("ESP_HL") then local hl=Instance.new("Highlight") hl.Name="ESP_HL" hl.FillColor=CFG.ESPColor hl.FillTransparency=CFG.ESPFillAlpha hl.OutlineColor=Color3.new(1,1,1) hl.OutlineTransparency=0 hl.Parent=pp.Character ST.espList[pp.UserId]=hl end end else for id,hl in pairs(ST.espList) do if hl and hl.Parent then hl:Destroy() end ST.espList[id]=nil end end end)
tog(tP,"NameTags+Dist",function() return ST.nameTags end,function() ST.nameTags=not ST.nameTags if ST.nameTags then for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character then local hd=pp.Character:FindFirstChild("Head") if hd and not hd:FindFirstChild("NTag") then local bg=Instance.new("BillboardGui") bg.Name="NTag" bg.Size=UDim2.new(0,250,0,60) bg.StudsOffset=Vector3.new(0,3,0) bg.AlwaysOnTop=true bg.Parent=hd local nl=Instance.new("TextLabel") nl.Size=UDim2.new(1,0,0.4,0) nl.BackgroundTransparency=0.5 nl.BackgroundColor3=Color3.fromRGB(0,0,0) nl.Text=pp.Name nl.TextColor3=Color3.new(1,1,1) nl.TextScaled=true nl.Font=Enum.Font.GothamBold nl.Parent=bg local il=Instance.new("TextLabel") il.Size=UDim2.new(1,0,0.35,0) il.Position=UDim2.new(0,0,0.4,0) il.BackgroundTransparency=0.5 il.BackgroundColor3=Color3.fromRGB(0,0,0) local hp=pp.Character:FindFirstChildOfClass("Humanoid") il.Text="HP:"..(hp and math.floor(hp.Health) or "?").."/"..(hp and math.floor(hp.MaxHealth) or "?") il.TextColor3=Color3.fromRGB(100,255,100) il.TextScaled=true il.Font=Enum.Font.GothamBold il.Parent=bg local dl=Instance.new("TextLabel") dl.Size=UDim2.new(1,0,0.25,0) dl.Position=UDim2.new(0,0,0.75,0) dl.BackgroundTransparency=0.5 dl.BackgroundColor3=Color3.fromRGB(0,0,0) dl.Text="[...]" dl.TextColor3=Color3.fromRGB(255,255,100) dl.TextScaled=true dl.Font=Enum.Font.GothamBold dl.Parent=bg ST.nameTagList[pp.UserId]=bg end end end else for id,bg in pairs(ST.nameTagList) do if bg and bg.Parent then bg:Destroy() end ST.nameTagList[id]=nil end end end)
log("Part 2: GUI + Tabs loaded")
end)
if not ok then print("[A] ERROR Part2: "..tostring(err)) end


print("[A] Part 3: Features + Events")
local ok,err=pcall(function()
local A=_G.AMENU if not A then print("[A] ERROR: Run Parts 1-2 first!") return end
local P=A.P local LP=A.LP local MS=A.MS local CAM=A.CAM local R=A.R local W=A.W
local log=A.log ntf=A.ntf ST=A.ST CFG=A.CFG
local sep=A.sep lbl=A.lbl btn=A.btn tog=A.tog inp=A.inp tw=A.tw
local safeFire=A.safeFire fireServer=A.fireServer

local SG=LP:WaitForChild("PlayerGui"):FindFirstChild("AM") or game:GetService("CoreGui"):FindFirstChild("AM")
if not SG then print("[A] ERROR: ScreenGui not found!") return end
local MF=SG:FindFirstChild("MF")
if not MF then print("[A] ERROR: MainFrame not found!") return end

-- FUN
local tF2=MF:FindFirstChildOfClass("ScrollingFrame") -- move first
local function getTabScroll(name) for _,f in pairs(MF:GetChildren()) do if f:IsA("ScrollingFrame") then local lbl=f:FindFirstChildOfClass("TextLabel") and f:FindFirstChildOfClass("TextLabel").Text or "" end end end
-- Get tabs by index (they're added in order, skip first for title bar, skip second for tab bar)
local allFrames=MF:GetChildren()
local frames={}
for _,f in pairs(allFrames) do if f:IsA("ScrollingFrame") then table.insert(frames,f) end end
-- frames[1]=move, [2]=world, [3]=plr, [4]=fun, [5]=troll, [6]=net, [7]=misc, [8]=cars, [9]=money, [10]=set
local function gt(idx) return frames[idx] end

-- FUN TAB (4)
local tFu=gt(4)
if tFu then
lbl(tFu,">> FUN")
btn(tFu,"Jumpscare",function() safeFire("jumpscare",100) end)
btn(tFu,"Popcorn",function() safeFire("popcorn",100) end)
btn(tFu,"Confetti",function() safeFire("confetti",100) end)
btn(tFu,"Big Head",function() safeFire("bighead",100) end)
btn(tFu,"Small Head",function() safeFire("smallhead",100) end)
btn(tFu,"Fire All",function() safeFire("fire",100) end)
btn(tFu,"Sparkle All",function() safeFire("sparkle",100) end)
btn(tFu,"Smoke All",function() safeFire("smoke",100) end)
btn(tFu,"Remove FX",function() safeFire("removefx",100) end)
btn(tFu,"Invisible All",function() safeFire("invisible",100) end)
btn(tFu,"Visible All",function() safeFire("visible",100) end)
btn(tFu,"Spin All",function() safeFire("spin",100) end)
btn(tFu,"Stop Spin",function() safeFire("unspin",100) end)
btn(tFu,"Slap All",function() safeFire("slap",100) end)
btn(tFu,"Bang All",function() safeFire("bang",100) end)
btn(tFu,"Dance All",function() safeFire("dance",100) end)
btn(tFu,"Sleep All",function() safeFire("sleep",100) end)
sep(tFu) lbl(tFu,">> SELF")
btn(tFu,"Self Jumpscare",function() safeFire("jumpscare",1) end)
btn(tFu,"Self Confetti",function() safeFire("confetti",1) end)
btn(tFu,"Self Fire",function() safeFire("fire",1) end)
btn(tFu,"Self Sparkle",function() safeFire("sparkle",1) end)
btn(tFu,"Self Dance",function() safeFire("dance",1) end)
btn(tFu,"Self Bang",function() safeFire("bang",1) end)
btn(tFu,"Self Sleep",function() safeFire("sleep",1) end)
btn(tFu,"Self Spin",function() safeFire("spin",1) end)
btn(tFu,"Self Stop Spin",function() safeFire("unspin",1) end)
end

-- TROLL TAB (5)
local tTr=gt(5)
if tTr then
lbl(tTr,">> TROLL")
btn(tTr,"Stomp All",function() safeFire("stomp",100) end)
btn(tTr,"Trip All",function() safeFire("trip",100) end)
btn(tTr,"Scare All",function() safeFire("scare",100) end)
btn(tTr,"Fake Leave",function() safeFire("fakeLeave",100) end)
btn(tTr,"Vibrate All",function() safeFire("vibrate",100) end)
btn(tTr,"Explode",function() safeFire("explode",100) end)
btn(tTr,"Fling All",function() safeFire("fling",100) end)
btn(tTr,"Ragdoll",function() safeFire("ragdoll",100) end)
btn(tTr,"Freeze All",function() safeFire("freeze",100) end)
btn(tTr,"Unfreeze All",function() safeFire("unfreeze",100) end)
sep(tTr) lbl(tTr,">> JAIL/ARREST")
btn(tTr,"Jail All",function() safeFire("jail",100) end)
btn(tTr,"Unjail All",function() safeFire("unjail",100) end)
btn(tTr,"Arrest All",function() safeFire("arrest",100) end)
btn(tTr,"Unarrest All",function() safeFire("unarrest",100) end)
sep(tTr) lbl(tTr,">> TROLL TOOLS")
btn(tTr,"Explode All",function() safeFire("explode",100) end)
btn(tTr,"Fling All",function() safeFire("fling",100) end)
btn(tTr,"Ragdoll All",function() safeFire("ragdoll",100) end)
end

-- NET TAB (6)
local tNe=gt(6)
if tNe then
lbl(tNe,">> REMOTES")
btn(tNe,"Spam Remote x50",function() for i=1,50 do safeFire("ping") end end)
btn(tNe,"Mass Explode",function() safeFire("explode",100) end)
btn(tNe,"Mass Fire",function() safeFire("fire",100) end)
btn(tNe,"Mass Sparkle",function() safeFire("sparkle",100) end)
btn(tNe,"Mass Smoke",function() safeFire("smoke",100) end)
btn(tNe,"Mass Invisible",function() safeFire("invisible",100) end)
sep(tNe) lbl(tNe,">> STRESS TEST")
btn(tNe,"Fire x20",function() for i=1,20 do safeFire("fire",100) end end)
btn(tNe,"Confetti x20",function() for i=1,20 do safeFire("confetti",100) end end)
btn(tNe,"Bang x20",function() for i=1,20 do safeFire("bang",100) end end)
end

-- MISC TAB (7)
local tMi=gt(7)
if tMi then
lbl(tMi,">> MISC")
btn(tMi,"Reset Character",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=0 end end end)
btn(tMi,"Respawn",function() safeFire("respawn",1) end)
btn(tMi,"God Mode",function() safeFire("godmode",1) end)
btn(tMi,"Anti-AFK",function() pcall(function() LP.Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Running) end) end)
btn(tMi,"Third Person",function() pcall(function() LP.CameraMinZoomDistance=10 LP.CameraMaxZoomDistance=10 end) end)
btn(tMi,"First Person",function() pcall(function() LP.CameraMinZoomDistance=0.5 LP.CameraMaxZoomDistance=0.5 end) end)
sep(tMi) lbl(tMi,">> SERVER")
btn(tMi,"Full Server Kill",function() safeFire("kill",100) end)
btn(tMi,"Full Server Healen",function() safeFire("heal",100) end)
btn(tMi,"Full Server Freeze",function() safeFire("freeze",100) end)
btn(tMi,"Full Server Unfreeze",function() safeFire("unfreeze",100) end)
btn(tMi,"Full Server Jail",function() safeFire("jail",100) end)
btn(tMi,"Full Server Unjail",function() safeFire("unjail",100) end)
end

-- CARS TAB (8)
local tCa=gt(8)
if tCa then
lbl(tCa,">> CARS")
btn(tCa,"Speed Boost",function() safeFire("carSpeed",100) end)
btn(tCa,"Explode Cars",function() safeFire("carExplode",100) end)
btn(tCa,"Delete Cars",function() safeFire("carDelete",100) end)
btn(tCa,"Flip Cars",function() safeFire("carFlip",100) end)
end

-- MONEY TAB (9)
local tMo=gt(9)
if tMo then
lbl(tMo,">> MONEY")
btn(tMo,"Give Money 100",function() safeFire("giveMoney",100) end)
btn(tMo,"Give Money 1000",function() safeFire("giveMoney",1000) end)
btn(tMo,"Give Money 10000",function() safeFire("giveMoney",10000) end)
btn(tMo,"Remove Money",function() safeFire("removeMoney",100) end)
end

-- SETTINGS TAB (10)
local tSe=gt(10)
if tSe then
lbl(tSe,">> THEME")
btn(tSe,"Blue Theme",function() CFG.ThemePrimary=Color3.fromRGB(10,15,30) CFG.ThemeSecondary=Color3.fromRGB(15,25,45) CFG.ThemeButton=Color3.fromRGB(20,35,60) CFG.ThemeButtonHover=Color3.fromRGB(30,50,80) CFG.ThemeAccent=Color3.fromRGB(80,150,255) ntf("Theme","Blue") end)
btn(tSe,"Green Theme",function() CFG.ThemePrimary=Color3.fromRGB(10,25,10) CFG.ThemeSecondary=Color3.fromRGB(15,35,15) CFG.ThemeButton=Color3.fromRGB(20,50,20) CFG.ThemeButtonHover=Color3.fromRGB(30,70,30) CFG.ThemeAccent=Color3.fromRGB(80,255,80) ntf("Theme","Green") end)
btn(tSe,"Red Theme",function() CFG.ThemePrimary=Color3.fromRGB(25,10,10) CFG.ThemeSecondary=Color3.fromRGB(35,15,15) CFG.ThemeButton=Color3.fromRGB(50,20,20) CFG.ThemeButtonHover=Color3.fromRGB(70,30,30) CFG.ThemeAccent=Color3.fromRGB(255,80,80) ntf("Theme","Red") end)
sep(tSe) lbl(tSe,">> HOTKEYS")
lbl(tSe,"(Use KeyPicker buttons below)")
btn(tSe,"Reset All Keys",function() CFG.MenuKey=Enum.KeyCode.F4 CFG.NoclipKey=Enum.KeyCode.F5 CFG.ClickTPKey=Enum.KeyCode.F6 CFG.FlyKey=Enum.KeyCode.F7 CFG.InfJumpKey=Enum.KeyCode.F8 CFG.ESPKey=Enum.KeyCode.F9 CFG.GodModeKey=Enum.KeyCode.F10 CFG.InvisibleKey=Enum.KeyCode.F11 ntf("Hotkeys","All reset to defaults") end)
btn(tSe,"Show Current Keys",function() ntf("Menu",tostring(CFG.MenuKey)) ntf("Noclip",tostring(CFG.NoclipKey)) ntf("ClickTP",tostring(CFG.ClickTPKey)) ntf("Fly",tostring(CFG.FlyKey)) ntf("ESP",tostring(CFG.ESPKey)) end)
sep(tSe) lbl(tSe,">> ESP")
inp(tSe,"ESP Color R",function(t) local v=tonumber(t) if v then CFG.ESPColor=Color3.fromRGB(v,CFG.ESPColor.G*255,CFG.ESPColor.B*255) end end)
inp(tSe,"ESP Color G",function(t) local v=tonumber(t) if v then CFG.ESPColor=Color3.fromRGB(CFG.ESPColor.R*255,v,CFG.ESPColor.B*255) end end)
inp(tSe,"ESP Color B",function(t) local v=tonumber(t) if v then CFG.ESPColor=Color3.fromRGB(CFG.ESPColor.R*255,CFG.ESPColor.G*255,v) end end)
end

-- HOTKEY HANDLER
A.U.InputBegan:Connect(function(inp2,gpe)
if gpe then return end
if inp2.KeyCode==CFG.MenuKey then ST.menuOpen=not ST.menuOpen MF.Visible=ST.menuOpen
elseif inp2.KeyCode==CFG.NoclipKey then ST.noclip=not ST.noclip ntf("Noclip",ST.noclip and "ON" or "OFF")
elseif inp2.KeyCode==CFG.ClickTPKey then ST.clickTP=not ST.clickTP ntf("ClickTP",ST.clickTP and "ON" or "OFF")
elseif inp2.KeyCode==CFG.FlyKey then ST.fly=not ST.fly if not ST.fly and LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.PlatformStand=false end end ntf("Fly",ST.fly and "ON" or "OFF")
elseif inp2.KeyCode==CFG.ESPKey then
ST.esp=not ST.esp
if ST.esp then for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and not pp.Character:FindFirstChild("ESP_HL") then local hl=Instance.new("Highlight") hl.Name="ESP_HL" hl.FillColor=CFG.ESPColor hl.FillTransparency=CFG.ESPFillAlpha hl.OutlineColor=Color3.new(1,1,1) hl.OutlineTransparency=0 hl.Parent=pp.Character ST.espList[pp.UserId]=hl end end else for id,hl in pairs(ST.espList) do if hl and hl.Parent then hl:Destroy() end ST.espList[id]=nil end end ntf("ESP",ST.esp and "ON" or "OFF")
elseif inp2.KeyCode==CFG.GodModeKey then safeFire("godmode",1) ntf("GodMode","Sent")
elseif inp2.KeyCode==CFG.InvisibleKey then
ST.invisible=not ST.invisible
if ST.invisible then for _,p in pairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") or p:IsA("MeshPart") or p:IsA("Part") then p.Transparency=1 end end else for _,p in pairs(LP.Character:GetDescendants()) do if (p:IsA("BasePart") or p:IsA("MeshPart") or p:IsA("Part")) and p.Name~="HumanoidRootPart" then p.Transparency=0 end end end ntf("Invis",ST.invisible and "ON" or "OFF")
end
end)

-- MS BIND FOR CLICK TP
A.MS.Button1Down:Connect(function() if ST.clickTP and LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h and A.MS.Hit then h.CFrame=CFrame.new(A.MS.Hit.Position+Vector3.new(0,3,0)) end end end)

-- UPDATE LOOPS
R.RenderStepped:Connect(function()
-- FLY
if ST.fly and LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h then h.Velocity=Vector3.new(0,0,0) h.RotVelocity=Vector3.new(0,0,0) local dir=Vector3.new(0,0,0) if A.U:IsKeyDown(Enum.KeyCode.W) then dir=dir+CAM.CFrame.LookVector end if A.U:IsKeyDown(Enum.KeyCode.S) then dir=dir-CAM.CFrame.LookVector end if A.U:IsKeyDown(Enum.KeyCode.A) then dir=dir-CAM.CFrame.RightVector end if A.U:IsKeyDown(Enum.KeyCode.D) then dir=dir+CAM.CFrame.RightVector end if A.U:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end if A.U:IsKeyDown(Enum.KeyCode.LeftShift) then dir=dir-Vector3.new(0,1,0) end if dir.Magnitude>0 then dir=dir.Unit end h.CFrame=h.CFrame+dir*ST.flySpeed*R.RenderStepped:Wait() end end
-- NOCLIP
if ST.noclip and LP.Character then for _,p in pairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
-- DISTANCE LABELS
if ST.nameTags then for id,bg in pairs(ST.nameTagList) do if bg and bg.Parent then local plr=P:GetPlayerFromCharacter(bg.Adornee and bg.Adornee.Parent) if plr and plr.Character then local hd=plr.Character:FindFirstChild("Head") if hd and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then local dist=(LP.Character.HumanoidRootPart.Position-hd.Position).Magnitude local dl=bg:FindFirstChildOfClass("Frame") and bg:FindFirstChildOfClass("Frame"):FindFirstChildOfClass("TextLabel") or nil -- search deeper for dist label for _,c in pairs(bg:GetDescendants()) do if c:IsA("TextLabel") and c.Text:find("[") then if dist<50 then c.Text="["..math.floor(dist).."m CLOSE]" c.TextColor3=Color3.fromRGB(255,100,100) elseif dist<200 then c.Text="["..math.floor(dist).."m]" c.TextColor3=Color3.fromRGB(255,255,100) else c.Text="["..math.floor(dist).."m FAR]" c.TextColor3=Color3.fromRGB(100,100,255) end end end
local hp=plr.Character:FindFirstChildOfClass("Humanoid") if hp then for _,c in pairs(bg:GetDescendants()) do if c:IsA("TextLabel") and c.Text:find("HP:") then c.Text="HP:"..math.floor(hp.Health).."/"..math.floor(hp.MaxHealth) if hp.Health/hp.MaxHealth>0.6 then c.TextColor3=Color3.fromRGB(100,255,100) elseif hp.Health/hp.MaxHealth>0.3 then c.TextColor3=Color3.fromRGB(255,255,100) else c.TextColor3=Color3.fromRGB(255,100,100) end end end end end end end
end end
end)

-- ESP AUTO UPDATE
P.PlayerAdded:Connect(function(pp) pp.CharacterAdded:Connect(function(ch) wait(1) if ST.esp and pp~=LP then local hl=Instance.new("Highlight") hl.Name="ESP_HL" hl.FillColor=CFG.ESPColor hl.FillTransparency=CFG.ESPFillAlpha hl.OutlineColor=Color3.new(1,1,1) hl.OutlineTransparency=0 hl.Parent=ch ST.espList[pp.UserId]=hl end end end)
P.PlayerRemoving:Connect(function(pp) if ST.espList[pp.UserId] then ST.espList[pp.UserId]:Destroy() ST.espList[pp.UserId]=nil end if ST.nameTagList[pp.UserId] then ST.nameTagList[pp.UserId]:Destroy() ST.nameTagList[pp.UserId]=nil end end)
log("Part 3: Features + Events loaded")
end)
if not ok then print("[A] ERROR Part3: "..tostring(err)) end
