# LaTeX Resume

[![Build](https://github.com/masudafsar/resume/actions/workflows/release.yml/badge.svg)](https://github.com/masudafsar/resume/actions/workflows/release.yml)
[![Release](https://img.shields.io/github/v/release/masudafsar/resume?sort=semver)](https://github.com/masudafsar/resume/releases)
[![Release Date](https://img.shields.io/github/release-date/masudafsar/resume)](https://github.com/masudafsar/resume/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Contributors](https://img.shields.io/github/contributors/masudafsar/resume)](https://github.com/masudafsar/resume/graphs/contributors)
[![Languages](https://img.shields.io/github/languages/top/masudafsar/resume)](https://github.com/masudafsar/resume)

This repository contains role-specific versions of my resume, built from shared
LaTeX sections and a custom document class. The layout is based on the Developer
CV template.

## Available PDFs

- [Frontend Engineer](https://github.com/masudafsar/resume/releases/latest/download/frontend-engineer.pdf)
- [Software Engineer](https://github.com/masudafsar/resume/releases/latest/download/software-engineer.pdf)

## Project Structure

- `src/variants/` contains the build entry points.
- `src/sections/shared/` contains experience, education, and language sections
  used by every variant.
- `src/sections/frontend/` and `src/sections/software/` contain role-specific
  headers and skill summaries.
- `src/developercv.cls` and `src/libs/` define the document layout and reusable
  LaTeX commands.
- `Makefile` provides build, watch, target-listing, and cleanup commands.
- `dist/` contains generated PDFs and auxiliary build files.

## Requirements

- Make and Bash.
- Docker with a running daemon. The build uses the `blang/latex` image and pulls
  it automatically when it is not available locally.

## Build

The Makefile is the recommended way to build the resumes:

```bash
make build
```

Without a target, every `.tex` file in `src/variants/` is built. To build one
variant, set `TARGET` to its filename with or without the `.tex` extension:

```bash
make build TARGET=frontend-engineer
make build TARGET=software-engineer.tex
```

Generated PDFs are written to `dist/`.
By default, each generated PDF is opened with the system PDF viewer after a
successful build. Disable this behavior for CI or non-interactive environments:

```bash
make build NO_OPEN=1
```

## Watch for Changes

Watching requires an explicit target:

```bash
make watch TARGET=software-engineer
```

The selected PDF is built and opened before watching begins. To watch without
opening the PDF, use `make watch TARGET=software-engineer NO_OPEN=1`.

If `TARGET` is omitted or invalid, Make prints the available targets without
starting Docker. You can also list them directly:

```bash
make list
```

Stop the watcher with `Ctrl+C`. Remove generated output with:

```bash
make clean
```

## Direct Docker Usage

To run `latexmk` without the helper script:

```bash
docker run --rm -v "$PWD":/work -w /work/src blang/latex \
  latexmk -pdf -output-directory=/work/dist \
  variants/frontend-engineer.tex
```

## Releases

Pushing a tag matching `v*` runs the GitHub Actions release workflow. It builds
all variants with `NO_OPEN=1` and attaches the PDFs from `dist/` to the
corresponding release.
