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
-- ANTI-BAN SYSTEM v8 FULL - ALL FEATURES + THROTTLED (NO FREEZE)
local hookLog={}
local blockedKeywords={"anticheat","anti","cheat","detect","ban","kick","report","flag","log","trace","monitor","watch","scan","validate","verify","check","suspicious","abnormal","illegal","unauthorized","modified","exploit","hack","teleport","speed","noclip","fly","cheatdetected","serverintegrity","integritycheck","remotespy","remoteblock","remotecheck","adminremote","admin"}
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
local _frameCount=0
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
            -- aimbot moved to RenderStepped only for stability
            if ST.remoteSpyOn and not ST.remoteSpyPaused then
                pcall(function()
                    local argsStr=""
                    for i=1,math.min(#args,4) do
                        local v=args[i]
                        if typeof(v)=="Instance" then argsStr=argsStr..v.Name.." "
                        elseif typeof(v)=="Vector3" then argsStr=argsStr.."V3 "
                        elseif typeof(v)=="CFrame" then argsStr=argsStr.."CF "
                        elseif typeof(v)=="string" then argsStr=argsStr..string.sub(v,1,20).." "
                        else argsStr=argsStr..tostring(v).." "
                        end
                    end
                    if _G._spyAdd then _G._spyAdd(self.Name,argsStr,"F") end
                end)
            end
        end
        return oldNC(self,unpack(args))
    end))
