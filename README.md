# Thesis Template

This **LaTeX** template is designed to satisfy the major formatting requirements
for a thesis or dissertation as specified by the Texas A&M Graduate and
Professional School, which can be found on the
[Thesis and Dissertation Services webpage](https://grad.tamu.edu/academics/academic-success-resources/thesis-dissertation-services).

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
`lualatex`. This template has been tested using `LuaHBTeX, Version 1.24.0`,
which is included in the March 1 release of
[TeX Live 2026](https://tug.org/texlive/).
You may also need to install `biber`, which is used by default as the
bibliography backend instead of `BibTeX` (though this can certainly be changed
at your discretion).
Finally, if you choose to use any of the example fonts specified in the
preamble, you must ensure they are installed on your system.

### Using the Makefile
A `Makefile` is provided to automate the compilation process.
You may find the following commands useful:

*   **`make`**: Compiles the document using `latexmk` and `lualatex`.
*   **`make todo`**: Lists all "TODO" notes found in `.tex` files.
*   **`make clean`**: Removes all auxiliary files and the generated PDF.

If you wish to change the name of the `main` file, you will need to modify the
first line of the `Makefile` appropriately.

If you do not wish to use `make` or `latexmk`, then you may compile the document
using
```bash
lualatex main.tex
```
however, it may require multiple passes to correctly number everything.

## Using the cleanup script
Once you have reviewed the contents in this template and are ready to begin your
own thesis, you can use the included `cleanup.py` script to clear all of the
examples and strip the template to a minimal working state. This script will
also remove this `README` itself--- rename this file to something else if you
want to keep these instructions.

Run the script from your terminal (assuming you have python):
```bash
python3 cleanup.py
```

> [!WARNING]
> This action is semi-permanent and destructive.
> Running this script will delete all example chapters, all LaTeX auxiliary
> files, this README.md file, and the `cleanup.py` script itself. Ensure you
> have read the documentation and examples provided in the template before
> proceeding. If you ever find that you need any of the instructions deleted by
> this script, you will need to re-clone this repository from scratch.
