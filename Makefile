OUTPUT=pta_workshop
PDF_OUTPUT=$(OUTPUT).pdf

OUTPUTS=$(PDF_OUTPUT)

CONFIG=config.yaml
MD_FILES=$(sort $(wildcard 0*.md))
LEDGER_FILES=$(sort $(wildcard *.ledger))

LICENSE_TEX=LICENSE.tex

all: $(OUTPUTS)

$(PDF_OUTPUT): $(MD_FILES) $(CONFIG) $(LICENSE_TEX)
	pandoc \
		--defaults $(CONFIG) \
		$(MD_FILES) \
		-o $@ \
		-M "date=v$(shell date +%Y.%m.%d)$(PATCH)" \
		-M "crossrefYaml=pandoc-crossref.yaml"

.PHONY: open
open: $(PDF_OUTPUT)
	open $(PDF_OUTPUT)

%.tex: %.md
	pandoc --from=markdown+autolink_bare_uris --to=latex $< -o $@

WATCHABLES=Makefile $(MD_FILES) $(CONFIG) $(LEDGER_FILES) $(LICENSE_TEX:%.tex=%.md) refs.bibtex

.PHONY: watch
watch:
	ls $(WATCHABLES) $(LICENSE_TEX) | entr -napr make $(PDF_OUTPUT) PATCH=-wip

.PHONY: gitadd
gitadd:
	git add $(WATCHABLES)
