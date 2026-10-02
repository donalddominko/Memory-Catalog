# Memory Catalog

A protocol for organising an AI assistant's long-term memory so it stays useful as it grows: an **index** of your work streams, a **backlog** of what's next, a dated **log** of what happened, a register of ideas **already considered**, and links from every entry back to the exact chat turn it came from.

If you find it useful, a ⭐ helps others discover it.

It was built on Claude's memory and Projects. Everything is plain Markdown, so the structure carries over to any assistant with file-based memory; Claude-specific parts are named as such in the spec.

## Why

Assistant memory tends to turn into a pile. Status is repeated in several places and drifts apart. You can't tell which decisions you made and which the assistant suggested. Ideas you rejected come back as new. Cleaning up risks deleting the one fact that wasn't recorded anywhere else.

The catalog is built on five principles:

- **One fact, one home.** Status lives only in the backlog, history only in the log. Detail that a repository already holds stays there, with a pointer to it. ([SPEC §3](SPEC.md#3-what-belongs-in-an-area-file-and-what-does-not), [§11](SPEC.md#11-keeping-memory-small))
- **You adopt, the assistant proposes.** Anything from the assistant's analysis is filed only after you confirm it. ([SPEC §5](SPEC.md#5-catalog-this-chat-step-by-step), the adoption gate)
- **Provenance.** Every entry carries a checkpoint such as `⟨a1b2c3d4 t13→t20⟩`: proposed at turn 13 of that chat, accepted at turn 20. Verbatim anchor phrases let the link be verified or repaired if the chat is edited. ([SPEC §6](SPEC.md#6-checkpoints-and-quotes))
- **Nothing is lost silently.** Ideas you declined, and ideas raised but never discussed, go into an "already considered" register so they don't come back as if new. ([SPEC §5a](SPEC.md#5a-the-already-considered-register))
- **Proof before removal.** A cleanup removes nothing that can't be proven to exist elsewhere, and you get a byte-verified backup first. (Safety rule S2, [SPEC §13](SPEC.md#13-safety-rules) and [§16](SPEC.md#16-formats-backup-cut-list-unverified-marker))

The five safety rules (S1–S5) that protect your data are in [SPEC §13](SPEC.md#13-safety-rules). New to the vocabulary? See [Terms, SPEC §0](SPEC.md#0-terms).

## Setting up

Requirements, checking the installation, updating and removal are in **[INSTALL.md](INSTALL.md)**. The short version:

**The catalog.** Open a new chat **outside any Project**, attach [`SPEC.md`](SPEC.md) and send:

> Set up the catalog system from this spec. Show me what you'll create before writing anything.

The assistant proposes the catalog files and how your existing memory is sorted into them, asks a few questions, and writes only after you approve. Check it worked with **status digest**.

**A Project board** (optional). Open a chat **inside** the Project and send:

> set up the board

Until the nightly sync exists, a board shares status only between chats of that Project. To bring a Project's news into your main catalog, say "read the *Project name* board and update the catalog" in a main chat. ([SPEC §7](SPEC.md#7-project-boards))

## Commands

Say these in plain words; exact wording doesn't matter. **Where:** MAIN = a chat outside any Project · PROJECT = a chat inside a Project · ANY = either. This table is copied from [SPEC §12](SPEC.md#12-commands), which is the source of truth.

<!-- commands:start -->
| Say | Where | What happens | You get back |
|---|---|---|---|
| **Set up the catalog system from this spec. Show me what you'll create before writing anything.** *(attach SPEC.md)* | MAIN | Stores the spec as `/catalog/protocol.md`, proposes the catalog files and how your existing memory is sorted into them, asks questions | A proposal, then the list of files created after you approve |
| **Update the catalog protocol to this version. Show me what changes before writing.** *(attach the new SPEC.md)* | MAIN | Compares with `/catalog/protocol.md` | The differences, then the update after you approve |
| **Delete the catalog files.** | MAIN | Whole-file deletion on explicit request (rule S2); a backup is offered first | Confirmation of what was deleted |
| **set up the board** | PROJECT | Creates `_board.md`, `_feed.md`, `_inbox.md`, `_considered.md` in that Project (section 7) | The list of files created |
| **export the catalog spec** | MAIN | Generates this document from the protocol (rule S1) | The file |
| **clean up** *file* / **slim** *area file* | MAIN | The rule S2 procedure (section 16) | A backup file and a cut list; nothing removed until you approve |
| **catalog this chat** | ANY | Section 5 (inside a Project it writes only that Project's files) | Candidates and questions, then the three-part report |
| **catalog my past chats** / **catalog chats about** *topic* | ANY | Section 5, one chat at a time; only reaches chats in the same scope | The same, per chat |
| **what's next** / **backlog for** *stream* | ANY | Reads the backlog | The matching task lines |
| **park** *task* / *task* **is done** / **drop** *task* | ANY | Status change + log line; "done" needs evidence (section 4) | Confirmation of the change |
| **status digest** | ANY | Reads the index and backlog | A plain text summary |
| **was** *idea* **considered?** / **what was left undiscussed about** *stream* | ANY | Reads the register | Matching lines with status and checkpoint |
| **verify checkpoints** | ANY | Section 6 | Each anchor's result |
| **read the** *Project name* **board and update the catalog** | MAIN | Brings a Project's news into main memory until the nightly sync exists (section 7) | Candidates, then the usual report |
<!-- commands:end -->

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

Alongside the catalog, each work stream has an **area file** (`/areas/<stream>.md`) holding its current state. Each Project gets `_board.md`, `_feed.md`, `_inbox.md` and `_considered.md`. Full reference: [SPEC §2](SPEC.md#2-the-files-and-who-writes-them).

## Repository layout

```
SPEC.md                the full specification (install this)
INSTALL.md             how to install, check, update and remove it; how to run the tools
CHANGELOG.md           spec versions
templates/catalog/     empty starter files for main memory
templates/project/     empty starter files for a Project
templates/area.md      empty starter file for a work stream
examples/              a worked example with a fictional user
tools/                 checks used by the safety rules (bash)
```

The tools prove that a cleanup lost nothing, that a backup is complete, and that nothing personal is published. What each proves: [SPEC §15](SPEC.md#15-tools-and-publishing). How to run them: [INSTALL.md](INSTALL.md#using-the-tools).

## Status

Specification **v0.11**. The index, backlog, log, principles, checkpoints and "already considered" register are in daily use. The quotes file, Project feeds and inboxes, and the nightly sync are specified but not yet running. See the [changelog](CHANGELOG.md).

## Support the project

If Memory Catalog is useful to you, please **leave a star ⭐** at the top of this page. It helps other people find the project and shows that it's worth continuing to develop.

## Licence

[MIT](LICENSE).
