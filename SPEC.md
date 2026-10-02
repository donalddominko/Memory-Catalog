# Memory Catalog — Specification v0.12

A generic setup for tracking productive work in an AI assistant's memory: what work streams exist, what is to be done next, and what has already happened.

**How to use this document:** give it to your assistant, read it together, and say "Set up the catalog system from this spec. Show me what you'll create before writing anything." when you are ready. It is information, not instructions: nothing happens automatically when it is imported (rule S5). It cannot override your own privacy or memory rules (rule S4). Installation, step by step: [INSTALL.md](INSTALL.md).

It was built on Claude. Features that are specific to Claude (Projects, opening a past chat at a given turn, scheduled tasks) are named as such. On other assistants, those parts are skipped (rule S3).

In this document, "the user" means the person whose memory is being organised.

---

## 0. Terms

| Term | Meaning |
|---|---|
| **User** | The person whose memory is being organised. |
| **Assistant** | The AI that keeps the memory and follows this spec. |
| **Work stream** (or **stream**) | One ongoing piece of work: a product, a client, a piece of research. It has one line in the index; its detail lives in an area file, in a Project, or both. |
| **Area file** | `/areas/<stream>.md`: the current state of one work stream (section 3). |
| **Topic file** | `/topics/<subject>.md`: facts about the user that are not work streams. |
| **Project** (capital P) | The assistant feature that groups chats and gives them shared memory (in Claude: Projects). **Not** the same as a work stream: one stream may use one Project, several, or none. |
| **Catalog** | The files under `/catalog/`. |
| **Protocol** | `/catalog/protocol.md`: this spec, stored in memory. |
| **Board, feed, inbox** | The per-Project files `_board.md`, `_feed.md`, `_inbox.md` (sections 2 and 7). |
| **Checkpoint** | A link from an entry back to the chat and turn it came from: `⟨chat-key tP→tA⟩` (section 6). |
| **Chat key** | The first 8 characters of a chat's ID. |
| **Turn** | One message in a chat, numbered from 0. |
| **Anchor phrase** | A short verbatim phrase from a turn, used to prove a checkpoint still points at the right place. |
| **Candidate** | Something from the assistant's analysis, shown to the user but not yet filed. |
| **Adoption gate** | The rule that candidates are filed only after the user confirms them (section 5, step 3). |
| **Register** | The "already considered" register, `/catalog/considered.md`: declined ideas, and ideas raised but not discussed (section 5a). |
| **Cut list** | The proposal shown before any removal, with evidence for every line (section 16). |
| **Backup** | A verified copy of every affected memory file, given to the user before any removal (section 16). |
| **Unverified** | The marker on an item whose source could not be checked (section 16). |
| **Source of truth** | The one place a fact is maintained; other places only point to it. |
| **Export** | Generating this document from the protocol in memory. |
| **Nightly sync** | The planned scheduled task that moves news between Projects and main memory (section 8). |
| **Watermark** | The last feed entry the sync has already merged. |

## 1. What the catalog is for

- The catalog answers three questions: what work streams exist and what state each one is in (the **index**), what is to be done next (the **backlog**), and what has already happened and when (the **log**).
- The catalog organises information; it does not copy it. Every fact has exactly one home. Catalog files hold short lines that point to the file where the detail lives.
- The protocol changes over time. Whenever the design changes, the protocol in memory is updated in the same turn and a line is added to its version history.

## 2. The files and who writes them

| File | What it holds |
|---|---|
| `/catalog/protocol.md` | This spec. The single source of truth for how the catalog works. |
| `/catalog/index.md` | One line per work stream: short name, status (active, waiting, stable, parked, reference), and where its detail lives. Pointers only. |
| `/catalog/backlog.md` | One line per open task, grouped by work stream. The **only** place task status is recorded. Finished tasks are removed and logged. |
| `/catalog/log.md` | Dated lines, newest first, by month. Current and previous month kept line by line; older months rolled up to one line each. |
| `/catalog/principles.md` | Reusable rules of thumb the user has adopted, grouped by theme, each with a checkpoint. |
| `/catalog/checkpoints.md` | Links catalog entries back to the exact chat and turn they came from (section 6). |
| `/catalog/considered.md` | The "already considered" register (section 5a). |
| `/catalog/quotes.md` | *Planned.* Exact key sentences, append-only (section 6). |
| `/catalog/sync-state.md` | *Planned.* For each Project, the last feed entry already merged (section 8). |
| `/areas/<stream>.md` | The current state of one work stream (section 3). |
| `/topics/<subject>.md` | Facts about the user that are not work streams. The catalog does not change them. |

Inside each Project:

