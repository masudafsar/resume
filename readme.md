# Resume (LaTeX)

[![Build](https://github.com/masudafsar/resume/actions/workflows/release.yml/badge.svg)](https://github.com/masudafsar/resume/actions/workflows/release.yml)
[![Release](https://img.shields.io/github/v/release/masudafsar/resume?sort=semver)](https://github.com/masudafsar/resume/releases)
[![Release Date](https://img.shields.io/github/release-date/masudafsar/resume)](https://github.com/masudafsar/resume/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Contributors](https://img.shields.io/github/contributors/masudafsar/resume)](https://github.com/masudafsar/resume/graphs/contributors)
[![Languages](https://img.shields.io/github/languages/top/masudafsar/resume)](https://github.com/masudafsar/resume)

This repository contains my LaTeX resume built with a custom class file and
multiple role variants.

## Files

- `src/variants/`: Resume variants (each `.tex` file is a build target)
- `src/variants/frontend.tex`: Frontend Developer resume
- `src/variants/software.tex`: Software Engineer resume
- `src/developercv.cls`: LaTeX class definition
- `dist/`: Build output directory

## Requirements

- Docker (uses `blang/latex` image)

## Build with Docker

Use the Docker image you already pulled to compile the PDF:

```bash
docker run --rm -v "$PWD":/work -w /work/src blang/latex \
  latexmk -pdf -output-directory=/work/dist variants/frontend.tex
```

Build the Software Engineer version:

```bash
docker run --rm -v "$PWD":/work -w /work/src blang/latex \
  latexmk -pdf -output-directory=/work/dist variants/software.tex
```

Build both versions at once:

```bash
docker run --rm -v "$PWD":/work -w /work/src blang/latex \
  latexmk -pdf -output-directory=/work/dist variants/frontend.tex variants/software.tex
```

The generated PDF will appear in `dist/`.

## Scripts (Recommended)

Run Docker-based convenience scripts:

```bash
./make build
./make build frontend
./make build software
./make watch
./make watch software
./make clean
```

## Watch and Auto-Build (Direct Docker)

Run a persistent build that rebuilds on file changes:

```bash
docker run --rm -v "$PWD":/work -w /work/src blang/latex \
  latexmk -pdf -pvc -interaction=nonstopmode -output-directory=/work/dist \
  variants/frontend.tex
```

Stop the watcher with `Ctrl+C`.
