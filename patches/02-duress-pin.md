# Patch 02 — Duress / panic PIN 🦤

**Goal:** a secondary "duress" PIN/password that, when entered at the lock
screen, **immediately and irreversibly wipes the phone** (data + eSIM) instead
of unlocking it. For situations where someone is forced to hand over the device.

Inspired by GrapheneOS's duress password feature.

## User experience
- **Settings → Security → "Duress password"**
- User sets a duress PIN/pattern/password (must differ from the real one).
- When that credential is entered at the lock screen, the screen behaves
  normally for a second, then the device **factory-resets** — no confirmation,
  no visible hint that a wipe was triggered (so an attacker can't stop it).

## New setting / storage
- Store a **salted hash** of the duress credential (never plaintext), alongside
  the real credential hash, in the lock-settings storage
  (`LockSettingsStorage` / synthetic-password area). Reuse AOSP's existing
  credential-hashing so we don't roll our own crypto.
- `Settings.Secure.DODO_DURESS_ENABLED` (int 0/1) as a UI flag only.

## Code changes (Android 15; confirm paths after sync)

1. **Credential check** —
   `frameworks/base/services/core/java/com/android/server/locksettings/LockSettingsService.java`,
   in the credential-verify path (`verifyCredential` / `doVerifyCredential`):
   - After computing the entered credential's hash, **also** compare against the
     stored duress hash.
   - On duress match: trigger `wipeDataNoLock(...)` (same audited wipe as
     Patch 03) with eSIM wipe flag, and return a *failed* unlock to the caller
     so nothing else reacts.

2. **Set/change duress credential** — extend the same service with
   `setDuressCredential(...)` mirroring `setLockCredential(...)`, reusing the
   hashing/synthetic-password machinery.

3. **Settings UI** — `packages/apps/Settings/.../security/`: a "Duress password"
   screen to set/clear it, with a strong explanatory warning.

## Safety & correctness
- Duress hash stored the same secure way as the real credential.
- Duress entry must **not** increment the failed-attempt counter (see Patch 03).
- Wipe reuses AOSP's audited path; we add no custom deletion routine.
- Refuse to set a duress credential identical to the real one.

## Honest note
This protects against a *coerced unlock*. It is not magic: a sophisticated
attacker who images the storage before powering on is out of scope (that's the
job of full-disk encryption + verified boot, which the N100 hardware limits).
