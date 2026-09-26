print("[Axynth] Loading... build=fx30")
local ok, err = pcall(function()
P = game:GetService("Players")
U = game:GetService("UserInputService")
R = game:GetService("RunService")
L = game:GetService("Lighting")
S = game:GetService("StarterGui")
RS = game:GetService("ReplicatedStorage")
CG = game:GetService("CoreGui")
TW = game:GetService("TweenService")
W = game:GetService("Workspace")
LP = P.LocalPlayer
MS = LP:GetMouse()
CAM = W.CurrentCamera
print("[Axynth] Services OK")
local ST={}
local HOOK_OK,HOOK_ERR,HOOK_PATH,HOOK_APIS
local findRemote
local freezeLocalForCam
local unfreezeLocalFromCam
local restoreLocalCamera
local ensureCamInputConns
local keyHeld
local ovhPrevM
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
    ["WeaponsSystem.Network.WeaponActivated"]=true,
    ["SupermarketEvent.Triggered"]=true,
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
function axSpyHUD()
    if HOOK_OK==false then
        local pf=ST._spyPTL
        if pf and pf.Parent then
            pf.TextSize=10
            local disp=string.gsub(tostring(HOOK_ERR or "?"),"^.-loadstring[:%.][%d]+[:%.]%d+:%s*","")
            pf.Text="HOOK FAILED: "..string.sub(disp,1,64)
            pf.TextColor3=Color3.fromRGB(255,80,80)
        end
        return
    end
    if not ST.remoteSpyOn then return end
    local now=tick()
    if now-(ST._spyHUDT or 0)<0.4 then return end
    ST._spyHUDT=now
    local p=ST._spyPTL
    if p and p.Parent then
        local e=ST._ncErr or 0
        p.TextSize=10
        p.Text="any:"..(ST._ncAny or 0).." nc:"..(ST._ncAll or 0).." blk:"..(ST._ncBlk or 0).." log:"..(ST._ncLog or 0)..(e>0 and (" err:"..e) or "")
    end
end
local function xnapi(n)
    local v=_G[n]
    if v~=nil then return v end
    if type(getgenv)=="function" then
        local okg,g=pcall(getgenv)
        if okg and type(g)=="table" and g[n]~=nil then return g[n] end
    end
    if type(getfenv)=="function" then
        local oke,e0=pcall(getfenv,0)
        if oke and type(e0)=="table" and e0[n]~=nil then return e0[n] end
    end
    return nil
end
local XM=xnapi("hookmetamethod") or xnapi("hook_metamethod")
local XC=xnapi("newcclosure") or xnapi("new_cclosure")
local XG=xnapi("getrawmetatable") or xnapi("get_raw_metatable")
local XS=xnapi("setreadonly") or xnapi("set_readonly")
local XN=xnapi("getnamecallmethod") or xnapi("get_namecall_method")
local XCHK=xnapi("checkcaller")
local XHF=xnapi("hookfunction") or xnapi("hook_function")
pcall(function()
    local rep={}
    for _,n in ipairs({"hookmetamethod","newcclosure","getrawmetatable","setreadonly","getnamecallmethod","hookfunction","checkcaller","getgenv","getgc","getreg","getinstances","getnilinstances","getconnections","getloadedmodules","getrenv","getsenv","gethui","protectgui","queue_on_teleport","firesignal","setclipboard","islclosure","iscclosure","getcallbackvalue","gethui"}) do
        rep[#rep+1]=n.."="..type(xnapi(n))
    end
    HOOK_APIS=table.concat(rep," ")
    local okE,ET=pcall(getgenv)
    if okE and type(ET)=="table" then
        local ks={}
        for k in pairs(ET) do if type(k)=="string" then ks[#ks+1]=k end end
        table.sort(ks)
        HOOK_APIS=HOOK_APIS.." | genv["..string.sub(table.concat(ks,","),1,400).."]"
    end
    local XT=xnapi("Xeno")
    if type(XT)=="table" then
        local ks={}
        for k in pairs(XT) do ks[#ks+1]=tostring(k) end
        table.sort(ks)
        HOOK_APIS=HOOK_APIS.." | Xeno["..string.sub(table.concat(ks,","),1,400).."]"
    end
    print("[Axynth][Hook] resolved: hookmetamethod="..type(XM).." newcclosure="..type(XC).." getrawmetatable="..type(XG).." setreadonly="..type(XS).." getnamecallmethod="..type(XN).." checkcaller="..type(XCHK))
    print("[Axynth][Hook] avail "..HOOK_APIS)
    local okm,gm=pcall(getmetatable,game)
    local gms=okm and (type(gm)..":"..string.sub(tostring(gm),1,60)) or ("err:"..string.sub(tostring(gm),1,60))
    local dbgm=(type(debug)=="table") and type(debug.getmetatable) or "no-debug"
    local hfs="no-hookfunction"
    if type(XHF)=="function" then
        local okh,hinfo=pcall(function()
            local a=function() return 1 end
            local b=function() return 2 end
            local r=XHF(a,b)
            local oka,ra=pcall(a)
            return "ret="..type(r).."/same="..tostring(r==b).."/aCall="..(oka and tostring(ra) or "err")
        end)
        if okh then hfs=hinfo else hfs="probe-err:"..string.sub(tostring(hinfo),1,60) end
    end
    local hits={}
    local function scanKeys(t,tag)
        if type(t)~="table" then return end
        for k in pairs(t) do
            if type(k)=="string" then
                local lk=string.lower(k)
                if string.find(lk,"hook",1,true) or string.find(lk,"meta",1,true) or string.find(lk,"namecall",1,true) then
                    hits[#hits+1]=tag..k
                end
            end
        end
    end
    scanKeys(_G,"")
    if type(getgenv)=="function" then local o,e=pcall(getgenv) if o then scanKeys(e,"genv:") end end
    if type(getfenv)=="function" then local o,e=pcall(getfenv,0) if o then scanKeys(e,"fenv:") end end
    scanKeys(xnapi("Xeno"),"Xeno:")
    print("[Axynth][Hook] probe gm="..gms.." debugGM="..tostring(dbgm).." hf="..hfs)
    print("[Axynth][Hook] hookish: "..(next(hits) and table.concat(hits,",") or "none"))
    local XTK=xnapi("Xeno")
    if type(XTK)=="table" then
        local ks={}
        for k in pairs(XTK) do ks[#ks+1]=tostring(k) end
        table.sort(ks)
        print("[Axynth][Hook] Xeno keys: "..string.sub(table.concat(ks,","),1,500))
    end
end)
local path4FS=false
local hkOk,hkErr=pcall(function()
    local oldNC
    local hookBody=function(method,orig,self,...)
        local args = {...}
        ST._ncAny=(ST._ncAny or 0)+1
        if axSpyHUD then pcall(axSpyHUD) end
        if method=="" and typeof(self)=="Instance" then
            if self:IsA("Workspace") or self:IsA("BasePart") then method="Raycast"
            elseif self:IsA("RemoteEvent") or self:IsA("UnreliableRemoteEvent") then method="FireServer"
            elseif self:IsA("RemoteFunction") then method="InvokeServer" end
        end
        local ok, res = pcall(function()
            if method=="Raycast" and ST.magicBullet and not (type(XCHK)=="function" and XCHK() or false) then
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
                        return orig(self,rcp,dir,newParams)
                    end
                end
            end
            if (method=="FireServer" or method=="InvokeServer") and typeof(self)=="Instance" and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction") or self:IsA("UnreliableRemoteEvent")) then
                ST._ncAll=(ST._ncAll or 0)+1
                if ST._forceFire then
                    ST._ncFF=(ST._ncFF or 0)+1
                    if axSpyHUD then pcall(axSpyHUD) end
                    return "PASS"
                end
                pcall(function()
                    local fn=self:GetFullName()
                    local fl=string.lower(fn)
                    if string.find(fl,"inventory",1,true) or string.find(fl,"armory",1,true) or string.find(fl,"supermarket",1,true) or string.find(fl,"jobcenter",1,true) or string.find(fl,"changejob",1,true) or string.find(fl,"changeteam",1,true) or string.find(fl,"weaponhit",1,true) or string.find(fl,"weaponfired",1,true) or string.find(fl,"damage",1,true) or string.find(fl,"hurt",1,true) or string.find(fl,"cardealer",1,true) or string.find(fl,"vehicle",1,true) or string.find(fl,"spawncar",1,true) or string.find(fl,"shop",1,true) or string.find(fl,"store",1,true) or string.find(fl,"garage",1,true) or string.find(fl,"dealership",1,true) or string.find(fl,"cars",1,true) or string.find(fl,"job",1,true) or string.find(fl,"career",1,true) then
                        local verb=""
                        for i=1,#args do
                            local a=args[i]
                            if typeof(a)=="string" and #a<=14 and not string.find(a," ",1,true) then verb=string.lower(a) break end
                        end
                        local arr=ST._learnLog and ST._learnLog[fn]
                        if not arr then
                            ST._learnLog=ST._learnLog or {}
                            arr={} ST._learnLog[fn]=arr
                        end
                        local copyargs={}
                        for i=1,#args do
                            local a=args[i]
                            if typeof(a)=="table" then
                                local c={} for k,v in pairs(a) do c[k]=v end copyargs[i]=c
                            else copyargs[i]=a end
                        end
                        if axSerStr and tick()-(ST._capSerT or 0)>0.3 then
                            ST._capSerT=tick()
                            local line=fn.." | "..axSerStr(copyargs)
                            if not ST._capLast or ST._capLast~=line then
                                ST._capLast=line
                                ST._capLines=ST._capLines or {}
                                table.insert(ST._capLines,1,string.sub(line,1,2000))
                                while #ST._capLines>40 do table.remove(ST._capLines) end
                            end
                        end
                        local fresh=true
                        for _,rec in ipairs(arr) do
                            if rec.sig==verb then
                                rec.t=tick()
                                rec.inst=self
                                rec.args=copyargs
                                rec.path=fn
                                fresh=false
                                break
                            end
                        end
                        if fresh then
                            table.insert(arr,1,{sig=verb,t=tick(),inst=self,args=copyargs,path=fn})
                            while #arr>6 do table.remove(arr) end
                            ST._lsForce=true
                        end
                        if axSaveLearn then pcall(axSaveLearn) end
                        if not ST._learnNtf and (string.find(fl,"inventory",1,true) or string.find(fl,"shop",1,true)) then
                            ST._learnNtf=true
                            ST._learnPending=true
                        end
                        if not ST._learnCT and (string.find(fl,"weaponhit",1,true) or string.find(fl,"weaponfired",1,true) or string.find(fl,"damage",1,true) or string.find(fl,"hurt",1,true)) then
                            ST._learnCT=true
                            ST._learnCPend=true
                        end
                        if not ST._learnVT and (string.find(fl,"cardealer",1,true) or string.find(fl,"spawncar",1,true)) then
                            ST._learnVT=true
                            ST._learnVPend=true
                        end
                    end
                end)
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
                    if _G._spyAdd then _G._spyAdd(self.Name,argsStr,"F") ST._ncLog=(ST._ncLog or 0)+1 end
                    if axSpyHUD then pcall(axSpyHUD) end
                end
                if isBlocked(self.Name) and not isWhitelisted(self.Name) then
                    ST._ncBlk=(ST._ncBlk or 0)+1
                    if axSpyHUD then pcall(axSpyHUD) end
                    table.insert(hookLog,{time=tick(),remote=self.Name,blocked=true})
                    return "BLOCK"
                end
                if isUsingExploit and not isWhitelisted(self.Name) then
                    ST._ncExp=(ST._ncExp or 0)+1
                    if axSpyHUD then pcall(axSpyHUD) end
                    task.delay(randomDelay(),function()
                        pcall(function() orig(self,unpack(args)) end)
                    end)
                    return "BLOCK"
                end
            end
            return "PASS"
        end)
        if not ok then ST._ncErr=(ST._ncErr or 0)+1 if not ST._ncErrP then ST._ncErrP=true pcall(function() print("[Axynth][NC] hook error: "..tostring(res)) end) end if axSpyHUD then pcall(axSpyHUD) end return orig(self,unpack(args)) end
        if res=="BLOCK" then return nil end
        if res=="PASS" then return orig(self,unpack(args)) end
        return res
    end
    local hookFn=function(self,...)
        return hookBody((type(XN)=="function") and XN() or "", oldNC, self, ...)
    end
    local p1ok,p1err=pcall(function()
        if type(XM)~="function" then error("hookmetamethod is "..type(XM),0) end
        local h=hookFn
        if type(XC)=="function" then h=XC(hookFn) end
        local r=XM(game,"__namecall",h)
        if type(r)~="function" then error("hookmetamethod returned "..type(r),0) end
        oldNC=r
    end)
    if p1ok then
        HOOK_PATH=(type(XC)=="function") and "hookmetamethod+cclosure" or "hookmetamethod+lclosure"
    else
        local pHIok,pHIerr=false,"hookinstance not run"
        local pHIdone=false
        task.spawn(function()
            pHIok,pHIerr=pcall(function()
                local HI=xnapi("hookinstance") or xnapi("hook_instance")
                if type(HI)~="function" then error("hookinstance is "..type(HI),0) end
                ST._hiShape=nil
                local dA=Instance.new("RemoteEvent")
                local origA=dA.FireServer
                if type(origA)~="function" then error("FireServer is "..type(origA),0) end
                local function mkCb(method,orig)
                    local w=function(self,...)
                        if ST._hiShape==nil then
                            local a2=select(1,...)
                            ST._hiShape=typeof(self).."/"..typeof(a2)
                        end
                        return hookBody(method,orig,self,...)
                    end
                    if type(XC)=="function" then
                        local o,r=pcall(XC,w)
                        if o and type(r)=="function" then return r end
                    end
                    return w
                end
                local cbA=mkCb("FireServer",origA)
                local tries={}
                local hookedF={}
                local function run(tag,...)
                    local okR,ret=pcall(HI,...)
                    if not okR then
                        tries[#tries+1]=tag.."!:"..string.sub(tostring(ret),1,220)
                        return false
                    end
                    ST._hiShape=nil
                    local ferr=nil
                    local okF,errF=pcall(function() dA:FireServer("axprobe") end)
                    if not okF then ferr=tostring(errF) end
                    if ST._hiShape~=nil then
                        if ferr==nil then
                            tries[#tries+1]=tag.." OK shape="..tostring(ST._hiShape)
                            return true
                        end
                        tries[#tries+1]=tag.." hit+ERR shape="..tostring(ST._hiShape).." e="..string.sub(ferr,1,40)
                        return false
                    end
                    tries[#tries+1]=tag..": ret="..type(ret)..",no-hit"
                    return false
                end
                local winForm=nil
                if run("A2",dA,cbA) then winForm="A2" end
                if not winForm and run("B3",dA,"FireServer",cbA) then winForm="B3" end
                if not winForm and run("Cfn",origA,cbA) then
                    winForm="Cfn"
                    hookedF[origA]=true
                end
                if not winForm and run("Dtb",dA,{cbA}) then winForm="Dtb" end
                if not winForm then
                    local addrT=nil
                    local gi=xnapi("getinstanceaddress")
                    if type(gi)=="function" then
                        local oT,rT=pcall(gi,dA)
                        if oT then addrT=rT end
                    end
                    tries[#tries+1]="addr="..type(addrT)
                    if addrT~=nil and run("Ead",dA,addrT) then winForm="Ead" end
                    if not winForm and run("E0",dA,0) then winForm="E0" end
                    if not winForm and run("Enl",dA,nil) then winForm="Enl" end
                end
                if not winForm then error("f2:"..table.concat(tries," | "),0) end
                if string.sub(tostring(ST._hiShape),1,8)~="Instance" then
                    error("f2:shape="..tostring(ST._hiShape).." "..table.concat(tries," | "),0)
                end
                local function apply(tag,target,method,fn,cb)
                    local okH=false
                    if tag=="A2" then okH=pcall(HI,target,cb)
                    elseif tag=="B3" then okH=pcall(HI,target,method,cb)
                    elseif tag=="Cfn" then
                        if hookedF[fn] then return true end
                        hookedF[fn]=true
                        okH=pcall(HI,fn,cb)
                    elseif tag=="Dtb" then okH=pcall(HI,target,{cb})
                    end
                    return okH
                end
                local dB=Instance.new("RemoteEvent")
                local origB=dB.FireServer
                local cbB=mkCb("FireServer",origB)
                apply(winForm,dB,"FireServer",origB,cbB)
                local v1=ST._ncAny or 0
                pcall(function() dB:FireServer("axprobe") end)
                if (ST._ncAny or 0)>v1 then
                    local parts={winForm..":FireServer"}
                    local dF=Instance.new("RemoteFunction")
                    local origF=dF.InvokeServer
                    if type(origF)=="function" then
                        local cbF=mkCb("InvokeServer",origF)
                        if apply(winForm,dF,"InvokeServer",origF,cbF) then parts[#parts+1]="InvokeServer" end
                    end
                    local dU=Instance.new("UnreliableRemoteEvent")
                    local origU=dU.FireServer
                    if type(origU)=="function" then
                        local cbU=mkCb("FireServer",origU)
                        if apply(winForm,dU,"FireServer",origU,cbU) then parts[#parts+1]="UnreliableRE" end
                    end
                    HOOK_PATH="hookinstance["..table.concat(parts,",").."]"
                    return
                end
                local got=xnapi("getinstances")
                local n=0
                if type(got)=="function" then
                    local okL,insts=pcall(got)
                    if okL and type(insts)=="table" then
                        for _,inst in ipairs(insts) do
                            if n>=600 then break end
                            if typeof(inst)=="Instance" then
                                local cn=inst.ClassName
                                if cn=="RemoteEvent" or cn=="UnreliableRemoteEvent" or cn=="RemoteFunction" then
                                    local m=(cn=="RemoteFunction") and "InvokeServer" or "FireServer"
                                    local fn=inst[m]
                                    if type(fn)=="function" then
                                        local cb=mkCb(m,fn)
                                        if apply(winForm,inst,m,fn,cb) then n=n+1 end
                                    end
                                end
                            end
                        end
                    end
                end
                if n>0 then
                    HOOK_PATH="hookinstance[instance x"..n.."]"
                    return
                end
                error("f2:"..table.concat(tries," | ").."; class=no inst=0",0)
            end)
            pHIdone=true
        end)
        for i=1,30 do
            if pHIdone then break end
            task.wait(0.1)
        end
        if pHIok then
            if type(HOOK_PATH)~="string" then HOOK_PATH="hookinstance" end
        else
        local p2ok,p2err=pcall(function()
            if type(XG)~="function" then error("getrawmetatable is "..type(XG),0) end
            local mt=XG(game)
            if type(mt)~="table" then error("getrawmetatable(game) is "..type(mt),0) end
            if type(XS)=="function" then pcall(XS,mt,false) end
            oldNC=mt.__namecall
            if type(oldNC)~="function" then error("__namecall is "..type(oldNC),0) end
            local h=hookFn
            if type(XC)=="function" then h=XC(hookFn) end
            mt.__namecall=h
            if type(XS)=="function" then pcall(XS,mt,true) end
        end)
        if p2ok then
            HOOK_PATH="rawmetatable (after p1: "..string.sub(tostring(p1err),1,48)..")"
        else
            local p3ok,p3err=pcall(function()
                local mt=getmetatable(game)
                if type(mt)~="table" then error("getmetatable(game) is "..type(mt),0) end
                local ro=type(XS)=="function"
                if ro then local o=pcall(XS,mt,false) if not o then ro=false end end
                oldNC=mt.__namecall
                if type(oldNC)~="function" then error("__namecall is "..type(oldNC),0) end
                local h=hookFn
                if type(XC)=="function" then h=XC(hookFn) end
                mt.__namecall=h
                if ro then pcall(XS,mt,true) end
            end)
            if p3ok then
                HOOK_PATH="getmetatable (after p2: "..string.sub(tostring(p2err),1,48)..")"
            else
                if type(XHF)~="function" then error("path3 failed ("..string.sub(tostring(p3err),1,48).."); hookfunction is "..type(XHF),0) end
                local done,errs={},{}
                local function tryM(mname,cls)
                    local fn
                    if cls=="Workspace" then fn=workspace.Raycast
                    else
                        local inst0=Instance.new(cls)
                        fn=inst0[mname]
                    end
                    if type(fn)~="function" then error(mname.." is "..type(fn),0) end
                    local box={orig=fn,probing=false,hit=false}
                    local wrapper=function(self,...)
                        if box.probing then box.hit=true end
                        return hookBody(mname,box.orig,self,...)
                    end
                    local cands={}
                    if type(XC)=="function" then
                        local okc,rc=pcall(XC,wrapper)
                        if okc and type(rc)=="function" then cands[#cands+1]={rc,"cc"} end
                    end
                    cands[#cands+1]={wrapper,"lc"}
                    local hooked=false
                    local herrs={}
                    for _,cd in ipairs(cands) do
                        local hw,hwtag=cd[1],cd[2]
                        local okh,ret=pcall(XHF,fn,hw)
                        if not okh then
                            herrs[#herrs+1]=hwtag..":"..string.sub(tostring(ret),1,45)
                        else
                            if type(ret)=="function" and ret~=hw and ret~=wrapper then box.orig=ret end
                            if box.orig==hw or box.orig==wrapper then
                                herrs[#herrs+1]=hwtag..":recursive"
                            else
                                box.probing=true
                                box.hit=false
                                local probeDone=false
                                task.spawn(function()
                                    pcall(function()
                                        local pr=(cls=="Workspace") and workspace or Instance.new(cls)
                                        pr[mname](pr,"selftest")
                                    end)
                                    probeDone=true
                                end)
                                for i=1,7 do
                                    if box.hit or probeDone then break end
                                    task.wait(0.1)
                                end
                                box.probing=false
                                if box.hit then
                                    hooked=true
                                    break
                                end
                                herrs[#herrs+1]=hwtag..":no-hit"
                            end
                        end
                    end
                    if not hooked then
                        error(mname..": closure did not run ("..table.concat(herrs,",")..")",0)
                    end
                    done[#done+1]=cls..":"..mname
                    if cls=="RemoteEvent" and mname=="FireServer" then path4FS=true end
                end
                local tgt={{"FireServer","RemoteEvent"},{"FireServer","UnreliableRemoteEvent"},{"Raycast","Workspace"},{"InvokeServer","RemoteFunction"}}
                for _,t in ipairs(tgt) do
                    local ok,e,done=false,"timeout",false
                    task.spawn(function()
                        ok,e=pcall(tryM,t[1],t[2])
                        done=true
                    end)
                    for i=1,25 do
                        if done then break end
                        task.wait(0.1)
                    end
                    if not ok then errs[#errs+1]=t[2]..":"..string.sub(tostring(e),1,60) end
                end
                if #done==0 then error("pHI["..string.sub(tostring(pHIerr),1,400).."] path4: "..table.concat(errs,"; "),0) end
                HOOK_PATH="hookfunction["..table.concat(done,",").."]"..((#errs>0) and (" partial: "..table.concat(errs,"; ")) or "")
            end
        end
        end
    end
end)
if hkOk then
    HOOK_OK=true
    local pth=tostring(HOOK_PATH)
    local skipFS=(string.find(pth,"hookfunction",1,true) and not path4FS) or string.find(pth,"[instance",1,true)
    if skipFS then
        pcall(function() print("[Axynth][Hook] OK via "..pth.." (install probes passed)") end)
    else
        local vB=ST._ncAny or 0
        task.spawn(function()
            pcall(function()
                local r=Instance.new("RemoteEvent") r.Name="AxSelfTest"
                r:FireServer("selftest")
            end)
        end)
        for i=1,10 do
            if (ST._ncAny or 0)>vB then break end
            task.wait(0.1)
        end
        if (ST._ncAny or 0)>vB then
            pcall(function() print("[Axynth][Hook] namecall OK via "..pth.." (self-test passed)") end)
        else
            HOOK_OK=false HOOK_ERR="installed via "..pth.." but closure never runs (no-op hook)"
            pcall(function() print("[Axynth][Hook] "..HOOK_ERR) end)
        end
    end
else
    HOOK_OK=false HOOK_ERR=tostring(hkErr)
    pcall(function() print("[Axynth][Hook] namecall FAILED: "..HOOK_ERR) end)
end
pcall(function()
    if type(setclipboard)=="function" then
        local msg="build=fx30 | "..(HOOK_OK and ("HOOK_OK | "..tostring(HOOK_PATH)) or ("HOOK_FAIL | "..tostring(HOOK_ERR)))
        setclipboard(msg)
        print("[Axynth][Hook] result copied to clipboard")
    end
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
local function applyGodLocal()
    pcall(function()
        if not ST.godmodeLoop then return end
        local ch=LP.Character
        if not ch then return end
        local hum=ch:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if hum.MaxHealth<10000000 then hum.MaxHealth=10000000 end
        if hum.Health<hum.MaxHealth then hum.Health=hum.MaxHealth end
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead,false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false) end)
        if not ch:FindFirstChild("AxGodFF") then
            local ff=Instance.new("ForceField")
            ff.Name="AxGodFF"
            ff.Visible=false
            ff.Parent=ch
        end
    end)
end
local function clearGodLocal()
    pcall(function()
        local ch=LP.Character
        if not ch then return end
        local hum=ch:FindFirstChildOfClass("Humanoid")
        if hum then
            if hum.MaxHealth>=10000000 then
                hum.MaxHealth=100
                hum.Health=100
            end
            pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead,true) end)
            pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true) end)
            pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true) end)
        end
        local ff=ch:FindFirstChild("AxGodFF")
        if ff then ff:Destroy() end
    end)
end
local function applyInvisible()
    pcall(function()
        local ch=LP.Character
        if not ch or not ST.invisible then return end
        for _,d in pairs(ch:GetDescendants()) do
            if d:IsA("BasePart") then
                if d.Transparency~=1 then d.Transparency=1 end
                if d.LocalTransparencyModifier~=1 then d.LocalTransparencyModifier=1 end
            elseif d:IsA("Decal") or d:IsA("Texture") then
                if d.Transparency~=1 then d.Transparency=1 end
            elseif d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam") or d:IsA("Fire") or d:IsA("Smoke") or d:IsA("Sparkles") then
                if d.Enabled then d.Enabled=false end
            elseif d:IsA("BillboardGui") or d:IsA("SurfaceGui") then
                if d.Enabled then d.Enabled=false end
            elseif d:IsA("Accessory") then
                local handle=d:FindFirstChild("Handle")
                if handle and handle:IsA("BasePart") then
                    handle.Transparency=1
                    handle.LocalTransparencyModifier=1
                end
            end
        end
        local hum=ch:FindFirstChildOfClass("Humanoid")
        if hum then
            local head=ch:FindFirstChild("Head")
            if head then
                for _,c in pairs(head:GetChildren()) do
                    if c:IsA("BillboardGui") or c:IsA("SurfaceGui") then c.Enabled=false end
                end
            end
        end
    end)
end
local function grFire(r, args, rateKey)
    if not r then return false end
    local rk=rateKey or "gr"
    local st=ST["_rt"..rk]
    if type(st)~="table" then st={t=0,c=0} ST["_rt"..rk]=st end
    local now=tick()
    if now-st.t>=0.05 then st.t=now st.c=0 end
    if st.c>=10 then return false end
    st.c=st.c+1
    local ok2=false
    if r:IsA("RemoteFunction") then
        ST._forceFire=true
        ok2=pcall(function() r:InvokeServer(unpack(args)) end)
        ST._forceFire=false
    else
        ST._forceFire=true
        ok2=pcall(function() r:FireServer(unpack(args)) end)
        ST._forceFire=false
    end
    return ok2 and true or false
end
local function fireInvisRemotes(on)
    pcall(function()
        local flag=on and true or false
        local sent=0
        local prio={
            "Inventory.Inventory",
            "NoclipEvent",
            "HDAdminHDClient.Signals.RequestCommand",
            "HDAdminHDClient.Signals.ExecuteClientCommand",
            "HDAdminHDClient.Signals.FireSignal",
            "CreateMafia.RemoteEvent",
            "Chat"
        }
        local hdArgs={
            {"invisible"},{"invis"},{":invisible"},{":invis"},
            {"invisible",LP.Name},{LP.Name,"invisible"},
            {"cmd","invisible"},{action="invisible"},
            {"ghost"},{"cloak"},{"hide"}
        }
        local invArgs={
            {flag},{"invisible",flag},{"cloak",flag},{"hide",flag},
            {"set",flag},{LP,flag},{"visible",not flag},
            {"transparency",flag and 1 or 0}
        }
        for _,path in ipairs(prio) do
            local r=findRemote(path)
            if r then
                local sets=(path:find("HDAdmin") or path=="Chat") and hdArgs or invArgs
                for _,args in ipairs(sets) do
                    if grFire(r,args,"inv") then sent=sent+1 end
                end
            end
        end
        local keys={"invis","invisible","cloak","ghost","hide","visibility","transparency","status"}
        local budget=10
        for _,parent in ipairs({RS,W}) do
            if budget<=0 then break end
            for _,d in pairs(parent:GetDescendants()) do
                if budget<=0 then break end
                if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
                    local nm=string.lower(d.Name)
                    for _,k in ipairs(keys) do
                        if nm:find(k,1,true) and not nm:find("anticheat") and not nm:find("admin") then
                            if grFire(d,{flag},"inv") then budget=budget-1 sent=sent+1 end
                            if grFire(d,{"invisible",flag},"inv") then budget=budget-1 sent=sent+1 end
                            break
                        end
                    end
                end
            end
        end
        ST._invisSent=sent
    end)
    pcall(function()
        if not on then return end
        local ch=LP.Character
        if not ch then return end
        for _,acc in pairs(ch:GetChildren()) do
            if acc:IsA("Accessory") then
                local handle=acc:FindFirstChild("Handle")
                if handle then
                    for _,m in pairs(handle:GetDescendants()) do
                        if m:IsA("DataModelMesh") or m:IsA("SpecialMesh") or m:IsA("FileMesh") then
                            pcall(function()
                                if m.Scale and m.Scale.Magnitude>0 then
                                    m:SetAttribute("AxOldScale", tostring(m.Scale))
                                    m.Scale=Vector3.new(0.001,0.001,0.001)
                                end
                            end)
                        end
                    end
                    pcall(function()
                        local at=handle:FindFirstChildOfClass("Attachment")
                        if not at then
                            at=Instance.new("Attachment")
                            at.Name="AxInvisAt"
                            at.Parent=handle
                        end
                        at.Position=Vector3.new(0,10000,0)
                    end)
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
        pcall(function()
            local items=ST._givenItems
            if not items then return end
            local bp=LP:FindFirstChild("Backpack")
            local c=0
            for nm,kind in pairs(items) do
                c=c+1
                if c>6 then break end
                local have=false
                pcall(function()
                    if (bp and bp:FindFirstChild(nm)) or char:FindFirstChild(nm) then have=true end
                end)
                if not have then
                    task.delay(1.0,function() pcall(function() giveGRItem(nm,kind,true) end) end)
                end
            end
        end)
        if ST.freeCam then
            task.delay(0.3,function()
                if not ST.freeCam then return end
                freezeLocalForCam()
                pcall(function()
                    local cam=W.CurrentCamera or CAM
                    CAM=cam
                    if cam then
                        cam.CameraType=Enum.CameraType.Scriptable
                        if ST.freeCamPos then
                            local yaw=ST.freeCamYaw or 0
                            local pitch=ST.freeCamPitch or 0
                            cam.CFrame=CFrame.new(ST.freeCamPos)*CFrame.Angles(pitch,yaw,0)
                        end
                    end
                end)
            end)
        end
        if ST.spectateOverhead and ST.spectating then
            task.delay(0.3,function()
                if not ST.spectateOverhead then return end
                freezeLocalForCam()
                ST.ovhInit=false
            end)
        end
        if ST.godmodeLoop then
            pcall(function()
                applyGodLocal()
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hum then
                    if ST._godHC then pcall(function() ST._godHC:Disconnect() end) ST._godHC=nil end
                    ST._godHC=hum.HealthChanged:Connect(function(h)
                        if not ST.godmodeLoop then return end
                        pcall(function()
                            if hum.MaxHealth<10000000 then hum.MaxHealth=10000000 end
                            if h<=0 or h<hum.MaxHealth then hum.Health=hum.MaxHealth end
                        end)
                    end)
                end
            end)
        end
        if ST.invisible then
            task.delay(0.2,function() applyInvisible() end)
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
            applyGodLocal()
            if _frameCount%90==0 then syncServerGod() end
        elseif not ST.godmodeLoop and ST._srvGod then
            syncServerGod()
        elseif not ST.godmodeLoop and _frameCount%300==0 then
            pcall(function()
                local ch=LP.Character
                if ch and ch:FindFirstChild("AxGodFF") then clearGodLocal() end
            end)
        end
        if ST.invisible and _frameCount%2==0 then
            applyInvisible()
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
print("[Axynth] Anti-Ban v9 SAFE | Whitelist: "..(function() local c=0 for _ in pairs(whitelistRemotes) do c=c+1 end return c end)().." | Keywords: "..#blockedKeywords.." | Hooks: "..(HOOK_OK and 1 or 0)..(HOOK_PATH and (" via "..HOOK_PATH) or ""))
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
ST = {menuOpen=false,fly=false,noclip=false,clickTP=false,esp=false,spectating=nil,selectedPlayer=nil,flySpeed=50,night=false,bright=false,noFog=false,invisible=false,espList={},spinner=false,autoClicker=false,infJump=false,savedCollide={},flyBypass=true,godmodeLoop=false,spheresOn=false,speedHard=false,vehicleSpeedOn=false,maceTP=false,infStamina=false,magicBullet=false,weaponDmgOn=false,weaponDmg=30,weaponDmgMult=1,cursorTPPreview=nil,waypoints={},botRecord=false,botPlay=false,botLoop=false,botFrames={},botStart=0,arrayList=false,markerObj=nil,savedLighting=nil,savedGravity=196.2,spinnerSpeed=25,remoteSpyOn=false,remoteSpyPaused=false,remoteSpyLog={},spySG=nil,aimEnabled=false,aimFOV=250,aimMaxDist=350,aimMode="silent",aimTargetPart="Head",aimTeamCheck=false,aimHoldKey=false,aimKeyHeld=false,aimFOVGui=nil,aimTarget=nil,showFOV=false,    aimWallCheck=false,vehBoost=80,vehApplyT=0,spectateOverhead=false,ovhOff=Vector3.new(0,25,0),ovhYaw=0,ovhPitch=-1.4,ovhInit=false,speedPreset=0,jumpPreset=0,shotTracer=false,dmgPop=true}
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
local function getDisplayName(pl)
    if not pl then return "Unknown" end
    if ST._renamedOthers and ST._renamedOthers[pl.UserId] then return ST._renamedOthers[pl.UserId] end
    if pl.Character then
        local hum=pl.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.DisplayName and hum.DisplayName~="" then return hum.DisplayName end
    end
    return pl.DisplayName or pl.Name
end
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
local function safeTeleport(targetPos)
    if not targetPos then return end
    if not LP.Character then return end
    local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local startPos=hrp.Position
    local dist=(targetPos-startPos).Magnitude
    if dist<=120 then
        pcall(function()
            hrp.Velocity=Vector3.new(0,0,0)
            hrp.RotVelocity=Vector3.new(0,0,0)
            hrp.CFrame=CFrame.new(targetPos)
        end)
        return
    end
    if ST._tpBusy then return end
    ST._tpBusy=true
    task.spawn(function()
        pcall(function()
            local steps=math.min(math.ceil(dist/55),28)
            for i=1,steps do
                if not LP.Character then break end
                local h=LP.Character:FindFirstChild("HumanoidRootPart")
                if not h then break end
                local alpha=i/steps
                local p=startPos+(targetPos-startPos)*alpha
                pcall(function()
                    h.Velocity=Vector3.new(0,0,0)
                    h.RotVelocity=Vector3.new(0,0,0)
                    h.CFrame=CFrame.new(p)
                end)
                pcall(function()
                    for _,part in pairs(LP.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide=false end
                    end
                end)
                task.wait(0.05)
            end
            pcall(function()
                local h=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if h then
                    h.Velocity=Vector3.new(0,0,0)
                    h.RotVelocity=Vector3.new(0,0,0)
                    h.CFrame=CFrame.new(targetPos)
                end
                if LP.Character and not ST.noclip then
                    for _,part in pairs(LP.Character:GetDescendants()) do
                        if part:IsA("BasePart") and ST.savedCollide[part]~=nil then
                            part.CanCollide=ST.savedCollide[part]
                        elseif part:IsA("BasePart") then
                            part.CanCollide=true
                        end
                    end
                end
            end)
        end)
        ST._tpBusy=false
    end)
end
local FC_KEYS={}
local fcLastT=tick()
local function fcKey(code)
    return FC_KEYS[code]==true
end
restoreLocalCamera=function()
    U.MouseBehavior=Enum.MouseBehavior.Default
    pcall(function()
        local cam=W.CurrentCamera or CAM
        CAM=cam
        if cam then
            local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if h then cam.CameraSubject=h end
            cam.CameraType=Enum.CameraType.Custom
        end
    end)
end
local function stopOverhead(notify)
    local was=ST.spectateOverhead
    ST.spectateOverhead=false
    ST._ovhActive=false
    pcall(function()
        game:GetService("ContextActionService"):UnbindAction("AxOvhSink")
    end)
    if not ST.freeCam then table.clear(FC_KEYS) end
    if was and not ST.freeCam then
        unfreezeLocalFromCam()
        restoreLocalCamera()
        ovhPrevM=nil
        pcall(function() U.MouseBehavior=Enum.MouseBehavior.Default end)
    else
        pcall(function()
            local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and ST._ovhWalk~=nil then
                hum.WalkSpeed=ST._ovhWalk
                ST._ovhWalk=nil
            end
        end)
    end
    if was and notify then ntf("Spectate","Overhead OFF - camera on you") end
end
freezeLocalForCam=function()
    pcall(function()
        local ch=LP.Character
        local hum=ch and ch:FindFirstChildOfClass("Humanoid")
        local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
        if hum and hum.Seated then return end
        if hum then
            if ST._fcWalk==nil then ST._fcWalk=hum.WalkSpeed end
            if ST._fcAS==nil then ST._fcAS=hum.AutoRotate end
            if hum.WalkSpeed~=0 then hum.WalkSpeed=0 end
            if hum.AutoRotate then hum.AutoRotate=false end
        end
        if hrp and not hrp.Anchored then
            hrp.Anchored=true
            hrp.Velocity=Vector3.new(0,0,0)
            hrp.RotVelocity=Vector3.new(0,0,0)
        end
    end)
end
unfreezeLocalFromCam=function()
    pcall(function()
        local ch=LP.Character
        local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
        local hum=ch and ch:FindFirstChildOfClass("Humanoid")
        if hrp and hrp.Anchored then
            hrp.Anchored=false
            hrp.Velocity=Vector3.new(0,0,0)
            hrp.RotVelocity=Vector3.new(0,0,0)
        end
        if hum then
            pcall(function() hum.PlatformStand=false end)
            pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Jumping,true) end)
            hum.WalkSpeed=ST.speedPreset or 16
            if ST.speedHard and hum.WalkSpeed<50 then hum.WalkSpeed=50 end
            if hum.WalkSpeed<=0 then hum.WalkSpeed=16 end
            if ST.jumpPreset and ST.jumpPreset>0 then
                if hum.UseJumpPower then hum.JumpPower=ST.jumpPreset else hum.JumpHeight=math.max(5,math.floor(ST.jumpPreset*0.14+0.5)) end
            end
            hum.AutoRotate=ST._fcAS~=false
        end
        ST._fcWalk=nil ST._fcAS=nil
    end)
end
ensureCamInputConns=function()
    if ST._fcInConns then return end
    ST._fcInConns=true
    pcall(function()
        U.InputBegan:Connect(function(inp,gpe)
            if not ST.freeCam and not ST.spectateOverhead then return end
            if inp.KeyCode and inp.KeyCode~=Enum.KeyCode.Unknown then
                FC_KEYS[inp.KeyCode]=true
            end
        end)
        U.InputEnded:Connect(function(inp)
            if inp.KeyCode and inp.KeyCode~=Enum.KeyCode.Unknown then
                FC_KEYS[inp.KeyCode]=nil
            end
        end)
        U.InputBegan:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseButton2 then
                if ST.freeCam or ST.spectateOverhead then ST._camRMB=true end
            end
        end)
        U.InputEnded:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseButton2 then
                ST._camRMB=false
            end
        end)
    end)
end
local function setFreeCam(on)
    if on then
        if ST.freeCam then return end
        stopOverhead(false)
        ST.freeCam=true
        ensureCamInputConns()
        -- freeze character once (no per-frame spam)
        pcall(function()
            local ch=LP.Character
            local hum=ch and ch:FindFirstChildOfClass("Humanoid")
            local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
            if hum then
                if ST._fcWalk==nil then ST._fcWalk=hum.WalkSpeed end
                if ST._fcAS==nil then ST._fcAS=hum.AutoRotate end
                hum.WalkSpeed=0
                hum.AutoRotate=false
            end
            if hrp then
                hrp.Anchored=true
                hrp.Velocity=Vector3.new(0,0,0)
                hrp.RotVelocity=Vector3.new(0,0,0)
            end
        end)
        pcall(function()
            local cam=W.CurrentCamera or CAM
            CAM=cam
            if not cam then return end
            local p=cam.CFrame.Position
            local look=cam.CFrame.LookVector
            if p.X==p.X and p.Y==p.Y and p.Z==p.Z and look.X==look.X then
                ST.freeCamPos=p
                ST.freeCamYaw=math.atan2(look.X,look.Z)
                ST.freeCamPitch=math.clamp(math.asin(math.clamp(-look.Y,-1,1)),-1.45,1.45)
            else
                local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                ST.freeCamPos=hrp and (hrp.Position+Vector3.new(0,5,0)) or Vector3.new(0,10,0)
                ST.freeCamYaw=0
                ST.freeCamPitch=0
            end
            if ST.freeCamYaw~=ST.freeCamYaw then ST.freeCamYaw=0 end
            if ST.freeCamPitch~=ST.freeCamPitch then ST.freeCamPitch=0 end
            fcLastT=tick()
            cam.CameraType=Enum.CameraType.Scriptable
            cam.CFrame=CFrame.new(ST.freeCamPos)*CFrame.Angles(0,ST.freeCamYaw,0)*CFrame.Angles(ST.freeCamPitch,0,0)
            U.MouseBehavior=Enum.MouseBehavior.Default
        end)
        -- capture WASD/Space/Ctrl/Shift even when game would normally handle them (gpe)
        pcall(function()
            local CAS=game:GetService("ContextActionService")
            CAS:UnbindAction("AxFreecamSink")
            CAS:BindActionAtPriority("AxFreecamSink",function(an,st,io)
                local kc=io and io.KeyCode
                if typeof(kc)=="EnumItem" and kc~=Enum.KeyCode.Unknown then
                    if st==Enum.UserInputState.Begin then
                        FC_KEYS[kc]=true
                    elseif st==Enum.UserInputState.End or st==Enum.UserInputState.Cancel then
                        FC_KEYS[kc]=nil
                    end
                end
                return Enum.ContextActionResult.Sink
            end,false,Enum.ContextActionPriority.Max.Value,Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Space,Enum.KeyCode.LeftControl,Enum.KeyCode.LeftShift)
        end)
        pcall(function()
            if ST._axCamTick then
                R:BindToRenderStep("AxCamCtrl",Enum.RenderPriority.Last.Value+100,function(...)
                    if ST._axCamTick then ST._axCamTick(...) end
                end)
            end
        end)
        ntf("FreeCam","ON - WASD to move (no RMB), hold RMB to look, Shift fast, Space/Ctrl up/down")
    else
        local was=ST.freeCam
        ST.freeCam=false
        ST._camRMB=false
        pcall(function() U.MouseBehavior=Enum.MouseBehavior.Default end)
        pcall(function() game:GetService("ContextActionService"):UnbindAction("AxFreecamSink") end)
        unfreezeLocalFromCam()
        restoreLocalCamera()
        ST.freeCamPos=nil
        if was then ntf("FreeCam","OFF") end
    end
end
keyHeld=function(kc)
    return fcKey(kc) or U:IsKeyDown(kc)
end
local function applyFreeCam(cam)
    if not ST.freeCam then return end
    if not cam then return end
    if cam.CameraType~=Enum.CameraType.Scriptable then
        pcall(function() cam.CameraType=Enum.CameraType.Scriptable end)
    end
    local now=tick()
    local dt=now-(fcLastT or now)
    if dt<=0 then dt=0.016 end
    if dt>0.1 then dt=0.1 end
    fcLastT=now
    -- RMB = look (LockCenter + delta), else free mouse
    local rmb=false
    pcall(function() rmb=U:IsKeyDown(Enum.UserInputType.MouseButton2) end)
    if not rmb then pcall(function() rmb=U:IsMouseButtonPressed(Enum.MouseButton2) end) end
    if not rmb and ST._camRMB then rmb=true end
    if rmb then
        pcall(function() U.MouseBehavior=Enum.MouseBehavior.LockCenter end)
        local dx,dy=0,0
        pcall(function()
            local d=U:GetMouseDelta()
            if d then dx,dy=d.X,d.Y end
        end)
        if dx>80 then dx=80 elseif dx<-80 then dx=-80 end
        if dy>80 then dy=80 elseif dy<-80 then dy=-80 end
        if dx~=0 or dy~=0 then
            ST.freeCamYaw=(ST.freeCamYaw or 0)-dx*0.004
            ST.freeCamPitch=math.clamp((ST.freeCamPitch or 0)-dy*0.004,-1.45,1.45)
        end
    else
        pcall(function()
            if U.MouseBehavior~=Enum.MouseBehavior.Default then
                U.MouseBehavior=Enum.MouseBehavior.Default
            end
        end)
        if ST._camRMB then ST._camRMB=false end
    end
    local yaw=ST.freeCamYaw or 0
    local pitch=ST.freeCamPitch or 0
    local rot=CFrame.Angles(0,yaw,0)*CFrame.Angles(pitch,0,0)
    -- WASD always works via direct IsKeyDown (no FC_KEYS needed)
    local dir=Vector3.new(0,0,0)
    local base=60
    local isShift=false
    pcall(function() isShift=U:IsKeyDown(Enum.KeyCode.LeftShift) end)
    if isShift then base=180 end
    local fw,back,left,right,up,down=false,false,false,false,false,false
    pcall(function() fw=U:IsKeyDown(Enum.KeyCode.W) end)
    pcall(function() back=U:IsKeyDown(Enum.KeyCode.S) end)
    pcall(function() left=U:IsKeyDown(Enum.KeyCode.A) end)
    pcall(function() right=U:IsKeyDown(Enum.KeyCode.D) end)
    pcall(function() up=U:IsKeyDown(Enum.KeyCode.Space) end)
    pcall(function() down=U:IsKeyDown(Enum.KeyCode.LeftControl) end)
    -- always OR with FC_KEYS (IsKeyDown can fail in some executors)
    if not fw and FC_KEYS[Enum.KeyCode.W] then fw=true end
    if not back and FC_KEYS[Enum.KeyCode.S] then back=true end
    if not left and FC_KEYS[Enum.KeyCode.A] then left=true end
    if not right and FC_KEYS[Enum.KeyCode.D] then right=true end
    if not up and FC_KEYS[Enum.KeyCode.Space] then up=true end
    if not down and FC_KEYS[Enum.KeyCode.LeftControl] then down=true end
    if FC_KEYS[Enum.KeyCode.LeftShift] then base=180 end
    if fw then dir=dir+rot.LookVector end
    if back then dir=dir-rot.LookVector end
    if left then dir=dir-rot.RightVector end
    if right then dir=dir+rot.RightVector end
    if up then dir=dir+Vector3.new(0,1,0) end
    if down then dir=dir-Vector3.new(0,1,0) end
    local pos=ST.freeCamPos
    if not pos then
        pos=cam.CFrame.Position
        ST.freeCamPos=pos
    end
    if dir.Magnitude>0 then
        pos=pos+dir.Unit*base*dt
        ST.freeCamPos=pos
    end
    local cf=CFrame.new(pos)*rot
    -- NaN guard (only CFrame, no Focus to avoid game's WeaponsSystem nil error)
    if pos.X==pos.X and pos.Y==pos.Y and pos.Z==pos.Z then
        pcall(function()
            cam.CFrame=cf
            cam.Focus=cf
        end)
    end
end
ovhPrevM=nil
local ovhLastT=tick()
local function applyOverhead(cam)
    if not ST.spectateOverhead then return end
    if not ST.spectating or not ST.spectating.Parent then
        stopOverhead(false)
        ntf("Spectate","Target lost - overhead stopped",4)
        return
    end
    local chT=ST.spectating.Character
    local hrpT=chT and (chT:FindFirstChild("HumanoidRootPart") or chT:FindFirstChild("Head"))
    if not cam then return end
    if not hrpT then
        if not ST._ovhNoChar then ST._ovhNoChar=tick() return end
        if tick()-ST._ovhNoChar<5 then return end
        ST._ovhNoChar=nil
        stopOverhead(false)
        ntf("Spectate","Target character lost - overhead stopped",4)
        return
    end
    ST._ovhNoChar=nil
    if cam.CameraType~=Enum.CameraType.Scriptable then cam.CameraType=Enum.CameraType.Scriptable end
    ensureCamInputConns()
    pcall(function()
        local ch=LP.Character
        local hum=ch and ch:FindFirstChildOfClass("Humanoid")
        local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
        if hum then
            if ST._fcWalk==nil then ST._fcWalk=hum.WalkSpeed end
            if ST._fcAS==nil then ST._fcAS=hum.AutoRotate end
            if hum.WalkSpeed~=0 then hum.WalkSpeed=0 end
            if hum.AutoRotate then hum.AutoRotate=false end
        end
        if hrp and not hrp.Anchored then
            hrp.Anchored=true
            hrp.Velocity=Vector3.new(0,0,0)
            hrp.RotVelocity=Vector3.new(0,0,0)
        end
    end)
    if not ST.ovhInit then
        ST.ovhYaw=0
        ST.ovhPitch=1.45
        ST.ovhDist=32
        ST.ovhInit=true
        ovhLastT=tick()-1
    end
    local now=tick()
    local dt=now-(ovhLastT or now)
    if dt<=0 then dt=0.016 end
    if dt>0.09 then dt=0.09 end
    ovhLastT=now
    if U.MouseBehavior~=Enum.MouseBehavior.Default then
        U.MouseBehavior=Enum.MouseBehavior.Default
    end
    ovhPrevM=nil
    local yaw=ST.ovhYaw or 0
    local pitch=ST.ovhPitch or 1.45
    local dist=ST.ovhDist or 32
    local cx=hrpT.Position.X+dist*math.cos(pitch)*math.sin(yaw)
    local cy=hrpT.Position.Y+dist*math.sin(pitch)
    local cz=hrpT.Position.Z+dist*math.cos(pitch)*math.cos(yaw)
    local target=hrpT.Position+Vector3.new(0,2,0)
    local want=CFrame.lookAt(Vector3.new(cx,cy,cz),target)
    local alpha=math.clamp(dt*18,0,1)
    if cx==cx and cy==cy and cz==cz then
        pcall(function()
            cam.CFrame=cam.CFrame:Lerp(want,alpha)
            cam.Focus=CFrame.new(target)
        end)
    end
end
local function isAimActive()
    if ST.aimHoldKey then return ST.aimKeyHeld end
    return ST.aimEnabled or ST.aimKeyHeld
end
local function aimWallOk(camPos, pl, tgtPos)
    if not ST.aimWallCheck then return true end
    local cacheKey=pl.UserId
    local now=tick()
    local cache=ST._aimWallC and ST._aimWallC[cacheKey]
    if cache and now-cache.t<0.15 then return cache.ok end
    local ok=true
    pcall(function()
        local params=RaycastParams.new()
        params.FilterType=Enum.RaycastFilterType.Exclude
        local filt={LP.Character}
        if pl.Character then
            for _,v in pairs(pl.Character:GetDescendants()) do table.insert(filt,v) end
        end
        params.FilterDescendantsInstances=filt
        ok=(W:Raycast(camPos,tgtPos-camPos,params)==nil)
    end)
    ST._aimWallC=ST._aimWallC or {}
    ST._aimWallC[cacheKey]={t=now,ok=ok}
    return ok
end
local function applyAim(cam)
    if ST.freeCam or ST.spectateOverhead then return end
    if not isAimActive() then
        if ST.aimTarget then
            ST.aimTarget=nil
            ST._aimWallC=nil
            local myHum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if myHum and not myHum.AutoRotate then myHum.AutoRotate=true end
        end
        return
    end
    if not (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character:FindFirstChildOfClass("Humanoid")) then return end
    local camPos=cam.CFrame.Position
    local myPos=LP.Character.HumanoidRootPart.Position
    local vp=cam.ViewportSize
    local screenCenter=Vector2.new(vp.X*0.5,vp.Y*0.5)
    local center=U:GetMouseLocation()
    local fov=ST.aimFOV or 250
    local maxDist=ST.aimMaxDist or 350
    local bestTarget=nil
    local bestScore=math.huge
    local cur=ST.aimTarget
    for _,pp in pairs(P:GetPlayers()) do
        if pp==LP then continue end
        local ch=pp.Character
        if not ch then continue end
        local part=ch:FindFirstChild(ST.aimTargetPart) or ch:FindFirstChild("HumanoidRootPart")
        local hum=ch:FindFirstChildOfClass("Humanoid")
        if not part or not hum or hum.Health<=0 then continue end
        if ST.aimTeamCheck and pp.Team==LP.Team then continue end
        local tgtPos=part.Position
        local worldDist=(myPos-tgtPos).Magnitude
        if worldDist>maxDist then continue end
        if not aimWallOk(camPos,pp,tgtPos) then continue end
        local sp2,onscreen=cam:WorldToViewportPoint(tgtPos)
        if not onscreen then continue end
        local p2=Vector2.new(sp2.X,sp2.Y)
        local dScreen=math.min((p2-center).Magnitude,(p2-screenCenter).Magnitude)
        if dScreen>fov then continue end
        local score=dScreen+worldDist*0.15
        if pp==cur then score=score-20 end
        if score<bestScore then bestScore=score bestTarget=pp end
    end
    ST.aimTarget=bestTarget
    local myHum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if myHum and not myHum.AutoRotate then myHum.AutoRotate=true end
end
ST._axCamTick=function()
    pcall(function()
        local cam=W.CurrentCamera
        if not cam then return end
        CAM=cam
        if ST.freeCam then
            applyFreeCam(cam)
        elseif ST.spectateOverhead then
            applyOverhead(cam)
        else
            if not isAimActive() and cam.CameraType~=Enum.CameraType.Custom then
                pcall(function()
                    cam.CameraType=Enum.CameraType.Custom
                    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                    if hum then cam.CameraSubject=hum end
                end)
            end
            applyAim(cam)
        end
    end)
end
pcall(function()
    R:BindToRenderStep("AxCamCtrl",Enum.RenderPriority.Last.Value+100,function(...)
        if ST._axCamTick then ST._axCamTick(...) end
    end)
end)
function findRemote(name)
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
axResolvePath=function(p)
    if type(p)~="string" then return nil end
    local cur=game
    for part in string.gmatch(p,"[^%.]+") do
        if not cur then return nil end
        cur=cur:FindFirstChild(part)
    end
    return cur
end
axEnc=function(v,d)
    d=d or 0
    if d>7 then return nil end
    local t=typeof(v)
    if t=="string" then return v end
    if t=="boolean" then return v end
    if t=="number" then
        if v~=v or v==math.huge or v==-math.huge then return 0 end
        return v
    end
    if t=="Instance" then return {__t="i",p=v:GetFullName()} end
    if t=="Vector3" then return {__t="v",x=v.X,y=v.Y,z=v.Z} end
    if t=="CFrame" then return {__t="c",c={v:GetComponents()}} end
    if t=="EnumItem" then return {__t="e",s=tostring(v)} end
    if t=="table" then
        local n=#v
        local seq=false
        if n>0 then
            seq=true
            local cnt=0
            for k in pairs(v) do
                cnt=cnt+1
                if type(k)~="number" or k<1 or k%1~=0 then seq=false break end
            end
            if cnt~=n then seq=false end
        end
        if seq then
            local o={}
            for i=1,n do o[i]=axEnc(v[i],d+1) end
            return o
        end
        local o={}
        for k,val in pairs(v) do
            local e=axEnc(val,d+1)
            if e~=nil then o[tostring(k)]=e end
        end
        return o
    end
    return nil
end
axSerStr=function(a)
    local ok2,r=pcall(function()
        return game:GetService("HttpService"):JSONEncode(axEnc(a))
    end)
    if ok2 and type(r)=="string" then return r end
    return ""
end
axSaveLearn=function()
    pcall(function()
        if not ST._lsForce and tick()-(ST._lsT or 0)<5 then return end
        ST._lsForce=false
        ST._lsT=tick()
        local HS=game:GetService("HttpService")
        local out={}
        local lg=ST._learnLog
        if lg then
            for path,arr in pairs(lg) do
                if #out>=25 then break end
                local rec=arr and arr[1]
                if rec and rec.args then
                    table.insert(out,{p=path,s=rec.sig or "",a=axEnc(rec.args)})
                end
            end
        end
        writefile("axynth_learn.json",HS:JSONEncode(out))
        if ST._capLines and #ST._capLines>0 then
            pcall(function() writefile("axynth_capture.txt",table.concat(ST._capLines,"\n")) end)
        end
    end)
end
axLoadLearn=function()
    pcall(function()
        if not isfile("axynth_learn.json") then return end
        local raw=readfile("axynth_learn.json")
        if type(raw)~="string" or raw=="" then return end
        local data=game:GetService("HttpService"):JSONDecode(raw)
        if type(data)~="table" then return end
        local function dec(v,d)
            d=d or 0
            if d>7 then return v end
            if type(v)~="table" then return v end
            local tg=v.__t
            if tg=="i" then return axResolvePath(v.p) or v.p end
            if tg=="v" then return Vector3.new(v.x or 0,v.y or 0,v.z or 0) end
            if tg=="c" then
                local ok2,cf=pcall(function() return CFrame.new(unpack(v.c)) end)
                if ok2 then return cf end
                return v
            end
            if tg=="e" then
                local cls,it=tostring(v.s or ""):match("^Enum%.([^.]+)%.(.+)$")
                if cls and Enum[cls] and Enum[cls][it] then return Enum[cls][it] end
                return v.s
            end
            local o={}
            for k,val in pairs(v) do o[k]=dec(val,d+1) end
            return o
        end
        ST._learnLog=ST._learnLog or {}
        for _,e in ipairs(data) do
            if type(e)=="table" and type(e.p)=="string" and type(e.a)=="table" then
                local args=dec(e.a)
                if type(args)=="table" then
                    local arr=ST._learnLog[e.p] or {}
                    table.insert(arr,1,{sig=e.s or "",t=tick(),inst=axResolvePath(e.p),path=e.p,args=args})
                    while #arr>6 do table.remove(arr) end
                    ST._learnLog[e.p]=arr
                end
            end
        end
    end)
end
axLearnInst=function(rec)
    if not rec then return nil end
    if not rec.inst and rec.path then
        rec.inst=axResolvePath(rec.path)
    end
    return rec.inst
end
pcall(axLoadLearn)
local function forceFire(r, ...)
    if not r then return end
    local args={...}
    ST._forceFire=true
    local ok=pcall(function() r:FireServer(unpack(args)) end)
    ST._forceFire=false
    return ok
end
local function forceInvoke(r, ...)
    if not r then return end
    local args={...}
    ST._forceFire=true
    pcall(function() r:InvokeServer(unpack(args)) end)
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
local fireGameVolley
local hitRemotesCache=nil
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
            grFire(rf,{origin,hitPos},"kill")
            grFire(rf,{origin,hitPos,part},"kill")
            grFire(rf,{hitPos,part},"kill")
        end
        if not hitRemotesCache then
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
                for _,parent in ipairs({RS,W}) do
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
            hitRemotesCache=hitRemotes
        end
        local dmg=999999
        local argSets={
            {hitPos,part,dmg},
            {victim,hitPos,part,dmg},
            {victim.Name,hitPos,part,dmg},
            {victim.UserId,hitPos,dmg},
            {origin,hitPos},
            {origin,dir.Unit,part,hitPos,dmg},
            {part,hitPos,dmg},
            {victim,dmg}
        }
        local budgetH=8
        for _,r in ipairs(hitRemotesCache) do
            for _,args in ipairs(argSets) do
                if budgetH<=0 then break end
                if grFire(r,args,"kill") then budgetH=budgetH-1 end
            end
            if budgetH<=0 then break end
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
    mpKillPlayer(target,pos)
    pcall(function()
        if not AR then AR=RS:FindFirstChild("AdminRemote") or RS:FindFirstChild("HDAdminRemote") end
        if AR then AR:FireServer("kill", target.Name) end
    end)
    pcall(function()
        local thief=findRemote("ThiefSystem.RemoteEvent")
        if thief then forceFire(thief,{"kill",target}) end
    end)
    ntf("Kill","Sent MP kill to "..target.DisplayName.." ("..(hadWeapon and "weapon equipped" or "no weapon - remotes only")..")")
end
fireGameVolley=function(origin, target)
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
    b.MouseButton1Click:Connect(function() twFast(b,{BackgroundColor3=TH.a},0.08) wait(0.08) tw(b,{BackgroundColor3=TH.bh},0.15) local okE,eE=pcall(fn) if not okE then pcall(function() print("[Axynth][btn] "..tostring(t)..": "..tostring(eE)) end) pcall(function() ntf("Error",tostring(t)..": "..tostring(eE),7) end) end end)
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
    b.MouseButton1Click:Connect(function() twFast(b,{BackgroundColor3=TH.a},0.08) wait(0.08) local okE,eE=pcall(fn) if not okE then pcall(function() print("[Axynth][tog] "..tostring(t)..": "..tostring(eE)) end) pcall(function() ntf("Error",tostring(t)..": "..tostring(eE),7) end) end local s=gf() tw(b,{BackgroundColor3=s and Color3.fromRGB(30,60,30) or TH.b},0.15) b.Text="  "..t..": "..(s and "ON" or "OFF") b.TextColor3=s and TH.g or TH.t pcall(function() b.UIStroke.Color=s and TH.g or Color3.fromRGB(60,60,90) end) end)
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
local SG=Instance.new("ScreenGui") SG.Name="AxynthMenu" SG.ResetOnSpawn=false SG.DisplayOrder=999 SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling SG.IgnoreGuiInset=true
pcall(function() if gethui then SG.Parent=gethui() end end)
if not SG.Parent then pcall(function() SG.Parent=CG end) end
if not SG.Parent then SG.Parent=LP:WaitForChild("PlayerGui") end
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
table.insert(allToggles,tog(tH,"Infinite Jump",function() return ST.infJump end,function() ST.infJump=not ST.infJump if ST.infJump then ST.godmodeLoop=true syncServerGod() ntf("InfJump","ON - Space + Godmode forced") else ntf("InfJump","OFF") end end,"infjump"))
table.insert(allToggles,tog(tH,"Speed Hard",function() return ST.speedHard end,function() ST.speedHard=not ST.speedHard if ST.speedHard then ST.speedPreset=math.max(ST.speedPreset,50) ntf("SpeedHard","ON (50)") else ST.speedPreset=0 pcall(function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=16 end end end) ntf("SpeedHard","OFF") end end,"speedhard"))
table.insert(allToggles,tog(tH,"Infinite Stamina",function() return ST.infStamina end,function() ST.infStamina=not ST.infStamina ST._stamVals=nil ST._stamWarned=false ntf("Stamina",ST.infStamina and "ON - scanning char+player+gui+attrs" or "OFF") end,"infstam"))
sep(tH)
lbl(tH,">> FLY + NOCLIP")
table.insert(allToggles,tog(tH,"Fly",function() return ST.fly end,function() ST.fly=not ST.fly if ST.fly then ST.godmodeLoop=true syncServerGod() end if not ST.fly and LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.PlatformStand=false end local hrp=LP.Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.Velocity=Vector3.new(0,0,0) hrp.RotVelocity=Vector3.new(0,0,0) end end ntf("Fly",ST.fly and "ON - WASD+Space/Ctrl + Godmode" or "OFF") end,"fly"))
table.insert(allToggles,tog(tH,"Noclip",function() return ST.noclip end,function()
    ST.noclip=not ST.noclip
    pcall(function()
        local r=findRemote("NoclipEvent")
        if r then
            grFire(r,{ST.noclip},"noclip")
            grFire(r,{LP,ST.noclip},"noclip")
        end
    end)
    if not ST.noclip and LP.Character then
        for _,p2 in pairs(LP.Character:GetDescendants()) do
            if p2:IsA("BasePart") and ST.savedCollide[p2]~=nil then p2.CanCollide=ST.savedCollide[p2] end
        end
        ST.savedCollide={}
    end
    ntf("Noclip",ST.noclip and "ON" or "OFF")
end,"noclip"))
table.insert(allToggles,tog(tH,"Free Cam",function() return ST.freeCam end,function() setFreeCam(not ST.freeCam) end,"freecam"))
table.insert(allToggles,tog(tH,"Spinner (Self)",function() return ST.spinner end,function() ST.spinner=not ST.spinner if not ST.spinner and LP.Character then for _,v in pairs(LP.Character:GetDescendants()) do if v:IsA("BodyAngularVelocity") and v.Name:find("AxSpin") then v:Destroy() end end end end,"spinner"))
btn(tH,"Spinner: Slow",function() ST.spinnerSpeed=10 ntf("Spinner","Slow (10)") end,"spinslow")
btn(tH,"Spinner: Fast",function() ST.spinnerSpeed=25 ntf("Spinner","Fast (25)") end,"spinfast")
btn(tH,"Spinner: Insane",function() ST.spinnerSpeed=50 ntf("Spinner","Insane (50)") end,"spinins")
sep(tH)
lbl(tH,">> TELEPORT")
table.insert(allToggles,tog(tH,"Click TP",function() return ST.clickTP end,function() ST.clickTP=not ST.clickTP if ST.clickTP then if not ST.cursorTPPreview then local p=Instance.new("Part") p.Name="AxCTPPreview" p.Size=Vector3.new(3,0.2,3) p.Anchored=true p.CanCollide=false p.Material=Enum.Material.Neon p.Color=Color3.fromRGB(255,0,0) p.Transparency=0.5 p.Parent=W ST.cursorTPPreview=p end else if ST.cursorTPPreview then ST.cursorTPPreview:Destroy() ST.cursorTPPreview=nil end end ntf("ClickTP",ST.clickTP and "ON" or "OFF") end,"clicktp"))
btn(tH,"TP Cursor",function() if LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h and MS.Hit then safeTeleport(MS.Hit.Position+Vector3.new(0,3,0)) ntf("TP","Teleported to cursor!") end end end,"tpcur")
btn(tH,"TP Forward",function() if LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h then safeTeleport(h.Position+CAM.CFrame.LookVector*100) end end end,"tpfwd")

local tW=tF["world"]
lbl(tW,">> WORLD")
table.insert(allToggles,tog(tW,"Night",function() return ST.night end,function() setNight(not ST.night) end,"night"))
table.insert(allToggles,tog(tW,"Fullbright",function() return ST.bright end,function() ST.bright=not ST.bright if ST.bright then if not ST.savedLighting then ST.savedLighting={Brightness=L.Brightness,GlobalShadows=L.GlobalShadows,FogEnd=L.FogEnd,Ambient=L.Ambient,OutdoorAmbient=L.OutdoorAmbient,ClockTime=L.ClockTime} end else if ST.savedLighting then pcall(function() L.Brightness=ST.savedLighting.Brightness L.GlobalShadows=ST.savedLighting.GlobalShadows L.FogEnd=ST.savedLighting.FogEnd L.Ambient=ST.savedLighting.Ambient L.OutdoorAmbient=ST.savedLighting.OutdoorAmbient L.ClockTime=ST.savedLighting.ClockTime end) ST.savedLighting=nil end end end,"bright"))
table.insert(allToggles,tog(tW,"No Fog",function() return ST.noFog end,function() setNoFog(not ST.noFog) end,"nofog"))
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
sep(tW)
lbl(tW,">> SPAWN VEHICLE (Next to you)")
local function getVehicleList()
    if ST._vehList and #ST._vehList>0 then return ST._vehList end
    if ST._vehScanT and tick()-ST._vehScanT<5 then return ST._vehList or {} end
    ST._vehScanT=tick()
    local list={}
    local seen={}
    local function addModel(m)
        if not m or seen[m] then return end
        seen[m]=true
        table.insert(list,m)
        if #list>40 then return true end
        return false
    end
    local function scan(parent,deep)
        if not parent then return false end
        local ok=false
        pcall(function()
            local items=deep and parent:GetDescendants() or parent:GetChildren()
            for _,d in ipairs(items) do
                if d:IsA("VehicleSeat") then
                    local model=d:FindFirstAncestorOfClass("Model")
                    if model and addModel(model) then ok=true return end
                elseif d:IsA("Model") then
                    -- quick check: only if model has VehicleSeat child (not deep scan for every desc)
                    if d:FindFirstChildOfClass("VehicleSeat") then
                        if addModel(d) then ok=true return end
                    end
                end
                if #list>40 then ok=true return end
            end
        end)
        return ok
    end
    -- only scan ReplicatedStorage and RS for templates (fast), not Workspace
    scan(game:GetService("ReplicatedStorage"),true)
    if #list<10 then scan(RS,true) end
    if #list<5 then scan(game:GetService("ServerStorage"),true) end
    -- fallback: if still empty, bounded walk of Workspace (finds nested vehicles, capped cost)
    if #list==0 then
        pcall(function()
            local stack={W}
            local budget=20000
            while #stack>0 and budget>0 and #list<40 do
                local par=table.remove(stack,#stack)
                budget=budget-1
                pcall(function()
                    for _,d in ipairs(par:GetChildren()) do
                        if d:IsA("VehicleSeat") then
                            local m=d:FindFirstAncestorOfClass("Model")
                            if m and not addModel(m) then return end
                        elseif d:IsA("Model") then
                            if d:FindFirstChildOfClass("VehicleSeat") then
                                if not addModel(d) then return end
                            else
                                table.insert(stack,d)
                            end
                        elseif d:IsA("Folder") then
                            table.insert(stack,d)
                        end
                    end
                end)
            end
        end)
    end
    ST._vehList=list
    return list
end
local function spawnVehicle(name, pos)
    pcall(function() if ST._vehClone and ST._vehClone.Parent then ST._vehClone:Destroy() end ST._vehClone=nil end)
    local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local spawnPos=pos or (hrp and hrp.Position + hrp.CFrame.LookVector*10 + Vector3.new(0,2,0) or Vector3.new(0,5,0))
    name=string.match(name or "","^%s*(.-)%s*$") or name
    local q=string.lower(name or "")
    if q=="" then
        local all=getVehicleList()
        if #all>0 then
            local pick=all[math.random(1,#all)]
            q=string.lower(pick.Name)
            name=pick.Name
        else
            ntf("Vehicle","No vehicles found to spawn",4) return
        end
    end
    local fired=0
    pcall(function()
        local lg=ST._learnLog
        if not lg then return end
        if ST._learnVPend then
            ST._learnVPend=nil
            ntf("Vehicle","Vehicle args learned - Spawn now replays them",5)
        end
        local verbSet={buy=1,sell=1,spawn=1,respawn=1,select=1,use=1,set=1,get=1,open=1,park=1,add=1,save=1,create=1}
        local replays=0
        for path,arr in pairs(lg) do
            if replays>=2 then break end
            local lp=string.lower(path)
            if string.find(lp,"cardealer",1,true) or string.find(lp,"spawncar",1,true) or string.find(lp,"vehicle",1,true) or string.find(lp,"garage",1,true) or string.find(lp,"dealership",1,true) or string.find(lp,"cars",1,true) then
                local rec=arr[1]
                if rec and axLearnInst(rec) then
                    local function build(usePos)
                        local na={} local sub=false
                        for i,a in ipairs(rec.args) do
                            if typeof(a)=="string" then
                                local lv=string.lower(a)
                                if verbSet[lv]==1 or string.find(a,"%d") or string.find(a,"_",1,true) then
                                    na[i]=a
                                else
                                    na[i]=name sub=true
                                end
                            elseif usePos and typeof(a)=="Vector3" then
                                na[i]=spawnPos sub=true
                            elseif usePos and typeof(a)=="CFrame" then
                                na[i]=CFrame.new(spawnPos) sub=true
                            else
                                na[i]=a
                            end
                        end
                        return na,sub
                    end
                    local na1,sub1=build(false)
                    if sub1 then
                        grFire(rec.inst,na1,"lv"..replays) replays=replays+1
                    end
                    if replays<2 then
                        local hasPos=false
                        for _,a in ipairs(rec.args) do
                            if typeof(a)=="Vector3" or typeof(a)=="CFrame" then hasPos=true break end
                        end
                        if hasPos then
                            local na2,sub2=build(true)
                            if sub2 then grFire(rec.inst,na2,"lv"..replays) replays=replays+1 end
                        end
                    end
                end
            end
        end
    end)
    pcall(function()
        local rems={
            RS:FindFirstChild("Cars") and RS.Cars:FindFirstChild("CarDealer"),
            RS:FindFirstChild("CarDealer"),
            W:FindFirstChild("Cars") and W.Cars:FindFirstChild("CarDealer"),
            findRemote("Cars.CarDealer"),
            findRemote("CarDealer"),
            findRemote("SpawnVehicle"),
            findRemote("BuyVehicle"),
            findRemote("CreateVehicle"),
            findRemote("VehicleSpawn"),
        }
        for ri,r in ipairs(rems) do
            if r then
                if grFire(r,{name},"veh"..ri) then fired=fired+1 end
                if r:IsA("RemoteFunction") then
                    pcall(function() r:InvokeServer(name) fired=fired+1 end)
                end
            end
        end
    end)
    -- scan for any vehicle remote by name
    pcall(function()
        local vi=0
        for _,obj in pairs(RS:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local nm=string.lower(obj.Name)
                if nm:find("car",1,true) or nm:find("vehicle",1,true) then
                    vi=vi+1
                    if grFire(obj,{name},"vehS"..vi) then fired=fired+1 end
                    if vi>=3 then break end
                end
            end
        end
    end)
    local function vehStats(m)
        local parts,joints,anchored=0,0,0
        pcall(function()
            for _,d in pairs(m:GetDescendants()) do
                if d:IsA("BasePart") then
                    parts=parts+1
                    if d.Anchored then anchored=anchored+1 end
                elseif d:IsA("Weld") or d:IsA("WeldConstraint") or d:IsA("Motor6D") or d:IsA("Snap") or d:IsA("Hinge") or d:IsA("BallSocket") then
                    joints=joints+1
                end
            end
        end)
        return parts,joints,anchored
    end
    local function verify()
        local near=false
        pcall(function()
            for _,d in pairs(W:GetDescendants()) do
                if d:IsA("VehicleSeat") then
                    local m=d:FindFirstAncestorOfClass("Model")
                    if m then
                        local parts,joints,anchored=vehStats(m)
                        if parts>0 and (joints>0 or anchored>=parts) then
                            local okd=false
                            pcall(function() okd=(d.Position-spawnPos).Magnitude<40 end)
                            if okd then near=true break end
                        end
                    end
                end
            end
        end)
        if near then
            ntf("Vehicle","Spawned "..tostring(name).." nearby - press E to enter",5)
            return
        end
        ntf("Vehicle","Server ignored - spawn a car ONCE at the dealer with menu open, then Spawn replays it",7)
    end
    if fired>0 then
        ntf("Vehicle","Spawning "..tostring(name).." ...",3)
        task.delay(1.2,verify)
    else
        verify()
    end
end
local vehBox
local vDropBtn=Instance.new("TextButton") vDropBtn.Size=UDim2.new(1,-12,0,30) vDropBtn.Position=UDim2.new(0,6,0,0) vDropBtn.BackgroundColor3=TH.b vDropBtn.BorderSizePixel=0 vDropBtn.Text="  Select vehicle..." vDropBtn.TextColor3=TH.t vDropBtn.TextSize=11 vDropBtn.Font=Enum.Font.GothamMedium vDropBtn.TextXAlignment=Enum.TextXAlignment.Left vDropBtn.Parent=tW mkCorner(vDropBtn,6) mkStroke(vDropBtn,TH.a,1)
local vDropOpen=false local vDropdown=nil
vDropBtn.MouseButton1Click:Connect(function()
    vDropOpen=not vDropOpen
    if vDropOpen then
        if vDropdown then pcall(function() vDropdown:Destroy() end) end
        vDropdown=Instance.new("ScrollingFrame")
        local bw=vDropBtn.AbsoluteSize.X if bw<40 then bw=300 end
        vDropdown.Size=UDim2.fromOffset(bw,160) vDropdown.BackgroundColor3=TH.s vDropdown.BorderSizePixel=0 vDropdown.ScrollBarThickness=3 vDropdown.ScrollBarImageColor3=TH.a vDropdown.ZIndex=110 vDropdown.Active=true vDropdown.Parent=OVF
        vDropdown.CanvasSize=UDim2.new(0,0,0,0) vDropdown.AutomaticCanvasSize=Enum.AutomaticSize.Y vDropdown.ScrollingDirection=Enum.ScrollingDirection.Y
        mkCorner(vDropdown,6) mkStroke(vDropdown,TH.a,1) mkPadding(vDropdown,2,2,4,4)
        local bp=vDropBtn.AbsolutePosition local op=OVF.AbsolutePosition
        vDropdown.Position=UDim2.fromOffset(bp.X-op.X, bp.Y-op.Y+vDropBtn.AbsoluteSize.Y)
        local y=4
        local list=getVehicleList()
        table.sort(list, function(a,b) return a.Name:lower()<b.Name:lower() end)
        if #list==0 then
            local lbl2=Instance.new("TextLabel") lbl2.Size=UDim2.new(1,-8,0,22) lbl2.Position=UDim2.new(0,4,0,y) lbl2.BackgroundTransparency=1 lbl2.Text="  No vehicles found" lbl2.TextColor3=TH.t lbl2.TextSize=11 lbl2.Font=Enum.Font.Gotham lbl2.TextXAlignment=Enum.TextXAlignment.Left lbl2.Parent=vDropdown
        end
        for _,m in ipairs(list) do
            local o=Instance.new("TextButton") o.Size=UDim2.new(1,-8,0,24) o.Position=UDim2.new(0,4,0,y) o.BackgroundColor3=TH.b o.BorderSizePixel=0 o.Text="  "..m.Name o.TextColor3=TH.t o.TextSize=11 o.Font=Enum.Font.Gotham o.TextXAlignment=Enum.TextXAlignment.Left o.Parent=vDropdown mkCorner(o,4)
            o.MouseButton1Click:Connect(function()
                vehBox.Text=m.Name
                vDropBtn.Text="  > "..m.Name
                vDropOpen=false if vDropdown then vDropdown:Destroy() vDropdown=nil end
                ntf("Vehicle","Selected: "..m.Name,3)
            end)
            y=y+28
        end
    else
        if vDropdown then vDropdown:Destroy() vDropdown=nil end
    end
end)
vehBox=Instance.new("TextBox") vehBox.Size=UDim2.new(1,-12,0,28) vehBox.Position=UDim2.new(0,6,0,0) vehBox.BackgroundColor3=TH.b vehBox.BorderSizePixel=0 vehBox.PlaceholderText="Vehicle name or select above / empty for random" vehBox.PlaceholderColor3=Color3.fromRGB(100,100,120) vehBox.Text="" vehBox.TextColor3=TH.t vehBox.TextSize=11 vehBox.Font=Enum.Font.Gotham vehBox.ClearTextOnFocus=false vehBox.Parent=tW mkCorner(vehBox,6)
btn(tW,"Spawn Vehicle Next to Me",function() spawnVehicle(vehBox.Text) end,"spawnveh")
btn(tW,"Spawn Random Vehicle",function() spawnVehicle("") end,"spawnrand")
btn(tW,"Despawn Nearest Vehicle",function()
    pcall(function()
        local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local best=nil
        local bestD=40
        for _,m in pairs(W:GetChildren()) do
            if m:IsA("Model") and m:FindFirstChildOfClass("VehicleSeat") then
                local seat=m:FindFirstChildOfClass("VehicleSeat")
                if seat then
                    local d=(seat.Position-hrp.Position).Magnitude
                    if d<bestD then bestD=d best=m end
                end
            end
        end
        if best then
            local fired=0
            -- try remotes (visible to all if server accepts)
            local r=findRemote("Cars.CarDealer") or findRemote("DespawnVehicle")
            if r then
                if grFire(r,{"Despawn",best.Name},"veh") then fired=fired+1 end
                if grFire(r,{"Delete",best.Name},"veh") then fired=fired+1 end
                if grFire(r,{"Remove",best.Name},"veh") then fired=fired+1 end
                if grFire(r,{best.Name,"Despawn"},"veh") then fired=fired+1 end
            end
            for _,obj in pairs(RS:GetDescendants()) do
                if obj:IsA("RemoteEvent") and string.lower(obj.Name):find("despawn",1,true) then
                    if grFire(obj,{best.Name},"veh2") then fired=fired+1 end
                    if grFire(obj,{best},"veh2") then fired=fired+1 end
                    if fired>3 then break end
                end
            end
            -- client fallback (only you see)
            pcall(function() best:Destroy() end)
            if fired>0 then ntf("Vehicle","Despawed "..best.Name.." (visible to all, "..fired.." remotes)",4)
            else ntf("Vehicle","Despawed "..best.Name.." (client only - others still see it)",4) end
        else
            ntf("Vehicle","No vehicle nearby",4)
        end
    end)
end,"despawnveh")
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
                o.Text="  "..getDisplayName(pp)
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
                o.MouseButton1Click:Connect(function() ST.selectedPlayer=pp pDropBtn.Text="  > "..getDisplayName(pp) pDropOpen=false if pDropdown then pDropdown:Destroy() pDropdown=nil end end)
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
lbl(tP,">> FORCE JOB (Dropdown)")
ST.selectedJob=nil
local jDropBtn=Instance.new("TextButton") jDropBtn.Size=UDim2.new(1,-12,0,32) jDropBtn.Position=UDim2.new(0,6,0,0) jDropBtn.BackgroundColor3=TH.b jDropBtn.BorderSizePixel=0 jDropBtn.Text="  Select job..." jDropBtn.TextColor3=TH.t jDropBtn.TextSize=12 jDropBtn.Font=Enum.Font.GothamMedium jDropBtn.TextXAlignment=Enum.TextXAlignment.Left jDropBtn.Parent=tP mkCorner(jDropBtn,6) mkStroke(jDropBtn,TH.a,1)
local jDropOpen=false local jDropdown=nil
local function getTeamsList()
    local list={}
    local seen={}
    local function add(nm,obj)
        if not nm or nm=="" then return end
        local k=string.lower(nm)
        if seen[k] then return end
        seen[k]=true
        table.insert(list,obj or {Name=nm,TeamColor=Color3.new(1,1,1)})
    end
    pcall(function()
        for _,tm in pairs(game:GetService("Teams"):GetTeams()) do add(tm.Name,tm) end
    end)
    pcall(function()
        for _,tm in pairs(game:GetService("Teams"):GetChildren()) do if tm:IsA("Team") then add(tm.Name,tm) end end
    end)
    pcall(function()
        for _,root in ipairs({RS,W}) do
            for _,f in ipairs(root:GetChildren()) do
                local ln=string.lower(f.Name)
                if (f:IsA("Folder") or f:IsA("Configuration")) and (ln=="jobs" or ln=="joblist" or ln=="jobcenter" or ln=="roles" or ln=="teams" or ln=="work") then
                    for _,ch in ipairs(f:GetChildren()) do add(ch.Name) end
                end
            end
        end
    end)
    for _,nm in ipairs({"Police","EMT","Medic","Taxi","Mafia","Gang","Mechanic","Trucker","Unemployed","Civilian","CREWMATE","EMPLOYEE"}) do
        add(nm)
    end
    return list
end
jDropBtn.MouseButton1Click:Connect(function()
    jDropOpen=not jDropOpen
    if jDropOpen then
        if jDropdown then pcall(function() jDropdown:Destroy() end) end
        jDropdown=Instance.new("ScrollingFrame")
        local bw=jDropBtn.AbsoluteSize.X if bw<40 then bw=300 end
        jDropdown.Size=UDim2.fromOffset(bw,150) jDropdown.BackgroundColor3=TH.s jDropdown.BorderSizePixel=0 jDropdown.ScrollBarThickness=3 jDropdown.ScrollBarImageColor3=TH.a jDropdown.ZIndex=110 jDropdown.Active=true jDropdown.Parent=OVF
        jDropdown.CanvasSize=UDim2.new(0,0,0,0) jDropdown.AutomaticCanvasSize=Enum.AutomaticSize.Y jDropdown.ScrollingDirection=Enum.ScrollingDirection.Y
        mkCorner(jDropdown,6) mkStroke(jDropdown,TH.a,1) mkPadding(jDropdown,2,2,4,4)
        local bp=jDropBtn.AbsolutePosition local op=OVF.AbsolutePosition
        jDropdown.Position=UDim2.fromOffset(bp.X-op.X, bp.Y-op.Y+jDropBtn.AbsoluteSize.Y)
        local y=4
        local list=getTeamsList()
        for _,tm in ipairs(list) do
            local tname=tm.Name or tostring(tm)
            local o=Instance.new("TextButton") o.Size=UDim2.new(1,-8,0,24) o.Position=UDim2.new(0,4,0,y) o.BackgroundColor3=TH.b o.BorderSizePixel=0 o.Text="  "..tname o.TextColor3=TH.t o.TextSize=11 o.Font=Enum.Font.Gotham o.TextXAlignment=Enum.TextXAlignment.Left o.Parent=jDropdown mkCorner(o,4)
            o.MouseButton1Click:Connect(function()
                ST.selectedJob=tname
                ST.selectedJobObj=tm
                jDropBtn.Text="  > "..tname
                jDropOpen=false if jDropdown then jDropdown:Destroy() jDropdown=nil end
                ntf("Job","Selected: "..tname,3)
            end)
            y=y+28
        end
    else
        if jDropdown then jDropdown:Destroy() jDropdown=nil end
    end
end)
local function doForceJob(targetPl, jobName)
    if not jobName or jobName=="" then jobName=ST.selectedJob end
    if not jobName or jobName=="" then ntf("Job","Select a job first",4) return end
    local target=targetPl or LP
    local jobPos=nil
    local fired=0
    pcall(function()
        local lg=ST._learnLog
        local verbs={apply=1,change=1,set=1,select=1,join=1,choose=1,get=1,switch=1,work=1,accept=1,job=1,team=1,setjob=1,changejob=1,start=1,enter=1}
        local jDone=false
        local function replayFor(sub)
            if jDone then return true end
            if not lg then return false end
            for path,arr in pairs(lg) do
                if string.find(string.lower(path),sub,1,true) then
                    local rec=arr[1]
                    if rec and axLearnInst(rec) then
                        local newArgs={}
                        local okSub=false
                        for i,a in ipairs(rec.args) do
                            if typeof(a)=="string" then
                                local lv=string.lower(a)
                                if verbs[lv] or string.find(a,"%d") then
                                    newArgs[i]=a
                                else
                                    newArgs[i]=jobName okSub=true
                                end
                            elseif typeof(a)=="Vector3" and jobPos then
                                newArgs[i]=jobPos okSub=true
                            else
                                newArgs[i]=a
                            end
                        end
                        if okSub then
                            jDone=true
                            if grFire(rec.inst,newArgs,"learnJ") then fired=fired+1 end
                            return true
                        end
                    end
                end
            end
            return false
        end
        if not replayFor("changejob") and not replayFor("changeteam") and not replayFor("job") and not replayFor("team") and not replayFor("career") then
            local r=findRemote("Teams.ChangeJob") or findRemote("Teams.ChangeTeam") or findRemote("ChangeJob") or findRemote("ChangeTeam")
            if r then
                local teamObj=nil
                pcall(function()
                    for _,tm in pairs(game:GetService("Teams"):GetTeams()) do if tm.Name==jobName then teamObj=tm break end end
                    if not teamObj then for _,tm in pairs(game:GetService("Teams"):GetChildren()) do if tm.Name==jobName and tm:IsA("Team") then teamObj=tm break end end end
                end)
                if teamObj then
                    if grFire(r,{teamObj},"jobCJ") then fired=fired+1 end
                else
                    if grFire(r,{jobName},"jobCJ") then fired=fired+1 end
                end
            end
        end
        task.wait(0.3)
        if not replayFor("jobcenter") then
            local jc=findRemote("JobCenter.JobCenter") or findRemote("JobCenter")
            if jc then
                if grFire(jc,{jobName},"jobJC") then fired=fired+1 end
            end
        end
    end)
    if fired>0 then
        ntf("Job",(target==LP and "Self" or target.DisplayName).." -> "..jobName.." ("..fired.." remotes)",4)
    else
        -- fallback client TeamColor change (visible only to you, but at least UI)
        pcall(function()
            if target==LP and target.Character then
                local hum=target.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    -- try to find team color
                    for _,tm in pairs(game:GetService("Teams"):GetTeams()) do
                        if tm.Name==jobName then
                            pcall(function() LP.Team=tm end)
                            break
                        end
                    end
                end
            end
        end)
        ntf("Job","Tried "..jobName.." on "..(target==LP and "self" or target.DisplayName).." - check team",4)
    end
end
btn(tP,"Force Job Self",function() doForceJob(LP, ST.selectedJob) end,"forcejobself")
btn(tP,"Force Job Selected Player",function()
    local t=ST.selectedPlayer
    if not t then ntf("Job","Select a player first",4) return end
    doForceJob(t, ST.selectedJob)
end,"forcejobother")
sep(tP)
lbl(tP,">> PLAYER ACTIONS")
btn(tP,"Goto Player",function() if ST.selectedPlayer and ST.selectedPlayer.Character and LP.Character then local t2=ST.selectedPlayer.Character:FindFirstChild("HumanoidRootPart") local m=LP.Character:FindFirstChild("HumanoidRootPart") if t2 and m then safeTeleport(t2.Position+Vector3.new(3,1,0)) end end end,"goto")
sep(tP)
lbl(tP,">> SPECTATE + ESP")
btn(tP,"Spectate",function() if ST.selectedPlayer and ST.selectedPlayer.Character then local h=ST.selectedPlayer.Character:FindFirstChildOfClass("Humanoid") if h then CAM.CameraSubject=h CAM.CameraType=Enum.CameraType.Custom ST.spectating=ST.selectedPlayer end end end,"spec")
btn(tP,"Stop Spectate",function()
    local wasOvh=ST.spectateOverhead
    stopOverhead(false)
    ST.spectating=nil
    ST.spectateOverhead=false
    ST._ovhActive=false
    pcall(function()
        game:GetService("ContextActionService"):UnbindAction("AxOvhSink")
    end)
    if not ST.freeCam then
        unfreezeLocalFromCam()
        restoreLocalCamera()
    end
    ntf("Spectate",wasOvh and "Overhead stopped - camera on you" or "Spectate stopped - camera on you")
end,"stopspec")
btn(tP,"Spectate: Next Player",function() local plrs=P:GetPlayers() local idx=1 for i,pp in pairs(plrs) do if pp==ST.spectating then idx=i break end end local nextI=idx+1 if nextI>#plrs then nextI=1 end local np=plrs[nextI] if np~=LP and np.Character then local h=np.Character:FindFirstChildOfClass("Humanoid") if h then if not ST.spectateOverhead then CAM.CameraSubject=h CAM.CameraType=Enum.CameraType.Custom end ST.spectating=np ST.ovhInit=false ntf("Spectate","Following: "..np.DisplayName) end end end,"specnext")
btn(tP,"Spectate: Prev Player",function() local plrs=P:GetPlayers() local idx=1 for i,pp in pairs(plrs) do if pp==ST.spectating then idx=i break end end local prevI=idx-1 if prevI<1 then prevI=#plrs end local pp2=plrs[prevI] if pp2~=LP and pp2.Character then local h=pp2.Character:FindFirstChildOfClass("Humanoid") if h then if not ST.spectateOverhead then CAM.CameraSubject=h CAM.CameraType=Enum.CameraType.Custom end ST.spectating=pp2 ST.ovhInit=false ntf("Spectate","Following: "..pp2.DisplayName) end end end,"specprev")
btn(tP,"Spectate: Overhead",function()
    if ST.selectedPlayer and ST.selectedPlayer.Character and ST.selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        ST.spectating=ST.selectedPlayer
    end
    if not ST.spectating or not ST.spectating.Parent or not ST.spectating.Character or not ST.spectating.Character:FindFirstChild("HumanoidRootPart") then
        local best=nil
        local bd=math.huge
        local mp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        for _,pp in pairs(P:GetPlayers()) do
            if pp~=LP and pp.Character and pp.Character:FindFirstChild("HumanoidRootPart") and mp then
                local d=(pp.Character.HumanoidRootPart.Position-mp.Position).Magnitude
                if d<bd then bd=d best=pp end
            end
        end
        ST.spectating=best
    end
    if not ST.spectating or not ST.spectating.Character or not ST.spectating.Character:FindFirstChild("HumanoidRootPart") then
        ntf("Spectate","No other players online",4) return
    end
    if ST.spectateOverhead then
        stopOverhead(true)
    else
        setFreeCam(false)
        ST.spectateOverhead=true
        ST._ovhActive=true
        ST.ovhYaw=0
        ST.ovhPitch=1.45
        ST.ovhDist=32
        ST.ovhInit=true
        ovhLastT=tick()-1
        ovhPrevM=nil
        table.clear(FC_KEYS)
        ensureCamInputConns()
        freezeLocalForCam()
        ovhPrevM=nil
        pcall(function() U.MouseBehavior=Enum.MouseBehavior.Default end)
        pcall(function()
            local CAS=game:GetService("ContextActionService")
            CAS:UnbindAction("AxOvhSink")
            CAS:BindActionAtPriority("AxOvhSink",function(an,st,io)
                local kc=io and io.KeyCode
                if typeof(kc)=="EnumItem" and kc~=Enum.KeyCode.Unknown then
                    if st==Enum.UserInputState.Begin then
                        FC_KEYS[kc]=true
                    elseif st==Enum.UserInputState.End or st==Enum.UserInputState.Cancel then
                        FC_KEYS[kc]=nil
                    end
                end
                return Enum.ContextActionResult.Sink
            end,false,Enum.ContextActionPriority.High.Value,Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Space,Enum.KeyCode.LeftControl,Enum.KeyCode.LeftShift)
        end)
        pcall(function()
            local cam=W.CurrentCamera or CAM
            if cam then CAM=cam applyOverhead(cam) end
        end)
        ntf("Spectate","Overhead ON - "..ST.spectating.DisplayName)
    end
end,"specover")
table.insert(allToggles,tog(tP,"ESP",function() return ST.esp end,function() ST.esp=not ST.esp if ST.esp then for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and not pp.Character:FindFirstChild("AxESP") then local hl=Instance.new("Highlight") hl.Name="AxESP" hl.FillColor=CFG.ESPColor hl.FillTransparency=CFG.ESPFillAlpha hl.OutlineColor=CFG.ESPOutlineColor hl.OutlineTransparency=CFG.ESPOutlineEnabled and 0 or 1 hl.Enabled=CFG.ESPFillEnabled hl.Parent=pp.Character ST.espList[pp.UserId]=hl end end else for id,hl in pairs(ST.espList) do if hl and hl.Parent then hl:Destroy() end ST.espList[id]=nil end end end,"esp"))
sep(tP)
lbl(tP,">> ESP SETTINGS")
btn(tP,"Open ESP Settings / Palette",function()
    if ST.palSG then pcall(function() ST.palSG:Destroy() end) ST.palSG=nil return end
    local SG4=Instance.new("ScreenGui") SG4.Name="AxPalette" SG4.ResetOnSpawn=false SG4.DisplayOrder=1000 SG4.ZIndexBehavior=Enum.ZIndexBehavior.Sibling SG4.IgnoreGuiInset=true pcall(function() if gethui then SG4.Parent=gethui() end end) if not SG4.Parent then pcall(function() SG4.Parent=CG end) end if not SG4.Parent then SG4.Parent=LP:WaitForChild("PlayerGui") end ST.palSG=SG4
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
table.insert(allToggles,tog(tP,"MaceTP",function() return ST.maceTP end,function() ST.maceTP=not ST.maceTP ntf("MaceTP",ST.maceTP and "ON - Follow selected, else nearest" or "OFF") end,"macetp"))
btn(tP,"MaceTP: Closer",function() if not ST.maceTPOffset then ST.maceTPOffset=3 end ST.maceTPOffset=ST.maceTPOffset-1 ntf("MaceTP","Offset: "..ST.maceTPOffset) end,"mzcloser")
btn(tP,"MaceTP: Further",function() if not ST.maceTPOffset then ST.maceTPOffset=3 end ST.maceTPOffset=ST.maceTPOffset+1 ntf("MaceTP","Offset: "..ST.maceTPOffset) end,"mzfurther")
sep(tP)
lbl(tP,">> MARKER SYSTEM")
btn(tP,"Set Marker Here",function() pcall(function() if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then if ST.markerObj then ST.markerObj:Destroy() end local p=Instance.new("Part") p.Name="AxMarker" p.Size=Vector3.new(4,0.2,4) p.Anchored=true p.CanCollide=false p.Material=Enum.Material.Neon p.Color=Color3.fromRGB(0,150,255) p.Transparency=0.3 p.Position=LP.Character.HumanoidRootPart.Position-Vector3.new(0,3,0) p.Parent=W ST.markerObj=p local bb=Instance.new("BillboardGui") bb.Size=UDim2.new(0,100,0,40) bb.StudsOffset=Vector3.new(0,3,0) bb.AlwaysOnTop=true bb.Parent=p local tl=Instance.new("TextLabel") tl.Size=UDim2.new(1,0,1,0) tl.BackgroundTransparency=1 tl.Text="MARKER" tl.TextColor3=Color3.fromRGB(0,200,255) tl.TextSize=14 tl.Font=Enum.Font.GothamBold tl.Parent=bb ntf("Marker","Set!") end end) end,"setmarker")
btn(tP,"TP to Marker",function() pcall(function() if ST.markerObj and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then safeTeleport(ST.markerObj.Position+Vector3.new(0,3,0)) end end) end,"tpmarker")
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
local wpSelBtns={}
for i=1,5 do
    local b=Instance.new("TextButton") b.Size=UDim2.new(0,36,0,22) b.Position=UDim2.new(0,(i-1)*40+4,0.5,2) b.BackgroundColor3=wpColors[i] b.BackgroundTransparency=0.6 b.BorderSizePixel=0 b.Text="WP"..i b.TextColor3=TH.t b.TextSize=10 b.Font=Enum.Font.GothamBold b.Parent=wpFrame mkCorner(b,4)
    b.MouseButton1Click:Connect(function() ST.wpSelected=i updateWPLbl() ntf("WP","Selected WP"..i) end)
    wpSelBtns[i]=b
end
btn(tP,"Set Selected WP",function() pcall(function() if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then local id=ST.wpSelected ST.waypoints[id]=LP.Character.HumanoidRootPart.Position+Vector3.new(0,2,0) createWPVisual(id,ST.waypoints[id]) ntf("Waypoint","Set WP"..id.."!") end end) end,"setwp")
btn(tP,"TP to Selected WP",function() pcall(function() local id=ST.wpSelected if ST.waypoints[id] and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then safeTeleport(ST.waypoints[id]) end end) end,"tpwp")
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
        local ek=findRemote("Hospital.EKAB")
        if ek then grFire(ek,{LP},"heal") grFire(ek,{LP.Position},"heal") grFire(ek,{},"heal") fired=fired+3 end
    end)
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
            applyGodLocal()
            ST._godHC=hum.HealthChanged:Connect(function(h)
                if not ST.godmodeLoop then return end
                pcall(function()
                    if hum.MaxHealth<10000000 then hum.MaxHealth=10000000 end
                    if h<=0 or h<hum.MaxHealth then hum.Health=hum.MaxHealth end
                    if h<=0 then pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
                end)
            end)
        end
    end)
end
local function fireGodRemotes(on)
    pcall(function()
        if not on then
            local hd=findRemote("HDAdminHDClient.Signals.RequestCommand")
            if hd then
                grFire(hd,{"ungod"},"god")
                grFire(hd,{":ungod"},"god")
            end
            local inv=findRemote("Inventory.Inventory")
            if inv then
                grFire(inv,{"heal"},"god")
                grFire(inv,{100},"god")
            end
            return
        end
        local hd=findRemote("HDAdminHDClient.Signals.RequestCommand")
        if hd then
            local sets={
                {"god"},{":god"},{"godmode"}
            }
            for _,args in ipairs(sets) do grFire(hd,args,"god") end
        end
        local hd2=findRemote("HDAdminHDClient.Signals.ExecuteClientCommand")
        if hd2 then
            grFire(hd2,{"god"},"god")
            grFire(hd2,{"godmode"},"god")
        end
        local inv=findRemote("Inventory.Inventory")
        if inv then
            grFire(inv,{"heal"},"god")
            grFire(inv,{"godmode",true},"god")
            grFire(inv,{"sethealth",10000000},"god")
        end
        syncServerGod()
    end)
end
table.insert(allToggles,tog(tEx,"Godmode Loop",function() return ST.godmodeLoop end,function() ST.godmodeLoop=not ST.godmodeLoop if ST.godmodeLoop then applyGodLocal() bindGodHC() fireGodRemotes(true) ntf("Godmode","ON - 10M HP client + HDAdmin/Inventory god remotes") else if ST._godHC then pcall(function() ST._godHC:Disconnect() end) ST._godHC=nil end clearGodLocal() fireGodRemotes(false) ntf("Godmode","OFF") end end,"godloop"))
table.insert(allToggles,tog(tEx,"Spheres on Click",function() return ST.spheresOn end,function() ST.spheresOn=not ST.spheresOn ntf("Spheres",ST.spheresOn and "ON - LMB throws neon spheres" or "OFF") end,"spheres"))
table.insert(allToggles,tog(tEx,"Shot Tracer (laser)",function() return ST.shotTracer end,function() ST.shotTracer=not ST.shotTracer ntf("Tracer",ST.shotTracer and "ON - LMB draws tracer beam" or "OFF - no lasers on click") end,"tracer"))
function equipAnyTool()
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
function nearestPl(maxD)
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
local GR_ITEMS={"Bandage","Bread","Cheeseburger","Water","LockPick","Broom","Bronze Pickaxe","Gold","Pill"}
function cloneToolFull(tool, destBp)
    if not tool or not tool:IsA("Tool") or not destBp then return false end
    local okC=false
    pcall(function()
        local cl=tool:Clone()
        cl.Name=tool.Name
        for _,d in pairs(cl:GetDescendants()) do
            if d:IsA("BasePart") then d.Anchored=false d.CanCollide=false pcall(function() d.Massless=true end) end
            if d:IsA("LocalScript") or d:IsA("Script") then pcall(function() d.Disabled=false end) end
        end
        local h=cl:FindFirstChild("Handle")
        if not h then
            for _,v in pairs(cl:GetChildren()) do if v:IsA("BasePart") then v.Name="Handle" h=v break end end
        end
        if not h then cl:Destroy() return end
        pcall(function() cl.CanBeDropped=true cl.ManualActivationOnly=false end)
        cl.Parent=destBp
        okC=true
    end)
    return okC
end
function fireWeaponActivated()
    pcall(function()
        local r=findRemote("WeaponsSystem.Network.WeaponActivated")
        if not r then return end
        local tool=LP.Character and LP.Character:FindFirstChildOfClass("Tool")
        local nm=tool and tool.Name or "FN FAL"
        grFire(r,{nm},"wact")
        grFire(r,{nm,true},"wact")
        grFire(r,{tool},"wact")
    end)
end
function giveGRItem(name, kind, noFire)
    if ST._learnPending then
        ST._learnPending=nil
        pcall(function() ntf("Learn","Inventory args learned - Give now replays them",5) end)
    end
    local existing=nil
    pcall(function()
        local c=LP.Character
        local o=c and c:FindFirstChild(name)
        if o and o:IsA("Tool") then existing=o end
        if not existing then
            local bp=LP:FindFirstChild("Backpack")
            if bp then
                local ln=string.lower(name)
                for _,v in pairs(bp:GetChildren()) do
                    if v:IsA("Tool") and string.lower(v.Name)==ln then existing=v break end
                end
            end
        end
    end)
    if existing then
        if not noFire then
            pcall(function()
                local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if hum and existing.Parent==LP:FindFirstChild("Backpack") then hum:EquipTool(existing) end
            end)
        end
        return 1
    end
    local n=0
    local didReplay=false
    pcall(function()
        if noFire then return end
        local arm=findRemote("Armory.RemoteEvent")
        local inv=findRemote("Inventory.Inventory")
        local sm=findRemote("SupermarketEvent.Triggered") or findRemote("SupermarketEvent.BuyItem")
        local jc=findRemote("JobCenter.JobCenter")
        local rk="give"..(kind or "w")
        pcall(function()
            local lg=ST._learnLog
            if not lg then return end
            local verbSet={buy=1,sell=1,add=1,use=1,equip=1,give=1,save=1,set=1,drop=1,take=1,select=1,spawn=1,craft=1,collect=1,pickup=1,pick=1,eat=1,heal=1,store=1,load=1,get=1,put=1,trade=1,accept=1,apply=1,open=1}
            for path,arr in pairs(lg) do
                local lp=string.lower(path)
                if string.find(lp,"inventory",1,true) or string.find(lp,"armory",1,true) or string.find(lp,"supermarket",1,true) or string.find(lp,"shop",1,true) or string.find(lp,"store",1,true) then
                    local rec=arr[1]
                    if rec and axLearnInst(rec) then
                        local newArgs={}
                        local sub=false
                        for i,a in ipairs(rec.args) do
                            if typeof(a)=="string" then
                                local lv=string.lower(a)
                                if verbSet[lv]==1 or string.find(a,"%d") or string.find(a,"_",1,true) then
                                    newArgs[i]=a
                                else
                                    newArgs[i]=name sub=true
                                end
                            else
                                newArgs[i]=a
                            end
                        end
                        if sub then grFire(rec.inst,newArgs,"learn") didReplay=true end
                    end
                end
            end
        end)
        if kind=="weapon" or kind==nil then
            if arm then
                grFire(arm,{"buy",name},rk)
                grFire(arm,{name},"give")
                grFire(arm,{"give",name},"give")
            end
            if inv then
                grFire(inv,{"add",name},"give")
                grFire(inv,{name},"give")
                grFire(inv,{"save",name},"give")
                grFire(inv,{"save",name,1},"give")
            end
        else
            if sm then
                grFire(sm,{"buy",name},"give")
                grFire(sm,name,"give")
            end
            if inv then
                grFire(inv,{"add",name},"give")
                grFire(inv,{name},"give")
                grFire(inv,{"save",name},"give")
                grFire(inv,{"save",name,1},"give")
            end
            if jc then grFire(jc,name,"give") end
        end
    end)
    if not noFire then
        pcall(function()
            if didReplay then
                ntf("Give","Using real shop remote (learned) - if others dont see the item, server rejected the replay",6)
            else
                ntf("Give","LOCAL copy only - make ONE legit purchase in-game with menu open first, then Give uses the real remote",7)
            end
        end)
    end
    pcall(function()
        local bp=LP:FindFirstChild("Backpack")
        if not bp then return end
        ST._toolCache=ST._toolCache or {}
        local function findTemplate(nm)
            if ST._toolCache[nm] and ST._toolCache[nm].Parent then return ST._toolCache[nm] end
            local lower=string.lower(nm)
            local exact=nil
            local partial=nil
            local function consider(obj)
                if not obj or not obj:IsA("Tool") then return end
                local on=string.lower(obj.Name)
                if on==lower then exact=obj
                elseif not partial and string.find(on,lower,1,true) then partial=obj end
            end
            local roots={}
            pcall(function() table.insert(roots,game:GetService("StarterPack")) end)
            pcall(function() table.insert(roots,game:GetService("StarterGear")) end)
            pcall(function() table.insert(roots,RS) end)
            pcall(function() table.insert(roots,W) end)
            pcall(function() local ss=game:GetService("ServerStorage") if ss then table.insert(roots,ss) end end)
            pcall(function() local sa=game:GetService("ServerScriptService") if sa then table.insert(roots,sa) end end)
            pcall(function() local sp=game:GetService("StarterPlayer") if sp then local sc=sp:FindFirstChild("StarterCharacterTools") if sc then table.insert(roots,sc) end end end)
            for _,src in ipairs(roots) do
                pcall(function()
                    for _,obj in pairs(src:GetDescendants()) do
                        consider(obj)
                        if exact then break end
                    end
                end)
                if exact then break end
            end
            if not exact then
                pcall(function()
                    for _,pl in pairs(P:GetPlayers()) do
                        if pl~=LP then
                            local pb=pl:FindFirstChild("Backpack")
                            if pb then
                                for _,obj in pairs(pb:GetChildren()) do consider(obj) end
                            end
                            if pl.Character then
                                for _,obj in pairs(pl.Character:GetChildren()) do consider(obj) end
                            end
                        end
                        if exact then break end
                    end
                end)
            end
            local found=exact or partial
            if found then ST._toolCache[nm]=found end
            return found
        end
        local tpl=findTemplate(name)
        local got=false
        if tpl and cloneToolFull(tpl, bp) then n=n+1 got=true end
        if not got then
            local alt=nil
            pcall(function() alt=findTemplate(string.lower(name)) end)
            if alt and cloneToolFull(alt, bp) then n=n+1 got=true end
        end
        if not got then
            -- fallback visible placeholder so it at least appears and can be equipped
            pcall(function()
                local t=Instance.new("Tool")
                t.Name=name
                t.CanBeDropped=true
                t.RequiresHandle=true
                t.ManualActivationOnly=false
                t.Enabled=true
                local h=Instance.new("Part")
                h.Name="Handle"
                h.Size=Vector3.new(0.5,0.7,0.4)
                h.CanCollide=false
                h.Massless=true
                local m=Instance.new("SpecialMesh")
                m.MeshType=Enum.MeshType.Brick
                m.Scale=Vector3.new(0.4,0.4,0.4)
                m.Parent=h
                h.Parent=t
                t.Parent=bp
                n=n+1
                got=true
            end)
        end
        -- keep in inventory + auto-equip (so it stays and can be re-equipped)
        if got then
            ST._givenItems=ST._givenItems or {}
            ST._givenItems[name]=kind or "w"
            pcall(function()
                task.delay(0.25, function()
                    pcall(function()
                        if LP.Character and not LP.Character:FindFirstChildOfClass("Tool") then
                            local hum=LP.Character:FindFirstChildOfClass("Humanoid")
                            if hum then
                                local toEquip=nil
                                for _,v in pairs(bp:GetChildren()) do
                                    if v:IsA("Tool") and v.Name:lower()==string.lower(name) then toEquip=v break end
                                end
                                if not toEquip then
                                    for _,v in pairs(bp:GetChildren()) do if v:IsA("Tool") then toEquip=v break end end
                                end
                                if toEquip then
                                    hum:EquipTool(toEquip)
                                    if not LP.Character:FindFirstChild(toEquip.Name) then
                                        pcall(function() toEquip.Parent=LP.Character end)
                                    end
                                end
                            end
                        end
                    end)
                    -- also try Inventory equip remote for custom inventory
                    if not noFire then pcall(function()
                        local inv=findRemote("Inventory.Inventory")
                        if inv then
                            grFire(inv,{"equip",name},"equip")
                            grFire(inv,{"use",name},"equip")
                        end
                    end) end
                end)
            end)
        end
    end)
    return n
end
pcall(function()
    pcall(function()
        local bpc=LP:FindFirstChild("Backpack")
        local oldx=bpc and bpc:FindFirstChild("AxWatch")
        if oldx then oldx:Destroy() end
    end)
    local function watchBp(bp)
        if not bp then return end
        ST._bpWatched=ST._bpWatched or {}
        if ST._bpWatched[bp] then return end
        ST._bpWatched[bp]=true
        bp.ChildRemoved:Connect(function(ch)
            if not ch or not ch:IsA("Tool") then return end
            if not ST._givenItems then return end
            local key=string.lower(ch.Name)
            local kind=nil
            for nm,k in pairs(ST._givenItems) do
                if string.lower(nm)==key then kind=k break end
            end
            if not kind then return end
            ST._recloneT=ST._recloneT or {}
            if tick()-(ST._recloneT[key] or 0)<6 then return end
            ST._recloneT[key]=tick()
            task.delay(0.7,function()
                pcall(function()
                    local gone=true
                    local c2=LP.Character
                    local b2=LP:FindFirstChild("Backpack")
                    if c2 and c2:FindFirstChild(ch.Name) then gone=false end
                    if b2 and b2:FindFirstChild(ch.Name) then gone=false end
                    if gone then giveGRItem(ch.Name,kind,true) end
                end)
            end)
        end)
    end
    watchBp(LP:FindFirstChild("Backpack"))
    LP.ChildAdded:Connect(function(c)
        if c and c.Name=="Backpack" then task.defer(function() pcall(function() watchBp(c) end) end) end
    end)
end)
function doGreenSteal()
    if not cd() then return end
    equipAnyTool()
    local t=ST.selectedPlayer
    if not t or t==LP or not t.Character then t=nearestPl(15) end
    if not t then ntf("Steal","No player nearby / not selected",4) return end
    pcall(function()
        local my=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local th=t.Character and t.Character:FindFirstChild("HumanoidRootPart")
        if my and th then
            local d=(my.Position-th.Position).Magnitude
            if d>12 and d<80 then
                my.CFrame=CFrame.lookAt(my.Position,Vector3.new(th.Position.X,my.Position.Y,th.Position.Z))
            end
        end
    end)
    local cloned=0
    pcall(function()
        local bp=LP:FindFirstChild("Backpack")
        if not bp then return end
        local vbp=t:FindFirstChild("Backpack")
        local function grab(tool)
            if not tool or not tool:IsA("Tool") or cloned>=5 then return end
            if cloneToolFull(tool, bp) then cloned=cloned+1 end
        end
        if vbp then
            for _,tool in pairs(vbp:GetChildren()) do grab(tool) end
        end
        if t.Character then
            for _,tool in pairs(t.Character:GetChildren()) do grab(tool) end
        end
        if cloned>0 then
            task.delay(0.2, function()
                pcall(function()
                    local tools=bp:GetChildren()
                    for i=#tools,1,-1 do
                        local tool=tools[i]
                        if tool:IsA("Tool") then
                            pcall(function() LP.Character:EquipTool(tool) end)
                            break
                        end
                    end
                end)
                fireWeaponActivated()
            end)
        end
    end)
    pcall(function()
        -- real steal: try many arg combos so server actually transfers (not just duplicate)
        local inv=findRemote("Inventory.Inventory")
        if inv then
            for _,a in ipairs({t, t.UserId, t.Name, t.Character}) do
                if a then
                    grFire(inv,{"steal",a},"steal")
                    grFire(inv,{"pickpocket",a},"steal")
                    grFire(inv,{"rob",a},"steal")
                end
            end
            grFire(inv,{"steal",t.UserId},"steal")
            grFire(inv,{"steal",t.Name},"steal")
        end
        local arm=findRemote("Armory.RemoteEvent")
        if arm then
            for _,a in ipairs({t, t.UserId, t.Name}) do
                if a then grFire(arm,{"steal",a},"steal") grFire(arm,{"rob",a},"steal") end
            end
            grFire(arm,{"steal",t.Name},"steal")
        end
        local thief=findRemote("ThiefSystem.RemoteEvent")
        if thief then
            grFire(thief,{"steal",t},"steal")
            grFire(thief,{"steal",t.Name},"steal")
        end
    end)
    local fired=0
    local budget=6
    local function tryFire(r,args)
        if not r or fired>=budget then return end
        if grFire(r,args,"steal") then fired=fired+1 end
    end
    pcall(function()
        local inv=findRemote("Inventory.Inventory")
        local arm=findRemote("Armory.RemoteEvent")
        local thief=findRemote("ThiefSystem.RemoteEvent")
        local claim=findRemote("ClaimEvent")
        local sets={
            {"steal",t.UserId},
            {"steal",t.Name},
            {"rob",t.Name},
            {"pickpocket",t.Name},
            {"transfer",t.UserId,LP.UserId}
        }
        for _,args in ipairs(sets) do
            tryFire(inv,args)
            tryFire(arm,args)
            tryFire(thief,args)
            if claim then tryFire(claim,args) end
        end
    end)
    pcall(function()
        local scanned=0
        local keys={"steal","thief","pickpocket","rob","transfer","claim"}
        for _,parent in ipairs({RS}) do
            if fired>=budget then break end
            for _,d in pairs(parent:GetDescendants()) do
                if fired>=budget or scanned>=4 then break end
                if (d:IsA("RemoteEvent") or d:IsA("RemoteFunction")) then
                    local nm=d.Name:lower()
                    local hitk=false
                    for _,k in ipairs(keys) do
                        if nm:find(k,1,true) and not nm:find("group") and not nm:find("anticheat") then hitk=true break end
                    end
                    if hitk then
                        scanned=scanned+1
                        tryFire(d,{"steal",t.UserId})
                        tryFire(d,{"steal",t.Name})
                        tryFire(d,{"pickpocket",t.Name})
                    end
                end
            end
        end
    end)
    local parts={}
    if cloned>0 then table.insert(parts,cloned.." tool(s) cloned+equipped") end
    if fired>0 then table.insert(parts,fired.." remote(s)") end
    if #parts>0 then
        ntf("Steal","OK on "..t.DisplayName..": "..table.concat(parts,", ").." - WeaponActivated sent",5)
    else
        ntf("Steal","No tools on "..t.DisplayName.." - firing Armory/Inventory steal",4)
        giveGRItem("FN FAL","weapon")
    end
end
-- Steal Outfit & Ped visible (HumanoidDescription, no server.lua)
ST._origDesc=nil
function saveMyOutfit()
    if ST._origDesc then return end
    pcall(function()
        local ch=LP.Character
        local hum=ch and ch:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local desc=nil
        pcall(function() desc=hum:GetAppliedDescription() end)
        if not desc then pcall(function() desc=P:GetHumanoidDescriptionFromUserId(LP.UserId) end) end
        if desc then ST._origDesc=desc end
    end)
end
function applyOutfitFromPlayer(target)
    if not target or not target.Character then return false end
    local thum=target.Character:FindFirstChildOfClass("Humanoid")
    local myHum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if not thum or not myHum then return false end
    saveMyOutfit()
    local ok=false
    pcall(function()
        local desc=nil
        pcall(function() desc=thum:GetAppliedDescription() end)
        if not desc then pcall(function() desc=P:GetHumanoidDescriptionFromUserId(target.UserId) end) end
        if desc then
            local nd=Instance.new("HumanoidDescription")
            for _,pr in ipairs({"Head","Torso","LeftArm","RightArm","LeftLeg","RightLeg","Face","Pants","Shirt","GraphicTShirt","HatAccessories","HairAccessories","FaceAccessories","NeckAccessories","ShoulderAccessories","FrontAccessories","BackAccessories","WaistAccessories","BodyTypeScale","HeightScale","WidthScale","HeadScale","ProportionScale","DepthScale","HeadColor","TorsoColor","LeftArmColor","RightArmColor","LeftLegColor","RightLegColor"}) do
                pcall(function() local v=desc[pr] if v~=nil then nd[pr]=v end end)
            end
            myHum:ApplyDescription(nd)
            ok=true
        end
    end)
    if not ok then
        pcall(function()
            for _,v in pairs(LP.Character:GetChildren()) do if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then v:Destroy() end end
            for _,v in pairs(target.Character:GetChildren()) do if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then pcall(function() v:Clone().Parent=LP.Character end) end end
            ok=true
        end)
    end
    return ok
end
function doStealOutfit()
    if not cd() then return end
    local t=ST.selectedPlayer
    if not t or t==LP or not t.Character then t=nearestPl(25) end
    if not t then ntf("Outfit","No player nearby",4) return end
    if applyOutfitFromPlayer(t) then ntf("Outfit","Stole outfit from "..t.DisplayName.." (visible)!",5) else ntf("Outfit","Failed",4) end
end
function doStealPed()
    if not cd() then return end
    local t=ST.selectedPlayer
    if not t or t==LP or not t.Character then t=nearestPl(25) end
    if not t then ntf("Ped","No player nearby",4) return end
    saveMyOutfit()
    local ok=false
    pcall(function()
        local thum=t.Character:FindFirstChildOfClass("Humanoid")
        local myHum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if thum and myHum then
            local desc=nil
            pcall(function() desc=thum:GetAppliedDescription() end)
            if not desc then pcall(function() desc=P:GetHumanoidDescriptionFromUserId(t.UserId) end) end
            if desc then myHum:ApplyDescription(desc) ok=true end
        end
    end)
    if not ok then ok=applyOutfitFromPlayer(t) end
    if ok then ntf("Ped","Stole ped from "..t.DisplayName.." (visible)!",5) else ntf("Ped","Failed",4) end
end
function doRestoreOutfit()
    if not ST._origDesc then ntf("Outfit","No saved outfit",4) return end
    pcall(function()
        local myHum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if myHum then myHum:ApplyDescription(ST._origDesc) ntf("Outfit","Restored (visible)",4) end
    end)
end

btn(tEx,"Steal in Greenzone (no gun)",function() doGreenSteal() end,"stealgreen")
sep(tEx)
lbl(tEx,">> GIVE WORKING ITEMS (Armory/Inventory/Shop)")
btn(tEx,"Give FN FAL (working)",function()
    if not cd() then return end
    local n=giveGRItem("FN FAL","weapon")
    fireWeaponActivated()
    ntf("Give","FN FAL x"..n.." - Armory+Inventory+clone+WeaponActivated",4)
end,"gfnfal")
btn(tEx,"Give M4A5 (working)",function()
    if not cd() then return end
    local n=giveGRItem("M4A5","weapon")
    fireWeaponActivated()
    ntf("Give","M4A5 x"..n.." sent",4)
end,"gm4a5")
btn(tEx,"Give Police Glock",function()
    if not cd() then return end
    local n=giveGRItem("Police Glock","weapon")
    fireWeaponActivated()
    ntf("Give","Police Glock x"..n.." sent",4)
end,"gglock")
btn(tEx,"Give Food+Medkit pack",function()
    if not cd() then return end
    local total=0
    for _,it in ipairs(GR_ITEMS) do total=total+giveGRItem(it,"item") end
    ntf("Give","Items pack: "..total.." added (Bandage/Bread/Water/etc)",5)
end,"gpack")
btn(tEx,"Give LockPick",function()
    if not cd() then return end
    local n=giveGRItem("LockPick","item")
    ntf("Give","LockPick x"..n,4)
end,"glockpick")
table.insert(allToggles,tog(tEx,"Auto Steal Loop",function() return ST.autoSteal end,function() ST.autoSteal=not ST.autoSteal if ST.autoSteal then ntf("Steal","Loop ON - nearest every 0.6s") else ntf("Steal","Loop OFF") end end,"autosteal"))
sep(tEx)
lbl(tEx,">> STEAL OUTFIT & PED (Visible - no server.lua)")
btn(tEx,"Steal Outfit (Selected/Nearest)",function() doStealOutfit() end,"stealoutfit")
btn(tEx,"Steal Ped - Full Clone",function() doStealPed() end,"stealped")
btn(tEx,"Restore My Outfit",function() doRestoreOutfit() end,"restoreoutfit")
sep(tEx)
lbl(tEx,">> RENAME")
local renameBox=Instance.new("TextBox") renameBox.Size=UDim2.new(1,-12,0,28) renameBox.Position=UDim2.new(0,6,0,0) renameBox.BackgroundColor3=TH.b renameBox.BorderSizePixel=0 renameBox.PlaceholderText="New name..." renameBox.PlaceholderColor3=Color3.fromRGB(100,100,120) renameBox.Text="" renameBox.TextColor3=TH.t renameBox.TextSize=12 renameBox.Font=Enum.Font.Gotham renameBox.Parent=tEx mkCorner(renameBox,6)
btn(tEx,"Rename Self (Visible)",function()
    local n=renameBox.Text if n=="" then ntf("Rename","Enter name",4) return end
    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.DisplayName=n ntf("Rename","Self -> "..n.." (visible)",4) end
end,"renameself")
btn(tEx,"Rename Other (Client)",function()
    local n=renameBox.Text if n=="" then ntf("Rename","Enter name",4) return end
    local t=ST.selectedPlayer or nearestPl(25)
    if not t or not t.Character then ntf("Rename","No target",4) return end
    local hum=t.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.DisplayName=n ntf("Rename",t.DisplayName.." -> "..n.." (client)",4) end
end,"renameother")
btn(tEx,"Reset Names",function()
    pcall(function()
        local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum and ST._origName then hum.DisplayName=ST._origName end
        for _,pl in pairs(P:GetPlayers()) do
            if pl.Character then
                local h=pl.Character:FindFirstChildOfClass("Humanoid")
                if h then h.DisplayName=pl.DisplayName end
            end
        end
        ntf("Rename","Reset",4)
    end)
end,"resetnames")
sep(tEx)
lbl(tEx,">> VISIBLE REMOTE EFFECTS")
btn(tEx,"Fire Weapon (Visible)",function() if not cd() then return end equipAnyTool() local cam=W.CurrentCamera or CAM local pos=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character.HumanoidRootPart.Position or Vector3.new(0,0,0) local dir=cam and cam.CFrame.LookVector*100 or Vector3.new(0,0,100) local hit=MS.Hit and MS.Hit.Position or pos+dir pcall(function() local r=findRemote("WeaponsSystem.Network.WeaponFired") if r then grFire(r,{pos,hit},"wfire") grFire(r,{pos,dir},"wfire") end local ra=findRemote("WeaponsSystem.Network.WeaponActivated") if ra then grFire(ra,{"FN FAL"},"wfire") end ntf("Weapon","Fired visible!",4) end) end,"weapfire")
btn(tEx,"Toggle Police Siren",function() pcall(function() local r=findRemote("ToggleSirenEvent") if r then grFire(r,{true},"siren") ntf("Siren","Toggled visible!",4) end end) end,"siren")
btn(tEx,"Spam Siren x5",function() if cd() then pcall(function() local r=findRemote("ToggleSirenEvent") if r then for i=1,5 do r:FireServer(true) task.wait(0.1) end ntf("Siren","Spam x5!") end end) end end,"siren5")
btn(tEx,"Siren Off",function() pcall(function() local r=findRemote("ToggleSirenEvent") if r then r:FireServer(false) ntf("Siren","Off!") end end) end,"sirenoff")
btn(tEx,"Weapon Hit (Visible)",function() if not cd() then return end local t=ST.selectedPlayer or nearestPl(40) if not t or not t.Character then ntf("Weapon","No target",4) return end local part=t.Character:FindFirstChild("Head") or t.Character:FindFirstChild("HumanoidRootPart") if not part then return end equipAnyTool() pcall(function() local r=findRemote("WeaponsSystem.Network.WeaponHit") or findRemote("WeaponsSystem.Network.Hit") if r then grFire(r,{part.Position},"whit") grFire(r,{t,part},"whit") end ntf("Weapon","Hit "..t.DisplayName.." visible!",4) end) end,"weaphit")
sep(tEx)
lbl(tEx,">> MAGIC BULLET")
table.insert(allToggles,tog(tEx,"Magic Bullet",function() return ST.magicBullet end,function() ST.magicBullet=not ST.magicBullet ntf("MagicBullet",ST.magicBullet and "ON - Bullets hit through walls!" or "OFF") end,"magbul"))
table.insert(allToggles,tog(tEx,"Weapon Dmg (MP)",function() return ST.weaponDmgOn end,function() ST.weaponDmgOn=not ST.weaponDmgOn ntf("WeaponDmg",ST.weaponDmgOn and "ON - hits damage other players" or "OFF") end,"weapdmg"))
local dmgBox=Instance.new("TextBox")
dmgBox.Size=UDim2.new(1,-12,0,30)
dmgBox.Position=UDim2.new(0,6,0,0)
dmgBox.BackgroundColor3=TH.b
dmgBox.BorderSizePixel=0
dmgBox.PlaceholderText="Custom damage (1-999999)"
dmgBox.PlaceholderColor3=Color3.fromRGB(100,100,120)
dmgBox.Text=tostring(ST.weaponDmg or 30)
dmgBox.TextColor3=TH.t
dmgBox.TextSize=13
dmgBox.Font=Enum.Font.GothamBold
dmgBox.ClearTextOnFocus=false
dmgBox.Parent=tEx
mkCorner(dmgBox,6)
mkStroke(dmgBox,TH.a,1)
local dmgLbl=Instance.new("TextLabel")
dmgLbl.Size=UDim2.new(1,-12,0,18)
dmgLbl.Position=UDim2.new(0,6,0,0)
dmgLbl.BackgroundTransparency=1
dmgLbl.Text="DAMAGE: "..tostring(ST.weaponDmg or 30).."  |  input box = custom"
dmgLbl.TextColor3=TH.a
dmgLbl.TextSize=11
dmgLbl.Font=Enum.Font.GothamBold
dmgLbl.TextXAlignment=Enum.TextXAlignment.Left
dmgLbl.Parent=tEx
local function applyDmgBox()
    local n=tonumber(dmgBox.Text)
    if not n then dmgBox.Text=tostring(ST.weaponDmg or 30) return end
    ST.weaponDmg=math.clamp(math.floor(n),1,999999)
    dmgBox.Text=tostring(ST.weaponDmg)
    dmgLbl.Text="DAMAGE: "..tostring(ST.weaponDmg).."  |  input box = custom"
    ntf("WeaponDmg","Amount: "..ST.weaponDmg)
end
dmgBox.FocusLost:Connect(function(enter)
    if enter then applyDmgBox() end
end)
btn(tEx,"Apply typed damage",function() applyDmgBox() end,"wdmgset")
btn(tEx,"Dmg: 20",function() ST.weaponDmg=20 dmgBox.Text="20" dmgLbl.Text="DAMAGE: 20  |  input box = custom" ntf("WeaponDmg","Amount: 20") end,"wdmg20")
btn(tEx,"Dmg: 40",function() ST.weaponDmg=40 dmgBox.Text="40" dmgLbl.Text="DAMAGE: 40  |  input box = custom" ntf("WeaponDmg","Amount: 40") end,"wdmg40")
btn(tEx,"Dmg: 60",function() ST.weaponDmg=60 dmgBox.Text="60" dmgLbl.Text="DAMAGE: 60  |  input box = custom" ntf("WeaponDmg","Amount: 60") end,"wdmg60")
btn(tEx,"Dmg: 100",function() ST.weaponDmg=100 dmgBox.Text="100" dmgLbl.Text="DAMAGE: 100  |  input box = custom" ntf("WeaponDmg","Amount: 100") end,"wdmg100")
btn(tEx,"Mult x1",function() ST.weaponDmgMult=1 ntf("WeaponDmg","Multiplier: x1") end,"wmult1")
btn(tEx,"Mult x2",function() ST.weaponDmgMult=2 ntf("WeaponDmg","Multiplier: x2") end,"wmult2")
btn(tEx,"Mult x5",function() ST.weaponDmgMult=5 ntf("WeaponDmg","Multiplier: x5") end,"wmult5")
btn(tEx,"Mult x10",function() ST.weaponDmgMult=10 ntf("WeaponDmg","Multiplier: x10") end,"wmult10")
sep(tEx)
lbl(tEx,">> SPAWN / GIVE ITEMS")
local function getGameToolList()
    if ST._gameTools then return ST._gameTools end
    local list={}
    local seen={}
    local function addTool(d)
        if not d or seen[d] then return end
        seen[d]=true
        table.insert(list,d)
    end
    local function scan(parent,deep)
        pcall(function()
            if not parent then return end
            local items=deep and parent:GetDescendants() or parent:GetChildren()
            for _,d in ipairs(items) do
                if d:IsA("Tool") then addTool(d) end
            end
        end)
    end
    pcall(function() scan(game:GetService("StarterPack"),true) end)
    pcall(function() scan(game:GetService("StarterGear"),true) end)
    pcall(function() scan(RS,true) end)
    pcall(function() scan(game:GetService("ReplicatedFirst"),true) end)
    pcall(function() scan(W,true) end)
    pcall(function()
        local ss=game:GetService("ServerStorage")
        if ss then scan(ss,true) end
    end)
    pcall(function()
        local sss=game:GetService("ServerScriptService")
        if sss then scan(sss,true) end
    end)
    pcall(function()
        for _,pl in pairs(P:GetPlayers()) do
            local ch=pl:FindFirstChild("Backpack")
            if ch then scan(ch,true) end
            if pl.Character then scan(pl.Character,true) end
        end
    end)
    ST._gameTools=list
    return list
end
local function matchToolName(name, q)
    if not name or not q then return false end
    local tn=string.lower(name)
    if tn==q or tn:find(q,1,true) or q:find(tn,1,true) then return true end
    for word in string.gmatch(q,"[^%s]+") do
        if #word>=3 and tn:find(word,1,true) then return true end
    end
    return false
end
local function getItemCatalog()
    if ST._itemCat then return ST._itemCat end
    local names={}
    local seen={}
    local function add(n)
        if not n or #n<2 or #n>50 then return end
        local k=string.lower(n)
        if seen[k] then return end
        if k:find("remote") or k:find("event") or k:find("signal") or k:find("anticheat") then return end
        seen[k]=true
        table.insert(names,n)
    end
    pcall(function()
        for _,tool in ipairs(getGameToolList()) do add(tool.Name) end
    end)
    pcall(function()
        for _,d in pairs(RS:GetDescendants()) do
            if d:IsA("StringValue") then add(d.Name) end
            if d:IsA("Folder") or d:IsA("Model") then
                local pn=string.lower(d.Name)
                if pn:find("shop") or pn:find("item") or pn:find("store") or pn:find("catalog") or pn:find("weapon") or pn:find("armory") or pn:find("loot") then
                    for _,c in pairs(d:GetChildren()) do
                        if c:IsA("StringValue") or c:IsA("Tool") or c:IsA("Folder") or c:IsA("ModuleScript") then add(c.Name) end
                    end
                end
            end
        end
    end)
    ST._itemCat=names
    return names
end
local function fireGiveRemotes(itemName)
    local lower=string.lower(itemName)
    local aliases={itemName,lower}
    local cat=getItemCatalog()
    for _,cn in ipairs(cat) do
        if matchToolName(cn,lower) and #aliases<6 then
            table.insert(aliases,cn)
        end
    end
    if lower:find("fal") and #aliases<8 then
        table.insert(aliases,"fnfal")
        table.insert(aliases,"FN_FAL")
    end
    if (lower:find("plant") or lower:find("weed")) and #aliases<8 then
        table.insert(aliases,"weed")
        table.insert(aliases,"cannabis")
        table.insert(aliases,"plant")
    end
    local budget=20
    ST._giveRateT=ST._giveRateT or 0
    local function tryFire(r,args)
        if not r or budget<=0 then return false end
        local now=tick()
        if now-ST._giveRateT<0.08 then return false end
        ST._giveRateT=now
        local ok2=false
        if r:IsA("RemoteFunction") then
            ST._forceFire=true
            ok2=pcall(function() r:InvokeServer(unpack(args)) end)
            ST._forceFire=false
        else
            ok2=forceFire(r,unpack(args))
        end
        if ok2 then budget=budget-1 end
        return ok2
    end
    local inv=findRemote("Inventory.Inventory")
    local arm=findRemote("Armory.RemoteEvent")
    local buy=findRemote("SupermarketEvent.BuyItem")
    local prio={
        "Inventory.Inventory","Armory.RemoteEvent","SupermarketEvent.BuyItem",
        "GiveTool","GiveItem","SpawnItem","addItem","GiveWeapon"
    }
    for _,alias in ipairs(aliases) do
        local sets={
            {alias},{"give",alias},{"add",alias,1},{"buy",alias},{LP,alias},{alias,1}
        }
        for _,args in ipairs(sets) do
            tryFire(inv,args)
            tryFire(arm,args)
            tryFire(buy,args)
        end
    end
    for _,path in ipairs(prio) do
        if budget<=0 then break end
        pcall(function()
            local r=findRemote(path)
            if r then
                for _,alias in ipairs(aliases) do
                    tryFire(r,{alias})
                    tryFire(r,{"give",alias})
                end
            end
        end)
    end
    pcall(function()
        local scanned=0
        for _,parent in ipairs({RS,W}) do
            if budget<=0 or scanned>=4 then break end
            for _,d in pairs(parent:GetDescendants()) do
                if budget<=0 or scanned>=4 then break end
                if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
                    local nm=string.lower(d.Name)
                    if (nm:find("give") or nm:find("spawn") or nm:find("additem") or nm:find("buyitem") or nm:find("armory")) and not nm:find("antiban") then
                        scanned=scanned+1
                        for _,alias in ipairs(aliases) do
                            tryFire(d,{alias})
                            tryFire(d,{"give",alias})
                        end
                    end
                end
            end
        end
    end)
    return 20-budget
end
local function giveGameItem(query)
    if not query or query=="" then ntf("Give","Enter item name",4) return end
    local q=string.lower(query)
    local bp=LP:FindFirstChild("Backpack")
    if not bp then ntf("Give","No backpack",4) return end
    local all=getGameToolList()
    local given=0
    local names={}
    for _,tool in ipairs(all) do
        if matchToolName(tool.Name,q) then
            pcall(function()
                local cl=tool:Clone()
                cl.Parent=bp
                given=given+1
                table.insert(names,tool.Name)
            end)
        end
        if given>=6 then break end
    end
    if given==0 then
        ST._gameTools=nil
        all=getGameToolList()
        for _,tool in ipairs(all) do
            if matchToolName(tool.Name,q) then
                pcall(function()
                    local cl=tool:Clone()
                    cl.Parent=bp
                    given=given+1
                    table.insert(names,tool.Name)
                end)
            end
            if given>=6 then break end
        end
    end
    local firedN=0
    pcall(function() firedN=fireGiveRemotes(query) or 0 end)
    local sample={}
    for i=1,math.min(6,#all) do table.insert(sample,all[i].Name) end
    local catN=0
    pcall(function() catN=#getItemCatalog() end)
    if given>0 then
        pcall(function()
            local last=bp:FindFirstChildOfClass("Tool")
            if last then LP.Character:EquipTool(last) end
        end)
        ntf("Give","Cloned "..given..": "..table.concat(names,", "),5)
    else
        ntf("Give","0 Tool instances (cache "..#all..", catalog "..catN.."). Remotes sent: "..firedN..". If empty: Remote Spy on shop/armory buy. Sample: "..table.concat(sample,", "),8)
    end
end
local itemBox=Instance.new("TextBox")
itemBox.Size=UDim2.new(1,-12,0,28)
itemBox.Position=UDim2.new(0,6,0,0)
itemBox.BackgroundColor3=TH.b
itemBox.BorderSizePixel=0
itemBox.PlaceholderText="Item name (e.g. FN FAL, milk, vest...)"
itemBox.PlaceholderColor3=Color3.fromRGB(100,100,120)
itemBox.Text=""
itemBox.TextColor3=TH.t
itemBox.TextSize=12
itemBox.Font=Enum.Font.Gotham
itemBox.ClearTextOnFocus=false
itemBox.Parent=tEx
mkCorner(itemBox,6)
mkStroke(itemBox,Color3.fromRGB(60,60,90),1)
itemBox.FocusLost:Connect(function(enter)
    if enter then giveGameItem(itemBox.Text) end
end)
btn(tEx,"Give typed item",function() giveGameItem(itemBox.Text) end,"giveitem")
-- duplicate give buttons removed (use GIVE WORKING ITEMS above)
btn(tEx,"Refresh item list",function()
    ST._gameTools=nil
    local n=#getGameToolList()
    local sample={}
    local all=ST._gameTools or {}
    for i=1,math.min(8,#all) do table.insert(sample,all[i].Name) end
    ntf("Give","Rescanned - "..n.." Tools. Sample: "..table.concat(sample,", "),6)
end,"refitems")
btn(tEx,"Dump ALL remotes (for Spy)",function()
    local lines={}
    pcall(function()
        for _,parent in ipairs({RS,W}) do
            for _,d in pairs(parent:GetDescendants()) do
                if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
                    table.insert(lines,(d:IsA("RemoteFunction") and "RF " or "RE ")..d:GetFullName())
                end
            end
        end
    end)
    table.sort(lines)
    local msg=table.concat(lines,"\n")
    ntf("Remotes","#"..#lines.." remotes dumped. Full list -> clipboard + console",6)
    print("[Axynth REMOTES]\n"..msg)
    pcall(function()
        if setclipboard then setclipboard(msg) end
    end)
end,"dumprems")
btn(tEx,"Dump all tool names",function()
    ST._gameTools=nil
    ST._itemCat=nil
    local all=getGameToolList()
    local cat=getItemCatalog()
    local names={}
    local seen={}
    for _,t in ipairs(all) do if not seen[t.Name] then seen[t.Name]=true table.insert(names,t.Name) end end
    for _,n in ipairs(cat) do if not seen[n] then seen[n]=true table.insert(names,n) end end
    table.sort(names)
    local msg=table.concat(names,", ")
    if #msg>180 then msg=string.sub(msg,1,180).."..." end
    ntf("Give","Tools "..#all..", catalog "..#cat..": "..msg,8)
    pcall(function()
        if setclipboard and #names>0 then setclipboard(table.concat(names,", ")) ntf("Give","Full list copied to clipboard",4) end
    end)
end,"dumptools")
sep(tEx)
lbl(tEx,">> MULTIPLAYER KILL")
btn(tEx,"Kill Selected/Nearest (MP)",function()
    if cd() then killNearestOrSelected() end
end,"killmp")
btn(tEx,"Kill All in Range 40 (MP)",function()
    if not cd() then return end
    local my=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not my then return end
    local hadWeapon=ensureWeaponEquipped()
    local nkill=0
    local deaths=0
    for _,pp in pairs(P:GetPlayers()) do
        if pp~=LP and pp.Character and pp.Character:FindFirstChild("HumanoidRootPart") then
            local d=(pp.Character.HumanoidRootPart.Position-my.Position).Magnitude
            if d<=40 then
                local pos=pp.Character.HumanoidRootPart.Position
                mpKillPlayer(pp,pos)
                pcall(function()
                    if not AR then AR=RS:FindFirstChild("AdminRemote") or RS:FindFirstChild("HDAdminRemote") end
                    if AR then AR:FireServer("kill", pp.Name) end
                end)
                pcall(function()
                    local h=pp.Character:FindFirstChildOfClass("Humanoid")
                    if h and h.Health<=0 then deaths=deaths+1 end
                end)
                nkill=nkill+1
                task.wait(0.05)
            end
        end
    end
    ntf("Kill","Sent MP kill x"..nkill.." in 40 studs ("..(hadWeapon and "weapon on" or "no weapon")..") - if still alive game blocks fake hits",5)
end,"killall40")
sep(tEx)
lbl(tEx,">> REMOTE SCANNER")
btn(tEx,"Open Remote Scanner",function() if _G.RemoteScanner then pcall(function() _G.RemoteScanner:Destroy() end) end
    local SG2=Instance.new("ScreenGui") SG2.Name="RemoteScanner" SG2.ResetOnSpawn=false SG2.DisplayOrder=1001 SG2.ZIndexBehavior=Enum.ZIndexBehavior.Sibling SG2.IgnoreGuiInset=true pcall(function() if gethui then SG2.Parent=gethui() end end) if not SG2.Parent then pcall(function() SG2.Parent=CG end) end if not SG2.Parent then SG2.Parent=LP:WaitForChild("PlayerGui") end _G.RemoteScanner=SG2
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
    if ST.spySG then
        local alive=false
        pcall(function() alive=(ST.spySG.Parent~=nil) end)
        pcall(function() ST.spySG:Destroy() end)
        ST.spySG=nil ST.remoteSpyOn=false
        if alive then return end
    end
    local spyOK,spyErr=pcall(function()
    ST.remoteSpyOn=true ST.remoteSpyPaused=false ST.remoteSpyLog={}
    local SG3=Instance.new("ScreenGui") SG3.Name="RemoteSpy" SG3.ResetOnSpawn=false SG3.DisplayOrder=1002 SG3.ZIndexBehavior=Enum.ZIndexBehavior.Sibling SG3.IgnoreGuiInset=true pcall(function() if gethui then SG3.Parent=gethui() end end) if not SG3.Parent then pcall(function() SG3.Parent=CG end) end if not SG3.Parent then SG3.Parent=LP:WaitForChild("PlayerGui") end ST.spySG=SG3
    local PF=Instance.new("Frame") PF.Size=UDim2.new(0,550,0,400) PF.Position=UDim2.new(0.5,-275,0.5,-200) PF.BackgroundColor3=TH.p PF.BorderSizePixel=0 PF.Active=true PF.Draggable=true PF.Parent=SG3 PF.BackgroundTransparency=0 mkCorner(PF,12) mkStroke(PF,Color3.fromRGB(255,160,0),2)
    local PT=Instance.new("Frame") PT.Size=UDim2.new(1,0,0,36) PT.BackgroundColor3=TH.s PT.BorderSizePixel=0 PT.Parent=PF mkCorner(PT,12)
    local PTL=Instance.new("TextLabel") PTL.Size=UDim2.new(1,-230,1,0) PTL.Position=UDim2.new(0,12,0,0) PTL.BackgroundTransparency=1 PTL.Text="REMOTE SPY" PTL.TextColor3=Color3.fromRGB(255,160,0) PTL.TextSize=14 PTL.Font=Enum.Font.GothamBlack PTL.TextXAlignment=Enum.TextXAlignment.Left PTL.Parent=PT
    ST._spyPTL=PTL pcall(axSpyHUD)
    local PX=Instance.new("TextButton") PX.Size=UDim2.new(0,28,0,28) PX.Position=UDim2.new(1,-32,0,4) PX.BackgroundTransparency=1 PX.Text="X" PX.TextColor3=TH.r PX.TextSize=18 PX.Font=Enum.Font.GothamBold PX.Parent=PT
    PX.MouseButton1Click:Connect(function() ST.spySG:Destroy() ST.spySG=nil ST.remoteSpyOn=false end)
    local PBtn=Instance.new("TextButton") PBtn.Size=UDim2.new(0,60,0,22) PBtn.Position=UDim2.new(1,-100,0,7) PBtn.BackgroundColor3=TH.b PBtn.BorderSizePixel=0 PBtn.Text="Pause" PBtn.TextColor3=TH.t PBtn.TextSize=10 PBtn.Font=Enum.Font.GothamBold PBtn.Parent=PT mkCorner(PBtn,4)
    PBtn.MouseButton1Click:Connect(function() ST.remoteSpyPaused=not ST.remoteSpyPaused PBtn.Text=ST.remoteSpyPaused and "Resume" or "Pause" end)
    local SF2=Instance.new("ScrollingFrame") SF2.Size=UDim2.new(1,-16,1,-48) SF2.Position=UDim2.new(0,8,0,42) SF2.BackgroundTransparency=1 SF2.BorderSizePixel=0 SF2.ScrollBarThickness=4 SF2.ScrollBarImageColor3=Color3.fromRGB(255,160,0) SF2.CanvasSize=UDim2.new(0,0,0,0) SF2.Parent=PF SF2.AutomaticCanvasSize=Enum.AutomaticSize.Y SF2.ScrollingDirection=Enum.ScrollingDirection.Y SF2.ElasticBehavior=Enum.ElasticBehavior.Never
    local CBtn=Instance.new("TextButton") CBtn.Size=UDim2.new(0,50,0,22) CBtn.Position=UDim2.new(1,-160,0,7) CBtn.BackgroundColor3=TH.b CBtn.BorderSizePixel=0 CBtn.Text="Clear" CBtn.TextColor3=TH.t CBtn.TextSize=10 CBtn.Font=Enum.Font.GothamBold CBtn.Parent=PT mkCorner(CBtn,4)
    CBtn.MouseButton1Click:Connect(function() ST.remoteSpyLog={} for _,ch in pairs(SF2:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end end)
    local CPBtn=Instance.new("TextButton") CPBtn.Size=UDim2.new(0,50,0,22) CPBtn.Position=UDim2.new(1,-216,0,7) CPBtn.BackgroundColor3=TH.b CPBtn.BorderSizePixel=0 CPBtn.Text="Copy" CPBtn.TextColor3=TH.t CPBtn.TextSize=10 CPBtn.Font=Enum.Font.GothamBold CPBtn.Parent=PT mkCorner(CPBtn,4)
    CPBtn.MouseButton1Click:Connect(function()
        local cleanE=string.gsub(tostring(HOOK_ERR or "-"),"^.-loadstring[:%.][%d]+[:%.]%d+:%s*","")
        local hdr="hook="..(HOOK_OK==false and ("FAIL:"..cleanE) or tostring(HOOK_PATH or "OK")).." any="..(ST._ncAny or 0).." nc="..(ST._ncAll or 0).." ff="..(ST._ncFF or 0).." blk="..(ST._ncBlk or 0).." exp="..(ST._ncExp or 0).." log="..(ST._ncLog or 0).." err="..(ST._ncErr or 0).." | apis="..string.sub(tostring(HOOK_APIS or "-"),1,600)
        local lines=ST._capLines
        local txt=""
        if lines and #lines>0 then txt=table.concat(lines,"\n") end
        if txt=="" then
            local sl={}
            for _,e in ipairs(ST.remoteSpyLog or {}) do table.insert(sl,e.time.." "..e.name.." "..e.args.." "..e.caller) end
            txt=table.concat(sl,"\n")
        end
        local body=txt
        txt=hdr
        if body~="" then txt=hdr.."\n"..body end
        if body=="" then ntf("Spy","No events yet - counters copied",5) end
        local okc=false
        pcall(function() setclipboard(txt) okc=true end)
        if okc then
            ntf("Spy",(body~="" and ("Copied "..#(ST._capLines or {}).." captures") or "Counters copied").." - paste them",6)
        else
            ntf("Spy","setclipboard unavailable - file axynth_capture.txt",6)
        end
    end)
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
    end)
    if not spyOK then
        pcall(function() print("[Axynth][Spy] open failed: "..tostring(spyErr)) end)
        ST.spySG=nil ST.remoteSpyOn=false
        pcall(function() ntf("Spy","Open error: "..tostring(spyErr),7) end)
    end
end,"openspy")
btn(tEx,"Spy Test (probe remote)",function()
    local b1=ST._ncAny or 0
    local b2=ST._ncAll or 0
    pcall(function()
        local r=Instance.new("RemoteEvent") r.Name="AxProbe"
        r:FireServer("axprobe",math.floor(tick()))
    end)
    ntf("Spy","Probe: any "..b1.."->"..(ST._ncAny or 0).." | nc "..b2.."->"..(ST._ncAll or 0).." (same = hook dead, +1 = hook OK)",8)
end,"spytest")
btn(tEx,"Clear Spy Log",function() ST.remoteSpyLog={} if _G._spyFrame then for _,ch in pairs(_G._spyFrame:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end end ntf("Spy","Cleared!") end,"clrspry")
sep(tEx)
lbl(tEx,">> AIMBOT")
table.insert(allToggles,tog(tEx,"Aimbot (Silent)",function() return ST.aimEnabled end,function() ST.aimEnabled=not ST.aimEnabled if ST.aimEnabled then ntf("Aimbot","ON - Silent (no cam move, FOV lock)") else ntf("Aimbot","OFF") ST.aimTarget=nil ST._aimWallC=nil local myHum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if myHum then myHum.AutoRotate=true end end end,"aimbot"))
table.insert(allToggles,tog(tEx,"Hold to Aim",function() return ST.aimHoldKey end,function() ST.aimHoldKey=not ST.aimHoldKey if not ST.aimHoldKey then ST.aimKeyHeld=false KBActive.aimhold=nil else if not KB.aimhold then KB.aimhold=Enum.UserInputType.MouseButton2 KBMode.aimhold="hold" end if not KB.aimbot or KBMode.aimbot~="hold" then KBMode.aimhold="hold" end ntf("Aimbot","Hold ON - hold "..getKeyDisplay(KB.aimhold).." to aim (default RMB)") end refreshKBBtns() end,"aimhold"))
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

makeSlider(tEx,"Max Dist",50,1000,function() return ST.aimMaxDist end,function(v) ST.aimMaxDist=math.floor(v) end)
table.insert(allToggles,tog(tEx,"Team Check",function() return ST.aimTeamCheck end,function() ST.aimTeamCheck=not ST.aimTeamCheck ntf("Aimbot","TeamCheck: "..(ST.aimTeamCheck and "ON" or "OFF")) end,"aimtc"))
table.insert(allToggles,tog(tEx,"Wall Check",function() return ST.aimWallCheck end,function() ST.aimWallCheck=not ST.aimWallCheck ntf("Aimbot","WallCheck: "..(ST.aimWallCheck and "ON (skip through walls)" or "OFF")) end,"aimwc"))
table.insert(allToggles,tog(tEx,"Show FOV Always",function() return ST.showFOV end,function() ST.showFOV=not ST.showFOV if not ST.showFOV and ST.aimFOVGui then ST.aimFOVGui:Destroy() ST.aimFOVGui=nil end ntf("Aimbot","ShowFOV: "..(ST.showFOV and "ON (always visible)" or "OFF")) end,"showfov"))
local tMi=tF["misc"]
lbl(tMi,">> MISC")
btn(tMi,"Reset Character",function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=0 end end end,"reset")
btn(tMi,"Anti-AFK",function() pcall(function() LP.Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Running) end) end,"antiafk")
table.insert(allToggles,tog(tMi,"Auto Clicker",function() return ST.autoClicker end,function() ST.autoClicker=not ST.autoClicker ntf("AutoClick",ST.autoClicker and "ON (5 CPS)" or "OFF") end,"autoclick"))
table.insert(allToggles,tog(tMi,"Vehicle Speed",function() return ST.vehicleSpeedOn end,function() ST.vehicleSpeedOn=not ST.vehicleSpeedOn if ST.vehicleSpeedOn then ntf("VehicleSpeed","ON - boost "..tostring(ST.vehBoost or 80).." (re-applied gently)") else ntf("VehicleSpeed","OFF - restoring car speeds") pcall(function() if ST._vehOrig and LP.Character then local hum=LP.Character:FindFirstChildOfClass("Humanoid") if hum and hum.Seated and hum.SeatPart and ST._vehOrig[hum.SeatPart] then hum.SeatPart.MaxSpeed=ST._vehOrig[hum.SeatPart] end end end) end end,"vehspeed"))
table.insert(allToggles,tog(tMi,"ArrayList",function() return ST.arrayList end,function() ST.arrayList=not ST.arrayList ntf("ArrayList",ST.arrayList and "ON" or "OFF") end,"arraylist"))
table.insert(allToggles,tog(tMi,"Invisible",function() return ST.invisible end,function()
    ST.invisible=not ST.invisible
    if ST.invisible then
        applyInvisible()
        fireInvisRemotes(true)
        local nsent=ST._invisSent or 0
        ntf("Invisible","ON - local hide + "..nsent.." remote(s). Others see you only if game cloak remote accepted",7)
    else
        fireInvisRemotes(false)
        pcall(function()
            local ch=LP.Character
            if ch then
                for _,d in pairs(ch:GetDescendants()) do
                    if d:IsA("BasePart") and d.Name~="HumanoidRootPart" then
                        d.Transparency=d.Name=="Head" and 0 or 0
                        d.LocalTransparencyModifier=0
                    elseif d:IsA("Decal") or d:IsA("Texture") then
                        d.Transparency=0
                    elseif d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam") then
                        d.Enabled=true
                    elseif d:IsA("BillboardGui") or d:IsA("SurfaceGui") then
                        d.Enabled=true
                    elseif d:IsA("Accessory") then
                        local handle=d:FindFirstChild("Handle")
                        if handle and handle:IsA("BasePart") then
                            handle.Transparency=0
                            handle.LocalTransparencyModifier=0
                        end
                    end
                end
                local head=ch:FindFirstChild("Head")
                if head then
                    for _,c in pairs(head:GetChildren()) do
                        if c:IsA("BillboardGui") then c.Enabled=true end
                    end
                end
            end
        end)
        ntf("Invisible","OFF")
    end
end,"invisible"))
btn(tMi,"Third Person",function() pcall(function() LP.CameraMinZoomDistance=10 LP.CameraMaxZoomDistance=10 end) end,"3rdperson")
btn(tMi,"First Person",function() pcall(function() LP.CameraMinZoomDistance=0.5 LP.CameraMaxZoomDistance=0.5 end) end,"1stperson")
btn(tMi,"Infinite Yield Load",function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end) ntf("IY","Loading Infinite Yield...") end,"infyield")
sep(tMi)
lbl(tMi,">> ANTI-AFK")
btn(tMi,"Anti-AFK (Proper)",function() pcall(function() if not ST._antiafkHooked then local vu=game:GetService("VirtualUser") LP.Idled:Connect(function() vu:CaptureController() vu:ClickButton2(Vector2.new()) end) ST._antiafkHooked=true ntf("Anti-AFK","Hooked with VirtualUser!") end end) end,"antiafk2")
sep(tMi)
lbl(tMi,">> BOT (RECORD/PLAY)")
table.insert(allToggles,tog(tMi,"Bot Record",function() return ST.botRecord end,function() ST.botRecord=not ST.botRecord if ST.botRecord then ST.botFrames={} ST.botStart=tick() ntf("Bot","Recording...") else ntf("Bot","Stopped. Frames: "..#ST.botFrames) end end,"botrec"))
table.insert(allToggles,tog(tMi,"Bot Play",function() return ST.botPlay end,function() ST.botPlay=not ST.botPlay if ST.botPlay then if #ST.botFrames==0 then ST.botPlay=false ntf("Bot","No recording!") return end ST.botStart=tick() ntf("Bot","Playing. Frames: "..#ST.botFrames) else ntf("Bot","Stopped playback") end end,"botplay"))
table.insert(allToggles,tog(tMi,"Bot Loop",function() return ST.botLoop end,function() ST.botLoop=not ST.botLoop ntf("BotLoop",ST.botLoop and "ON" or "OFF") end,"botloop"))
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
btn(tSe,"Unload Everything",function() pcall(function() ST.fly=false ST.noclip=false ST.clickTP=false ST.esp=false ST.spinner=false ST.autoClicker=false ST.infJump=false setFreeCam(false) setNight(false) setNoFog(false) ST.maceTP=false ST.botRecord=false ST.botPlay=false ST.botLoop=false ST.godmodeLoop=false clearGodLocal() syncServerGod() ST.invisible=false ST.spheresOn=false ST.shotTracer=false ST.autoSteal=false ST.speedHard=false ST.infStamina=false ST.magicBullet=false ST.weaponDmgOn=false ST.weaponDmgMult=1 ST.vehicleSpeedOn=false stopOverhead(false) ST.spectating=nil if ST._vehOrig then for seat,sp in pairs(ST._vehOrig) do pcall(function() if seat and seat.Parent then seat.MaxSpeed=sp end end) end ST._vehOrig=nil end ST.arrayList=false ST.aimEnabled=false ST.remoteSpyOn=false local myHum0=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if myHum0 then myHum0.AutoRotate=true end table.clear(KBActive) if ST.aimFOVGui then ST.aimFOVGui:Destroy() ST.aimFOVGui=nil end if ST.spySG then pcall(function() ST.spySG:Destroy() end) ST.spySG=nil end if ST.palSG then pcall(function() ST.palSG:Destroy() end) ST.palSG=nil end if pDropdown then pcall(function() pDropdown:Destroy() end) pDropdown=nil pDropOpen=false end if aimDropList then pcall(function() aimDropList:Destroy() end) aimDropList=nil aimDropOpen=false end if _G._spyFrame then _G._spyFrame=nil end if _G._spyAdd then _G._spyAdd=nil end if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=16 h.JumpPower=50 h.PlatformStand=false h.AutoRotate=true end end W.Gravity=196.2 if ST.markerObj then ST.markerObj:Destroy() ST.markerObj=nil end ST.waypoints={} for i=1,5 do if ST.wpParts and ST.wpParts[i] then pcall(function() ST.wpParts[i]:Destroy() end) ST.wpParts[i]=nil end end for id,hl in pairs(ST.espList) do if hl and hl.Parent then hl:Destroy() end end ST.espList={} if ST.esp2D then for uid,fr in pairs(ST.esp2D) do if fr then pcall(function() fr:Destroy() end) end end ST.esp2D={} end for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and pp.Character:FindFirstChild("AxESP_BB") then pp.Character.AxESP_BB:Destroy() end if pp~=LP and pp.Character and pp.Character:FindFirstChild("AxESP") then pp.Character.AxESP:Destroy() end end if ST.savedCollide then ST.savedCollide={} end if ST.savedLighting then L.Brightness=ST.savedLighting.Brightness L.GlobalShadows=ST.savedLighting.GlobalShadows L.FogEnd=ST.savedLighting.FogEnd L.Ambient=ST.savedLighting.Ambient L.OutdoorAmbient=ST.savedLighting.OutdoorAmbient L.ClockTime=ST.savedLighting.ClockTime ST.savedLighting=nil end if ST.cursorTPPreview and ST.cursorTPPreview.Parent then ST.cursorTPPreview:Destroy() ST.cursorTPPreview=nil end if _G.AxArrayList and _G.AxArrayList.Parent then _G.AxArrayList:Destroy() _G.AxArrayList=nil end ntf("Cleanup","All features disabled!") end) end,"unload")
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
                    elseif id=="godloop" then ST.godmodeLoop=true applyGodLocal() bindGodHC() syncServerGod()
                    elseif id=="spheres" then ST.spheresOn=true
                    elseif id=="tracer" then ST.shotTracer=true
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
                    elseif id=="invisible" then ST.invisible=true applyInvisible() fireInvisRemotes(true)
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
            elseif id=="godloop" then ST.godmodeLoop=not ST.godmodeLoop if ST.godmodeLoop then applyGodLocal() bindGodHC() else if ST._godHC then pcall(function() ST._godHC:Disconnect() end) ST._godHC=nil end clearGodLocal() end syncServerGod()
            elseif id=="spheres" then ST.spheresOn=not ST.spheresOn if ST.spheresOn then ntf("Spheres","ON") else ntf("Spheres","OFF") end
            elseif id=="tracer" then ST.shotTracer=not ST.shotTracer if ST.shotTracer then ntf("Tracer","ON") else ntf("Tracer","OFF") end
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
            elseif id=="invisible" then ST.invisible=not ST.invisible if ST.invisible then applyInvisible() fireInvisRemotes(true) else fireInvisRemotes(false) end
            end
            end
            for _,t in pairs(allToggles) do if togUpdates[t] then togUpdates[t]() end end
        end
    end
    if inp.KeyCode==Enum.KeyCode.RightShift then
        pcall(function()
            for _,root in pairs({MF,ST.spySG}) do
                if root then
                    for _,g in pairs(root:GetDescendants()) do
                        if g:IsA("TextBox") then pcall(function() g:ReleaseFocus() end) end
                        pcall(function() if g:IsA("GuiButton") and g.Selected then g.Selected=false end end)
                    end
                end
            end
            pcall(function() U.SelectedObject=nil end)
            pcall(function() local GS=game:GetService("GuiService") if GS.SelectedObject then GS.SelectedObject=nil end end)
        end)
        waitingForKey=nil
        pcall(function() refreshKBBtns() end)
        ST.menuOpen=not ST.menuOpen if ST.menuOpen then MF.Visible=true MF.BackgroundTransparency=1 MF.Size=UDim2.new(0,520,0,420) tw(MF,{BackgroundTransparency=0.02,Size=UDim2.new(0,520,0,480),Position=UDim2.new(0.5,-260,0.5,-240)},0.35) else tw(MF,{Position=UDim2.new(0.5,-260,0.5,-280),BackgroundTransparency=1,Size=UDim2.new(0,520,0,420)},0.25) wait(0.25) MF.Visible=false MF.Position=UDim2.new(0.5,-260,0.5,-240) MF.Size=UDim2.new(0,520,0,480) MF.BackgroundTransparency=0.02 if pDropdown then pcall(function() pDropdown:Destroy() end) pDropdown=nil pDropOpen=false end if aimDropList then pcall(function() aimDropList:Destroy() end) aimDropList=nil aimDropOpen=false end end end
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
                elseif id=="godloop" then ST.godmodeLoop=false if ST._godHC then pcall(function() ST._godHC:Disconnect() end) ST._godHC=nil end clearGodLocal() syncServerGod()
                elseif id=="spheres" then ST.spheresOn=false
                elseif id=="tracer" then ST.shotTracer=false
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
                elseif id=="invisible" then ST.invisible=false fireInvisRemotes(false)
                elseif id=="clicktp" then ST.clickTP=false if ST.cursorTPPreview then ST.cursorTPPreview:Destroy() ST.cursorTPPreview=nil end
                end
                for _,t in pairs(allToggles) do if togUpdates[t] then togUpdates[t]() end end
            end
        end
    end
    if ST.aimHoldKey and KB.aimbot and (inp.KeyCode==KB.aimbot or inp.UserInputType==KB.aimbot) and KBMode.aimbot~="toggle" then ST.aimKeyHeld=false end
end)
local _lastTracer=0
local function popDmgNum(victim, amount)
    if not ST.dmgPop then return end
    if not victim or not victim.Character then return end
    pcall(function()
        local head=victim.Character:FindFirstChild("Head") or victim.Character:FindFirstChild("HumanoidRootPart")
        if not head then return end
        local bg=Instance.new("BillboardGui")
        bg.Name="AxDmgNum"
        bg.Size=UDim2.new(0,90,0,36)
        bg.StudsOffset=Vector3.new(math.random(-12,12)/10,2.8,0)
        bg.AlwaysOnTop=true
        bg.LightInfluence=0
        bg.Parent=head
        local tl=Instance.new("TextLabel")
        tl.Size=UDim2.new(1,0,1,0)
        tl.BackgroundTransparency=1
        tl.Text="-"..tostring(amount)
        tl.TextColor3=Color3.fromRGB(255,90,70)
        tl.TextStrokeTransparency=0.25
        tl.TextStrokeColor3=Color3.new(0,0,0)
        tl.TextScaled=true
        tl.Font=Enum.Font.GothamBlack
        tl.Parent=bg
        game:GetService("Debris"):AddItem(bg,0.65)
        spawn(function()
            for i=1,7 do
                if not bg or not bg.Parent then break end
                bg.StudsOffset=bg.StudsOffset+Vector3.new(0,0.22,0)
                tl.TextTransparency=i/8
                tl.TextStrokeTransparency=math.min(1,0.25+i/8)
                wait(0.05)
            end
        end)
    end)
end
local function dealWeaponDamage(victim, hitPos, force)
    if not force and not ST.weaponDmgOn then return end
    if not victim or victim==LP or not victim.Character then return end
    local now=tick()
    if now-(ST._wdT or 0)<0.1 then return end
    ST._wdT=now
    local mult=math.clamp(ST.weaponDmgMult or 1,1,10)
    local amt=ST.weaponDmg or 30
    popDmgNum(victim, math.floor(amt*mult))
    local function learnedDmgFire()
        local ok=false
        pcall(function()
            local lg=ST._learnLog
            if not lg then return end
            for wpath,arr in pairs(lg) do
                local lp2=string.lower(wpath)
                if string.find(lp2,"weaponhit",1,true) or string.find(lp2,"damage",1,true) or string.find(lp2,"hurt",1,true) then
                    local rec=arr[1]
                    if rec and axLearnInst(rec) then
                        local newArgs={}
                        local sub=false
                        for i,a in ipairs(rec.args) do
                            local rep=nil
                            if typeof(a)=="Instance" then
                                if a:IsA("Player") and a~=LP then rep=victim
                                else
                                    local mdl=a:IsA("Model") and a or a:FindFirstAncestorOfClass("Model")
                                    local apl=mdl and P:GetPlayerFromCharacter(mdl)
                                    if apl and apl~=LP and victim.Character then
                                        rep=victim.Character:FindFirstChild(a.Name) or victim.Character
                                    end
                                end
                                newArgs[i]=rep or a
                                if rep and rep~=a then sub=true end
                            elseif typeof(a)=="Vector3" then
                                newArgs[i]=hitPos
                                sub=true
                            else
                                newArgs[i]=a
                            end
                        end
                        if sub and grFire(rec.inst,newArgs,"learnDmg") then ok=true end
                    end
                end
            end
        end)
        return ok
    end
    if not learnedDmgFire() then
    pcall(function()
        local part=victim.Character:FindFirstChild(ST.aimTargetPart) or victim.Character:FindFirstChild("Head") or victim.Character:FindFirstChild("HumanoidRootPart")
        local hits={
            findRemote("WeaponsSystem.Network.WeaponHit"),
            findRemote("WeaponsSystem.Network.Hit")
        }
        for _,r in ipairs(hits) do
            if r then
                local jp=hitPos
                grFire(r,{jp,part,amt},"dmg")
                grFire(r,{victim,jp,part,amt},"dmg")
            end
        end
    end)
    end
    pcall(function()
        if not AR then AR=RS:FindFirstChild("AdminRemote") or RS:FindFirstChild("HDAdminRemote") end
        if AR then AR:FireServer("damage",victim.Name,amt) end
    end)
end
local function weaponHitScan(force)
    if ST._learnCPend then
        ST._learnCPend=nil
        pcall(function() ntf("Learn","Combat args learned - your shots can damage now",5) end)
    end
    if not force and not ST.weaponDmgOn then return end
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
            dealWeaponDamage(pl,hit.Position,force)
            return
        end
    end
    if aimed and ST.aimTarget and ST.aimTarget.Character then
        local tp=ST.aimTarget.Character:FindFirstChild(ST.aimTargetPart) or ST.aimTarget.Character:FindFirstChild("HumanoidRootPart")
        local h=ST.aimTarget.Character:FindFirstChildOfClass("Humanoid")
        if tp and h and h.Health>0 and not (ST.aimTeamCheck and ST.aimTarget.Team==LP.Team) then
            dealWeaponDamage(ST.aimTarget,tp.Position,force)
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
local function sphereKillAt(pos, forcedPl)
    pcall(function()
        local hitPl=forcedPl
        if not hitPl or hitPl==LP or not hitPl.Character then
            hitPl=nil
            for _,pp in pairs(P:GetPlayers()) do
                if pp~=LP and pp.Character and pp.Character:FindFirstChild("HumanoidRootPart") then
                    local d=(pp.Character.HumanoidRootPart.Position-pos).Magnitude
                    if d<8 then hitPl=pp break end
                end
            end
        end
        if hitPl and hitPl~=LP and hitPl.Character then
            ensureWeaponEquipped()
            mpKillPlayer(hitPl, pos)
            pcall(function()
                if not AR then AR=RS:FindFirstChild("AdminRemote") or RS:FindFirstChild("HDAdminRemote") end
                if AR then AR:FireServer("kill", hitPl.Name) end
            end)
            pcall(function()
                local e=Instance.new("Explosion")
                e.Position=pos
                e.BlastPressure=0
                e.BlastRadius=6
                e.Parent=W
            end)
            ntf("Spheres","Hit "..hitPl.DisplayName.." - MP weapon kill sent")
        end
    end)
end
local function throwSpheres()
    pcall(function()
        if tick()-(ST._sphT or 0)<0.65 then return end
        ST._sphT=tick()
        ensureWeaponEquipped()
        local alive=0
        for _,o in pairs(W:GetChildren()) do
            if o.Name=="AxSphere" then
                alive=alive+1
                if alive>8 then pcall(function() o:Destroy() end) end
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
        for i=1,4 do
            local ball=Instance.new("Part")
            ball.Name="AxSphere"
            ball.Shape=Enum.PartType.Ball
            ball.Size=Vector3.new(1.2,1.2,1.2)
            ball.Material=Enum.Material.Neon
            ball.Color=Color3.fromRGB(255, math.random(60,160), math.random(20,100))
            ball.Anchored=false
            ball.CanCollide=false
            ball.CanQuery=false
            ball.CanTouch=true
            ball.Massless=true
            ball.CFrame=CFrame.new(origin+look*2+right*((i-2.5)*0.4)+up*0.15)
            ball.Parent=W
            local bv=Instance.new("BodyVelocity")
            bv.Velocity=dir*math.random(90,130)+right*((i-2.5)*8)+up*math.random(2,8)
            bv.MaxForce=Vector3.new(1e5,1e5,1e5)
            bv.P=1e4
            bv.Parent=ball
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
                sphereKillAt(ppos, pl)
            end)
            task.delay(1.4,function()
                pcall(function()
                    if ball and ball.Parent then
                        sphereKillAt(ball.Position)
                        ball:Destroy()
                    end
                end)
            end)
        end
        ntf("Spheres","Fired x4 - kills on touch via weapon remotes")
    end)
end
MS.Button1Down:Connect(function()
    if not ST.menuOpen then
        if ST.shotTracer then drawShotTracer() end
        if ST.spheresOn then throwSpheres() end
        if isAimActive() and ST.aimTarget then weaponHitScan() end
        pcall(function()
            local eq=LP.Character and LP.Character:FindFirstChildOfClass("Tool")
            if eq and ST._givenItems and ST._givenItems[eq.Name] then
                local cam=W.CurrentCamera or CAM
                if cam then
                    local origin=cam.CFrame.Position
                    local endPos=origin+cam.CFrame.LookVector*500
                    local fired=false
                    pcall(function()
                        local lg=ST._learnLog
                        if lg then
                            for wpath,arr in pairs(lg) do
                                if string.find(string.lower(wpath),"weaponfired",1,true) then
                                    local rec=arr[1]
                                    if rec and axLearnInst(rec) then
                                        local na={}
                                        local ns=false
                                        for i,a in ipairs(rec.args) do
                                            if typeof(a)=="Vector3" then
                                                na[i]=(i==1) and origin or endPos
                                                ns=true
                                            else
                                                na[i]=a
                                            end
                                        end
                                        if ns and grFire(rec.inst,na,"learnWF") then fired=true break end
                                    end
                                end
                            end
                        end
                    end)
                    if not fired then
                        pcall(function()
                            local r=findRemote("WeaponsSystem.Network.WeaponFired")
                            if r then grFire(r,{origin,endPos},"wf") end
                        end)
                    end
                end
                weaponHitScan(true)
            end
        end)
    end
    if ST.clickTP and LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h and MS.Hit then safeTeleport(MS.Hit.Position+Vector3.new(0,2,0)) end end
end)
local lastInfJump=0
local function vaultJumpUnlock(h)
    if not h then return end
    if not ST.freeCam and not ST.spectateOverhead and h.PlatformStand then h.PlatformStand=false end
    if h.Health<=0 then h.Health=h.MaxHealth end
    pcall(function() h:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end)
    pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end)
end
U.JumpRequest:Connect(function()
    if ST.infJump and not ST.freeCam and not ST.spectateOverhead and LP.Character and tick()-lastInfJump>0.05 then
        lastInfJump=tick()
        pcall(function()
            vaultJumpUnlock(LP.Character:FindFirstChildOfClass("Humanoid"))
        end)
    end
end)
print("[Axynth] Events OK")
R.RenderStepped:Connect(function()
    pcall(function()
        if ST.menuOpen then
            local nowSel=tick()
            if nowSel-(ST._selT or 0)>0.4 then
                ST._selT=nowSel
                pcall(function()
                    local sel=U.SelectedObject
                    if sel and not sel:IsA("TextBox") then U.SelectedObject=nil end
                end)
                pcall(function()
                    local GS=game:GetService("GuiService")
                    if GS.SelectedObject then GS.SelectedObject=nil end
                end)
                if MF then
                    for _,g in pairs(MF:GetDescendants()) do
                        pcall(function() if g:IsA("GuiButton") and g.Selected then g.Selected=false end end)
                    end
                end
            end
        end
    end)
    pcall(function()
        if ST.fly and not ST.freeCam and not ST.spectateOverhead and LP.Character then local h=LP.Character:FindFirstChild("HumanoidRootPart") if h then local dir=Vector3.new(0,0,0) local sp=ST.flySpeed if U:IsKeyDown(Enum.KeyCode.LeftShift) then sp=sp*3 end if U:IsKeyDown(Enum.KeyCode.W) then dir=dir+CAM.CFrame.LookVector end if U:IsKeyDown(Enum.KeyCode.S) then dir=dir-CAM.CFrame.LookVector end if U:IsKeyDown(Enum.KeyCode.A) then dir=dir-CAM.CFrame.RightVector end if U:IsKeyDown(Enum.KeyCode.D) then dir=dir+CAM.CFrame.RightVector end if U:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end if U:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end if dir.Magnitude>0 then dir=dir.Unit h.Velocity=Vector3.new(0,0,0) h.RotVelocity=Vector3.new(0,0,0) h.CFrame=h.CFrame+dir*sp/60 else h.Velocity=Vector3.new(0,0,0) end end end
    end)
    pcall(function()
        if not ST.godmodeLoop or not LP.Character then return end
        local now=tick()
        applyGodLocal()
        local hum=LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if hum.Health<=0 then
                hum.Health=hum.MaxHealth
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            elseif hum.Health<hum.MaxHealth then
                hum.Health=hum.MaxHealth
            end
            if not ST.freeCam and not ST.spectateOverhead and hum.PlatformStand then hum.PlatformStand=false end
        end
        if now-(ST._godScanT or 0)<0.08 then return end
        ST._godScanT=now
        local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local myPos=hrp.Position
        for _,obj in pairs(W:GetChildren()) do
            if obj:IsA("BasePart") and obj~=hrp then
                local nm=obj.Name
                local low=nm:lower()
                if nm=="AxSphere" or low:find("bullet",1,true) or low:find("projectile",1,true) or low:find("shell",1,true) or low:find("round",1,true) or low:find("ammo",1,true) then
                    if (obj.Position-myPos).Magnitude<14 then
                        pcall(function() obj:Destroy() end)
                    end
                end
            end
        end
    end)
    pcall(function()
        if ST.invisible then applyInvisible() end
    end)
    pcall(function()
        if ST.infJump and not ST.freeCam and not ST.spectateOverhead and LP.Character and U:IsKeyDown(Enum.KeyCode.Space) then
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
                if not ST.freeCam and not ST.spectateOverhead and hum.PlatformStand then hum.PlatformStand=false end
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
        if ST.autoSteal and not ST.freeCam and not ST.spectateOverhead and tick()-(ST._stealT or 0)>0.6 then
            ST._stealT=tick()
            doGreenSteal()
        end
    end)
    pcall(function()
        if ST.freeCam or ST.spectateOverhead then return end
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
                pcall(function()
                    if seat.Heat~=nil and seat.Heat<1 then seat.Heat=1 end
                end)
                pcall(function()
                    local model=seat:FindFirstAncestorOfClass("Model")
                    if model then
                        for _,ch in pairs(model:GetDescendants()) do
                            if ch:IsA("VehicleSeat") and ch~=seat then
                                if ST._vehOrig[ch]==nil and ch.MaxSpeed>0 then ST._vehOrig[ch]=ch.MaxSpeed end
                                if ch.MaxSpeed~=target then ch.MaxSpeed=target end
                            end
                            if ch:IsA("LinearVelocity") and ch.MaxForce then
                                ch.MaxForce=math.max(ch.MaxForce, 1e6)
                            end
                            if ch:IsA("BodyVelocity") and ch.MaxForce then
                                ch.MaxForce=Vector3.new(1e6,1e6,1e6)
                            end
                        end
                    end
                end)
            end
        end
    end)
    pcall(function()
        if ST.spinner and not ST.freeCam and not ST.spectateOverhead and LP.Character then local hrp=LP.Character:FindFirstChild("HumanoidRootPart") if hrp then local sv=hrp:FindFirstChild("AxSpin") if not sv then sv=Instance.new("BodyAngularVelocity") sv.Name="AxSpin" sv.AngularVelocity=Vector3.new(0,ST.spinnerSpeed,0) sv.MaxTorque=Vector3.new(0,math.huge,0) sv.P=10000 sv.Parent=hrp end sv.AngularVelocity=Vector3.new(0,ST.spinnerSpeed,0) sv.MaxTorque=Vector3.new(0,math.huge,0) end end
    end)
    pcall(function() if ST.autoClicker then mouse1click() end end)
    pcall(function() if ST.night then L.ClockTime=0 L.Brightness=0 end end)
    pcall(function() if ST.bright then L.Brightness=2 L.GlobalShadows=false L.Ambient=Color3.fromRGB(178,178,178) L.OutdoorAmbient=Color3.fromRGB(178,178,178) end end)
    pcall(function() if ST.noFog then L.FogEnd=999999 L.FogStart=0 local atm=L:FindFirstChildOfClass("Atmosphere") if atm then atm.Density=0 end end end)
    pcall(function()
        if not ST.freeCam and not ST.spectateOverhead and ST.maceTP and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local myRoot=LP.Character.HumanoidRootPart
            local targetRoot=nil
            -- priority: selected player
            if ST.selectedPlayer and ST.selectedPlayer~=LP and ST.selectedPlayer.Character then
                local ch=ST.selectedPlayer.Character
                local hrp=ch:FindFirstChild("HumanoidRootPart")
                local hum=ch:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health>0 then targetRoot=hrp end
            end
            -- fallback: nearest
            if not targetRoot then
                local nearestDist=math.huge
                for _,pp in pairs(P:GetPlayers()) do
                    if pp~=LP and pp.Character and pp.Character:FindFirstChild("HumanoidRootPart") and pp.Character:FindFirstChildOfClass("Humanoid") then
                        local hum2=pp.Character:FindFirstChildOfClass("Humanoid")
                        if hum2.Health>0 then
                            local d=(myRoot.Position-pp.Character.HumanoidRootPart.Position).Magnitude
                            if d<nearestDist then nearestDist=d targetRoot=pp.Character.HumanoidRootPart end
                        end
                    end
                end
            end
            if targetRoot then
                local off=ST.maceTPOffset or 3
                local targetCF=targetRoot.CFrame*CFrame.new(0,0,off)
                local d=(myRoot.Position-targetRoot.Position).Magnitude
                if d>140 then if tick()-(ST._maceTpT or 0)>0.5 then ST._maceTpT=tick() safeTeleport(targetCF.Position) end else myRoot.CFrame=targetCF end
            end
        end
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
                circ.Position=UDim2.new(0.5,0,0.5,0)
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
                        if CFG.ESPShowName then txt=txt..getDisplayName(pp) end
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
                        hl.Enabled=CFG.ESPFillEnabled or CFG.ESPOutlineEnabled
                        ST.espList[pp.UserId]=hl
                    else
                        hl=Instance.new("Highlight")
                        hl.Name="AxESP"
                        hl.Adornee=pp.Character
                        hl.FillColor=CFG.ESPColor
                        hl.FillTransparency=CFG.ESPFillAlpha
                        hl.OutlineColor=CFG.ESPOutlineColor
                        hl.OutlineTransparency=CFG.ESPOutlineEnabled and 0 or 1
                        hl.Enabled=CFG.ESPFillEnabled or CFG.ESPOutlineEnabled
                        hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Parent=pp.Character
                        ST.espList[pp.UserId]=hl
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
            local c=_G.AxArrayList:FindFirstChild("Container") if c then local entries={} local function addE(name) table.insert(entries,name) end if ST.fly then addE("Fly") end if ST.noclip then addE("Noclip") end if ST.esp then addE("ESP") end if ST.infJump then addE("InfJump") end if ST.spinner then addE("Spinner") end if ST.autoClicker then addE("AutoClick") end if ST.godmodeLoop then addE("Godmode") end if ST.invisible then addE("Invis") end if ST.spheresOn then addE("Spheres") end if ST.autoSteal then addE("AutoSteal") end if ST.speedHard then addE("SpeedHard") end if ST.infStamina then addE("InfStam") end if ST.magicBullet then addE("MagicBul") end if ST.weaponDmgOn then addE("WpnDmg") end if ST.maceTP then addE("MaceTP") end if ST.freeCam then addE("FreeCam") end if ST.clickTP then addE("ClickTP") end if ST.bright then addE("Fullbright") end if ST.night then addE("Night") end if ST.noFog then addE("NoFog") end if ST.vehicleSpeedOn then addE("VehicleSpeed") end if ST.botPlay then addE("BotPlay") end if ST.botRecord then addE("BotRec") end local sig=table.concat(entries,"|") if ST._alSig~=sig then ST._alSig=sig for _,ch in pairs(c:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end for i,name in pairs(entries) do local ef=Instance.new("Frame") ef.Size=UDim2.new(0,160,0,22) ef.BackgroundColor3=Color3.fromRGB(0,0,0) ef.BackgroundTransparency=0.4 ef.BorderSizePixel=0 ef.LayoutOrder=i ef.Parent=c mkCorner(ef,4) local et=Instance.new("TextLabel") et.Size=UDim2.new(1,-8,1,0) et.Position=UDim2.new(0,4,0,0) et.BackgroundTransparency=1 et.Text=name et.TextColor3=TH.a et.TextSize=12 et.Font=Enum.Font.GothamBold et.TextXAlignment=Enum.TextXAlignment.Right et.Parent=ef end end end
        elseif _G.AxArrayList then _G.AxArrayList:Destroy() _G.AxArrayList=nil end
    end)
end)
pcall(function() P.PlayerAdded:Connect(function(pp) pp.CharacterAdded:Connect(function(ch) task.wait(1) pcall(function() if ST.esp and pp~=LP then local hl=Instance.new("Highlight") hl.Name="AxESP" hl.FillColor=CFG.ESPColor hl.FillTransparency=CFG.ESPFillAlpha hl.OutlineColor=Color3.new(1,1,1) hl.OutlineTransparency=0 hl.Parent=ch ST.espList[pp.UserId]=hl end end) end) end) end)
pcall(function() LP.CharacterAdded:Connect(function(ch) task.wait(1) ST.savedCollide={} pcall(function() if ST.spinner then task.delay(0.5,function() if ch and LP.Character==ch then local hrp=ch:FindFirstChild("HumanoidRootPart") if hrp then local sv=Instance.new("BodyAngularVelocity") sv.Name="AxSpin" sv.AngularVelocity=Vector3.new(0,ST.spinnerSpeed,0) sv.MaxTorque=Vector3.new(0,math.huge,0) sv.P=10000 sv.Parent=hrp end end end) end end) pcall(function() if ST.speedHard then task.delay(0.5,function() local hum=ch:FindFirstChildOfClass("Humanoid") if hum then hum.WalkSpeed=math.max(ST.speedPreset or 0,50) end end) end end) pcall(function() if ST.godmodeLoop then ST._srvGod=false if ST._godHC then pcall(function() ST._godHC:Disconnect() end) ST._godHC=nil end task.delay(0.3,function() if ch and LP.Character==ch then applyGodLocal() syncServerGod() bindGodHC() end end) end end) pcall(function() if ST.invisible then task.delay(0.3,function() applyInvisible() end) end end) pcall(function() if ST.freeCam then task.delay(0.8,function() if not ST.freeCam then return end local hrp=ch:FindFirstChild("HumanoidRootPart") local hum=ch:FindFirstChildOfClass("Humanoid") if hrp then hrp.Anchored=true hrp.Velocity=Vector3.new(0,0,0) hrp.RotVelocity=Vector3.new(0,0,0) end if hum then hum.WalkSpeed=0 hum.AutoRotate=false end end) end end) end) end)
P.PlayerRemoving:Connect(function(pp) if ST.espList[pp.UserId] then ST.espList[pp.UserId]:Destroy() ST.espList[pp.UserId]=nil end if ST.esp2D and ST.esp2D[pp.UserId] then pcall(function() ST.esp2D[pp.UserId]:Destroy() end) ST.esp2D[pp.UserId]=nil end end)
for _,pp in pairs(P:GetPlayers()) do if pp~=LP and pp.Character and pp.Character:FindFirstChild("AxESP_BB") then pp.Character.AxESP_BB:Destroy() end end
pcall(function() for _,g in pairs({CG,LP:WaitForChild("PlayerGui")}) do for _,v in pairs(g:GetDescendants()) do if v.Name=="AxESP_2D" then v:Destroy() end end end end)
print("[Axynth] MENU LOADED! Press RightShift!")
pcall(function() ntf("Axynth","Loaded! Press RightShift to open",5) end)
end)
if not ok then print("[Axynth] ERROR: "..tostring(err)) end
