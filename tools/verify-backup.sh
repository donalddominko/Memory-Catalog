#!/usr/bin/env bash
# verify-backup.sh — SPEC rule S2: prove a backup is complete before anything is removed.
#
# The backup file holds each memory file between marker lines:
#   ===== BEGIN /path/file.md =====
#   ...exact content...
#   ===== END /path/file.md =====
# For each PATH=BYTES pair given, the section's content (without the final
# newline added before the END marker) must be exactly BYTES long — the size
# memory reported when the file was read.
#
# Exit 0 = every section matches. Exit 1 = a section is missing or the wrong size.

set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: $0 BACKUP_FILE /path/one.md=BYTES [/path/two.md=BYTES ...]" >&2
  exit 2
fi

backup=$1; shift
[ -f "$backup" ] || { echo "not a file: $backup" >&2; exit 2; }

fail=0
for pair in "$@"; do
  path=${pair%=*}; want=${pair##*=}
  if ! grep -qxF "===== BEGIN $path =====" "$backup"; then
    echo "MISSING  $path"; fail=1; continue
  fi
  got=$(awk -v p="$path" '$0=="===== BEGIN " p " ====="{on=1;next} $0=="===== END " p " ====="{on=0} on' "$backup" | wc -c)
  got=$((got - 1))
  if [ "$got" -eq "$want" ]; then
    echo "OK       $path  $got bytes"
  else
    echo "MISMATCH $path  backup $got bytes, memory reported $want"; fail=1
  fi
done
exit "$fail"
