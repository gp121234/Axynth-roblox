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
-- ANTI-BAN SYSTEM v8 LITE - LIGHTWEIGHT + POWERFUL
local hookLog={}
local blockedKeywords={"anticheat","anti","cheat","detect","ban","kick","report","flag","log","trace","monitor","watch","scan","validate","verify","check","suspicious","abnormal","illegal","unauthorized","modified","exploit","hack","teleport","speed","noclip","fly"}
local whitelistRemotes={
    ["HDAdminHDClient.Signals.RequestCommand"]=true,
    ["HDAdminHDClient.Signals.ExecuteClientCommand"]=true,
    ["HDAdminHDClient.Signals.FireSignal"]=true,
    ["HDAdminHDClient.Signals.OnSignal"]=true,
    ["Teams.ChangeJob"]=true,
    ["efood.efoodJob"]=true,
    ["efood.acceptOrder"]=true,
    ["efood.collectedOrder"]=true,
    ["efood.deliveredOrder"]=true,
    ["Bank.TablesEvents.Prompt"]=true,
    ["Bank.TablesEvents.Leave"]=true,
    ["Bank.TablesEvents.Grab"]=true,
    ["Bank.Lockpick.Vault"]=true,
    ["Bank.Lockpick.Lock"]=true,
    ["Bank.Lockpick.Lock2"]=true,
    ["Bank.Lockpick.Vault2"]=true,
    ["NoclipEvent"]=true,
    ["ToggleSirenEvent"]=true,
    ["Crosshairs.ApplyCrosshair"]=true,
    ["Cars.CarDealer"]=true,
    ["Inventory.Inventory"]=true,
    ["Chat"]=true,
    ["CreateMafia.RemoteEvent"]=true,
    ["ThiefSystem.RemoteEvent"]=true,
    ["Armory.RemoteEvent"]=true,
    ["Hospital.EKAB"]=true,
    ["SupermarketEvent.AcceptJob"]=true,
    ["SupermarketEvent.FinishJob"]=true,
    ["SupermarketEvent.BuyItem"]=true,
    ["WeaponsSystem.Network.WeaponFired"]=true,
    ["WeaponsSystem.Network.WeaponHit"]=true,
    ["WeaponsSystem.Network.WeaponReloadRequest"]=true,
    ["ClaimEvent"]=true,
}
local isUsingExploit=false
local function isBlocked(name)
    if whitelistRemotes[name] then return false end
    local lower=name:lower()
    for _,kw in pairs(blockedKeywords) do
        if lower:find(kw) then return true end
    end
    return false
end
local function isWhitelisted(name)
    return whitelistRemotes[name]==true
end
local function randomDelay()
    return math.random(100,400)/1000
end
pcall(function()
    local oldNC
    oldNC = hookmetamethod(game,"__namecall",newcclosure(function(self,...)
        local method=getnamecallmethod()
        local args={...}
        if (method=="FireServer" or method=="InvokeServer") and self:IsA("RemoteEvent") then
            if isBlocked(self.Name) and not isWhitelisted(self.Name) then
                table.insert(hookLog,{time=tick(),remote=self.Name,blocked=true})
                return nil
            end
            if isUsingExploit and not isWhitelisted(self.Name) then
                task.delay(randomDelay(),function()
                    oldNC(self,unpack(args))
                end)
                return nil
            end
        end
        return oldNC(self,unpack(args))
    end))
end)
pcall(function()
    local mt=getrawmetatable(game)
    local oldNC=mt.__namecall
    local oldIdx=mt.__index
    local oldNew=mt.__newindex
    setreadonly(mt,false)
    mt.__namecall=newcclosure(function(self,...)
        local method=getnamecallmethod()
        local args={...}
        if (method=="FireServer" or method=="InvokeServer") and self:IsA("RemoteEvent") then
            if isBlocked(self.Name) and not isWhitelisted(self.Name) then
                return nil
            end
            if isUsingExploit and not isWhitelisted(self.Name) then
                task.delay(randomDelay(),function()
                    oldNC(self,unpack(args))
                end)
                return nil
            end
        end
        return oldNC(self,unpack(args))
    end)
    mt.__index=newcclosure(function(self,key)
        if typeof(self)=="Instance" and self:IsA("Humanoid") then
            if key=="WalkSpeed" then
                local val=oldIdx(self,key)
                if val>50 then return 16 end
                return val
            end
            if key=="JumpPower" then
                local val=oldIdx(self,key)
                if val>100 then return 50 end
                return val
            end
        end
        return oldIdx(self,key)
    end)
    mt.__newindex=newcclosure(function(self,key,value)
        if typeof(self)=="Instance" and self:IsA("Humanoid") then
            if key=="WalkSpeed" and value>50 then return oldNew(self,key,16) end
            if key=="JumpPower" and value>100 then return oldNew(self,key,50) end
        end
        return oldNew(self,key,value)
    end)
    setreadonly(mt,true)
end)
pcall(function()
    local oldGetService
    oldGetService = hookfunction(game.GetService,function(self,service)
        local s=service:lower()
        if s:find("anticheat") or s:find("detector") or s:find("cheat") then
            return nil
        end
        return oldGetService(self,service)
    end)
end)
pcall(function()
    local oldFFI=Instance.new("Workspace").FindFirstChild
    hookfunction(Instance.new("Workspace").FindFirstChild,function(self,name,recursive)
        if self==workspace and name then
            local n=name:lower()
            if n:find("anticheat") or n:find("detector") or n:find("trigger") or n:find("cheat") then
                return nil
            end
        end
        return oldFFI(self,name,recursive)
    end)
end)
pcall(function()
    local oldFire=Instance.new("RemoteEvent").FireServer
    hookfunction(Instance.new("RemoteEvent").FireServer,function(self,...)
        local args={...}
        if self and self:IsA("RemoteEvent") then
            if isBlocked(self.Name) and not isWhitelisted(self.Name) then
                return nil
            end
            if isUsingExploit and not isWhitelisted(self.Name) then
                task.delay(randomDelay(),function()
                    oldFire(self,unpack(args))
                end)
                return nil
            end
        end
        return oldFire(self,unpack(args))
    end)
end)
pcall(function()
    local oldInvoke=Instance.new("RemoteFunction").InvokeServer
    hookfunction(Instance.new("RemoteFunction").InvokeServer,function(self,...)
        local args={...}
        if self and self:IsA("RemoteFunction") then
            if isBlocked(self.Name) and not isWhitelisted(self.Name) then
                return nil
            end
            if isUsingExploit and not isWhitelisted(self.Name) then
                task.delay(randomDelay(),function()
                    oldInvoke(self,unpack(args))
                end)
                return nil
            end
        end
        return oldInvoke(self,unpack(args))
    end)
end)
pcall(function()
    LP.CharacterAdded:Connect(function(char)
        task.wait(1)
        pcall(function()
            local h=char:FindFirstChildOfClass("Humanoid")
            if h then
                if h.WalkSpeed>50 then h.WalkSpeed=16 end
                if h.JumpPower>100 then h.JumpPower=50 end
            end
        end)
    end)
end)
print("[Axynth] Anti-Ban v8 LITE ACTIVE | Hooks: 8 | No FPS impact")
local AR = RS:FindFirstChild("AdminRemote")
if not AR then AR = Instance.new("RemoteEvent") AR.Name = "AdminRemote" AR.Parent = RS end
pcall(function()
    AR.Name = "HDAdminRemote"
    AR:GetPropertyChangedSignal("Name"):Connect(function()
        AR.Name = "HDAdminRemote"
    end)
end)
local decoyRemotes={"ClientReplicator","CharacterReplicator","PlayerReplicator","DataReplicator"}
for _,name in pairs(decoyRemotes) do
    pcall(function()
        local d=Instance.new("RemoteEvent")
        d.Name=name
        d.Parent=RS
    end)
