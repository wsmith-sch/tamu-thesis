# Thesis Template

This **LaTeX** template is designed to satisfy the major formatting requirements
for a thesis or dissertation as specified by the Texas A&M Graduate and
Professional School, which can be found on the
[TDS Writing Your Document website](https://grad.tamu.edu/degree-completion/thesis-and-dissertation/writing-tools/index.html).

In addition, this template helps ensure that your thesis or dissertation
meets the Web Content Accessibility Guidelines (WCAG) 2.1 Level AA standards.

The template compiles the document to meet both **PDF/UA-2** and **PDF/A-4**
standards. The **PDF/A-4** standard ensures the long-term preservation and
archival integrity of the file's visual appearance, whereas the **PDF/UA-2**
standard provides the high-level semantic tagging and structural metadata
necessary for compatibility with assistive technologies like screen readers and
refreshable braille displays. Inside the example template itself, we give brief
examples of how one may add alternative text to figures along with a few other
remarks about digital accessibility in **LaTeX**.

## Local Compilation

If you intend to compile the document on your own device, note that you must use
`lualatex`. This template has been tested using `LuaHBTeX, Version 1.24.0`
and the 2026-06-01 release of LaTeX, both included in an up-to-date
[TeX Live 2026](https://tug.org/texlive/).
If you do not already have a recent TeX Live installation, you are *strongly*
recommended to install one using the install script provided by the TeX Users
Group (TUG); see their
[quick install guide](https://www.tug.org/texlive/quickinstall.html).
You may also need to install `biber`, which is used by default as the
bibliography backend instead of `BibTeX` (though this can certainly be changed
at your discretion).
Finally, if you choose to use any of the example fonts specified in the
preamble, you must ensure they are installed on your system.

### Using the Makefile
A `Makefile` is provided to automate the compilation process.
Note that you will need `make` installed on your system to use it.
You may find the following commands useful:

*   **`make`**: Compiles the document using `latexmk` and `lualatex`.
*   **`make todo`**: Lists all "TODO" notes found in `.tex` files.
*   **`make clean`**: Removes all auxiliary files and the generated PDF.
*   **`make strip-template`**: Strips the template of all example content (vide infra).

If you wish to change the name of the `main` file, you will need to modify the
first line of the `Makefile` appropriately.

If you do not wish to use `make` or `latexmk`, then you may compile the document
using
```bash
lualatex main.tex
```
however, it may require multiple passes to correctly number everything.

## Stripping the template
Once you have reviewed the contents in this template and are ready to begin your
own thesis, you can run `make strip-template` to clear all of the examples and
strip the template to a minimal working state. This command will also remove
this `README` itself — rename this file to something else if you want to keep
these instructions.

Run it from your terminal:
```bash
make strip-template
```

> [!WARNING]
> This action is semi-permanent and destructive.
> Running this command will delete all example chapters, all LaTeX auxiliary
> files, this README.md file, empty out `backmatter/refs.bib`, and remove the
> `strip-template` command itself (so it
> cannot accidentally be run a second time, e.g. after you've written your own
> content into `main.tex`). Ensure you have read the documentation and examples
> provided in the template before proceeding. If you ever find that you need
> any of the instructions deleted by this command, you will need to restore this
> repository to its previous state or re-clone it entirely
