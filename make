#!/usr/bin/env bash
set -euo pipefail

IMAGE="blang/latex"
WORKDIR="/work/src"
OUTDIR="/work/dist"
VARIANTS_DIR="src/variants"

usage() {
  cat <<'EOF'
Usage: scripts/resume.sh <command> [target]

Commands:
  build            Build both variants
  watch            Watch and auto-build (default: frontend)
  clean            Remove files from dist/

Targets for watch/build:
  Any .tex file in ${VARIANTS_DIR} (name without extension or full filename)
EOF
}

build_one() {
  local target="$1"
  docker run --rm -v "$PWD":/work -w "$WORKDIR" "$IMAGE" \
    latexmk -pdf -output-directory="$OUTDIR" "variants/${target}.tex"
}

resolve_targets() {
  local target="${1:-}"
  if [[ -n "$target" ]]; then
  if [[ -f "${VARIANTS_DIR}/$target" ]]; then
    printf '%s\n' "variants/$target"
    return 0
  fi
  if [[ -f "${VARIANTS_DIR}/${target}.tex" ]]; then
    printf '%s\n' "variants/${target}.tex"
    return 0
  fi
    return 1
  fi

  shopt -s nullglob
  local files=("${VARIANTS_DIR}"/*.tex)
  shopt -u nullglob
  if (( ${#files[@]} == 0 )); then
    return 2
  fi
  local file
  for file in "${files[@]}"; do
    printf '%s\n' "variants/$(basename "$file")"
  done
}

read_targets() {
  local target="${1:-}"
  local -a out=()
  while IFS= read -r line; do
    out+=("$line")
  done < <(resolve_targets "$target") || return 1

  if (( ${#out[@]} == 0 )); then
    return 1
  fi

  TARGETS=("${out[@]}")
}

case "${1:-}" in
  build)
    read_targets "${2:-}" || {
      usage
      exit 1
    }
    docker run --rm -v "$PWD":/work -w "$WORKDIR" "$IMAGE" \
      latexmk -pdf -output-directory="$OUTDIR" "${TARGETS[@]}"
    ;;
  watch)
    read_targets "${2:-}" || {
      usage
      exit 1
    }
    if (( ${#TARGETS[@]} == 1 )); then
      docker run --rm -v "$PWD":/work -w "$WORKDIR" "$IMAGE" \
        latexmk -pdf -pvc -interaction=nonstopmode -output-directory="$OUTDIR" \
        "${TARGETS[0]}"
    else
      pids=()
      for target in "${TARGETS[@]}"; do
        docker run --rm -v "$PWD":/work -w "$WORKDIR" "$IMAGE" \
          latexmk -pdf -pvc -interaction=nonstopmode -output-directory="$OUTDIR" \
          "$target" &
        pids+=("$!")
      done

      trap 'for pid in "${pids[@]}"; do kill "$pid" 2>/dev/null || true; done' INT TERM
      wait
    fi
    ;;
  clean)
    rm -f dist/*
    ;;
  *)
    usage
    exit 1
    ;;
esac
