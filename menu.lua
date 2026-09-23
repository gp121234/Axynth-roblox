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
local ST={}
-- ANTI-BAN SYSTEM v9 SAFE - single guarded namecall only
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
    ["WeaponsSystem.Network.Hit"]=true,
    ["WeaponsSystem.Network.WeaponHitConfirm"]=true,
    ["WeaponsSystem.Network.Damage"]=true,
    ["WeaponsSystem.Network.Hurt"]=true,
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
        local args = {...}
        local method = getnamecallmethod()
        local ok, res = pcall(function()
            if method=="Raycast" and ST.magicBullet and not checkcaller() then
                local rcp,dir,params=args[1],args[2],args[3]
                if typeof(rcp)=="Vector3" and typeof(dir)=="Vector3" and params~=nil then
                    if not _G._mbParts or tick()-(_G._mbPartsT or 0)>0.5 then
                        _G._mbPartsT=tick()
                        local cp={}
                        for _,ch in pairs(P:GetPlayers()) do
                            if ch~=LP and ch.Character then
                                for _,p2 in pairs(ch.Character:GetDescendants()) do
                                    if p2:IsA("BasePart") then table.insert(cp,p2) end
                                end
                            end
                        end
                        _G._mbParts=cp
                    end
                    local charParts=_G._mbParts
                    if charParts and #charParts>0 then
                        local newParams=params:Clone()
                        newParams.FilterType=Enum.RaycastFilterType.Include
                        newParams.FilterDescendantsInstances=charParts
                        return oldNC(self,rcp,dir,newParams)
                    end
                end
            end
            if (method=="FireServer" or method=="InvokeServer") and typeof(self)=="Instance" and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
                if ST._forceFire then
                    return "PASS"
                end
                if isBlocked(self.Name) and not isWhitelisted(self.Name) then
                    table.insert(hookLog,{time=tick(),remote=self.Name,blocked=true})
                    return "BLOCK"
                end
                if isUsingExploit and not isWhitelisted(self.Name) then
                    task.delay(randomDelay(),function()
                        pcall(function() oldNC(self,unpack(args)) end)
                    end)
                    return "BLOCK"
                end
                if ST.remoteSpyOn and not ST.remoteSpyPaused then
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
                end
            end
            return "PASS"
        end)
        if not ok then return oldNC(self,unpack(args)) end
        if res=="BLOCK" then return nil end
        if res=="PASS" then return oldNC(self,unpack(args)) end
        return res
    end))
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
        if ST.freeCam then
            pcall(function()
                local hrp=char:FindFirstChild("HumanoidRootPart")
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hrp then hrp.Anchored=true hrp.Velocity=Vector3.new(0,0,0) hrp.RotVelocity=Vector3.new(0,0,0) end
                if hum then hum.WalkSpeed=0 hum.JumpPower=0 hum.AutoRotate=false end
                local cam=W.CurrentCamera or CAM
                if cam then cam.CameraType=Enum.CameraType.Scriptable end
            end)
        end
        if ST.godmodeLoop then
            pcall(function()
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hum then
                    if hum.MaxHealth<100 then hum.MaxHealth=100 end
                    hum.Health=hum.MaxHealth
                    if not ST._godHC then
                        ST._godHC=hum.HealthChanged:Connect(function(h)
                            if not ST.godmodeLoop then return end
                            pcall(function()
                                if hum.MaxHealth<100 then hum.MaxHealth=100 end
                                if h<hum.MaxHealth then hum.Health=hum.MaxHealth end
                                if h<=0 then hum.Health=hum.MaxHealth end
                            end)
                        end)
                    end
                end
            end)
        end
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
local AR = RS:FindFirstChild("AdminRemote") or RS:FindFirstChild("HDAdminRemote")
local function syncServerGod()
    pcall(function()
        if not AR then AR=RS:FindFirstChild("AdminRemote") or RS:FindFirstChild("HDAdminRemote") end
        if not AR then return end
        if ST.godmodeLoop and not ST._srvGod then
            ST._srvGod=true
            AR:FireServer("godmode",LP.Name)
        elseif not ST.godmodeLoop and ST._srvGod then
            ST._srvGod=false
            AR:FireServer("ungodmode",LP.Name)
        end
    end)
