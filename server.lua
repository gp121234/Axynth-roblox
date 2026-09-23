-- Axynth Server Script v2
-- Vale auton ton kwdiko sthn ServerScriptService > Script
local RS = game:GetService("ReplicatedStorage")
local P = game:GetService("Players")

local AR = RS:FindFirstChild("AdminRemote")
if not AR then AR = Instance.new("RemoteEvent") AR.Name = "AdminRemote" AR.Parent = RS end

local function getPl(name)
    for _, p in pairs(P:GetPlayers()) do
        if p.Name == name or p.DisplayName == name then return p end
    end
    return nil
end

local function getAll(count)
    local list = {}
    for _, p in pairs(P:GetPlayers()) do
        table.insert(list, p)
        if count and #list >= count then break end
    end
    return list
end

local function getTargets(pl, count)
    if pl and pl ~= 0 then
        local p = getPl(tostring(pl))
        if p then return {p} end
    end
    return getAll(count)
end

local function addFX(char, name, fx)
    if char:FindFirstChild(name) then return end
    fx.Name = name
    fx.Parent = char
end

local function removeFX(char, name)
    local f = char:FindFirstChild(name)
    if f then f:Destroy() end
end

local lastRemote = 0
local remoteCount = 0
local remoteReset = tick()

AR.OnServerEvent:Connect(function(player, action, ...)
    local args = {...}

    local now = tick()
    if now - remoteReset > 60 then remoteCount = 0 remoteReset = now end
    remoteCount = remoteCount + 1
    if remoteCount > 120 then return end

    if action == "bring" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character and player.Character then
                local tp = t.Character:FindFirstChild("HumanoidRootPart")
                local mp = player.Character:FindFirstChild("HumanoidRootPart")
                if tp and mp then tp.CFrame = mp.CFrame + Vector3.new(3, 0, 0) end
            end
        end

    elseif action == "freeze" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                for _, p in pairs(t.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.Anchored = true end
                end
            end
        end

    elseif action == "unfreeze" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                for _, p in pairs(t.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.Anchored = false end
                end
            end
        end

    elseif action == "kill" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local h = t.Character:FindFirstChildOfClass("Humanoid")
                if h then h.Health = 0 end
            end
        end

    elseif action == "damage" then
        local targets = getTargets(args[1], 1)
        local amount = tonumber(args[2]) or 30
        if amount < 0 then amount = 0 end
        if amount > 200 then amount = 200 end
        for _, t in pairs(targets) do
            if t ~= player and t.Character then
                local h = t.Character:FindFirstChildOfClass("Humanoid")
                if h and h.Health > 0 then
                    h.Health = math.max(0, h.Health - amount)
                end
            end
        end

    elseif action == "heal" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local h = t.Character:FindFirstChildOfClass("Humanoid")
                if h then h.Health = h.MaxHealth end
            end
        end

    elseif action == "godmode" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local h = t.Character:FindFirstChildOfClass("Humanoid")
                if h then
                    h.MaxHealth = 10000000
                    h.Health = 10000000
                end
            end
        end

    elseif action == "ungodmode" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local h = t.Character:FindFirstChildOfClass("Humanoid")
                if h and h.MaxHealth >= 10000000 then
                    h.MaxHealth = 100
                    h.Health = 100
                end
            end
        end

    elseif action == "explode" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local hrp = t.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local e = Instance.new("Explosion")
                    e.Position = hrp.Position
                    e.BlastPressure = 0
                    e.Parent = workspace
                end
            end
        end

    elseif action == "fire" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local h = t.Character:FindFirstChild("Head")
                if h then addFX(t.Character, "AxFire", Instance.new("Fire")) end
            end
        end

    elseif action == "sparkle" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local h = t.Character:FindFirstChild("Head")
                if h then addFX(t.Character, "AxSparkle", Instance.new("Sparkles")) end
            end
        end

    elseif action == "smoke" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local h = t.Character:FindFirstChild("Head")
                if h then addFX(t.Character, "AxSmoke", Instance.new("Smoke")) end
            end
        end

    elseif action == "removefx" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                removeFX(t.Character, "AxFire")
                removeFX(t.Character, "AxSparkle")
                removeFX(t.Character, "AxSmoke")
            end
        end

    elseif action == "bighead" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local head = t.Character:FindFirstChild("Head")
                if head then head.Size = Vector3.new(3, 3, 3) end
            end
        end

    elseif action == "smallhead" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local head = t.Character:FindFirstChild("Head")
                if head then head.Size = Vector3.new(0.5, 0.5, 0.5) end
            end
        end

    elseif action == "spin" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local hrp = t.Character:FindFirstChild("HumanoidRootPart")
                if hrp and not hrp:FindFirstChild("AxSpin") then
                    local bg = Instance.new("BodyAngularVelocity")
                    bg.Name = "AxSpin"
                    bg.AngularVelocity = Vector3.new(0, 20, 0)
                    bg.MaxTorque = Vector3.new(0, math.huge, 0)
                    bg.P = 10000
                    bg.Parent = hrp
                end
            end
        end

    elseif action == "unspin" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local hrp = t.Character:FindFirstChild("HumanoidRootPart")
                if hrp then removeFX(hrp, "AxSpin") end
            end
        end

    elseif action == "trip" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local hrp = t.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Velocity = hrp.CFrame.LookVector * 20 + Vector3.new(0, 10, 0)
                    hrp.RotVelocity = Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
                end
            end
        end

    elseif action == "vibrate" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local hrp = t.Character:FindFirstChild("HumanoidRootPart")
                if hrp and not hrp:FindFirstChild("AxVibrate") then
                    local bg = Instance.new("BodyPosition")
                    bg.Name = "AxVibrate"
                    bg.Position = hrp.Position
                    bg.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bg.P = 5000
                    bg.D = 500
                    bg.Parent = hrp
                    spawn(function()
                        for i = 1, 30 do
                            if hrp and hrp.Parent then
                                bg.Position = hrp.Position + Vector3.new(math.random(-2, 2)/10, math.random(-2, 2)/10, math.random(-2, 2)/10)
                                wait(0.05)
                            end
                        end
                        if bg and bg.Parent then bg:Destroy() end
                    end)
                end
            end
        end

    elseif action == "fling" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local hrp = t.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Velocity = Vector3.new(math.random(-50, 50), 50, math.random(-50, 50))
                    hrp.RotVelocity = Vector3.new(math.random(-30, 30), math.random(-30, 30), math.random(-30, 30))
                end
            end
        end

    elseif action == "ragdoll" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local h = t.Character:FindFirstChildOfClass("Humanoid")
                if h then
                    h.PlatformStand = true
                    spawn(function() wait(3) if h then h.PlatformStand = false end end)
                end
            end
        end

    elseif action == "bang" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local hrp = t.Character:FindFirstChild("HumanoidRootPart")
                if hrp and not hrp:FindFirstChild("AxBang") then
                    local bg = Instance.new("BodyPosition")
                    bg.Name = "AxBang"
                    bg.Position = hrp.Position
                    bg.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bg.P = 10000
                    bg.D = 1000
                    bg.Parent = hrp
                    spawn(function()
                        for i = 1, 50 do
                            if hrp and hrp.Parent then
                                local cf = hrp.CFrame
                                bg.Position = cf.Position + cf.LookVector * 0.3 + Vector3.new(0, -0.5, 0)
                                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, 0, math.rad(20))
                                wait(0.05)
                            end
                        end
                        if bg and bg.Parent then bg:Destroy() end
                    end)
                end
            end
        end

    elseif action == "dance" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local h = t.Character:FindFirstChildOfClass("Humanoid")
                if h then
                    local anim = Instance.new("Animation")
                    anim.AnimationId = "rbxassetid://507771019"
                    local a = h:LoadAnimation(anim)
                    a:Play()
                end
            end
        end

    elseif action == "sleep" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local h = t.Character:FindFirstChildOfClass("Humanoid")
                if h then
                    h.PlatformStand = true
                    spawn(function() wait(5) if h then h.PlatformStand = false end end)
                end
            end
        end

    elseif action == "stomp" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                local h = t.Character:FindFirstChildOfClass("Humanoid")
                if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end) end
            end
        end

    elseif action == "invisible" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                for _, p in pairs(t.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.Transparency = 1 end
                    if p:IsA("Decal") then p.Transparency = 1 end
                end
                local h = t.Character:FindFirstChildOfClass("Humanoid")
                if h then h.Name = "AxHidden" end
            end
        end

    elseif action == "visible" then
        local targets = getTargets(args[1], 1)
        for _, t in pairs(targets) do
            if t.Character then
                for _, p in pairs(t.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.Transparency = 0 end
                    if p:IsA("Decal") then p.Transparency = 0 end
                end
                local h = t.Character:FindFirstChildOfClass("Humanoid")
                if h then h.Name = "Humanoid" end
            end
        end

    elseif action == "spawnSpheres" then
        local origin = args[1]
        local target = args[2]
        if typeof(origin) ~= "Vector3" or typeof(target) ~= "Vector3" then return end
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if (origin - hrp.Position).Magnitude > 80 then origin = hrp.Position end
        local dir = (target - origin)
        if dir.Magnitude < 1 then return end
        dir = dir.Unit
        local shooter = player
        for i = 1, 10 do
            local ball = Instance.new("Part")
            ball.Name = "AxSphere"
            ball.Shape = Enum.PartType.Ball
            ball.Size = Vector3.new(1.4, 1.4, 1.4)
            ball.Material = Enum.Material.Neon
            ball.Color = Color3.fromRGB(255, math.random(60, 160), math.random(20, 100))
            ball.Anchored = false
            ball.CanCollide = false
            ball.CanQuery = false
            ball.CanTouch = true
            ball.Massless = true
            local side = (i - 5.5) * 0.35
            ball.CFrame = CFrame.new(origin + dir * 2 + Vector3.new(side, 0.15, 0))
            ball.Parent = workspace
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = dir * math.random(90, 130) + Vector3.new(side * 8, math.random(2, 8), 0)
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.P = 1e4
            bv.Parent = ball
            local light = Instance.new("PointLight")
            light.Color = ball.Color
            light.Range = 14
            light.Brightness = 2
            light.Parent = ball
            local dead = false
            ball.Touched:Connect(function(hit)
                if dead then return end
                if not hit or not hit:IsA("BasePart") then return end
                local model = hit:FindFirstAncestorOfClass("Model")
                if not model then return end
                local hum = model:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                local victim = P:GetPlayerFromCharacter(model)
                if not victim or victim == shooter then return end
                dead = true
                local pos = ball.Position
                pcall(function() ball:Destroy() end)
                pcall(function() hum.Health = 0 end)
                pcall(function()
                    local e = Instance.new("Explosion")
                    e.Position = pos
                    e.BlastPressure = 0
                    e.BlastRadius = 6
                    e.Parent = workspace
                end)
            end)
            game:GetService("Debris"):AddItem(ball, 2.5)
        end
    end
end)

print("[Axynth] Server v2 loaded!")
