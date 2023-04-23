DROPBEAR_APP_DIR	:= apps/dropbear
DROPBEAR_SRC_DIR	:= vendor/dropbear

DROPBEAR_BIN		:= $(DROPBEAR_SRC_DIR)/dropbear
DROPBEAR_CONFIG_H	:= $(DROPBEAR_SRC_DIR)/config.h

DROPBEAR_CONFIG_FLAGS	:= --host arm-apple-darwin --disable-utmpx --disable-utmp \
				--disable-wtmp --disable-wtmpx --disable-zlib \
				--disable-pam --enable-bundled-libtom

# ===------------------------------------------------------------------------===

$(DROPBEAR_CONFIG_H):
	@$(call log_info, "Configuring Dropbear build...")

	cd $(DROPBEAR_SRC_DIR) && autoreconf $(HUSH)
	cd $(DROPBEAR_SRC_DIR) && ./configure $(DROPBEAR_CONFIG_FLAGS) $(HUSH)

$(DROPBEAR_BIN): $(DROPBEAR_CONFIG_H)
	@$(call log, "Building Dropbear...")

	$(MAKE) --quiet -C $(DROPBEAR_SRC_DIR) dropbear $(HUSH)

# ===------------------------------------------------------------------------===

CRYPTEX_CONTENTS	+= $(ROOT_BIN_DIR)/dropbear $(ROOT_DAEMON_DIR)/dropbear.plist

$(ROOT_BIN_DIR)/dropbear: $(DROPBEAR_BIN)
	codesign -s - --entitlements $(DROPBEAR_APP_DIR)/entitlements.plist $(DROPBEAR_BIN)
	chmod 775 $(DROPBEAR_BIN)
	cp $(DROPBEAR_BIN) $@

$(ROOT_DAEMON_DIR)/dropbear.plist: $(DROPBEAR_APP_DIR)/dropbear.plist
	cp $< $@

# ===------------------------------------------------------------------------===

.PHONY: dropbear-clean
dropbear-clean:
	$(MAKE) -C $(DROPBEAR_SRC_DIR) clean $(HUSH)
	rm -f $(DROPBEAR_CONFIG_H)

clean: dropbear-clean
