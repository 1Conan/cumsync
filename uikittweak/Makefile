ARCHS = armv6 armv7 arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CumSyncUIKit

CumSyncUIKit_FILES = Tweak.x
CumSyncUIKit_LIBRARIES = rocketbootstrap
CumSyncUIKit_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
