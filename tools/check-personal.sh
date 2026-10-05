#!/usr/bin/env bash
# check-personal.sh — SPEC rule S1: nothing personal leaves.
#
# Scans every file under DIR (default: current folder) for the terms listed in
# a terms file (default: .personal-terms in DIR), one term per line, matched as
# whole words, case-insensitively. Lines starting with # are ignored.
# The terms file itself must never be committed (it is in .gitignore).
#
# Allowed strings: a match is ignored when its line contains a string listed in
# .personal-allow (one per line, committed), for example the project's own
# public repository URL.
#
# LICENSE and CLA.md are skipped: they name the author on purpose (copyright
# line; the party contributors grant rights to).
#
# Exit 0 = clean. Exit 1 = matches found (printed with file and line).

set -euo pipefail

dir=${1:-.}
terms=${2:-$dir/.personal-terms}
allow=$dir/.personal-allow

if [ ! -f "$terms" ]; then
  echo "no terms file at $terms — create it with one personal term per line" >&2
  echo "usage: $0 [DIR] [TERMS_FILE]" >&2
  exit 2
fi

patterns=$(mktemp); allowed=$(mktemp); trap 'rm -f "$patterns" "$allowed"' EXIT
grep -vE '^\s*(#|$)' "$terms" > "$patterns" || true
[ -s "$patterns" ] || { echo "terms file is empty: $terms" >&2; exit 2; }
[ -f "$allow" ] && grep -vE '^\s*(#|$)' "$allow" > "$allowed" || true

hits=$(grep -rniwF -f "$patterns" \
         --exclude-dir=.git --exclude=LICENSE --exclude=CLA.md \
         --exclude="$(basename "$terms")" --exclude=.personal-allow "$dir" || true)
if [ -s "$allowed" ] && [ -n "$hits" ]; then
  hits=$(printf '%s\n' "$hits" | grep -vF -f "$allowed" || true)
fi

if [ -n "$hits" ]; then
  printf '%s\n' "$hits"
  echo "personal terms found — remove them before committing" >&2
  exit 1
fi
echo "clean: no personal terms found in $dir"
