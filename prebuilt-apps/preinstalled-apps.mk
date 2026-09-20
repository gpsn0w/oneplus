# 🦤 Dodo OS — pre-installed apps product include
# Add to the Dodo OS device product with:
#     $(call inherit-product, vendor/dodo/apps/preinstalled-apps.mk)

PRODUCT_PACKAGES += \
    FDroid \
    AuroraStore \
    Wasted \
    DuressApp

# Notes:
# - FDroid    : open-source app store (privacy-respecting)
# - AuroraStore: anonymous front-end to Google Play (no Google account needed)
# - Wasted    : device-admin app that can wipe the phone on a trigger
#               (works together with our built-in duress/auto-wipe features)
# - DuressApp : companion app for the duress feature
#
# For Wasted/Duress to actually wipe, the user grants them Device Admin in
# Settings after first boot (Android requires explicit user consent for that).
