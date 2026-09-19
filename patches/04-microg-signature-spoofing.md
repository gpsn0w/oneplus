# Patch 04 — microG signature spoofing (sandboxed Google services) 🦤

**Goal:** run Google apps/services through **microG** — an open-source
reimplementation of Google Play services — so apps that need "Google" still work,
but the real Google code (and its tracking) never runs. This is Dodo OS's
answer to "Google services, but in a sandbox."

## Why a patch is needed
microG must convince apps it *is* Google Play services. That requires the OS to
let microG **spoof the Google signature**. Stock AOSP forbids this. Dodo OS adds
a **restricted, permission-gated** signature-spoofing capability — granted to
microG only, not to any app.

## Approach (the safe, well-known one)
Use the community "signature spoofing" framework patch (as used by LineageOS-for-
microG / GrapheneOS-sandboxed-Play alternatives), gated behind a **new signature-
level permission** so only system-privileged, whitelisted packages (microG's
GmsCore) can use it.

### Code changes (Android 15; confirm paths after sync)
1. New permission `android.permission.FAKE_PACKAGE_SIGNATURE`
   (protectionLevel `signature|privileged`) declared in
   `frameworks/base/core/res/AndroidManifest.xml`.
2. In `frameworks/base/services/core/java/com/android/server/pm/` — the package
   manager's signature-reading path (`PackageManagerService` /
   `ComputerEngine.generatePackageInfo` where `GET_SIGNATURES` /
   `GET_SIGNING_CERTIFICATES` is handled): if the calling package holds
   `FAKE_PACKAGE_SIGNATURE` **and** declares a `fake-signature` metadata value,
   return the spoofed signature instead of the real one.
3. Whitelist microG in `privapp-permissions` so only it gets the permission.

## The microG package set (prebuilt, see `products/microg.mk`)
- **GmsCore** — the Play-services replacement (runs sandboxed)
- **GsfProxy** — legacy GCM/GTalk framework proxy
- **FakeStore** — a stub "Play Store" so apps that check for it are satisfied
- (optional) **DroidGuard**, location backends (Mozilla/Nominatim) for maps

## Sandboxing
- microG runs as a **normal privileged app**, not as part of the framework, and
  is subject to Dodo OS's per-app permission model (network, location, etc.).
- Users can deny microG network/location like any app — that's the "sandbox".

## Honest note
Signature spoofing is a deliberate, scoped weakening of one check, limited to
microG by permission + whitelist. It is the standard trade-off every de-Googled
"Google-compatible" ROM makes. GrapheneOS instead runs *real* Play in a sandbox
without spoofing — a different trade-off we could offer later as an alternative.
