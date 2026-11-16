local ADDON, A = ...
local icon = LibStub("LibDBIcon-1.0")
local launcher = LibStub("LibDataBroker-1.1"):NewDataObject(ADDON, {
    type = "launcher", text = ADDON,
    icon = "Interface\\AddOns\\AggeStealthBar\\Media\\Icon",
    OnClick = function(_, button)
        if button == "LeftButton" or button == "RightButton" then A.ToggleOptions() end
    end,
    OnTooltipShow = function(tooltip)
        tooltip:SetText(ADDON, 1, 0.82, 0)
        tooltip:AddLine("Click to toggle settings. Drag to move.", 1, 1, 1)
    end,
})

function A.UpdateMinimap()
    if not AggeStealthBarDB then return end
    local db = AggeStealthBarDB.minimap
    db.hide = not AggeStealthBarDB.showMinimap
    if not icon:IsRegistered(ADDON) then icon:Register(ADDON, launcher, db) end
    if db.hide then icon:Hide(ADDON) else icon:Show(ADDON) end
end
