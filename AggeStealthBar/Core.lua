local ADDON, A = ...
local _, class = UnitClass("player")
local supported = class == "ROGUE" or class == "DRUID"
local defaults = { enabled = true, showMinimap = true, startupMessage = true, smoothTransitions = true }
local controller, pending, initialized
A.version = C_AddOns.GetAddOnMetadata(ADDON, "Version") or "dev"
A.supported = supported

function A.Print(message)
    print("|cff80e5b0AggeStealthBar:|r " .. message)
end

-- Only this restricted snippet changes pages in combat. Blizzard's own
-- OnAttributeChanged/CalculateAction handles both presentation and execution.
-- Never replace a click/drag handler, binding, texture, or action-slot content.
local refresh = [[
    local bar = self:GetFrameRef("bar")
    local page = bar:GetAttribute("actionpage") or 1
    local active = self:GetAttribute("enabled")
    local stealth = self:GetAttribute("state-stealth") == 1
    local target = self:GetAttribute("stealthpage")
    local catpage = self:GetAttribute("catpage")
    local selected = nil
    if active and stealth and (page == 1 or page == catpage) then
        selected = target
    end
    for i = 1, 12 do
        local button = self:GetFrameRef("button" .. i)
        button:SetAttribute("actionpage", selected)
    end
]]

local function StealthCondition()
    if class == "ROGUE" then return "[stealth] 1; 0" end
    -- Form indices change when forms are learned; identify Cat by spell ID,
    -- never a localized name or a fixed stance number.
    for index = 1, GetNumShapeshiftForms() do
        local _, _, _, spellID = GetShapeshiftFormInfo(index)
        if spellID == 768 then return "[stealth,form:" .. index .. "] 1; 0" end
    end
    return "0"
end

local function Install()
    if controller then return true end
    if not MainActionBar or not MainActionBar:GetAttribute("actionpage") then return false end
    for index = 1, 12 do
        local button = _G["ActionButton" .. index]
        -- Refuse bars already owned by another paging addon.
        if not button or button:GetAttribute("actionpage") ~= nil
            or not button:GetAttribute("useparent-actionpage") then
            A.status = "Another addon owns the main buttons, or the native bar is unavailable."
            return false
        end
    end
    controller = CreateFrame("Frame", "AggeStealthBarController", UIParent, "SecureHandlerStateTemplate")
    controller:SetFrameRef("bar", MainActionBar)
    for index = 1, 12 do
        controller:SetFrameRef("button" .. index, _G["ActionButton" .. index])
    end
    controller:SetAttribute("stealthpage", class == "DRUID" and 8 or 7)
    controller:SetAttribute("catpage", class == "DRUID" and 7 or 1)
    controller:SetAttribute("refresh", refresh)
    controller:SetAttribute("_onstate-stealth", [[self:RunAttribute("refresh")]])
    -- Reconsider the stealth override when the native page changes. Outside
    -- stealth leave actionpage unset so native form changes cannot get pinned.
    controller:WrapScript(MainActionBar, "OnAttributeChanged", [[return nil, true]], [[
        if name == "actionpage" then control:RunAttribute("refresh") end
    ]])
    A.controller = controller
    if A.SetupTransitions then A.SetupTransitions(class == "DRUID" and 8 or 7) end
    return true
end

function A.Apply()
    if not initialized then return end
    if InCombatLockdown() then
        pending = true
        A.status = "Settings will apply after combat."
        return
    end
    pending = nil
    if not supported then
        A.status = "Stealth paging is available for rogues and druids."
        return
    end
    if not controller and not AggeStealthBarDB.enabled then
        A.status = "Disabled. Blizzard controls the main bar."
        return
    end
    if not Install() then
        A.status = A.status or "Waiting for Blizzard's main action bar."
        return
    end
    controller:SetAttribute("enabled", AggeStealthBarDB.enabled)
    RegisterStateDriver(controller, "stealth", StealthCondition())
    controller:Execute([[self:RunAttribute("refresh")]])
    A.status = AggeStealthBarDB.enabled
        and "Enabled. Blizzard buttons, artwork and controls are preserved."
        or "Disabled. Blizzard controls the main bar."
end

function A.SetOption(key, value)
    if defaults[key] == nil or type(value) ~= "boolean" then return end
    AggeStealthBarDB[key] = value
    A.Apply()
    if A.UpdateMinimap then A.UpdateMinimap() end
    if A.UpdateTransitions then A.UpdateTransitions() end
    if A.RefreshOptions then A.RefreshOptions() end
end

function A.Reset()
    for key, value in pairs(defaults) do AggeStealthBarDB[key] = value end
    A.Apply()
    if A.UpdateMinimap then A.UpdateMinimap() end
    if A.UpdateTransitions then A.UpdateTransitions() end
    if A.RefreshOptions then A.RefreshOptions() end
end

local events = CreateFrame("Frame")
for _, event in ipairs({"ADDON_LOADED", "PLAYER_LOGIN", "PLAYER_ENTERING_WORLD",
    "PLAYER_REGEN_ENABLED", "UPDATE_SHAPESHIFT_FORMS"}) do events:RegisterEvent(event) end
events:SetScript("OnEvent", function(_, event, name)
    if event == "ADDON_LOADED" and name == ADDON then
        if type(AggeStealthBarDB) ~= "table" then AggeStealthBarDB = {} end
        for key, value in pairs(defaults) do
            if type(AggeStealthBarDB[key]) ~= "boolean" then AggeStealthBarDB[key] = value end
        end
        if type(AggeStealthBarDB.minimap) ~= "table" then AggeStealthBarDB.minimap = {minimapPos = 225} end
        initialized = true
        return
    end
    if not initialized then return end
    if event == "PLAYER_REGEN_ENABLED" and not pending then return end
    A.Apply()
    if A.RefreshOptions then A.RefreshOptions() end
    if event ~= "PLAYER_LOGIN" then return end
    if A.RegisterOptions then A.RegisterOptions() end
    if A.UpdateMinimap then A.UpdateMinimap() end
    if AggeStealthBarDB.startupMessage then
        A.Print("v" .. A.version .. " loaded. /asb for settings.")
    end
end)
