# Prevent any included targets from becoming the default target.
.PHONY: all
all:

PROJECT_PATH 	?= $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
BUILD_DIR 	?= $(abspath $(PROJECT_PATH)/build)

include mk/toolchain.mk
include mk/graft.mk
include mk/log.mk

CRYPTEX_ID	?= com.jonpalmisc.srdsh
CRYPTEX_VERSION	?= 1.0.0

CRYPTEX		?= $(BUILD_DIR)/$(CRYPTEX_ID).cxbd
CRYPTEX_ROOT	?= $(BUILD_DIR)/$(CRYPTEX_ID).root
CRYPTEX_IMAGE	?= $(BUILD_DIR)/$(CRYPTEX_ID).dmg

ROOT_DAEMON_DIR	:= $(CRYPTEX_ROOT)/Library/LaunchDaemons
ROOT_BIN_DIR	:= $(CRYPTEX_ROOT)/usr/bin

all: $(CRYPTEX)

CRYPTEX_CONTENTS	:=

include $(wildcard apps/*/module.mk)

$(CRYPTEX_ROOT):
	@$(call log_info, "Creating cryptex root...")
	mkdir -p $(ROOT_DAEMON_DIR)
	mkdir -p $(ROOT_BIN_DIR)

$(CRYPTEX_CONTENTS): $(CRYPTEX_ROOT)

$(CRYPTEX_IMAGE): $(CRYPTEX_CONTENTS)
	@$(call log, "Creating cryptex disk image...")
	@rm -fr $@
	hdiutil create -fs hfs+ -srcfolder $(CRYPTEX_ROOT) $@ $(HUSH)

$(CRYPTEX): $(CRYPTEX_IMAGE)
	@$(call log, "Creating cryptex...")
	cryptexctl create --research --replace -o $(BUILD_DIR) \
		--identifier=$(CRYPTEX_ID) --version=$(CRYPTEX_VERSION) \
		--variant=research $(CRYPTEX_IMAGE) 

# This is split out as a separate step to avoid repeatedly re-signing the
# cryptex upon installation even if the contents have not changed.
$(CRYPTEX).signed: $(CRYPTEX)
	@$(call log_info, "Personalizing cryptex for device...")
	cryptexctl personalize --replace -o $(BUILD_DIR) --variant=research $(CRYPTEX) || exit 1

.PHONY: install
install: $(CRYPTEX).signed
	@$(call log, "Installing cryptex on device...")
	cryptexctl uninstall $(CRYPTEX_ID) $(HUSH) || true
	cryptexctl install --variant=research $(CRYPTEX).signed

.PHONY: clean
clean:
	rm -fr $(BUILD_DIR)
