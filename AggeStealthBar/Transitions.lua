local _, A = ...
local effects = {}

-- Animate our own textures only. Native icons, cooldowns, button alpha,
-- visibility, click handlers and protected paging are never animated.
local function Fade(texture, opacity, duration)
    texture:SetAlpha(0)
    local group = texture:CreateAnimationGroup()
    local fade = group:CreateAnimation("Alpha")
    fade:SetFromAlpha(opacity)
    fade:SetToAlpha(0)
    fade:SetDuration(duration)
    fade:SetSmoothing("OUT")
    local function Clear() texture:SetAlpha(0) end
    group:SetScript("OnFinished", Clear)
    group:SetScript("OnStop", Clear)
    return group
end

function A.UpdateTransitions()
    if AggeStealthBarDB.enabled and AggeStealthBarDB.smoothTransitions then return end
    for _, effect in ipairs(effects) do
        effect.shadow:Stop()
        effect.glow:Stop()
    end
end

function A.SetupTransitions(stealthPage)
    if #effects > 0 then return end
    for index = 1, 12 do
        local button = _G["ActionButton" .. index]
        local icon = button.icon or button.Icon
        if icon then
            local shadow = button:CreateTexture(nil, "OVERLAY", nil, 0)
            shadow:SetAllPoints(icon)
            shadow:SetColorTexture(0.035, 0.015, 0.065, 1)
            local glow = button:CreateTexture(nil, "OVERLAY", nil, 1)
            glow:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
            glow:SetBlendMode("ADD")
            glow:SetVertexColor(0.65, 0.38, 1)
            glow:SetPoint("TOPLEFT", icon, "TOPLEFT", -9, 9)
            glow:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 9, -9)
            local effect = {shadow = Fade(shadow, 0.24, 0.06), glow = Fade(glow, 0.30, 0.10)}
            effects[#effects + 1] = effect
            local previous = button:GetAttribute("actionpage") or MainActionBar:GetAttribute("actionpage")
            button:HookScript("OnAttributeChanged", function(_, name, page)
                if name ~= "actionpage" then return end
                -- Clearing our override restores the inherited native page.
                page = page or MainActionBar:GetAttribute("actionpage")
                if issecretvalue and issecretvalue(page) then previous = nil; return end
                local old = previous
                previous = page
                if not old or not page or old == page then return end
                if old ~= stealthPage and page ~= stealthPage then return end
                if not AggeStealthBarDB.enabled or not AggeStealthBarDB.smoothTransitions then return end
                effect.shadow:Stop()
                effect.glow:Stop()
                effect.shadow:Play()
                effect.glow:Play()
            end)
        end
    end
end
