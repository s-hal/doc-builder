PANDOC= /usr/bin/pandoc
XELATEX= /usr/bin/xelatex
PDFTK= /usr/bin/pdftk
SED= /usr/bin/sed

DIR ?= .
TITLE_PRE= title
TITLE_TEX= $(TITLE_PRE).tex
TITLE_PDF= $(TITLE_PRE).pdf
TITLE_DAT= $(TITLE_PRE).dat
BODY= body.pdf
BODY_INFO= body.info
CONCAT= concat.pdf

.DEFAULT_GOAL := draft

TITLE = $(shell grep 'Title: ' $(TITLE_DAT) | cut -d ' ' -f 2-)
VERSION = $(shell grep 'Version: ' $(TITLE_DAT) | cut -d ' ' -f 2-)
ifneq (final,$(MAKECMDGOALS))
  OUT ?= "$(DIR)/$(TITLE) DRAFT $(VERSION).pdf"
else
  OUT ?= "$(DIR)/$(TITLE) $(VERSION).pdf"
endif

.PHONY: draft final set-draft set-final pdf clean

draft: copy-files set-draft pdf

final: copy-files set-final pdf

copy-files:
	cp $(DIR)/body.md $(DIR)/title.dat .

set-draft:
	$(SED) -i "s/Status\:\ .*/Status: Draft/" $(TITLE_DAT)

set-final:
	$(SED) -i "s/Status\:\ .*/Status: Final/" $(TITLE_DAT)

pdf: $(BODY)

#%.pdf: %.md
$(BODY): body.md
	$(PANDOC) $< \
		-t pdf \
		--from=markdown+yaml_metadata_block \
		--toc \
		--toc-depth 6 \
		--citeproc \
		--bibliography references.bib \
		--csl elsevier-with-titles.csl \
		--pdf-engine=xelatex \
		--number-sections \
		--lua-filter=section-number.lua \
		--highlight-style=tango \
		-V linkcolor:blue \
		-V geometry:a4paper \
		-V geometry:margin=2cm \
		-V mainfont="DejaVu Serif" \
		-V monofont="DejaVu Sans Mono" \
		-o $@

	$(PDFTK) $(BODY) dump_data output - | \
		awk -v title="$(TITLE)" '/^InfoKey: Title/ { t=1 } t && /^InfoValue:/ { $$0 = "InfoValue: " title; t=0 }1' > $(BODY_INFO)
	$(SED) -i "s/Pages\:\ .*/Pages: $$(grep 'NumberOfPages: ' $(BODY_INFO)| $(SED) 's/NumberOfPages: //g')/" $(TITLE_DAT)
	$(XELATEX) $(TITLE_TEX)
	$(PDFTK) A=$(TITLE_PDF) B=$(BODY) cat A1-end B2-end output $(CONCAT)
	$(PDFTK) $(CONCAT) update_info $(BODY_INFO) output $(OUT)
	rm -f $(TITLE_PDF) $(BODY) $(BODY_INFO) $(CONCAT)

clean:
	rm -f $(TITLE_PDF) $(BODY) $(BODY_INFO) $(CONCAT) $(OUT) *.log *.aux
