ARCHS = armv6 armv7 arm64
include $(THEOS)/makefiles/common.mk

TOOL_NAME = CumSyncDaemon

CumSyncDaemon_FILES = \
	main.m \
	$(wildcard PocketSocket/*.m)
CumSyncDaemon_CFLAGS = -fobjc-arc
CumSyncDaemon_LIBRARIES = rocketbootstrap
CumSyncDaemon_CODESIGN_FLAGS = -Sentitlements.plist
CumSyncDaemon_INSTALL_PATH = /usr/bin

include $(THEOS_MAKE_PATH)/tool.mk
