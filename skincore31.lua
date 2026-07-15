-- ============================================================
--  SKIN CHANGER
--  Minimal Working Version
-- ============================================================

-- Weapons
local Weapons = {
    ["Bayonet"] = 42,
    ["Classic Knife"] = 500,
    ["Flip Knife"] = 505,
    ["Gut Knife"] = 506,
    ["Karambit"] = 507,
    ["M9 Bayonet"] = 508,
    ["Huntsman"] = 509,
    ["Falchion"] = 512,
    ["Bowie Knife"] = 514,
    ["Butterfly"] = 515,
    ["Shadow Daggers"] = 516,
    ["Paracord Knife"] = 517,
    ["Survival Knife"] = 518,
    ["Ursus Knife"] = 519,
    ["Navaja Knife"] = 520,
    ["Nomad Knife"] = 521,
}

-- Skins
local Skins = {
    ["None"] = 0,
    ["Autotronic"] = 10048,
    ["Black Laminate"] = 408,
    ["Blue Steel"] = 34,
    ["Boreal Forest"] = 43,
    ["Bright Water"] = 836,
    ["Case Hardened"] = 39,
    ["Crimson Web"] = 400,
    ["Damascus Steel"] = 409,
    ["Doppler"] = 411,
    ["Fade"] = 38,
    ["Marble Fade"] = 413,
    ["Tiger Tooth"] = 412,
    ["Gamma Doppler"] = 414,
    ["Lore"] = 10056,
}

local state = {
    wear = 0.000,
    seed = 0,
    currentWeapon = "Karambit",
    currentSkin = "Fade",
}

function ApplySkin(weapon, skin)
    local wid = Weapons[weapon]
    local sid = Skins[skin]
    if wid and sid then
        executeCommand(string.format("skins %d %d %d %.3f %d", wid, sid, sid, state.wear, state.seed))
        print("[✓] " .. skin .. " on " .. weapon)
    end
end

function RemoveSkin()
    executeCommand("skins 0")
    print("[✓] Removed")
end

-- ============================================================
--  GUI - ONE WINDOW WITH EVERYTHING
-- ============================================================

local win = gui.Window("skin", "Skin Changer31", 10, 10, 500, 450)

-- Weapons
local wg = gui.Groupbox(win, "Weapons", 10, 10, 500, 450)
local wl = gui.Listbox(wg, "", 10, 20, 450, 400)
local wn = {}
for k, v in pairs(Weapons) do table.insert(wn, k) end
table.sort(wn)
wl:SetItems(wn)
wl:SetValue(1)

-- Skins
local sg = gui.Groupbox(win, "Skins", 250, 10, 230, 280)
local sl = gui.Listbox(sg, "", 10, 20, 210, 240)
local sn = {}
for k, v in pairs(Skins) do table.insert(sn, k) end
table.sort(sn)
sl:SetItems(sn)
sl:SetValue(1)

-- Settings
local stg = gui.Groupbox(win, "Settings", 10, 300, 470, 80)

local wt = gui.Text(stg, "Wear / Float:", 10, 20, 80, 20)
local ws = gui.Slider(stg, "", 100, 20, 200, 20)
ws:SetMinMax(0, 100)
ws:SetValue(0)
local wv = gui.Text(stg, "0.000", 310, 20, 50, 20)

local st = gui.Text(stg, "Seed:", 10, 45, 40, 20)
local ss = gui.Slider(stg, "", 100, 45, 200, 20)
ss:SetMinMax(0, 999)
ss:SetValue(0)
local sv = gui.Text(stg, "0", 310, 45, 50, 20)

-- Actions
local ag = gui.Groupbox(win, "Actions", 10, 390, 470, 40)

local ab = gui.Button(ag, "Apply", function()
    local wi = wl:GetValue()
    local si = sl:GetValue()
    state.currentWeapon = wn[wi]
    state.currentSkin = sn[si]
    state.wear = ws:GetValue() / 100
    state.seed = ss:GetValue()
    ApplySkin(state.currentWeapon, state.currentSkin)
end)

local rb = gui.Button(ag, "Remove", function()
    RemoveSkin()
end)

local rs = gui.Button(ag, "Reset All", function()
    executeCommand("skins 0")
    ws:SetValue(0)
    ss:SetValue(0)
    wv:SetText("0.000")
    sv:SetText("0")
    state.wear = 0
    state.seed = 0
    print("[✓] Reset")
end)

-- Slider callbacks
ws:SetCallback(function()
    wv:SetText(string.format("%.3f", ws:GetValue() / 100))
end)

ss:SetCallback(function()
    sv:SetText(tostring(ss:GetValue()))
end)

-- Auto-apply on selection
wl:SetCallback(function()
    local wi = wl:GetValue()
    local si = sl:GetValue()
    state.currentWeapon = wn[wi]
    state.currentSkin = sn[si]
    state.wear = ws:GetValue() / 100
    state.seed = ss:GetValue()
    ApplySkin(state.currentWeapon, state.currentSkin)
end)

sl:SetCallback(function()
    local wi = wl:GetValue()
    local si = sl:GetValue()
    state.currentWeapon = wn[wi]
    state.currentSkin = sn[si]
    state.wear = ws:GetValue() / 100
    state.seed = ss:GetValue()
    ApplySkin(state.currentWeapon, state.currentSkin)
end)

win:SetOpenKey(gui.GetValue("adv.menukey"))

-- Auto-apply on load
ApplySkin("Karambit", "Fade")

print("[✓] Skin Changer Loaded")
print("[✓] Open Aimware menu -> Lua -> Skin Changer")
