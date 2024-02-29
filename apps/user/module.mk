CRYPTEX_CONTENTS	+= $(ROOT_BIN_DIR)/user-app

$(ROOT_BIN_DIR)/user-app: apps/user/main.c
	@$(call log, "Building user app...")

	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@
	codesign -s - --entitlements apps/user/entitlements.plist $@

# A "clean" target is not necessary for this module since the output lives
# directly in the build directory.
