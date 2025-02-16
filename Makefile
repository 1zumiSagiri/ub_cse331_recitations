FILE := $(word 2, $(MAKECMDGOALS))

LATEX_DOCS := $(shell find . -name '*.tex')

CLEANABLES := $(shell find . \( -name '*.aux'\
							-o -name '*.log'\
							-o -name '*.nav'\
							-o -name '*.out'\
							-o -name '*.snm'\
							-o -name '*-blx.bib'\
							-o -name '*.bbl'\
							-o -name '*.bcf'\
							-o -name '*.blg'\
							-o -name '*.run.xml'\
							-o -name '*.toc' \) -type f -not -path "./.git/*")

ALLCLEANABLES := $(CLEANABLES) $(shell find . -name '*.pdf' -type f -not -path "./.git/*")

.PHONY: check-env all slide clean cleanall

check-env:
	@command -v xelatex >/dev/null 2>&1 || { echo "Error: xelatex is not installed. Please install TeX Live or MacTeX."; exit 1; }
	@command -v biber >/dev/null 2>&1 || { echo "Error: biber is not installed. Please install biber."; exit 1; }

all: check-env
		@for file in $(LATEX_DOCS); do \
			base=$$(basename $$file .tex); \
			dir=$$(dirname $$file); \
			if [ -f "$${dir}/$$base.bib" ]; then \
				xelatex -output-directory=$$dir $$file; \
				biber --input-directory $$dir --output-directory $$dir $$base; \
				xelatex -output-directory=$$dir $$file; \
				xelatex -output-directory=$$dir $$file; \
			else \
				xelatex -output-directory=$$dir $$file; \
			fi; \
		done

clean:
	@for file in $(CLEANABLES); do\
		echo "Removing $$file";\
		rm -f $$file;\
	done

cleanall:
	@for file in $(ALLCLEANABLES); do\
		echo "Removing $$file";\
		rm -f $$file;\
	done
