OUTPUT=pta_workshop
PDF_OUTPUT=$(OUTPUT).pdf
HTML_OUTPUT=$(OUTPUT).html

OUTPUTS=$(PDF_OUTPUT) $(HTML_OUTPUT)

CONFIG=config.yaml
MD_FILES=$(sort $(wildcard 0*.md))
LEDGER_FILES=$(sort $(wildcard *.ledger))

HEADER_TEXS=LICENSE.tex REPO.tex
HEADER_HTMLS=$(HEADER_TEXS:%.tex=%.html)

all: $(OUTPUTS)

$(OUTPUT).pdf: $(MD_FILES) $(CONFIG) $(HEADER_TEXS)
	pandoc \
		--defaults $(CONFIG) \
		$(MD_FILES) \
		-o $@ \
		-M "date=v$(shell date +%Y.%m.%d)$(PATCH)" \
		-M "crossrefYaml=pandoc-crossref.yaml" \
		$(addprefix --include-before-body=, $(HEADER_TEXS))

$(OUTPUT).html: $(MD_FILES) $(CONFIG) $(HEADER_HTMLS)
	pandoc \
		--defaults $(CONFIG) \
		$(MD_FILES) \
		-o $@ \
		-M "date=v$(shell date +%Y.%m.%d)$(PATCH)" \
		-M "crossrefYaml=pandoc-crossref.yaml" \
		$(addprefix --include-before-body=, $(HEADER_HTMLS))

.PHONY: open
open: $(PDF_OUTPUT)
	open $(PDF_OUTPUT)

%.tex: %.md
	pandoc --from=markdown+autolink_bare_uris --to=latex $< -o $@

%.html: %.md
	pandoc --from=markdown+autolink_bare_uris --to=html $< -o $@

WATCHABLES=Makefile $(MD_FILES) $(CONFIG) $(LEDGER_FILES) $(HEADER_TEXS:%.tex=%.md) refs.bibtex

.PHONY: watch
watch:
	ls $(WATCHABLES) $(HEADER_TEXS) $(HEADER_HTMLS) | entr -napr make all PATCH=-wip

.PHONY: gitadd
gitadd:
	git add $(WATCHABLES)

.PHONY: clean
clean:
	rm -rf $(HEADER_TEXS) $(HEADER_HTMLS) $(OUTPUTS) pta_workshop_artifacts.tar.gz