end
local function fakeDecoy()
    pcall(function()
        for _,r in pairs(decoyRemotes) do
            local remote=RS:FindFirstChild(r)
            if remote and remote:IsA("RemoteEvent") then
                remote:FireServer("ping",math.random(1,100),math.random(1,100))
            end
        end
    end)
end
local function hideExploitObjects()
    pcall(function()
        if LP.Character then
            for _,v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("BodyMover") or v:IsA("BodyAngularVelocity") or v:IsA("BodyPosition") or v:IsA("BodyVelocity") or v:IsA("BodyGyro") or v:IsA("BodyForce") or v:IsA("BodyThrust") then
                    if v.Name:find("Ax") then
                        v.Parent=nil
                    end
                end
            end
        end
    end)
end
local function spoofNetworkStats()
    pcall(function()
        local stats=game:GetService("Stats")
        if stats then
            local network=stats:FindFirstChild("Network")
            if network then
                local ping=network:FindFirstChild("DataPing")
                if ping then
                    if ping.Value>200 then ping.Value=math.random(30,80) end
                end
            end
        end
    end)
end
local function spoofCharacterModel()
    pcall(function()
        if LP.Character then
            local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local vel=hrp.Velocity
                if vel.Magnitude>100 then
                    hrp.Velocity=Vector3.new(0,0,0)
                    hrp.RotVelocity=Vector3.new(0,0,0)
                end
            end
        end
    end)
end
local function fakeNormalActivity()
    pcall(function()
        if LP.Character then
            local h=LP.Character:FindFirstChildOfClass("Humanoid")
            if h then
                if math.random(1,100)>90 then
                    h:MoveTo(LP.Character.HumanoidRootPart.Position+Vector3.new(math.random(-5,5),0,math.random(-5,5)))
                end
            end
        end
    end)
end
local actionQueue={}
local function queueAction(fn)
    table.insert(actionQueue,fn)
end
local function processQueue()
    if #actionQueue>0 then
        local fn=table.remove(actionQueue,1)
        fn()
    end
end
local function sf(a, ...) local args = {...} spawn(function() isUsingExploit=true wait(math.random(30,100)/1000) pcall(function()
    if AR.Name~="HDAdminRemote" then AR.Name="HDAdminRemote" end
    local enc=a.."\0"..table.concat(args,"\0")
    local fake1=string.char(math.random(65,90))..string.char(math.random(97,122))..math.random(100,999)
    local fake2=string.char(math.random(65,90))..math.random(1000,9999)
    AR:FireServer(a, unpack(args))
end) isUsingExploit=false end) end
local function spoofExecutor()
    pcall(function()
        if getgenv then
            local g=getgenv()
            g.AxynthLoaded=true
            g.Executor=nil
            g.exploit=nil
            g.syn=nil
            g.krnl=nil
            g.fluxus=nil
            g.electron=nil
            g.scriptware=nil
        end
    end)
    pcall(function()
        if getfenv then
            local env=getfenv()
            env.identifyexecutor=function() return "RobloxStudio","2.0" end
            env.getexecutorname=function() return "RobloxStudio" end
            env.is_synapse_function=function() return false end
            env.islclosure=function() return false end
            env.iscclosure=function() return true end
        end
    end)
end
pcall(spoofExecutor)
local function spoofStats()
    pcall(function()
        local s=game:GetService("Stats")
        if s then
            for _,v in pairs(s:GetDescendants()) do
                if v:IsA("IntValue") or v:IsA("NumberValue") then
                    if v.Name:lower():find("cpu") or v.Name:lower():find("memory") then
                        if v.Value>100 then v.Value=math.random(10,50) end
                    end
                end
            end
        end
    end)
