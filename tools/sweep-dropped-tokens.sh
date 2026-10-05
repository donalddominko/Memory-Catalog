#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright (C) 2026 Donald Dominko
#
# sweep-dropped-tokens.sh — SPEC rule S2 mechanical check.
#
# Lists every distinctive token (identifiers, numbers, dates, hashes, file
# names, CamelCase and ALL-CAPS words) that appears in OLD but not in NEW and
# cannot be found in any SOURCE (a file, a folder searched recursively, or a
# git repository whose commit messages are also searched).
#
# Empty output + exit 0  = nothing unproven was dropped.
# Any output   + exit 1  = review each token: restore it, or name where it lives.
#
# Matching is case-insensitive. Wording variants of a proven fact (for example
# "P1-P8" vs "P1–P8") show up as hits and need a human decision.

set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "usage: $0 OLD_FILE NEW_FILE SOURCE [SOURCE ...]" >&2
  echo "  SOURCE: a file or folder to search; git repos also have their commit messages searched" >&2
  exit 2
fi

old=$1; new=$2; shift 2
for f in "$old" "$new"; do [ -f "$f" ] || { echo "not a file: $f" >&2; exit 2; }; done

found_in_sources() {
  local t=$1 s
  for s in "${SOURCES[@]}"; do
    if [ -d "$s" ]; then
      grep -rqiF --exclude-dir=.git --exclude-dir=node_modules -- "$t" "$s" 2>/dev/null && return 0
      if git -C "$s" rev-parse --git-dir >/dev/null 2>&1; then
        # grep without -q reads all input: with -q, grep exits on the first match,
        # git log gets SIGPIPE, and pipefail turns a real match into a failure.
        git -C "$s" log --all --format='%h %s%n%b' 2>/dev/null | grep -iF -- "$t" >/dev/null && return 0
      fi
    elif [ -f "$s" ]; then
      grep -qiF -- "$t" "$s" && return 0
    fi
  done
  return 1
}

SOURCES=("$@")
hits=0
while IFS= read -r t; do
  grep -qiF -- "$t" "$new" && continue
  found_in_sources "$t" && continue
  echo "UNPROVEN-DROPPED: $t"
  hits=$((hits + 1))
done < <(
  grep -oE "[A-Za-z0-9_./:+~%£-]*[0-9_][A-Za-z0-9_./:+~%£-]*|[A-Z][a-z]+[A-Z][A-Za-z]+|\b[A-Z]{4,}\b" "$old" \
    | sed 's/[.,:;)]*$//' | awk 'length>=3' | sort -u
)

[ "$hits" -eq 0 ] && exit 0 || exit 1
