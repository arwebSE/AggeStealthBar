# CurseForge preparation

1. Complete `docs/TESTING.md`. Keep the first upload Alpha until both classes and combat/Shift-drag checks pass.
2. Create **AggeStealthBar**, game **World of Warcraft**, categories **Action Bars**, **Rogue**, **Druid**. Use `assets/curseforge-icon.png` as the project image and `docs/CURSEFORGE.md` as the description. Set MIT license, source and issue links to this GitHub repository.
3. Add the assigned numeric project ID as `## X-Curse-Project-ID:` in the TOC. Do not guess an ID. Choose the available **Forever 1.60.1** game-version entry.
4. Add your author upload token to the new GitHub repository as secret **CF_API_TOKEN** (`gh secret set CF_API_TOKEN --repo arwebSE/AggeStealthBar`, paste into its hidden prompt). Never commit or paste the token into chat. A token from the public read API may not grant author-upload access.
5. Update the TOC version and changelog, run `uv run --with lupa python tests/check.py`, then `./scripts/package.ps1`. Inspect the ZIP: it must contain a single top-level `AggeStealthBar` folder, Lua, libraries, texture and notices.
6. Upload `dist/AggeStealthBar-0.1.0.zip` manually as Alpha for initial testing, or configure the packager workflow after adding the project ID and secret. The workflow only publishes when a `v*` tag is pushed and the project ID exists. Use `v0.1.0-alpha` for an alpha release. Do not tag a public stable release until live checks pass.

The CurseForge project has not yet been created or uploaded. There is no CurseForge download link until the project exists. Local packaging works without any API token.

