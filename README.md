# doc-builder

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)

## Description

This toolkit generates PDF documents from Markdown using Pandoc and a LaTeX
template. It is used to produce technical profiles and specifications for the
Federated Services of The Swedish Internet Foundation, but can be used for
similar documents in other contexts.

You can run it directly with `make` or via Docker.

## Prerequisites for local use

These prerequisites apply only when running doc-builder directly on the host.
They are not required when using the Docker image.

If necessary, adjust paths in the `Makefile`.

When running directly (without Docker), ensure the following are installed:

- Pandoc >= 3.1.12-1
- A TeX distribution with `xelatex` available in `$PATH`

Download the Pandoc `.deb` from:

- <https://github.com/jgm/pandoc/releases>

Install it with:

```sh
sudo dpkg -i pandoc-VERSION-1-amd64.deb
````

Install a TeX distribution, for example:

```sh
sudo apt install texlive-xetex
```

## Document setup

You can either:

* author directly in the `doc-builder` folder, or
* keep the authored document in a separate folder or repository.

Below is an example using a separate folder one level up.

Create a folder for the document:

```sh
mkdir -p ../doc-folder
```

### Metadata

Copy the example metadata file and edit it:

```sh
cp metadata.yaml.example ../doc-folder/metadata.yaml
```

Edit `../doc-folder/metadata.yaml` and adjust the fields as needed. The `date`
field can use `\today` if you want the build date to be inserted automatically.

### Body

Copy the example body file and edit it:

```sh
cp body.md.example ../doc-folder/profile.md
```

Edit `../doc-folder/profile.md` to define the actual content of your document.

## Building the document

If the prerequisites are installed locally, you can use `make`. Otherwise, use
Docker.

### Make

The default target is `draft`. Running `make` without arguments will build a
draft PDF.

#### Using an external document folder

If the source document and metadata live in another folder (for example
`../doc-folder/profile.md` and `../doc-folder/metadata.yaml`), you point `make` to
them using `SRC_BODY` and `SRC_METADATA`.

Draft build with external sources:

```sh
make \
  SRC_BODY="../doc-folder/profile.md" \
  SRC_METADATA="../doc-folder/metadata.yaml"
```

Final build with external sources, writing the PDF to `../doc-folder`:

```sh
make final \
  DIR=../doc-folder \
  SRC_BODY="../doc-folder/profile.md" \
  SRC_METADATA="../doc-folder/metadata.yaml"
```

#### Authoring directly in the doc-builder repo

If `body.md` and `metadata.yaml` are already present in the current directory,
because you author directly in the `doc-builder` repo, you can build without
setting any extra variables. In this case, PDFs are written to the current
directory by default.

Generate a draft document in the current directory:

```sh
make
```

Generate the final document in the current directory:

```sh
make final
```

If you want the PDF to be written somewhere else, override `DIR`:

```sh
make final DIR=../doc-folder
```

Clean up generated PDFs in the current directory:

```sh
make clean
```

### Docker

The Docker image bundles Pandoc and the required TeX tooling. You do not need
Pandoc or TeX installed locally when using Docker.

Build the image:

```sh
docker build -t doc-builder .
```

#### Simple usage (document and Makefile in the same directory)

If your `body.md`, `metadata.yaml`, `Makefile`, `template.tex` and other support
files are all in the current directory, you can build directly from there.

Draft PDF:

```sh
docker run --rm -it \
  -v "$(pwd):/workspace" \
  --user "$(id -u):$(id -g)" \
  doc-builder draft
````

Final PDF:

```sh
docker run --rm -it \
  -v "$(pwd):/workspace" \
  --user "$(id -u):$(id -g)" \
  doc-builder final
```

Inside the container, `/workspace` corresponds to the current directory on the
host, and the generated PDF is written there.

#### Using a separate document repository

If you keep the doc-builder framework in one repository and the authored
document in another, mount both and use `SRC_BODY` and `SRC_METADATA` to point
`make` at the authored files.

Example layout on the host:

```text
/path/to/doc-builder   # this repo, with Dockerfile, Makefile, template, etc.
/path/to/doc-source    # your authored document repo
  profile.md
  metadata.yaml
```

Run:

```sh
docker run --rm -it \
  -v "/path/to/doc-builder:/workspace" \
  -v "/path/to/doc-source:/src" \
  --user "$(id -u):$(id -g)" \
  doc-builder \
  draft \
    SRC_BODY="/src/profile.md" \
    SRC_METADATA="/src/metadata.yaml" \
    DIR="/src"
```

The resulting PDF is written to `/path/to/doc-source` on the host.

For a final PDF, replace `draft` with `final`:

```sh
docker run --rm -it \
  -v "/path/to/doc-builder:/workspace" \
  -v "/path/to/doc-source:/src" \
  --user "$(id -u):$(id -g)" \
  doc-builder \
  final \
    SRC_BODY="/src/profile.md" \
    SRC_METADATA="/src/metadata.yaml" \
    DIR="/src"
```
