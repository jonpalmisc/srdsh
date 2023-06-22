DEBUGSERVER_APP_DIR	:= apps/debugserver

ORIGINAL_BIN		:= $(DEBUGSERVER_APP_DIR)/debugserver
RESEARCH_BIN		:= $(DEBUGSERVER_APP_DIR)/debugserver.RESEARCH
ORIGINAL_PLIST		:= $(DEBUGSERVER_APP_DIR)/entitlements.plist
RESEARCH_PLIST		:= $(DEBUGSERVER_APP_DIR)/entitlements.RESEARCH.plist

# ===------------------------------------------------------------------------===

$(ORIGINAL_PLIST): $(ORIGINAL_BIN)
	@$(call log_info, "Extracting original debug server entitlements...")
	codesign -d --entitlements - --xml $< >$@

$(RESEARCH_PLIST): $(ORIGINAL_PLIST)
	@$(call log_info, "Adding research entitlements...")

	plutil -convert xml1 -o $@ $<
	plutil -insert 'research\.com\.apple\.license-to-operate' -bool "true" -- $@
	plutil -insert 'task_for_pid-allow' -bool "true" -- $@
	plutil -remove 'seatbelt-profiles' -- $@
	plutil -insert 'com\.apple\.private\.security\.no-container' -bool "true" -- $@

$(RESEARCH_BIN): $(ORIGINAL_BIN) $(RESEARCH_PLIST)
	@$(call log_info, "Signing patched debug server...")

	cp $< $@
	chmod +x $@
	
	codesign -fs - --preserve-metadata=identifier,requirements,flags,runtime \
		--entitlements $(RESEARCH_PLIST) $@

# ===------------------------------------------------------------------------===

CRYPTEX_CONTENTS	+= $(ROOT_BIN_DIR)/debugserver $(ROOT_DAEMON_DIR)/debugserver.plist

$(ROOT_BIN_DIR)/debugserver: $(RESEARCH_BIN)
	@$(call log, "Staging patched debug server...")
	cp $< $@

$(ROOT_DAEMON_DIR)/debugserver.plist: $(DEBUGSERVER_APP_DIR)/debugserver.plist
	cp $< $@

# ===------------------------------------------------------------------------===

.PHONY: debugserver-clean
debugserver-clean:
	rm -f $(RESEARCH_BIN) $(ORIGINAL_PLIST) $(RESEARCH_PLIST)

clean: debugserver-clean
