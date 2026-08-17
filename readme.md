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
- `dist/` contains generated PDFs and auxiliary build files.

## Requirements

- Docker with a running daemon. The build uses the `blang/latex` image and pulls
  it automatically when it is not available locally.

## Build

The convenience script is the recommended way to build the resumes:

```bash
./make.sh build
```

Without a target, every `.tex` file in `src/variants/` is built. To build one
variant, pass its filename with or without the `.tex` extension:

```bash
./make.sh build frontend-engineer
./make.sh build software-engineer.tex
```

Generated PDFs are written to `dist/`.

## Watch for Changes

Watch and automatically rebuild every variant:

```bash
./make.sh watch
```

This starts one persistent Docker process per variant. A single variant can also
be watched explicitly:

```bash
./make.sh watch software-engineer
```

Stop the watcher with `Ctrl+C`. Remove generated output with:

```bash
./make.sh clean
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
all variants and attaches the PDFs from `dist/` to the corresponding release.
