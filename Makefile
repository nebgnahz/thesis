.PHONY: quick thesis.pdf clean

LATEX = pdflatex
BIBTEX = bibtex
SRCS = $(shell find . -name '*.tex')
TEX_FLAGS = -interaction=nonstopmode -halt-on-error

ALL: thesis.pdf

quick: $(SRCS)
	$(LATEX) $(TEX_FLAGS) thesis

thesis.pdf: $(SRCS)
	$(LATEX) $(TEX_FLAGS) thesis
	$(BIBTEX) thesis
	$(LATEX) $(TEX_FLAGS) thesis
	$(LATEX) $(TEX_FLAGS) thesis

clean:
	rm -f *.aux *.log *.out *.bbl *.blg *~ *.bak *.ps *.pdf *.synctex.gz
	rm -f *.bcf *.xml *.nav *.vrb *.snm *.toc *.lot *.lof *-blx.bib
	rm -rf auto
	rm -f thesis.pdf intro.pdf network.pdf compute.pdf conclusion.pdf
