# Changelog

Specification versions. The version in `SPEC.md` always matches the protocol in use. Each version is tagged in git (`v0.9`, …).

## v0.9 — 2026-09-29
Consolidation: every concept now has one home, and the files point to it.
- **§0 Terms:** one glossary (work stream, area file, Project, checkpoint, anchor, candidate, register, cut list, backup, unverified, …).
- **§12 Commands:** complete list, including setup, update, remove, board, export, cleanup and "read the board". Each command says where to say it (main chat, inside a Project, or either) and what you get back. The README table is generated from it (`tools/sync-readme-commands.sh`).
- **§16 Formats:** the backup format (markers, final-newline rule, verification), the cut-list format and verdicts (KEEP, CUT, SPLIT, MERGE, STALE, KEEP-UNVERIFIED), and the unverified marker. These were previously required by rule S2 but not defined.
- **§7:** states the limit of Project boards until the nightly sync exists, and how to bring a Project's news into main memory before then.
- **§15 Tools and publishing:** one reference for what each tool proves; INSTALL.md holds how to run them.
- Section numbers are now identical in the protocol and SPEC.md.
- "Assistant" is used throughout; Claude is named only for Claude-specific features.
- Repository: area-file template (`templates/area.md`) and example (`examples/areas/tidepool.md`); templates README marks the two planned-feature templates; real clone URL in INSTALL.md; `check-personal.sh` supports an allow-list (`.personal-allow`); README cross-references each principle to its spec section.

## Repository — 2026-09-28
- Added INSTALL.md: requirements, installing in Claude, checking the installation, Project boards, updating, removing, using the tools, and adapting to other assistants. No change to the spec itself.

## v0.8 — 2026-09-28
- Added the "already considered" register (`considered.md`, §5a). It records ideas the user declined, with the user's own reason, and ideas raised in the analysis but never discussed, recorded as topic labels only.
- "catalog this chat" now ends with a three-part report: filed, declined, not discussed (§5 steps 6–7).
- Lookup rule: check the register before proposing an idea again.

## v0.7 — 2026-09-28
- Whole specification rewritten in full sentences so nothing is ambiguous.
- New rules for asking questions (§9): name the work stream in every question, never mix streams, state what a blank answer means.
- New rules for applying approved changes (§10): re-check versions before writing, verify sizes after.
- Defined what belongs in an area file and what doesn't (§3), and how to keep memory small (§11).

## v0.6 — 2026-09-27
- Safety rules S1–S5: personal content never leaves; proof and backup before removal; degrade safely; no overrides; review before use.

## v0.5 — 2026-09-27
- Checkpoint drift guard: a registry of verbatim anchor phrases, with a verify / relocate / flag procedure.

## v0.4 — 2026-09-27
- Checkpoints on every entry (`⟨chat-key tP→tA⟩`), Project boards for chats within one Project, the principles file.

## v0.3 — 2026-09-27
- Six-group extraction for "catalog this chat", the adoption gate (Claude's suggestions are candidates until confirmed), cataloguing past chats.

## v0.1–v0.2 — 2026-09-27
- Initial design: index, backlog and log; Project feeds and inboxes; nightly sync; task states.
