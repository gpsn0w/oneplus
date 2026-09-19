# Patch 03 — Auto-wipe after N failed unlock attempts 🦤

**Goal (user's words):** if someone fails to unlock the phone **more than a
number the user chooses**, the phone wipes itself.

Stock AOSP can wipe after failed attempts only via the enterprise Device-Admin
API (`DevicePolicyManager.setMaximumFailedPasswordsForWipe`) — there is **no
user-facing setting**. Dodo OS adds that setting and wires it to the existing
wipe path.

## User experience
- **Settings → Security → "Auto-erase after failed attempts"**
- A number picker: **Off, 5, 10, 15, 20, 30** attempts (default: **Off**, so no
  one wipes their own phone by accident until they opt in).
- A clear warning dialog when enabling: *"After N wrong attempts, ALL data is
  permanently erased and cannot be recovered."*

## New setting
`Settings.Secure.DODO_MAX_FAILED_ATTEMPTS_WIPE` — int, 0 = off.

## Code changes (Android 15 source; confirm exact paths after sync)

1. **Count + trigger** — failed lockscreen attempts are reported through
   `frameworks/base/services/core/java/com/android/server/locksettings/LockSettingsService.java`
   (see `reportFailedBiometricAttempt` / credential-verify failure path, which
   already increments a failed-attempt counter and notifies
   `DevicePolicyManagerService`).
   - Read `DODO_MAX_FAILED_ATTEMPTS_WIPE` for the current user.
   - When `failedCount >= limit && limit > 0`, call the existing wipe:
     `mInjector.getDevicePolicyManager().wipeDataNoLock(...)` (same call the
     enterprise path already uses), so we reuse audited wipe code, not a new one.

2. **Settings UI** —
   `packages/apps/Settings/src/com/android/settings/security/` : add a
   `ListPreference` ("Auto-erase after failed attempts") in the screen-lock
   settings fragment, backed by the Secure setting, guarded by the warning
   dialog.

3. **Default value** — leave at 0 (Off); user opts in explicitly.

## Interactions
- Must cooperate with Patch 02 (duress PIN): a duress entry counts as a
  *successful* credential match that triggers a wipe, so it should NOT also
  increment the failed counter.
- Consider a short lockout/backoff before the final wipe attempt so a child
  tapping randomly gets slowed, not instantly wiped (AOSP already backs off
  after 5 attempts — we keep that and wipe at the user's chosen threshold).

## Safety
- Off by default.
- Explicit warning on enable.
- Reuses AOSP's existing, audited wipe path (no custom deletion code).
