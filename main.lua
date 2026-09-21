print("[AXYNTH] Script loaded via loadstring!")
local ok, err = pcall(function()
    print("[AXYNTH] Inside pcall")
    local P = game:GetService("Players")
    local LP = P.LocalPlayer
    print("[AXYNTH] Player: " .. LP.Name)
    
    local CG = game:GetService("CoreGui")
    local SG = Instance.new("ScreenGui")
    SG.Name = "AxynthTest"
    pcall(function() SG.Parent = CG end)
    if not SG.Parent then SG.Parent = LP:WaitForChild("PlayerGui") end
    
    local F = Instance.new("Frame")
    F.Size = UDim2.new(0, 200, 0, 100)
    F.Position = UDim2.new(0.5, -100, 0.5, -50)
    F.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    F.BorderSizePixel = 0
    F.Parent = SG
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)
    
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, 0, 1, 0)
    L.BackgroundTransparency = 1
    L.Text = "AXYNTH LOADED! F4 to toggle"
    L.TextColor3 = Color3.new(1, 1, 1)
    L.TextScaled = true
    L.Font = Enum.Font.GothamBold
    L.Parent = F
    
    print("[AXYNTH] GUI created!")
    
    game:GetService("UserInputService").InputBegan:Connect(function(inp, gpe)
        if not gpe and inp.KeyCode == Enum.KeyCode.F4 then
            F.Visible = not F.Visible
            print("[AXYNTH] F4 pressed! visible=" .. tostring(F.Visible))
        end
    end)
    print("[AXYNTH] F4 hotkey set! Press F4 now!")
end)
if not ok then print("[AXYNTH] ERROR: " .. tostring(err)) end