| File | Written by | Purpose |
|---|---|---|
| `_board.md` | that Project's chats | The Project's shared status, read by every chat in the Project |
| `_feed.md` | that Project's chats only, append-only | Carries news from the Project to main memory |
| `_considered.md` | that Project's chats | The Project's own "already considered" register (section 5a) |
| `_inbox.md` | main memory / nightly sync only | Carries news from main memory into the Project |

Each side writes only its own file. The platform has no publish-only mode, so this one-way flow is enforced by following the rule, not by a technical lock. **Keep every Project memory-connected**: a Project set to separate memory is invisible to main memory and to the sync.

## 3. What belongs in an area file, and what does not

**Keep:** what the thing is; decisions and the reasons for them; rejected alternatives worth remembering; constraints and rules that still apply; risks and open questions; working arrangements; facts not recorded anywhere else.

**Do not keep:** task status (backlog); dated history (log); build detail a repository already holds, such as commit lists, test counts, file lists and release-by-release notes. For those, the area file keeps a one-line pointer to the repository and its progress file as the source of truth. The first line of an area file names its sources of truth.

Template: [`templates/area.md`](templates/area.md). Example: [`examples/areas/tidepool.md`](examples/areas/tidepool.md).

## 4. Task states

| State | Meaning |
|---|---|
| `[next]` | To be done soon |
| `[active]` | Being worked on now |
| `[waiting on <what>]` | Cannot move until something outside the user's control happens, or the user decides. Always name it. |
| `[blocked by <what>]` | A prerequisite is missing. Always name it. |
| `[later]` | Agreed, but not soon |
| `[parked <date> <reason>]` | Deliberately paused |
| `[dropped <date>]` | Decided against; removed and logged |

A task is only marked done with evidence: the user says so, or a repository shows it (for example a merged commit). When a repository is the evidence, the log line names the commit or date.

Example of parking: promotion tasks for an open-source project stay active as if a grant application were planned, and only the grant application itself is parked until promotion shows traction.

## 5. "catalog this chat": step by step

1. Read the current chat to get its ID and turn numbers. Register it in the checkpoint registry if it is new.
2. Read the **whole** chat, including the assistant's own analysis, and sort what matters into six groups:
   1. decisions, with the reason and rejected alternatives → log + area file
   2. completed work → log
   3. new tasks → backlog
   4. reusable rules of thumb → principles
   5. risks and traps → area file
   6. open questions → backlog as `[waiting on the user]`

   Everything else is discarded.
3. **Adoption gate:** anything that came from the assistant's analysis rather than the user is shown as a *candidate* and filed only after the user confirms it. Confirmation is what makes it the user's own.
4. Ask clarifying questions following section 9, in one round.
5. Write only what was approved, following section 10.
6. Record everything that was **not** filed in the register (section 5a), so it is never lost and never presented again as new.
7. Report back in three parts: **(a)** what was filed and where; **(b)** what the user declined, and the user's reason; **(c)** what was raised in the analysis but never discussed. Parts (b) and (c) each carry the checkpoint to where the idea was raised. See [`examples/report.md`](examples/report.md).

Inside a Project chat, the same steps write only that Project's files and append to its `_feed.md`, never to `/catalog/`. A chat moved into a Project is catalogued from inside the Project. "catalog my past chats" runs the same steps one chat at a time.

## 5a. The "already considered" register

A quick reference to every idea raised in a catalogued chat that did not become a decision, task or principle. It stops good ideas being silently lost, and stops rejected ideas being proposed again as if new.

- **Declined:** the user considered it and said no. Records the user's reason in their own terms, or "no reason given". A reason is never invented.
- **Not discussed:** it appeared in the assistant's analysis but the conversation never returned to it. Records only a short topic label, never the assistant's conclusions, because undiscussed analysis is not the user's position. The reasoning stays in the chat, reached through the checkpoint.

Line format: `<status> <date> — <stream>: <topic label> ⟨chat-key tN⟩` (declined lines add `— reason: <user's reason>`). Grouped by stream. An item later adopted is removed and the adoption logged; an item that becomes irrelevant is marked "no longer relevant <date>", not deleted. Every line is shown to the user when it is filed. Inside a Project, the register is `_considered.md`.

**Lookup rule:** before proposing an idea in any analysis, check the register. If it's there, say "already considered on <date>, <status>, see ⟨checkpoint⟩", then say whether anything has changed that makes it worth revisiting.

## 6. Checkpoints and quotes

