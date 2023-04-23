# ===-- graft.mk -- macOS/iOS SDK header graft helpers ----------------------===
#
# If including this file separately from `toolchain.mk`, you must provide the
# macOS SDK path (`MACOS_SDK_PATH`) and likely want to set `PROJECT_PATH`.
#
# ===------------------------------------------------------------------------===

ifeq ($(MACOS_SDK_PATH),)
	$(error "MACOS_SDK_PATH must be defined to perform SDK grafts.")
endif

# Default to current directory if not provided.
PROJECT_PATH			?= .

GRAFT_DIR			?= $(abspath $(PROJECT_PATH)/graft)
GRAFT_DOWNLOAD_DIR		?= $(abspath $(GRAFT_DIR)/downloads)
export GRAFT_INCLUDE_DIR	?= $(abspath $(GRAFT_DIR)/include)

# Update any compiler flags (which may have already been defined elsewhere) to
# use the graft include directory.
export CFLAGS		+= -I$(GRAFT_INCLUDE_DIR) -F$(GRAFT_INCLUDE_DIR)
export CPPFLAGS		+= -I$(GRAFT_INCLUDE_DIR) -F$(GRAFT_INCLUDE_DIR)
export CXXFLAGS		+= -I$(GRAFT_INCLUDE_DIR) -F$(GRAFT_INCLUDE_DIR)

IOKIT_INCLUDE_PATH	= $(MACOS_SDK_PATH)/System/Library/Frameworks/IOKit.framework/Versions/Current/Headers/

$(GRAFT_INCLUDE_DIR)/%: $(MACOS_SDK_PATH)/usr/include/%
	@$(call log_info, "Grafting system header '$*' from macOS SDK...")

	@mkdir -p $(dir $@)
	cp $< $@

$(GRAFT_INCLUDE_DIR)/IOKit/%.h: $(IOKIT_INCLUDE_PATH)/%.h
	@$(call log_info, "Grafting IOKit header '$*' from macOS SDK...")

	@mkdir -p $(dir $@)
	cp $< $@

.PHONY: graft-clean
graft-clean:
	rm -fr $(GRAFT_DIR)

clean: graft-clean