end
R.Heartbeat:Connect(function()
    _frameCount=_frameCount+1
    pcall(function()
        if ST.godmodeLoop and LP.Character then
            local hum=LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                if hum.MaxHealth<100 then hum.MaxHealth=100 end
                if hum.Health<hum.MaxHealth then hum.Health=hum.MaxHealth end
                if hum.Health<=0 then hum.Health=hum.MaxHealth end
            end
            if _frameCount%90==0 then syncServerGod() end
        elseif not ST.godmodeLoop and ST._srvGod then
            syncServerGod()
        end
    end)
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
print("[Axynth] Anti-Ban v9 SAFE | Whitelist: "..(function() local c=0 for _ in pairs(whitelistRemotes) do c=c+1 end return c end)().." | Keywords: "..#blockedKeywords.." | Hooks: 1 (namecall)")
local decoyRemotes={"ClientReplicator","CharacterReplicator","PlayerReplicator","DataReplicator"}
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
    if not AR then AR = RS:FindFirstChild("AdminRemote") or RS:FindFirstChild("HDAdminRemote") end
    if AR then AR:FireServer(a, unpack(args)) end
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
local ntf
local lastAction=0
local function cd() local now=tick() if now-lastAction<3 then ntf("Cooldown","Wait "..string.format("%.1f",3-(now-lastAction)).."s") return false end lastAction=now return true end
ST = {menuOpen=false,fly=false,noclip=false,clickTP=false,esp=false,spectating=nil,selectedPlayer=nil,flySpeed=50,night=false,bright=false,noFog=false,invisible=false,espList={},spinner=false,autoClicker=false,infJump=false,savedCollide={},flyBypass=true,godmodeLoop=false,spheresOn=false,speedHard=false,vehicleSpeedOn=false,maceTP=false,infStamina=false,magicBullet=false,weaponDmgOn=true,weaponDmg=30,weaponDmgMult=1,cursorTPPreview=nil,waypoints={},botRecord=false,botPlay=false,botLoop=false,botFrames={},botStart=0,arrayList=false,markerObj=nil,savedLighting=nil,savedGravity=196.2,spinnerSpeed=25,remoteSpyOn=false,remoteSpyPaused=false,remoteSpyLog={},spySG=nil,aimEnabled=false,aimFOV=250,aimMode="silent",aimTargetPart="Head",aimTeamCheck=true,aimHoldKey=false,aimKeyHeld=false,aimFOVGui=nil,aimTarget=nil,showFOV=false,    aimWallCheck=true,vehBoost=80,vehApplyT=0,spectateOverhead=false,ovhOff=Vector3.new(0,25,0),ovhYaw=0,ovhPitch=-1.4,ovhInit=false,speedPreset=0,jumpPreset=0}
local CFG = {ESPColor=Color3.fromRGB(255,0,0),ESPOutlineColor=Color3.new(1,1,1),ESPFillAlpha=0.5,ESPOutlineEnabled=true,ESPFillEnabled=true,ESPShowName=true,ESPShowHealth=true,ESPShowDistance=true,ESPShowTracer=false,ESPTracerColor=Color3.fromRGB(255,0,0),ESPTextColor=Color3.new(1,1,1),ESPThickness=2,ESP2D=false,ESPMaxDist=5000,AimEnabled=false,AimFOV=120,AimMode="silent",AimTargetPart="Head",AimTeamCheck=true}
local TH = {p=Color3.fromRGB(15,15,15),s=Color3.fromRGB(22,22,22),b=Color3.fromRGB(30,30,30),bh=Color3.fromRGB(45,45,45),t=Color3.fromRGB(230,230,230),a=Color3.fromRGB(255,255,255),g=Color3.fromRGB(80,255,120),r=Color3.fromRGB(255,80,80)}
local KB = {}
local KBMode={aimhold="hold",aimbot="hold"}
local KBActive={}
local kbBtns={}
local waitingForKey = nil
local togUpdates={}
local function tw(o,p,d) local t=TW:Create(o,TweenInfo.new(d or 0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),p) t:Play() return t end
local function twFast(o,p,d) local t=TW:Create(o,TweenInfo.new(d or 0.15,Enum.EasingStyle.Back,Enum.EasingDirection.Out),p) t:Play() return t end
local function mkCorner(p,r) local c=Instance.new("UICorner",p) c.CornerRadius=UDim.new(0,r or 8) return c end
local function mkStroke(p,c,w) local s=Instance.new("UIStroke",p) s.Color=c or Color3.fromRGB(60,60,90) s.Thickness=w or 1 s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border return s end
local function mkPadding(p,t,b,l,r2) local pd=Instance.new("UIPadding",p) pd.PaddingTop=UDim.new(0,t or 4) pd.PaddingBottom=UDim.new(0,b or 4) pd.PaddingLeft=UDim.new(0,l or 6) pd.PaddingRight=UDim.new(0,r2 or 6) return pd end
local function sep(p) local f=Instance.new("Frame") f.Size=UDim2.new(1,-12,0,1) f.Position=UDim2.new(0,6,0,0) f.BackgroundColor3=Color3.fromRGB(50,50,75) f.BorderSizePixel=0 f.Parent=p end
local function lbl(p,t) local l=Instance.new("TextLabel") l.Size=UDim2.new(1,-12,0,22) l.Position=UDim2.new(0,6,0,0) l.BackgroundTransparency=1 l.Text=t l.TextColor3=TH.a l.TextSize=11 l.Font=Enum.Font.GothamBold l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=p return l end
ntf=function(t,x,d) pcall(function() S:SetCore("SendNotification",{Title=t,Text=x,Duration=d or 3}) end) end
local function getKeyDisplay(key) if not key then return "NONE" end local s=tostring(key) s=s:gsub("Enum.KeyCode%.","") s=s:gsub("Enum.UserInputType%.MouseButton2","RMB") s=s:gsub("Enum.UserInputType%.MouseButton1","LMB") s=s:gsub("Enum.UserInputType%.MouseButton3","MMB") s=s:gsub("Enum.UserInputType%.","") return s end
local function refreshKBBtns() for id,kb in pairs(kbBtns) do if kb and kb.Parent then kb.Text=getKeyDisplay(KB[id]) kb.TextColor3=(KBMode[id]=="hold") and Color3.fromRGB(255,200,80) or TH.a end end end
local function cycleKBMode(id) KBMode[id]=(KBMode[id]=="hold") and "toggle" or "hold" refreshKBBtns() ntf("Keybind",(KBMode[id]=="hold") and "Mode: HOLD (while key down)" or "Mode: TOGGLE (press once)") end
local function setNight(on)
    if on then
        if ST.night then return end
        ST.night=true
        ST._nightClock=L.ClockTime
        ST._nightBright=L.Brightness
        L.ClockTime=0
        L.Brightness=0
    else
        if not ST.night then return end
        ST.night=false
        if ST._nightClock then L.ClockTime=ST._nightClock end
        if ST._nightBright then L.Brightness=ST._nightBright end
        ST._nightClock=nil
        ST._nightBright=nil
    end
end
local function setNoFog(on)
    if on then
        if ST.noFog then return end
        ST.noFog=true
        ST._fogEnd=L.FogEnd
        ST._fogStart=L.FogStart
        local atm=L:FindFirstChildOfClass("Atmosphere")
        ST._atmDen=atm and atm.Density
        L.FogEnd=999999
        L.FogStart=0
        if atm then atm.Density=0 end
    else
        if not ST.noFog then return end
        ST.noFog=false
        if ST._fogEnd then L.FogEnd=ST._fogEnd end
        if ST._fogStart then L.FogStart=ST._fogStart end
        local atm=L:FindFirstChildOfClass("Atmosphere")
        if atm and ST._atmDen then atm.Density=ST._atmDen end
        ST._fogEnd=nil
        ST._fogStart=nil
        ST._atmDen=nil
    end
end
local function setFrozen(f) pcall(function() if LP.Character then local hrp=LP.Character:FindFirstChild("HumanoidRootPart") local hum=LP.Character:FindFirstChildOfClass("Humanoid") if hrp and (not hum or not hum.Seated) then hrp.Anchored=f if f then hrp.Velocity=Vector3.new(0,0,0) hrp.RotVelocity=Vector3.new(0,0,0) end end end end) end
local function setFreeCam(on)
    if on then
        if ST.freeCam then return end
        ST.freeCam=true
        pcall(function()
            ST.spectateOverhead=false
            local ch=LP.Character
            local hum=ch and ch:FindFirstChildOfClass("Humanoid")
            local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
            if hum then
                if ST._fcWalk==nil then ST._fcWalk=hum.WalkSpeed end
                if ST._fcJump==nil then ST._fcJump=hum.JumpPower end
                if not ST._fcAS then ST._fcAS=hum.AutoRotate end
                hum.WalkSpeed=0
                hum.AutoRotate=false
            end
            if hrp then
                ST.freeCamAnchor=true
                hrp.Anchored=true
                hrp.Velocity=Vector3.new(0,0,0)
                hrp.RotVelocity=Vector3.new(0,0,0)
            end
            local cam=W.CurrentCamera or CAM
            CAM=cam
            local rx,ry=cam.CFrame:ToEulerAnglesYXZ()
            ST.freeCamYaw=ry
            ST.freeCamPitch=rx
            ST.freeCamPos=cam.CFrame.Position
            cam.CameraType=Enum.CameraType.Scriptable
            cam.CFrame=CFrame.new(ST.freeCamPos)*CFrame.Angles(rx,ry,0)
            U.MouseBehavior=Enum.MouseBehavior.Default
            pcall(function()
                local CAS=game:GetService("ContextActionService")
                CAS:BindActionAtPriority("AxFreecamSink",function() return Enum.ContextActionResult.Sink end,false,Enum.ContextActionPriority.High.Value,Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Space,Enum.KeyCode.LeftControl,Enum.KeyCode.LeftShift,Enum.KeyCode.One,Enum.KeyCode.Two,Enum.KeyCode.Three)
            end)
        end)
        ntf("FreeCam","ON - camera moves only (WASD + RMB), player idle")
    else
        local was=ST.freeCam
        ST.freeCam=false
        pcall(function()
            game:GetService("ContextActionService"):UnbindAction("AxFreecamSink")
            local ch=LP.Character
            local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
            local hum=ch and ch:FindFirstChildOfClass("Humanoid")
            if hrp then hrp.Anchored=false hrp.Velocity=Vector3.new(0,0,0) hrp.RotVelocity=Vector3.new(0,0,0) end
            if hum then
                hum.WalkSpeed=ST._fcWalk or (ST.speedHard and math.max(ST.speedPreset or 0,50) or (ST.speedPreset or 0))
                if hum.WalkSpeed<=0 then hum.WalkSpeed=16 end
                if ST.jumpPreset and ST.jumpPreset>0 then
                    if hum.UseJumpPower then hum.JumpPower=ST.jumpPreset else hum.JumpHeight=math.max(5,math.floor(ST.jumpPreset*0.14+0.5)) end
                end
                hum.AutoRotate=ST._fcAS~=false
                hum.PlatformStand=false
                local cam=W.CurrentCamera or CAM
                CAM=cam
                cam.CameraSubject=hum
                cam.CameraType=Enum.CameraType.Custom
            end
            U.MouseBehavior=Enum.MouseBehavior.Default
        end)
        ST._fcWalk=nil ST._fcJump=nil ST._fcAS=nil ST.freeCamAnchor=nil ST.freeCamPos=nil
        if was then ntf("FreeCam","OFF") end
    end
end
local fcPrevM=nil
local function applyFreeCam(cam)
    if not ST.freeCam then return end
    if not cam then return end
    cam.CameraType=Enum.CameraType.Scriptable
    local ch=LP.Character
    local hum=ch and ch:FindFirstChildOfClass("Humanoid")
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    if hum then
        if hum.WalkSpeed~=0 then hum.WalkSpeed=0 end
        if hum.AutoRotate then hum.AutoRotate=false end
        if hum.PlatformStand then hum.PlatformStand=false end
    end
    if hrp then
        if not hrp.Anchored then hrp.Anchored=true end
        if hrp.Velocity.Magnitude>0.01 then hrp.Velocity=Vector3.new(0,0,0) end
        if hrp.RotVelocity.Magnitude>0.01 then hrp.RotVelocity=Vector3.new(0,0,0) end
        if hrp.CFrame then hrp.CFrame=hrp.CFrame end
    end
    local pos=ST.freeCamPos
    if not pos then
        pos=cam.CFrame.Position
        ST.freeCamPos=pos
    end
    local rmb=U:IsKeyDown(Enum.UserInputType.MouseButton2)
    local dx,dy=0,0
    local mp=U:GetMouseLocation()
    if rmb then
        U.MouseBehavior=Enum.MouseBehavior.LockCenter
        local md=U:GetMouseDelta()
        if md then dx,dy=md.X,md.Y end
        if dx==0 and dy==0 and fcPrevM then
            dx=mp.X-fcPrevM.X dy=mp.Y-fcPrevM.Y
        end
    elseif U.MouseBehavior~=Enum.MouseBehavior.Default then
        U.MouseBehavior=Enum.MouseBehavior.Default
    end
    fcPrevM=mp
    if dx~=0 or dy~=0 then
        ST.freeCamYaw=(ST.freeCamYaw or 0)-dx*0.0035
        ST.freeCamPitch=math.clamp((ST.freeCamPitch or 0)-dy*0.0035,-1.45,1.45)
    end
    local yaw=ST.freeCamYaw or 0
    local pitch=ST.freeCamPitch or 0
    local rot=CFrame.Angles(0,yaw,0)*CFrame.Angles(pitch,0,0)
    local dir=Vector3.new(0,0,0)
    local sp=1.2
    if U:IsKeyDown(Enum.KeyCode.LeftShift) then sp=4 end
    if U:IsKeyDown(Enum.KeyCode.W) then dir=dir+rot.LookVector end
    if U:IsKeyDown(Enum.KeyCode.S) then dir=dir-rot.LookVector end
    if U:IsKeyDown(Enum.KeyCode.A) then dir=dir-rot.RightVector end
    if U:IsKeyDown(Enum.KeyCode.D) then dir=dir+rot.RightVector end
    if U:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
    if U:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end
    if dir.Magnitude>0 then
        pos=pos+dir.Unit*sp
        ST.freeCamPos=pos
    end
    local cf=CFrame.new(pos)*rot
    cam.CFrame=cf
    cam.Focus=cf
    if cam.CameraType~=Enum.CameraType.Scriptable then cam.CameraType=Enum.CameraType.Scriptable end
end
local ovhPrevM=nil
local function applyOverhead(cam)
    if not ST.spectateOverhead or not ST.spectating or not ST.spectating.Character then return end
    local hrpT=ST.spectating.Character:FindFirstChild("HumanoidRootPart")
    if not hrpT then return end
    if not cam then return end
    cam.CameraType=Enum.CameraType.Scriptable
    if not ST.ovhInit then
        ST.ovhYaw=0
        ST.ovhPitch=1.1
        ST.ovhDist=22
        ST.ovhInit=true
    end
    local rmb=U:IsKeyDown(Enum.UserInputType.MouseButton2)
    local dx,dy=0,0
    local mp=U:GetMouseLocation()
    if rmb then
        U.MouseBehavior=Enum.MouseBehavior.LockCenter
        local md=U:GetMouseDelta()
        if md then dx,dy=md.X,md.Y end
        if dx==0 and dy==0 and ovhPrevM then
            dx=mp.X-ovhPrevM.X dy=mp.Y-ovhPrevM.Y
        end
    elseif U.MouseBehavior~=Enum.MouseBehavior.Default then
        U.MouseBehavior=Enum.MouseBehavior.Default
    end
    ovhPrevM=mp
    if dx~=0 or dy~=0 then
        ST.ovhYaw=(ST.ovhYaw or 0)-dx*0.004
        ST.ovhPitch=math.clamp((ST.ovhPitch or 1.1)+dy*0.004,0.15,1.5)
    end
    if U:IsKeyDown(Enum.KeyCode.A) then ST.ovhYaw=(ST.ovhYaw or 0)+0.04 end
    if U:IsKeyDown(Enum.KeyCode.D) then ST.ovhYaw=(ST.ovhYaw or 0)-0.04 end
    if U:IsKeyDown(Enum.KeyCode.W) then ST.ovhPitch=math.clamp((ST.ovhPitch or 1.1)+0.03,0.15,1.5) end
    if U:IsKeyDown(Enum.KeyCode.S) then ST.ovhPitch=math.clamp((ST.ovhPitch or 1.1)-0.03,0.15,1.5) end
    if U:IsKeyDown(Enum.KeyCode.Space) then ST.ovhDist=math.max(8,(ST.ovhDist or 22)+0.5) end
    if U:IsKeyDown(Enum.KeyCode.LeftControl) then ST.ovhDist=math.min(80,(ST.ovhDist or 22)-0.5) end
    local yaw=ST.ovhYaw or 0
    local pitch=ST.ovhPitch or 1.1
    local dist=ST.ovhDist or 22
    local cx=hrpT.Position.X+dist*math.cos(pitch)*math.sin(yaw)
    local cy=hrpT.Position.Y+dist*math.sin(pitch)
    local cz=hrpT.Position.Z+dist*math.cos(pitch)*math.cos(yaw)
    local target=hrpT.Position+Vector3.new(0,2,0)
    local cf=CFrame.lookAt(Vector3.new(cx,cy,cz),target)
    cam.CFrame=cf
    cam.Focus=CFrame.new(target)
end
local function isAimActive()
    if ST.aimHoldKey then return ST.aimKeyHeld end
    return ST.aimEnabled or ST.aimKeyHeld
end
local function applyAim(cam)
    if ST.freeCam or ST.spectateOverhead then return end
    if not isAimActive() then return end
    if not (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character:FindFirstChildOfClass("Humanoid")) then return end
    cam.CameraType=Enum.CameraType.Scriptable
    local camPos=cam.CFrame.Position
    local mpA=U:GetMouseLocation()
    local vp=cam.ViewportSize
    local screenCenter=Vector2.new(vp.X*0.5,vp.Y*0.5)
    local center=mpA
    local bestTarget=nil local bestDist=math.max(ST.aimFOV, 400)
    local cur=ST.aimTarget
    local curOk=false
    if cur and cur.Character and cur.Character:FindFirstChild(ST.aimTargetPart) and cur.Character:FindFirstChildOfClass("Humanoid") then
        local h=cur.Character:FindFirstChildOfClass("Humanoid")
        if h.Health>0 and not (ST.aimTeamCheck and cur.Team==LP.Team) then
            local tgtPos=cur.Character[ST.aimTargetPart].Position
            local wallOK=true
            if ST.aimWallCheck then
                local cacheKey=cur.UserId
                local now=tick()
                local c=ST._aimWallC and ST._aimWallC[cacheKey]
                if c and now-c.t<0.15 then
                    wallOK=c.ok
                else
                    local params=RaycastParams.new()
                    params.FilterType=Enum.RaycastFilterType.Exclude
                    local filt={LP.Character}
                    for _,v in pairs(cur.Character:GetDescendants()) do table.insert(filt,v) end
                    params.FilterDescendantsInstances=filt
                    wallOK=(W:Raycast(camPos,tgtPos-camPos,params)==nil)
                    ST._aimWallC=ST._aimWallC or {}
                    ST._aimWallC[cacheKey]={t=now,ok=wallOK}
                end
            end
            if wallOK then
                local sp2,onscreen=cam:WorldToViewportPoint(tgtPos)
                if onscreen then
                    local p2=Vector2.new(sp2.X,sp2.Y)
                    local dMouse=(p2-center).Magnitude
                    local dCenter=(p2-screenCenter).Magnitude
                    curOk=true bestTarget=cur bestDist=math.min(dMouse,dCenter)
                end
            end
        end
    end
    if not curOk then
        for _,pp in pairs(P:GetPlayers()) do
            if pp~=LP and pp~=cur and pp.Character and pp.Character:FindFirstChild(ST.aimTargetPart) and pp.Character:FindFirstChildOfClass("Humanoid") then
                if pp.Character:FindFirstChildOfClass("Humanoid").Health>0 then
                    if ST.aimTeamCheck and pp.Team==LP.Team then continue end
                    local tgtPos=pp.Character[ST.aimTargetPart].Position
                    if ST.aimWallCheck then
                        local params=RaycastParams.new()
                        params.FilterType=Enum.RaycastFilterType.Exclude
                        local filt={LP.Character}
                        for _,v in pairs(pp.Character:GetDescendants()) do table.insert(filt,v) end
                        params.FilterDescendantsInstances=filt
                        if W:Raycast(camPos,tgtPos-camPos,params) then continue end
                    end
                    local sp2,onscreen=cam:WorldToViewportPoint(tgtPos)
                    if onscreen then
                        local p2=Vector2.new(sp2.X,sp2.Y)
                        local d=math.min((p2-center).Magnitude,(p2-screenCenter).Magnitude)
                        if d<bestDist then bestDist=d bestTarget=pp end
                    end
                end
            end
        end
    end
    if bestTarget and bestTarget.Character and bestTarget.Character:FindFirstChild(ST.aimTargetPart) then
        ST.aimTarget=bestTarget
        local tgtPos=bestTarget.Character[ST.aimTargetPart].Position
        local lookDir=CFrame.lookAt(camPos,tgtPos)
        cam.CFrame=cam.CFrame:Lerp(lookDir,0.85)
        cam.Focus=CFrame.new(tgtPos)
        local myHRP=LP.Character:FindFirstChild("HumanoidRootPart")
        local myHum=LP.Character:FindFirstChildOfClass("Humanoid")
        if myHRP and myHum then
            if myHum.AutoRotate then myHum.AutoRotate=false end
            local flat=Vector3.new(tgtPos.X-myHRP.Position.X,0,tgtPos.Z-myHRP.Position.Z)
            if flat.Magnitude>0.5 then
                local faceCF=CFrame.lookAt(myHRP.Position,myHRP.Position+flat)
                myHRP.CFrame=myHRP.CFrame:Lerp(faceCF,0.35)
            end
        end
    else
        ST.aimTarget=nil
        local myHum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if myHum and not myHum.AutoRotate then myHum.AutoRotate=true end
    end
end
pcall(function()
    R:BindToRenderStep("AxCamCtrl",Enum.RenderPriority.Last.Value+10,function()
        pcall(function()
            local cam=W.CurrentCamera
            if not cam then return end
            CAM=cam
            if ST.freeCam then
                applyFreeCam(cam)
            elseif ST.spectateOverhead then
                applyOverhead(cam)
            end
            applyAim(cam)
        end)
    end)
end)
local function findRemote(name)
    local cur=RS
    local okPath=true
    for part in string.gmatch(name,"[^%.]+") do
        if cur then cur=cur:FindFirstChild(part) end
        if not cur then okPath=false break end
    end
    if okPath and cur then return cur end
    local last=name:match("[^%.]+$")
    if last then local found=RS:FindFirstChild(last,true) if found then return found end end
    return nil
end
local function forceFire(r, ...)
    if not r then return end
    ST._forceFire=true
    local ok=pcall(function() r:FireServer(...) end)
    ST._forceFire=false
    return ok
end
local function forceInvoke(r, ...)
    if not r then return end
    ST._forceFire=true
    pcall(function() r:InvokeServer(...) end)
    ST._forceFire=false
end
local function getFXRemotes()
    if ST._fxRemotes then return ST._fxRemotes end
    local list={}
    local keys={"explo","grenade","rocket","missile","bullet","tracer","muzzle","impact","effect","damage","hurt","shoot","projectile","artillery","c4","bomb"}
    pcall(function()
        for _,d in pairs(RS:GetDescendants()) do
            if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
                local nm=string.lower(d.Name)
                for _,k in ipairs(keys) do
                    if string.find(nm,k,1,true) then
                        table.insert(list,d)
                        break
                    end
                end
            end
        end
    end)
    ST._fxRemotes=list
    return list
end
local function ensureWeaponEquipped()
    local ok=false
    pcall(function()
        if not LP.Character then return end
        local hum=LP.Character:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local bp=LP:FindFirstChild("Backpack")
        local already=LP.Character:FindFirstChildOfClass("Tool")
        if already then pcall(function() LP.Character:EquipTool(already) end) ok=true return end
        if bp then
            for _,tool in pairs(bp:GetChildren()) do
                if tool:IsA("Tool") then
                    pcall(function() LP.Character:EquipTool(tool) end) ok=true return
                end
            end
        end
        local sources={
            game:GetService("StarterPack"),
            game:GetService("StarterGear"),
            W,
            RS
        }
        local found=nil
        for _,src in ipairs(sources) do
            pcall(function()
                if found then return end
                for _,obj in pairs(src:GetDescendants()) do
                    if found then break end
                    if obj:IsA("Tool") then
                        local low=string.lower(obj.Name)
                        if string.find(low,"gun",1,true) or string.find(low,"weapon",1,true) or string.find(low,"pistol",1,true) or string.find(low,"rifle",1,true) or string.find(low,"smg",1,true) or string.find(low,"ak",1,true) or string.find(low,"m4",1,true) or string.find(low,"sword",1,true) then
                            found=obj
                        end
                    end
                end
                if not found then
                    for _,obj in pairs(src:GetDescendants()) do
                        if obj:IsA("Tool") then found=obj break end
                    end
                end
            end)
            if found then break end
        end
        if not found then
            pcall(function()
                for _,pl in pairs(P:GetPlayers()) do
                    if pl~=LP and pl.Character then
                        for _,obj in pairs(pl.Character:GetChildren()) do
                            if obj:IsA("Tool") then found=obj break end
                        end
                    end
                    if found then break end
                    if pl~=LP then
                        local pb=pl:FindFirstChild("Backpack")
                        if pb then
                            for _,obj in pairs(pb:GetChildren()) do
                                if obj:IsA("Tool") then found=obj break end
                            end
                        end
                    end
                    if found then break end
                end
            end)
        end
        if found then
            pcall(function()
                local clone=found:Clone()
                if bp then clone.Parent=bp end
                pcall(function() LP.Character:EquipTool(clone) end)
                ok=true
            end)
            if not ok then
                pcall(function()
                    found.Parent=LP.Character
                    pcall(function() LP.Character:EquipTool(found) end)
                    ok=true
                end)
            end
        end
        if not ok then
            pcall(function()
                local t=Instance.new("Tool")
                t.Name="AxFakeGun"
                local handle=Instance.new("Part")
                handle.Name="Handle"
                handle.Size=Vector3.new(0.4,1,0.4)
                handle.CanCollide=false
                handle.Parent=t
                if bp then t.Parent=bp end
                pcall(function() LP.Character:EquipTool(t) end)
                ok=true
            end)
        end
    end)
    return ok
end
local function mpKillPlayer(victim, hitPos)
    if not victim or victim==LP or not victim.Character then return end
    ensureWeaponEquipped()
    pcall(function()
        local part=victim.Character:FindFirstChild("Head") or victim.Character:FindFirstChild("HumanoidRootPart")
        local hrp=victim.Character:FindFirstChild("HumanoidRootPart")
        local my=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local origin=my and my.Position or hitPos
        local dir=(hitPos-origin)
        if dir.Magnitude<1 then dir=Vector3.new(0,0,-1) end
        local rf=findRemote("WeaponsSystem.Network.WeaponFired")
        if rf then
            for i=1,8 do forceFire(rf, origin, hitPos) end
            forceFire(rf, origin, dir.Unit)
            forceFire(rf, hitPos)
            forceFire(rf, origin, hitPos, part)
        end
        local hitRemotes={}
        local seen={}
        local function addRem(r)
            if not r then return end
            for _,e in ipairs(hitRemotes) do if e==r then return end end
            table.insert(hitRemotes,r)
        end
        local names={
            "WeaponsSystem.Network.WeaponHit",
            "WeaponsSystem.Network.Hit",
            "WeaponsSystem.Network.WeaponHitConfirm",
            "WeaponsSystem.Network.Damage",
            "WeaponsSystem.Network.Hurt",
            "WeaponsSystem.Network.Kill",
            "WeaponsSystem.Network.Eliminate",
            "KillRemote",
            "KillEvent",
            "PlayerKill",
            "DamagePlayer",
            "TakeDamage"
        }
        for _,nm in ipairs(names) do
            addRem(findRemote(nm))
        end
        local keys={"weaponhit","weapondamage","network.hit","kill","eliminate","takedamage","damageplayer","playerdamage","hurt"}
        pcall(function()
            for _,parent in ipairs({RS,W,game:GetService("ReplicatedFirst")}) do
                for _,d in pairs(parent:GetDescendants()) do
                    if (d:IsA("RemoteEvent") or d:IsA("RemoteFunction")) and not seen[d] then
                        local low=string.lower(d.Name)
                        for _,k in ipairs(keys) do
                            if string.find(low,k,1,true) then
                                seen[d]=true
                                addRem(d)
                                break
                            end
                        end
                    end
                end
            end
        end)
        local dmg=999999
        for _,r in ipairs(hitRemotes) do
            local argSets={
                {hitPos},
                {hitPos,part},
                {hitPos,part,dmg},
                {hitPos,dmg},
                {victim,hitPos},
                {victim,hitPos,dmg},
                {victim,part,hitPos,dmg},
                {victim.Name,hitPos},
                {victim.Name,hitPos,part},
                {victim.Name,hitPos,part,dmg},
                {victim.Name,dmg},
                {victim.UserId,hitPos},
                {victim.UserId,hitPos,dmg},
                {victim.UserId,dmg},
                {origin,hitPos},
                {origin,dir.Unit,hitPos},
                {origin,dir.Unit,part,hitPos,dmg},
                {part,hitPos,dmg},
                {part,dmg},
                {victim,dmg},
                {victim},
                {victim.Name}
            }
            for _,args in ipairs(argSets) do
                if r:IsA("RemoteFunction") then
                    forceInvoke(r, unpack(args))
                else
                    forceFire(r, unpack(args))
                end
            end
        end
        if hrp then
            fireGameVolley(origin, hrp.Position)
        end
    end)
end
local function killNearestOrSelected()
    local target=ST.selectedPlayer
    if not (target and target~=LP and target.Character and target.Character:FindFirstChild("HumanoidRootPart")) then
        target=nil
        local best=nil
        local bestD=80
        for _,pp in pairs(P:GetPlayers()) do
            if pp~=LP and pp.Character and pp.Character:FindFirstChild("HumanoidRootPart") then
                local my=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                local d=my and (pp.Character.HumanoidRootPart.Position-my.Position).Magnitude or 999
                if d<bestD then bestD=d best=pp end
            end
        end
        target=best
    end
    if not target then ntf("Kill","No target within 80 studs (select a player)") return end
    local hrp=target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hadWeapon=ensureWeaponEquipped()
    local pos=hrp.Position
    for i=1,3 do mpKillPlayer(target,pos) end
    pcall(function()
        if not AR then AR=RS:FindFirstChild("AdminRemote") or RS:FindFirstChild("HDAdminRemote") end
        if AR then AR:FireServer("kill", target.Name) end
    end)
    pcall(function()
        local h=target.Character:FindFirstChildOfClass("Humanoid")
        if h and h.Health>0 then h.Health=math.max(0,h.Health-100000) end
    end)
    ntf("Kill","Sent MP kill to "..target.DisplayName.." ("..(hadWeapon and "weapon equipped" or "no weapon - remotes only")..")")
end
local function fireGameVolley(origin, target)
    pcall(function()
        local rf=findRemote("WeaponsSystem.Network.WeaponFired")
        if rf then
            for i=1,8 do
                local j=Vector3.new(math.random(-40,40)/10,math.random(-40,40)/10,math.random(-40,40)/10)
                forceFire(rf, origin, target+j)
            end
        end
        for _,r in pairs(getFXRemotes()) do
            if r:IsA("RemoteEvent") then
                forceFire(r, target)
                forceFire(r, origin, target)
                forceFire(r, target.X, target.Y, target.Z)
            elseif r:IsA("RemoteFunction") then
                forceInvoke(r, target)
                forceInvoke(r, origin, target)
            end
        end
    end)
end
local function btn(p,t,fn,id)
    local b=Instance.new("TextButton") b.Size=UDim2.new(1,-12,0,30) b.Position=UDim2.new(0,6,0,0) b.BackgroundColor3=TH.b b.BorderSizePixel=0 b.Text="  "..t b.TextColor3=TH.t b.TextSize=12 b.Font=Enum.Font.GothamMedium b.TextXAlignment=Enum.TextXAlignment.Left b.Parent=p
    mkCorner(b,6) mkStroke(b,Color3.fromRGB(60,60,90),1)
    local kbBtn=Instance.new("TextButton") kbBtn.Size=UDim2.new(0,40,0,22) kbBtn.Position=UDim2.new(1,-48,0,6) kbBtn.BackgroundColor3=TH.p kbBtn.BorderSizePixel=0 kbBtn.Text=getKeyDisplay(KB[id]) kbBtn.TextColor3=(KBMode[id]=="hold") and Color3.fromRGB(255,200,80) or TH.a kbBtn.TextSize=9 kbBtn.Font=Enum.Font.GothamBold kbBtn.Parent=b mkCorner(kbBtn,4) mkStroke(kbBtn,TH.a,1)
    if id then kbBtns[id]=kbBtn end
    kbBtn.MouseButton1Click:Connect(function() waitingForKey=id kbBtn.Text="..." kbBtn.TextColor3=TH.r ntf("Keybind","Press key for: "..t.." (Backspace=clear, RMB on box=hold/toggle)",6) end)
    kbBtn.MouseButton2Click:Connect(function() if id then cycleKBMode(id) end end)
    b.MouseEnter:Connect(function() twFast(b,{BackgroundColor3=TH.bh,TextColor3=Color3.new(1,1,1)}) end)
    b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=TH.b,TextColor3=TH.t},0.2) end)
    b.MouseButton1Click:Connect(function() twFast(b,{BackgroundColor3=TH.a},0.08) wait(0.08) tw(b,{BackgroundColor3=TH.bh},0.15) pcall(fn) end)
    return b
