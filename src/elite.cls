% Elite-Class
% Params:
%   narrow: change margin to 1in instead of 1.5in
% Key-Value Params:
%   fontstyle [default=default,light,bold]: directly passed in font-package-requirement
%   babelparam [default=ngerman]

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{elite}[2021/08/03 S32-Class]
\LoadClass[document]{article}

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


%
% Package-Dependencies
%

% Load babel package before anything else
\RequirePackage[\elite@babelparam]{babel}

\RequirePackage[T1]{fontenc}        % text font
\RequirePackage[utf8]{inputenc}     % input encoding

\RequirePackage[table]{xcolor}      % colors
\RequirePackage{fontawesome5}       % fontawesome icons
\RequirePackage[color, leftbars]{changebar}     % colored bars next to definitions
\RequirePackage{graphicx}   % include pictures
\RequirePackage{wrapfig}    % format pictures
\RequirePackage{booktabs}   % prettier tables
\RequirePackage{csquotes}   % \enquote command
\RequirePackage{environ}    % better environments
\RequirePackage{xparse}     % better commands

% Math packages and symbols
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}

% Index and listing packages
\RequirePackage{caption}
\RequirePackage{imakeidx}
\RequirePackage{hyperref}
\RequirePackage{listings}       % source code listings
\RequirePackage{sourcecodepro}  % soruce code font

% Dependencies changed by options
% \RequirePackage[\elite@fontstyle]{sourceserifpro}


%
% Indices
%
\makeindex[name=definition, title=Definitionen]
\providecommand{\printindices}{%
    \printindex
    \printindex[definition]
}


%
% Elite Modules
%
\RequirePackage{elite-listings}
\RequirePackage{elite-colors}
\RequirePackage{elite-definitions}
\RequirePackage{elite-utils}


%
% Listings and Geometry
%
\AtEndOfClass{
    % captions and listing index
    \addto\captionsngerman{\renewcommand{\figurename}{Abb.}}
    \addto\captionsenglish{\renewcommand{\figurename}{Fig.}}

    \RequirePackage[a4paper, margin=\elitePageMargin]{geometry}
    % fix spacing and indentation
    \frenchspacing
    \setlength{\parindent}{0em}

    \makeindex[title=Definitionenübersicht, columns=2, intoc]
}


%
% Style Utilities
%

% Renewing \maketitle deprecated, still leaving here for now
%\renewcommand{\maketitle}{%
%    \twocolumn[%
%        \fontsize{50}{60}\fontfamily{phv}\fontseries{b}%
%        \fontshape{sl}\selectfont\headlinecolor
%        \@title
%        \medskip
%        ]%
%}

% change standard sizes
\renewcommand\LARGE{\@setfontsize\LARGE{13pt}{16}}
\renewcommand\Large{\@setfontsize\Large{11pt}{14}}
\renewcommand\large{\@setfontsize\large{10pt}{13}}

% change header sizes

%! suppress = MightBreakTexify
%! suppress = MissingLabel
\renewcommand{\section}{%
    \@startsection
    {section}{1}{0pt}{-1.5ex plus -1ex minus -.2ex}%
    {1ex plus .2ex}{\LARGE\rmfamily\fontseries{sb}\selectfont\headlinecolor}%
}

%! suppress = MightBreakTexify
%! suppress = MissingLabel
\renewcommand{\subsection}{%
    \@startsection
    {subsection}{2}{0pt}{-1.5ex plus -1ex minus -.2ex}%
    {1ex plus .2ex}{\Large\rmfamily\fontseries{sb}\selectfont\headlinecolor}%
}

%! suppress = MightBreakTexify
%! suppress = MissingLabel
\renewcommand{\subsubsection}{%
    \@startsection
    {subsubsection}{3}{0pt}{-1.5ex plus -1ex minus -.2ex}%
    {1ex plus .2ex}{\large\rmfamily\fontseries{sb}\selectfont\headlinecolor}%
}
