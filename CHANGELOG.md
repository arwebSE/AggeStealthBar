# Changelog

## 1.0.0

First public release for **WoW Forever 1.60.1**.

- Rogue Stealth and druid Cat Form + Prowl switch the native main bar to page 8 (slots 85–96).
- Leaving stealth restores Blizzard's normal/form paging without pinning a previous form's bar.
- Preserve Blizzard buttons, artwork, keybindings, tooltips, cooldowns and normal action dragging.
- Fast shadow/violet-glow transitions, Blizzard-style settings, an optional LibDBIcon minimap launcher and per-character preferences.
- Refined gold-framed icon, with no telemetry or network requests.

## 0.1.7 — test build

- Refine the icon's gold bezel with even sides and matching corners.

## 0.1.6 — test build

- Use page 8 (slots 85–96) for both rogue Stealth and druid Prowl.
- Handle native rogue page-7 updates without losing the page-8 override. Leave all existing action slots untouched; rogue users switching from earlier builds must arrange page 8 once.

## 0.1.5 — test build

- Keep the startup message and smooth transitions always on; remove their settings and obsolete saved preferences.
- Compact the settings window, simplify interaction instructions, and show status text only when something needs attention.
- Preserve existing rogue page 7 and druid page 8 spell layouts.

## 0.1.4 — test build

- Make transitions snappier: shorten the shadow fade from 160 to 60 ms and edge glow from 240 to 100 ms, with lighter overlays so the new icons read sooner.

## 0.1.3 — test build

- Clear the button page override outside stealth so Cat Form's page cannot remain pinned over the native caster bar.
- Keep normal/form/manual paging inherited from Blizzard; adapt transition effects to clearing the stealth override.
- Add regression coverage for native caster/bear page changes without an addon wrapper callback.

## 0.1.2 — test build

- Add a synchronized 160 ms shadow fade and subtle 240 ms violet edge glow when entering or leaving the stealth page.
- Add a default-on Smooth stealth transitions setting. Effects touch only added decorative textures; action paging stays immediate.

## 0.1.1 — test build

- Fix stealth detection: Blizzard converts numeric state-driver results to numbers, so compare with numeric `1`.
- Correct the regression simulation to reproduce the client's state value type for rogue Stealth and druid Prowl.

## 0.1.0 — test build

- Original secure paging for rogue Stealth and druid Cat Form + Prowl.
- Preserve native Blizzard main-bar buttons, artwork, input handlers and bindings.
- Add character settings, startup message and LibDBIcon minimap launcher.
- Prepare package, regression checks and CurseForge submission materials.
- Live Forever testing required before a public release.
