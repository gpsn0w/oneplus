# Dodo OS — Overlays 🦤

**Overlays** change how AOSP behaves *without editing AOSP's own code*. At build
time these files are layered on top of the matching AOSP files. This keeps Dodo
OS easy to maintain and to update to new Android versions.

The folder structure here mirrors AOSP's own tree, so each file lands in the
right place automatically.

## What's here

| File | What it changes |
|------|-----------------|
| `frameworks/base/core/res/res/values/config.xml` | Framework defaults: no background Wi-Fi scanning, no Google connectivity-check phone-home, safer carrier defaults |
| `frameworks/base/packages/SettingsProvider/res/values/defaults.xml` | First-boot settings: location/Wi-Fi/Bluetooth off by default, private lock-screen notifications |

Everything here is still **user-toggleable** — Dodo OS just chooses the private
option as the *default*.

## Status

⚠️ These overlays are written but **not yet compiled/tested** — that happens once
the AOSP source is synced (Stage 1) and wired into the Dodo OS product makefile
(Stage 2/3). They are staged here in advance so Dodo OS is private from its very
first build.
