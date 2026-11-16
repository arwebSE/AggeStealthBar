local class, conflict = ...
local A, events, combat, condition = {}, {}, false
local Frame = {}
Frame.__index = Frame
function Frame:GetAttribute(key) return self.attributes[key] end
function Frame:SetAttribute(key, value)
    self.attributes[key] = value
    if self.scripts.OnAttributeChanged then self.scripts.OnAttributeChanged(self, key, value) end
    if key == 'state-stealth' and self.attributes['_onstate-stealth'] then
        self:Execute(self.attributes['_onstate-stealth'])
    end
end
function Frame:SetFrameRef(key, value) self.refs[key] = value end
function Frame:GetFrameRef(key) return self.refs[key] end
function Frame:RunAttribute(key) return self:Execute(self.attributes[key]) end
function Frame:Execute(code)
    local fn = assert(loadstring(code))
    setfenv(fn, setmetatable({self = self}, {__index = _G}))
    return fn()
end
function Frame:WrapScript(frame, script, pre, post)
    local old = frame.scripts[script]
    frame.scripts[script] = function(target, name, value)
        local environment = setmetatable({self = target, control = self, name = name, value = value}, {__index = _G})
        local allow, message = setfenv(assert(loadstring(pre)), environment)()
        if allow == false then return end
        if old then old(target, name, value) end
        if post and message ~= nil then
            environment.message = message
            setfenv(assert(loadstring(post)), environment)()
        end
    end
end
function Frame:RegisterEvent(event) events[event] = self end
function Frame:SetScript(key, fn) self.scripts[key] = fn end
function CreateFrame(_, name)
    local frame = setmetatable({attributes = {}, refs = {}, scripts = {}}, Frame)
    if name then _G[name] = frame end
    return frame
end
function UnitClass() return class, class end
function InCombatLockdown() return combat end
function GetNumShapeshiftForms() return #forms end
function GetShapeshiftFormInfo(index) return nil, nil, nil, forms[index] end
function RegisterStateDriver(frame, state, rule)
    assert(not combat, 'insecure driver registration in combat')
    condition = rule
    -- Blizzard's resolveDriver converts numeric macro results with tonumber.
    frame:SetAttribute('state-' .. state, 0)
end
C_AddOns = {GetAddOnMetadata = function() return 'test' end}
forms = {5487, 768, 1066}
MainActionBar = CreateFrame('Frame')
MainActionBar:SetAttribute('actionpage', 1)
local clicks = function() end
for i = 1, 12 do
    local b = CreateFrame('Button', 'ActionButton' .. i)
    b:SetAttribute('useparent-actionpage', true)
    b:SetScript('OnClick', clicks)
    b:SetScript('OnDragStart', clicks)
end
if conflict then ActionButton1:SetAttribute('actionpage', 4) end
local function Fire(event, ...) events[event].scripts.OnEvent(events[event], event, ...) end
assert(loadfile('AggeStealthBar/Core.lua'))('AggeStealthBar', A)
Fire('ADDON_LOADED', 'AggeStealthBar')
Fire('PLAYER_LOGIN')
if class == 'MAGE' or conflict then
    assert(not A.controller)
    return
end
local function ExplicitPage(page)
    for i = 1, 12 do assert(_G['ActionButton' .. i]:GetAttribute('actionpage') == page, 'page mismatch') end
end
local function Page(page)
    for i = 1, 12 do
        local own = _G['ActionButton' .. i]:GetAttribute('actionpage')
        assert((own or MainActionBar:GetAttribute('actionpage')) == page, 'effective page mismatch')
    end
end
local function Stealth(value) A.controller:SetAttribute('state-stealth', value and 1 or 0) end
Page(1)
if class == 'DRUID' then assert(condition == '[stealth,form:2] 1; 0') end
combat = true
Stealth(true)
Page(class == 'DRUID' and 8 or 7)
-- Stock parent changes must still refresh children while in stealth/combat.
MainActionBar:SetAttribute('actionpage', 2)
Page(2)
MainActionBar:SetAttribute('actionpage', 12)
Page(12)
MainActionBar:SetAttribute('actionpage', class == 'DRUID' and 7 or 1)
Page(class == 'DRUID' and 8 or 7)
Stealth(false)
Page(class == 'DRUID' and 7 or 1)
-- Outside stealth there must be no private page to pin the previous form.
-- Native caster/bear/cat changes must work even without a wrapper callback.
ExplicitPage(nil)
local wrapper = MainActionBar.scripts.OnAttributeChanged
MainActionBar.scripts.OnAttributeChanged = nil
MainActionBar:SetAttribute('actionpage', 1)
Page(1)
MainActionBar:SetAttribute('actionpage', 9)
Page(9)
MainActionBar:SetAttribute('actionpage', 1)
MainActionBar.scripts.OnAttributeChanged = wrapper
A.SetOption('enabled', false)
assert(A.controller:GetAttribute('enabled') == true)
combat = false
Fire('PLAYER_REGEN_ENABLED')
ExplicitPage(nil)
MainActionBar:SetAttribute('actionpage', 1)
ExplicitPage(nil)
A.SetOption('enabled', true)
Stealth(true)
Page(class == 'DRUID' and 8 or 7)
if class == 'DRUID' then
    forms = {768, 5487}
    Fire('UPDATE_SHAPESHIFT_FORMS')
    assert(condition == '[stealth,form:1] 1; 0')
    forms = {}
    Fire('UPDATE_SHAPESHIFT_FORMS')
    assert(condition == '0')
end
A.Reset()
for i = 1, 12 do
    local b = _G['ActionButton' .. i]
    assert(b.scripts.OnClick == clicks and b.scripts.OnDragStart == clicks)
    assert(b:GetAttribute('useparent-actionpage') == true)
end
