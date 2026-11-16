# Implementation notes

The original addon adds a `SecureHandlerStateTemplate` controller with a secure `[stealth]` condition; druids also require the Cat Form index identified by spell ID 768. The controller supplies an explicit `actionpage` to the twelve existing Blizzard action buttons. A secure post-wrapper mirrors native parent-page changes, preserving manual pages and special bars. Turning the feature off clears the explicit child pages and restores their existing parent inheritance. It never replaces Blizzard click/drag handlers, bindings, slot contents, art or protected global functions.

Page mappings (rogue 7; cat 7; prowling cat 8) and live secure execution require the in-game acceptance checks. No claim of live verification is made. The current implementation targets the stock keyboard/mouse bar only. Initial child-attribute ownership checks catch some conflicts, not every addon loading later.

Reference inspected: [Forever UI source snapshot bebcb6bf](https://github.com/Gethe/wow-ui-source/tree/bebcb6bf309cf41b41bd74f8ca651e6a105b2676), specifically `Blizzard_ActionBar/Shared/ActionButton.lua`, `Blizzard_ActionBarController/ActionBarController.lua`, `Blizzard_FrameXML/SecureTemplates.lua`, and `Blizzard_RestrictedAddOnEnvironment/SecureHandlers.lua`. This is a public mirror of Blizzard UI source, not competitor addon code. The secure wrapper's pre-body returns a message so its post-body runs; tests exercise this behavior.

Only the public descriptions of [Stealthbarfix](https://www.curseforge.com/wow/addons/stealthbarfix), [ForeverStealthBarFix](https://www.curseforge.com/wow/addons/foreverstealthbarfix) and [ProwlBar-Forever](https://www.curseforge.com/wow/addons/prowlbar-forever) were reviewed. Their archives/source were not downloaded or copied. Existing AggeMinimap and AggeHealBot repositories supplied the requested family style, startup convention and identical library snapshot.

The release workflow uses [BigWigsMods/packager](https://github.com/BigWigsMods/packager), as AggeHealBot does. A CurseForge project ID and author-upload token must be configured before tag publishing.
