import os
import glob

TO_DELETE = [
    "README.md",
    "chapters/usage.tex",
    "chapters/equations.tex",
    "chapters/tagging-images.tex",
    "chapters/making-tables.tex",
    "chapters/making-bib.tex",
    "chapters/headings.tex",
    "backmatter/troubleshoot.tex",
    "backmatter/compile.tex",
    "figs/alt-text-instructions.png",
    "figs/complicated.tex",
    "figs/example-a.pdf",
    "figs/example-b.pdf",
    "figs/mathbf.png",
    "tables/table.tex",
]

# we'll just dump this into main.tex at the end
SKINNY_MAIN = r"""% !TeX program = lualatex

\input{preamble}

\begin{document}

\input{preface/title-page}

\startpreface

\include{preface/abstract}
\include{preface/dedication}
\include{preface/acknowledgements}
\include{preface/contributors}
\include{preface/nomenclature}

\makecontents

\startmain

% put your chapters here

\buildbibliography{References}

%\begin{appendices}
% appendices here if you have them
%\end{appendices}

\end{document}
"""


def strip_template():
    for path in TO_DELETE:
        if os.path.exists(path):
            try:
                os.remove(path)
                print(f"Removed: {path}")
            except OSError as e:
                print(f"Error deleting {path}: {e}")

    for aux in glob.glob("./**/*.aux", recursive=True):
        os.remove(aux)
        print(f"Cleared: {aux}")

    # this deletes all main* files including main.tex
    # we add back a 'skinny' version later
    for junk in glob.glob("./main*"):
        try:
            os.remove(junk)
            print(f"Cleared LaTeX junk: {junk}")
        except OSError:
            pass

    with open("main.tex", "w") as f:
        f.write(SKINNY_MAIN)
    print("Replaced main.tex with the skinny version.")

    print("\nCleanup complete. Enjoy the template.")
    print("Deleting myself too... bye!")
    if os.path.exists(__file__):
        os.remove(__file__)


if __name__ == "__main__":
    confirm = input(
        "This will strip the template of all extraneous examples, "
        "change main.tex to reflect this, and deleted itself. "
        "PROCEED? (y/n): "
    )
    if confirm.lower() == "y":
        strip_template()
    else:
        print("Aborted.")