end)
pcall(function()
    local oldGetService
    oldGetService = hookfunction(game.GetService,function(self,service)
        local s=service:lower()
        if s:find("anticheat") or s:find("antichet") or s:find("detector") or s:find("moderation") then
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
            if n:find("anticheat") or n:find("detector") or n:find("trigger") or n:find("cheat") or n:find("admin") then
                return nil
            end
        end
        return oldFFI(self,name,recursive)
    end)
end)
pcall(function()
    local oldFFIC=Instance.new("Workspace").FindFirstChildOfClass
    hookfunction(Instance.new("Workspace").FindFirstChildOfClass,function(self,class)
        if self==workspace and class then
            local c=class:lower()
            if c:find("detector") or c:find("trigger") or c:find("cheat") then
                return nil
            end
        end
        return oldFFIC(self,class)
    end)
end)
pcall(function()
    local old=Instance.new("Workspace").FindFirstChildWhichIsA
    hookfunction(Instance.new("Workspace").FindFirstChildWhichIsA,function(self,class,recursive)
        if self==workspace and class then
            local c=class:lower()
            if c:find("detector") or c:find("trigger") or c:find("cheat") then
                return nil
            end
        end
        return old(self,class,recursive)
    end)
end)
pcall(function()
    local old=Instance.new("Workspace").GetChildren
    hookfunction(Instance.new("Workspace").GetChildren,function(self)
        local children=old(self)
        if self==workspace then
            local filtered={}
            for _,v in pairs(children) do
                local name=v.Name:lower()
                if not (name:find("anticheat") or name:find("detector") or name:find("trigger") or name:find("cheat")) then
                    table.insert(filtered,v)
                end
            end
            return filtered
        end
        return children
    end)
end)
pcall(function()
    local old=Instance.new("Workspace").GetDescendants
    hookfunction(Instance.new("Workspace").GetDescendants,function(self)
        local descendants=old(self)
        if self==workspace then
            local filtered={}
            for _,v in pairs(descendants) do
                local name=v.Name:lower()
                if not (name:find("anticheat") or name:find("detector") or name:find("trigger") or name:find("cheat")) then
                    table.insert(filtered,v)
                end
            end
            return filtered
        end
        return descendants
    end)
end)
pcall(function()
    local mt=getrawmetatable(game)
    local old=mt.__tostring
    setreadonly(mt,false)
    mt.__tostring=newcclosure(function(self)
        if typeof(self)=="Instance" and self:IsA("RemoteEvent") then
            if isBlocked(self.Name) and not isWhitelisted(self.Name) then
                return "BasePart"
            end
        end
        return old(self)
    end)
    setreadonly(mt,true)
end)
pcall(function()
    local oldGetObjects=game.GetObjects
    hookfunction(game.GetObjects,function(self,assetId)
        if assetId and typeof(assetId)=="string" then
            if assetId:lower():find("anticheat") or assetId:lower():find("cheat") then
                return {}
            end
        end
        return oldGetObjects(self,assetId)
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
local function spoofVelocity()
    pcall(function()
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local hrp=LP.Character.HumanoidRootPart
            hrp.Velocity=Vector3.new(0,0,0)
            hrp.RotVelocity=Vector3.new(0,0,0)
        end
    end)
end
local function spoofHealth()
    pcall(function()
        if LP.Character then
            local h=LP.Character:FindFirstChildOfClass("Humanoid")
            if h and h.Health>h.MaxHealth then h.Health=h.MaxHealth end
        end
    end)
end
local function cleanTrails()
    pcall(function()
        if LP.Character then
            for _,v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("BodyMover") and v.Name:find("Ax") then v:Destroy() end
            end
        end
    end)
end
local function spoofLeaderstats()
    pcall(function()
        if LP:FindFirstChild("leaderstats") then
            for _,v in pairs(LP.leaderstats:GetChildren()) do
                if (v:IsA("IntValue") or v:IsA("NumberValue")) and v.Value>1000000 then
                    v.Value=math.random(100,500)
                end
            end
        end
    end)
end
local function hideBanGUI()
    pcall(function()
        for _,v in pairs(LP.PlayerGui:GetDescendants()) do
            if (v:IsA("TextLabel") or v:IsA("TextButton")) and v.Text then
                local t=v.Text:lower()
                if t:find("anticheat") or t:find("detected") or t:find("banned") or t:find("kicked") then
                    v.Visible=false v.Text=""
                end
            end
        end
    end)
end
pcall(function()
    LP.CharacterAdded:Connect(function(char)
        task.wait(1)
        spoofLeaderstats()
        hideBanGUI()
    end)
end)
pcall(function()
    LP.PlayerGui.DescendantAdded:Connect(function(v)
        task.wait(0.2)
        if (v:IsA("TextLabel") or v:IsA("TextButton")) and v.Text then
            local t=v.Text:lower()
            if t:find("anticheat") or t:find("detected") or t:find("banned") then
                v.Visible=false v.Text=""
            end
        end
    end)
end)
R.Heartbeat:Connect(function()
    _frameCount=_frameCount+1
    if _frameCount%60~=0 then return end
    spoofVelocity()
    spoofHealth()
    spoofLeaderstats()
    for i=#hookLog,1,-1 do
        if tick()-hookLog[i].time>10 then table.remove(hookLog,i) end
    end
end)
R.Stepped:Connect(function()
    if _frameCount%120~=0 then return end
    cleanTrails()
end)
R.RenderStepped:Connect(function()
    if _frameCount%300~=0 then return end
    hideBanGUI()
end)
print("[Axynth] Anti-Ban v8 FULL ACTIVE | Whitelist: "..(function() local c=0 for _ in pairs(whitelistRemotes) do c=c+1 end return c end)().." | Keywords: "..#blockedKeywords.." | Hooks: 15 | Throttled: 1/sec")
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
local ST = {menuOpen=false,fly=false,noclip=false,clickTP=false,esp=false,spectating=nil,selectedPlayer=nil,flySpeed=50,night=false,bright=false,noFog=false,invisible=false,espList={},spinner=false,autoClicker=false,infJump=false,savedCollide={},flyBypass=true,godmodeLoop=false,speedHard=false,vehicleSpeedOn=false,maceTP=false,infStamina=false,magicBullet=false,cursorTPPreview=nil,waypoints={},botRecord=false,botPlay=false,botLoop=false,botFrames={},botStart=0,arrayList=false,markerObj=nil,savedLighting=nil,savedGravity=196.2,spinnerSpeed=25,remoteSpyOn=false,remoteSpyPaused=false,remoteSpyLog={},spySG=nil,aimEnabled=false,aimFOV=120,aimMode="silent",aimTargetPart="Head",aimTeamCheck=true,aimFOVGui=nil,aimTarget=nil}
local CFG = {ESPColor=Color3.fromRGB(255,0,0),ESPOutlineColor=Color3.new(1,1,1),ESPFillAlpha=0.5,ESPOutlineEnabled=true,ESPFillEnabled=true,ESPShowName=true,ESPShowHealth=true,ESPShowDistance=true,ESPShowTracer=false,ESPTracerColor=Color3.fromRGB(255,0,0),ESPTextColor=Color3.new(1,1,1),ESPThickness=2,ESP2D=false,ESPMaxDist=5000,AimEnabled=false,AimFOV=120,AimMode="silent",AimTargetPart="Head",AimTeamCheck=true}
local TH = {p=Color3.fromRGB(15,15,15),s=Color3.fromRGB(22,22,22),b=Color3.fromRGB(30,30,30),bh=Color3.fromRGB(45,45,45),t=Color3.fromRGB(230,230,230),a=Color3.fromRGB(255,255,255),g=Color3.fromRGB(80,255,120),r=Color3.fromRGB(255,80,80)}
local KB = {}
local waitingForKey = nil
local togUpdates={}
local function tw(o,p,d) local t=TW:Create(o,TweenInfo.new(d or 0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),p) t:Play() return t end
local function twFast(o,p,d) local t=TW:Create(o,TweenInfo.new(d or 0.15,Enum.EasingStyle.Back,Enum.EasingDirection.Out),p) t:Play() return t end
local function mkCorner(p,r) local c=Instance.new("UICorner",p) c.CornerRadius=UDim.new(0,r or 8) return c end
local function mkStroke(p,c,w) local s=Instance.new("UIStroke",p) s.Color=c or Color3.fromRGB(60,60,90) s.Thickness=w or 1 s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border return s end
local function mkPadding(p,t,b,l,r2) local pd=Instance.new("UIPadding",p) pd.PaddingTop=UDim.new(0,t or 4) pd.PaddingBottom=UDim.new(0,b or 4) pd.PaddingLeft=UDim.new(0,l or 6) pd.PaddingRight=UDim.new(0,r2 or 6) return pd end
local function sep(p) local f=Instance.new("Frame") f.Size=UDim2.new(1,-12,0,1) f.Position=UDim2.new(0,6,0,0) f.BackgroundColor3=Color3.fromRGB(50,50,75) f.BorderSizePixel=0 f.Parent=p end
local function lbl(p,t) local l=Instance.new("TextLabel") l.Size=UDim2.new(1,-12,0,22) l.Position=UDim2.new(0,6,0,0) l.BackgroundTransparency=1 l.Text=t l.TextColor3=TH.a l.TextSize=11 l.Font=Enum.Font.GothamBold l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=p return l end
local function ntf(t,x,d) pcall(function() S:SetCore("SendNotification",{Title=t,Text=x,Duration=d or 3}) end) end
local function getKeyDisplay(key) if not key then return "NONE" end local s=tostring(key) s=s:gsub("Enum.KeyCode.","") s=s:gsub("Enum.UserInputType.","") return s end
local function findRemote(name) return RS:FindFirstChild(name) end
local function btn(p,t,fn,id)
    local b=Instance.new("TextButton") b.Size=UDim2.new(1,-12,0,30) b.Position=UDim2.new(0,6,0,0) b.BackgroundColor3=TH.b b.BorderSizePixel=0 b.Text="  "..t b.TextColor3=TH.t b.TextSize=12 b.Font=Enum.Font.GothamMedium b.TextXAlignment=Enum.TextXAlignment.Left b.Parent=p
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
local TB=Instance.new("Frame") TB.Size=UDim2.new(1,0,0,40) TB.BackgroundColor3=TH.s TB.BorderSizePixel=0 TB.Parent=MF mkCorner(TB,12) TB.Parent=MF
local TL=Instance.new("TextLabel") TL.Size=UDim2.new(1,-50,1,0) TL.Position=UDim2.new(0,16,0,0) TL.BackgroundTransparency=1 TL.Text="AXYNTH" TL.TextColor3=TH.a TL.TextSize=18 TL.Font=Enum.Font.GothamBlack TL.TextXAlignment=Enum.TextXAlignment.Left TL.Parent=TB
local XBtn=Instance.new("TextButton") XBtn.Size=UDim2.new(0,32,0,32) XBtn.Position=UDim2.new(1,-38,0,4) XBtn.BackgroundTransparency=1 XBtn.Text="X" XBtn.TextColor3=TH.r XBtn.TextSize=20 XBtn.Font=Enum.Font.GothamBold XBtn.Parent=TB
XBtn.MouseEnter:Connect(function() twFast(XBtn,{TextColor3=Color3.new(1,1,1)}) end)
XBtn.MouseLeave:Connect(function() tw(XBtn,{TextColor3=TH.r},0.2) end)
XBtn.MouseButton1Click:Connect(function() ST.menuOpen=false tw(MF,{Position=UDim2.new(0.5,-260,0.5,-280),BackgroundTransparency=1,Size=UDim2.new(0,520,0,420)},0.3) wait(0.3) MF.Visible=false MF.Position=UDim2.new(0.5,-260,0.5,-240) MF.Size=UDim2.new(0,520,0,480) MF.BackgroundTransparency=0.02 end)
local CFB=Instance.new("Frame") CFB.Size=UDim2.new(1,0,0,38) CFB.Position=UDim2.new(0,0,0,40) CFB.BackgroundColor3=Color3.fromRGB(20,20,36) CFB.BorderSizePixel=0 CFB.Parent=MF
print("[Axynth] GUI OK")
local tabs={} local tF={}
local tNames={{"home","Home"},{"world","World"},{"plr","Players"},{"exploit","Exploit"},{"set","Settings"}}
for i,n in pairs(tNames) do
    local f=Instance.new("TextButton") f.Size=UDim2.new(0,78,0,30) f.Position=UDim2.new(0,(i-1)*82+4,0,4) f.BackgroundColor3=TH.p f.BorderSizePixel=0 f.Text=n[2] f.TextColor3=TH.t f.TextSize=10 f.Font=Enum.Font.GothamBold f.Parent=CFB mkCorner(f,6)
    local fr=Instance.new("ScrollingFrame") fr.Size=UDim2.new(1,-16,1,-86) fr.Position=UDim2.new(0,8,0,82) fr.BackgroundTransparency=1 fr.BorderSizePixel=0 fr.ScrollBarThickness=4 fr.ScrollBarImageColor3=TH.a fr.CanvasSize=UDim2.new(0,0,0,0) fr.Visible=false fr.Parent=MF fr.AutomaticCanvasSize=Enum.AutomaticSize.Y fr.ScrollingDirection=Enum.ScrollingDirection.Y fr.ElasticBehavior=Enum.ElasticBehavior.Never fr.TopImage="rbxasset://textures/ui/Scroll/scroll-middle.png" fr.BottomImage="rbxasset://textures/ui/Scroll/scroll-middle.png"
    local layout=Instance.new("UIListLayout",fr) layout.Padding=UDim.new(0,4) layout.SortOrder=Enum.SortOrder.LayoutOrder
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() fr.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+8) end)
    mkPadding(fr,4,4,2,2)
    tabs[n[1]]={btn=f,frame=fr} tF[n[1]]=fr
    f.MouseButton1Click:Connect(function() for _,v in pairs(tabs) do v.frame.Visible=false v.btn.BackgroundColor3=TH.p v.btn.TextColor3=TH.t end fr.Visible=true tw(f,{BackgroundColor3=TH.a,TextColor3=Color3.fromRGB(15,15,15)},0.2) end)
end
tabs["home"].frame.Visible=true tw(tabs["home"].btn,{BackgroundColor3=TH.a,TextColor3=Color3.fromRGB(15,15,15)},0.2)
print("[Axynth] Tabs OK")
local allToggles={}
_G.AxST=ST
local tH=tF["home"]
lbl(tH,">> SPEED")
btn(tH,"Speed 100",function() task.spawn(function() task.wait(0.1) pcall(function() local ch=LP.Character if ch then local h=ch:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=100 end end end) end) end,"sp100")
btn(tH,"Speed 250",function() task.spawn(function() task.wait(0.1) pcall(function() local ch=LP.Character if ch then local h=ch:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=250 end end end) end) end,"sp250")
btn(tH,"Speed 500",function() task.spawn(function() task.wait(0.1) pcall(function() local ch=LP.Character if ch then local h=ch:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=500 end end end) end) end,"sp500")
btn(tH,"Reset Speed",function() task.spawn(function() task.wait(0.1) pcall(function() local ch=LP.Character if ch then local h=ch:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=16 end end end) end) end,"sprst")
sep(tH)
lbl(tH,">> JUMP")
btn(tH,"Jump 100",function() task.spawn(function() task.wait(0.1) pcall(function() local ch=LP.Character if ch then local h=ch:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower=true h.JumpPower=100 end end end) end) end,"jp100")
btn(tH,"Jump 300",function() task.spawn(function() task.wait(0.1) pcall(function() local ch=LP.Character if ch then local h=ch:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower=true h.JumpPower=300 end end end) end) end,"jp300")
btn(tH,"Jump 500",function() task.spawn(function() task.wait(0.1) pcall(function() local ch=LP.Character if ch then local h=ch:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower=true h.JumpPower=500 end end end) end) end,"jp500")
btn(tH,"Reset Jump",function() task.spawn(function() task.wait(0.1) pcall(function() local ch=LP.Character if ch then local h=ch:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower=true h.JumpPower=50 end end end) end) end,"jprst")
local tInfJ=tog(tH,"Infinite Jump",function() return ST.infJump end,function() ST.infJump=not ST.infJump ntf("InfJump",ST.infJump and "ON" or "OFF") end,"infjump")
table.insert(allToggles,tInfJ)
local tGML=tog(tH,"Godmode Loop",function() return ST.godmodeLoop end,function() ST.godmodeLoop=not ST.godmodeLoop ntf("Godmode",ST.godmodeLoop and "ON" or "OFF") end,"godloop")
table.insert(allToggles,tGML)
local tSPH=tog(tH,"Speed Hard",function() return ST.speedHard end,function() ST.speedHard=not ST.speedHard if ST.speedHard then pcall(function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=70 end end end) ntf("SpeedHard","ON (70)") else pcall(function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=16 end end end) ntf("SpeedHard","OFF") end end,"speedhard")
table.insert(allToggles,tSPH)
local tIS=tog(tH,"Infinite Stamina",function() return ST.infStamina end,function() ST.infStamina=not ST.infStamina ntf("Stamina",ST.infStamina and "ON" or "OFF") end,"infstam")
table.insert(allToggles,tIS)
sep(tH)
lbl(tH,">> FLY + NOCLIP")
local tFly=tog(tH,"Fly",function() return ST.fly end,function() ST.fly=not ST.fly if not ST.fly and LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.PlatformStand=false end end end,"fly")
table.insert(allToggles,tFly)
local tFlyBP=tog(tH,"Fly Bypass",function() return ST.flyBypass end,function() ST.flyBypass=not ST.flyBypass ntf("FlyBypass",ST.flyBypass and "ON" or "OFF") end,"flybyp")
table.insert(allToggles,tFlyBP)
local tNoclip=tog(tH,"Noclip",function() return ST.noclip end,function() ST.noclip=not ST.noclip if not ST.noclip and LP.Character then for _,p2 in pairs(LP.Character:GetDescendants()) do if p2:IsA("BasePart") and ST.savedCollide[p2]~=nil then p2.CanCollide=ST.savedCollide[p2] end end ST.savedCollide={} end end,"noclip")
table.insert(allToggles,tNoclip)
local tFC=tog(tH,"Free Cam",function() return ST.freeCam end,function() ST.freeCam=not ST.freeCam if ST.freeCam then ST.freeCamPos=CAM.CFrame ST.freeCamYaw=0 ST.freeCamPitch=0 CAM.CameraType=Enum.CameraType.Scriptable U.MouseBehavior=Enum.MouseBehavior.LockCenter ntf("FreeCam","ON - WASD + Mouse") else CAM.CameraType=Enum.CameraType.Custom U.MouseBehavior=Enum.MouseBehavior.Default if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h end end ntf("FreeCam","OFF") end end,"freecam")
table.insert(allToggles,tFC)
local tSpin=tog(tH,"Spinner (Self)",function() return ST.spinner end,function() ST.spinner=not ST.spinner if not ST.spinner and LP.Character then for _,v in pairs(LP.Character:GetDescendants()) do if v:IsA("BodyAngularVelocity") and v.Name:find("AxSpin") then v:Destroy() end end end end,"spinner")
table.insert(allToggles,tSpin)
btn(tH,"Spinner: Slow",function() ST.spinnerSpeed=10 ntf("Spinner","Slow (10)") end,"spinslow")
btn(tH,"Spinner: Fast",function() ST.spinnerSpeed=25 ntf("Spinner","Fast (25)") end,"spinfast")
btn(tH,"Spinner: Insane",function() ST.spinnerSpeed=50 ntf("Spinner","Insane (50)") end,"spinins")
sep(tH)
lbl(tH,">> TELEPORT")
local tCTP=tog(tH,"Click TP",function() return ST.clickTP end,function() ST.clickTP=not ST.clickTP if ST.clickTP then if not ST.cursorTPPreview then local p=Instance.new("Part") p.Name="AxCTPPreview" p.Size=Vector3.new(3,0.2,3) p.Anchored=true p.CanCollide=false p.Material=Enum.Material.Neon p.Color=Color3.fromRGB(255,0,0) p.Transparency=0.5 p.Parent=W ST.cursorTPPreview=p end else if ST.cursorTPPreview then ST.cursorTPPreview:Destroy() ST.cursorTPPreview=nil end end ntf("ClickTP",ST.clickTP and "ON" or "OFF") end,"clicktp")
table.insert(allToggles,tCTP)
btn(tH,"TP Cursor",function() if LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h and MS.Hit then h.CFrame=CFrame.new(MS.Hit.Position+Vector3.new(0,3,0)) ntf("TP","Teleported to cursor!") end end end,"tpcur")
btn(tH,"TP Forward",function() if LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h then h.CFrame=h.CFrame+CAM.CFrame.LookVector*100 end end end,"tpfwd")

local tW=tF["world"]
lbl(tW,">> WORLD")
local tNight=tog(tW,"Night",function() return ST.night end,function() ST.night=not ST.night if ST.night then ST._savedClock=L.ClockTime L.ClockTime=0 else if ST._savedClock then L.ClockTime=ST._savedClock ST._savedClock=nil else L.ClockTime=14 end end end,"night")
table.insert(allToggles,tNight)
local tBright=tog(tW,"Fullbright",function() return ST.bright end,function() ST.bright=not ST.bright if ST.bright then if not ST.savedLighting then ST.savedLighting={Brightness=L.Brightness,GlobalShadows=L.GlobalShadows,FogEnd=L.FogEnd,Ambient=L.Ambient,OutdoorAmbient=L.OutdoorAmbient,ClockTime=L.ClockTime} end else if ST.savedLighting then pcall(function() L.Brightness=ST.savedLighting.Brightness L.GlobalShadows=ST.savedLighting.GlobalShadows L.FogEnd=ST.savedLighting.FogEnd L.Ambient=ST.savedLighting.Ambient L.OutdoorAmbient=ST.savedLighting.OutdoorAmbient L.ClockTime=ST.savedLighting.ClockTime end) ST.savedLighting=nil end end end,"bright")
table.insert(allToggles,tBright)
local tFog=tog(tW,"No Fog",function() return ST.noFog end,function() ST.noFog=not ST.noFog end,"nofog")
table.insert(allToggles,tFog)
sep(tW)
lbl(tW,">> LIGHTING")
btn(tW,"Brightness +1",function() L.Brightness=L.Brightness+1 end,"brup")
btn(tW,"Brightness -1",function() L.Brightness=math.max(0,L.Brightness-1) end,"brdn")
btn(tW,"Reset Lighting",function() L.Brightness=1 L.GlobalShadows=true L.FogEnd=100000 L.ClockTime=14 end,"lgrst")
sep(tW)
lbl(tW,">> GRAVITY")
btn(tW,"Gravity +50",function() pcall(function() W.Gravity=W.Gravity+50 ntf("Gravity",math.floor(W.Gravity)) end) end,"gravup")
btn(tW,"Gravity -50",function() pcall(function() W.Gravity=math.max(0,W.Gravity-50) ntf("Gravity",math.floor(W.Gravity)) end) end,"gravdn")
btn(tW,"Gravity: Moon",function() pcall(function() W.Gravity=13 ntf("Gravity","Moon (13)") end) end,"gravmoon")
btn(tW,"Gravity: Normal",function() pcall(function() W.Gravity=196.2 ntf("Gravity","Normal (196.2)") end) end,"gravnorm")
btn(tW,"Gravity: Zero",function() pcall(function() W.Gravity=0 ntf("Gravity","Zero-G (0)") end) end,"gravzero")
btn(tW,"Gravity: Super",function() pcall(function() W.Gravity=400 ntf("Gravity","Super (400)") end) end,"gravsuper")
lbl(tW,">> VEHICLE SPEED")
btn(tW,"Vehicle MaxSpeed",function() pcall(function() local ch=LP.Character if ch then local seat=ch:FindFirstChildOfClass("VehicleSeat") or ch:FindFirstChild("Seat") if seat then seat.MaxSpeed=200 ntf("Vehicle","MaxSpeed: 200") end end end) end,"vmax")
btn(tW,"Vehicle Turbo",function() pcall(function() local ch=LP.Character if ch then local seat=ch:FindFirstChildOfClass("VehicleSeat") or ch:FindFirstChild("Seat") if seat then seat.MaxSpeed=500 ntf("Vehicle","Turbo: 500") end end end) end,"vturbo")
btn(tW,"Vehicle Reset",function() pcall(function() local ch=LP.Character if ch then local seat=ch:FindFirstChildOfClass("VehicleSeat") or ch:FindFirstChild("Seat") if seat then seat.MaxSpeed=25 ntf("Vehicle","Reset: 25") end end end) end,"vreset")
local tP=tF["plr"]
lbl(tP,">> SELECT PLAYER")
local pDropBtn=Instance.new("TextButton") pDropBtn.Size=UDim2.new(1,-12,0,34) pDropBtn.Position=UDim2.new(0,6,0,0) pDropBtn.BackgroundColor3=TH.b pDropBtn.BorderSizePixel=0 pDropBtn.Text="  Click to select..." pDropBtn.TextColor3=TH.t pDropBtn.TextSize=13 pDropBtn.Font=Enum.Font.GothamMedium pDropBtn.TextXAlignment=Enum.TextXAlignment.Left pDropBtn.Parent=tP mkCorner(pDropBtn,6) mkStroke(pDropBtn,TH.a,1)
local pDropOpen=false local pDropdown=nil
pDropBtn.MouseButton1Click:Connect(function()
    pDropOpen=not pDropOpen
    if pDropOpen then
        if pDropdown then pDropdown:Destroy() end
        pDropdown=Instance.new("ScrollingFrame") pDropdown.Size=UDim2.new(1,-12,0,120) pDropdown.Position=UDim2.new(0,6,0,38) pDropdown.BackgroundColor3=TH.s pDropdown.BorderSizePixel=0 pDropdown.ScrollBarThickness=3 pDropdown.ScrollBarImageColor3=TH.a pDropdown.Parent=tP mkCorner(pDropdown,6) mkStroke(pDropdown,TH.a,1)
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
sep(tP)
lbl(tP,">> SPECTATE + ESP")
btn(tP,"Spectate",function() if ST.selectedPlayer and ST.selectedPlayer.Character then local h=ST.selectedPlayer.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h CAM.CameraType=Enum.CameraType.Custom ST.spectating=ST.selectedPlayer end end end,"spec")
btn(tP,"Stop Spectate",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h end CAM.CameraType=Enum.CameraType.Custom ST.spectating=nil end end,"stopspec")
btn(tP,"Spectate: Next Player",function() local plrs=P:GetPlayers() local idx=1 for i,pp in pairs(plrs) do if pp==ST.spectating then idx=i break end end local nextI=idx+1 if nextI>#plrs then nextI=1 end local np=plrs[nextI] if np~=LP and np.Character then local h=np.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h CAM.CameraType=Enum.CameraType.Custom ST.spectating=np ntf("Spectate","Following: "..np.DisplayName) end end end,"specnext")
btn(tP,"Spectate: Prev Player",function() local plrs=P:GetPlayers() local idx=1 for i,pp in pairs(plrs) do if pp==ST.spectating then idx=i break end end local prevI=idx-1 if prevI<1 then prevI=#plrs end local pp2=plrs[prevI] if pp2~=LP and pp2.Character then local h=pp2.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h CAM.CameraType=Enum.CameraType.Custom ST.spectating=pp2 ntf("Spectate","Following: "..pp2.DisplayName) end end end,"specprev")
btn(tP,"Spectate: Overhead",function() if ST.spectating and ST.spectating.Character and ST.spectating.Character:FindFirstChild("HumanoidRootPart") then ST.spectateOverhead=not ST.spectateOverhead if ST.spectateOverhead then CAM.CameraType=Enum.CameraType.Scriptable ntf("Spectate","Overhead follow ON") else CAM.CameraType=Enum.CameraType.Custom ntf("Spectate","Overhead follow OFF") end end end,"specover")
local tESP=tog(tP,"ESP",function() return ST.esp end,function() ST.esp=not ST.esp if ST.esp then for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and not pp.Character:FindFirstChild("AxESP") then local hl=Instance.new("Highlight") hl.Name="AxESP" hl.FillColor=CFG.ESPColor hl.FillTransparency=CFG.ESPFillAlpha hl.OutlineColor=CFG.ESPOutlineColor hl.OutlineTransparency=CFG.ESPOutlineEnabled and 0 or 1 hl.Enabled=CFG.ESPFillEnabled hl.Parent=pp.Character ST.espList[pp.UserId]=hl end end else for id,hl in pairs(ST.espList) do if hl and hl.Parent then hl:Destroy() end ST.espList[id]=nil end end end,"esp")
table.insert(allToggles,tESP)
btn(tP,"ESP Color: Red",function() CFG.ESPColor=Color3.fromRGB(255,0,0) CFG.ESPTracerColor=Color3.fromRGB(255,0,0) ntf("ESP","Color: Red") end,"espcred")
btn(tP,"ESP Color: Blue",function() CFG.ESPColor=Color3.fromRGB(0,100,255) CFG.ESPTracerColor=Color3.fromRGB(0,100,255) ntf("ESP","Color: Blue") end,"esp cblu")
btn(tP,"ESP Color: White",function() CFG.ESPColor=Color3.fromRGB(255,255,255) CFG.ESPTracerColor=Color3.fromRGB(255,255,255) ntf("ESP","Color: White") end,"esp cwht")
btn(tP,"Toggle: Names",function() CFG.ESPShowName=not CFG.ESPShowName ntf("ESP","Names: "..(CFG.ESPShowName and "ON" or "OFF")) end,"espname")
btn(tP,"Toggle: Health Bar",function() CFG.ESPShowHealth=not CFG.ESPShowHealth ntf("ESP","Health: "..(CFG.ESPShowHealth and "ON" or "OFF")) end,"esphealth")
btn(tP,"Toggle: Distance",function() CFG.ESPShowDistance=not CFG.ESPShowDistance ntf("ESP","Distance: "..(CFG.ESPShowDistance and "ON" or "OFF")) end,"espdist")
btn(tP,"Toggle: Fill",function() CFG.ESPFillEnabled=not CFG.ESPFillEnabled ntf("ESP","Fill: "..(CFG.ESPFillEnabled and "ON" or "OFF")) end,"espfill")
btn(tP,"Toggle: Outline",function() CFG.ESPOutlineEnabled=not CFG.ESPOutlineEnabled ntf("ESP","Outline: "..(CFG.ESPOutlineEnabled and "ON" or "OFF")) end,"espoline")
btn(tP,"Max Dist: 2000",function() CFG.ESPMaxDist=2000 ntf("ESP","MaxDist: 2000") end,"espmd2k")
btn(tP,"Max Dist: 5000",function() CFG.ESPMaxDist=5000 ntf("ESP","MaxDist: 5000") end,"espmd5k")
local tESP2D=tog(tP,"2D Box ESP",function() return CFG.ESP2D end,function() CFG.ESP2D=not CFG.ESP2D ntf("ESP","2D Box: "..(CFG.ESP2D and "ON" or "OFF")) end,"esp2d")
table.insert(allToggles,tESP2D)
sep(tP)
lbl(tP,">> MACETP (FOLLOW)")
local tMace=tog(tP,"MaceTP",function() return ST.maceTP end,function() ST.maceTP=not ST.maceTP ntf("MaceTP",ST.maceTP and "ON - Follow nearest" or "OFF") end,"macetp")
table.insert(allToggles,tMace)
btn(tP,"MaceTP: Closer",function() if not ST.maceTPOffset then ST.maceTPOffset=3 end ST.maceTPOffset=ST.maceTPOffset-1 ntf("MaceTP","Offset: "..ST.maceTPOffset) end,"mzcloser")
btn(tP,"MaceTP: Further",function() if not ST.maceTPOffset then ST.maceTPOffset=3 end ST.maceTPOffset=ST.maceTPOffset+1 ntf("MaceTP","Offset: "..ST.maceTPOffset) end,"mzfurther")
sep(tP)
lbl(tP,">> MARKER SYSTEM")
btn(tP,"Set Marker Here",function() pcall(function() if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then if ST.markerObj then ST.markerObj:Destroy() end local p=Instance.new("Part") p.Name="AxMarker" p.Size=Vector3.new(4,0.2,4) p.Anchored=true p.CanCollide=false p.Material=Enum.Material.Neon p.Color=Color3.fromRGB(0,150,255) p.Transparency=0.3 p.Position=LP.Character.HumanoidRootPart.Position-Vector3.new(0,3,0) p.Parent=W ST.markerObj=p local bb=Instance.new("BillboardGui") bb.Size=UDim2.new(0,100,0,40) bb.StudsOffset=Vector3.new(0,3,0) bb.AlwaysOnTop=true bb.Parent=p local tl=Instance.new("TextLabel") tl.Size=UDim2.new(1,0,1,0) tl.BackgroundTransparency=1 tl.Text="MARKER" tl.TextColor3=Color3.fromRGB(0,200,255) tl.TextSize=14 tl.Font=Enum.Font.GothamBold tl.Parent=bb ntf("Marker","Set!") end end) end,"setmarker")
btn(tP,"TP to Marker",function() pcall(function() if ST.markerObj and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then LP.Character.HumanoidRootPart.CFrame=CFrame.new(ST.markerObj.Position+Vector3.new(0,3,0)) end end) end,"tpmarker")
btn(tP,"Clear Marker",function() pcall(function() if ST.markerObj then ST.markerObj:Destroy() ST.markerObj=nil ntf("Marker","Cleared!") end end) end,"clrmarker")

sep(tP)
lbl(tP,">> WAYPOINT TP (5 MAX)")
btn(tP,"Set Waypoint 1",function() pcall(function() if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then ST.waypoints=ST.waypoints or {} ST.waypoints[1]=LP.Character.HumanoidRootPart.Position+Vector3.new(0,2,0) ntf("Waypoint","Set #1!") end end) end,"wp1")
btn(tP,"Set Waypoint 2",function() pcall(function() if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then ST.waypoints=ST.waypoints or {} ST.waypoints[2]=LP.Character.HumanoidRootPart.Position+Vector3.new(0,2,0) ntf("Waypoint","Set #2!") end end) end,"wp2")
btn(tP,"Set Waypoint 3",function() pcall(function() if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then ST.waypoints=ST.waypoints or {} ST.waypoints[3]=LP.Character.HumanoidRootPart.Position+Vector3.new(0,2,0) ntf("Waypoint","Set #3!") end end) end,"wp3")
btn(tP,"Set Waypoint 4",function() pcall(function() if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then ST.waypoints=ST.waypoints or {} ST.waypoints[4]=LP.Character.HumanoidRootPart.Position+Vector3.new(0,2,0) ntf("Waypoint","Set #4!") end end) end,"wp4")
btn(tP,"Set Waypoint 5",function() pcall(function() if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then ST.waypoints=ST.waypoints or {} ST.waypoints[5]=LP.Character.HumanoidRootPart.Position+Vector3.new(0,2,0) ntf("Waypoint","Set #5!") end end) end,"wp5")
btn(tP,"TP to WP 1",function() pcall(function() if ST.waypoints and ST.waypoints[1] and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then LP.Character.HumanoidRootPart.CFrame=CFrame.new(ST.waypoints[1]) end end) end,"tpwp1")
btn(tP,"TP to WP 2",function() pcall(function() if ST.waypoints and ST.waypoints[2] and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then LP.Character.HumanoidRootPart.CFrame=CFrame.new(ST.waypoints[2]) end end) end,"tpwp2")
btn(tP,"TP to WP 3",function() pcall(function() if ST.waypoints and ST.waypoints[3] and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then LP.Character.HumanoidRootPart.CFrame=CFrame.new(ST.waypoints[3]) end end) end,"tpwp3")
btn(tP,"TP to WP 4",function() pcall(function() if ST.waypoints and ST.waypoints[4] and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then LP.Character.HumanoidRootPart.CFrame=CFrame.new(ST.waypoints[4]) end end) end,"tpwp4")
btn(tP,"TP to WP 5",function() pcall(function() if ST.waypoints and ST.waypoints[5] and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then LP.Character.HumanoidRootPart.CFrame=CFrame.new(ST.waypoints[5]) end end) end,"tpwp5")
btn(tP,"Clear All Waypoints",function() ST.waypoints={} ntf("Waypoint","All cleared!") end,"clrwp")
local tEx=tF["exploit"]
lbl(tEx,">> GRAND RP EXPLOITS")
sep(tEx)
btn(tEx,"Full Heal Self",function() if cd() then pcall(function() local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=h.MaxHealth h.PlatformStand=false h:ChangeState(Enum.HumanoidStateType.GettingUp) end end) pcall(function() local r=findRemote("Hospital.EKAB") if r then r:FireServer() end end) ntf("Heal","Fully healed!") end end,"fheal")
btn(tEx,"Set Health 100",function() if cd() then pcall(function() local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=100 h.MaxHealth=100 end end) ntf("Health","Set to 100") end end,"sethp")
btn(tEx,"Set Health 9999",function() if cd() then pcall(function() local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.MaxHealth=9999 h.Health=9999 end end) ntf("Health","Set to 9999") end end,"sethpmax")
btn(tEx,"Godmode Self",function() if cd() then pcall(function() local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.MaxHealth=math.huge h.Health=math.huge h.PlatformStand=false h:ChangeState(Enum.HumanoidStateType.GettingUp) end end) ntf("Godmode","Enabled!") end end,"godself")
sep(tEx)
lbl(tEx,">> VISIBLE REMOTE EFFECTS")
btn(tEx,"Fire Weapon (Effects)",function() pcall(function() local r=findRemote("WeaponsSystem.Network.WeaponFired") if r then r:FireServer() ntf("Weapon","Fired!") end end) end,"weapfire")
btn(tEx,"Toggle Police Siren",function() pcall(function() local r=findRemote("ToggleSirenEvent") if r then r:FireServer() ntf("Siren","Toggled!") end end) end,"siren")
btn(tEx,"Spam Siren x5",function() if cd() then pcall(function() local r=findRemote("ToggleSirenEvent") if r then for i=1,5 do r:FireServer() task.wait(0.1) end ntf("Siren","Spam x5!") end end) end end,"siren5")
btn(tEx,"Weapon Hit (Fake)",function() pcall(function() local r=findRemote("WeaponsSystem.Network.Hit") if r then local ch=LP.Character if ch then local hrp=ch:FindFirstChild("HumanoidRootPart") if hrp then r:FireServer(hrp.Position) ntf("Weapon","Hit sent!") end end end end) end,"weaphit")
sep(tEx)
lbl(tEx,">> MAGIC BULLET")
local tMB=tog(tEx,"Magic Bullet",function() return ST.magicBullet end,function() ST.magicBullet=not ST.magicBullet if ST.magicBullet then if not _G._mbHooked then _G._mbHooked=true local oldRay oldRay=hookmetamethod(game,"__namecall",function(self,...) if not checkcaller() and getnamecallmethod()=="Raycast" and ST.magicBullet then local args={...} local rcp=args[1] local dir=args[2] local params=args[3] if params then local newParams=params:Clone() newParams.FilterType=Enum.RaycastFilterType.Include local charParts={} for _,ch in pairs(P:GetPlayers()) do if ch~=LP and ch.Character then for _,p in pairs(ch.Character:GetDescendants()) do if p:IsA("BasePart") then table.insert(charParts,p) end end end end if #charParts>0 then newParams.FilterDescendantsInstances=charParts local r=oldRay(self,rcp,dir,newParams) if r then return r end end end end return oldRay(self,unpack(args)) end) ntf("MagicBullet","ON - Bullets hit through walls!") end else ntf("MagicBullet","OFF") end end,"magbul")
table.insert(allToggles,tMB)
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
sep(tEx)
lbl(tEx,">> REMOTE SPY (LIVE LOG)")
btn(tEx,"Open Remote Spy",function()
    if ST.spySG then pcall(function() ST.spySG:Destroy() end) ST.spySG=nil ST.remoteSpyOn=false return end
    ST.remoteSpyOn=true ST.remoteSpyPaused=false ST.remoteSpyLog={}
    local SG3=Instance.new("ScreenGui") SG3.Name="RemoteSpy" SG3.ResetOnSpawn=false SG3.DisplayOrder=3 pcall(function() SG3.Parent=CG end) if not SG3.Parent then SG3.Parent=LP:WaitForChild("PlayerGui") end ST.spySG=SG3
    local PF=Instance.new("Frame") PF.Size=UDim2.new(0,550,0,400) PF.Position=UDim2.new(0.5,-275,0.5,-200) PF.BackgroundColor3=TH.p PF.BorderSizePixel=0 PF.Active=true PF.Draggable=true PF.Parent=SG3 PF.BackgroundTransparency=0 mkCorner(PF,12) mkStroke(PF,Color3.fromRGB(255,160,0),2)
    local PT=Instance.new("Frame") PT.Size=UDim2.new(1,0,0,36) PT.BackgroundColor3=TH.s PT.BorderSizePixel=0 PT.Parent=PF mkCorner(PT,12)
    local PTL=Instance.new("TextLabel") PTL.Size=UDim2.new(1,-120,1,0) PTL.Position=UDim2.new(0,12,0,0) PTL.BackgroundTransparency=1 PTL.Text="REMOTE SPY" PTL.TextColor3=Color3.fromRGB(255,160,0) PTL.TextSize=14 PTL.Font=Enum.Font.GothamBlack PTL.TextXAlignment=Enum.TextXAlignment.Left PTL.Parent=PT
    local PX=Instance.new("TextButton") PX.Size=UDim2.new(0,28,0,28) PX.Position=UDim2.new(1,-32,0,4) PX.BackgroundTransparency=1 PX.Text="X" PX.TextColor3=TH.r PX.TextSize=18 PX.Font=Enum.Font.GothamBold PX.Parent=PT
    PX.MouseButton1Click:Connect(function() ST.spySG:Destroy() ST.spySG=nil ST.remoteSpyOn=false end)
    local PBtn=Instance.new("TextButton") PBtn.Size=UDim2.new(0,60,0,22) PBtn.Position=UDim2.new(1,-100,0,7) PBtn.BackgroundColor3=TH.b PBtn.BorderSizePixel=0 PBtn.Text="Pause" PBtn.TextColor3=TH.t PBtn.TextSize=10 PBtn.Font=Enum.Font.GothamBold PBtn.Parent=PT mkCorner(PBtn,4)
    PBtn.MouseButton1Click:Connect(function() ST.remoteSpyPaused=not ST.remoteSpyPaused PBtn.Text=ST.remoteSpyPaused and "Resume" or "Pause" end)
    local CBtn=Instance.new("TextButton") CBtn.Size=UDim2.new(0,50,0,22) CBtn.Position=UDim2.new(1,-160,0,7) CBtn.BackgroundColor3=TH.b CBtn.BorderSizePixel=0 CBtn.Text="Clear" CBtn.TextColor3=TH.t CBtn.TextSize=10 CBtn.Font=Enum.Font.GothamBold CBtn.Parent=PT mkCorner(CBtn,4)
    CBtn.MouseButton1Click:Connect(function() ST.remoteSpyLog={} for _,ch in pairs(SF2:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end end)
    local SF2=Instance.new("ScrollingFrame") SF2.Size=UDim2.new(1,-16,1,-48) SF2.Position=UDim2.new(0,8,0,42) SF2.BackgroundTransparency=1 SF2.BorderSizePixel=0 SF2.ScrollBarThickness=4 SF2.ScrollBarImageColor3=Color3.fromRGB(255,160,0) SF2.CanvasSize=UDim2.new(0,0,0,0) SF2.Parent=PF SF2.AutomaticCanvasSize=Enum.AutomaticSize.Y SF2.ScrollingDirection=Enum.ScrollingDirection.Y SF2.ElasticBehavior=Enum.ElasticBehavior.Never
    local SL2=Instance.new("UIListLayout",SF2) SL2.Padding=UDim.new(0,2) SL2.SortOrder=Enum.SortOrder.LayoutOrder
    SL2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() SF2.CanvasSize=UDim2.new(0,0,0,SL2.AbsoluteContentSize.Y+8) end)
    _G._spyFrame=SF2
    _G._spyAdd=function(name,argsStr,caller)
        if ST.remoteSpyPaused then return end
        if not SF2 or not SF2.Parent then return end
        local count=#SF2:GetChildren()
        local RF=Instance.new("Frame") RF.Size=UDim2.new(1,-4,0,26) RF.BackgroundColor3=TH.b RF.BorderSizePixel=0 RF.LayoutOrder=count RF.Parent=SF2 mkCorner(RF,3)
        local ts=string.format("%.1f",tick()%100)
        local TL=Instance.new("TextLabel") TL.Size=UDim2.new(0.15,0,1,0) TL.Position=UDim2.new(0,4,0,0) TL.BackgroundTransparency=1 TL.Text=ts TL.TextColor3=Color3.fromRGB(150,150,150) TL.TextSize=10 TL.Font=Enum.Font.Code TL.TextXAlignment=Enum.TextXAlignment.Left TL.Parent=RF
        local NL=Instance.new("TextLabel") NL.Size=UDim2.new(0.35,0,1,0) NL.Position=UDim2.new(0.16,0,0,0) NL.BackgroundTransparency=1 NL.Text=name NL.TextColor3=Color3.fromRGB(255,200,0) NL.TextSize=10 NL.Font=Enum.Font.GothamBold NL.TextXAlignment=Enum.TextXAlignment.Left NL.TextTruncate=Enum.TextTruncate.AtEnd NL.Parent=RF
        local AL=Instance.new("TextLabel") AL.Size=UDim2.new(0.44,0,1,0) AL.Position=UDim2.new(0.52,0,0,0) AL.BackgroundTransparency=1 AL.Text=argsStr AL.TextColor3=Color3.fromRGB(180,180,200) AL.TextSize=9 AL.Font=Enum.Font.Code AL.TextXAlignment=Enum.TextXAlignment.Left AL.TextTruncate=Enum.TextTruncate.AtEnd AL.Parent=RF
        local CL=Instance.new("TextLabel") CL.Size=UDim2.new(0.08,0,1,0) CL.Position=UDim2.new(0.92,0,0,0) CL.BackgroundTransparency=1 CL.Text=caller CL.TextColor3=caller=="S" and Color3.fromRGB(80,255,120) or Color3.fromRGB(255,80,80) CL.TextSize=9 CL.Font=Enum.Font.GothamBold CL.TextXAlignment=Enum.TextXAlignment.Center CL.Parent=RF
        table.insert(ST.remoteSpyLog,{name=name,args=argsStr,caller=caller,time=ts})
        if #SF2:GetChildren()>200 then local first=SF2:FindFirstChildOfClass("Frame") if first then first:Destroy() end end
    end
end,"openspy")
btn(tEx,"Clear Spy Log",function() ST.remoteSpyLog={} if _G._spyFrame then for _,ch in pairs(_G._spyFrame:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end end ntf("Spy","Cleared!") end,"clrspry")
sep(tEx)
lbl(tEx,">> AIMBOT")
local tAim=tog(tEx,"Aimbot (Silent)",function() return ST.aimEnabled end,function() ST.aimEnabled=not ST.aimEnabled if ST.aimEnabled then ntf("Aimbot","ON - Silent Aim") else ntf("Aimbot","OFF") end end,"aimbot")
table.insert(allToggles,tAim)
btn(tEx,"Aim Target: Head",function() ST.aimTargetPart="Head" ntf("Aimbot","Target: Head") end,"aimhead")
btn(tEx,"Aim Target: Torso",function() ST.aimTargetPart="Torso" ntf("Aimbot","Target: Torso") end,"aimtorso")
btn(tEx,"Aim Target: HRP",function() ST.aimTargetPart="HumanoidRootPart" ntf("Aimbot","Target: HRP") end,"aimhrp")
btn(tEx,"FOV: 80",function() ST.aimFOV=80 if ST.aimFOVGui then ST.aimFOVGui.Size=UDim2.new(0,160,0,160) end ntf("Aimbot","FOV: 80") end,"aimfov80")
btn(tEx,"FOV: 120",function() ST.aimFOV=120 if ST.aimFOVGui then ST.aimFOVGui.Size=UDim2.new(0,240,0,240) end ntf("Aimbot","FOV: 120") end,"aimfov120")
btn(tEx,"FOV: 200",function() ST.aimFOV=200 if ST.aimFOVGui then ST.aimFOVGui.Size=UDim2.new(0,400,0,400) end ntf("Aimbot","FOV: 200") end,"aimfov200")
local tAimTC=tog(tEx,"Team Check",function() return ST.aimTeamCheck end,function() ST.aimTeamCheck=not ST.aimTeamCheck ntf("Aimbot","TeamCheck: "..(ST.aimTeamCheck and "ON" or "OFF")) end,"aimtc")
table.insert(allToggles,tAimTC)
local tMi=tF["misc"]
lbl(tMi,">> MISC")
btn(tMi,"Reset Character",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=0 end end end,"reset")
btn(tMi,"Anti-AFK",function() pcall(function() LP.Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Running) end) end,"antiafk")
local tAC=tog(tMi,"Auto Clicker",function() return ST.autoClicker end,function() ST.autoClicker=not ST.autoClicker ntf("AutoClick",ST.autoClicker and "ON (5 CPS)" or "OFF") end,"autoclick")
table.insert(allToggles,tAC)
local tVS=tog(tMi,"Vehicle Speed",function() return ST.vehicleSpeedOn end,function() ST.vehicleSpeedOn=not ST.vehicleSpeedOn ntf("VehicleSpeed",ST.vehicleSpeedOn and "ON - Will increase when seated" or "OFF") end,"vehspeed")
table.insert(allToggles,tVS)
local tAL=tog(tMi,"ArrayList",function() return ST.arrayList end,function() ST.arrayList=not ST.arrayList ntf("ArrayList",ST.arrayList and "ON" or "OFF") end,"arraylist")
table.insert(allToggles,tAL)
btn(tMi,"Third Person",function() pcall(function() LP.CameraMinZoomDistance=10 LP.CameraMaxZoomDistance=10 end) end,"3rdperson")
btn(tMi,"First Person",function() pcall(function() LP.CameraMinZoomDistance=0.5 LP.CameraMaxZoomDistance=0.5 end) end,"1stperson")
btn(tMi,"Infinite Yield Load",function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end) ntf("IY","Loading Infinite Yield...") end,"infyield")
sep(tMi)
lbl(tMi,">> ANTI-AFK")
btn(tMi,"Anti-AFK (Proper)",function() pcall(function() if not ST._antiafkHooked then local vu=game:GetService("VirtualUser") LP.Idled:Connect(function() vu:CaptureController() vu:ClickButton2(Vector2.new()) end) ST._antiafkHooked=true ntf("Anti-AFK","Hooked with VirtualUser!") end end) end,"antiafk2")
sep(tMi)
lbl(tMi,">> BOT (RECORD/PLAY)")
local tBotR=tog(tMi,"Bot Record",function() return ST.botRecord end,function() ST.botRecord=not ST.botRecord if ST.botRecord then ST.botFrames={} ST.botStart=tick() ntf("Bot","Recording...") else ntf("Bot","Stopped. Frames: "..#ST.botFrames) end end,"botrec")
table.insert(allToggles,tBotR)
local tBotP=tog(tMi,"Bot Play",function() return ST.botPlay end,function() ST.botPlay=not ST.botPlay if ST.botPlay then if #ST.botFrames==0 then ST.botPlay=false ntf("Bot","No recording!") return end ST.botStart=tick() ntf("Bot","Playing. Frames: "..#ST.botFrames) else ntf("Bot","Stopped playback") end end,"botplay")
table.insert(allToggles,tBotP)
local tBotL=tog(tMi,"Bot Loop",function() return ST.botLoop end,function() ST.botLoop=not ST.botLoop ntf("BotLoop",ST.botLoop and "ON" or "OFF") end,"botloop")
table.insert(allToggles,tBotL)
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
sep(tSe)
lbl(tSe,">> CONFIG SAVE / LOAD")
btn(tSe,"Save Config",function() pcall(function() local cfg={kb={},esp={color={CFG.ESPColor.R,CFG.ESPColor.G,CFG.ESPColor.B},fillAlpha=CFG.ESPFillAlpha,outline=CFG.ESPOutlineEnabled,fill=CFG.ESPFillEnabled,name=CFG.ESPShowName,health=CFG.ESPShowHealth,distance=CFG.ESPShowDistance}} for id,key in pairs(KB) do cfg.kb[id]=tostring(key) end writefile("AxynthConfig.json",game:GetService("HttpService"):JSONEncode(cfg)) ntf("Config","Saved to AxynthConfig.json!") end) end,"savecfg")
btn(tSe,"Load Config",function() pcall(function() if readfile then local raw=readfile("AxynthConfig.json") if raw then local cfg=game:GetService("HttpService"):JSONDecode(raw) if cfg.kb then for id,str in pairs(cfg.kb) do KB[id]=str end end if cfg.esp then local c=cfg.esp if c.color then CFG.ESPColor=Color3.new(c.color[1],c.color[2],c.color[3]) end if c.fillAlpha then CFG.ESPFillAlpha=c.fillAlpha end if c.outline~=nil then CFG.ESPOutlineEnabled=c.outline end if c.fill~=nil then CFG.ESPFillEnabled=c.fill end if c.name~=nil then CFG.ESPShowName=c.name end if c.health~=nil then CFG.ESPShowHealth=c.health end if c.distance~=nil then CFG.ESPShowDistance=c.distance end end for _,t in pairs(allToggles) do if togUpdates[t] then togUpdates[t]() end end ntf("Config","Loaded from AxynthConfig.json!") end end end) end,"loadcfg")
btn(tSe,"Delete Config",function() pcall(function() if delfile then delfile("AxynthConfig.json") ntf("Config","Deleted!") end end) end,"delcfg")
sep(tSe)
lbl(tSe,">> UNHOOK / CLEANUP")
btn(tSe,"Unload Everything",function() pcall(function() ST.fly=false ST.noclip=false ST.clickTP=false ST.esp=false ST.spinner=false ST.autoClicker=false ST.infJump=false ST.freeCam=false U.MouseBehavior=Enum.MouseBehavior.Default ST.maceTP=false ST.botRecord=false ST.botPlay=false ST.botLoop=false ST.godmodeLoop=false ST.speedHard=false ST.infStamina=false ST.magicBullet=false ST.vehicleSpeedOn=false ST.arrayList=false ST.aimEnabled=false ST.remoteSpyOn=false if ST.aimFOVGui then ST.aimFOVGui:Destroy() ST.aimFOVGui=nil end if ST.spySG then pcall(function() ST.spySG:Destroy() end) ST.spySG=nil end if _G._spyFrame then _G._spyFrame=nil end if _G._spyAdd then _G._spyAdd=nil end if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=16 h.JumpPower=50 h.PlatformStand=false end end W.Gravity=196.2 if ST.markerObj then ST.markerObj:Destroy() ST.markerObj=nil end for id,hl in pairs(ST.espList) do if hl and hl.Parent then hl:Destroy() end end ST.espList={} for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character then local b=pp.Character:FindFirstChild("AxESP_2D") if b then b:Destroy() end end end for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and pp.Character:FindFirstChild("AxESP_BB") then pp.Character.AxESP_BB:Destroy() end if pp~=LP and pp.Character and pp.Character:FindFirstChild("AxESP") then pp.Character.AxESP:Destroy() end end if ST.savedCollide then ST.savedCollide={} end if ST.savedLighting then L.Brightness=ST.savedLighting.Brightness L.GlobalShadows=ST.savedLighting.GlobalShadows L.FogEnd=ST.savedLighting.FogEnd L.Ambient=ST.savedLighting.Ambient L.OutdoorAmbient=ST.savedLighting.OutdoorAmbient L.ClockTime=ST.savedLighting.ClockTime ST.savedLighting=nil end if ST.cursorTPPreview and ST.cursorTPPreview.Parent then ST.cursorTPPreview:Destroy() ST.cursorTPPreview=nil end if _G.AxArrayList and _G.AxArrayList.Parent then _G.AxArrayList:Destroy() _G.AxArrayList=nil end ntf("Cleanup","All features disabled!") end) end,"unload")
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
            elseif id=="freecam" then ST.freeCam=not ST.freeCam if ST.freeCam then CAM.CameraType=Enum.CameraType.Scriptable U.MouseBehavior=Enum.MouseBehavior.LockCenter else CAM.CameraType=Enum.CameraType.Custom U.MouseBehavior=Enum.MouseBehavior.Default if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h end end end
            elseif id=="clicktp" then ST.clickTP=not ST.clickTP if ST.clickTP then if not ST.cursorTPPreview then local p=Instance.new("Part") p.Name="AxCTPPreview" p.Size=Vector3.new(3,0.2,3) p.Anchored=true p.CanCollide=false p.Material=Enum.Material.Neon p.Color=Color3.fromRGB(255,0,0) p.Transparency=0.5 p.Parent=W ST.cursorTPPreview=p end else if ST.cursorTPPreview then ST.cursorTPPreview:Destroy() ST.cursorTPPreview=nil end end
            elseif id=="esp" then ST.esp=not ST.esp if ST.esp then for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and not pp.Character:FindFirstChild("AxESP") then local hl=Instance.new("Highlight") hl.Name="AxESP" hl.FillColor=CFG.ESPColor hl.FillTransparency=CFG.ESPFillAlpha hl.OutlineColor=Color3.new(1,1,1) hl.OutlineTransparency=0 hl.Parent=pp.Character ST.espList[pp.UserId]=hl end end else for uid,hl in pairs(ST.espList) do if hl and hl.Parent then hl:Destroy() end ST.espList[uid]=nil end end
            elseif id=="night" then ST.night=not ST.night
            elseif id=="bright" then ST.bright=not ST.bright if ST.bright and not ST.savedLighting then ST.savedLighting={Brightness=L.Brightness,GlobalShadows=L.GlobalShadows,FogEnd=L.FogEnd,Ambient=L.Ambient,OutdoorAmbient=L.OutdoorAmbient,ClockTime=L.ClockTime} elseif not ST.bright and ST.savedLighting then pcall(function() L.Brightness=ST.savedLighting.Brightness L.GlobalShadows=ST.savedLighting.GlobalShadows L.FogEnd=ST.savedLighting.FogEnd L.Ambient=ST.savedLighting.Ambient L.OutdoorAmbient=ST.savedLighting.OutdoorAmbient L.ClockTime=ST.savedLighting.ClockTime end) ST.savedLighting=nil end
            elseif id=="nofog" then ST.noFog=not ST.noFog
            elseif id=="aimbot" then ST.aimEnabled=not ST.aimEnabled if ST.aimEnabled then ntf("Aimbot","ON") else ntf("Aimbot","OFF") end
            elseif id=="infjump" then ST.infJump=not ST.infJump if ST.infJump then ntf("InfJump","ON - Hold Space") end
            elseif id=="godloop" then ST.godmodeLoop=not ST.godmodeLoop
            elseif id=="speedhard" then ST.speedHard=not ST.speedHard
            elseif id=="infstam" then ST.infStamina=not ST.infStamina
            elseif id=="magbul" then ST.magicBullet=not ST.magicBullet
            elseif id=="spinner" then ST.spinner=not ST.spinner if not ST.spinner and LP.Character then for _,v in pairs(LP.Character:GetDescendants()) do if v:IsA("BodyAngularVelocity") and v.Name:find("AxSpin") then v:Destroy() end end end end
            elseif id=="autoclick" then ST.autoClicker=not ST.autoClicker
            elseif id=="flybyp" then ST.flyBypass=not ST.flyBypass
            elseif id=="macetp" then ST.maceTP=not ST.maceTP
            elseif id=="vehspeed" then ST.vehicleSpeedOn=not ST.vehicleSpeedOn
            elseif id=="arraylist" then ST.arrayList=not ST.arrayList
            end
            for _,t in pairs(allToggles) do if togUpdates[t] then togUpdates[t]() end end
        end
    if inp.KeyCode==Enum.KeyCode.F4 then ST.menuOpen=not ST.menuOpen if ST.menuOpen then MF.Visible=true MF.BackgroundTransparency=1 MF.Size=UDim2.new(0,520,0,420) tw(MF,{BackgroundTransparency=0.02,Size=UDim2.new(0,520,0,480),Position=UDim2.new(0.5,-260,0.5,-240)},0.35) else tw(MF,{Position=UDim2.new(0.5,-260,0.5,-280),BackgroundTransparency=1,Size=UDim2.new(0,520,0,420)},0.25) wait(0.25) MF.Visible=false MF.Position=UDim2.new(0.5,-260,0.5,-240) MF.Size=UDim2.new(0,520,0,480) MF.BackgroundTransparency=0.02 end end
end)
MS.Button1Down:Connect(function() if ST.clickTP and LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h and MS.Hit then h.CFrame=CFrame.new(MS.Hit.Position+Vector3.new(0,2,0)) end end end)
U.JumpRequest:Connect(function()
    if ST.infJump and LP.Character then
        pcall(function()
            local h=LP.Character:FindFirstChildOfClass("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end)
print("[Axynth] Events OK")
R.RenderStepped:Connect(function()
    if ST.fly and LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h then h.Velocity=Vector3.new(0,0,0) h.RotVelocity=Vector3.new(0,0,0) local dir=Vector3.new(0,0,0) local sp=ST.flySpeed if U:IsKeyDown(Enum.KeyCode.LeftShift) then sp=sp*3 end if U:IsKeyDown(Enum.KeyCode.W) then dir=dir+CAM.CFrame.LookVector end if U:IsKeyDown(Enum.KeyCode.S) then dir=dir-CAM.CFrame.LookVector end if U:IsKeyDown(Enum.KeyCode.A) then dir=dir-CAM.CFrame.RightVector end if U:IsKeyDown(Enum.KeyCode.D) then dir=dir+CAM.CFrame.RightVector end if U:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end if U:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end if dir.Magnitude>0 then dir=dir.Unit end h.CFrame=h.CFrame+dir*sp/60 end end
    if ST.godmodeLoop and LP.Character then pcall(function() local hum=LP.Character:FindFirstChildOfClass("Humanoid") if hum then hum.Health=hum.MaxHealth end end) end
    if ST.infStamina and LP.Character then pcall(function() local ch=LP.Character local hum=ch:FindFirstChildOfClass("Humanoid") if hum then hum.WalkSpeed=70 for _,v in pairs(ch:GetDescendants()) do if v:IsA("NumberValue") or v:IsA("IntValue") then local n=v.Name:lower() if n:find("stamina") or n:find("stam") or n:find("endurance") or n:find("energy") then v.Value=v.MaxValue or 100 end end end end end) end

    if ST.noclip and LP.Character then pcall(function() for _,p2 in pairs(LP.Character:GetDescendants()) do if p2:IsA("BasePart") then if ST.savedCollide[p2]==nil then ST.savedCollide[p2]=p2.CanCollide end p2.CanCollide=false end end end) end
    if ST.spinner and LP.Character then pcall(function() local hrp=LP.Character:FindFirstChild("HumanoidRootPart") if hrp then local sv=hrp:FindFirstChild("AxSpin") if not sv then sv=Instance.new("BodyAngularVelocity") sv.Name="AxSpin" sv.AngularVelocity=Vector3.new(0,ST.spinnerSpeed,0) sv.MaxTorque=Vector3.new(0,math.huge,0) sv.P=10000 sv.Parent=hrp end sv.AngularVelocity=Vector3.new(0,ST.spinnerSpeed,0) sv.MaxTorque=Vector3.new(0,math.huge,0) end end) end
    if ST.autoClicker then pcall(function() mouse1click() end) end
    if ST.night then pcall(function() L.ClockTime=0 L.Brightness=0 end) end
    if ST.bright then pcall(function() L.Brightness=2 L.GlobalShadows=false L.Ambient=Color3.fromRGB(178,178,178) L.OutdoorAmbient=Color3.fromRGB(178,178,178) end) end
    if ST.noFog then pcall(function() L.FogEnd=999999 L.FogStart=0 L.Atmosphere.Density=0 end) end
    if ST.maceTP and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then local myRoot=LP.Character.HumanoidRootPart local nearestDist=math.huge local nearestRoot=nil for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and pp.Character:FindFirstChild("HumanoidRootPart") and pp.Character:FindFirstChildOfClass("Humanoid") then local hum2=pp.Character:FindFirstChildOfClass("Humanoid") if hum2.Health>0 then local d=(myRoot.Position-pp.Character.HumanoidRootPart.Position).Magnitude if d<nearestDist then nearestDist=d nearestRoot=pp.Character.HumanoidRootPart end end end end if nearestRoot then local off=ST.maceTPOffset or 3 myRoot.CFrame=nearestRoot.CFrame*CFrame.new(0,0,off) end end
    if ST.botRecord and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then table.insert(ST.botFrames,{t=tick()-ST.botStart,cf=LP.Character.HumanoidRootPart.CFrame:clone()}) end
    if ST.botPlay and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then if #ST.botFrames>0 then local elapsed=tick()-ST.botStart local idx=1 for i=1,#ST.botFrames do if ST.botFrames[i].t<=elapsed then idx=i else break end end if idx>#ST.botFrames then if ST.botLoop then ST.botStart=tick() idx=1 else ST.botPlay=false ntf("Bot","Playback finished!") end end if ST.botPlay and ST.botFrames[idx] then LP.Character.HumanoidRootPart.CFrame=ST.botFrames[idx].cf end end end
        if ST.spectateOverhead and ST.spectating and ST.spectating.Character and ST.spectating.Character:FindFirstChild("HumanoidRootPart") then pcall(function() local pos=ST.spectating.Character.HumanoidRootPart.Position CAM.CFrame=CFrame.new(pos+Vector3.new(0,25,0),pos) end) end
if ST.cursorTPPreview then if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then local m=MS.Hit if m then ST.cursorTPPreview.Position=m.Position+Vector3.new(0,3,0) end end end
    if ST.freeCam then pcall(function() if CAM then CAM.CameraType=Enum.CameraType.Scriptable end local dir=Vector3.new(0,0,0) local sp=1 if U:IsKeyDown(Enum.KeyCode.LeftShift) then sp=2 end if U:IsKeyDown(Enum.KeyCode.W) then dir=dir+CAM.CFrame.LookVector end if U:IsKeyDown(Enum.KeyCode.S) then dir=dir-CAM.CFrame.LookVector end if U:IsKeyDown(Enum.KeyCode.A) then dir=dir-CAM.CFrame.RightVector end if U:IsKeyDown(Enum.KeyCode.D) then dir=dir+CAM.CFrame.RightVector end if U:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end if U:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end local md=U:GetMouseDelta() if md then ST.freeCamYaw=(ST.freeCamYaw or 0)-md.X*0.002 ST.freeCamPitch=math.clamp((ST.freeCamPitch or 0)-md.Y*0.002,-1.2,1.2) end local cf=CFrame.new(CAM.CFrame.Position)*CFrame.Angles(0,ST.freeCamYaw or 0,0)*CFrame.Angles(ST.freeCamPitch or 0,0,0) CAM.CFrame=cf+dir*sp end) end
    if ST.esp and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local myPos=LP.Character.HumanoidRootPart.Position
        for _,pp in pairs(P:GetPlayers()) do
            if pp~=LP and pp.Character and pp.Character:FindFirstChild("HumanoidRootPart") and pp.Character:FindFirstChildOfClass("Humanoid") then
                local hrp=pp.Character.HumanoidRootPart
                local hum=pp.Character:FindFirstChildOfClass("Humanoid")
                local dist=(myPos-hrp.Position).Magnitude
                if dist>CFG.ESPMaxDist then local bb2=pp.Character:FindFirstChild("AxESP_BB") if bb2 then bb2:Destroy() end local box2=pp.Character:FindFirstChild("AxESP_2D") if box2 then box2:Destroy() end continue end
                local head=pp.Character:FindFirstChild("Head")
                local headY=head and head.Position.Y+3 or hrp.Position.Y+3
                if CFG.ESP2D then
                    local topPos,onTop=CAM:WorldToViewportPoint(Vector3.new(hrp.Position.X,headY,hrp.Position.Z))
                    local botPos,onBot=CAM:WorldToViewportPoint(hrp.Position-Vector3.new(0,3,0))
                    local esp2d=pp.Character:FindFirstChild("AxESP_2D")
                    if not esp2d then esp2d=Instance.new("Frame") esp2d.Name="AxESP_2D" esp2d.AnchorPoint=Vector2.new(0.5,0.5) esp2d.BorderSizePixel=0 esp2d.Parent=SG end
                    if onTop and onBot then
                        local boxH=math.abs(topPos.Y-botPos.Y)
                        local boxW=boxH*0.6
                        esp2d.Size=UDim2.new(0,boxW,0,boxH)
                        esp2d.Position=UDim2.new(0,(topPos.X+botPos.X)/2,0,(topPos.Y+botPos.Y)/2)
                        esp2d.BackgroundColor3=CFG.ESPColor
                        esp2d.BackgroundTransparency=0.85
                        esp2d.Visible=true
                        local corner=esp2d:FindFirstChild("Corner") if not corner then corner=Instance.new("UICorner") corner.Name="Corner" corner.CornerRadius=UDim.new(0,0) corner.Parent=esp2d end
                        local stroke=esp2d:FindFirstChild("Stroke") if not stroke then stroke=Instance.new("UIStroke") stroke.Name="Stroke" stroke.Color=CFG.ESPColor stroke.Thickness=CFG.ESPThickness stroke.Parent=esp2d end
                        stroke.Color=CFG.ESPColor stroke.Thickness=CFG.ESPThickness
                    else
                        esp2d.Visible=false
                    end
                else
                    local old2d=pp.Character:FindFirstChild("AxESP_2D") if old2d then old2d:Destroy() end
                end
                local bb=pp.Character:FindFirstChild("AxESP_BB")
                if not bb then
                    bb=Instance.new("BillboardGui") bb.Name="AxESP_BB" bb.Size=UDim2.new(0,150,0,40) bb.StudsOffset=Vector3.new(0,3,0) bb.AlwaysOnTop=true bb.LightInfluence=0 bb.Parent=pp.Character
                    local nL=Instance.new("TextLabel") nL.Name="NL" nL.Size=UDim2.new(1,0,0.4,0) nL.Position=UDim2.new(0,0,0,0) nL.BackgroundTransparency=1 nL.TextColor3=CFG.ESPTextColor nL.TextStrokeTransparency=0.5 nL.TextStrokeColor3=Color3.new(0,0,0) nL.TextSize=11 nL.Font=Enum.Font.GothamBold nL.Parent=bb
                    local hB=Instance.new("Frame") hB.Name="HB" hB.Size=UDim2.new(0.8,0,0.2,0) hB.Position=UDim2.new(0.1,0,0.5,0) hB.BackgroundColor3=Color3.new(0.2,0.2,0.2) hB.BorderSizePixel=0 hB.Parent=bb
                    local hF=Instance.new("Frame") hF.Name="HF" hF.Size=UDim2.new(1,0,1,0) hF.BackgroundColor3=TH.g hF.BorderSizePixel=0 hF.Parent=hB
                    local dL=Instance.new("TextLabel") dL.Name="DL" dL.Size=UDim2.new(1,0,0.3,0) dL.Position=UDim2.new(0,0,0.7,0) dL.BackgroundTransparency=1 dL.TextColor3=CFG.ESPTextColor dL.TextStrokeTransparency=0.5 dL.TextStrokeColor3=Color3.new(0,0,0) dL.TextSize=8 dL.Font=Enum.Font.Gotham dL.Parent=bb
                end
                local nL=bb:FindFirstChild("NL")
                local hB=bb:FindFirstChild("HB")
                local hF=hB and hB:FindFirstChild("HF")
                local dL=bb:FindFirstChild("DL")
                if nL then
                    local txt=""
                    if CFG.ESPShowName then txt=txt..pp.DisplayName end
                    if CFG.ESPShowHealth then txt=txt.." ["..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth).."]" end
                    nL.Text=txt
                    nL.TextColor3=CFG.ESPTextColor
                    nL.Visible=CFG.ESPShowName or CFG.ESPShowHealth
                end
                if hB then
                    hB.Visible=CFG.ESPShowHealth
                    if hF then
                        local hp=math.clamp(hum.Health/hum.MaxHealth,0,1)
                        hF.Size=UDim2.new(hp,0,1,0)
                        if hp>0.5 then hF.BackgroundColor3=TH.g elseif hp>0.25 then hF.BackgroundColor3=Color3.fromRGB(255,200,0) else hF.BackgroundColor3=TH.r end
                    end
                end
                if dL then
                    dL.Visible=CFG.ESPShowDistance
                    dL.Text=math.floor(dist).."m"
                    dL.TextColor3=CFG.ESPTextColor
                end
                local hl=pp.Character:FindFirstChild("AxESP")
                if hl then
                    hl.FillColor=CFG.ESPColor
                    hl.FillTransparency=CFG.ESPFillEnabled and CFG.ESPFillAlpha or 1
                    hl.OutlineColor=CFG.ESPOutlineColor
                    hl.OutlineTransparency=CFG.ESPOutlineEnabled and 0 or 1
                end
            end
        end
    end
    if ST.esp then
        for uid,hl in pairs(ST.espList) do
            local pp=P:GetPlayerByUserId(uid)
            if not pp or not pp.Character or not pp.Character:FindFirstChild("HumanoidRootPart") then
                if hl and hl.Parent then hl:Destroy() end
                ST.espList[uid]=nil
            end
        end
        for _,pp in pairs(P:GetPlayers()) do
            if pp~=LP and pp.Character and not ST.espList[pp.UserId] then
                local hl=Instance.new("Highlight") hl.Name="AxESP" hl.FillColor=CFG.ESPColor hl.FillTransparency=CFG.ESPFillEnabled and CFG.ESPFillAlpha or 1 hl.OutlineColor=CFG.ESPOutlineColor hl.OutlineTransparency=CFG.ESPOutlineEnabled and 0 or 1 hl.Parent=pp.Character ST.espList[pp.UserId]=hl
            end
        end
    end
    if ST.aimEnabled then pcall(function()
        if not ST.aimFOVGui then local s=Instance.new("ScreenGui") s.Name="AimFOV" s.ResetOnSpawn=false s.DisplayOrder=50 s.IgnoreGuiInset=true pcall(function() s.Parent=CG end) if not s.Parent then s.Parent=LP:WaitForChild("PlayerGui") end local c=Instance.new("Frame") c.Name="Circle" c.AnchorPoint=Vector2.new(0.5,0.5) c.Position=UDim2.new(0.5,0,0.5,0) c.Size=UDim2.new(0,ST.aimFOV*2,0,ST.aimFOV*2) c.BackgroundTransparency=1 c.BorderSizePixel=0 c.Parent=s local st=Instance.new("UIStroke") st.Color=Color3.fromRGB(255,80,80) st.Thickness=1.5 st.Transparency=0.3 st.Parent=c local cr=Instance.new("UICorner") cr.CornerRadius=UDim.new(1,0) cr.Parent=c ST.aimFOVGui=s end
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character:FindFirstChildOfClass("Humanoid") then
            local hum=LP.Character:FindFirstChildOfClass("Humanoid")
            local camPos=CAM.CFrame.Position
            local bestTarget=nil local bestDist=ST.aimFOV
            for _,pp in pairs(P:GetPlayers()) do
                if pp~=LP and pp.Character and pp.Character:FindFirstChild(ST.aimTargetPart) and pp.Character:FindFirstChildOfClass("Humanoid") then
                    if pp.Character:FindFirstChildOfClass("Humanoid").Health>0 then
                        if ST.aimTeamCheck and pp.Team==LP.Team then continue end
                        local tgtPos=pp.Character[ST.aimTargetPart].Position
                        local sp,onscreen=CAM:WorldToViewportPoint(tgtPos)
                        if onscreen then
                            local vp=Vector2.new(sp.X,sp.Y)
                            local center=Vector2.new(CAM.ViewportSize.X/2,CAM.ViewportSize.Y/2)
                            local d=(vp-center).Magnitude
                            if d<bestDist then bestDist=d bestTarget=pp end
                        end
                    end
                end
            end
            if bestTarget and bestTarget.Character and bestTarget.Character:FindFirstChild("HumanoidRootPart") then
                ST.aimTarget=bestTarget
                local tgtPos=bestTarget.Character[ST.aimTargetPart].Position
                local lookDir=CFrame.lookAt(camPos,tgtPos)
                CAM.CFrame=CAM.CFrame:Lerp(lookDir,0.3)
                local hrp=LP.Character.HumanoidRootPart
                local gyro=hrp:FindFirstChild("AimGyro")
                if not gyro then gyro=Instance.new("BodyGyro") gyro.Name="AimGyro" gyro.MaxTorque=Vector3.new(0,math.huge,0) gyro.P=10000 gyro.D=500 gyro.Parent=hrp end
                gyro.CFrame=CFrame.lookAt(hrp.Position,Vector3.new(tgtPos.X,hrp.Position.Y,tgtPos.Z))
            else
                ST.aimTarget=nil
                local hrp2=LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp2 then local g=hrp2:FindFirstChild("AimGyro") if g then g:Destroy() end end
            end
        end
    end)
    else
        if ST.aimFOVGui then ST.aimFOVGui:Destroy() ST.aimFOVGui=nil end
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then local g=LP.Character.HumanoidRootPart:FindFirstChild("AimGyro") if g then g:Destroy() end end
        ST.aimTarget=nil
    end
    if ST.arrayList then
        if not _G.AxArrayList then local sg=Instance.new("ScreenGui") sg.Name="AxArrayList" sg.ResetOnSpawn=false sg.DisplayOrder=999 sg.IgnoreGuiInset=true pcall(function() sg.Parent=CG end) if not sg.Parent then sg.Parent=LP:WaitForChild("PlayerGui") end _G.AxArrayList=sg local f=Instance.new("Frame") f.Name="Container" f.Size=UDim2.new(0,180,0,20) f.Position=UDim2.new(1,-190,1,-30) f.BackgroundTransparency=1 f.Parent=sg local l=Instance.new("UIListLayout",f) l.SortOrder=Enum.SortOrder.LayoutOrder l.HorizontalAlignment=Enum.HorizontalAlignment.Right end
        local c=_G.AxArrayList:FindFirstChild("Container") if c then for _,ch in pairs(c:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end local entries={} local function addE(name) table.insert(entries,name) end if ST.fly then addE("Fly") end if ST.noclip then addE("Noclip") end if ST.esp then addE("ESP") end if ST.infJump then addE("InfJump") end if ST.spinner then addE("Spinner") end if ST.autoClicker then addE("AutoClick") end if ST.godmodeLoop then addE("Godmode") end if ST.speedHard then addE("SpeedHard") end if ST.infStamina then addE("InfStam") end if ST.magicBullet then addE("MagicBul") end if ST.maceTP then addE("MaceTP") end if ST.freeCam then addE("FreeCam") end if ST.clickTP then addE("ClickTP") end if ST.bright then addE("Fullbright") end if ST.night then addE("Night") end             if ST.noFog then addE("NoFog") end if ST.vehicleSpeedOn then addE("VehicleSpeed") end if ST.botPlay then addE("BotPlay") end if ST.botRecord then addE("BotRec") end for i,name in pairs(entries) do local ef=Instance.new("Frame") ef.Size=UDim2.new(0,160,0,22) ef.BackgroundColor3=Color3.fromRGB(0,0,0) ef.BackgroundTransparency=0.4 ef.BorderSizePixel=0 ef.LayoutOrder=i ef.Parent=c mkCorner(ef,4) local et=Instance.new("TextLabel") et.Size=UDim2.new(1,-8,1,0) et.Position=UDim2.new(0,4,0,0) et.BackgroundTransparency=1 et.Text=name et.TextColor3=TH.a et.TextSize=12 et.Font=Enum.Font.GothamBold et.TextXAlignment=Enum.TextXAlignment.Right et.Parent=ef end end
    elseif _G.AxArrayList then _G.AxArrayList:Destroy() _G.AxArrayList=nil end
end)
P.PlayerAdded:Connect(function(pp) pp.CharacterAdded:Connect(function(ch) wait(1) if ST.esp and pp~=LP then local hl=Instance.new("Highlight") hl.Name="AxESP" hl.FillColor=CFG.ESPColor hl.FillTransparency=CFG.ESPFillAlpha hl.OutlineColor=Color3.new(1,1,1) hl.OutlineTransparency=0 hl.Parent=ch ST.espList[pp.UserId]=hl end end) end)
LP.CharacterAdded:Connect(function(ch) task.wait(1) ST.savedCollide={} if ST.spinner then task.delay(0.5,function() if ch and LP.Character==ch then local hrp=ch:FindFirstChild("HumanoidRootPart") if hrp then local sv=Instance.new("BodyAngularVelocity") sv.Name="AxSpin" sv.AngularVelocity=Vector3.new(0,ST.spinnerSpeed,0) sv.MaxTorque=Vector3.new(0,math.huge,0) sv.P=10000 sv.Parent=hrp end end end) end if ST.speedHard then task.delay(0.5,function() local hum=ch:FindFirstChildOfClass("Humanoid") if hum then hum.WalkSpeed=70 end end) end if ST.godmodeLoop then task.delay(0.5,function() local hum=ch:FindFirstChildOfClass("Humanoid") if hum then hum.Health=hum.MaxHealth end end) end end)
P.PlayerRemoving:Connect(function(pp) if ST.espList[pp.UserId] then ST.espList[pp.UserId]:Destroy() ST.espList[pp.UserId]=nil end end)
for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and pp.Character:FindFirstChild("AxESP_BB") then pp.Character.AxESP_BB:Destroy() end end
print("[Axynth] MENU LOADED! Press F4!")
end)
if not ok then print("[Axynth] ERROR: "..tostring(err)) end
