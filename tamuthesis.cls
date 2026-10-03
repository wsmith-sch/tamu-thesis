\NeedsTeXFormat{LaTeX2e}[2026-06-01]
\ProvidesClass{tamuthesis}[2026/10/03 TAMU thesis v1.2.0]

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
    \ClassWarning{tamuthesis}{TOC depth must be at least 1 per TAMU guidelines. Setting to 1.}
    \renewcommand{\tamuthesis@depth}{1}
    \else
    \ifnum#1>3
    \ClassWarning{tamuthesis}{TOC depth of #1 is a tad excessive. Setting to 3.}
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

% debugging: print latex lab info to log
\typeout{latex lab version : \ltlabsecdate\space v\ltlabsecversion}
\typeout{latex lab sec-template : \ltlabsecIIdate\space v\ltlabsecIIversion}

% Required for accessibility
\RequirePackage{unicode-math}

% Required for our formatting guidelines etc
\RequirePackage[letterpaper]{geometry}
\geometry{verbose, margin=1in}
\RequirePackage{hyperref}
\RequirePackage[doublespacing]{setspace}
\RequirePackage{longtable}
\RequirePackage[bottom]{footmisc} % force footnotes to bottom of page
\RequirePackage{appendix}
\RequirePackage{etoolbox} % \ifdefempty on the title page

% not required but nice
\RequirePackage{microtype} % good kerning etc

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
\tagpdfsetup{float/here}

% set TOC depth: must be at least 1 per the Grad school
\AddToHook{begindocument}{
  \setcounter{tocdepth}{\tamuthesis@depth}
  \setcounter{secnumdepth}{\tamuthesis@depth}
}

% Format titles for subheadings:

% latex-lab formats headings through tagged "heading" templates, which we edit here
%
% Its keys change between releases, so we only restyle for sec-template versions
% we have checked; add a line here after verifying a new one
\@namedef{tamuthesis@secII@0.9g}{}
\@ifundefined{tamuthesis@secII@\ltlabsecIIversion}
{% unverified version: warn and keep latex-lab's default, rather than risk errors
  \ClassWarning{tamuthesis}{%
    Heading formatting unverified for latex-lab sec-template
  \ltlabsecIIversion; using default style. Update tamuthesis.cls}%
}
{% "hang" keeps the number and title on one centered line
  % after-*-vspace pull the title to the top of the page
  % prefix (\@chapapp) is cleared for a bare "1."
  \DeclareInstance{headformat}{tamuchapter}{hang}{
    , heading-indent   = 0pt
    , number-title-sep = 1em
    , title-format     = \MakeUppercase{#1}
  }
  \EditInstance{heading}{chapter}{
    , placement            = top
    , after-penalty-vspace = 0pt
    , after-vspace         = 20pt
    , prefix               = \NoValue
    , heading-decls        = \centering \normalfont \normalsize
    \if@tamuthesis@boldheadings \bfseries \fi
    , number-decls         = \normalsize
    , title-decls          = \normalsize
    , headformat-instance  = tamuchapter
    , number-format        = \MakeUppercase{\thechapter.}
    , contents-extra       = % no space between chapters in the LoF & LoT
  }
  % for sections and lower, this applies to the normal and *'d alike
  \EditInstance{heading}{section}{
    , before-vspace = 2.5ex plus 1ex minus .2ex
    , after-vspace  = 1.5ex plus .2ex
    , heading-decls = \normalfont
    \if@tamuthesis@italicsections \itshape \fi
    \if@tamuthesis@boldsections \bfseries \fi
    \if@tamuthesis@centersections \centering \fi
  }
  \EditInstance{heading}{subsection}{
    , before-vspace = 2ex plus 1ex minus .2ex
    , after-vspace  = 1ex plus .2ex
    , heading-decls = \normalfont
    \if@tamuthesis@italicsubsections \itshape \fi
    \if@tamuthesis@boldsubsections \bfseries \fi
    \if@tamuthesis@centersections \centering \fi
  }
  \EditInstance{heading}{subsubsection}{
    , before-vspace = 1.5ex plus 1ex minus .2ex
    , after-vspace  = 1ex plus .2ex
    , heading-decls = \normalfont
    \if@tamuthesis@italicsubsubsections \itshape \fi
    \if@tamuthesis@boldsubsubsections \bfseries \fi
    \if@tamuthesis@centersections \centering \fi
  }
}

%% Format TOC

\renewcommand{\@dotsep}{2}
\AddToHookWithArguments{contentsline/text/after}{%
  \ifnum#1=0%
  \tagmcbegin{artifact=notype} \dotfill \tagmcend%
  \vspace{0.5em}%
  \fi%
}

% to make a . after the chapter title in the ToC
\AddToHook{cmd/l@chapter/before}{
  \let\tamuthesis@numberline\numberline
  \renewcommand{\numberline}[1]{\tamuthesis@numberline{#1.}}
}
\AddToHook{cmd/l@chapter/after}{
  \let\numberline\tamuthesis@numberline
}

\renewcommand{\contentsname}{Table of Contents}

% the commented out lines here make the ToC be formatted consistently with the chapter/section titles.
% we were told that the ToC should always appear without italics, etc, so we commented it out (weird rule; if it ever changes, just put these lines back in)
% TODO: would be nice to force TitleCase on the level 1+ subheadings but there's a bug methinks
\@namedef{contentsline@text@0@format}{
  \mdseries % <- it is BF by default; negates our toggle
  %\ifdefined\BoldHeadings\bfseries\fi\centering
  \MakeUppercase
}

\@namedef{contentsline@text@1@format}{
  %\ifdefined\ItalicSections\itshape\fi
  %\ifdefined\BoldSections\bfseries\fi
}

\@namedef{contentsline@text@2@format}{
  %\ifdefined\ItalicSubSections\itshape\fi
  %\ifdefined\BoldSubSections\bfseries\fi
}

\@namedef{contentsline@text@3@format}{
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
  \pagenumbering{roman}
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
        { \if@tamuthesis@boldheadings\bfseries\fi
          \MakeUppercase{\manuscripttitle}
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
      \gradmonth\ \gradyear

      \vspace{3em}

      Major Subject: \department \par
      \vspace{3em}
      Copyright \gradyear \hspace{.5em}\fullname
      \par
    \end{center}
  \end{titlepage}
  \newpage
}

% ToC, LoF, and LoT pages: a chapter-style heading listed in the ToC, the word "Page", then the list
% #3 is extra space below "Page"
% "Page" header adapted from https://tex.stackexchange.com/a/759618
\newcommand{\tamuthesis@contentspage}[3]{
  \chapter*{#2}
  \addcontentsline{toc}{chapter}{#2}
  \begin{singlespace}
    \SuspendTagging{tamuthesis}
    \vspace*{16.5pt}
    \hfill\makebox[\@pnumwidth][c]{Page}\par
    \vspace{#3}\bigskip
    \ResumeTagging{tamuthesis}
    \@starttoc{#1}
  \end{singlespace}
  \newpage
}

% this command makes the ToC, LoF, and LoT
\newcommand{\makecontents}{
  \tamuthesis@contentspage{toc}{\contentsname}{-0.5em}
  % to space out entries in the LoF/LoT
  \AddToHookWithArguments{contentsline/text/after}{ \vspace{1em} }
  \tamuthesis@contentspage{lof}{\listfigurename}{0.5em}
  \tamuthesis@contentspage{lot}{\listtablename}{0.5em}
}

% FORMATTING THE APPENDIX
% we want it to say "APPENDIX" before the Chapter heading, in the ToC, and in \ref's (but not before sections etc)
\newif\if@inappendixhead
\@inappendixheadfalse

\ExplSyntaxOn
\cs_new:Npn \tamuthesis@appendixprefix { \text_uppercase:n { \appendixname } }
\ExplSyntaxOff

\AddToHook{env/appendices/begin}{
  \IfInstanceExistsT{headformat}{tamuchapter}
  {\EditInstance{heading}{chapter}{prefix = \tamuthesis@appendixprefix}}
  \renewcommand{\p@chapter}{\tamuthesis@appendixprefix~}
  \AddToHook{cmd/chapter/before}{\@inappendixheadtrue}
  \AddToHook{cmd/chapter/after}{\@inappendixheadfalse}
}

% (the [titletoc] option of the appendix package no longer does this with latex-lab headings)
\NewCommandCopy{\tamuthesis@addcontentsline}{\addcontentsline}
\renewcommand{\addcontentsline}[3]{
  \if@inappendixhead
  \tamuthesis@addcontentsline{#1}{#2}{\appendixname\space #3}
  \else
  \tamuthesis@addcontentsline{#1}{#2}{#3}
  \fi
}

% command to add the bibliography and correctly format it in the ToC
\newcommand{\buildbibliography}[1]{
  \printbibliography[heading=bibintoc, title=#1]
}

% capitalize chapters when autoref'd
\renewcommand{\chapterautorefname}{Chapter}
% use symbol for section
\renewcommand{\sectionautorefname}{\S}

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
