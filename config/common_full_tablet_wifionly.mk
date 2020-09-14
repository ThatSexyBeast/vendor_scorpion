# Inherit common Scorpion stuff
$(call inherit-product, vendor/scorpion/config/common.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include Scorpion LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/overlay/dictionaries
