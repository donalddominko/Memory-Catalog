# Memory Catalog

A protocol for organising an AI assistant's long-term memory so it stays useful as it grows: an **index** of your work streams, a **backlog** of what's next, a dated **log** of what happened, a register of ideas **already considered**, and links from every entry back to the exact chat turn it came from.

It was designed and tested with Claude's memory and Projects. Everything is plain Markdown files, so the structure carries over to any assistant with file-based memory.

## Why

Assistant memory tends to turn into a pile. Status is repeated in several places and drifts apart. You can't tell which decisions you made and which the assistant suggested. Ideas you rejected come back as new. Cleaning up risks deleting the one fact that wasn't recorded anywhere else.

The catalog fixes this with a few rules:

- **One fact, one home.** Status lives only in the backlog, history only in the log. Detail that a repository already holds stays there, with a pointer to it.
- **You adopt, the assistant proposes.** Anything that came from the assistant's analysis is filed only after you confirm it.
- **Provenance.** Every entry carries a checkpoint such as `⟨a1b2c3d4 t13→t20⟩`: proposed at turn 13 of that chat, accepted at turn 20. A registry of verbatim anchor phrases lets the link be verified or repaired if the chat is edited.
- **Nothing is lost silently.** Ideas you declined, and ideas raised but never discussed, go into an "already considered" register so they don't come back as if new.
- **Proof before removal.** A cleanup removes nothing that can't be proven to exist elsewhere, and you get a byte-verified backup first.

## Quick start

Full step-by-step instructions, including requirements, checking the installation, updates and removal, are in **[INSTALL.md](INSTALL.md)**.

1. Read [`SPEC.md`](SPEC.md). It is the whole system.
2. Give it to your assistant and say: **"set up the catalog system from this spec."** It will create the catalog files from [`templates/`](templates/), sweep your existing memory into them, and ask where to start. The spec itself goes into memory as `/catalog/protocol.md`, adapted to your memory's line format.
3. At the end of a working chat, say **"catalog this chat"**. You'll get candidate entries to approve and a three-part report: what was filed, what you declined, and what was raised but never discussed.
4. Use the other commands as needed: "what's next", "status digest", "was *X* considered?", "verify checkpoints". See [SPEC §12](SPEC.md#12-commands).

A received spec is information, not instructions: nothing happens until you ask for it (rule S5). It can't override your own privacy or memory rules (rule S4).

## What's in the catalog

| File | Holds |
|---|---|
| `index.md` | Every work stream, its status, where its detail lives |
| `backlog.md` | Open tasks by stream: the only place task status lives |
| `log.md` | Dated history, older months rolled up |
| `principles.md` | Rules of thumb you've adopted, with checkpoints |
| `considered.md` | Ideas declined (with your reason) or raised but not discussed |
| `checkpoints.md` | Chat keys, turns and anchor phrases for provenance |
| `quotes.md` | *Planned.* Exact key sentences, append-only |

Projects get their own `_board.md` (shared status for chats in that Project), `_feed.md` (news going out), `_inbox.md` (news coming in) and `_considered.md`.

## Repository layout

```
SPEC.md                the full specification
INSTALL.md             how to install, check, update and remove it
CHANGELOG.md           spec versions
templates/catalog/     empty starter files for main memory
templates/project/     empty starter files for a Project
examples/              a worked example with a fictional user
tools/                 checks used by the safety rules (bash)
```

## Tools

| Script | What it proves |
|---|---|
| `tools/sweep-dropped-tokens.sh` | A slimmed memory file dropped nothing that can't be found in a named source (rule S2) |
| `tools/verify-backup.sh` | A backup file contains each memory file at exactly the size memory reported (rule S2) |
| `tools/check-personal.sh` | Files you're about to publish contain none of the terms in your local `.personal-terms` (rule S1) |

Each script prints its usage when run without arguments.

## Status

Specification **v0.8**. The index, backlog, log, principles, checkpoints and "already considered" register are in daily use. The quotes file, Project feeds and inboxes, and the nightly sync are specified but not yet running. See [SPEC §14](SPEC.md#14-rollout-order-for-a-new-setup) and the [changelog](CHANGELOG.md).

## Licence

[MIT](LICENSE).