end
local function tog(p,t,gf,fn,id)
    local b=Instance.new("TextButton") b.Size=UDim2.new(1,-12,0,34) b.Position=UDim2.new(0,6,0,0) b.BackgroundColor3=TH.b b.BorderSizePixel=0
    local st=gf() b.Text="  "..t..": "..(st and "ON" or "OFF") b.TextColor3=st and TH.g or TH.t b.TextSize=13 b.Font=Enum.Font.GothamMedium b.TextXAlignment=Enum.TextXAlignment.Left b.Parent=p
    mkCorner(b,6) mkStroke(b,st and TH.g or Color3.fromRGB(60,60,90),1)
    local kbBtn=Instance.new("TextButton") kbBtn.Size=UDim2.new(0,40,0,22) kbBtn.Position=UDim2.new(1,-48,0,6) kbBtn.BackgroundColor3=TH.p kbBtn.BorderSizePixel=0 kbBtn.Text=getKeyDisplay(KB[id]) kbBtn.TextColor3=(KBMode[id]=="hold") and Color3.fromRGB(255,200,80) or TH.a kbBtn.TextSize=9 kbBtn.Font=Enum.Font.GothamBold kbBtn.Parent=b mkCorner(kbBtn,4) mkStroke(kbBtn,TH.a,1)
    if id then kbBtns[id]=kbBtn end
    kbBtn.MouseButton1Click:Connect(function() waitingForKey=id kbBtn.Text="..." kbBtn.TextColor3=TH.r ntf("Keybind","Press key for: "..t.." (Backspace=clear, RMB on box=hold/toggle)",6) end)
    kbBtn.MouseButton2Click:Connect(function() if id then cycleKBMode(id) end end)
    b.MouseEnter:Connect(function() twFast(b,{BackgroundColor3=TH.bh}) end)
    b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=TH.b},0.2) end)
    b.MouseButton1Click:Connect(function() twFast(b,{BackgroundColor3=TH.a},0.08) wait(0.08) fn() local s=gf() tw(b,{BackgroundColor3=s and Color3.fromRGB(30,60,30) or TH.b},0.15) b.Text="  "..t..": "..(s and "ON" or "OFF") b.TextColor3=s and TH.g or TH.t pcall(function() b.UIStroke.Color=s and TH.g or Color3.fromRGB(60,60,90) end) end)
    local updateFn=function() local s=gf() b.Text="  "..t..": "..(s and "ON" or "OFF") b.TextColor3=s and TH.g or TH.t pcall(function() b.UIStroke.Color=s and TH.g or Color3.fromRGB(60,60,90) end) kbBtn.Text=getKeyDisplay(KB[id]) kbBtn.TextColor3=(KBMode[id]=="hold") and Color3.fromRGB(255,200,80) or TH.a end
    togUpdates[b]=updateFn
    return b
end
local function makeSlider(parent,title,minV,maxV,getFn,setFn)
    local wrap=Instance.new("Frame") wrap.Size=UDim2.new(1,-12,0,46) wrap.BackgroundColor3=TH.p wrap.BorderSizePixel=0 wrap.Parent=parent mkCorner(wrap,6)
    local lab=Instance.new("TextLabel") lab.Size=UDim2.new(1,-16,0,18) lab.Position=UDim2.new(0,8,0,2) lab.BackgroundTransparency=1 lab.Text=title..": "..tostring(math.floor(getFn())) lab.TextColor3=TH.t lab.TextSize=11 lab.Font=Enum.Font.GothamBold lab.TextXAlignment=Enum.TextXAlignment.Left lab.Parent=wrap
    local bar=Instance.new("TextButton") bar.Size=UDim2.new(1,-16,0,14) bar.Position=UDim2.new(0,8,0,26) bar.BackgroundColor3=TH.s bar.BorderSizePixel=0 bar.Text="" bar.AutoButtonColor=false bar.Parent=wrap mkCorner(bar,7)
    local fill=Instance.new("Frame") fill.Size=UDim2.new(0,0,1,0) fill.BackgroundColor3=TH.a fill.BorderSizePixel=0 fill.Parent=bar mkCorner(fill,7)
    local function refresh() local v=getFn() local f=math.clamp((v-minV)/math.max(1,(maxV-minV)),0,1) fill.Size=UDim2.new(f,0,1,0) lab.Text=title..": "..tostring(math.floor(v)) end
    refresh()
    local drag=false
    local function upd() local mx=U:GetMouseLocation().X-bar.AbsolutePosition.X local f=math.clamp(mx/math.max(1,bar.AbsoluteSize.X),0,1) setFn(minV+f*(maxV-minV)) refresh() end
    bar.MouseButton1Down:Connect(function() drag=true upd() end)
    U.InputEnded:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
    U.InputChanged:Connect(function(inp) if drag and inp.UserInputType==Enum.UserInputType.MouseMovement then upd() end end)
    return wrap,refresh
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
local OVF=Instance.new("Frame") OVF.Name="AxOverlay" OVF.Size=UDim2.fromScale(1,1) OVF.BackgroundTransparency=1 OVF.BorderSizePixel=0 OVF.ZIndex=100 OVF.Active=false OVF.ClipsDescendants=false OVF.Parent=SG
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
btn(tH,"Speed 40",function() ST.speedPreset=40 pcall(function() local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h and not ST.freeCam and not h.Seated and h.Health>0 then h.WalkSpeed=40 end end) ntf("Speed","40 - applied") end,"sp100")
btn(tH,"Speed 55",function() ST.speedPreset=55 pcall(function() local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h and not ST.freeCam and not h.Seated and h.Health>0 then h.WalkSpeed=55 end end) ntf("Speed","55 - applied") end,"sp250")
btn(tH,"Speed 70",function() ST.speedPreset=70 pcall(function() local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h and not ST.freeCam and not h.Seated and h.Health>0 then h.WalkSpeed=70 end end) ntf("Speed","70 - applied") end,"sp500")
btn(tH,"Reset Speed",function() ST.speedPreset=0 pcall(function() local ch=LP.Character if ch then local h=ch:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=16 end end end) ntf("Speed","Reset 16") end,"sprst")
sep(tH)
lbl(tH,">> JUMP")
btn(tH,"Jump 75",function() ST.jumpPreset=75 pcall(function() local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h and not ST.freeCam and not h.Seated and h.Health>0 then if h.UseJumpPower then h.JumpPower=75 else h.JumpHeight=math.max(5,math.floor(75*0.14+0.5)) end end end) ntf("Jump","75 - applied") end,"jp100")
btn(tH,"Jump 100",function() ST.jumpPreset=100 pcall(function() local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h and not ST.freeCam and not h.Seated and h.Health>0 then if h.UseJumpPower then h.JumpPower=100 else h.JumpHeight=math.max(5,math.floor(100*0.14+0.5)) end end end) ntf("Jump","100 - applied") end,"jp300")
btn(tH,"Jump 150",function() ST.jumpPreset=150 pcall(function() local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h and not ST.freeCam and not h.Seated and h.Health>0 then if h.UseJumpPower then h.JumpPower=150 else h.JumpHeight=math.max(5,math.floor(150*0.14+0.5)) end end end) ntf("Jump","150 - applied") end,"jp500")
btn(tH,"Reset Jump",function() ST.jumpPreset=0 pcall(function() local ch=LP.Character if ch then local h=ch:FindFirstChildOfClass("Humanoid") if h then if h.UseJumpPower then h.JumpPower=50 else h.JumpHeight=7 end end end end) ntf("Jump","Reset") end,"jprst")
local tInfJ=tog(tH,"Infinite Jump",function() return ST.infJump end,function() ST.infJump=not ST.infJump if ST.infJump then ST.godmodeLoop=true syncServerGod() ntf("InfJump","ON - Space + Godmode forced") else ntf("InfJump","OFF") end end,"infjump")
table.insert(allToggles,tInfJ)
local tSPH=tog(tH,"Speed Hard",function() return ST.speedHard end,function() ST.speedHard=not ST.speedHard if ST.speedHard then ST.speedPreset=math.max(ST.speedPreset,50) ntf("SpeedHard","ON (50)") else ST.speedPreset=0 pcall(function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=16 end end end) ntf("SpeedHard","OFF") end end,"speedhard")
table.insert(allToggles,tSPH)
local tIS=tog(tH,"Infinite Stamina",function() return ST.infStamina end,function() ST.infStamina=not ST.infStamina ST._stamVals=nil ST._stamWarned=false ntf("Stamina",ST.infStamina and "ON - scanning char+player+gui+attrs" or "OFF") end,"infstam")
table.insert(allToggles,tIS)
sep(tH)
lbl(tH,">> FLY + NOCLIP")
local tFly=tog(tH,"Fly",function() return ST.fly end,function() ST.fly=not ST.fly if ST.fly then ST.godmodeLoop=true syncServerGod() end if not ST.fly and LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.PlatformStand=false end local hrp=LP.Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.Velocity=Vector3.new(0,0,0) hrp.RotVelocity=Vector3.new(0,0,0) end end ntf("Fly",ST.fly and "ON - WASD+Space/Ctrl + Godmode" or "OFF") end,"fly")
table.insert(allToggles,tFly)
local tNoclip=tog(tH,"Noclip",function() return ST.noclip end,function() ST.noclip=not ST.noclip if not ST.noclip and LP.Character then for _,p2 in pairs(LP.Character:GetDescendants()) do if p2:IsA("BasePart") and ST.savedCollide[p2]~=nil then p2.CanCollide=ST.savedCollide[p2] end end ST.savedCollide={} end end,"noclip")
table.insert(allToggles,tNoclip)
local tFC=tog(tH,"Free Cam",function() return ST.freeCam end,function() setFreeCam(not ST.freeCam) end,"freecam")
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
local tNight=tog(tW,"Night",function() return ST.night end,function() setNight(not ST.night) end,"night")
table.insert(allToggles,tNight)
local tBright=tog(tW,"Fullbright",function() return ST.bright end,function() ST.bright=not ST.bright if ST.bright then if not ST.savedLighting then ST.savedLighting={Brightness=L.Brightness,GlobalShadows=L.GlobalShadows,FogEnd=L.FogEnd,Ambient=L.Ambient,OutdoorAmbient=L.OutdoorAmbient,ClockTime=L.ClockTime} end else if ST.savedLighting then pcall(function() L.Brightness=ST.savedLighting.Brightness L.GlobalShadows=ST.savedLighting.GlobalShadows L.FogEnd=ST.savedLighting.FogEnd L.Ambient=ST.savedLighting.Ambient L.OutdoorAmbient=ST.savedLighting.OutdoorAmbient L.ClockTime=ST.savedLighting.ClockTime end) ST.savedLighting=nil end end end,"bright")
table.insert(allToggles,tBright)
local tFog=tog(tW,"No Fog",function() return ST.noFog end,function() setNoFog(not ST.noFog) end,"nofog")
table.insert(allToggles,tFog)
sep(tW)
lbl(tW,">> LIGHTING")
btn(tW,"Brightness +1",function() L.Brightness=L.Brightness+1 end,"brup")
btn(tW,"Brightness -1",function() L.Brightness=math.max(0,L.Brightness-1) end,"brdn")
btn(tW,"Reset Lighting",function() L.Brightness=1 L.GlobalShadows=true L.FogEnd=100000 L.ClockTime=14 end,"lgrst")
sep(tW)
lbl(tW,">> GRAVITY")
local gravPresets={{"Moon",13},{"Normal",196.2},{"Zero-G",0},{"Super",400}}
local gravFrame=Instance.new("Frame") gravFrame.Size=UDim2.new(1,-12,0,30) gravFrame.BackgroundColor3=TH.p gravFrame.BorderSizePixel=0 gravFrame.Parent=tW mkCorner(gravFrame,6)
for gi,gp in ipairs(gravPresets) do
    local gb=Instance.new("TextButton") gb.Size=UDim2.new(0,56,0,22) gb.Position=UDim2.new(0,(gi-1)*60+4,0,4) gb.BackgroundColor3=TH.b gb.BorderSizePixel=0 gb.Text=gp[1] gb.TextColor3=TH.t gb.TextSize=9 gb.Font=Enum.Font.GothamBold gb.Parent=gravFrame mkCorner(gb,4)
    gb.MouseButton1Click:Connect(function() pcall(function() W.Gravity=gp[2] ntf("Gravity",gp[1].." ("..gp[2]..")") end) end)
end
lbl(tW,">> VEHICLE SPEED")
local vehPresets={{"Restore",nil},{"Boost+",nil,"up"},{"Boost-",nil,"down"},{"Max",200},{"Turbo",500}}
local vehFrame=Instance.new("Frame") vehFrame.Size=UDim2.new(1,-12,0,30) vehFrame.BackgroundColor3=TH.p vehFrame.BorderSizePixel=0 vehFrame.Parent=tW mkCorner(vehFrame,6)
for vi,vp in ipairs(vehPresets) do
    local vb=Instance.new("TextButton") vb.Size=UDim2.new(0,72,0,22) vb.Position=UDim2.new(0,(vi-1)*78+4,0,4) vb.BackgroundColor3=TH.b vb.BorderSizePixel=0 vb.Text=vp[1] vb.TextColor3=TH.t vb.TextSize=10 vb.Font=Enum.Font.GothamBold vb.Parent=vehFrame mkCorner(vb,4)
    vb.MouseButton1Click:Connect(function() pcall(function()
        if vp[3]=="up" then ST.vehBoost=math.min((ST.vehBoost or 80)+20,500) ntf("Vehicle","Boost: "..ST.vehBoost) return end
        if vp[3]=="down" then ST.vehBoost=math.max((ST.vehBoost or 80)-20,30) ntf("Vehicle","Boost: "..ST.vehBoost) return end
        local ch=LP.Character if ch then local seat=ch:FindFirstChildOfClass("VehicleSeat") or ch:FindFirstChild("Seat") if seat then ST._vehOrig=ST._vehOrig or {} if ST._vehOrig[seat]==nil and seat.MaxSpeed>0 then ST._vehOrig[seat]=seat.MaxSpeed end if vp[2]==nil then seat.MaxSpeed=ST._vehOrig[seat] or 30 ntf("Vehicle","Restored: "..tostring(seat.MaxSpeed)) else seat.MaxSpeed=math.max(vp[2],ST._vehOrig[seat] or 0) ntf("Vehicle",vp[1]..": "..tostring(seat.MaxSpeed)) end end end
    end) end)
