# Dodo OS — Flashing 🦤

Two ways to put Dodo OS on the OnePlus Nord N100 (BE2013).

> ⚠️ **You need the actual build output first.** The scripts below are ready, but
> the images/zip they flash are produced by building Dodo OS **for the device**
> (Roadmap Stage 2 — device bring-up). Until then there is nothing to flash to a
> real phone yet. The current test build targets the *emulator*, not the N100.

## Prerequisites
```bash
sudo apt-get install -y android-tools-adb android-tools-fastboot
```
The phone's **bootloader must be unlocked** (`fastboot flashing unlock`).

## Method 1 — fastboot (flash raw images)
Best for a full/clean install. Phone in **bootloader/fastboot** mode
(power off, then Power + Volume Up), connected by USB.
```bash
./flash-linux.sh          # flashes boot/super/vbmeta/... from ../out
./flash-linux.sh --wipe   # also erases all user data
```

## Method 2 — adb sideload (install an update .zip from recovery)
Best for updates. Phone in **recovery → Apply update from ADB**.
```bash
./sideload-linux.sh                       # auto-finds dodo-os-*.zip
./sideload-linux.sh path/to/update.zip    # explicit file
```

## Which one?
| | fastboot | adb sideload |
|---|---|---|
| First install | ✅ best | possible |
| Updates | possible | ✅ best |
| Needs | unlocked bootloader | recovery with sideload |
| Flashes | raw partition images | a signed OTA .zip |

## Honest note on the N100
The N100 bootloader **cannot be re-locked with custom keys**, so it will show an
"unlocked bootloader" warning at boot and cannot provide GrapheneOS-grade
verified boot. See [`../docs/SECURITY.md`](../docs/SECURITY.md).
