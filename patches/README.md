# Dodo OS — Patches 🦤

**Patches** are code changes to AOSP that add features overlays can't (real new
behavior, not just changed defaults). Each patch here is first written as a
**design spec** (target files + logic). Once the AOSP source is synced, each spec
becomes an actual `.patch`/git commit against the tree and is applied at build.

All three security features below live together in
**Settings → Security** (under the screen-lock / password section), exactly as
requested.

| # | Feature | Spec | Needs code in |
|---|---------|------|---------------|
| 01 | USB-C data block when locked | [`01-usb-c-lock-protection.md`](01-usb-c-lock-protection.md) | `services` (USB manager) + Settings UI |
| 02 | Duress / panic PIN (wipes on entry) | [`02-duress-pin.md`](02-duress-pin.md) | `LockSettingsService` + Settings UI |
| 03 | Auto-wipe after N failed unlocks | [`03-auto-wipe-failed-attempts.md`](03-auto-wipe-failed-attempts.md) | `LockSettingsService` + Settings UI |

## Status

📝 **Design specs written; not yet applied.** Applying them is a Stage-4 task
once `~/dodo-os` (AOSP source) has finished syncing. Exact line numbers/paths in
each spec are to be confirmed against the synced Android 15 source.
