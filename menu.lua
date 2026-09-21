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
local ST = {menuOpen=false,fly=false,noclip=false,clickTP=false,esp=false,nameTags=false,spectating=nil,selectedPlayer=nil,flySpeed=50,night=false,bright=false,noFog=false,invisible=false,espList={},nameTagList={}}
local CFG = {MenuKey=Enum.KeyCode.F4,ESPKey=Enum.KeyCode.F9,ESPColor=Color3.fromRGB(255,0,0),ESPFillAlpha=0.5}
local cP = Color3.fromRGB(15,15,25)
local cS = Color3.fromRGB(22,22,40)
local cB = Color3.fromRGB(30,30,50)
local cBH = Color3.fromRGB(50,50,80)
local cT = Color3.fromRGB(200,200,220)
local cA = Color3.fromRGB(100,100,255)
local function tw(o,p,d)
    local t = TW:Create(o, TweenInfo.new(d or 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), p)
    t:Play()
    return t
end
local function sep(p)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-10,0,1)
    f.BackgroundColor3 = Color3.fromRGB(40,40,60)
    f.BorderSizePixel = 0
    f.Parent = p
end
local function lbl(p,t)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-10,0,22)
    l.BackgroundTransparency = 1
    l.Text = t
    l.TextColor3 = cA
    l.TextSize = 12
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = p
end
local function btn(p,t,fn)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-10,0,30)
    b.BackgroundColor3 = cB
    b.BorderSizePixel = 0
    b.Text = "  "..t
    b.TextColor3 = cT
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = p
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,6)
    b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=cBH},0.15) end)
    b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=cB},0.15) end)
    b.MouseButton1Click:Connect(function() pcall(fn) end)
    return b
end
local function tog(p,t,gf,fn)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-10,0,30)
    b.BackgroundColor3 = cB
    b.BorderSizePixel = 0
    local st = gf()
    b.Text = "  "..t..": "..(st and "ON" or "OFF")
    b.TextColor3 = st and Color3.fromRGB(100,255,100) or cT
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = p
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,6)
    b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=cBH},0.15) end)
    b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=cB},0.15) end)
    b.MouseButton1Click:Connect(function()
        fn()
        local s = gf()
        b.Text = "  "..t..": "..(s and "ON" or "OFF")
        b.TextColor3 = s and Color3.fromRGB(100,255,100) or cT
    end)
    return b
end
local function ntf(t,x,d)
    pcall(function() S:SetCore("SendNotification",{Title=t,Text=x,Duration=d or 3}) end)
