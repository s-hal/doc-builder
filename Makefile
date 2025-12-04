PANDOC   = /usr/bin/pandoc

DIR      ?= .
BODY     = body.md
METADATA = metadata.yaml
TEMPLATE = template.tex

# Optional sources to copy from (e.g. another repo)
SRC_BODY     ?=
SRC_METADATA ?=

TITLE_NAME = $(shell \
  grep '^title:' $(METADATA) | head -n1 | cut -d ':' -f2- | \
  sed 's/^[[:space:]]*//;s/[[:space:]]*$$//' \
)
VERSION    = $(shell grep 'version:' $(METADATA) | head -n1 | cut -d ':' -f 2 | tr -d ' "')

.DEFAULT_GOAL := draft

.PHONY: draft final render clean prepare

draft: STATUS = Draft
draft: OUT = "$(DIR)/$(TITLE_NAME) DRAFT $(VERSION).pdf"
draft: prepare render

final: STATUS = Final
final: OUT = "$(DIR)/$(TITLE_NAME) $(VERSION).pdf"
final: prepare render

prepare:
	@if [ -n "$(SRC_BODY)" ]; then \
	  cp "$(SRC_BODY)" "$(BODY)"; \
	fi
	@if [ -n "$(SRC_METADATA)" ]; then \
	  cp "$(SRC_METADATA)" "$(METADATA)"; \
	fi

render:
	$(PANDOC) $(BODY) \
		--verbose \
		--template=$(TEMPLATE) \
		--metadata-file=$(METADATA) \
		--variable=status:"$(STATUS)" \
		--pdf-engine=xelatex \
		--toc \
		--toc-depth=6 \
		--number-sections \
		--citeproc \
		--bibliography references.bib \
		--csl elsevier-with-titles.csl \
		--lua-filter=section-number.lua \
		--highlight-style=tango \
		-V linkcolor:blue \
		-o $(OUT)

clean:
	rm -f *.pdf