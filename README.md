# DOC-Builder

This toolkit creates documents for the Swedish Internet Foundation Federated Services. Either run directly from shell or use Docker.

## Prerequisites
If necessary, edit the paths in the Makefile.

If running directly the following is needed:

- Pandoc >= 2.17.1.1
- XeLaTeX
- PDFtk
- Make

### Ubuntu
```
sudo apt-get install \
   build-essential \
   texlive-xetex \
   pdftk
```

Download pandoc deb: https://github.com/jgm/pandoc/releases

```
sudo dpkg -i $DEB
```

## The document

### Title Page

Edit title.dat and change the variables accordingly. The variables Status and Pages will be set automatic by make.

### Body

Edit the body.md file.

## Finalize the Document

If the prerequisites are already installed, use make, otherwise use Docker.

### Make

To create a draft document.
```
make draft
```

To create a final document
```
make final
```

To clean.
```
make clean
```

### Docker

Build image
```
docker build -t doc-builder .
```

To create a draft document.
```
docker run --rm -it -v "$(pwd):/workspace" --user $(id -u):$(id -g) doc-builder draft
```

To create a final document.
```
docker run --rm -it -v "$(pwd):/workspace" --user $(id -u):$(id -g) doc-builder final
```

To clean.
```
docker run --rm -it -v "$(pwd):/workspace" --user $(id -u):$(id -g) doc-builder clean
```
