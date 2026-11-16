local A, textures = {}, {}
AggeStealthBarDB = {enabled = true, smoothTransitions = true}
MainActionBar = {GetAttribute = function() return 7 end}
local function Texture()
    local texture = {alpha = 1}
    function texture:SetAlpha(value) self.alpha = value end
    function texture:SetAllPoints() end
    function texture:SetColorTexture() end
    function texture:SetTexture() end
    function texture:SetBlendMode() end
    function texture:SetVertexColor() end
    function texture:SetPoint() end
    function texture:CreateAnimationGroup()
        local group = {plays = 0, scripts = {}}
        function group:CreateAnimation()
            return setmetatable({}, {__index = function() return function() end end})
        end
        function group:SetScript(key, fn) self.scripts[key] = fn end
        function group:Stop() self.playing = false; self.scripts.OnStop() end
        function group:Play() self.playing = true; self.plays = self.plays + 1 end
        self.group = group
        return group
    end
    textures[#textures + 1] = texture
    return texture
end
for index = 1, 12 do
    local button = {icon = {}, page = 1}
    function button:CreateTexture() return Texture() end
    function button:GetAttribute() return self.page end
    function button:HookScript(_, callback) self.callback = callback end
    function button:Page(value) self.page = value; self.callback(self, 'actionpage', value) end
    _G['ActionButton' .. index] = button
end
assert(loadfile('AggeStealthBar/Transitions.lua'))('AggeStealthBar', A)
A.SetupTransitions(8)
assert(#textures == 24)
A.SetupTransitions(8)
assert(#textures == 24, 'repeated setup must not duplicate effects')
for _, texture in ipairs(textures) do assert(texture.alpha == 0 and texture.group.plays == 0) end
local button = ActionButton1
button:Page(7)
assert(textures[1].group.plays == 0, 'ordinary form changes must not flash')
button:Page(8)
assert(textures[1].group.plays == 1 and button.page == 8, 'effect must not delay paging')
button:Page(8)
assert(textures[1].group.plays == 1, 'same-page refresh must not restart effects')
button:Page(nil)
assert(textures[1].group.plays == 2, 'leaving stealth also animates')
AggeStealthBarDB.smoothTransitions = false
A.UpdateTransitions()
for _, texture in ipairs(textures) do assert(not texture.group.playing and texture.alpha == 0) end
button:Page(8)
assert(textures[1].group.plays == 2, 'disabled transitions must not play')
AggeStealthBarDB.smoothTransitions = true
issecretvalue = function(value) return value == 'secret' end
button:Page('secret')
button:Page(7)
assert(textures[1].group.plays == 2, 'unreadable pages must not animate')
