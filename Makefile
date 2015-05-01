GO_EASY_ON_ME = 1
TARGET = iphone:latest:5.0
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

TWEAK_NAME = Emoji83
Emoji83_FILES = Tweak.xm
Emoji83_FRAMEWORKS = UIKit CoreGraphics CoreFoundation CoreText
#Emoji83_PRIVATE_FRAMEWORKS = TextInput

include $(THEOS_MAKE_PATH)/tweak.mk
