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
NEW_MAIN = r"""% !TeX program = lualatex

\input{preamble}

\begin{document}

\input{preliminary/title-page}

\startpreliminary

\include{preliminary/abstract}
\include{preliminary/dedication}
\include{preliminary/acknowledgements}
\include{preliminary/contributors}
\include{preliminary/nomenclature}

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
    # we add back a minimal version later
    for junk in glob.glob("./main*"):
        try:
            os.remove(junk)
            print(f"Deleted junk: {junk}")
        except OSError:
            pass

    with open("main.tex", "w") as f:
        f.write(NEW_MAIN)
    print("Replaced main.tex with minimal version.")

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
