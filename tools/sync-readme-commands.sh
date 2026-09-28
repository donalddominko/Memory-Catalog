#!/usr/bin/env bash
# sync-readme-commands.sh — keep the README's command table identical to SPEC.md section 12.
#
# SPEC.md is the source of truth. The table sits between these two marker lines
# in both files:
#   <!-- commands:start -->
#   <!-- commands:end -->
#
#   tools/sync-readme-commands.sh           copy the table from SPEC.md into README.md
#   tools/sync-readme-commands.sh --check   exit 1 if README.md differs from SPEC.md
#
# Run from the repository root.

set -euo pipefail

spec=SPEC.md; readme=README.md
start='<!-- commands:start -->'; end='<!-- commands:end -->'

for f in "$spec" "$readme"; do
  [ -f "$f" ] || { echo "not found: $f (run from the repository root)" >&2; exit 2; }
  grep -qxF "$start" "$f" && grep -qxF "$end" "$f" || { echo "markers missing in $f" >&2; exit 2; }
done

block() { awk -v s="$start" -v e="$end" '$0==s{on=1;next} $0==e{on=0} on' "$1"; }

if [ "${1:-}" = "--check" ]; then
  if diff <(block "$spec") <(block "$readme") >/dev/null; then
    echo "in sync: README command table matches SPEC section 12"; exit 0
  fi
  echo "OUT OF SYNC: run tools/sync-readme-commands.sh" >&2
  diff <(block "$spec") <(block "$readme") >&2 || true
  exit 1
fi

tmp=$(mktemp)
awk -v s="$start" -v e="$end" -v src="$spec" '
  BEGIN { while ((getline line < src) > 0) { if (line==s) {on=1; continue} if (line==e) {on=0} if (on) tbl = tbl line "\n" } }
  $0==s { print; printf "%s", tbl; skip=1; next }
  $0==e { skip=0 }
  !skip { print }
' "$readme" > "$tmp"
mv "$tmp" "$readme"
echo "README command table updated from SPEC section 12"
