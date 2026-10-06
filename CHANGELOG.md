# Changelog

Specification versions. The version in `SPEC.md` always matches the protocol in use. Each version is tagged in git (`v0.9`, …).

## v0.15 — 2026-10-07
- **§5, step 3 and §5a:** alternatives the user turned down are filed without approval, as rejected alternatives in the area file and declined lines in the register, and are still shown in the step 7 report. Options the user never responded to stay "not discussed".

## Repository — 2026-10-06
- Added `NOTICE`: copyright notice and an express reservation of text-and-data-mining rights, including AI training (Article 4(3) of Directive (EU) 2019/790 and equivalents). Such use is permitted only under the applicable licence or a separate licence; the notice does not restrict any right the licences grant. No change to the spec itself.

## Repository — 2026-10-05
- **Licence change.** Code (`tools/`, `.github/`) is now AGPL-3.0-only (`LICENSE`); documentation is CC BY-SA 4.0 (`LICENSE-DOCS`); templates and examples are CC0 1.0 (`LICENSE-TEMPLATES`). Commercial licences for the code are available. Everything up to and including commit `e32b809` (spec v0.14) remains available under MIT. No change to the spec itself.
- Added `CLA.md` (contributor licence agreement), its signing workflow (`.github/workflows/cla.yml`) and `CONTRIBUTING.md`. Pull requests are currently closed; suggestions go through issues.
- `check-personal.sh` skips `CLA.md`, which names the author on purpose, as `LICENSE` did.

## v0.14 — 2026-10-04
- **§18, step E:** a second check, the source check. A candidate that states the current state of something kept elsewhere (a risk in code, completed work, a setting, a number) is checked against that source at its latest commit, not only against the chat. Results: CONFIRMED, FIXED LATER, REFUTED, PARTLY, NOT CHECKABLE. Fixed-later items are filed as history, refuted ones are left out, and a report must say which candidates were not checked.
- **§5, step 3:** pointer to the source check.

## v0.13 — 2026-10-04
- **§18 Bulk cataloguing of past chats:** inventory, then triage (catalogue now, later, or drop; dropped chats go into the register), then a mode chosen by a threshold (interactive for a chat up to about 50 turns and a batch under 3; background otherwise). Unattended runs only produce candidates; only candidates whose anchors are verified are put forward; the adoption gate and the three-part report still apply.
- **§5 and §12:** pointers to §18.

## v0.12 — 2026-10-02
- **§9:** when the user does not know which option is better, the assistant presents the trade-offs of each option and a recommendation before asking for a decision.
- **§17:** check tool caps before launching helpers; the cap differs by provider (the Claude-specific figure is marked as such).

## v0.11 — 2026-10-02
- **§17 Working with helper agents:** right-size the model per task, record progress durably with a resume marker, and keep batches small. At most about three helpers that use a chat-reading tool run at once.

## v0.10 — 2026-10-01
Not released on its own: these changes were first published in v0.11.
- Added §17 (helper agents): choose the model by task, never launch many expensive-model helpers at once, and have each helper record progress to a notes file so an interrupted session loses nothing. Superseded by v0.11, which adds the limit on parallel chat-reading helpers.

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
