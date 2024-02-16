# DOC-Builder

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)

## Description

This toolkit is designed to generate documents for the Federated Services of the Swedish Internet Foundation. You can seamlessly execute it either directly from the shell or utilize Docker for added convenience.


## Prerequisites

If necessary, adjust paths in the Makefile.

When running directly, ensure the following prerequisites are met:

- Pandoc >= 2.17.1.1
- XeLaTeX
- PDFtk
- Make


### Ubuntu

Install the necessary packages using the following command:
```
sudo apt-get install \
   build-essential \
   texlive-xetex \
   pdftk
```

Download pandoc deb: [Pandoc Releases](https://github.com/jgm/pandoc/releases)

```
sudo dpkg -i $DEB
```


## Document Setup

Establish a dedicated workspace for the document by creating a folder:

```
mkdir -p ../doc-folder
```

### Title Page

Copy the title.dat.example file into the doc-folder and remove the .example extension:
```
cp title.dat.example ../doc-folder/title.dat
```

Proceed to edit the title.dat file, adjusting the variables as needed. Note that the variables Status and Pages will be automatically set by the make command, streamlining the document customization process.


### Body

Copy the body.md.example file into the doc-folder and remove the .example extension:
```
cp body.md.example ../doc-folder/body.md
```
Subsequently, edit the body.md file to tailor the document content according to your requirements.


## Finalizing the Document

If the prerequisites are already installed, use make, otherwise, use Docker.


### Make

To generate a draft document:
```
make DIR=../doc-folder
```

To generate the final document:
```
make DIR=../doc-folder final
```

To clean up and remove intermediate files:
```
make DIR=../doc-folder clean
```


### Docker

Initiate the image build process:
```
docker build -t doc-builder .
```

To generate a draft document:
```
docker run --rm -it -v "$(pwd):/workspace" --user $(id -u):$(id -g) doc-builder draft
```

To generate a final document.
```
docker run --rm -it -v "$(pwd):/workspace" --user $(id -u):$(id -g) doc-builder final
```

To clean up and remove intermediate files:
```
docker run --rm -it -v "$(pwd):/workspace" --user $(id -u):$(id -g) doc-builder clean
```
