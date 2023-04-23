# ===-- toolchain.mk -- iOS cross-complication toolchain setup --------------===
#
# This file should be included in a top-level makefile as close to the top as
# possible to ensure targets and subprocesses see the "correct" values for all
# of the variables below.
#
# It is assumed you have the iOS and macOS SDK installed.
#
# ===------------------------------------------------------------------------===

export ARCH		:= arm64e

export TOOLCHAIN	?= iOS14.0
export MACOS_TOOLCHAIN	?= MacOSX11.0

export IOS_SDK_PATH	:= $(shell xcrun --show-sdk-path --sdk iphoneos)
export MACOS_SDK_PATH	:= $(shell xcrun --show-sdk-path --sdk macosx)

export CC		:= $(shell xcrun -f --toolchain $(TOOLCHAIN) clang)
export CXX		:= $(shell xcrun -f --toolchain $(TOOLCHAIN) clang++)

export CFLAGS		:= -isysroot $(IOS_SDK_PATH) -arch $(ARCH) -I$(IOS_SDK_PATH)/usr/include -DTARGET_OS_IPHONE=1 -DTARGET_OS_BRIDGE=0
export CPPFLAGS		:= -DUSE_GETCWD -isysroot $(IOS_SDK_PATH) -arch arm64
export CXXFLAGS		:= $(CFLAGS)
export LDFLAGS		:= -isysroot $(IOS_SDK_PATH) -arch $(ARCH)

export LD_LIBRARY_PATH	:= $(IOS_SDK_PATH)/usr/lib

export HOSTCC		:= $(shell xcrun -f --toolchain $(MACOS_TOOLCHAIN) clang)
export HOSTCFLAGS	:= -isysroot $(MACOS_SDK_PATH) -I$(MACOS_SDK_PATH)/usr/include
export HOSTLDFLAGS	:= -isysroot $(MACOS_SDK_PATH)

# Warning: While not directly used in this file, this is a load-bearing
# environment variable; removal not advised.
export SDKROOT		:= $(IOS_SDK_PATH)