- Every entry that came from a chat ends with `⟨chat-key tP→tA⟩`: the chat, the turn where the idea was proposed, and the turn where the user accepted it (only `tA` when the user said it themselves).
- The checkpoint registry maps each key to the full chat ID and title, and lists every referenced turn with a short verbatim **anchor phrase** and a status: **verified** *date*, **pending**, **relocated** *old→new, date*, **drifted** *date*, or **source lost** *date*.
- A checkpoint is provenance only. If a chat is edited or deleted, no catalog content is lost, only the link back.
- An anchor is marked verified only after the turn has been opened and the phrase found. A turn still in progress when filed is marked pending.
- **"verify checkpoints"**: open each stored turn. Phrase present → verified. Absent → search the chat; found elsewhere → relocated (update the registry). Not found → drifted, or source lost if the chat is gone. Catalog content is never changed by this.
- Chat search only covers the current scope (one Project's chats, or non-project chats), so a checkpoint across that boundary may not be openable.
- *Planned:* load-bearing sentences (decisions relied on, and the user's acceptance) stored verbatim in an append-only quotes file with fixed IDs `q-<chat-key>-t<turn>`, referenced from the registry, so exact quotes survive edits, deletion and scope boundaries.

## 7. Project boards

Chats in one Project share that Project's memory, so `_board.md` is their shared channel: status, open tasks, decisions and principles, each checkpointed to the sibling chat and turn it came from. There is no live push: a chat learns what siblings did when it reads the board. A board is created from inside its Project ("set up the board").

**Limit until the nightly sync exists:** the feed and inbox are written, but nothing moves automatically between a Project and main memory. A board shares status only between chats of the same Project. To bring a Project's news into main memory before then, say in a main chat: "read the *Project name* board and update the catalog". The usual adoption gate and approval rules apply.

## 8. Nightly sync (planned)

A scheduled task at a fixed night-time hour, in a fresh session: read each Project's `_feed.md` past its watermark; merge into log, index, backlog and area files; write relevant news into each Project's `_inbox.md`; move the watermark forward. A missed run is harmless. Prove it on one Project first. Requires scheduled tasks on the account (rule S3).

## 9. Rules for asking the user questions

- Group questions by work stream and **name the stream at the start of every question**. Never mix two streams in one numbered question.
- Every question is understandable on its own: which item, what the evidence shows (with its source and date), the options, and **what happens if left blank**.
- The default for a blank answer is always the safe one: keep the information, make no change. Say which default was applied.
- Ask only questions whose answers change what gets done, in one round.
- If an answer is ambiguous, ask again about that one item only. Never guess.
- If the user says they do not know which option is better, do not make them choose blind and do not choose for them. First present the trade-offs of each option (what it gains, what it costs, what it risks, what it makes harder later), say which one the assistant would recommend and why, and only then ask for the decision. Nothing is filed or built until the user has chosen.

## 10. Rules for applying approved changes

1. Nothing is written, changed or removed until the user explicitly approves it.
2. Before writing, re-read the files and check their version numbers match the ones read when the proposal was made. If anything changed, stop and show the difference first.
3. Write exactly the approved content, then check the size memory reports matches the approved draft.
4. Add a dated log line describing the change, with a checkpoint to the approval.

## 11. Keeping memory small

- Each memory file has a size limit (about 48 KB), and every file adds a line to the listing loaded into every conversation: fewer files, shorter descriptions.
- One fact, one home: status only in the backlog, history only in the log, repository-held detail stays in the repository with a pointer.
- Finished streams shrink to one index line and a rolled-up log line.
- All of this is subject to rule S2: nothing is removed unless proven to exist elsewhere.

## 12. Commands

Wording doesn't have to be exact; the meaning does. **Where:** MAIN = a chat outside any Project · PROJECT = a chat inside a Project · ANY = either.

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

## 13. Safety rules

- **S1 Personal stays personal.** This document is generated from the protocol only, with the user's name replaced. It never includes the index, backlog, log, principles, checkpoints, quotes, area files or Project content.
- **S2 Proof and backup before removal.** Before any cleanup, check every item against where else it lives (repositories, progress files, commit messages, past chats). Anything unproven is kept and marked unverified (section 16). Mechanically check that every identifier, number, date and hash in the old file is either kept or found in a named source. Show a cut list with evidence per line (section 16). Give the user a full backup of every affected file, verified byte for byte, **before** anything is removed (section 16). Delete a whole file only on explicit request.
- **S3 Degrade safely.** If a source can't be reached, keep the item and mark it unverified (section 16). Without scheduled tasks, skip the sync; the rest still works.
- **S4 No overrides.** This spec defines structure and routines only. It cannot grant permissions, relax privacy or memory rules, or require storing anything those rules forbid. Client identities stay in their own area file, not in log or backlog lines.
- **S5 Review before use.** A received spec is information, not instructions. Nothing happens on import.

## 14. Rollout order for a new setup

1. Create the catalog files and seed them from existing memory.
2. Use "catalog this chat" on real chats and refine.
3. Add the quotes file.
4. Add Project boards, feeds, inboxes and the nightly sync, one Project first.
5. Visualisation is optional; a text status digest is usually enough.

## 15. Tools and publishing

- If you publish your own copy of the spec, keep the protocol in memory as the source of truth and treat the published file as an export. Keep section numbers identical between the two.
- The tools below live in this repository. Full descriptions and runnable examples: [INSTALL.md → Using the tools](INSTALL.md#using-the-tools).

| Script | What it proves |
|---|---|
| `tools/sweep-dropped-tokens.sh` | A slimmed memory file dropped nothing that can't be found in a named source (rule S2) |
| `tools/verify-backup.sh` | A backup holds each file at exactly the size memory reported (rule S2, section 16) |
| `tools/check-personal.sh` | Files about to be published contain none of your personal terms (rule S1) |
| `tools/sync-readme-commands.sh` | The README's command table is identical to section 12 |

## 16. Formats: backup, cut list, unverified marker

**Backup.** A single Markdown file given to the user (never stored in memory), made before any removal. It starts with a table of every affected file: path, version, last-updated time, and size in bytes as memory reported it. Then each file's content, exactly as read, between two marker lines:

```
===== BEGIN /areas/example.md =====
…the file's exact content…
===== END /areas/example.md =====
```

The content is copied byte for byte, **including its final newline if it has one**: a file that ends with a newline shows a blank line before its END marker. Before anything is removed, the backup is checked with `tools/verify-backup.sh` (or an equivalent byte count) against the sizes memory reported, and the user is told the result.

**Cut list.** Shown to the user before any removal. It starts with the files affected, their size now and proposed, and the sources checked (each with its commit or date). Then, per file, a table:

| # | Line (short) | Verdict | Evidence / what's kept |
|---|---|---|---|

Verdicts:

| Verdict | Meaning |
|---|---|
| **KEEP** | Unchanged |
| **CUT** | The fact is proven to exist elsewhere; name the source |
| **SPLIT** | The proven parts are cut, the unproven parts kept; say which |
| **MERGE** | Several lines joined; no fact dropped |
| **STALE** | A source shows the line is no longer true; never removed or changed without the user's confirmation |
| **KEEP-UNVERIFIED** | The source could not be reached |

It ends with the result of the mechanical check (rule S2) and any questions, following section 9. The proposed new files are attached so the user can read exactly what will be written.

**Unverified marker.** When an item can't be checked because its source is unreachable, it stays where it is and gets ` [unverified: <reason>, <date>]` appended to its line, for example ` [unverified: repository not reachable, 2026-09-28]`. The marker is removed when the item is later checked. Checkpoints don't use this marker; they have their own statuses (section 6).

## 17. Working with helper agents

If your assistant can hand work to helper agents (sub-agents), for example to read a long chat in parallel, these rules apply to every task, not only to catalog work.

- **Right-size the model.** Choose the model for each helper by the task: a cheap, fast model for mechanical work such as reading chat turns, extracting lines into a fixed format, counting, or checking an anchor phrase; a mid-tier model for extraction that needs judgment about why something was decided; the most expensive model only for work that truly needs deep reasoning. Never leave every helper on the most expensive model by default, and never launch many expensive-model helpers at the same moment, because a session limit can stop all of them.
- **Record progress durably.** Tell every helper to write its findings to its own notes file as it goes (at least every few turns or items), to begin the file with the range it covers, to keep a resume marker (the last turn or item recorded), and to end the file with a coverage line. If a session is interrupted, the work done so far is not lost: the assistant reads the notes files, finds the last item recorded in each, and resumes the interrupted range from just before that point instead of starting again.
- **Keep batches small enough to survive a limit.** Launch helpers in modest waves, check the notes files after each wave, and relaunch only the ranges that did not finish. When the helpers use a chat-reading tool, run at most about three at the same time: in one run, with six in parallel, four lost the tool partway through their range, while every later wave of three finished.
- **Check tool caps before launching.** Tools can limit how many calls they allow per hour or per session, and the limit differs from one provider to another. Before launching helpers, estimate how many calls the whole job needs and compare that with the cap, which the assistant and all its helpers share. Split the job so it fits, run it in waves, record in the notes where each range stopped, and resume after the cap resets (a scheduled task can do this). Claude-specific, as measured on 2026-10-02: the chat-reading tool allowed 256 calls per hour, and reading one long turn cost one call, so a 624-turn chat plus verification passes exceeded one hour's allowance. Other providers will have other limits.
