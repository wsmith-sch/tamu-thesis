# change this if you change the name of your main file:
MAIN = main

.PHONY: all latexmk todo clean strip-template

all: latexmk

latexmk:
	latexmk -pdflua -f $(MAIN)

todo:
	@grep -R -s -n "TODO" **/*.tex || echo "No TODOs found."

clean:
	latexmk -C $(MAIN)
	@rm -f **/*.aux *-mathml.html *.bcf *.xml *.bbl
	@echo "Clean complete."

# STRIP-TEMPLATE-START
strip-template:
	@printf '%s' "This will delete all example chapters/figures, empty backmatter/refs.bib, replace main.tex with a minimal version, delete this README, and remove this command from the Makefile. PROCEED? (y/n): "; \
	read confirm; \
	if [ "$$confirm" != "y" ]; then echo "Aborted."; exit 1; fi
	@rm -f README.md \
		chapters/usage.tex \
		chapters/equations.tex \
		chapters/tagging-images.tex \
		chapters/making-tables.tex \
		chapters/making-bib.tex \
		chapters/headings.tex \
		backmatter/troubleshoot.tex \
		backmatter/compile.tex \
		figs/alt-text-instructions.png \
		figs/complicated.tex \
		figs/example-a.pdf \
		figs/example-b.pdf \
		figs/mathbf.png \
		tables/table.tex
	@find . -name "*.aux" -delete
	@rm -f main*
	@: > backmatter/refs.bib
	@sed -i.bak '/\\autoref{ch:usage}/d' preliminary/abstract.tex
	@rm -f preliminary/abstract.tex.bak
	@printf '%b' '% !TeX program = lualatex\n\n\\input{preamble}\n\n\\begin{document}\n\n\\input{preliminary/title-page}\n\n\\startpreliminary\n\n\\include{preliminary/abstract}\n\\include{preliminary/dedication}\n\\include{preliminary/acknowledgements}\n\\include{preliminary/contributors}\n\\include{preliminary/nomenclature}\n\n\\makecontents\n\n\\startmain\n\n% put your chapters here\n\n\\buildbibliography{References}\n\n%\\begin{appendices}\n% appendices here if you have them\n%\\end{appendices}\n\n\\end{document}\n' > main.tex
	@sed -i.bak 's/ strip-template//' Makefile
	@sed -i.bak '/# STRIP-TEMPLATE-START/,/# STRIP-TEMPLATE-EN[D]/d' Makefile
	@rm -f Makefile.bak
	@echo "Cleanup complete. Enjoy the template."
# STRIP-TEMPLATE-END
