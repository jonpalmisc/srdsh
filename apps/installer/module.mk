CRYPTEX_CONTENTS	+= $(ROOT_BIN_DIR)/install-ipa

$(ROOT_BIN_DIR)/install-ipa: apps/installer/installer.m
	@$(call log, "Building IPA installer...")

	$(CC) $(CFLAGS) $(LDFLAGS) -fobjc-arc -framework MobileCoreServices -framework Foundation $< -o $@
	codesign -s - --entitlements apps/installer/entitlements.plist $@

# A "clean" target is not necessary for this module since the output lives
# directly in the build directory.
