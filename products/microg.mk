# 🦤 Dodo OS — microG package set
# ================================
# Include this from the Dodo OS device product makefile (Stage 3) with:
#     $(call inherit-product, vendor/dodo/products/microg.mk)
#
# It adds the microG apps to the system image so Google-dependent apps work
# through the open-source, sandboxed microG instead of real Google Play services.
#
# NOTE: the actual app binaries (prebuilt APKs) are added under
#       prebuilts/dodo/microg/ during Stage 4; this file just declares them.
#       Requires Patch 04 (signature spoofing) to be applied.

PRODUCT_PACKAGES += \
    GmsCore \
    GsfProxy \
    FakeStore \
    DroidGuard

# Optional location backends (open-source, no Google):
PRODUCT_PACKAGES += \
    MozillaNlpBackend \
    NominatimNlpBackend

# Make microG privileged so it can hold the gated FAKE_PACKAGE_SIGNATURE
# permission (see patches/04). The privapp-permissions whitelist is added
# alongside the prebuilts in Stage 4.
PRODUCT_PACKAGES += \
    DodoMicrogPermissions

# microG works best with a working cell/wifi location source; we ship the
# open backends above rather than Google's network location.