end
pcall(function()
    R.RenderStepped:Connect(function()
        spoofStats()
    end)
end)
local lastAction=0
local function cd() local now=tick() if now-lastAction<3 then ntf("Cooldown","Wait "..string.format("%.1f",3-(now-lastAction)).."s") return false end lastAction=now return true end
local ST = {menuOpen=false,fly=false,noclip=false,clickTP=false,esp=false,spectating=nil,selectedPlayer=nil,flySpeed=50,night=false,bright=false,noFog=false,invisible=false,espList={}}
local CFG = {ESPColor=Color3.fromRGB(255,0,0),ESPFillAlpha=0.5}
local TH = {p=Color3.fromRGB(18,18,32),s=Color3.fromRGB(24,24,44),b=Color3.fromRGB(35,35,60),bh=Color3.fromRGB(55,55,85),t=Color3.fromRGB(210,210,230),a=Color3.fromRGB(120,120,255),g=Color3.fromRGB(80,255,120),r=Color3.fromRGB(255,80,80)}
local KB = {}
local waitingForKey = nil
local togUpdates={}
local function tw(o,p,d) local t=TW:Create(o,TweenInfo.new(d or 0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),p) t:Play() return t end
local function twFast(o,p,d) local t=TW:Create(o,TweenInfo.new(d or 0.15,Enum.EasingStyle.Back,Enum.EasingDirection.Out),p) t:Play() return t end
local function mkCorner(p,r) local c=Instance.new("UICorner",p) c.CornerRadius=UDim.new(0,r or 8) return c end
local function mkStroke(p,c,w) local s=Instance.new("UIStroke",p) s.Color=c or Color3.fromRGB(60,60,90) s.Thickness=w or 1 s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border return s end
local function mkPadding(p,t,b,l,r2) local pd=Instance.new("UIPadding",p) pd.PaddingTop=UDim.new(0,t or 4) pd.PaddingBottom=UDim.new(0,b or 4) pd.PaddingLeft=UDim.new(0,l or 6) pd.PaddingRight=UDim.new(0,r2 or 6) return pd end
local function sep(p) local f=Instance.new("Frame") f.Size=UDim2.new(1,-12,0,1) f.Position=UDim2.new(0,6,0,0) f.BackgroundColor3=Color3.fromRGB(50,50,75) f.BorderSizePixel=0 f.Parent=p end
local function lbl(p,t) local l=Instance.new("TextLabel") l.Size=UDim2.new(1,-12,0,24) l.Position=UDim2.new(0,6,0,0) l.BackgroundTransparency=1 l.Text=t l.TextColor3=TH.a l.TextSize=13 l.Font=Enum.Font.GothamBold l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=p return l end
local function ntf(t,x,d) pcall(function() S:SetCore("SendNotification",{Title=t,Text=x,Duration=d or 3}) end) end
local function getKeyDisplay(key) if not key then return "NONE" end local s=tostring(key) s=s:gsub("Enum.KeyCode.","") s=s:gsub("Enum.UserInputType.","") return s end
local function findRemote(name) return RS:FindFirstChild(name) end
local function btn(p,t,fn,id)
    local b=Instance.new("TextButton") b.Size=UDim2.new(1,-12,0,34) b.Position=UDim2.new(0,6,0,0) b.BackgroundColor3=TH.b b.BorderSizePixel=0 b.Text="  "..t b.TextColor3=TH.t b.TextSize=13 b.Font=Enum.Font.GothamMedium b.TextXAlignment=Enum.TextXAlignment.Left b.Parent=p
    mkCorner(b,6) mkStroke(b,Color3.fromRGB(60,60,90),1)
    local kbBtn=Instance.new("TextButton") kbBtn.Size=UDim2.new(0,40,0,22) kbBtn.Position=UDim2.new(1,-48,0,6) kbBtn.BackgroundColor3=TH.p kbBtn.BorderSizePixel=0 kbBtn.Text=getKeyDisplay(KB[id]) kbBtn.TextColor3=TH.a kbBtn.TextSize=9 kbBtn.Font=Enum.Font.GothamBold kbBtn.Parent=b mkCorner(kbBtn,4) mkStroke(kbBtn,TH.a,1)
    kbBtn.MouseButton1Click:Connect(function() waitingForKey=id kbBtn.Text="..." kbBtn.TextColor3=TH.r ntf("Keybind","Press any key for: "..t,5) end)
    b.MouseEnter:Connect(function() twFast(b,{BackgroundColor3=TH.bh,TextColor3=Color3.new(1,1,1)}) end)
    b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=TH.b,TextColor3=TH.t},0.2) end)
    b.MouseButton1Click:Connect(function() twFast(b,{BackgroundColor3=TH.a},0.08) wait(0.08) tw(b,{BackgroundColor3=TH.bh},0.15) pcall(fn) end)
    return b
end
local function tog(p,t,gf,fn,id)
    local b=Instance.new("TextButton") b.Size=UDim2.new(1,-12,0,34) b.Position=UDim2.new(0,6,0,0) b.BackgroundColor3=TH.b b.BorderSizePixel=0
    local st=gf() b.Text="  "..t..": "..(st and "ON" or "OFF") b.TextColor3=st and TH.g or TH.t b.TextSize=13 b.Font=Enum.Font.GothamMedium b.TextXAlignment=Enum.TextXAlignment.Left b.Parent=p
    mkCorner(b,6) mkStroke(b,st and TH.g or Color3.fromRGB(60,60,90),1)
    local kbBtn=Instance.new("TextButton") kbBtn.Size=UDim2.new(0,40,0,22) kbBtn.Position=UDim2.new(1,-48,0,6) kbBtn.BackgroundColor3=TH.p kbBtn.BorderSizePixel=0 kbBtn.Text=getKeyDisplay(KB[id]) kbBtn.TextColor3=TH.a kbBtn.TextSize=9 kbBtn.Font=Enum.Font.GothamBold kbBtn.Parent=b mkCorner(kbBtn,4) mkStroke(kbBtn,TH.a,1)
    kbBtn.MouseButton1Click:Connect(function() waitingForKey=id kbBtn.Text="..." kbBtn.TextColor3=TH.r ntf("Keybind","Press any key for: "..t,5) end)
    b.MouseEnter:Connect(function() twFast(b,{BackgroundColor3=TH.bh}) end)
    b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=TH.b},0.2) end)
    b.MouseButton1Click:Connect(function() twFast(b,{BackgroundColor3=TH.a},0.08) wait(0.08) fn() local s=gf() tw(b,{BackgroundColor3=s and Color3.fromRGB(30,60,30) or TH.b},0.15) b.Text="  "..t..": "..(s and "ON" or "OFF") b.TextColor3=s and TH.g or TH.t pcall(function() b.UIStroke.Color=s and TH.g or Color3.fromRGB(60,60,90) end) end)
    local updateFn=function() local s=gf() b.Text="  "..t..": "..(s and "ON" or "OFF") b.TextColor3=s and TH.g or TH.t pcall(function() b.UIStroke.Color=s and TH.g or Color3.fromRGB(60,60,90) end) kbBtn.Text=getKeyDisplay(KB[id]) end
    togUpdates[b]=updateFn
    return b
