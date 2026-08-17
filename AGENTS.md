# Repository Guidelines

## Project Structure & Module Organization

This repository builds role-specific resumes from shared LaTeX components.

- `src/variants/` contains the build entry points, such as `frontend-engineer.tex` and `software-engineer.tex`.
- `src/sections/shared/` holds reusable education, language, and experience content. Individual jobs live in `src/sections/shared/experience/` and use a numeric prefix to control display order.
- `src/sections/frontend/` and `src/sections/software/` contain role-specific headers and skill summaries.
- `src/developercv.cls` defines the document class; `src/libs/` contains its focused style modules.
- `dist/` is generated build output and should not be edited by hand.

## Build, Test, and Development Commands

Make, Bash, Docker, and the `blang/latex` image are required.

- `make build` compiles every file in `src/variants/` into `dist/`.
- `make build TARGET=frontend-engineer` builds one named variant.
- `make watch TARGET=software-engineer` continuously rebuilds the required target; stop it with `Ctrl+C`.
- Add `NO_OPEN=1` to `build` or `watch` in CI and other non-interactive environments.
- `make list` lists the accepted target names.
- `make clean` removes generated files from `dist/`.

There is no separate automated test suite. Treat a clean build of both variants as the required validation before submitting changes. Review the resulting PDFs for overflow, awkward page breaks, broken links, and inconsistent spacing.

## Coding Style & Naming Conventions

Use four-space indentation inside LaTeX environments and keep one sentence or `\item` per line. Follow the existing lowercase, kebab-case filenames (`summary_skills.tex`, `frontend-engineer.tex`). Keep reusable presentation logic in `src/libs/`, shared resume facts in `sections/shared/`, and variant-only content in its role directory. Add experience files with the next three-digit prefix, then include them explicitly in `experience.tex` in newest-first order.

## Commit & Pull Request Guidelines

Recent history follows short, imperative Conventional Commit-style subjects, including `feat:`, `fix:`, `refactor:`, `style:`, `docs:`, and `chore:`. Keep commits focused; for example, `fix: correct frontend experience dates`.

Pull requests should summarize the content or layout change, identify affected variants, and report the build command used. Include before/after PDF screenshots for visual changes and link relevant issues when applicable. Do not commit LaTeX auxiliary files or generated PDFs unless a release workflow explicitly requires them.

## Release Notes

Tags matching `v*` trigger `.github/workflows/release.yml`, which builds all variants and attaches `dist/*.pdf` to the GitHub release. Verify both PDFs locally before creating a release tag.
