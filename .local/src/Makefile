SHELL := /bin/bash

SRC_DIRECTORY := $(CURDIR)
BIN_DIRECTORY := $(HOME)/.local/bin

.PHONY: install clean

install:
	mkdir --parents "$(BIN_DIRECTORY)"
	@find "$(SRC_DIRECTORY)" -type f -name "*.sh" | while read -r file; do \
		name=$$(basename "$$file" .sh); \
		ln -sf "$$(realpath "$$file")" "$(BIN_DIRECTORY)/$$name"; \
		echo "Linked: $$(realpath "$$file") -> $(BIN_DIRECTORY)/$$name"; \
	done

clean:
	rm -f "$(BIN_DIRECTORY)"/*
