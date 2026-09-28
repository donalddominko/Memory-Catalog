# Changelog

Specification versions. The version in `SPEC.md` always matches the protocol in use.

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
