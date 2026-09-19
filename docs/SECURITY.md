# Dodo OS — Security features 🦤

All Dodo OS security features live in one place: **Settings → Security**, under
the screen-lock / password section.

## The three anti-tamper features

| Feature | What it does | Default |
|---------|--------------|---------|
| 🔌 **USB-C when locked** | Port is charging-only while the phone is locked — blocks data-extraction tools | Charging-only when locked |
| 🚨 **Duress password** | A secret PIN that wipes the phone instead of unlocking it | Off (opt-in) |
| 🔢 **Auto-erase after failed attempts** | After N wrong unlocks (user picks N), the phone erases itself | Off (opt-in) |

Design specs: [`../patches/`](../patches/).

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
