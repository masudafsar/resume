# Resume (LaTeX)

This repository contains my LaTeX resume built with a custom class file.

## Files

- `src/Masud Afsar - Frontend Developer.tex`: Main resume source
- `src/developercv.cls`: LaTeX class definition
- `dist/`: Build output directory

## Build with Docker

Use the Docker image you already pulled to compile the PDF:

```bash
docker run --rm -v "$PWD":/work -w /work/src blang/latex \
  latexmk -pdf -output-directory=/work/dist "Masud Afsar - Frontend Developer.tex"
```

The generated PDF will appear in `dist/`.

## Watch and Auto-Build

Run a persistent build that rebuilds on file changes:

```bash
docker run --rm -v "$PWD":/work -w /work/src blang/latex \
  latexmk -pdf -pvc -interaction=nonstopmode -output-directory=/work/dist \
  "Masud Afsar - Frontend Developer.tex"
```

Stop the watcher with `Ctrl+C`.
