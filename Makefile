SHELL := /bin/bash
.DEFAULT_GOAL := help

IMAGE := blang/latex
WORKDIR := /work/src
OUTDIR := /work/dist
HOST_OUTDIR := dist
VARIANTS_DIR := src/variants
VARIANTS := $(basename $(notdir $(wildcard $(VARIANTS_DIR)/*.tex)))
VARIANT_PATHS := $(addprefix variants/,$(addsuffix .tex,$(VARIANTS)))
TARGET_NAME := $(basename $(notdir $(TARGET)))
OUTPUT_NAMES := $(if $(TARGET),$(TARGET_NAME),$(VARIANTS))
OUTPUT_PDFS := $(addprefix $(HOST_OUTDIR)/,$(addsuffix .pdf,$(OUTPUT_NAMES)))
OPEN_CMD := $(shell command -v open 2>/dev/null || command -v xdg-open 2>/dev/null)
NO_OPEN ?=
PRINT_TARGETS = if [[ -z "$(VARIANTS)" ]]; then echo 'No targets found in $(VARIANTS_DIR)/'; else echo 'Available targets:'; for target in $(VARIANTS); do printf '  %s\n' "$$target"; done; fi
OPEN_FILES = if [[ -z "$(NO_OPEN)" ]]; then if [[ -z "$(OPEN_CMD)" ]]; then echo 'No supported PDF opener found; skipping automatic open.' >&2; else for pdf in $(1); do "$(OPEN_CMD)" "$$pdf" || echo "Could not open $$pdf" >&2; done; fi; fi

.PHONY: help list build watch clean

help:
	@printf '%s\n' \
		'Usage:' \
		'  make build [TARGET=<name>] [NO_OPEN=1]  Build all variants or one target' \
		'  make watch TARGET=<name> [NO_OPEN=1]    Build, open, and watch one target' \
		'  make list                   List available targets' \
		'  make clean                  Remove generated output'

list:
	@$(PRINT_TARGETS)

build:
	@mkdir -p "$(HOST_OUTDIR)"
	@if [[ -n "$(TARGET)" ]]; then \
		if [[ ! -f "$(VARIANTS_DIR)/$(TARGET_NAME).tex" ]]; then \
			echo 'Unknown target: $(TARGET)' >&2; \
			$(PRINT_TARGETS); \
			exit 2; \
		fi; \
		sources="variants/$(TARGET_NAME).tex"; \
	else \
		if [[ -z "$(VARIANTS)" ]]; then \
			echo 'No targets found in $(VARIANTS_DIR)/' >&2; \
			exit 2; \
		fi; \
		sources="$(VARIANT_PATHS)"; \
	fi; \
	docker run --rm -v "$(CURDIR):/work" -w "$(WORKDIR)" "$(IMAGE)" \
		latexmk -pdf -output-directory="$(OUTDIR)" $$sources
	@$(call OPEN_FILES,$(OUTPUT_PDFS))

watch:
	@if [[ -z "$(TARGET)" ]]; then \
		echo 'TARGET is required for watch.' >&2; \
		$(PRINT_TARGETS); \
		exit 2; \
	fi
	@if [[ ! -f "$(VARIANTS_DIR)/$(TARGET_NAME).tex" ]]; then \
		echo 'Unknown target: $(TARGET)' >&2; \
		$(PRINT_TARGETS); \
		exit 2; \
	fi
	@mkdir -p "$(HOST_OUTDIR)"
	@docker run --rm -v "$(CURDIR):/work" -w "$(WORKDIR)" "$(IMAGE)" \
		latexmk -pdf -interaction=nonstopmode -output-directory="$(OUTDIR)" \
		"variants/$(TARGET_NAME).tex"
	@$(call OPEN_FILES,$(HOST_OUTDIR)/$(TARGET_NAME).pdf)
	@docker run --rm -v "$(CURDIR):/work" -w "$(WORKDIR)" "$(IMAGE)" \
		latexmk -pdf -pvc -view=none -interaction=nonstopmode -output-directory="$(OUTDIR)" \
		"variants/$(TARGET_NAME).tex"

clean:
	@rm -f "$(HOST_OUTDIR)"/*
