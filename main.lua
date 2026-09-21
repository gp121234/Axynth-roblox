print("[Axynth] Fetching...")
local c = game:HttpGet("https://raw.githubusercontent.com/gp121234/Axynth-roblox/main/main.lua?t=" .. tick())
print("[Axynth] Got " .. #c .. " chars")
local fn, serr = loadstring(c)
if fn then
    print("[Axynth] Compiled OK, running...")
    local rok, rerr = pcall(fn)
    print("[Axynth] Result: " .. tostring(rok) .. " " .. tostring(rerr))
else
    print("[Axynth] COMPILE ERROR: " .. tostring(serr))
end