# Changelog

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