end
print("[Axynth] Helpers OK")
local SG = Instance.new("ScreenGui")
SG.Name = "AxynthMenu"
SG.ResetOnSpawn = false
SG.DisplayOrder = 1
pcall(function() SG.Parent = CG end)
if not SG.Parent then SG.Parent = LP:WaitForChild("PlayerGui") end
local MF = Instance.new("Frame")
MF.Size = UDim2.new(0,560,0,500)
MF.Position = UDim2.new(0.5,-280,0.5,-250)
MF.BackgroundColor3 = cP
MF.BorderSizePixel = 0
MF.Active = true
MF.Draggable = true
MF.Visible = false
MF.Parent = SG
MF.ClipsDescendants = true
Instance.new("UICorner",MF).CornerRadius = UDim.new(0,12)
local TB = Instance.new("Frame")
TB.Size = UDim2.new(1,0,0,35)
TB.BackgroundColor3 = cS
TB.BorderSizePixel = 0
TB.Parent = MF
local TL = Instance.new("TextLabel")
TL.Size = UDim2.new(1,-50,1,0)
TL.BackgroundTransparency = 1
TL.Text = "AXYNTH"
TL.TextColor3 = cA
TL.TextSize = 16
TL.Font = Enum.Font.GothamBold
TL.TextXAlignment = Enum.TextXAlignment.Left
TL.Parent = TB
TL.Position = UDim2.new(0,12,0,0)
local XBtn = Instance.new("TextButton")
XBtn.Size = UDim2.new(0,30,0,30)
XBtn.Position = UDim2.new(1,-35,0,2)
XBtn.BackgroundTransparency = 1
XBtn.Text = "X"
XBtn.TextColor3 = Color3.fromRGB(200,80,80)
XBtn.TextSize = 18
XBtn.Font = Enum.Font.GothamBold
XBtn.Parent = TB
XBtn.MouseButton1Click:Connect(function() ST.menuOpen = false MF.Visible = false end)
local CFB = Instance.new("Frame")
CFB.Size = UDim2.new(1,0,0,35)
CFB.Position = UDim2.new(0,0,0,35)
CFB.BackgroundColor3 = Color3.fromRGB(18,18,30)
CFB.BorderSizePixel = 0
CFB.Parent = MF
print("[Axynth] GUI OK")
local tabs = {}
local tF = {}
local tNames = {{"move","Move"},{"world","World"},{"plr","Players"},{"fun","Fun"},{"troll","Troll"},{"misc","Misc"},{"set","Settings"}}
for i, n in pairs(tNames) do
    local f = Instance.new("TextButton")
    f.Size = UDim2.new(0,72,0,30)
    f.Position = UDim2.new(0,(i-1)*76+2,0,2)
    f.BackgroundColor3 = cP
    f.BorderSizePixel = 0
    f.Text = n[2]
    f.TextColor3 = cT
    f.TextSize = 9
    f.Font = Enum.Font.GothamBold
    f.Parent = CFB
    Instance.new("UICorner",f).CornerRadius = UDim.new(0,6)
    local fr = Instance.new("ScrollingFrame")
    fr.Size = UDim2.new(1,-10,1,-75)
    fr.Position = UDim2.new(0,5,0,72)
    fr.BackgroundTransparency = 1
    fr.BorderSizePixel = 0
    fr.ScrollBarThickness = 4
    fr.CanvasSize = UDim2.new(0,0,0,0)
    fr.Visible = false
    fr.Parent = MF
    fr.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout",fr).Padding = UDim.new(0,3)
    Instance.new("UIPadding",fr).PaddingTop = UDim.new(0,2)
    tabs[n[1]] = {btn=f, frame=fr}
    tF[n[1]] = fr
    f.MouseButton1Click:Connect(function()
        for _, v in pairs(tabs) do
            v.frame.Visible = false
            v.btn.BackgroundColor3 = cP
            v.btn.TextColor3 = cT
        end
        fr.Visible = true
        f.BackgroundColor3 = cA
        f.TextColor3 = Color3.new(1,1,1)
    end)
