GO_EASY_ON_ME = 1
ARCHS = armv7 arm64
TARGET_CFLAGS = -fobjc-arc
SDKVERSION = 9.2
TARGET = iphone::9.2:9.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Midpoint
Midpoint_FILES = Tweak.xm $(wildcard *.m)
Midpoint_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += midpoint
include $(THEOS_MAKE_PATH)/aggregate.mk
