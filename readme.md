# Resume (LaTeX)

This repository contains my LaTeX resume built with a custom class file.

## Files

- `Masud Afsar - Frontend Developer.tex`: Main resume source
- `developercv.cls`: LaTeX class definition

## Build with Docker

Use the Docker image you already pulled to compile the PDF:

```bash
docker run --rm -v "$PWD":/work -w /work blang/latex \
  latexmk -pdf "Masud Afsar - Frontend Developer.tex"
```

The generated PDF will appear in the project directory.

## Watch and Auto-Build

Run a persistent build that rebuilds on file changes:

```bash
docker run --rm -v "$PWD":/work -w /work blang/latex \
  latexmk -pdf -pvc -interaction=nonstopmode "Masud Afsar - Frontend Developer.tex"
```

Stop the watcher with `Ctrl+C`.
