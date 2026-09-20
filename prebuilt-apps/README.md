# Dodo OS — Pre-installed apps 🦤

Config for the open-source apps shipped with Dodo OS. The APK binaries live in
the AOSP tree at `vendor/dodo/apps/<App>/<App>.apk` (kept local, not committed —
they are third-party signed binaries). This folder mirrors only the build config.

| App | Package job |
|-----|-------------|
| F-Droid | open-source app store |
| Aurora Store | anonymous Play Store access |
| Wasted | wipe after X days locked / on trigger (Device Admin) |
| Duress | companion for the duress feature |

`Android.bp` declares each APK as a presigned prebuilt on /product.
`preinstalled-apps.mk` adds them to `PRODUCT_PACKAGES`.
