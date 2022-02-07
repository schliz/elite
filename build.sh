#!/bin/bash

ORIGINAL_WORKDIR=$(pwd)

# change directory to location of script
BASE_DIR=$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )
cd $BASE_DIR

TEXMFHOME=$(kpsewhich -var-value TEXMFHOME)
TEXMFMAIN=$(kpsewhich -var-value TEXMFMAIN)

SOURCE_DIR=$BASE_DIR/src
DOCS_SOURCE_DIR=$BASE_DIR/docs

BUILD_DIR=$BASE_DIR/build
BUILD_DOCS_DIR=$BUILD_DIR/docs

CLASS_NAME=elite
DOCS_SOURCE=$CLASS_NAME-docs-en.tex

function clean_build_dir {
    # try to remove and redirect error messages to /dev/null
    rm -r ./build/ 2> /dev/null
}

function assemble {
    mkdir -p $BUILD_DIR/
    echo -n "" > $BUILD_DIR/$CLASS_NAME.cls

    if [ $GITHUB_SHA ]
    then
        echo "% Auto-built by GitHub Actions" >> $BUILD_DIR/$CLASS_NAME.cls
        echo "% Latest Commit-Hash: $GITHUB_SHA" >> $BUILD_DIR/$CLASS_NAME.cls
    fi

    cd $SOURCE_DIR/
    for STYFILE in *.sty
    do
        STYCONTENT=$(cat ${STYFILE})  
        echo_safe_filecontents $STYFILE "$STYCONTENT"
    done
    cd $BASE_DIR

    echo "" >> $BUILD_DIR/$CLASS_NAME.cls
    echo $CLASS_NAME
    cat $SOURCE_DIR/$CLASS_NAME.cls >> $BUILD_DIR/$CLASS_NAME.cls
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
#" >> $BUILD_DIR/${CLASS_NAME}.cls

    echo "%
% External File: $FILENAME
%
\begin{filecontents}[overwrite]{$FILENAME}
$FILECONTENTS
\end{filecontents}
" >> $BUILD_DIR/$CLASS_NAME.cls
}

function build_docs {
    mkdir -p $BUILD_DOCS_DIR/
    cd $DOCS_SOURCE_DIR
    # pdflatex -halt-on-error -output-directory $BUILD_DOCS_DIR -jobname $CLASS_NAME $DOCS_SOURCE_DIR/$DOCS_SOURCE
    latexmk -pdf -halt-on-error --jobname=$CLASS_NAME --output-directory=$BUILD_DOCS_DIR $DOCS_SOURCE_DIR/$DOCS_SOURCE
    cd $BUILD_DOCS_DIR
    _temp=$(makeindex *.idx)
    cd $BASE_DIR
}

function install_local {
    mkdir -p ${TEXMFHOME}/tex/latex/$CLASS_NAME
    install -m 0644 ${BASE_DIR}/build/$CLASS_NAME.cls $TEXMFHOME/tex/latex/$CLASS_NAME/$CLASS_NAME.cls
}

function install_docs_local {
    mkdir -p ${TEXMFHOME}/doc/latex/$CLASS_NAME
	install -m 0644 ${BASE_DIR}/build/docs/$CLASS_NAME.pdf ${TEXMFHOME}/doc/latex/$CLASS_NAME/$CLASS_NAME.pdf
}

function install_global {
    mkdir -p ${TEXMFMAIN}/tex/latex/$CLASS_NAME
    install -m 0644 ${BASE_DIR}/build/$CLASS_NAME.cls ${TEXMFMAIN}/tex/latex/$CLASS_NAME/$CLASS_NAME.cls
}

function install_docs_global {
    mkdir -p ${TEXMFMAIN}/doc/latex/$CLASS_NAME
	install -m 0644 ${BASE_DIR}/build/docs/$CLASS_NAME.pdf ${TEXMFMAIN}/doc/latex/$CLASS_NAME/$CLASS_NAME.pdf
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
    # perform twice to create correct index
    build_docs
    build_docs
}

function buildprocedure_local {
    buildprocedure_build
    echo "> local"
    install_local
    buildprocedure_docs
    install_docs_local
}

function buildprocedure_global {
    buildprocedure_build
    echo "> global"
    install_global
    buildprocedure_docs
    install_docs_global
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
            buildprocedure_$SUBCOMMAND
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