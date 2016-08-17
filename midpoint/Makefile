GO_EASY_ON_ME = 1
ARCHS = armv7 armv7s arm64
FINALPACKAGE = 1
SDKVERSION = 9.2
MidPoint_LDFLAGS += -Wl,-segalign,4000
TARGET_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Midpoint
Midpoint_FILES = Midpoint.mm
Midpoint_INSTALL_PATH = /Library/PreferenceBundles
Midpoint_FRAMEWORKS = UIKit
Midpoint_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Midpoint.plist$(ECHO_END)
