#!/usr/bin/env bash
# check-personal.sh — SPEC rule S1: nothing personal leaves.
#
# Scans every file under DIR (default: current folder) for the terms listed in
# a terms file (default: .personal-terms in DIR), one term per line, matched as
# whole words, case-insensitively. Lines starting with # are ignored.
# The terms file itself must never be committed (it is in .gitignore).
#
# LICENSE is skipped: its copyright line names the author on purpose.
#
# Exit 0 = clean. Exit 1 = matches found (printed with file and line).

set -euo pipefail

dir=${1:-.}
terms=${2:-$dir/.personal-terms}

if [ ! -f "$terms" ]; then
  echo "no terms file at $terms — create it with one personal term per line" >&2
  echo "usage: $0 [DIR] [TERMS_FILE]" >&2
  exit 2
fi

patterns=$(mktemp); trap 'rm -f "$patterns"' EXIT
grep -vE '^\s*(#|$)' "$terms" > "$patterns" || true
[ -s "$patterns" ] || { echo "terms file is empty: $terms" >&2; exit 2; }

if grep -rniwF -f "$patterns" \
     --exclude-dir=.git --exclude=LICENSE --exclude="$(basename "$terms")" "$dir"; then
  echo "personal terms found — remove them before committing" >&2
  exit 1
fi
echo "clean: no personal terms found in $dir"
