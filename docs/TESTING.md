# In-game acceptance checks

Run on Forever 1.60.1 with script errors enabled (`/console scriptErrors 1`). Start with only this addon, then repeat alongside AggeHealBot and AggeMinimap. Test a rogue and a druid independently. No live-client verification has been performed for 0.1.0.

- Enter/leave Stealth and Cat Form + Prowl using a spellbook click, action-bar click, keybind and macro. Check all twelve buttons and their keyboard actions select the same slots. Repeat in combat, including Vanish and breaking stealth by attacking.
- Druid: learn Cat Form, reorder available form indices by learning forms, change between caster/cat/bear/travel/aquatic/moonkin as available; ensure only prowling Cat uses page 8. Verify other form pages remain intact.
- With locked action bars, Shift-drag Prowl/Stealth off the bar and back. It must not cast on mouse-down. Repeat with unlocked bars and both game-wide key-down settings. Compare directly with the same Blizzard buttons while the addon is disabled.
- Verify macros, items, spell ranks, flyouts, range/usability colors, charges, cooldowns, tooltips, bindings, empty-slot art and Edit Mode positioning/scaling match the native bar. Capture before/after screenshots at identical scale.
- Switch manual pages while stealthed; test possession, vehicles, overrides and death/revival where available. Check both visuals and executed abilities.
- Disable/re-enable outside combat and during combat. Changes must defer until combat ends and restore the current native page. Reset preferences must preserve all action slots.
- Reload/login in stealth and in combat. Watch for blocked-action/taint errors. The simulation cannot validate the client's restricted execution environment.
- Open `/asb`, Escape/close it, open Options → AddOns, toggle the minimap button and startup message, drag the minimap icon and reload. Confirm per-character persistence and readability at different UI scales.
- Disable competing bar addons. Initial ownership checks are best effort; addons loading later can still conflict. Check unsupported classes keep their stock bar.

Record client build, class, result and any error text before promoting the test build.
