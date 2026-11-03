# Compiles scripts and generates executable files.
#
# Usage:
#     make [install | clean]
#
# Arguments:
#     install - Compiles and generates executable files in the output directory.
#     clean   - Removes all executables from the output directory.

SHELL := /bin/bash
SRC_DIRECTORY := $(CURDIR)
BIN_DIRECTORY := $(HOME)/.local/bin

.PHONY: install clean

install:
	mkdir --parents "$(BIN_DIRECTORY)"
	@$(call installBash)

clean:
	rm -f "$(BIN_DIRECTORY)"/*

define installBash
	@find "$(SRC_DIRECTORY)" -type f -name "*.sh" | while read -r file; do \
		name=$$(basename "$$file" .sh); \
		ln --force --symbolic \
				"$$(realpath "$$file")" "$(BIN_DIRECTORY)/$$name"; \
		echo "Linked: $$(realpath "$$file") -> $(BIN_DIRECTORY)/$$name"; \
	done
endef
