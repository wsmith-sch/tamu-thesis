\NeedsTeXFormat{LaTeX2e}[2025-11-01]
\ProvidesClass{tamuthesis}[2026/06/04 TAMU thesis v1.0]

\LoadClass[12pt]{report}

\newcommand{\tamuthesis@depth}{1}

% we act as a wrapper for hyperref here:
\newcommand{\tamuthesis@linkcolor}{black}
\newcommand{\tamuthesis@citecolor}{black}
\newcommand{\tamuthesis@urlcolor}{black}

\DeclareKeys[tamuthesis]
{
  boldheadings.if = @tamuthesis@boldheadings,
  centersections.if = @tamuthesis@centersections,
  boldsections.if = @tamuthesis@boldsections,
  italicsections.if = @tamuthesis@italicsections,
  boldsubsections.if = @tamuthesis@boldsubsections,
  italicsubsections.if = @tamuthesis@italicsubsections,
  boldsubsubsections.if = @tamuthesis@boldsubsubsections,
  italicsubsubsections.if = @tamuthesis@italicsubsubsections,
  depth.code = {
    \ifnum#1<1
    \PackageWarning{tamuthesis}{TOC depth must be at least 1 per TAMU guidelines. Setting to 1.}
    \renewcommand{\tamuthesis@depth}{1}
    \else
    \ifnum#1>3
    \PackageWarning{tamuthesis}{TOC depth of #1 is a tad excessive. Setting to 3.}
    \renewcommand{\tamuthesis@depth}{3}
    \else
    \renewcommand{\tamuthesis@depth}{#1}
    \fi
    \fi
  },
  printmode.if    = @tamuthesis@printmode,
  % comment out due to ToC looking ugly
  %linkcolor.store = \tamuthesis@linkcolor,
  citecolor.store = \tamuthesis@citecolor,
  urlcolor.store  = \tamuthesis@urlcolor,
}

% set default keys
\SetKeys[tamuthesis]{
  boldheadings=false,
  centersections=true,
  boldsections=false,
  italicsections=false,
  boldsubsections=false,
  italicsubsections=false,
  boldsubsubsections=false,
  italicsubsubsections=true,
  depth = 2,
  %linkcolor = black,
  citecolor = black,
  urlcolor  = blue,
  printmode = false,
}

\ProcessKeyOptions

% Let user define their own keys after loading the class (like hyperref)
% Because of this, any code using these options will have to be wrapped in an AddToHook so it is loaded in the right order
\newcommand{\setupformat}[1]{\SetKeys[tamuthesis]{#1}}

% Required for accessibility
\RequirePackage{unicode-math}

% Required for our formatting guidelines etc
\RequirePackage[letterpaper]{geometry}
\geometry{verbose, margin=1in}
\RequirePackage{hyperref}
\RequirePackage[doublespacing]{setspace}
\RequirePackage{longtable}
\RequirePackage[bottom]{footmisc} % force footnotes to bottom of page
\RequirePackage[titletoc]{appendix} % used to make appendices look right in the ToC

% not required but nice
\RequirePackage{microtype}[kerning=true, tracking=true] % good kerning etc

% style for pages after the title, before main content
\newcommand{\startpreliminary}{
  \pagestyle{plain}
  \pagenumbering{roman}
  \setcounter{page}{2}
}

% style for main content
\newcommand{\startmain}{
  \pagestyle{plain}
  \pagenumbering{arabic}
  \setcounter{page}{1}
}

% here we pass the class options into hyperref
\AddToHook{begindocument}{
  \if@tamuthesis@printmode
  \hypersetup{hidelinks}
  \else
  \hypersetup{
    colorlinks = true,
    linkcolor  = \tamuthesis@linkcolor,
    citecolor  = \tamuthesis@citecolor,
    urlcolor   = \tamuthesis@urlcolor
  }
  \fi
}

% Force logical order of floats
% https://tex.stackexchange.com/questions/755511/why-does-latex-put-the-pdf-tags-for-floats-at-the-end-of-the-document
\ExplSyntaxOn
\bool_gset_false:N\g__tag_float_sect_bool
\ExplSyntaxOff

% set TOC depth: must be at least 1 per the Grad school
\AddToHook{begindocument}{
  \setcounter{tocdepth}{\tamuthesis@depth}
  \setcounter{secnumdepth}{\tamuthesis@depth}
}

% Format titles for subheadings:

% start with chapters
\renewcommand{\@makechapterhead}[1]{
  \vspace*{0pt} % space before title
  {\parindent \z@
    \if@tamuthesis@boldheadings\bfseries\fi\centering\normalsize
    \ifnum \c@secnumdepth >\m@ne
    \MakeUppercase{\thechapter.} \hspace{1em}%
    \fi
    \interlinepenalty\@M
    \MakeUppercase{#1}\par\nobreak
    \vskip 20pt % space after title
  }
}

% ditto for "starred" (schapter)
% what a horrible convention
\renewcommand{\@makeschapterhead}[1]{
  \vspace*{0pt}
  {\parindent \z@
    \if@tamuthesis@boldheadings\bfseries\fi\centering\normalsize
    \interlinepenalty\@M
    \MakeUppercase{#1}\par\nobreak
    \vskip 20pt
  }
}

% for sections and lower, this applies to the normal and *'d alike:
\renewcommand{\section}{%
  \@startsection{section}%
  {1} % level
  {0pt} % indent
  {-2.5ex plus -1ex minus -.2ex} % beforeskip (compact-ish)
  {1.5ex plus .2ex} % afterskip
  {%
    \if@tamuthesis@italicsections\itshape\fi
    \if@tamuthesis@boldsections\bfseries\fi
    \if@tamuthesis@centersections\centering\fi
  }%
}

\renewcommand{\subsection}{%
  \@startsection{subsection}%
  {2}%
  {0pt}%
  {-2ex plus -1ex minus -.2ex}%
  {1ex plus .2ex}%
  {%
    \if@tamuthesis@italicsubsections\itshape\fi
    \if@tamuthesis@boldsubsections\bfseries\fi
    \if@tamuthesis@centersections\centering\fi
  }%
}

\renewcommand{\subsubsection}{%
  \@startsection{subsubsection}%
  {3}%
  {0pt}%
  {-1.5ex plus -1ex minus -.2ex}%
  {1ex plus .2ex}%
  {%
    \if@tamuthesis@italicsubsubsections\itshape\fi
    \if@tamuthesis@boldsubsubsections\bfseries\fi
    \if@tamuthesis@centersections\centering\fi
  }%
}

%% Format TOC

% Source - https://tex.stackexchange.com/a/759618

% add the word "Page"
\AddToHook{begindocument/end}
{\addtocontents{toc}
  {\unexpanded{\SuspendTagging{}
      \vspace*{-1.5em}
      \hfill
      \vspace*{-0.5em}
\makebox[\UseName{@pnumwidth}][c]{Page}\par\bigskip\ResumeTagging{}}}}

\AddToHook{begindocument/end}
{\addtocontents{lof}
  {\unexpanded{\SuspendTagging{}
      \vspace*{-1.5em}
      \hfill
      \vspace*{0.5em}
\makebox[\UseName{@pnumwidth}][c]{Page}\par\bigskip\ResumeTagging{}}}}

\AddToHook{begindocument/end}
{\addtocontents{lot}
  {\unexpanded{\SuspendTagging{}
      \vspace*{-1.5em}
      \hfill
      \vspace*{0.5em}
\makebox[\UseName{@pnumwidth}][c]{Page}\par\bigskip\ResumeTagging{}}}}

\ExpandArgs{c}\def{@dotsep}{2}
\AddToHookWithArguments{contentsline/text/after}{%
  \ifnum#1=0%
  \unexpanded{\tagmcbegin{artifact=notype} \dotfill \tagmcend}%
  \vspace{0.5em}%
  \fi%
}

% to make a . after the chapter title in the ToC
\AddToHook{cmd/l@chapter/before}{
  \let\oldnumberline\numberline
  \renewcommand{\numberline}[1]{\oldnumberline{#1.}}
}
\AddToHook{cmd/l@chapter/after}{
  \let\numberline\oldnumberline
}

% remove space between chapters in LoF & LoT
% Use a hook to target the start of the List of Figures
\AddToHook{cmd/listoffigures/before}{%
  \let\oldaddvspace\addvspace
  \renewcommand{\addvspace}[1]{} % Kill the vertical space command
}

\AddToHook{cmd/listoftables/before}{%
  \let\oldaddvspace\addvspace
  \renewcommand{\addvspace}[1]{}
}

% restore it after so it doesn't break the rest of the document
\AddToHook{cmd/listoffigures/after}{\let\addvspace\oldaddvspace}
\AddToHook{cmd/listoftables/after}{\let\addvspace\oldaddvspace}

\ExpandArgs{c}\def{contentsname}{Table of Contents}

% the commented out lines here make the ToC be formatted consistently with the chapter/section titles.
% we were told that the ToC should always appear without italics, etc, so we commented it out (weird rule; if it ever changes, just put these lines back in)
% TODO: would be nice to force TitleCase on the level 1+ subheadings but there's a bug methinks
\ExpandArgs{c}\def{contentsline@text@0@format}{
  \mdseries % <- it is BF by default; negates our toggle
  %\ifdefined\BoldHeadings\bfseries\fi\centering
  \MakeUppercase
}

\ExpandArgs{c}\def{contentsline@text@1@format}{
  %\ifdefined\ItalicSections\itshape\fi
  %\ifdefined\BoldSections\bfseries\fi
}

\ExpandArgs{c}\def{contentsline@text@2@format}{
  %\ifdefined\ItalicSubSections\itshape\fi
  %\ifdefined\BoldSubSections\bfseries\fi
}

\ExpandArgs{c}\def{contentsline@text@3@format}{
  %\ifdefined\ItalicSubsubsections\itshape\fi
  %\ifdefined\BoldSubsubsections\bfseries\fi
}

% make page # font consistent with chapter title
\AddToHook{contentsline/page/before}{
  \mdseries % <- it is bf by default
  %\ifdefined\BoldHeadings\bfseries\fi\centering%
}

\ExplSyntaxOn % so that `\MakeUppercase` doesn't eat the numberline:
\text_declare_expand_equivalent:Nn\numberline{\exp_not:n{\numberline}}
\ExplSyntaxOff

% this makes the correctly formatted title page & sets up the hyprref
% it must necessary come after they define the title, their name, etc
\newcommand{\maketitlepage}{
  \hypersetup{
    pdftitle={\manuscripttitle},
    pdfauthor={\fullname},
    pdfsubject={\department},
    pdfcopyright={ Copyright (C) \gradyear, \fullname},
    %pdflicenseurl={https://creativecommons.org/licenses/by-sa/4.0/},
    pdfpubtype={\papertype},
    pdflang={en},
    pdfmetalang={en},
  }

  \MakeLinkTarget[section]{}
  \pdfbookmark[0]{Title Page}{bm:titlepage}

  \begin{titlepage}
    \begin{center}
      \begin{doublespace}
        { \ifdefined\BoldHeadings\bfseries\fi
          \MakeUppercase{  \manuscripttitle}
        }
      \end{doublespace}
      \vspace{4em}

      A \papertype

      by

      \MakeUppercase{\fullname}

      \vspace{4em}

      \begin{singlespace}

        Submitted to the Graduate and Professional School of \\
        Texas A\&M University \\

        in partial fulfillment of the requirements for the degree of \\
      \end{singlespace}

      \MakeUppercase{\Degree}
      \par
    \end{center}
    \vspace{2em}
    \begin{doublespace}

    \end{doublespace}

    \begin{singlespace}
      \tagpdfsetup{table/tagging=false}
      \noindent
      \begin{tabular}{@{}ll}
        Chair of Committee, & \chairone\, \\

        % print contents iff the field is nonempty
        \ifdefempty{\chairtwo}{}{Co-Chair, & \chairtwo\, \\}

        Committee Members, & \memberone\, \\

        \ifdefempty{\membertwo}{}{& \membertwo\, \\}
        \ifdefempty{\memberthree}{}{& \memberthree\, \\}
        \ifdefempty{\memberfour}{}{& \memberfour\, \\}
        Head of Department, & \depthead\, \\
      \end{tabular}
    \end{singlespace}

    \vspace{3em}

    \begin{center}
      \gradmonth \hspace{2pt} \gradyear

      \vspace{3em}

      Major Subject: \department \par
      \vspace{3em}
      Copyright \gradyear \hspace{.5em}\fullname
      \par
    \end{center}
  \end{titlepage}
  \newpage
}

% this command makes the ToC, LoF, and LoT
\newcommand{\makecontents}{
  % we go through all this trouble so that the titles are formatted like a chapter
  % specifically, where they are located
  % if that doesn't matter, we could just but \tableofcontents etc
  \chapter*{Table of Contents}
  \addcontentsline{toc}{chapter}{Table of Contents}
  \begin{singlespace}
    \renewcommand\contentsname{\normalfont} {}

    \begingroup
    \let\clearpage\relax
    \let\cleardoublepage\relax
    \tableofcontents
    \endgroup

  \end{singlespace}

  \newpage

  % to space out entries in the LoF/LoT
  \AddToHookWithArguments{contentsline/text/after}{ \vspace{1em} }

  \chapter*{List of Figures}
  \addcontentsline{toc}{chapter}{List of Figures}

  \begin{singlespace}
    \renewcommand{\listfigurename}{}

    \begingroup
    \let\clearpage\relax
    \let\cleardoublepage\relax
    \listoffigures
    \endgroup

  \end{singlespace}
  \newpage

  \chapter*{List of Tables}
  \addcontentsline{toc}{chapter}{List of Tables}

  \begin{singlespace}
    \renewcommand{\listtablename}{}

    \begingroup
    \let\clearpage\relax
    \let\cleardoublepage\relax
    \listoftables
    \endgroup

  \end{singlespace}
  \newpage
}

% FORMATTING THE APPENDIX
% we want it to say "APPENDIX" before the Chapter heading (but not before sections etc)
% this is handled in the ToC using the [titletoc] option of the appendix package, so we turn it off in the ToC to avoid printing this twice
% for some reason, the [title] option is not working, so we manually inject it before we print the chapter title then turn this off subsequently
\newif\if@inappendixhead
\@inappendixheadfalse

\AddToHook{env/appendices/begin}{
  \AddToHook{cmd/chapter/before}{
    \@inappendixheadtrue
    \renewcommand{\thechapter}{APPENDIX~\Alph{chapter}}
  }
  % Immediately revert after the heading is drawn
  \AddToHook{cmd/chapter/after}{
    \renewcommand{\thechapter}{\Alph{chapter}}
    \@inappendixheadfalse
  }
}

% Now we make it to where ToC doesn't see the injection of "APPENDIX" before the chapter title
% we do this instead of turning off the [titletoc] option since it means we don't have to figure out the spacing ourselves (the appendix package does that for us)
\let\oldaddcontentsline\addcontentsline
\renewcommand{\addcontentsline}[3]{
  \if@inappendixhead
  {\renewcommand{\thechapter}{\Alph{chapter}}\oldaddcontentsline{#1}{#2}{#3}}
  \else
  \oldaddcontentsline{#1}{#2}{#3}
  \fi
}

% command to add the bibliography and correctly format it in the ToC
\newcommand{\buildbibliography}[1]{
  \clearpage
  \MakeLinkTarget[section]{}
  \addcontentsline{toc}{chapter}{#1}
  \printbibliography[title=#1]
}

% capitalize chapters when autoref'd
\def\chapterautorefname{Chapter}
% use symbol for section
\def\sectionautorefname{\S}

% First aid for biblatex c.f. :
% https://tex.stackexchange.com/questions/761788/documentmetadata-setspace-biblatex-yields-patching-footnotes-failed
% https://github.com/plk/biblatex/issues/1470
\FirstAidNeededT{biblatex}{sty}{%
  2025/07/10 v3.21 programmable bibliographies (PK/MW)%
}
{%
  \AddToHook{begindocument}{%
    \AddToHook{fntext/begin}[biblatexhack]{\toggletrue{blx@footnote}}%
    \AddToHook{fntext/end}[biblatexhack]{\togglefalse{blx@footnote}}%
  }
}

% brings List of Tables and Figures to the left 1 in margin
\renewcommand*\l@figure{\@dottedtocline{1}{0em}{2.3em}}
\renewcommand*\l@table{\@dottedtocline{1}{0em}{2.3em}}