end
print("[Axynth] Helpers OK")
local SG=Instance.new("ScreenGui") SG.Name="AxynthMenu" SG.ResetOnSpawn=false SG.DisplayOrder=1
pcall(function() SG.Parent=CG end) if not SG.Parent then SG.Parent=LP:WaitForChild("PlayerGui") end
local MF=Instance.new("Frame") MF.Size=UDim2.new(0,520,0,480) MF.Position=UDim2.new(0.5,-260,0.5,-240) MF.BackgroundColor3=TH.p MF.BackgroundTransparency=1 MF.BorderSizePixel=0 MF.Active=true MF.Draggable=true MF.Visible=false MF.Parent=SG MF.ClipsDescendants=true mkCorner(MF,12) mkStroke(MF,TH.a,2)
local TB=Instance.new("Frame") TB.Size=UDim2.new(1,0,0,40) TB.BackgroundColor3=TH.s TB.BorderSizePixel=0 TB.Parent=TB mkCorner(TB,12) TB.Parent=MF
local TL=Instance.new("TextLabel") TL.Size=UDim2.new(1,-50,1,0) TL.Position=UDim2.new(0,16,0,0) TL.BackgroundTransparency=1 TL.Text="AXYNTH" TL.TextColor3=TH.a TL.TextSize=18 TL.Font=Enum.Font.GothamBlack TL.TextXAlignment=Enum.TextXAlignment.Left TL.Parent=TB
local XBtn=Instance.new("TextButton") XBtn.Size=UDim2.new(0,32,0,32) XBtn.Position=UDim2.new(1,-38,0,4) XBtn.BackgroundTransparency=1 XBtn.Text="X" XBtn.TextColor3=TH.r XBtn.TextSize=20 XBtn.Font=Enum.Font.GothamBold XBtn.Parent=TB
XBtn.MouseEnter:Connect(function() twFast(XBtn,{TextColor3=Color3.new(1,1,1)}) end)
XBtn.MouseLeave:Connect(function() tw(XBtn,{TextColor3=TH.r},0.2) end)
XBtn.MouseButton1Click:Connect(function() ST.menuOpen=false tw(MF,{Position=UDim2.new(0.5,-260,0.5,-280),BackgroundTransparency=1,Size=UDim2.new(0,520,0,420)},0.3) wait(0.3) MF.Visible=false MF.Position=UDim2.new(0.5,-260,0.5,-240) MF.Size=UDim2.new(0,520,0,480) MF.BackgroundTransparency=0.02 end)
local CFB=Instance.new("Frame") CFB.Size=UDim2.new(1,0,0,38) CFB.Position=UDim2.new(0,0,0,40) CFB.BackgroundColor3=Color3.fromRGB(20,20,36) CFB.BorderSizePixel=0 CFB.Parent=MF
print("[Axynth] GUI OK")
local tabs={} local tF={}
local tNames={{"home","Home"},{"world","World"},{"plr","Players"},{"fun","Fun+Troll"},{"exploit","Exploit"},{"set","Settings"}}
for i,n in pairs(tNames) do
    local f=Instance.new("TextButton") f.Size=UDim2.new(0,78,0,30) f.Position=UDim2.new(0,(i-1)*82+4,0,4) f.BackgroundColor3=TH.p f.BorderSizePixel=0 f.Text=n[2] f.TextColor3=TH.t f.TextSize=10 f.Font=Enum.Font.GothamBold f.Parent=CFB mkCorner(f,6)
    local fr=Instance.new("ScrollingFrame") fr.Size=UDim2.new(1,-16,1,-86) fr.Position=UDim2.new(0,8,0,82) fr.BackgroundTransparency=1 fr.BorderSizePixel=0 fr.ScrollBarThickness=4 fr.ScrollBarImageColor3=TH.a fr.CanvasSize=UDim2.new(0,0,0,0) fr.Visible=false fr.Parent=MF fr.AutomaticCanvasSize=Enum.AutomaticSize.Y fr.ScrollingDirection=Enum.ScrollingDirection.Y fr.ElasticBehavior=Enum.ElasticBehavior.Never fr.TopImage="rbxasset://textures/ui/Scroll/scroll-middle.png" fr.BottomImage="rbxasset://textures/ui/Scroll/scroll-middle.png"
    local layout=Instance.new("UIListLayout",fr) layout.Padding=UDim.new(0,4) layout.SortOrder=Enum.SortOrder.LayoutOrder
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() fr.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+8) end)
    mkPadding(fr,4,4,2,2)
    tabs[n[1]]={btn=f,frame=fr} tF[n[1]]=fr
    f.MouseButton1Click:Connect(function() for _,v in pairs(tabs) do v.frame.Visible=false v.btn.BackgroundColor3=TH.p v.btn.TextColor3=TH.t end fr.Visible=true tw(f,{BackgroundColor3=TH.a,TextColor3=Color3.new(1,1,1)},0.2) end)
