GO_EASY_ON_ME = 1
SDKVERSION = 7.0
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

TWEAK_NAME = Emoji83
Emoji83_FILES = Tweak.xm
Emoji83_FRAMEWORKS = UIKit ##CoreGraphics CoreText

include $(THEOS_MAKE_PATH)/tweak.mk