end
local tP=tF["plr"]
lbl(tP,">> SELECT PLAYER")
local pDropBtn=Instance.new("TextButton") pDropBtn.Size=UDim2.new(1,-12,0,34) pDropBtn.Position=UDim2.new(0,6,0,0) pDropBtn.BackgroundColor3=TH.b pDropBtn.BorderSizePixel=0 pDropBtn.Text="  Click to select..." pDropBtn.TextColor3=TH.t pDropBtn.TextSize=13 pDropBtn.Font=Enum.Font.GothamMedium pDropBtn.TextXAlignment=Enum.TextXAlignment.Left pDropBtn.Parent=tP mkCorner(pDropBtn,6) mkStroke(pDropBtn,TH.a,1)
local pDropOpen=false local pDropdown=nil
pDropBtn.MouseButton1Click:Connect(function()
    pDropOpen=not pDropOpen
    if pDropOpen then
        if pDropdown then pDropdown:Destroy() end
        pDropdown=Instance.new("ScrollingFrame")
        local bw=pDropBtn.AbsoluteSize.X
        if bw<40 then bw=300 end
        pDropdown.Size=UDim2.fromOffset(bw,140)
        pDropdown.BackgroundColor3=TH.s
        pDropdown.BorderSizePixel=0
        pDropdown.ScrollBarThickness=3
        pDropdown.ScrollBarImageColor3=TH.a
        pDropdown.ZIndex=110
        pDropdown.Active=true
        pDropdown.Parent=OVF
        pDropdown.CanvasSize=UDim2.new(0,0,0,0)
        pDropdown.AutomaticCanvasSize=Enum.AutomaticSize.Y
        pDropdown.ScrollingDirection=Enum.ScrollingDirection.Y
        mkCorner(pDropdown,6)
        mkStroke(pDropdown,TH.a,1)
        mkPadding(pDropdown,2,2,4,4)
        local bp=pDropBtn.AbsolutePosition
        local op=OVF.AbsolutePosition
        pDropdown.Position=UDim2.fromOffset(bp.X-op.X,bp.Y-op.Y+pDropBtn.AbsoluteSize.Y)
        local y=4
        local pl=P:GetPlayers()
        for _,pp in pairs(pl) do
            if pp~=LP then
                local o=Instance.new("TextButton")
                o.Size=UDim2.new(1,-8,0,26)
                o.Position=UDim2.new(0,4,0,y)
                o.BackgroundColor3=TH.b
                o.BorderSizePixel=0
                o.Text="  "..pp.DisplayName
                o.TextColor3=TH.t
                o.TextXAlignment=Enum.TextXAlignment.Left
                o.TextSize=12
                o.Font=Enum.Font.Gotham
                o.ZIndex=111
                o.Parent=pDropdown
                mkCorner(o,4)
                y=y+28
                o.MouseEnter:Connect(function() o.BackgroundColor3=TH.bh end)
                o.MouseLeave:Connect(function() o.BackgroundColor3=TH.b end)
                o.MouseButton1Click:Connect(function() ST.selectedPlayer=pp pDropBtn.Text="  > "..pp.DisplayName pDropOpen=false if pDropdown then pDropdown:Destroy() pDropdown=nil end end)
            end
        end
        if y<=4 then
            local e=Instance.new("TextLabel")
            e.Size=UDim2.new(1,-8,0,26)
            e.Position=UDim2.new(0,4,0,4)
            e.BackgroundTransparency=1
            e.Text="  No other players"
            e.TextColor3=TH.t
            e.TextXAlignment=Enum.TextXAlignment.Left
            e.TextSize=12
            e.Font=Enum.Font.Gotham
            e.ZIndex=111
            e.Parent=pDropdown
        end
        pDropdown.CanvasSize=UDim2.new(0,0,0,y+4)
    else if pDropdown then pDropdown:Destroy() pDropdown=nil end end
end)
btn(tP,"Refresh Players",function() pDropBtn.Text="  Click to select..." ST.selectedPlayer=nil end,"plrrefresh")
sep(tP)
lbl(tP,">> PLAYER ACTIONS")
btn(tP,"Goto Player",function() if ST.selectedPlayer and ST.selectedPlayer.Character and LP.Character then local t2=ST.selectedPlayer.Character:FindFirstChild("HumanoidRootPart") local m=LP.Character:FindFirstChild("HumanoidRootPart") if t2 and m then m.CFrame=t2.CFrame+Vector3.new(3,0,0) end end end,"goto")
sep(tP)
lbl(tP,">> SPECTATE + ESP")
btn(tP,"Spectate",function() if ST.selectedPlayer and ST.selectedPlayer.Character then local h=ST.selectedPlayer.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h CAM.CameraType=Enum.CameraType.Custom ST.spectating=ST.selectedPlayer end end end,"spec")
btn(tP,"Stop Spectate",function() ST.spectateOverhead=false if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h end CAM.CameraType=Enum.CameraType.Custom ST.spectating=nil end ntf("Spectate","Stopped") end,"stopspec")
btn(tP,"Spectate: Next Player",function() local plrs=P:GetPlayers() local idx=1 for i,pp in pairs(plrs) do if pp==ST.spectating then idx=i break end end local nextI=idx+1 if nextI>#plrs then nextI=1 end local np=plrs[nextI] if np~=LP and np.Character then local h=np.Character:FindFirstChildOfClass("Humanoid") if h then if not ST.spectateOverhead then CAM.CameraSubject=h CAM.CameraType=Enum.CameraType.Custom end ST.spectating=np ST.ovhInit=false ntf("Spectate","Following: "..np.DisplayName) end end end,"specnext")
btn(tP,"Spectate: Prev Player",function() local plrs=P:GetPlayers() local idx=1 for i,pp in pairs(plrs) do if pp==ST.spectating then idx=i break end end local prevI=idx-1 if prevI<1 then prevI=#plrs end local pp2=plrs[prevI] if pp2~=LP and pp2.Character then local h=pp2.Character:FindFirstChildOfClass("Humanoid") if h then if not ST.spectateOverhead then CAM.CameraSubject=h CAM.CameraType=Enum.CameraType.Custom end ST.spectating=pp2 ST.ovhInit=false ntf("Spectate","Following: "..pp2.DisplayName) end end end,"specprev")
btn(tP,"Spectate: Overhead",function()
    if not ST.spectating then
        if ST.selectedPlayer and ST.selectedPlayer.Character then ST.spectating=ST.selectedPlayer end
        if not ST.spectating then
            for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character then ST.spectating=pp break end end
        end
    end
    if not ST.spectating or not ST.spectating.Character or not ST.spectating.Character:FindFirstChild("HumanoidRootPart") then
        ntf("Spectate","No target - select a player first",4) return
    end
    ST.spectateOverhead=not ST.spectateOverhead
    if ST.spectateOverhead then
        setFreeCam(false)
        ST.ovhYaw=0
        ST.ovhPitch=1.1
        ST.ovhDist=22
        ST.ovhInit=true
        pcall(function()
            local cam=W.CurrentCamera or CAM
            if cam then CAM=cam applyOverhead(cam) end
        end)
        ntf("Spectate","Overhead ON on "..ST.spectating.DisplayName.." - RMB look, WASD, Space/Ctrl dist")
    else
        CAM.CameraType=Enum.CameraType.Custom
        local h=ST.spectating.Character:FindFirstChildOfClass("Humanoid")
        if h then CAM.CameraSubject=h end
        U.MouseBehavior=Enum.MouseBehavior.Default
        ntf("Spectate","Overhead OFF")
    end
end,"specover")
local tESP=tog(tP,"ESP",function() return ST.esp end,function() ST.esp=not ST.esp if ST.esp then for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and not pp.Character:FindFirstChild("AxESP") then local hl=Instance.new("Highlight") hl.Name="AxESP" hl.FillColor=CFG.ESPColor hl.FillTransparency=CFG.ESPFillAlpha hl.OutlineColor=CFG.ESPOutlineColor hl.OutlineTransparency=CFG.ESPOutlineEnabled and 0 or 1 hl.Enabled=CFG.ESPFillEnabled hl.Parent=pp.Character ST.espList[pp.UserId]=hl end end else for id,hl in pairs(ST.espList) do if hl and hl.Parent then hl:Destroy() end ST.espList[id]=nil end end end,"esp")
table.insert(allToggles,tESP)
sep(tP)
lbl(tP,">> ESP SETTINGS")
btn(tP,"Open ESP Settings / Palette",function()
    if ST.palSG then pcall(function() ST.palSG:Destroy() end) ST.palSG=nil return end
    local SG4=Instance.new("ScreenGui") SG4.Name="AxPalette" SG4.ResetOnSpawn=false SG4.DisplayOrder=3 pcall(function() SG4.Parent=CG end) if not SG4.Parent then SG4.Parent=LP:WaitForChild("PlayerGui") end ST.palSG=SG4
    local PF=Instance.new("Frame") PF.Size=UDim2.new(0,320,0,400) PF.Position=UDim2.new(0.5,-160,0.5,-200) PF.BackgroundColor3=TH.p PF.BorderSizePixel=0 PF.Active=true PF.Draggable=true PF.Parent=SG4 mkCorner(PF,12) mkStroke(PF,TH.a,2)
    local PT=Instance.new("Frame") PT.Size=UDim2.new(1,0,0,34) PT.BackgroundColor3=TH.s PT.BorderSizePixel=0 PT.Parent=PF mkCorner(PT,12)
    local PTL=Instance.new("TextLabel") PTL.Size=UDim2.new(1,-50,1,0) PTL.Position=UDim2.new(0,12,0,0) PTL.BackgroundTransparency=1 PTL.Text="ESP SETTINGS" PTL.TextColor3=TH.a PTL.TextSize=13 PTL.Font=Enum.Font.GothamBlack PTL.TextXAlignment=Enum.TextXAlignment.Left PTL.Parent=PT
    local PX=Instance.new("TextButton") PX.Size=UDim2.new(0,28,0,28) PX.Position=UDim2.new(1,-32,0,3) PX.BackgroundTransparency=1 PX.Text="X" PX.TextColor3=TH.r PX.TextSize=18 PX.Font=Enum.Font.GothamBold PX.Parent=PT
    PX.MouseButton1Click:Connect(function() if ST.palSG then ST.palSG:Destroy() ST.palSG=nil end end)
    local grid=Instance.new("Frame") grid.Size=UDim2.new(1,-16,0,132) grid.Position=UDim2.new(0,8,0,40) grid.BackgroundTransparency=1 grid.Parent=PF
    local gl=Instance.new("UIGridLayout",grid) gl.CellSize=UDim2.new(0,30,0,30) gl.CellPadding=UDim2.new(0,4,0,4) gl.SortOrder=Enum.SortOrder.LayoutOrder
    local palHex={"FF0000","FF4040","FF8000","FF4000","FFA500","FFFF00","FFFF80","808000","00FF00","40FF40","00FF80","008000","00FFFF","00BFFF","0064FF","0000FF","8000FF","C832FF","FF00FF","FF80C0","FFFFFF","C0C0C0","808080","404040","000000","804000","FF0080","80FF00","008080","000080","800080","FFC0CB"}
    for _,hx in ipairs(palHex) do local cc=Color3.fromHex(hx) local cb=Instance.new("TextButton") cb.BackgroundColor3=cc cb.BorderSizePixel=0 cb.Text="" cb.Parent=grid mkCorner(cb,6)
        cb.MouseButton1Click:Connect(function() CFG.ESPColor=cc CFG.ESPTracerColor=cc ntf("ESP","Color: #"..hx) end) end
    local y0=180
    local espTogData={{n="Names",k="ESPShowName"},{n="Health",k="ESPShowHealth"},{n="Distance",k="ESPShowDistance"},{n="Fill",k="ESPFillEnabled"},{n="Outline",k="ESPOutlineEnabled"},{n="2D Box",k="ESP2D"}}
    for di,d in ipairs(espTogData) do
        local col=(di%2==1) and 0 or 0.5
        local row=math.floor((di-1)/2)
        local f=Instance.new("TextButton") f.Size=UDim2.new(0.48,-8,0,22) f.Position=UDim2.new(col,8,0,y0+row*26) f.BackgroundColor3=TH.s f.BorderSizePixel=0 f.Text="" f.Parent=PF mkCorner(f,4)
        local l=Instance.new("TextLabel") l.Size=UDim2.new(0.7,0,1,0) l.Position=UDim2.new(0,6,0,0) l.BackgroundTransparency=1 l.Text=d.n l.TextColor3=TH.t l.TextSize=11 l.Font=Enum.Font.Gotham l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=f
        local st=Instance.new("Frame") st.Size=UDim2.new(0,20,0,12) st.Position=UDim2.new(1,-26,0.5,-6) st.BackgroundColor3=CFG[d.k] and TH.g or TH.r st.BorderSizePixel=0 st.Parent=f mkCorner(st,6)
        local lbl2=Instance.new("TextLabel") lbl2.Size=UDim2.new(1,0,1,0) lbl2.BackgroundTransparency=1 lbl2.Text=CFG[d.k] and "ON" or "OFF" lbl2.TextColor3=TH.t lbl2.TextSize=7 lbl2.Font=Enum.Font.GothamBold lbl2.Parent=st
        f.MouseButton1Click:Connect(function()
            CFG[d.k]=not CFG[d.k]
            st.BackgroundColor3=CFG[d.k] and TH.g or TH.r
            lbl2.Text=CFG[d.k] and "ON" or "OFF"
            ntf("ESP",d.n..": "..(CFG[d.k] and "ON" or "OFF"))
        end)
    end
    local sl1=makeSlider(PF,"Fill Alpha",0,100,function() return CFG.ESPFillAlpha*100 end,function(v) CFG.ESPFillAlpha=v/100 end)
    sl1.Position=UDim2.new(0,6,0,268)
    local sl2=makeSlider(PF,"Max Dist",100,100000,function() return CFG.ESPMaxDist end,function(v) CFG.ESPMaxDist=math.floor(v) end)
    sl2.Position=UDim2.new(0,6,0,320)
end,"esppal")
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
ST.waypoints=ST.waypoints or {}
ST.wpParts=ST.wpParts or {}
local wpColors={[1]=Color3.fromRGB(255,50,50),[2]=Color3.fromRGB(50,255,50),[3]=Color3.fromRGB(50,150,255),[4]=Color3.fromRGB(255,200,0),[5]=Color3.fromRGB(200,50,255)}
local function createWPVisual(id,pos)
    pcall(function()
        if ST.wpParts[id] then ST.wpParts[id]:Destroy() end
        local c=wpColors[id] or Color3.fromRGB(255,50,50)
        local p=Instance.new("Part") p.Name="AxWP"..id p.Size=Vector3.new(3,0.2,3) p.Anchored=true p.CanCollide=false p.Material=Enum.Material.Neon p.Color=c p.Transparency=0.3 p.Position=pos-Vector3.new(0,2.5,0) p.Parent=W
        local bb=Instance.new("BillboardGui") bb.Size=UDim2.new(0,80,0,30) bb.StudsOffset=Vector3.new(0,3,0) bb.AlwaysOnTop=true bb.Parent=p
        local tl=Instance.new("TextLabel") tl.Size=UDim2.new(1,0,1,0) tl.BackgroundTransparency=1 tl.Text="WP"..id tl.TextColor3=c tl.TextSize=14 tl.Font=Enum.Font.GothamBold tl.Parent=bb
        ST.wpParts[id]=p
    end)
end
local function clearWPVisual(id)
    if ST.wpParts[id] then pcall(function() ST.wpParts[id]:Destroy() end) ST.wpParts[id]=nil end
end
ST.wpSelected=ST.wpSelected or 1
local wpFrame=Instance.new("Frame") wpFrame.Size=UDim2.new(1,-10,0,60) wpFrame.BackgroundColor3=TH.p wpFrame.BorderSizePixel=0 wpFrame.Parent=tP mkCorner(wpFrame,6)
local wpSelLbl=Instance.new("TextLabel") wpSelLbl.Size=UDim2.new(0.5,0,0.5,0) wpSelLbl.Position=UDim2.new(0,8,0,0) wpSelLbl.BackgroundTransparency=1 wpSelLbl.Text="Selected: WP1" wpSelLbl.TextColor3=wpColors[1] wpSelLbl.TextSize=12 wpSelLbl.Font=Enum.Font.GothamBold wpSelLbl.TextXAlignment=Enum.TextXAlignment.Left wpSelLbl.Parent=wpFrame
local function updateWPLbl()
    wpSelLbl.Text="Selected: WP"..ST.wpSelected
    wpSelLbl.TextColor3=wpColors[ST.wpSelected] or TH.a
end
local wpSel=1
local wpSelBtns={}
for i=1,5 do
    local b=Instance.new("TextButton") b.Size=UDim2.new(0,36,0,22) b.Position=UDim2.new(0,(i-1)*40+4,0.5,2) b.BackgroundColor3=wpColors[i] b.BackgroundTransparency=0.6 b.BorderSizePixel=0 b.Text="WP"..i b.TextColor3=TH.t b.TextSize=10 b.Font=Enum.Font.GothamBold b.Parent=wpFrame mkCorner(b,4)
    b.MouseButton1Click:Connect(function() ST.wpSelected=i updateWPLbl() ntf("WP","Selected WP"..i) end)
    wpSelBtns[i]=b
end
btn(tP,"Set Selected WP",function() pcall(function() if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then local id=ST.wpSelected ST.waypoints[id]=LP.Character.HumanoidRootPart.Position+Vector3.new(0,2,0) createWPVisual(id,ST.waypoints[id]) ntf("Waypoint","Set WP"..id.."!") end end) end,"setwp")
btn(tP,"TP to Selected WP",function() pcall(function() local id=ST.wpSelected if ST.waypoints[id] and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then LP.Character.HumanoidRootPart.CFrame=CFrame.new(ST.waypoints[id]) end end) end,"tpwp")
btn(tP,"Clear Selected WP",function() pcall(function() local id=ST.wpSelected ST.waypoints[id]=nil clearWPVisual(id) ntf("Waypoint","Cleared WP"..id.."!") end) end,"clrwp")
btn(tP,"Clear All Waypoints",function() pcall(function() ST.waypoints={} for i=1,5 do clearWPVisual(i) end ntf("Waypoint","All cleared!") end) end,"clrwpall")
local tEx=tF["exploit"]
lbl(tEx,">> GRAND RP EXPLOITS")
sep(tEx)
local function doFullHeal()
    pcall(function()
        local ch=LP.Character
        if not ch then return end
        local h=ch:FindFirstChildOfClass("Humanoid")
        if not h then return end
        if h.MaxHealth<100 then h.MaxHealth=100 end
        h.Health=h.MaxHealth
        h.PlatformStand=false
        pcall(function() h:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end)
    end)
    local paths={
        "Hospital.EKAB","Hospital.Heal","Hospital.heal","Hospital.Revive",
        "Hospital.Treat","Hospital.Ambulance","Ambulance.EKAB","EKAB",
        "HealEvent","Heal","ReviveEvent","revive","medicHeal","Medic.Heal"
    }
    local fired=0
    for _,path in ipairs(paths) do
        pcall(function()
            local r=findRemote(path)
            if r then
                if r:IsA("RemoteFunction") then
                    r:InvokeServer(LP)
                else
                    r:FireServer(LP)
                    r:FireServer()
                    r:FireServer(LP.Name)
                end
                fired=fired+1
            end
        end)
    end
    pcall(function()
        for _,d in pairs(RS:GetDescendants()) do
            if (d:IsA("RemoteEvent") or d:IsA("RemoteFunction")) then
                local nm=string.lower(d.Name)
                if nm:find("heal") or nm:find("ekab") or nm:find("revive") or nm:find("medic") then
                    if d:IsA("RemoteEvent") then
                        d:FireServer(LP)
                    end
                    fired=fired+1
                end
            end
        end
    end)
    ST._healBurst=tick()
    ntf("Heal", fired>0 and ("Full heal + "..fired.." remote(s)") or "Full heal applied")
end
btn(tEx,"Full Heal Self",function() if cd() then doFullHeal() end end,"fheal")
local function bindGodHC()
    pcall(function()
        if ST._godHC then pcall(function() ST._godHC:Disconnect() end) ST._godHC=nil end
        local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum and ST.godmodeLoop then
            ST._godHC=hum.HealthChanged:Connect(function(h)
                if not ST.godmodeLoop then return end
                pcall(function()
                    if hum.MaxHealth<100 then hum.MaxHealth=100 end
                    if h<hum.MaxHealth then hum.Health=hum.MaxHealth end
                    if h<=0 then hum.Health=hum.MaxHealth end
                end)
            end)
        end
    end)
end
local tGML=tog(tEx,"Godmode Loop",function() return ST.godmodeLoop end,function() ST.godmodeLoop=not ST.godmodeLoop if ST.godmodeLoop then bindGodHC() syncServerGod() ntf("Godmode","ON - blocks weapon spheres + server ammo") else if ST._godHC then pcall(function() ST._godHC:Disconnect() end) ST._godHC=nil end syncServerGod() ntf("Godmode","OFF") end end,"godloop")
table.insert(allToggles,tGML)
local tSPH3=tog(tEx,"Spheres on Click",function() return ST.spheresOn end,function() ST.spheresOn=not ST.spheresOn ntf("Spheres",ST.spheresOn and "ON - LMB throws neon spheres" or "OFF") end,"spheres")
table.insert(allToggles,tSPH3)
local function equipAnyTool()
    pcall(function()
        if not LP.Character then return end
        local tool=LP.Character:FindFirstChildOfClass("Tool")
        if tool then return end
        local bp=LP:FindFirstChild("Backpack")
        if not bp then return end
        for _,t in pairs(bp:GetChildren()) do
            if t:IsA("Tool") then t.Parent=LP.Character return end
        end
    end)
end
local function nearestPl(maxD)
    local best=nil local bestD=maxD or 12
    local my=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not my then return nil end
    for _,pp in pairs(P:GetPlayers()) do
        if pp~=LP and pp.Character and pp.Character:FindFirstChild("HumanoidRootPart") then
            local d=(pp.Character.HumanoidRootPart.Position-my.Position).Magnitude
            if d<bestD then bestD=d best=pp end
        end
    end
    return best
end
local function doGreenSteal()
    if not cd() then return end
    equipAnyTool()
    local t=ST.selectedPlayer
    if not t or t==LP or not t.Character then t=nearestPl(15) end
    if not t then ntf("Steal","No player nearby / not selected",4) return end
    local fired=0
    local paths={
        "ThiefSystem.RemoteEvent","ThiefSystem.Steal","ThiefSystem",
        "StealEvent","Steal","PickpocketEvent","Pickpocket",
        "RobEvent","RobPlayer","Rob","ThiefRob",
        "Inventory.Steal","PlayerActions.Steal"
    }
    local argSets={
        {t},{t.Name},{"steal",t},{"steal",t.Name},
        {t,"steal"},{t.UserId},{t.Name,true},{"rob",t.Name}
    }
    for _,path in ipairs(paths) do
        pcall(function()
            local r=findRemote(path)
            if r and r:IsA("RemoteEvent") then
                for _,args in ipairs(argSets) do
                    pcall(function() r:FireServer(unpack(args)) end)
                end
                fired=fired+1
            elseif r and r:IsA("RemoteFunction") then
                pcall(function() r:InvokeServer(t) end)
                pcall(function() r:InvokeServer(t.Name) end)
                fired=fired+1
            end
        end)
    end
    pcall(function()
        for _,d in pairs(RS:GetDescendants()) do
            if d:IsA("RemoteEvent") then
                local nm=d.Name:lower()
                if nm:find("steal") or nm:find("thief") or nm:find("pickpocket") or (nm:find("rob") and not nm:find("group")) then
                    pcall(function() d:FireServer(t) end)
                    pcall(function() d:FireServer(t.Name) end)
                    pcall(function() d:FireServer("steal",t.Name) end)
                    fired=fired+1
                end
            end
        end
    end)
    ntf("Steal",fired>0 and ("Tried "..fired.." path(s) on "..t.DisplayName.." - no weapon needed") or "No steal remotes found",4)
end
btn(tEx,"Steal in Greenzone (no gun)",function() doGreenSteal() end,"stealgreen")
local tGS=tog(tEx,"Auto Steal Loop",function() return ST.autoSteal end,function() ST.autoSteal=not ST.autoSteal if ST.autoSteal then ntf("Steal","Loop ON - nearest every 0.6s") else ntf("Steal","Loop OFF") end end,"autosteal")
table.insert(allToggles,tGS)
sep(tEx)
lbl(tEx,">> VISIBLE REMOTE EFFECTS")
btn(tEx,"Fire Weapon (Effects)",function() pcall(function() local r=findRemote("WeaponsSystem.Network.WeaponFired") if r then r:FireServer() ntf("Weapon","Fired!") end end) end,"weapfire")
btn(tEx,"Toggle Police Siren",function() pcall(function() local r=findRemote("ToggleSirenEvent") if r then r:FireServer(true) ntf("Siren","Toggled (true)!") end end) end,"siren")
btn(tEx,"Spam Siren x5",function() if cd() then pcall(function() local r=findRemote("ToggleSirenEvent") if r then for i=1,5 do r:FireServer(true) task.wait(0.1) end ntf("Siren","Spam x5!") end end) end end,"siren5")
btn(tEx,"Siren Off",function() pcall(function() local r=findRemote("ToggleSirenEvent") if r then r:FireServer(false) ntf("Siren","Off!") end end) end,"sirenoff")
btn(tEx,"Weapon Hit (Fake)",function() pcall(function() local r=findRemote("WeaponsSystem.Network.Hit") if r then local ch=LP.Character if ch then local hrp=ch:FindFirstChild("HumanoidRootPart") if hrp then r:FireServer(hrp.Position) ntf("Weapon","Hit sent!") end end end end) end,"weaphit")
sep(tEx)
lbl(tEx,">> MAGIC BULLET")
local tMB=tog(tEx,"Magic Bullet",function() return ST.magicBullet end,function() ST.magicBullet=not ST.magicBullet ntf("MagicBullet",ST.magicBullet and "ON - Bullets hit through walls!" or "OFF") end,"magbul")
table.insert(allToggles,tMB)
local tWD=tog(tEx,"Weapon Dmg (MP)",function() return ST.weaponDmgOn end,function() ST.weaponDmgOn=not ST.weaponDmgOn ntf("WeaponDmg",ST.weaponDmgOn and "ON - hits damage other players" or "OFF") end,"weapdmg")
table.insert(allToggles,tWD)
btn(tEx,"Dmg: 20",function() ST.weaponDmg=20 ntf("WeaponDmg","Amount: 20") end,"wdmg20")
btn(tEx,"Dmg: 40",function() ST.weaponDmg=40 ntf("WeaponDmg","Amount: 40") end,"wdmg40")
btn(tEx,"Dmg: 60",function() ST.weaponDmg=60 ntf("WeaponDmg","Amount: 60") end,"wdmg60")
btn(tEx,"Dmg: 100",function() ST.weaponDmg=100 ntf("WeaponDmg","Amount: 100") end,"wdmg100")
btn(tEx,"Mult x1",function() ST.weaponDmgMult=1 ntf("WeaponDmg","Multiplier: x1") end,"wmult1")
btn(tEx,"Mult x2",function() ST.weaponDmgMult=2 ntf("WeaponDmg","Multiplier: x2") end,"wmult2")
btn(tEx,"Mult x5",function() ST.weaponDmgMult=5 ntf("WeaponDmg","Multiplier: x5") end,"wmult5")
btn(tEx,"Mult x10",function() ST.weaponDmgMult=10 ntf("WeaponDmg","Multiplier: x10") end,"wmult10")
sep(tEx)
lbl(tEx,">> MULTIPLAYER KILL (no server.lua)")
btn(tEx,"Kill Selected/Nearest (MP)",function()
    if cd() then killNearestOrSelected() end
end,"killmp")
btn(tEx,"Kill All in Range 40 (MP)",function()
    if not cd() then return end
    local my=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not my then return end
    local nkill=0
    for _,pp in pairs(P:GetPlayers()) do
        if pp~=LP and pp.Character and pp.Character:FindFirstChild("HumanoidRootPart") then
            local d=(pp.Character.HumanoidRootPart.Position-my.Position).Magnitude
            if d<=40 then
                for i=1,2 do mpKillPlayer(pp, pp.Character.HumanoidRootPart.Position) end
                pcall(function()
                    if not AR then AR=RS:FindFirstChild("AdminRemote") or RS:FindFirstChild("HDAdminRemote") end
                    if AR then AR:FireServer("kill", pp.Name) end
                end)
                nkill=nkill+1
            end
        end
    end
    ntf("Kill","Tried MP kill on "..nkill.." player(s) in 40 studs")
end,"killall40")
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
local tAim=tog(tEx,"Aimbot (Silent)",function() return ST.aimEnabled end,function() ST.aimEnabled=not ST.aimEnabled if ST.aimEnabled then ntf("Aimbot","ON - Silent Aim") else ntf("Aimbot","OFF") local myHum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if myHum then myHum.AutoRotate=true end end end,"aimbot")
table.insert(allToggles,tAim)
local tAimHold=tog(tEx,"Hold to Aim",function() return ST.aimHoldKey end,function() ST.aimHoldKey=not ST.aimHoldKey if not ST.aimHoldKey then ST.aimKeyHeld=false KBActive.aimhold=nil else if not KB.aimhold then KB.aimhold=Enum.UserInputType.MouseButton2 KBMode.aimhold="hold" end if not KB.aimbot or KBMode.aimbot~="hold" then KBMode.aimhold="hold" end ntf("Aimbot","Hold ON - hold "..getKeyDisplay(KB.aimhold).." to aim (default RMB)") end refreshKBBtns() end,"aimhold")
table.insert(allToggles,tAimHold)
lbl(tEx,"Aim Target Part")
local aimParts={"Head","HumanoidRootPart","UpperTorso","LowerTorso","Torso"}
local aimDropBtn=Instance.new("TextButton") aimDropBtn.Size=UDim2.new(1,-12,0,34) aimDropBtn.BackgroundColor3=TH.b aimDropBtn.BorderSizePixel=0 aimDropBtn.Text="  Target: "..ST.aimTargetPart aimDropBtn.TextColor3=TH.t aimDropBtn.TextSize=13 aimDropBtn.Font=Enum.Font.GothamMedium aimDropBtn.TextXAlignment=Enum.TextXAlignment.Left aimDropBtn.Parent=tEx mkCorner(aimDropBtn,6) mkStroke(aimDropBtn,TH.a,1)
local aimDropOpen=false local aimDropList=nil
aimDropBtn.MouseButton1Click:Connect(function()
    aimDropOpen=not aimDropOpen
    if aimDropOpen then
        if aimDropList then aimDropList:Destroy() end
        aimDropList=Instance.new("ScrollingFrame")
        local bw=aimDropBtn.AbsoluteSize.X
        if bw<40 then bw=300 end
        aimDropList.Size=UDim2.fromOffset(bw,160)
        aimDropList.BackgroundColor3=TH.s
        aimDropList.BorderSizePixel=0
        aimDropList.ScrollBarThickness=3
        aimDropList.ScrollBarImageColor3=TH.a
        aimDropList.ZIndex=110
        aimDropList.Active=true
        aimDropList.Parent=OVF
        aimDropList.CanvasSize=UDim2.new(0,0,0,0)
        aimDropList.AutomaticCanvasSize=Enum.AutomaticSize.Y
        aimDropList.ScrollingDirection=Enum.ScrollingDirection.Y
        mkCorner(aimDropList,6)
        mkStroke(aimDropList,TH.a,1)
        mkPadding(aimDropList,2,2,4,4)
        local abp=aimDropBtn.AbsolutePosition
        local aop=OVF.AbsolutePosition
        aimDropList.Position=UDim2.fromOffset(abp.X-aop.X,abp.Y-aop.Y+aimDropBtn.AbsoluteSize.Y)
        local y=4
        for _,pn in pairs(aimParts) do
            local o=Instance.new("TextButton")
            o.Size=UDim2.new(1,-8,0,26)
            o.Position=UDim2.new(0,4,0,y)
            o.BackgroundColor3=TH.b
            o.BorderSizePixel=0
            o.Text="  "..pn
            o.TextColor3=TH.t
            o.TextXAlignment=Enum.TextXAlignment.Left
            o.TextSize=12
            o.Font=Enum.Font.Gotham
            o.ZIndex=111
            o.Parent=aimDropList
            mkCorner(o,4)
            y=y+28
            o.MouseEnter:Connect(function() o.BackgroundColor3=TH.bh end)
            o.MouseLeave:Connect(function() o.BackgroundColor3=TH.b end)
            o.MouseButton1Click:Connect(function() ST.aimTargetPart=pn aimDropBtn.Text="  Target: "..pn aimDropOpen=false if aimDropList then aimDropList:Destroy() aimDropList=nil end ntf("Aimbot","Target: "..pn) end)
        end
        aimDropList.CanvasSize=UDim2.new(0,0,0,y+4)
    else if aimDropList then aimDropList:Destroy() aimDropList=nil end end
end)
makeSlider(tEx,"FOV",20,500,function() return ST.aimFOV end,function(v) ST.aimFOV=math.floor(v) if ST.aimFOVGui then local c=ST.aimFOVGui:FindFirstChild("Circle") if c then c.Size=UDim2.new(0,ST.aimFOV*2,0,ST.aimFOV*2) end end end)
local tAimTC=tog(tEx,"Team Check",function() return ST.aimTeamCheck end,function() ST.aimTeamCheck=not ST.aimTeamCheck ntf("Aimbot","TeamCheck: "..(ST.aimTeamCheck and "ON" or "OFF")) end,"aimtc")
table.insert(allToggles,tAimTC)
local tAimWC=tog(tEx,"Wall Check",function() return ST.aimWallCheck end,function() ST.aimWallCheck=not ST.aimWallCheck ntf("Aimbot","WallCheck: "..(ST.aimWallCheck and "ON (skip through walls)" or "OFF")) end,"aimwc")
table.insert(allToggles,tAimWC)
local tFovShow=tog(tEx,"Show FOV Always",function() return ST.showFOV end,function() ST.showFOV=not ST.showFOV if not ST.showFOV and ST.aimFOVGui then ST.aimFOVGui:Destroy() ST.aimFOVGui=nil end ntf("Aimbot","ShowFOV: "..(ST.showFOV and "ON (always visible)" or "OFF")) end,"showfov")
table.insert(allToggles,tFovShow)
local tMi=tF["misc"]
lbl(tMi,">> MISC")
btn(tMi,"Reset Character",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=0 end end end,"reset")
btn(tMi,"Anti-AFK",function() pcall(function() LP.Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Running) end) end,"antiafk")
local tAC=tog(tMi,"Auto Clicker",function() return ST.autoClicker end,function() ST.autoClicker=not ST.autoClicker ntf("AutoClick",ST.autoClicker and "ON (5 CPS)" or "OFF") end,"autoclick")
table.insert(allToggles,tAC)
local tVS=tog(tMi,"Vehicle Speed",function() return ST.vehicleSpeedOn end,function() ST.vehicleSpeedOn=not ST.vehicleSpeedOn if ST.vehicleSpeedOn then ntf("VehicleSpeed","ON - boost "..tostring(ST.vehBoost or 80).." (re-applied gently)") else ntf("VehicleSpeed","OFF - restoring car speeds") pcall(function() if ST._vehOrig and LP.Character then local hum=LP.Character:FindFirstChildOfClass("Humanoid") if hum and hum.Seated and hum.SeatPart and ST._vehOrig[hum.SeatPart] then hum.SeatPart.MaxSpeed=ST._vehOrig[hum.SeatPart] end end end) end end,"vehspeed")
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
lbl(tSe,"Click box = set key (any key)")
lbl(tSe,"Backspace while waiting = clear")
lbl(tSe,"Right-click box = Hold/Toggle")
lbl(tSe,"Yellow box = Hold mode active.")
sep(tSe)
lbl(tSe,">> CONFIG SAVE / LOAD")
btn(tSe,"Save Config",function() pcall(function() local cfg={kb={},kbm={},esp={color={CFG.ESPColor.R,CFG.ESPColor.G,CFG.ESPColor.B},fillAlpha=CFG.ESPFillAlpha,outline=CFG.ESPOutlineEnabled,fill=CFG.ESPFillEnabled,name=CFG.ESPShowName,health=CFG.ESPShowHealth,distance=CFG.ESPShowDistance,maxDist=CFG.ESPMaxDist}} for id,key in pairs(KB) do cfg.kb[id]=tostring(key) end for id,m in pairs(KBMode) do cfg.kbm[id]=m end writefile("AxynthConfig.json",game:GetService("HttpService"):JSONEncode(cfg)) ntf("Config","Saved to AxynthConfig.json!") end) end,"savecfg")
btn(tSe,"Load Config",function() pcall(function() if readfile then local raw=readfile("AxynthConfig.json") if raw then local cfg=game:GetService("HttpService"):JSONDecode(raw) if cfg.kb then for id,str in pairs(cfg.kb) do local kcn=str:match("Enum%.KeyCode%.(.+)") if kcn and Enum.KeyCode[kcn] then KB[id]=Enum.KeyCode[kcn] else local utn=str:match("Enum%.UserInputType%.(.+)") if utn and Enum.UserInputType[utn] then KB[id]=Enum.UserInputType[utn] end end end end if cfg.kbm then for id,m in pairs(cfg.kbm) do KBMode[id]=m end end refreshKBBtns() if cfg.esp then local c=cfg.esp if c.color then CFG.ESPColor=Color3.new(c.color[1],c.color[2],c.color[3]) end if c.fillAlpha then CFG.ESPFillAlpha=c.fillAlpha end if c.outline~=nil then CFG.ESPOutlineEnabled=c.outline end if c.fill~=nil then CFG.ESPFillEnabled=c.fill end if c.name~=nil then CFG.ESPShowName=c.name end if c.health~=nil then CFG.ESPShowHealth=c.health end if c.distance~=nil then CFG.ESPShowDistance=c.distance end if c.maxDist then CFG.ESPMaxDist=c.maxDist end end for _,t in pairs(allToggles) do if togUpdates[t] then togUpdates[t]() end end ntf("Config","Loaded from AxynthConfig.json!") end end end) end,"loadcfg")
btn(tSe,"Delete Config",function() pcall(function() if delfile then delfile("AxynthConfig.json") ntf("Config","Deleted!") end end) end,"delcfg")
sep(tSe)
lbl(tSe,">> UNHOOK / CLEANUP")
btn(tSe,"Unload Everything",function() pcall(function() ST.fly=false ST.noclip=false ST.clickTP=false ST.esp=false ST.spinner=false ST.autoClicker=false ST.infJump=false setFreeCam(false) setNight(false) setNoFog(false) ST.maceTP=false ST.botRecord=false ST.botPlay=false ST.botLoop=false ST.godmodeLoop=false syncServerGod() ST.spheresOn=false ST.autoSteal=false ST.speedHard=false ST.infStamina=false ST.magicBullet=false ST.weaponDmgOn=false ST.weaponDmgMult=1 ST.vehicleSpeedOn=false ST.spectateOverhead=false ST.spectating=nil if ST._vehOrig then for seat,sp in pairs(ST._vehOrig) do pcall(function() if seat and seat.Parent then seat.MaxSpeed=sp end end) end ST._vehOrig=nil end ST.arrayList=false ST.aimEnabled=false ST.remoteSpyOn=false local myHum0=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if myHum0 then myHum0.AutoRotate=true end table.clear(KBActive) if ST.aimFOVGui then ST.aimFOVGui:Destroy() ST.aimFOVGui=nil end if ST.spySG then pcall(function() ST.spySG:Destroy() end) ST.spySG=nil end if ST.palSG then pcall(function() ST.palSG:Destroy() end) ST.palSG=nil end if pDropdown then pcall(function() pDropdown:Destroy() end) pDropdown=nil pDropOpen=false end if aimDropList then pcall(function() aimDropList:Destroy() end) aimDropList=nil aimDropOpen=false end if _G._spyFrame then _G._spyFrame=nil end if _G._spyAdd then _G._spyAdd=nil end if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=16 h.JumpPower=50 h.PlatformStand=false h.AutoRotate=true end end W.Gravity=196.2 if ST.markerObj then ST.markerObj:Destroy() ST.markerObj=nil end ST.waypoints={} for i=1,5 do if ST.wpParts and ST.wpParts[i] then pcall(function() ST.wpParts[i]:Destroy() end) ST.wpParts[i]=nil end end for id,hl in pairs(ST.espList) do if hl and hl.Parent then hl:Destroy() end end ST.espList={} if ST.esp2D then for uid,fr in pairs(ST.esp2D) do if fr then pcall(function() fr:Destroy() end) end end ST.esp2D={} end for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and pp.Character:FindFirstChild("AxESP_BB") then pp.Character.AxESP_BB:Destroy() end if pp~=LP and pp.Character and pp.Character:FindFirstChild("AxESP") then pp.Character.AxESP:Destroy() end end if ST.savedCollide then ST.savedCollide={} end if ST.savedLighting then L.Brightness=ST.savedLighting.Brightness L.GlobalShadows=ST.savedLighting.GlobalShadows L.FogEnd=ST.savedLighting.FogEnd L.Ambient=ST.savedLighting.Ambient L.OutdoorAmbient=ST.savedLighting.OutdoorAmbient L.ClockTime=ST.savedLighting.ClockTime ST.savedLighting=nil end if ST.cursorTPPreview and ST.cursorTPPreview.Parent then ST.cursorTPPreview:Destroy() ST.cursorTPPreview=nil end if _G.AxArrayList and _G.AxArrayList.Parent then _G.AxArrayList:Destroy() _G.AxArrayList=nil end ntf("Cleanup","All features disabled!") end) end,"unload")
print("[Axynth] All tabs OK")
U.InputBegan:Connect(function(inp,gpe)
    if gpe then return end
    if waitingForKey then
        local wid=waitingForKey
        if inp.KeyCode==Enum.KeyCode.Backspace or inp.KeyCode==Enum.KeyCode.Delete then
            KB[wid]=nil waitingForKey=nil ntf("Keybind","Keybind cleared!")
        else
            local key=inp.KeyCode~=Enum.KeyCode.Unknown and inp.KeyCode or inp.UserInputType KB[wid]=key waitingForKey=nil ntf("Keybind","Key assigned!")
        end
        refreshKBBtns()
        for _,t in pairs(allToggles) do if togUpdates[t] then togUpdates[t]() end end return
    end
    for id,key in pairs(KB) do
        if key and (inp.KeyCode==key or inp.UserInputType==key) then
            if KBMode[id]=="hold" then
                if not KBActive[id] then
                    KBActive[id]=true
                    if id=="fly" then ST.fly=true ST.godmodeLoop=true syncServerGod()
                    elseif id=="noclip" then ST.noclip=true
                    elseif id=="freecam" then setFreeCam(true)
                    elseif id=="esp" then ST.esp=true
                    elseif id=="night" then setNight(true)
                    elseif id=="bright" then ST.bright=true if not ST.savedLighting then ST.savedLighting={Brightness=L.Brightness,GlobalShadows=L.GlobalShadows,FogEnd=L.FogEnd,Ambient=L.Ambient,OutdoorAmbient=L.OutdoorAmbient,ClockTime=L.ClockTime} end
                    elseif id=="nofog" then setNoFog(true)
                    elseif id=="aimbot" then ST.aimKeyHeld=true
                    elseif id=="aimhold" then ST.aimKeyHeld=true
                    elseif id=="showfov" then ST.showFOV=true
                    elseif id=="aimwc" then ST.aimWallCheck=true
                    elseif id=="infjump" then ST.infJump=true ST.godmodeLoop=true syncServerGod()
                    elseif id=="godloop" then ST.godmodeLoop=true syncServerGod()
                    elseif id=="spheres" then ST.spheresOn=true
                    elseif id=="autosteal" then ST.autoSteal=true
                    elseif id=="speedhard" then ST.speedHard=true ST.speedPreset=math.max(ST.speedPreset,50)
                    elseif id=="infstam" then ST.infStamina=true
                    elseif id=="magbul" then ST.magicBullet=true
                    elseif id=="weapdmg" then ST.weaponDmgOn=true
                    elseif id=="spinner" then ST.spinner=true
                    elseif id=="autoclick" then ST.autoClicker=true
                    elseif id=="macetp" then ST.maceTP=true
                    elseif id=="vehspeed" then ST.vehicleSpeedOn=true
                    elseif id=="arraylist" then ST.arrayList=true
                    elseif id=="clicktp" then ST.clickTP=true
                    end
                    for _,t in pairs(allToggles) do if togUpdates[t] then togUpdates[t]() end end
                end
            else
            if id=="fly" then ST.fly=not ST.fly if ST.fly then ST.godmodeLoop=true syncServerGod() end if not ST.fly and LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.PlatformStand=false end end
            elseif id=="noclip" then ST.noclip=not ST.noclip
            elseif id=="freecam" then setFreeCam(not ST.freeCam)
            elseif id=="clicktp" then ST.clickTP=not ST.clickTP if ST.clickTP then if not ST.cursorTPPreview then local p=Instance.new("Part") p.Name="AxCTPPreview" p.Size=Vector3.new(3,0.2,3) p.Anchored=true p.CanCollide=false p.Material=Enum.Material.Neon p.Color=Color3.fromRGB(255,0,0) p.Transparency=0.5 p.Parent=W ST.cursorTPPreview=p end else if ST.cursorTPPreview then ST.cursorTPPreview:Destroy() ST.cursorTPPreview=nil end end
            elseif id=="esp" then ST.esp=not ST.esp if ST.esp then for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and not pp.Character:FindFirstChild("AxESP") then local hl=Instance.new("Highlight") hl.Name="AxESP" hl.FillColor=CFG.ESPColor hl.FillTransparency=CFG.ESPFillAlpha hl.OutlineColor=Color3.new(1,1,1) hl.OutlineTransparency=0 hl.Parent=pp.Character ST.espList[pp.UserId]=hl end end else for uid,hl in pairs(ST.espList) do if hl and hl.Parent then hl:Destroy() end ST.espList[uid]=nil end end
            elseif id=="night" then setNight(not ST.night)
            elseif id=="bright" then ST.bright=not ST.bright if ST.bright and not ST.savedLighting then ST.savedLighting={Brightness=L.Brightness,GlobalShadows=L.GlobalShadows,FogEnd=L.FogEnd,Ambient=L.Ambient,OutdoorAmbient=L.OutdoorAmbient,ClockTime=L.ClockTime} elseif not ST.bright and ST.savedLighting then pcall(function() L.Brightness=ST.savedLighting.Brightness L.GlobalShadows=ST.savedLighting.GlobalShadows L.FogEnd=ST.savedLighting.FogEnd L.Ambient=ST.savedLighting.Ambient L.OutdoorAmbient=ST.savedLighting.OutdoorAmbient L.ClockTime=ST.savedLighting.ClockTime end) ST.savedLighting=nil end
            elseif id=="nofog" then setNoFog(not ST.noFog)
            elseif id=="aimbot" then if ST.aimHoldKey then ST.aimKeyHeld=true else ST.aimEnabled=not ST.aimEnabled if ST.aimEnabled then ntf("Aimbot","ON") else ntf("Aimbot","OFF") end end
            elseif id=="aimhold" then if KBMode.aimhold=="toggle" then ST.aimKeyHeld=not ST.aimKeyHeld else ST.aimKeyHeld=true end
            elseif id=="showfov" then ST.showFOV=not ST.showFOV
            elseif id=="aimwc" then ST.aimWallCheck=not ST.aimWallCheck
            elseif id=="infjump" then ST.infJump=not ST.infJump if ST.infJump then ST.godmodeLoop=true syncServerGod() ntf("InfJump","ON - Space + Godmode forced") end
            elseif id=="godloop" then ST.godmodeLoop=not ST.godmodeLoop syncServerGod()
            elseif id=="spheres" then ST.spheresOn=not ST.spheresOn if ST.spheresOn then ntf("Spheres","ON") else ntf("Spheres","OFF") end
            elseif id=="autosteal" then ST.autoSteal=not ST.autoSteal if ST.autoSteal then ntf("Steal","Loop ON") else ntf("Steal","Loop OFF") end
            elseif id=="speedhard" then ST.speedHard=not ST.speedHard ST.speedPreset=ST.speedHard and math.max(ST.speedPreset,50) or 0 pcall(function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=ST.speedHard and 50 or 16 end end end)
            elseif id=="infstam" then ST.infStamina=not ST.infStamina
            elseif id=="magbul" then ST.magicBullet=not ST.magicBullet
            elseif id=="weapdmg" then ST.weaponDmgOn=not ST.weaponDmgOn if ST.weaponDmgOn then ntf("WeaponDmg","ON") else ntf("WeaponDmg","OFF") end
            elseif id=="spinner" then ST.spinner=not ST.spinner if not ST.spinner and LP.Character then for _,v in pairs(LP.Character:GetDescendants()) do if v:IsA("BodyAngularVelocity") and v.Name:find("AxSpin") then v:Destroy() end end end
            elseif id=="autoclick" then ST.autoClicker=not ST.autoClicker
            elseif id=="macetp" then ST.maceTP=not ST.maceTP
            elseif id=="vehspeed" then ST.vehicleSpeedOn=not ST.vehicleSpeedOn if not ST.vehicleSpeedOn then pcall(function() if ST._vehOrig and LP.Character then local hum=LP.Character:FindFirstChildOfClass("Humanoid") if hum and hum.Seated and hum.SeatPart and ST._vehOrig[hum.SeatPart] then hum.SeatPart.MaxSpeed=ST._vehOrig[hum.SeatPart] end end end) end
            elseif id=="arraylist" then ST.arrayList=not ST.arrayList
            end
            end
            for _,t in pairs(allToggles) do if togUpdates[t] then togUpdates[t]() end end
        end
    end
    if inp.KeyCode==Enum.KeyCode.RightShift then ST.menuOpen=not ST.menuOpen if ST.menuOpen then MF.Visible=true MF.BackgroundTransparency=1 MF.Size=UDim2.new(0,520,0,420) tw(MF,{BackgroundTransparency=0.02,Size=UDim2.new(0,520,0,480),Position=UDim2.new(0.5,-260,0.5,-240)},0.35) else tw(MF,{Position=UDim2.new(0.5,-260,0.5,-280),BackgroundTransparency=1,Size=UDim2.new(0,520,0,420)},0.25) wait(0.25) MF.Visible=false MF.Position=UDim2.new(0.5,-260,0.5,-240) MF.Size=UDim2.new(0,520,0,480) MF.BackgroundTransparency=0.02 if pDropdown then pcall(function() pDropdown:Destroy() end) pDropdown=nil pDropOpen=false end if aimDropList then pcall(function() aimDropList:Destroy() end) aimDropList=nil aimDropOpen=false end end end
end)
U.InputEnded:Connect(function(inp)
    if KB.aimhold and (inp.KeyCode==KB.aimhold or inp.UserInputType==KB.aimhold) then
        if KBMode.aimhold~="toggle" then ST.aimKeyHeld=false end
    end
    if ST.aimHoldKey and KB.aimbot and (inp.KeyCode==KB.aimbot or inp.UserInputType==KB.aimbot) then
        if KBMode.aimbot~="toggle" then ST.aimKeyHeld=false end
    end
    if ST.aimHoldKey and KB.aimhold and (inp.KeyCode==KB.aimhold or inp.UserInputType==KB.aimhold) then
        if KBMode.aimhold~="toggle" then ST.aimKeyHeld=false end
    end
    for id,act in pairs(KBActive) do
        if act then
            local key=KB[id]
            if key and (inp.KeyCode==key or inp.UserInputType==key) then
                KBActive[id]=nil
                if id=="fly" then ST.fly=false if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.PlatformStand=false end end
                elseif id=="noclip" then ST.noclip=false
                elseif id=="freecam" then setFreeCam(false)
                elseif id=="esp" then ST.esp=false
                elseif id=="night" then setNight(false)
                elseif id=="bright" then ST.bright=false if ST.savedLighting then pcall(function() L.Brightness=ST.savedLighting.Brightness L.GlobalShadows=ST.savedLighting.GlobalShadows L.FogEnd=ST.savedLighting.FogEnd L.Ambient=ST.savedLighting.Ambient L.OutdoorAmbient=ST.savedLighting.OutdoorAmbient L.ClockTime=ST.savedLighting.ClockTime end) ST.savedLighting=nil end
                elseif id=="nofog" then setNoFog(false)
                elseif id=="aimbot" then ST.aimKeyHeld=false
                elseif id=="aimhold" then ST.aimKeyHeld=false
                elseif id=="showfov" then ST.showFOV=false if ST.aimFOVGui then ST.aimFOVGui:Destroy() ST.aimFOVGui=nil end
                elseif id=="aimwc" then ST.aimWallCheck=false
                elseif id=="infjump" then ST.infJump=false
                elseif id=="godloop" then ST.godmodeLoop=false syncServerGod()
                elseif id=="spheres" then ST.spheresOn=false
                elseif id=="autosteal" then ST.autoSteal=false
                elseif id=="speedhard" then ST.speedHard=false ST.speedPreset=0 pcall(function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=16 end end end)
                elseif id=="infstam" then ST.infStamina=false
                elseif id=="magbul" then ST.magicBullet=false
                elseif id=="weapdmg" then ST.weaponDmgOn=false
                elseif id=="spinner" then ST.spinner=false if LP.Character then for _,v in pairs(LP.Character:GetDescendants()) do if v:IsA("BodyAngularVelocity") and v.Name:find("AxSpin") then v:Destroy() end end end
                elseif id=="autoclick" then ST.autoClicker=false
                elseif id=="macetp" then ST.maceTP=false
                elseif id=="vehspeed" then ST.vehicleSpeedOn=false pcall(function() if ST._vehOrig and LP.Character then local hum=LP.Character:FindFirstChildOfClass("Humanoid") if hum and hum.Seated and hum.SeatPart and ST._vehOrig[hum.SeatPart] then hum.SeatPart.MaxSpeed=ST._vehOrig[hum.SeatPart] end end end)
                elseif id=="arraylist" then ST.arrayList=false
                elseif id=="clicktp" then ST.clickTP=false if ST.cursorTPPreview then ST.cursorTPPreview:Destroy() ST.cursorTPPreview=nil end
                end
                for _,t in pairs(allToggles) do if togUpdates[t] then togUpdates[t]() end end
            end
        end
    end
    if ST.aimHoldKey and KB.aimbot and (inp.KeyCode==KB.aimbot or inp.UserInputType==KB.aimbot) and KBMode.aimbot~="toggle" then ST.aimKeyHeld=false end
end)
local _lastTracer=0
local function dealWeaponDamage(victim, hitPos)
    if not ST.weaponDmgOn then return end
    if not victim or victim==LP or not victim.Character then return end
    local now=tick()
    if now-(ST._wdT or 0)<0.1 then return end
    ST._wdT=now
    local mult=math.clamp(ST.weaponDmgMult or 1,1,10)
    local amt=ST.weaponDmg or 30
    pcall(function()
        local my=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local origin=my and my.Position or hitPos
        local rf=findRemote("WeaponsSystem.Network.WeaponFired")
        if rf then
            for i=1,math.min(mult,6) do forceFire(rf, origin, hitPos) end
        end
    end)
    pcall(function()
        local part=victim.Character:FindFirstChild(ST.aimTargetPart) or victim.Character:FindFirstChild("Head") or victim.Character:FindFirstChild("HumanoidRootPart")
        local hits={
            findRemote("WeaponsSystem.Network.WeaponHit"),
            findRemote("WeaponsSystem.Network.Hit")
        }
        for _,r in ipairs(hits) do
            if r then
                for i=1,mult do
                    local jp=hitPos+Vector3.new(math.random(-20,20)/20,math.random(-20,20)/20,math.random(-20,20)/20)
                    forceFire(r, jp)
                    forceFire(r, jp, part)
                    forceFire(r, jp, part, amt)
                    forceFire(r, victim, jp, amt)
                    forceFire(r, victim.Name, jp, part, amt)
                end
            end
        end
    end)
    pcall(function()
        if not AR then AR=RS:FindFirstChild("AdminRemote") or RS:FindFirstChild("HDAdminRemote") end
        if AR then AR:FireServer("damage",victim.Name,amt) end
    end)
end
local function weaponHitScan()
    if not ST.weaponDmgOn then return end
    if tick()-(ST._whsT or 0)<0.12 then return end
    ST._whsT=tick()
    local cam=W.CurrentCamera or CAM
    if not cam then return end
    local origin=cam.CFrame.Position
    local dir=cam.CFrame.LookVector*500
    local aimed=false
    if isAimActive() and ST.aimTarget and ST.aimTarget.Character then
        local tp=ST.aimTarget.Character:FindFirstChild(ST.aimTargetPart) or ST.aimTarget.Character:FindFirstChild("HumanoidRootPart")
        if tp then
            dir=(tp.Position-origin)
            aimed=true
        end
    end
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    local filt={}
    if LP.Character then table.insert(filt,LP.Character) end
    params.FilterDescendantsInstances=filt
    local hit=W:Raycast(origin,dir,params)
    if hit then
        local model=hit.Instance:FindFirstAncestorOfClass("Model")
        local pl=model and P:GetPlayerFromCharacter(model)
        if pl and pl~=LP then
            dealWeaponDamage(pl,hit.Position)
            return
        end
    end
    if aimed and ST.aimTarget and ST.aimTarget.Character then
        local tp=ST.aimTarget.Character:FindFirstChild(ST.aimTargetPart) or ST.aimTarget.Character:FindFirstChild("HumanoidRootPart")
        local h=ST.aimTarget.Character:FindFirstChildOfClass("Humanoid")
        if tp and h and h.Health>0 and not (ST.aimTeamCheck and ST.aimTarget.Team==LP.Team) then
            dealWeaponDamage(ST.aimTarget,tp.Position)
        end
    end
end
local function drawShotTracer()
    pcall(function()
        local now=tick()
        if now-_lastTracer<0.08 then return end
        _lastTracer=now
        local cam=W.CurrentCamera or CAM
        if not cam then return end
        local origin=cam.CFrame.Position
        local dir=cam.CFrame.LookVector*500
        local params=RaycastParams.new()
        params.FilterType=Enum.RaycastFilterType.Exclude
        local filt={}
        if LP.Character then table.insert(filt,LP.Character) end
        params.FilterDescendantsInstances=filt
        local hit=W:Raycast(origin,dir,params)
        local endPos=hit and hit.Position or (origin+dir)
        local holder=Instance.new("Part")
        holder.Name="AxTracer"
        holder.Anchored=true
        holder.CanCollide=false
        holder.CanQuery=false
        holder.Transparency=1
        holder.Size=Vector3.new(0.2,0.2,0.2)
        holder.CFrame=CFrame.lookAt(origin,endPos)
        holder.Parent=W
        local a0=Instance.new("Attachment") a0.Position=Vector3.new(0,0,0) a0.Parent=holder
        local a1=Instance.new("Attachment") a1.Parent=holder
        a1.WorldPosition=endPos
        local beam=Instance.new("Beam")
        beam.Attachment0=a0
        beam.Attachment1=a1
        beam.Width0=0.18
        beam.Width1=0.05
        beam.FaceCamera=true
        beam.Color=ColorSequence.new(Color3.fromRGB(255,210,60),Color3.fromRGB(255,70,70))
        beam.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.1),NumberSequenceKeypoint.new(1,0.6)})
        beam.LightEmission=1
        beam.Parent=holder
        local ball=Instance.new("Part")
        ball.Name="AxTracerHit"
        ball.Shape=Enum.PartType.Ball
        ball.Size=Vector3.new(0.55,0.55,0.55)
        ball.Anchored=true
        ball.CanCollide=false
        ball.CanQuery=false
        ball.Material=Enum.Material.Neon
        ball.Color=Color3.fromRGB(255,140,40)
        ball.Position=endPos
        ball.Parent=W
        task.delay(0.16,function()
            pcall(function()
                if beam then beam:Destroy() end
                if holder then holder:Destroy() end
                if ball then ball:Destroy() end
            end)
        end)
        pcall(function()
            local r=findRemote("WeaponsSystem.Network.WeaponFired")
            if r then forceFire(r, origin, endPos) end
        end)
        weaponHitScan()
    end)