end
tabs["move"].frame.Visible = true
tabs["move"].btn.BackgroundColor3 = cA
tabs["move"].btn.TextColor3 = Color3.new(1,1,1)
print("[Axynth] Tabs OK")
local tM = tF["move"]
lbl(tM, ">> SPEED")
btn(tM, "Speed 100", function() if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = 100 end end end)
btn(tM, "Speed 500", function() if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = 500 end end end)
btn(tM, "Speed Reset", function() if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = 16 end end end)
btn(tM, "Jump 100", function() if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower = true h.JumpPower = 100 end end end)
btn(tM, "Jump 500", function() if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower = true h.JumpPower = 500 end end end)
btn(tM, "Jump Reset", function() if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower = true h.JumpPower = 50 end end end)
sep(tM)
lbl(tM, ">> FLY")
tog(tM, "Fly", function() return ST.fly end, function()
    ST.fly = not ST.fly
    if not ST.fly and LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.PlatformStand = false end
    end
end)
sep(tM)
lbl(tM, ">> NOCLIP")
tog(tM, "Noclip", function() return ST.noclip end, function() ST.noclip = not ST.noclip end)
sep(tM)
lbl(tM, ">> TELEPORT")
tog(tM, "Click TP", function() return ST.clickTP end, function() ST.clickTP = not ST.clickTP ntf("ClickTP", ST.clickTP and "ON" or "OFF") end)
btn(tM, "TP Cursor", function() if LP.Character then local h = LP.Character:FindFirstChild("HumanoidRootPart") if h and MS.Hit then h.CFrame = CFrame.new(MS.Hit.Position + Vector3.new(0,3,0)) end end end)
btn(tM, "TP Forward 100", function() if LP.Character then local h = LP.Character:FindFirstChild("HumanoidRootPart") if h then h.CFrame = h.CFrame + CAM.CFrame.LookVector * 100 end end end)
btn(tM, "TP Up 50", function() if LP.Character then local h = LP.Character:FindFirstChild("HumanoidRootPart") if h then h.CFrame = h.CFrame + Vector3.new(0,50,0) end end end)
btn(tM, "TP Down 50", function() if LP.Character then local h = LP.Character:FindFirstChild("HumanoidRootPart") if h then h.CFrame = h.CFrame + Vector3.new(0,-50,0) end end end)
local tW = tF["world"]
tog(tW, "Night", function() return ST.night end, function() ST.night = not ST.night if ST.night then L.ClockTime = 0 else L.ClockTime = 14 end end)
tog(tW, "Fullbright", function() return ST.bright end, function() ST.bright = not ST.bright if ST.bright then L.Brightness = 2 L.GlobalShadows = false else L.Brightness = 1 L.GlobalShadows = true end end)
tog(tW, "No Fog", function() return ST.noFog end, function() ST.noFog = not ST.noFog if ST.noFog then L.FogEnd = 999999 else L.FogEnd = 100000 end end)
local tP = tF["plr"]
lbl(tP, ">> SELECT PLAYER")
local pDropBtn = Instance.new("TextButton")
pDropBtn.Size = UDim2.new(1,-10,0,30)
pDropBtn.BackgroundColor3 = cB
pDropBtn.BorderSizePixel = 0
pDropBtn.Text = "  Click to select..."
pDropBtn.TextColor3 = cT
pDropBtn.TextSize = 12
pDropBtn.Font = Enum.Font.GothamBold
pDropBtn.TextXAlignment = Enum.TextXAlignment.Left
pDropBtn.Parent = tP
Instance.new("UICorner",pDropBtn).CornerRadius = UDim.new(0,6)
local pDropOpen = false
local pDropdown = nil
pDropBtn.MouseButton1Click:Connect(function()
    pDropOpen = not pDropOpen
    if pDropOpen then
        if pDropdown then pDropdown:Destroy() end
        pDropdown = Instance.new("ScrollingFrame")
        pDropdown.Size = UDim2.new(1,-10,0,150)
        pDropdown.Position = UDim2.new(0,5,0,32)
        pDropdown.BackgroundColor3 = cS
        pDropdown.BorderSizePixel = 0
        pDropdown.ScrollBarThickness = 4
        pDropdown.Parent = tP
        Instance.new("UICorner",pDropdown).CornerRadius = UDim.new(0,6)
        Instance.new("UIListLayout",pDropdown).Padding = UDim.new(0,2)
        local pl = P:GetPlayers()
        pDropdown.CanvasSize = UDim2.new(0,0,0,#pl*28)
        for _, pp in pairs(pl) do
            if pp ~= LP then
                local o = Instance.new("TextButton")
                o.Size = UDim2.new(1,-4,0,26)
                o.BackgroundColor3 = cP
                o.BorderSizePixel = 0
                o.Text = "  "..pp.DisplayName
                o.TextColor3 = cT
                o.TextXAlignment = Enum.TextXAlignment.Left
                o.TextSize = 12
                o.Font = Enum.Font.Gotham
                o.Parent = pDropdown
                Instance.new("UICorner",o).CornerRadius = UDim.new(0,4)
                o.MouseButton1Click:Connect(function()
                    ST.selectedPlayer = pp
                    pDropBtn.Text = "  > "..pp.DisplayName
                    pDropOpen = false
                    if pDropdown then pDropdown:Destroy() pDropdown = nil end
                end)
            end
        end
    else
        if pDropdown then pDropdown:Destroy() pDropdown = nil end
    end
end)
btn(tP, "Refresh", function() pDropBtn.Text = "  Click to select..." ST.selectedPlayer = nil end)
sep(tP)
lbl(tP, ">> ACTIONS")
btn(tP, "Goto", function() if ST.selectedPlayer and ST.selectedPlayer.Character and LP.Character then local t2 = ST.selectedPlayer.Character:FindFirstChild("HumanoidRootPart") local m = LP.Character:FindFirstChild("HumanoidRootPart") if t2 and m then m.CFrame = t2.CFrame + Vector3.new(3,0,0) end end end)
btn(tP, "Bring", function() if ST.selectedPlayer then sf("bring", ST.selectedPlayer.Name) end end)
btn(tP, "Freeze", function() if ST.selectedPlayer then sf("freeze", ST.selectedPlayer.Name) end end)
btn(tP, "Unfreeze", function() if ST.selectedPlayer then sf("unfreeze", ST.selectedPlayer.Name) end end)
btn(tP, "Kill", function() if ST.selectedPlayer then sf("kill", ST.selectedPlayer.Name) end end)
btn(tP, "Heal", function() if ST.selectedPlayer then sf("heal", ST.selectedPlayer.Name) end end)
btn(tP, "Jail", function() if ST.selectedPlayer then sf("jail", ST.selectedPlayer.Name) end end)
btn(tP, "Unjail", function() if ST.selectedPlayer then sf("unjail", ST.selectedPlayer.Name) end end)
sep(tP)
lbl(tP, ">> SPECTATE")
btn(tP, "Spectate", function() if ST.selectedPlayer and ST.selectedPlayer.Character then local h = ST.selectedPlayer.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject = h CAM.CameraType = Enum.CameraType.Custom ST.spectating = ST.selectedPlayer end end end)
btn(tP, "Stop Spec", function() if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject = h end CAM.CameraType = Enum.CameraType.Custom ST.spectating = nil end end)
sep(tP)
lbl(tP, ">> ESP")
tog(tP, "ESP", function() return ST.esp end, function()
    ST.esp = not ST.esp
    if ST.esp then
        for _, pp in pairs(P:GetPlayers()) do
            if pp ~= LP and pp.Character and not pp.Character:FindFirstChild("AxESP") then
                local hl = Instance.new("Highlight")
                hl.Name = "AxESP"
                hl.FillColor = CFG.ESPColor
                hl.FillTransparency = CFG.ESPFillAlpha
                hl.OutlineColor = Color3.new(1,1,1)
                hl.OutlineTransparency = 0
                hl.Parent = pp.Character
                ST.espList[pp.UserId] = hl
            end
        end
    else
        for id, hl in pairs(ST.espList) do
            if hl and hl.Parent then hl:Destroy() end
            ST.espList[id] = nil
        end
    end
end)
local tFu = tF["fun"]
lbl(tFu, ">> FUN")
btn(tFu, "Fire All", function() sf("fire",100) end)
btn(tFu, "Sparkle All", function() sf("sparkle",100) end)
btn(tFu, "Smoke All", function() sf("smoke",100) end)
btn(tFu, "Remove FX", function() sf("removefx",100) end)
btn(tFu, "Big Head All", function() sf("bighead",100) end)
btn(tFu, "Small Head All", function() sf("smallhead",100) end)
btn(tFu, "Invisible All", function() sf("invisible",100) end)
btn(tFu, "Visible All", function() sf("visible",100) end)
btn(tFu, "Spin All", function() sf("spin",100) end)
btn(tFu, "Stop Spin All", function() sf("unspin",100) end)
btn(tFu, "Bang All", function() sf("bang",100) end)
btn(tFu, "Dance All", function() sf("dance",100) end)
btn(tFu, "Sleep All", function() sf("sleep",100) end)
sep(tFu)
lbl(tFu, ">> SELF")
btn(tFu, "Self Fire", function() sf("fire",1) end)
btn(tFu, "Self Sparkle", function() sf("sparkle",1) end)
btn(tFu, "Self Dance", function() sf("dance",1) end)
btn(tFu, "Self Bang", function() sf("bang",1) end)
btn(tFu, "Self Sleep", function() sf("sleep",1) end)
btn(tFu, "Self Spin", function() sf("spin",1) end)
btn(tFu, "Self Stop Spin", function() sf("unspin",1) end)
local tTr = tF["troll"]
lbl(tTr, ">> TROLL")
btn(tTr, "Stomp All", function() sf("stomp",100) end)
btn(tTr, "Trip All", function() sf("trip",100) end)
btn(tTr, "Vibrate All", function() sf("vibrate",100) end)
btn(tTr, "Fling All", function() sf("fling",100) end)
btn(tTr, "Ragdoll All", function() sf("ragdoll",100) end)
sep(tTr)
lbl(tTr, ">> JAIL")
btn(tTr, "Jail All", function() sf("jail",100) end)
btn(tTr, "Unjail All", function() sf("unjail",100) end)
btn(tTr, "Freeze All", function() sf("freeze",100) end)
btn(tTr, "Unfreeze All", function() sf("unfreeze",100) end)
sep(tTr)
lbl(tTr, ">> MASS")
btn(tTr, "Kill All", function() sf("kill",100) end)
btn(tTr, "Heal All", function() sf("heal",100) end)
btn(tTr, "Explode All", function() sf("explode",100) end)
local tMi = tF["misc"]
lbl(tMi, ">> MISC")
btn(tMi, "Reset Character", function() if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Health = 0 end end end)
btn(tMi, "God Mode", function() sf("godmode",1) end)
btn(tMi, "Anti-AFK", function() pcall(function() LP.Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Running) end) end)
btn(tMi, "Third Person", function() pcall(function() LP.CameraMinZoomDistance = 10 LP.CameraMaxZoomDistance = 10 end) end)
btn(tMi, "First Person", function() pcall(function() LP.CameraMinZoomDistance = 0.5 LP.CameraMaxZoomDistance = 0.5 end) end)
sep(tMi)
lbl(tMi, ">> SERVER")
btn(tMi, "Full Server Kill", function() sf("kill",100) end)
btn(tMi, "Full Server Heal", function() sf("heal",100) end)
btn(tMi, "Full Server Freeze", function() sf("freeze",100) end)
btn(tMi, "Full Server Unfreeze", function() sf("unfreeze",100) end)
btn(tMi, "Full Server Jail", function() sf("jail",100) end)
btn(tMi, "Full Server Unjail", function() sf("unjail",100) end)
local tSe = tF["set"]
lbl(tSe, ">> THEME")
btn(tSe, "Blue", function() cP = Color3.fromRGB(10,15,30) cS = Color3.fromRGB(15,25,45) cB = Color3.fromRGB(20,35,60) cBH = Color3.fromRGB(30,50,80) cA = Color3.fromRGB(80,150,255) end)
btn(tSe, "Red", function() cP = Color3.fromRGB(25,10,10) cS = Color3.fromRGB(35,15,15) cB = Color3.fromRGB(50,20,20) cBH = Color3.fromRGB(70,30,30) cA = Color3.fromRGB(255,80,80) end)
btn(tSe, "Green", function() cP = Color3.fromRGB(10,25,10) cS = Color3.fromRGB(15,35,15) cB = Color3.fromRGB(20,50,20) cBH = Color3.fromRGB(30,70,30) cA = Color3.fromRGB(80,255,80) end)
sep(tSe)
lbl(tSe, ">> HOTKEYS")
btn(tSe, "Show Keys", function() ntf("Menu=F4", "Noclip=F5,ClickTP=F6,Fly=F7,ESP=F9") end)
print("[Axynth] All tabs OK")
U.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == CFG.MenuKey then
        ST.menuOpen = not ST.menuOpen
        MF.Visible = ST.menuOpen
    elseif inp.KeyCode == Enum.KeyCode.F5 then
        ST.noclip = not ST.noclip
        ntf("Noclip", ST.noclip and "ON" or "OFF")
    elseif inp.KeyCode == Enum.KeyCode.F6 then
        ST.clickTP = not ST.clickTP
        ntf("ClickTP", ST.clickTP and "ON" or "OFF")
    elseif inp.KeyCode == Enum.KeyCode.F7 then
        ST.fly = not ST.fly
        if not ST.fly and LP.Character then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then h.PlatformStand = false end
        end
        ntf("Fly", ST.fly and "ON" or "OFF")
    elseif inp.KeyCode == CFG.ESPKey then
        ST.esp = not ST.esp
        if ST.esp then
            for _, pp in pairs(P:GetPlayers()) do
                if pp ~= LP and pp.Character and not pp.Character:FindFirstChild("AxESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "AxESP"
                    hl.FillColor = CFG.ESPColor
                    hl.FillTransparency = CFG.ESPFillAlpha
                    hl.OutlineColor = Color3.new(1,1,1)
                    hl.OutlineTransparency = 0
                    hl.Parent = pp.Character
                    ST.espList[pp.UserId] = hl
                end
            end
        else
            for id, hl in pairs(ST.espList) do
                if hl and hl.Parent then hl:Destroy() end
                ST.espList[id] = nil
            end
        end
        ntf("ESP", ST.esp and "ON" or "OFF")
    end
end)
MS.Button1Down:Connect(function()
    if ST.clickTP and LP.Character then
        local h = LP.Character:FindFirstChild("HumanoidRootPart")
        if h and MS.Hit then
            h.CFrame = CFrame.new(MS.Hit.Position + Vector3.new(0,3,0))
        end
    end
end)
print("[Axynth] Events OK")
R.RenderStepped:Connect(function()
    if ST.fly and LP.Character then
        local h = LP.Character:FindFirstChild("HumanoidRootPart")
        if h then
            h.Velocity = Vector3.new(0,0,0)
            h.RotVelocity = Vector3.new(0,0,0)
            local dir = Vector3.new(0,0,0)
            if U:IsKeyDown(Enum.KeyCode.W) then dir = dir + CAM.CFrame.LookVector end
            if U:IsKeyDown(Enum.KeyCode.S) then dir = dir - CAM.CFrame.LookVector end
            if U:IsKeyDown(Enum.KeyCode.A) then dir = dir - CAM.CFrame.RightVector end
            if U:IsKeyDown(Enum.KeyCode.D) then dir = dir + CAM.CFrame.RightVector end
            if U:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
            if U:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
            if dir.Magnitude > 0 then dir = dir.Unit end
            h.CFrame = h.CFrame + dir * ST.flySpeed * R.RenderStepped:Wait()
        end
    end
    if ST.noclip and LP.Character then
        for _, p2 in pairs(LP.Character:GetDescendants()) do
            if p2:IsA("BasePart") then p2.CanCollide = false end
        end
    end
end)
P.PlayerAdded:Connect(function(pp)
    pp.CharacterAdded:Connect(function(ch)
        wait(1)
        if ST.esp and pp ~= LP then
            local hl = Instance.new("Highlight")
            hl.Name = "AxESP"
            hl.FillColor = CFG.ESPColor
            hl.FillTransparency = CFG.ESPFillAlpha
            hl.OutlineColor = Color3.new(1,1,1)
            hl.OutlineTransparency = 0
            hl.Parent = ch
            ST.espList[pp.UserId] = hl
        end
    end)
end)
P.PlayerRemoving:Connect(function(pp)
    if ST.espList[pp.UserId] then ST.espList[pp.UserId]:Destroy() ST.espList[pp.UserId] = nil end
    if ST.nameTagList[pp.UserId] then ST.nameTagList[pp.UserId]:Destroy() ST.nameTagList[pp.UserId] = nil end
end)
print("[Axynth] MENU LOADED! Press F4!")
end)
if not ok then print("[Axynth] ERROR: "..tostring(err)) end
