# Patch 01 — USB-C data block when locked 🦤

**Goal:** when the phone is locked, the USB-C port carries **charging only** — no
data. This blocks "juice-jacking" and forensic/data-extraction tools (Cellebrite
etc.) that rely on plugging into a locked phone.

Inspired by GrapheneOS's USB-C port control.

## User experience
- **Settings → Security → "USB-C when locked"** with options:
  - **Charging only when locked** (default) — data enabled only after unlock
  - **Always allow data** (stock behavior)
  - **Charging only, always** (most strict; data never over USB)
- New USB data connections made while locked are refused until the user unlocks.

## New setting
`Settings.Global.DODO_USB_LOCKED_MODE` — int:
`0 = always allow`, `1 = charging-only when locked` (**default — always on**), `2 = charging-only always`.

> Dodo OS ships with this protection **enabled by default** (mode 1). The user
> can loosen it, but out of the box the port is always charging-only while
> locked — no action required from the user.

## Code changes (Android 15; confirm paths after sync)

1. **USB manager reacts to keyguard** —
   `frameworks/base/services/usb/java/com/android/server/usb/UsbDeviceManager.java`
   (and `UsbPortManager` for port data-role):
   - Observe keyguard locked/unlocked (`KeyguardManager` / the keyguard
     broadcast the class already listens to for related state).
   - When locked and mode != 0: force the USB data functions off (set the USB
     HAL function state to none / charging), and disable the data role on the
     port via `UsbPortManager`.
   - On unlock: restore the user's chosen USB function.

2. **Settings UI** — `packages/apps/Settings/.../security/`: a `ListPreference`
   ("USB-C when locked") backed by the Global setting.

## Notes / correctness
- Android already disables *new* USB data after a reboot until first unlock; this
  patch extends the block to **every** locked state, not just post-reboot.
- Must not break charging — only the *data* role/functions are toggled.
- Must not cut an **already-authorized** data session the user started while
  unlocked, unless mode = 2 (always strict).
- Verify against the N100's specific USB HAL once device bring-up (Stage 2) is
  done — HAL support for toggling data role varies by SoC (Snapdragon 460).
