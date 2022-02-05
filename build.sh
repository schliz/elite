#!/bin/bash

ORIGINAL_WORKDIR=$(pwd)

# change directory to location of script
BASEDIR=$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )
cd $BASEDIR

TEXMFHOME=$(kpsewhich -var-value TEXMFHOME)
TEXMFMAIN=$(kpsewhich -var-value TEXMFMAIN)

function clean_build_dir {
    # try to remove and redirect error messages to /dev/null
    rm -r ./build/ 2> /dev/null
}

function assemble {
    mkdir -p $BASEDIR/build/
    echo -n "" > $BASEDIR/build/elite.cls

    if [ $GITHUB_SHA ]
    then
        echo "% Auto-built by GitHub Actions" >> $BASEDIR/build/elite.cls
        echo "% Latest Commit-Hash: $GITHUB_SHA" >> $BASEDIR/build/elite.cls
    fi

    cd $BASEDIR/src/
    for STYFILE in *.sty
    do
        STYCONTENT=$(cat ${STYFILE})  
        echo_safe_filecontents $STYFILE "$STYCONTENT"
    done
    cd $BASEDIR

    echo "" >> $BASEDIR/build/elite.cls
    cat $BASEDIR/src/elite.cls >> $BASEDIR/build/elite.cls
}

function echo_safe_filecontents {
    FILENAME=$1
    FILECONTENTS=$2

#    echo "%
#% External File: $FILENAME
#%
#\begingroup\newif\ifmy
#\IfFileExists{$FILENAME}{}{\mytrue}
#\ifmy
#\begin{filecontents}{$FILENAME}
#$FILECONTENTS
#\end{filecontents}
#\fi\endgroup
#" >> $BASEDIR/build/elite.cls

    echo "%
% External File: $FILENAME
%
\begin{filecontents}[overwrite]{$FILENAME}
$FILECONTENTS
\end{filecontents}
" >> $BASEDIR/build/elite.cls
}

function build_docs {
    mkdir -p $BASEDIR/build/docs/
    cd $BASEDIR/docs
    pdflatex -halt-on-error -output-directory $BASEDIR/build/docs $BASEDIR/docs/elite.tex
    cd $BASEDIR
}

function install_local {
    mkdir -p ${TEXMFHOME}/tex/latex/elite
    mkdir -p ${TEXMFHOME}/doc/latex/elite
    install -m 0644 ${BASEDIR}/build/elite.cls ${TEXMFHOME}/tex/latex/elite/elite.cls
	install -m 0644 ${BASEDIR}/build/docs/elite.pdf ${TEXMFHOME}/doc/latex/elite/elite.pdf
}

function install_global {
    mkdir -p ${TEXMFMAIN}/tex/latex/elite
    mkdir -p ${TEXMFMAIN}/doc/latex/elite
    install -m 0644 ${BASEDIR}/build/elite.cls ${TEXMFMAIN}/tex/latex/elite/elite.cls
	install -m 0644 ${BASEDIR}/build/docs/elite.pdf ${TEXMFMAIN}/doc/latex/elite/elite.pdf
}

#
# available procedures
#

function buildprocedure_clean {
    echo "> clean"
    clean_build_dir
}

function buildprocedure_build {
    echo "> build"
    assemble
}

function buildprocedure_docs {
    echo "> docs"
    build_docs
    build_docs
    build_docs
}

function buildprocedure_local {
    buildprocedure_build
    # buildprocedure_docs
    echo "> local"
    install_local
}

function buildprocedure_global {
    buildprocedure_build
    buildprocedure_docs
    echo "> global"
    install_global
}

function echo_help {
    echo "Usage: $BASENAME <procedure> [options]"
    echo ""
    echo "Available procedures:"
    echo "    clean   delete old build files"
    echo "    build   assemble the document class into a single file"
    echo "    docs    build the documentation PDF"
    echo "    local   run the build and docs procedures and install"
    echo "                the LaTeX files locally"
    echo "    global  run the build and docs procedures and install"
    echo "                the LaTeX files globally"
    echo ""
}

#
# build script
#

BASENAME=$(basename $0)
NO_COMMAND=1

for SUBCOMMAND in "${@:1}"
do
    NO_COMMAND=0
    case $SUBCOMMAND in
        "" | "-h" | "--help")
            echo_help
            ;;
        *)
            buildprocedure_${SUBCOMMAND}
            if [ $? = 127 ]; then
                echo "Error: '$SUBCOMMAND' is not a known build procedure." >&2
                echo "       Run '$BASENAME --help' for a list of known subcommands." >&2
                exit 1
            fi
            ;;
    esac
done

if [ $NO_COMMAND = 1 ]
then
    echo_help
fi

cd $ORIGINAL_WORKDIR