# Dodo OS — Roadmap

This roadmap tracks the build of Dodo OS from an empty machine to a flashable
ROM for the OnePlus Nord N100 (BE2013).

## Stage 0 — Environment setup ✅ DONE
- [x] Install system build dependencies (git, Java 21, libs, ccache)
- [x] Install `repo` tool
- [x] Configure git
- [x] Create project scaffold + GitHub repo

## Stage 1 — Build vanilla AOSP for the emulator ⏳ NEXT
Goal: prove the whole toolchain works and the machine can complete a build,
*before* dealing with device-specific complexity.
- [ ] `repo init` + `repo sync` the AOSP source (~250 GB, several hours)
- [ ] `lunch` an emulator target (e.g. `sdk_phone_x86_64`)
- [ ] Full `m` build
- [ ] Boot the resulting image in the Android emulator

## Stage 2 — Device bring-up for OnePlus N100
Vanilla AOSP does not run on real hardware without device support.
- [ ] Confirm the N100 device codename (LineageOS community: likely `billie`/`billie2`)
- [ ] Add device tree, kernel, and vendor blobs to a Dodo OS local manifest
- [ ] Build a `userdebug` image for the device
- [ ] Flash and boot on the actual phone (bootloader must be unlocked)

## Stage 3 — Dodo OS branding
- [ ] Product name / build fingerprint → Dodo OS
- [ ] Logo + boot animation
- [ ] Default wallpaper & theme

## Stage 4 — Privacy features (one at a time)
- [ ] Sandboxed Google Play services (microG or sandboxed Play)
- [ ] USB-C data-block when locked
- [ ] Duress / panic PIN
- [ ] Hardened defaults (network permission toggle, sensors toggle, etc.)

## Known hardware limitation
The N100 bootloader cannot be re-locked with user AVB keys. Therefore Dodo OS
**cannot** provide GrapheneOS-equivalent verified boot on this device. This is a
hardware constraint, not a software one.
