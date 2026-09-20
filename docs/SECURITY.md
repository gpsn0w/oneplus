# Dodo OS — Security features 🦤

All Dodo OS security features live in one place: **Settings → Security**, under
the screen-lock / password section.

## The three anti-tamper features

| Feature | What it does | Default |
|---------|--------------|---------|
| 🔌 **USB-C when locked** | Port is charging-only while the phone is locked — blocks data-extraction tools | On |
| 🚨 **Duress password** | A secret PIN that wipes the phone instead of unlocking it | Off (opt-in) |
| 🔢 **Auto-erase after failed attempts** | After N wrong unlocks (user picks N), the phone erases itself | Off (opt-in) |
| 📆 **Auto-erase after X days locked** | If the phone isn't unlocked for X days, it wipes silently (no warning) — via the pre-installed **Wasted** app | Off (opt-in) |
| 🔐 **Encryption** | All user data encrypted at rest (file-based encryption) | On (AOSP standard) |

Design specs: [`../patches/`](../patches/).

## Pre-installed apps
Dodo OS ships these open-source apps (on /product, user-removable):

| App | Purpose |
|-----|---------|
| **F-Droid** | Open-source app store |
| **Aurora Store** | Anonymous Play Store access (no Google account) |
| **Wasted** | Device-admin app: wipes after X days locked / on trigger |
| **Duress** | Companion app for the duress feature |

Wasted & Duress need Device Admin granted by the user after first boot (Android
requires explicit consent to allow an app to wipe the device).

## How they work together
- A **duress** entry triggers a wipe but is counted as a *match*, so it does not
  bump the failed-attempt counter that drives **auto-erase**.
- Both wipe features reuse AOSP's existing, audited factory-reset path — Dodo OS
  writes no custom deletion code.
- **USB-C block** is independent and reacts purely to the lock state.

## Honest limits (same as the project's overall scope)
These features raise the cost of physical/coerced attacks a lot, but the N100's
bootloader **cannot be re-locked with custom keys**, so Dodo OS cannot offer
GrapheneOS-grade verified boot. A very sophisticated attacker who images the
encrypted storage before first unlock is out of scope. See
[`ROADMAP.md`](ROADMAP.md).

## Status
📝 Specs written. Implementation happens in **Stage 4**, after the AOSP source
finishes syncing and the Dodo OS device build works.
