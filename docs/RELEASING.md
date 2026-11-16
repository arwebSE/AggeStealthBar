# Releases

CurseForge project: **1810920**, [AggeStealthBar](https://www.curseforge.com/wow/addons/aggestealthbar).

The GitHub repository stores the author upload token as **CF_API_TOKEN**. Never commit or print it. GitHub Actions uses its built-in repository token to attach the packaged addon to a GitHub release.

1. Update the TOC version and changelog. Follow `docs/TESTING.md` for changed client behavior. Automated checks simulate Lua behavior; they do not establish live combat security or exact rendering.
2. Run `uv run --with lupa python tests/check.py` and `./scripts/package.ps1`. Inspect the ZIP: one top-level `AggeStealthBar` directory with its TOC, Lua, texture, libraries and notices.
3. Commit and push the source. Push an annotated `v<version>` tag (for example `v1.0.0`). The release workflow checks the project ID, runs tests and uses BigWigsMods/packager to upload to CurseForge and GitHub.
4. Monitor the workflow and verify Forever 1.60.1 compatibility, release type and moderation state in the author dashboard. A successful upload is not moderator approval; new projects stay unavailable until approved.

Listing title: **AggeStealthBar: Rogue Stealth & Druid Prowl Bar**. Keep the slug `aggestealthbar`. Main category: Action Bars. Additional categories: Druid, Rogue. MIT license, with bundled library notices retained. The project image is `assets/curseforge-icon.png`; description source is `docs/CURSEFORGE.md`.
