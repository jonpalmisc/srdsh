CRYPTEX_CONTENTS	+= $(ROOT_BIN_DIR)/cryptex-run

$(ROOT_BIN_DIR)/cryptex-run: apps/run/run.c
	@$(call log, "Building cryptex binary runner...")

	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@
	codesign -s - --entitlements apps/run/entitlements.plist $@

# A "clean" target is not necessary for this module since the output lives
# directly in the build directory.