end
local function sphereKillAt(pos)
    pcall(function()
        local hitPl=nil
        for _,pp in pairs(P:GetPlayers()) do
            if pp~=LP and pp.Character and pp.Character:FindFirstChild("HumanoidRootPart") then
                local d=(pp.Character.HumanoidRootPart.Position-pos).Magnitude
                if d<8 then hitPl=pp break end
            end
        end
        if hitPl then
            for i=1,3 do mpKillPlayer(hitPl, pos) end
            pcall(function()
                if not AR then AR=RS:FindFirstChild("AdminRemote") or RS:FindFirstChild("HDAdminRemote") end
                if AR then AR:FireServer("kill", hitPl.Name) end
            end)
            pcall(function()
                local h=hitPl.Character:FindFirstChildOfClass("Humanoid")
                if h and h.Health>0 then h.Health=math.max(0,h.Health-100000) end
            end)
            pcall(function()
                local e=Instance.new("Explosion")
                e.Position=pos
                e.BlastPressure=0
                e.BlastRadius=6
                e.Parent=W
            end)
            ntf("Spheres","Hit "..hitPl.DisplayName.." - killing via game weapons")
        end
    end)
end
local function throwSpheres()
    pcall(function()
        if tick()-(ST._sphT or 0)<0.45 then return end
        ST._sphT=tick()
        local alive=0
        for _,o in pairs(W:GetChildren()) do
            if o.Name=="AxSphere" then
                alive=alive+1
                if alive>24 then pcall(function() o:Destroy() end) end
            end
        end
        local cam=W.CurrentCamera or CAM
        if not cam then return end
        local origin=cam.CFrame.Position
        local look=cam.CFrame.LookVector
        local target=origin+look*120
        pcall(function()
            local params=RaycastParams.new()
            params.FilterType=Enum.RaycastFilterType.Exclude
            local filt={LP.Character}
            if LP.Character then table.insert(filt,LP.Character) end
            params.FilterDescendantsInstances=filt
            local hit=W:Raycast(origin, look*500, params)
            if hit then target=hit.Position end
        end)
        if MS.Hit then
            local mh=MS.Hit.Position
            if (mh-origin).Magnitude<400 then target=mh end
        end
        local dir=(target-origin)
        if dir.Magnitude<1 then dir=look*50 end
        dir=dir.Unit
        fireGameVolley(origin, target)
        pcall(function()
            if not AR then AR=RS:FindFirstChild("AdminRemote") or RS:FindFirstChild("HDAdminRemote") end
            if AR then AR:FireServer("spawnSpheres",origin,target) end
        end)
        local right=cam.CFrame.RightVector
        local up=cam.CFrame.UpVector
        for i=1,10 do
            local ball=Instance.new("Part")
            ball.Name="AxSphere"
            ball.Shape=Enum.PartType.Ball
            ball.Size=Vector3.new(1.4,1.4,1.4)
            ball.Material=Enum.Material.Neon
            ball.Color=Color3.fromRGB(255, math.random(60,160), math.random(20,100))
            ball.Anchored=false
            ball.CanCollide=false
            ball.CanQuery=true
            ball.CanTouch=true
            ball.Massless=true
            ball.CFrame=CFrame.new(origin+look*2+right*((i-5.5)*0.35)+up*0.15)
            ball.Parent=W
            local bv=Instance.new("BodyVelocity")
            bv.Velocity=dir*math.random(90,130)+right*((i-5.5)*8)+up*math.random(2,8)
            bv.MaxForce=Vector3.new(1e5,1e5,1e5)
            bv.P=1e4
            bv.Parent=ball
            local bg=Instance.new("BodyGyro")
            bg.MaxTorque=Vector3.new(1e5,1e5,1e5)
            bg.P=1e4
            bg.Parent=ball
            local light=Instance.new("PointLight")
            light.Color=ball.Color
            light.Range=14
            light.Brightness=2
            light.Parent=ball
            local dead=false
            ball.Touched:Connect(function(hit)
                if dead then return end
                if not hit or not hit:IsA("BasePart") then return end
                local ch=hit:FindFirstAncestorOfClass("Model")
                if not ch then return end
                local h=ch:FindFirstChildOfClass("Humanoid")
                if not h then return end
                local pl=P:GetPlayerFromCharacter(ch)
                if not pl or pl==LP then return end
                dead=true
                local ppos=ball.Position
                pcall(function() ball:Destroy() end)
                sphereKillAt(ppos)
            end)
            task.delay(1.8,function()
                pcall(function()
                    if ball and ball.Parent then
                        sphereKillAt(ball.Position)
                        ball:Destroy()
                    end
                end)
            end)
        end
        ntf("Spheres","Fired x10 - weapon FX via game (visible to all)")
    end)
