local ADDON, A = ...
local window, category
local controls, statuses = {}, {}

local function Text(parent, value, x, y, font)
    local label = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
    label:SetPoint("TOPLEFT", x, y)
    label:SetWidth(450)
    label:SetJustifyH("LEFT")
    label:SetText(value)
    return label
end

function A.RefreshOptions()
    if not AggeStealthBarDB then return end
    for _, control in ipairs(controls) do control:SetChecked(AggeStealthBarDB[control.key]) end
    for _, label in ipairs(statuses) do label:SetText(A.status or "Waiting for the main action bar.") end
end

local function Contents(parent)
    Text(parent, "AggeStealthBar", 0, 0, "GameFontNormalLarge")
    Text(parent, "Native stealth and prowl paging for WoW Forever", 0, -30)
    local options = {
        {"enabled", "Enable stealth / prowl bar"},
        {"showMinimap", "Show minimap button"},
        {"startupMessage", "Show startup message"},
    }
    for index, option in ipairs(options) do
        local check = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
        check:SetPoint("TOPLEFT", -2, -65 - (index - 1) * 34)
        check.Text:SetText(option[2])
        check.key = option[1]
        check:SetScript("OnClick", function(self) A.SetOption(self.key, self:GetChecked() == true) end)
        controls[#controls + 1] = check
    end
    Text(parent, "Enter Stealth (rogue) or Cat Form + Prowl (druid), then place your spells on the main bar. Your layout is saved by WoW.", 0, -182)
    Text(parent, "Uses rogue page 7 / druid page 8. Manual pages and other forms keep their native behavior. Hold your usual pickup modifier (normally Shift) to move locked actions.", 0, -238)
    statuses[#statuses + 1] = Text(parent, "", 0, -308, "GameFontNormal")
    local reset = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    reset:SetSize(140, 26)
    reset:SetPoint("TOPLEFT", 0, -360)
    reset:SetText("Reset settings")
    reset:SetScript("OnClick", A.Reset)
    Text(parent, "Resets preferences only. Your spells stay in their slots.", 0, -396, "GameFontHighlightSmall")
    parent:SetScript("OnShow", A.RefreshOptions)
    A.RefreshOptions()
end

function A.ToggleOptions()
    if window then window:SetShown(not window:IsShown()); return end
    window = CreateFrame("Frame", "AggeStealthBarSettings", UIParent, "PortraitFrameTemplate")
    window.PortraitContainer:Hide()
    if NineSliceUtil then NineSliceUtil.ApplyLayoutByName(window.NineSlice, "ButtonFrameTemplateNoPortrait") end
    window.TitleContainer.TitleText:SetText(ADDON)
    window.Bg:SetTexture("Interface\\FrameGeneral\\UI-Background-Rock")
    window.Bg:SetVertexColor(0.65, 0.65, 0.65)
    window:SetSize(520, 510)
    window:SetPoint("CENTER")
    window:SetFrameStrata("DIALOG")
    window:SetToplevel(true)
    window:SetClampedToScreen(true)
    window:SetMovable(true)
    window:EnableMouse(true)
    local drag = CreateFrame("Frame", nil, window)
    drag:SetPoint("TOPLEFT", 8, -2)
    drag:SetPoint("TOPRIGHT", -30, -2)
    drag:SetHeight(26)
    drag:EnableMouse(true)
    drag:RegisterForDrag("LeftButton")
    drag:SetScript("OnDragStart", function() window:StartMoving() end)
    drag:SetScript("OnDragStop", function() window:StopMovingOrSizing() end)
    window:SetScript("OnHide", function() window:StopMovingOrSizing() end)
    local content = CreateFrame("Frame", nil, window)
    content:SetPoint("TOPLEFT", 28, -50)
    content:SetSize(460, 430)
    Contents(content)
    UISpecialFrames[#UISpecialFrames + 1] = "AggeStealthBarSettings"
end

function A.RegisterOptions()
    if category then return end
    local canvas = CreateFrame("Frame")
    canvas:Hide()
    local content = CreateFrame("Frame", nil, canvas)
    content:SetPoint("TOPLEFT", 20, -20)
    content:SetSize(460, 430)
    Contents(content)
    category = Settings.RegisterCanvasLayoutCategory(canvas, ADDON)
    Settings.RegisterAddOnCategory(category)
end

SLASH_AGGESTEALTHBAR1 = "/asb"
SLASH_AGGESTEALTHBAR2 = "/aggestealthbar"
SlashCmdList.AGGESTEALTHBAR = A.ToggleOptions
