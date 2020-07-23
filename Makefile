OUTPUT=pta_workshop
PDF_OUTPUT=$(OUTPUT).pdf

OUTPUTS=$(PDF_OUTPUT)

CONFIG=config.yaml
MD_FILES=$(sort $(wildcard 0*.md))
LEDGER_FILES=$(sort $(wildcard *.ledger))

HEADER_TEXS=LICENSE.tex REPO.tex

all: $(OUTPUTS)

$(PDF_OUTPUT): $(MD_FILES) $(CONFIG) $(HEADER_TEXS)
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

WATCHABLES=Makefile $(MD_FILES) $(CONFIG) $(LEDGER_FILES) $(HEADER_TEXS:%.tex=%.md) refs.bibtex

.PHONY: watch
watch:
	ls $(WATCHABLES) $(HEADER_TEXS) | entr -napr make $(PDF_OUTPUT) PATCH=-wip

.PHONY: gitadd
gitadd:
	git add $(WATCHABLES)

.PHONY: clean
clean:
	rm -rf $(HEADER_TEXS) $(OUTPUTS)