end
MS.Button1Down:Connect(function()
    if not ST.menuOpen then
        drawShotTracer()
        if ST.spheresOn then throwSpheres() end
    end
    if ST.clickTP and LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h and MS.Hit then h.CFrame=CFrame.new(MS.Hit.Position+Vector3.new(0,2,0)) end end
end)
local lastInfJump=0
local function vaultJumpUnlock(h)
    if not h then return end
    if h.PlatformStand then h.PlatformStand=false end
    if h.Health<=0 then h.Health=h.MaxHealth end
    pcall(function() h:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end)
    pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end)
end
U.JumpRequest:Connect(function()
    if ST.infJump and not ST.freeCam and LP.Character and tick()-lastInfJump>0.05 then
        lastInfJump=tick()
        pcall(function()
            vaultJumpUnlock(LP.Character:FindFirstChildOfClass("Humanoid"))
        end)
    end
end)
print("[Axynth] Events OK")
R.RenderStepped:Connect(function()
    pcall(function()
        if ST.fly and not ST.freeCam and LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h then local dir=Vector3.new(0,0,0) local sp=ST.flySpeed if U:IsKeyDown(Enum.KeyCode.LeftShift) then sp=sp*3 end if U:IsKeyDown(Enum.KeyCode.W) then dir=dir+CAM.CFrame.LookVector end if U:IsKeyDown(Enum.KeyCode.S) then dir=dir-CAM.CFrame.LookVector end if U:IsKeyDown(Enum.KeyCode.A) then dir=dir-CAM.CFrame.RightVector end if U:IsKeyDown(Enum.KeyCode.D) then dir=dir+CAM.CFrame.RightVector end if U:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end if U:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end if dir.Magnitude>0 then dir=dir.Unit h.Velocity=Vector3.new(0,0,0) h.RotVelocity=Vector3.new(0,0,0) h.CFrame=h.CFrame+dir*sp/60 else h.Velocity=Vector3.new(0,0,0) end end end
    end)
    pcall(function()
        if ST.infJump then ST.godmodeLoop=true end
    end)
    pcall(function()
        if ST.godmodeLoop and LP.Character then
            local hum=LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                if hum.MaxHealth<100 then hum.MaxHealth=100 end
                if hum.Health<hum.MaxHealth then hum.Health=hum.MaxHealth end
                if hum.Health<=0 then hum.Health=hum.MaxHealth pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
                if hum.PlatformStand then hum.PlatformStand=false end
            end
            local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local myPos=hrp.Position
                for _,obj in pairs(W:GetDescendants()) do
                    if obj:IsA("BasePart") and obj~=hrp then
                        local nm=obj.Name:lower()
                        if nm=="axsphere" or nm:find("bullet") or nm:find("projectile") or nm:find("slug") or nm:find("shell") then
                            if (obj.Position-myPos).Magnitude<10 then
                                pcall(function() obj:Destroy() end)
                            end
                        end
                    end
                end
            end
        end
    end)
    pcall(function()
        if ST.infJump and not ST.freeCam and LP.Character and U:IsKeyDown(Enum.KeyCode.Space) then
            local hum=LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and tick()-lastInfJump>0.08 then
                lastInfJump=tick()
                vaultJumpUnlock(hum)
            end
        end
    end)
    pcall(function()
        if ST._healBurst and tick()-ST._healBurst<1.5 and LP.Character then
            local hum=LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                if hum.MaxHealth<100 then hum.MaxHealth=100 end
                hum.Health=hum.MaxHealth
                if hum.PlatformStand then hum.PlatformStand=false end
            end
        end
    end)
    pcall(function()
        if not ST.infStamina or not LP.Character then return end
        local now=tick()
        if now-(ST._stamApplyT or 0)<0.2 then return end
        ST._stamApplyT=now
        local ch=LP.Character
        local hum=ch:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if not ST._stamVals or now-(ST._stamT or 0)>5 or ST._stamChar~=ch then
            ST._stamChar=ch
            ST._stamT=now
            ST._stamVals={}
            local names={"stamina","stam","endurance","energy","fatigue","sprint","runstam","breath"}
            local function consider(v)
                if not (v:IsA("NumberValue") or v:IsA("IntValue") or v:IsA("FloatValue") or v:IsA("BoolValue")) then return end
                local n=string.lower(v.Name)
                for _,k in ipairs(names) do
                    if string.find(n,k,1,true) then
                        table.insert(ST._stamVals,{v=v,bool=v:IsA("BoolValue")})
                        return
                    end
                end
            end
            for _,d in pairs(ch:GetDescendants()) do consider(d) end
            local pg=LP:FindFirstChild("PlayerGui")
            if pg then
                for _,d in pairs(pg:GetDescendants()) do consider(d) end
            end
            local function considerAttr(obj)
                if not obj or not obj.GetAttributes then return end
                for k,val in pairs(obj:GetAttributes()) do
                    if type(val)=="number" then
                        local n=string.lower(tostring(k))
                        for _,sn in ipairs(names) do
                            if string.find(n,sn,1,true) then table.insert(ST._stamVals,{attr=obj,key=k}) return end
                        end
                    end
                end
            end
            considerAttr(ch) considerAttr(hum) considerAttr(LP)
        end
        local vals=ST._stamVals
        if not vals then return end
        local found=0
        for i=1,#vals do
            local e=vals[i]
            if e.attr then
                local maxv=e.attr:GetAttribute(e.key)
                if type(maxv)=="number" and maxv>0 and maxv<1e12 then
                    local want=math.max(maxv,100)
                    if want~=maxv then e.attr:SetAttribute(e.key,want) end
                    found=found+1
                end
            elseif e.v and e.v.Parent then
                if e.bool then
                    if e.v.Value==false then e.v.Value=true end
                    found=found+1
                else
                    local cur=e.v.Value
                    if type(cur)=="number" and cur<100 then e.v.Value=100 end
                    found=found+1
                end
            end
        end
        if found==0 and not ST._stamWarned then
            ST._stamWarned=true
            ntf("Stamina","No stamina values found (scan 5s)",5)
        end
    end)
    pcall(function()
        if ST.autoSteal and tick()-(ST._stealT or 0)>0.6 then
            ST._stealT=tick()
            doGreenSteal()
        end
    end)
    pcall(function()
        if ST.freeCam then return end
        local wantSp=ST.speedPreset or 0
        if ST.speedHard and wantSp<50 then wantSp=50 end
        if wantSp>80 then wantSp=80 end
        local wantJp=ST.jumpPreset or 0
        if wantJp>200 then wantJp=200 end
        if wantSp<=0 and wantJp<=0 then return end
        local now=tick()
        if now-(ST._spApplyT or 0)<0.35 then return end
        ST._spApplyT=now
        local ch=LP.Character
        if not ch then return end
        local hum=ch:FindFirstChildOfClass("Humanoid")
        if not hum or not hum.Parent or hum.Health<=0 or hum.Seated or hum.PlatformStand then return end
        if wantSp>0 and hum.WalkSpeed~=wantSp then
            pcall(function() hum.WalkSpeed=wantSp end)
        end
        if wantJp>0 then
            pcall(function()
                if hum.UseJumpPower then
                    if hum.JumpPower~=wantJp then hum.JumpPower=wantJp end
                else
                    local jh=math.max(5,math.floor(wantJp*0.14+0.5))
                    if hum.JumpHeight~=jh then hum.JumpHeight=jh end
                end
            end)
        end
    end)
    pcall(function()
        if ST.noclip and LP.Character then for _,p2 in pairs(LP.Character:GetDescendants()) do if p2:IsA("BasePart") then if ST.savedCollide[p2]==nil then ST.savedCollide[p2]=p2.CanCollide end p2.CanCollide=false end end end
    end)
    pcall(function()
        if ST.vehicleSpeedOn and LP.Character then
            local hum=LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Seated and hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
                local seat=hum.SeatPart
                if not ST._vehOrig then ST._vehOrig={} end
                if ST._vehOrig[seat]==nil and seat.MaxSpeed>0 then
                    ST._vehOrig[seat]=seat.MaxSpeed
                end
                local target=math.max(ST._vehOrig[seat] or 30, ST.vehBoost or 80)
                if seat.MaxSpeed~=target then
                    seat.MaxSpeed=target
                end
            end
        end
    end)
    pcall(function()
        if ST.spinner and LP.Character then local hrp=LP.Character:FindFirstChild("HumanoidRootPart") if hrp then local sv=hrp:FindFirstChild("AxSpin") if not sv then sv=Instance.new("BodyAngularVelocity") sv.Name="AxSpin" sv.AngularVelocity=Vector3.new(0,ST.spinnerSpeed,0) sv.MaxTorque=Vector3.new(0,math.huge,0) sv.P=10000 sv.Parent=hrp end sv.AngularVelocity=Vector3.new(0,ST.spinnerSpeed,0) sv.MaxTorque=Vector3.new(0,math.huge,0) end end
    end)
    pcall(function() if ST.autoClicker then mouse1click() end end)
    pcall(function() if ST.night then L.ClockTime=0 L.Brightness=0 end end)
    pcall(function() if ST.bright then L.Brightness=2 L.GlobalShadows=false L.Ambient=Color3.fromRGB(178,178,178) L.OutdoorAmbient=Color3.fromRGB(178,178,178) end end)
    pcall(function() if ST.noFog then L.FogEnd=999999 L.FogStart=0 local atm=L:FindFirstChildOfClass("Atmosphere") if atm then atm.Density=0 end end end)
    pcall(function()
        if ST.maceTP and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then local myRoot=LP.Character.HumanoidRootPart local nearestDist=math.huge local nearestRoot=nil for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and pp.Character:FindFirstChild("HumanoidRootPart") and pp.Character:FindFirstChildOfClass("Humanoid") then local hum2=pp.Character:FindFirstChildOfClass("Humanoid") if hum2.Health>0 then local d=(myRoot.Position-pp.Character.HumanoidRootPart.Position).Magnitude if d<nearestDist then nearestDist=d nearestRoot=pp.Character.HumanoidRootPart end end end end if nearestRoot then local off=ST.maceTPOffset or 3 myRoot.CFrame=nearestRoot.CFrame*CFrame.new(0,0,off) end end
    end)
    pcall(function()
        if ST.botRecord and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then table.insert(ST.botFrames,{t=tick()-ST.botStart,cf=LP.Character.HumanoidRootPart.CFrame:clone()}) end
        if ST.botPlay and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then if #ST.botFrames>0 then local elapsed=tick()-ST.botStart local idx=1 for i=1,#ST.botFrames do if ST.botFrames[i].t<=elapsed then idx=i else break end end if idx>#ST.botFrames then if ST.botLoop then ST.botStart=tick() idx=1 else ST.botPlay=false ntf("Bot","Playback finished!") end end if ST.botPlay and ST.botFrames[idx] then LP.Character.HumanoidRootPart.CFrame=ST.botFrames[idx].cf end end end
    end)
    pcall(function()
        local aimActive=isAimActive()
        local wantFOV=aimActive or ST.showFOV
        if wantFOV then
            if not ST.aimFOVGui then
                local s=Instance.new("ScreenGui") s.Name="AimFOV" s.ResetOnSpawn=false s.DisplayOrder=50 s.IgnoreGuiInset=true
                pcall(function() s.Parent=CG end) if not s.Parent then s.Parent=LP:WaitForChild("PlayerGui") end
                local c=Instance.new("Frame") c.Name="Circle" c.AnchorPoint=Vector2.new(0.5,0.5)
                c.Position=UDim2.new(0.5,0,0.5,0)
                c.Size=UDim2.new(0,ST.aimFOV*2,0,ST.aimFOV*2)
                c.BackgroundTransparency=1 c.BorderSizePixel=0 c.Parent=s
                local st=Instance.new("UIStroke") st.Color=Color3.fromRGB(255,80,80) st.Thickness=1.5 st.Transparency=0.3 st.Parent=c
                local cr=Instance.new("UICorner") cr.CornerRadius=UDim.new(1,0) cr.Parent=c
                ST.aimFOVGui=s
            end
            local circ=ST.aimFOVGui:FindFirstChild("Circle")
            if circ then
                circ.Size=UDim2.new(0,ST.aimFOV*2,0,ST.aimFOV*2)
                local mp=U:GetMouseLocation()
                circ.Position=UDim2.new(0,mp.X,0,mp.Y)
            end
        elseif ST.aimFOVGui then
            ST.aimFOVGui:Destroy()
            ST.aimFOVGui=nil
        end
        if not aimActive then
            ST.aimTarget=nil
            ST._aimWallC=nil
            local myHum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if myHum and not myHum.AutoRotate then myHum.AutoRotate=true end
            if not ST.freeCam and not ST.spectateOverhead then
                local cam=W.CurrentCamera or CAM
                if cam and cam.CameraType==Enum.CameraType.Scriptable and not ST._aimWasScriptable then
                    cam.CameraType=Enum.CameraType.Custom
                    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                    if hum then cam.CameraSubject=hum end
                end
            end
        end
    end)
    pcall(function() if ST.cursorTPPreview then if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then local m=MS.Hit if m then ST.cursorTPPreview.Position=m.Position+Vector3.new(0,3,0) end end end end)
    pcall(function()
        if ST.esp and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local myPos=LP.Character.HumanoidRootPart.Position
            for _,pp in pairs(P:GetPlayers()) do
                if pp~=LP and pp.Character and pp.Character:FindFirstChild("HumanoidRootPart") and pp.Character:FindFirstChildOfClass("Humanoid") then
                    local hrp=pp.Character.HumanoidRootPart
                    local hum=pp.Character:FindFirstChildOfClass("Humanoid")
                    local dist=(myPos-hrp.Position).Magnitude
                    if dist>CFG.ESPMaxDist then
                        local bb2=pp.Character:FindFirstChild("AxESP_BB")
                        if bb2 then bb2:Destroy() end
                        if ST.esp2D then local box2=ST.esp2D[pp.UserId] if box2 then pcall(function() box2:Destroy() end) ST.esp2D[pp.UserId]=nil end end
                        continue
                    end
                    local head=pp.Character:FindFirstChild("Head")
                    local headY=head and head.Position.Y+3 or hrp.Position.Y+3
                    ST.esp2D=ST.esp2D or {}
                    if CFG.ESP2D then
                        local topPos,onTop=CAM:WorldToViewportPoint(Vector3.new(hrp.Position.X,headY,hrp.Position.Z))
                        local botPos,onBot=CAM:WorldToViewportPoint(hrp.Position-Vector3.new(0,3,0))
                        local esp2d=ST.esp2D[pp.UserId]
                        if not esp2d or not esp2d.Parent then esp2d=Instance.new("Frame") esp2d.Name="AxESP_2D" esp2d.AnchorPoint=Vector2.new(0.5,0.5) esp2d.BorderSizePixel=0 esp2d.Parent=SG ST.esp2D[pp.UserId]=esp2d end
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
                        if ST.esp2D then local old2d=ST.esp2D[pp.UserId] if old2d then pcall(function() old2d:Destroy() end) ST.esp2D[pp.UserId]=nil end end
                    end
                    local bb=pp.Character:FindFirstChild("AxESP_BB")
                    if not bb then
                        bb=Instance.new("BillboardGui") bb.Name="AxESP_BB" bb.Size=UDim2.new(0,150,0,54) bb.StudsOffset=Vector3.new(0,3,0) bb.AlwaysOnTop=true bb.LightInfluence=0 bb.Parent=pp.Character
                        local nL=Instance.new("TextLabel") nL.Name="NL" nL.Size=UDim2.new(1,0,0.35,0) nL.Position=UDim2.new(0,0,0,0) nL.BackgroundTransparency=1 nL.TextColor3=CFG.ESPTextColor nL.TextStrokeTransparency=0.5 nL.TextStrokeColor3=Color3.new(0,0,0) nL.TextSize=12 nL.Font=Enum.Font.GothamBold nL.Parent=bb
                        local hB=Instance.new("Frame") hB.Name="HB" hB.Size=UDim2.new(0.8,0,0.12,0) hB.Position=UDim2.new(0.1,0,0.38,0) hB.BackgroundColor3=Color3.new(0.2,0.2,0.2) hB.BorderSizePixel=0 hB.Parent=bb
                        local hF=Instance.new("Frame") hF.Name="HF" hF.Size=UDim2.new(1,0,1,0) hF.BackgroundColor3=TH.g hF.BorderSizePixel=0 hF.Parent=hB
                        local dL=Instance.new("TextLabel") dL.Name="DL" dL.Size=UDim2.new(1,0,0.35,0) dL.Position=UDim2.new(0,0,0.55,0) dL.BackgroundTransparency=1 dL.TextColor3=CFG.ESPTextColor dL.TextStrokeTransparency=0.5 dL.TextStrokeColor3=Color3.new(0,0,0) dL.TextSize=14 dL.Font=Enum.Font.GothamBold dL.Parent=bb
                    end
                    local nL=bb:FindFirstChild("NL")
                    local hB=bb:FindFirstChild("HB")
                    local hF=hB and hB:FindFirstChild("HF")
                    local dL=bb:FindFirstChild("DL")
                    if nL then
                        local txt=""
                        if CFG.ESPShowName then txt=txt..pp.DisplayName end
                        nL.Text=txt
                        nL.TextColor3=CFG.ESPTextColor
                        nL.Visible=CFG.ESPShowName
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
                        local distTxt=math.floor(dist).."m"
                        if CFG.ESPShowHealth then distTxt=distTxt.."  ["..math.floor(hum.Health).."]" end
                        dL.Visible=CFG.ESPShowDistance or CFG.ESPShowHealth
                        dL.Text=distTxt
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
    end)
    pcall(function()
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
    end)
    pcall(function()
        if ST.esp2D then for uid,fr in pairs(ST.esp2D) do local pp=P:GetPlayerByUserId(uid) if not pp or not pp.Character then if fr then pcall(function() fr:Destroy() end) end ST.esp2D[uid]=nil end end end
    end)
    pcall(function()
        if ST.arrayList then
            if not _G.AxArrayList then local sg=Instance.new("ScreenGui") sg.Name="AxArrayList" sg.ResetOnSpawn=false sg.DisplayOrder=999 sg.IgnoreGuiInset=true pcall(function() sg.Parent=CG end) if not sg.Parent then sg.Parent=LP:WaitForChild("PlayerGui") end _G.AxArrayList=sg local f=Instance.new("Frame") f.Name="Container" f.Size=UDim2.new(0,180,0,20) f.Position=UDim2.new(1,-190,1,-30) f.BackgroundTransparency=1 f.Parent=sg local l=Instance.new("UIListLayout",f) l.SortOrder=Enum.SortOrder.LayoutOrder l.HorizontalAlignment=Enum.HorizontalAlignment.Right end
            local c=_G.AxArrayList:FindFirstChild("Container") if c then for _,ch in pairs(c:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end local entries={} local function addE(name) table.insert(entries,name) end if ST.fly then addE("Fly") end if ST.noclip then addE("Noclip") end if ST.esp then addE("ESP") end if ST.infJump then addE("InfJump") end if ST.spinner then addE("Spinner") end if ST.autoClicker then addE("AutoClick") end if ST.godmodeLoop then addE("Godmode") end if ST.spheresOn then addE("Spheres") end if ST.autoSteal then addE("AutoSteal") end if ST.speedHard then addE("SpeedHard") end if ST.infStamina then addE("InfStam") end if ST.magicBullet then addE("MagicBul") end if ST.weaponDmgOn then addE("WpnDmg") end if ST.maceTP then addE("MaceTP") end if ST.freeCam then addE("FreeCam") end if ST.clickTP then addE("ClickTP") end if ST.bright then addE("Fullbright") end if ST.night then addE("Night") end if ST.noFog then addE("NoFog") end if ST.vehicleSpeedOn then addE("VehicleSpeed") end if ST.botPlay then addE("BotPlay") end if ST.botRecord then addE("BotRec") end for i,name in pairs(entries) do local ef=Instance.new("Frame") ef.Size=UDim2.new(0,160,0,22) ef.BackgroundColor3=Color3.fromRGB(0,0,0) ef.BackgroundTransparency=0.4 ef.BorderSizePixel=0 ef.LayoutOrder=i ef.Parent=c mkCorner(ef,4) local et=Instance.new("TextLabel") et.Size=UDim2.new(1,-8,1,0) et.Position=UDim2.new(0,4,0,0) et.BackgroundTransparency=1 et.Text=name et.TextColor3=TH.a et.TextSize=12 et.Font=Enum.Font.GothamBold et.TextXAlignment=Enum.TextXAlignment.Right et.Parent=ef end end
        elseif _G.AxArrayList then _G.AxArrayList:Destroy() _G.AxArrayList=nil end
    end)
end)
pcall(function() P.PlayerAdded:Connect(function(pp) pp.CharacterAdded:Connect(function(ch) task.wait(1) pcall(function() if ST.esp and pp~=LP then local hl=Instance.new("Highlight") hl.Name="AxESP" hl.FillColor=CFG.ESPColor hl.FillTransparency=CFG.ESPFillAlpha hl.OutlineColor=Color3.new(1,1,1) hl.OutlineTransparency=0 hl.Parent=ch ST.espList[pp.UserId]=hl end end) end) end) end)
pcall(function() LP.CharacterAdded:Connect(function(ch) task.wait(1) ST.savedCollide={} pcall(function() if ST.spinner then task.delay(0.5,function() if ch and LP.Character==ch then local hrp=ch:FindFirstChild("HumanoidRootPart") if hrp then local sv=Instance.new("BodyAngularVelocity") sv.Name="AxSpin" sv.AngularVelocity=Vector3.new(0,ST.spinnerSpeed,0) sv.MaxTorque=Vector3.new(0,math.huge,0) sv.P=10000 sv.Parent=hrp end end end) end end) pcall(function() if ST.speedHard then task.delay(0.5,function() local hum=ch:FindFirstChildOfClass("Humanoid") if hum then hum.WalkSpeed=math.max(ST.speedPreset or 0,50) end end) end end) pcall(function() if ST.godmodeLoop then ST._srvGod=false task.delay(0.5,function() local hum=ch:FindFirstChildOfClass("Humanoid") if hum then if hum.MaxHealth<100 then hum.MaxHealth=100 end hum.Health=hum.MaxHealth pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) syncServerGod() end end) end end) pcall(function() if ST.freeCam then task.delay(0.8,function() if not ST.freeCam then return end local hrp=ch:FindFirstChild("HumanoidRootPart") local hum=ch:FindFirstChildOfClass("Humanoid") if hrp then hrp.Anchored=true hrp.Velocity=Vector3.new(0,0,0) hrp.RotVelocity=Vector3.new(0,0,0) end if hum then hum.WalkSpeed=0 hum.AutoRotate=false end end) end end) end) end)
P.PlayerRemoving:Connect(function(pp) if ST.espList[pp.UserId] then ST.espList[pp.UserId]:Destroy() ST.espList[pp.UserId]=nil end if ST.esp2D and ST.esp2D[pp.UserId] then pcall(function() ST.esp2D[pp.UserId]:Destroy() end) ST.esp2D[pp.UserId]=nil end end)
for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and pp.Character:FindFirstChild("AxESP_BB") then pp.Character.AxESP_BB:Destroy() end end
pcall(function() for _,g in pairs({CG,LP:WaitForChild("PlayerGui")}) do for _,v in pairs(g:GetDescendants()) do if v.Name=="AxESP_2D" then v:Destroy() end end end end)
print("[Axynth] MENU LOADED! Press RightShift!")
end)
if not ok then print("[Axynth] ERROR: "..tostring(err)) end
