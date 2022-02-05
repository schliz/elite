% Elite-Class
% Params:
%   narrow: change margin to 1in instead of 1.5in
% Key-Value Params:
%   fontstyle [default=default,light,bold]: directly passed in font-package-requirement
%   babelparam [default=ngerman]

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{elite}[2021/08/03 S32-Class]
\LoadClass{article}

\RequirePackage{kvoptions}

% Constant Definitions (may be overwritten by KV-Options)
\providecommand{\headlinecolor}{\color{black}}
\providecommand{\elitePageMargin}{1.5in}
\providecommand{\eliteFontStyle}{default,light,bold}

% Load KV-Options
\DeclareStringOption[default,light,bold]{fontstyle}
\DeclareStringOption[ngerman]{babelparam}
\ProcessKeyvalOptions*
\DeclareOption{narrow}{\renewcommand{\elitePageMargin}{1in}}
\ProcessOptions\relax

% Load babel package before anything else
\RequirePackage[\elite@babelparam]{babel}

% Package-Dependencies
\RequirePackage[table]{xcolor}   % Farben
\RequirePackage{fontawesome5}    % Fontawesome
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage[color, leftbars]{changebar}     % Farbige Balken neben Definitionen
\RequirePackage{graphicx}   % Bilder einbinden
\RequirePackage{wrapfig}    % Bilder formatieren
\RequirePackage{booktabs}   % Schöne Tabellen
\RequirePackage{csquotes}   % \enquote command
\RequirePackage{environ}    % Better Environments

% Math-Packages (idk why but it doesn't work without :P)
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}

% Index and Listing packages
\RequirePackage{caption}
\RequirePackage{imakeidx}
\RequirePackage{hyperref}
\RequirePackage{listings}       % Quelltext
\RequirePackage{sourcecodepro}  % Quelltext Font

% Custom packages
\RequirePackage{elite-listings}
\RequirePackage{elite-colors}
\RequirePackage{elite-definitions}
\RequirePackage{elite-utils}

% Dependencies changed by options
% \RequirePackage[\elite@fontstyle]{sourceserifpro}

\AtEndOfClass{
    \addto\captionsngerman{\renewcommand{\figurename}{Abb.}}
    \addto\captionsenglish{\renewcommand{\figurename}{Fig.}}
    \makeindex[title=Definitionenübersicht, columns=2, intoc]
}

% Class-Dependencies
% \LoadClass[document]{article}
\AtEndOfClass{
    \RequirePackage[a4paper, margin=\elitePageMargin]{geometry}
    % fix spacing and indentation
    \frenchspacing
    \setlength{\parindent}{0em}
}

% remove indentation

% Command Redefinition

%\renewcommand{\maketitle}{%
%    \twocolumn[%
%        \fontsize{50}{60}\fontfamily{phv}\fontseries{b}%
%        \fontshape{sl}\selectfont\headlinecolor
%        \@title
%        \medskip
%        ]%
%}

\renewcommand\LARGE{\@setfontsize\LARGE{13pt}{16}}
\renewcommand\Large{\@setfontsize\Large{11pt}{14}}
\renewcommand\large{\@setfontsize\large{10pt}{13}}

\renewcommand{\section}{%
    \@startsection
    {section}{1}{0pt}{-1.5ex plus -1ex minus -.2ex}%
    {1ex plus .2ex}{\LARGE\rmfamily\fontseries{sb}\selectfont\headlinecolor}%
}

\renewcommand{\subsection}{%
    \@startsection
    {subsection}{2}{0pt}{-1.5ex plus -1ex minus -.2ex}%
    {1ex plus .2ex}{\Large\rmfamily\fontseries{sb}\selectfont\headlinecolor}%
}

\renewcommand{\subsubsection}{%
    \@startsection
    {subsubsection}{3}{0pt}{-1.5ex plus -1ex minus -.2ex}%
    {1ex plus .2ex}{\large\rmfamily\fontseries{sb}\selectfont\headlinecolor}%
}