end
tabs["home"].frame.Visible=true tw(tabs["home"].btn,{BackgroundColor3=TH.a,TextColor3=Color3.new(1,1,1)},0.2)
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
local tFC=tog(tH,"Free Cam",function() return ST.freeCam end,function() ST.freeCam=not ST.freeCam if ST.freeCam then ST.freeCamPos=CAM.CFrame CAM.CameraType=Enum.CameraType.Scriptable ntf("FreeCam","ON - WASD + Shift") else CAM.CameraType=Enum.CameraType.Custom if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h end end ntf("FreeCam","OFF") end end,"freecam")
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
local pDropBtn=Instance.new("TextButton") pDropBtn.Size=UDim2.new(1,-12,0,34) pDropBtn.Position=UDim2.new(0,6,0,0) pDropBtn.BackgroundColor3=TH.b pDropBtn.BorderSizePixel=0 pDropBtn.Text="  Click to select..." pDropBtn.TextColor3=TH.t pDropBtn.TextSize=13 pDropBtn.Font=Enum.Font.GothamMedium pDropBtn.TextXAlignment=Enum.TextXAlignment.Left pDropBtn.Parent=tP mkCorner(pDropBtn,6) mkStroke(pDropBtn,TH.a,1)
local pDropOpen=false local pDropdown=nil
pDropBtn.MouseButton1Click:Connect(function()
    pDropOpen=not pDropOpen
    if pDropOpen then
        if pDropdown then pDropdown:Destroy() end
        pDropdown=Instance.new("ScrollingFrame") pDropdown.Size=UDim2.new(1,-12,0,140) pDropdown.Position=UDim2.new(0,6,0,38) pDropdown.BackgroundColor3=TH.s pDropdown.BorderSizePixel=0 pDropdown.ScrollBarThickness=3 pDropdown.ScrollBarImageColor3=TH.a pDropdown.Parent=tP mkCorner(pDropdown,6) mkStroke(pDropdown,TH.a,1)
        Instance.new("UIListLayout",pDropdown).Padding=UDim.new(0,2) mkPadding(pDropdown,2,2,4,4)
        local pl=P:GetPlayers() pDropdown.CanvasSize=UDim2.new(0,0,0,#pl*28)
        for _,pp in pairs(pl) do if pp~=LP then local o=Instance.new("TextButton") o.Size=UDim2.new(1,-8,0,26) o.BackgroundColor3=TH.p o.BorderSizePixel=0 o.Text="  "..pp.DisplayName o.TextColor3=TH.t o.TextXAlignment=Enum.TextXAlignment.Left o.TextSize=12 o.Font=Enum.Font.Gotham o.Parent=pDropdown mkCorner(o,4)
            o.MouseEnter:Connect(function() twFast(o,{BackgroundColor3=TH.bh}) end) o.MouseLeave:Connect(function() tw(o,{BackgroundColor3=TH.p},0.2) end)
            o.MouseButton1Click:Connect(function() ST.selectedPlayer=pp pDropBtn.Text="  > "..pp.DisplayName pDropOpen=false if pDropdown then pDropdown:Destroy() pDropdown=nil end end) end end
    else if pDropdown then pDropdown:Destroy() pDropdown=nil end end
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
btn(tP,"Revive Player",function() if ST.selectedPlayer and cd() then sf("heal",ST.selectedPlayer.Name) pcall(function() local h=ST.selectedPlayer.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=h.MaxHealth h.PlatformStand=false end end) ntf("Revive",ST.selectedPlayer.Name.." revived!") end end,"revive")
btn(tP,"Explode Player",function() if ST.selectedPlayer and cd() then sf("explode",ST.selectedPlayer.Name) end end,"expl")
sep(tP)
lbl(tP,">> SPECTATE + ESP")
btn(tP,"Spectate",function() if ST.selectedPlayer and ST.selectedPlayer.Character then local h=ST.selectedPlayer.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h CAM.CameraType=Enum.CameraType.Custom ST.spectating=ST.selectedPlayer end end end,"spec")
btn(tP,"Stop Spectate",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h end CAM.CameraType=Enum.CameraType.Custom ST.spectating=nil end end,"stopspec")
local tESP=tog(tP,"ESP",function() return ST.esp end,function() ST.esp=not ST.esp if ST.esp then for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and not pp.Character:FindFirstChild("AxESP") then local hl=Instance.new("Highlight") hl.Name="AxESP" hl.FillColor=CFG.ESPColor hl.FillTransparency=CFG.ESPFillAlpha hl.OutlineColor=Color3.new(1,1,1) hl.OutlineTransparency=0 hl.Parent=pp.Character ST.espList[pp.UserId]=hl end end else for id,hl in pairs(ST.espList) do if hl and hl.Parent then hl:Destroy() end ST.espList[id]=nil end end end,"esp")
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
btn(tF2,"Self Dance",function() sf("dance",1) end,"sdance")
btn(tF2,"Self Bang",function() sf("bang",1) end,"sbang")
btn(tF2,"Self Sleep",function() sf("sleep",1) end,"ssleep")
btn(tF2,"Self Spin",function() sf("spin",1) end,"sspin")
btn(tF2,"Self Stop Spin",function() sf("unspin",1) end,"sunspin")
local tEx=tF["exploit"]
lbl(tEx,">> GRAND RP EXPLOITS")
btn(tEx,"Change Job [Selected]",function() if ST.selectedPlayer and cd() then pcall(function() local r=findRemote("Teams.ChangeJob") if r then r:FireServer("police") end end) ntf("Job","Changed to police") end end,"chjob")
btn(tEx,"Try Efood Job",function() if cd() then pcall(function() local r=findRemote("efood.efoodJob") if r then r:FireServer() end end) ntf("Efood","Trying efood job") end end,"efood")
btn(tEx,"Try Bank Robbery",function() if cd() then pcall(function() local r=findRemote("Bank.TablesEvents.Prompt") if r then r:FireServer() end end) ntf("Bank","Trying robbery") end end,"bankrob")
btn(tEx,"Lockpick Vault",function() if cd() then pcall(function() local r=findRemote("Bank.Lockpick.Vault") if r then r:FireServer() end end) ntf("Lockpick","Trying vault") end end,"lockvault")
btn(tEx,"Toggle Siren",function() pcall(function() local r=findRemote("ToggleSirenEvent") if r then r:FireServer() end end) ntf("Siren","Toggled") end,"siren")
sep(tEx)
lbl(tEx,">> HEAL / HEALTH / ARMOR")
btn(tEx,"Full Heal Self",function() if cd() then pcall(function() local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=h.MaxHealth h.PlatformStand=false h:ChangeState(Enum.HumanoidStateType.GettingUp) end end) pcall(function() local r=findRemote("Hospital.EKAB") if r then r:FireServer() end end) ntf("Heal","Fully healed!") end end,"fheal")
btn(tEx,"Heal Selected",function() if ST.selectedPlayer and cd() then pcall(function() local h=ST.selectedPlayer.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=h.MaxHealth h.PlatformStand=false h:ChangeState(Enum.HumanoidStateType.GettingUp) end end) ntf("Heal",ST.selectedPlayer.Name.." healed!") end end,"healsel")
btn(tEx,"Heal All Players",function() if cd() then pcall(function() for _,pp in pairs(P:GetPlayers()) do if pp.Character then local h=pp.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=h.MaxHealth h.PlatformStand=false h:ChangeState(Enum.HumanoidStateType.GettingUp) end end end end) ntf("Heal","All healed!") end end,"healall")
btn(tEx,"Set Health 100",function() if cd() then pcall(function() local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=100 h.MaxHealth=100 end end) ntf("Health","Set to 100") end end,"sethp")
btn(tEx,"Set Health 9999",function() if cd() then pcall(function() local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.MaxHealth=9999 h.Health=9999 end end) ntf("Health","Set to 9999") end end,"sethpmax")
btn(tEx,"Godmode Self",function() if cd() then pcall(function() local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.MaxHealth=math.huge h.Health=math.huge h.PlatformStand=false h:ChangeState(Enum.HumanoidStateType.GettingUp) end end) ntf("Godmode","Enabled!") end end,"godself")
sep(tEx)
lbl(tEx,">> FOOD / WATER")
btn(tEx,"Full Hunger",function() if cd() then sf("heal",1) ntf("Food","Hunger restored!") end end,"fullhunger")
btn(tEx,"Full Thirst",function() if cd() then sf("heal",1) ntf("Water","Thirst restored!") end end,"fullthirst")
btn(tEx,"Full Hunger + Thirst",function() if cd() then sf("heal",1) pcall(function() local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=h.MaxHealth end end) ntf("Food","Both restored!") end end,"fullboth")
sep(tEx)
lbl(tEx,">> REVIVE")
btn(tEx,"Revive Self",function() if cd() then pcall(function() local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=h.MaxHealth h.PlatformStand=false h:ChangeState(Enum.HumanoidStateType.GettingUp) end end) pcall(function() local r=findRemote("Hospital.EKAB") if r then r:FireServer() end end) ntf("Revive","Self revived!") end end,"revself")
btn(tEx,"Revive Selected",function() if ST.selectedPlayer and cd() then pcall(function() local h=ST.selectedPlayer.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=h.MaxHealth h.PlatformStand=false h:ChangeState(Enum.HumanoidStateType.GettingUp) end end) ntf("Revive",ST.selectedPlayer.Name.." revived!") end end,"revsel")
btn(tEx,"Revive All",function() if cd() then pcall(function() for _,pp in pairs(P:GetPlayers()) do if pp.Character then local h=pp.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=h.MaxHealth h.PlatformStand=false h:ChangeState(Enum.HumanoidStateType.GettingUp) end end end end) ntf("Revive","All revived!") end end,"revall")
sep(tEx)
lbl(tEx,">> SELF EXPLOIT")
btn(tEx,"TP All To Me",function() if cd() then sf("bring",100) end end,"tpall")
btn(tEx,"Kill All",function() if cd() then sf("kill",100) end end,"killall")
btn(tEx,"Freeze All",function() if cd() then sf("freeze",100) end end,"frall")
btn(tEx,"Explode All",function() if cd() then sf("explode",100) end end,"expall")
sep(tEx)
lbl(tEx,">> REMOTE SCANNER")
btn(tEx,"Open Remote Scanner",function() if _G.RemoteScanner then pcall(function() _G.RemoteScanner:Destroy() end) end
    local SG2=Instance.new("ScreenGui") SG2.Name="RemoteScanner" SG2.ResetOnSpawn=false SG2.DisplayOrder=2 pcall(function() SG2.Parent=CG end) if not SG2.Parent then SG2.Parent=LP:WaitForChild("PlayerGui") end _G.RemoteScanner=SG2
    local PF=Instance.new("Frame") PF.Size=UDim2.new(0,600,0,450) PF.Position=UDim2.new(0.5,-300,0.5,-225) PF.BackgroundColor3=TH.p PF.BorderSizePixel=0 PF.Active=true PF.Draggable=true PF.Parent=SG2 PF.BackgroundTransparency=1 mkCorner(PF,12) mkStroke(PF,TH.a,2)
    tw(PF,{BackgroundTransparency=0,Position=UDim2.new(0.5,-300,0.5,-225)},0.3)
    local PT=Instance.new("Frame") PT.Size=UDim2.new(1,0,0,36) PT.BackgroundColor3=TH.s PT.BorderSizePixel=0 PT.Parent=PF mkCorner(PT,12)
    local PTL=Instance.new("TextLabel") PTL.Size=UDim2.new(1,-80,1,0) PTL.Position=UDim2.new(0,12,0,0) PTL.BackgroundTransparency=1 PTL.Text="REMOTE SCANNER" PTL.TextColor3=TH.a PTL.TextSize=14 PTL.Font=Enum.Font.GothamBlack PTL.TextXAlignment=Enum.TextXAlignment.Left PTL.Parent=PT
    local PX=Instance.new("TextButton") PX.Size=UDim2.new(0,28,0,28) PX.Position=UDim2.new(1,-32,0,4) PX.BackgroundTransparency=1 PX.Text="X" PX.TextColor3=TH.r PX.TextSize=18 PX.Font=Enum.Font.GothamBold PX.Parent=PT
    PX.MouseButton1Click:Connect(function() tw(PF,{BackgroundTransparency=1,Position=UDim2.new(0.5,-300,0.5,-180)},0.25) wait(0.25) SG2:Destroy() _G.RemoteScanner=nil end)
    local SC=Instance.new("TextBox") SC.Size=UDim2.new(1,-16,0,28) SC.Position=UDim2.new(0,8,0,42) SC.BackgroundColor3=TH.b SC.BorderSizePixel=0 SC.PlaceholderText="Search remotes..." SC.PlaceholderColor3=Color3.fromRGB(100,100,120) SC.Text="" SC.TextColor3=TH.t SC.TextSize=12 SC.Font=Enum.Font.Gotham SC.ClearTextOnFocus=false SC.Parent=PF mkCorner(SC,6) mkStroke(SC,TH.a,1)
    local SF=Instance.new("ScrollingFrame") SF.Size=UDim2.new(1,-16,1,-80) SF.Position=UDim2.new(0,8,0,76) SF.BackgroundTransparency=1 SF.BorderSizePixel=0 SF.ScrollBarThickness=4 SF.ScrollBarImageColor3=TH.a SF.CanvasSize=UDim2.new(0,0,0,0) SF.Parent=PF SF.AutomaticCanvasSize=Enum.AutomaticSize.Y SF.ScrollingDirection=Enum.ScrollingDirection.Y SF.ElasticBehavior=Enum.ElasticBehavior.Never
    local SL=Instance.new("UIListLayout",SF) SL.Padding=UDim.new(0,3) SL.SortOrder=Enum.SortOrder.LayoutOrder
    SL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() SF.CanvasSize=UDim2.new(0,0,0,SL.AbsoluteContentSize.Y+8) end)
    mkPadding(SF,4,4,2,2)
    local function loadRemotes(filter) for _,c in pairs(SF:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end local all={} local function scan(parent) for _,r in pairs(parent:GetDescendants()) do if r:IsA("RemoteEvent") then table.insert(all,{name=r.Name,Type="Event",Obj=r}) elseif r:IsA("RemoteFunction") then table.insert(all,{name=r.Name,Type="Function",Obj=r}) end end end scan(RS) scan(W) local count=0 for i,info in pairs(all) do if not filter or filter=="" or info.name:lower():find(filter:lower()) then count=count+1 local RF=Instance.new("Frame") RF.Size=UDim2.new(1,-4,0,30) RF.BackgroundColor3=TH.b RF.BorderSizePixel=0 RF.LayoutOrder=count RF.Parent=SF mkCorner(RF,4)
        local RL=Instance.new("TextLabel") RL.Size=UDim2.new(0.45,0,1,0) RL.Position=UDim2.new(0,8,0,0) RL.BackgroundTransparency=1 RL.Text=info.name RL.TextColor3=TH.t RL.TextSize=11 RL.Font=Enum.Font.GothamMedium RL.TextXAlignment=Enum.TextXAlignment.Left RL.TextTruncate=Enum.TextTruncate.AtEnd RL.Parent=RF
        local RT=Instance.new("TextLabel") RT.Size=UDim2.new(0,50,0,18) RT.Position=UDim2.new(0.46,0,0,6) RT.BackgroundColor3=info.Type=="Event" and Color3.fromRGB(40,60,40) or Color3.fromRGB(60,40,40) RT.BorderSizePixel=0 RT.Text=info.Type RT.TextColor3=info.Type=="Event" and TH.g or TH.r RT.TextSize=9 RT.Font=Enum.Font.GothamBold RT.Parent=RF mkCorner(RT,3)
        local CB=Instance.new("TextButton") CB.Size=UDim2.new(0,50,0,22) CB.Position=UDim2.new(0.55,4,0,4) CB.BackgroundColor3=Color3.fromRGB(50,50,80) CB.BorderSizePixel=0 CB.Text="Copy" CB.TextColor3=TH.t CB.TextSize=10 CB.Font=Enum.Font.GothamBold CB.Parent=RF mkCorner(CB,4)
        CB.MouseButton1Click:Connect(function() pcall(function() setclipboard(info.name) end) CB.Text="Copied!" CB.BackgroundColor3=TH.g wait(1) CB.Text="Copy" CB.BackgroundColor3=Color3.fromRGB(50,50,80) end)
        local FB=Instance.new("TextButton") FB.Size=UDim2.new(0,50,0,22) FB.Position=UDim2.new(0.55+0.1,8,0,4) FB.BackgroundColor3=Color3.fromRGB(80,40,40) FB.BorderSizePixel=0 FB.Text="Fire" FB.TextColor3=TH.t FB.TextSize=10 FB.Font=Enum.Font.GothamBold FB.Parent=RF mkCorner(FB,4)
        FB.MouseButton1Click:Connect(function() pcall(function() info.Obj:FireServer() end) FB.Text="Fired!" FB.BackgroundColor3=TH.g wait(0.5) FB.Text="Fire" FB.BackgroundColor3=Color3.fromRGB(80,40,40) end) end end local CL=Instance.new("TextLabel") CL.Size=UDim2.new(0.4,0,0,18) CL.Position=UDim2.new(0.56,40,0,0) CL.BackgroundTransparency=1 CL.Text="Found: "..count.." remotes" CL.TextColor3=TH.a CL.TextSize=10 CL.Font=Enum.Font.GothamBold CL.TextXAlignment=Enum.TextXAlignment.Right CL.Parent=PF end
    loadRemotes("") SC:GetPropertyChangedSignal("Text"):Connect(function() loadRemotes(SC.Text) end)
end,"scanrem")
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
btn(tMi,"Revive All",function() if cd() then sf("heal",100) pcall(function() for _,pp in pairs(P:GetPlayers()) do if pp.Character then local h=pp.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=h.MaxHealth h.PlatformStand=false end end end end) ntf("Revive","All revived!") end end,"svrevive")
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
        local key=inp.KeyCode~=Enum.KeyCode.Unknown and inp.KeyCode or inp.UserInputType KB[waitingForKey]=key waitingForKey=nil ntf("Keybind","Key assigned!")
        for _,t in pairs(allToggles) do if togUpdates[t] then togUpdates[t]() end end return
    end
    for id,key in pairs(KB) do
        if inp.KeyCode==key or inp.UserInputType==key then
            if id=="fly" then ST.fly=not ST.fly if not ST.fly and LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.PlatformStand=false end end
            elseif id=="noclip" then ST.noclip=not ST.noclip
            elseif id=="freecam" then ST.freeCam=not ST.freeCam if ST.freeCam then CAM.CameraType=Enum.CameraType.Scriptable else CAM.CameraType=Enum.CameraType.Custom if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h end end end
            elseif id=="clicktp" then ST.clickTP=not ST.clickTP
            elseif id=="esp" then ST.esp=not ST.esp if ST.esp then for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and not pp.Character:FindFirstChild("AxESP") then local hl=Instance.new("Highlight") hl.Name="AxESP" hl.FillColor=CFG.ESPColor hl.FillTransparency=CFG.ESPFillAlpha hl.OutlineColor=Color3.new(1,1,1) hl.OutlineTransparency=0 hl.Parent=pp.Character ST.espList[pp.UserId]=hl end end else for uid,hl in pairs(ST.espList) do if hl and hl.Parent then hl:Destroy() end ST.espList[uid]=nil end end
            elseif id=="night" then ST.night=not ST.night if ST.night then L.ClockTime=0 else L.ClockTime=14 end
            elseif id=="bright" then ST.bright=not ST.bright if ST.bright then L.Brightness=2 L.GlobalShadows=false else L.Brightness=1 L.GlobalShadows=true end
            elseif id=="nofog" then ST.noFog=not ST.noFog if ST.noFog then L.FogEnd=999999 else L.FogEnd=100000 end
            end
            for _,t in pairs(allToggles) do if togUpdates[t] then togUpdates[t]() end end
        end
    end
    if inp.KeyCode==Enum.KeyCode.F4 then ST.menuOpen=not ST.menuOpen if ST.menuOpen then MF.Visible=true MF.BackgroundTransparency=1 MF.Size=UDim2.new(0,520,0,420) tw(MF,{BackgroundTransparency=0.02,Size=UDim2.new(0,520,0,480),Position=UDim2.new(0.5,-260,0.5,-240)},0.35) else tw(MF,{Position=UDim2.new(0.5,-260,0.5,-280),BackgroundTransparency=1,Size=UDim2.new(0,520,0,420)},0.25) wait(0.25) MF.Visible=false MF.Position=UDim2.new(0.5,-260,0.5,-240) MF.Size=UDim2.new(0,520,0,480) MF.BackgroundTransparency=0.02 end end
end)
MS.Button1Down:Connect(function() if ST.clickTP and LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h and MS.Hit then h.CFrame=CFrame.new(MS.Hit.Position+Vector3.new(0,3,0)) end end end)
print("[Axynth] Events OK")
R.RenderStepped:Connect(function()
    if ST.fly and LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h then h.Velocity=Vector3.new(0,0,0) h.RotVelocity=Vector3.new(0,0,0) local dir=Vector3.new(0,0,0) if U:IsKeyDown(Enum.KeyCode.W) then dir=dir+CAM.CFrame.LookVector end if U:IsKeyDown(Enum.KeyCode.S) then dir=dir-CAM.CFrame.LookVector end if U:IsKeyDown(Enum.KeyCode.A) then dir=dir-CAM.CFrame.RightVector end if U:IsKeyDown(Enum.KeyCode.D) then dir=dir+CAM.CFrame.RightVector end if U:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end if U:IsKeyDown(Enum.KeyCode.LeftShift) then dir=dir-Vector3.new(0,1,0) end if dir.Magnitude>0 then dir=dir.Unit end h.CFrame=h.CFrame+dir*ST.flySpeed*R.RenderStepped:Wait() end end
    if ST.noclip and LP.Character then for _,p2 in pairs(LP.Character:GetDescendants()) do if p2:IsA("BasePart") then p2.CanCollide=false end end end
    if ST.freeCam then CAM.CameraType=Enum.CameraType.Scriptable local dir=Vector3.new(0,0,0) local sp=1 if U:IsKeyDown(Enum.KeyCode.LeftShift) then sp=2 end if U:IsKeyDown(Enum.KeyCode.W) then dir=dir+CAM.CFrame.LookVector end if U:IsKeyDown(Enum.KeyCode.S) then dir=dir-CAM.CFrame.LookVector end if U:IsKeyDown(Enum.KeyCode.A) then dir=dir-CAM.CFrame.RightVector end if U:IsKeyDown(Enum.KeyCode.D) then dir=dir+CAM.CFrame.RightVector end CAM.CFrame=CAM.CFrame+dir*sp end
end)
P.PlayerAdded:Connect(function(pp) pp.CharacterAdded:Connect(function(ch) wait(1) if ST.esp and pp~=LP then local hl=Instance.new("Highlight") hl.Name="AxESP" hl.FillColor=CFG.ESPColor hl.FillTransparency=CFG.ESPFillAlpha hl.OutlineColor=Color3.new(1,1,1) hl.OutlineTransparency=0 hl.Parent=ch ST.espList[pp.UserId]=hl end end) end)
P.PlayerRemoving:Connect(function(pp) if ST.espList[pp.UserId] then ST.espList[pp.UserId]:Destroy() ST.espList[pp.UserId]=nil end end)
print("[Axynth] MENU LOADED! Press F4!")
end)
if not ok then print("[Axynth] ERROR: "..tostring(err)) end
