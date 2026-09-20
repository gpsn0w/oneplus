# Patch 05 — Sandboxed user profiles 🦤

**Goal:** multiple isolated "worlds" on one phone (e.g. Personal, Work, Guest).
Each profile is its own sandbox: separate apps, accounts, files, encryption —
one profile cannot see another's data.

AOSP already has multi-user support; Dodo OS **turns it on by default** (see the
overlay `config.xml`) and adds the isolation/quality-of-life features below.

## What the overlay already gives us (no patch needed)
- Up to **8** profiles, multi-user UI enabled, ephemeral guest.
  (`config_multiuserMaximumUsers`, `config_enableMultiUserUI`,
  `config_guestUserEphemeral`.)

## Enhancements that need code (Android 15; confirm paths after sync)

1. **"End session" for secondary users** — a quick-settings tile / power-menu
   action that logs out a secondary profile and **evicts its encryption key
   from RAM**, so its data is at-rest-encrypted again immediately.
   - Reuse `UserManager` / `ActivityManager.stopUser(..., force)` and the
     storage key eviction already used at lock. Target:
     `frameworks/base/services/core/java/com/android/server/am/UserController.java`.

2. **Per-profile notification isolation** — by default a secondary profile's
   notifications do **not** surface on the owner (opt-in forwarding only).
   Target: `NotificationManagerService` filtering by user.

3. **Cross-profile default = deny** — no cross-profile app communication or
   contact/file sharing unless the user explicitly enables it. Verify defaults
   in `CrossProfileAppsService` / package manager cross-profile intents.

4. **Fast switch from the lock screen** — allow choosing a profile at unlock
   without fully booting into owner first.

## Isolation model (honest)
- Each user already gets **separate credential-encrypted storage** in AOSP —
  that's the real sandbox boundary, and it's solid.
- These enhancements mostly reduce *metadata leakage* (notifications, background
  run) and make ending a session actually re-lock the data.
- This is not a hypervisor VM; it's Android's user isolation, hardened. Good for
  compartmentalizing daily use; not a defense against a kernel exploit.

## Status
📝 Overlay defaults done; enhancement patches are Stage 4.
