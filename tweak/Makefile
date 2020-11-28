ARCHS = armv6 armv7 arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CumSyncSpringboard

CumSyncSpringboard_FILES = Tweak.x
CumSyncSpringboard_LIBRARIES = rocketbootstrap
CumSyncSpringboard_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
