# `elite.cls` - LaTeX Document Class

This is a beginner-friendly document class designed to summarize lecture notes. This readme explains the build process, for the documentation, see `docs/`

# Build Instructions

First make sure you have `pdflatex` installed. The project is build by:
```
./build.sh clean build
```
In order to install the class locally, run:
```
./build.sh clean local
```
In order to install the class globally, run:
```
./build.sh clean global
```
Build the documentation
```sh
./build.sh docs
```
For help, just type:
```
./build.sh --help
```