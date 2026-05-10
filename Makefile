# change this if you change the name of your main file:
MAIN = main

.PHONY: all latexmk todo clean

all: latexmk

latexmk:
	latexmk -pdflua -f $(MAIN)

todo:
	@grep -R -s -n "TODO" **/*.tex || echo "No TODOs found."

clean:
	latexmk -C $(MAIN)
	@rm -f **/*.aux *-mathml.html *.bcf *.xml *.bbl
	@echo "Clean complete."
