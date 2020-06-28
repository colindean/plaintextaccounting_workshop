OUTPUT=pta_workshop
PDF_OUTPUT=$(OUTPUT).pdf

OUTPUTS=$(PDF_OUTPUT)

CONFIG=config.yaml
MD_FILES=$(sort $(wildcard 0*.md))

all: $(OUTPUTS)

$(PDF_OUTPUT): $(MD_FILES) $(CONFIG)
	pandoc \
		--defaults $(CONFIG) \
		$(MD_FILES) \
		-o $@ \
		-M "crossrefYaml=pandoc-crossref.yaml"

.PHONY: open
open: $(PDF_OUTPUT)
	open $(PDF_OUTPUT)

.PHONY: watch
watch:
	ls Makefile $(MD_FILES) $(CONFIG) | entr -napr make $(PDF_OUTPUT)
