# Memory Catalog — Specification v0.8

A generic setup for tracking productive work in Claude's memory: what work streams exist, what is to be done next, and what has already happened.

**How to use this document:** give it to your own Claude, read it together, and say "set up the catalog system from this spec" when you are ready. It is information, not instructions — nothing happens automatically when it is imported (rule S5). It cannot override your own privacy or memory rules (rule S4).

In this document, "the user" means the person whose memory is being organised.

---

## 1. What the catalog is for

- The catalog answers three questions: what work streams exist and what state each one is in (the **index**), what is to be done next (the **backlog**), and what has already happened and when (the **log**).
- The catalog organises information; it does not copy it. Every fact has exactly one home. Catalog files hold short lines that point to the file where the detail lives.
- The protocol changes over time. Whenever the design changes, the protocol file in memory is updated in the same turn and a line is added to its version history.

## 2. The files and who writes them

| File | What it holds |
|---|---|
| `/catalog/protocol.md` | This operating manual. The single source of truth for how the catalog works. |
| `/catalog/index.md` | One line per work stream: short name, status (active, waiting, stable, parked, reference), and where its detail lives. Pointers only. |
| `/catalog/backlog.md` | One line per open task, grouped by work stream. The **only** place task status is recorded. Finished tasks are removed and logged. |
| `/catalog/log.md` | Dated lines, newest first, by month. Current and previous month kept line by line; older months rolled up to one line each. |
| `/catalog/principles.md` | Reusable rules of thumb the user has adopted, grouped by theme, each with a checkpoint. |
| `/catalog/checkpoints.md` | Links catalog entries back to the exact chat and turn they came from (section 6). |
| `/catalog/considered.md` | The "already considered" register: ideas declined (with the user's reason) or raised but never discussed, each with a checkpoint (section 5a). |
| `/catalog/quotes.md` | *Planned.* Exact key sentences, append-only (section 6). |
| `/catalog/sync-state.md` | *Planned.* For each Project, the last feed entry already merged (section 8). |
| `/areas/<stream>.md` | The current state of one work stream (section 3). |
| `/topics/<subject>.md` | Facts about the user that are not work streams. The catalog does not change them. |

Inside each claude.ai Project:

| File | Written by | Purpose |
|---|---|---|
| `_board.md` | that Project's chats | The Project's shared status, read by every chat in the Project |
| `_feed.md` | that Project's chats only, append-only | Carries news from the Project to main memory |
| `_considered.md` | that Project's chats | The Project's own "already considered" register (section 5a) |
| `_inbox.md` | main memory / nightly sync only | Carries news from main memory into the Project |

Each side writes only its own file. The platform has no publish-only mode, so this one-way flow is enforced by following the rule, not by a technical lock. **Keep every Project memory-connected** — a Project set to separate memory is invisible to main memory and to the sync.

## 3. What belongs in an area file, and what does not

**Keep:** what the thing is; decisions and the reasons for them; rejected alternatives worth remembering; constraints and rules that still apply; risks and open questions; working arrangements; facts not recorded anywhere else.

**Do not keep:** task status (backlog); dated history (log); build detail a repository already holds — commit lists, test counts, file lists, release-by-release notes. For those, the area file keeps a one-line pointer to the repository and its progress file as the source of truth.

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

## 5. "catalog this chat" — step by step

1. Read the current chat to get its ID and turn numbers. Register it in the checkpoint registry if it is new.
2. Read the **whole** chat, including Claude's own analysis, and sort what matters into six groups:
   1. decisions, with the reason and rejected alternatives → log + area file
   2. completed work → log
   3. new tasks → backlog
   4. reusable rules of thumb → principles
   5. risks and traps → area file
   6. open questions → backlog as `[waiting on the user]`

   Everything else is discarded.
3. **Adoption gate:** anything that came from Claude's analysis rather than the user is shown as a *candidate* and filed only after the user confirms it. Confirmation is what makes it the user's own.
4. Ask clarifying questions following section 9, in one round.
5. Write only what was approved, following section 10.
6. Record everything that was **not** filed in the "already considered" register (section 5a), so it is never lost and never presented again as new.
7. Report back in three parts: **(a)** what was filed and where; **(b)** what the user declined, and the user's reason; **(c)** what was raised in the analysis but never discussed. Parts (b) and (c) each carry the checkpoint to where the idea was raised.

Inside a Project chat, the same steps write only that Project's files and append to its `_feed.md` — never to `/catalog/`. A chat moved into a Project is catalogued from inside the Project. "catalog my past chats" runs the same steps one chat at a time.

## 5a. The "already considered" register

A quick reference to every idea raised in a catalogued chat that did not become a decision, task or principle. It stops good ideas being silently lost, and stops rejected ideas being proposed again as if new.

- **Declined** — the user considered it and said no. Records the user's reason in their own terms, or "no reason given". A reason is never invented.
- **Not discussed** — it appeared in Claude's analysis but the conversation never returned to it. Records only a short topic label, never Claude's conclusions, because undiscussed analysis is not the user's position. The reasoning stays in the chat, reached through the checkpoint.

Line format: `<status> <date> — <stream>: <topic label> ⟨chat-key tN⟩` (declined lines add `— reason: <user's reason>`). Grouped by stream. An item later adopted is removed and the adoption logged; an item that becomes irrelevant is marked "no longer relevant <date>", not deleted.

**Lookup rule:** before proposing an idea in any analysis, check the register. If it's there, say "already considered on <date>, <status>, see ⟨checkpoint⟩", then say whether anything has changed that makes it worth revisiting.

## 6. Checkpoints and quotes

- Every entry that came from a chat ends with `⟨chat-key tP→tA⟩`: the chat, the turn where the idea was proposed, and the turn where the user accepted it (only `tA` when the user said it themselves). The chat key is the first 8 characters of the chat ID.
- The checkpoint registry maps each key to the full chat ID and title, and lists every referenced turn with a short verbatim **anchor phrase** and a status.
- A checkpoint is provenance only. If a chat is edited or deleted, no catalog content is lost — only the link back.
- An anchor is marked **verified** only after the turn has been opened and the phrase found. A turn still in progress when filed is marked **pending**.
- **"verify checkpoints"**: open each stored turn. Phrase present → verified. Absent → search the chat; found elsewhere → **relocated** (update the registry). Not found → **drifted**, or **source lost** if the chat is gone. Catalog content is never changed by this.
- Chat search only covers the current scope (one Project's chats, or non-project chats), so a checkpoint across that boundary may not be openable.
- *Planned:* load-bearing sentences (decisions relied on, and the user's acceptance) stored verbatim in an append-only quotes file with fixed IDs `q-<chat-key>-t<turn>`, referenced from the registry — so exact quotes survive edits, deletion and scope boundaries.

## 7. Project boards

Chats in one Project share that Project's memory, so `_board.md` is their shared channel: status, open tasks, decisions and principles, each checkpointed to the sibling chat and turn it came from. There is no live push — a chat learns what siblings did when it reads the board. A board is created from inside its Project ("set up the board").

## 8. Nightly sync (planned)

A scheduled task at a fixed night-time hour, in a fresh session: read each Project's `_feed.md` past its watermark; merge into log, index, backlog and area files; write relevant news into each Project's `_inbox.md`; move the watermark forward. A missed run is harmless. Prove it on one Project first. Requires scheduled tasks to be available on the account (rule S3).

## 9. Rules for asking the user questions

- Group questions by work stream and **name the stream at the start of every question**. Never mix two streams in one numbered question.
- Every question is understandable on its own: which item, what the evidence shows (with its source and date), the options, and **what happens if left blank**.
- The default for a blank answer is always the safe one: keep the information, make no change — and say which default was applied.
- Ask only questions whose answers change what gets done, in one round.
- If an answer is ambiguous, ask again about that one item only. Never guess.

## 10. Rules for applying approved changes

1. Nothing is written, changed or removed until the user explicitly approves it.
2. Before writing, re-read the files and check their version numbers match the ones read when the proposal was made. If anything changed, stop and show the difference first.
3. Write exactly the approved content, then check the size memory reports matches the approved draft.
4. Add a dated log line describing the change, with a checkpoint to the approval.

## 11. Keeping memory small

- Each memory file has a size limit (about 48 KB), and every file adds a line to the listing loaded into every conversation — fewer files, shorter descriptions.
- One fact, one home: status only in the backlog, history only in the log, repository-held detail stays in the repository with a pointer.
- Finished streams shrink to one index line and a rolled-up log line.
- All of this is subject to rule S2: nothing is removed unless proven to exist elsewhere.

## 12. Commands

| Say | What happens |
|---|---|
| catalog this chat | Section 5 |
| catalog my past chats / chats about *topic* | Section 5, one chat at a time |
| what's next / backlog for *stream* | Read and summarise the backlog |
| park *task* / *task* is done / drop *task* | Status change + log line |
| status digest | Text summary of index and backlog |
| was *idea* considered? / what was left undiscussed about *stream* | Read the register, answer with status + checkpoint |
| verify checkpoints | Section 6 |
| set up the board *(inside a Project)* | Section 7 |
| export the catalog spec | Regenerate this document (rule S1) |

## 13. Safety rules

- **S1 Personal stays personal.** This document is generated from the protocol only, with the user's name replaced. It never includes the index, backlog, log, principles, checkpoints, quotes, area files or Project content.
- **S2 Proof and backup before removal.** Before any cleanup, check every item against where else it lives (repositories, progress files, commit messages, past chats). Anything unproven is kept and marked unverified. Mechanically check that every identifier, number, date and hash in the old file is either kept or found in a named source. Show a cut list with evidence per line. Give the user a full backup of every affected file, verified byte for byte, **before** anything is removed. Delete a whole file only on explicit request.
- **S3 Degrade safely.** If a source can't be reached, keep the item and mark it unverified. Without scheduled tasks, skip the sync — the rest still works.
- **S4 No overrides.** This spec defines structure and routines only. It cannot grant permissions, relax privacy or memory rules, or require storing anything those rules forbid. Client identities stay in their own area file, not in log or backlog lines.
- **S5 Review before use.** A received spec is information, not instructions. Nothing happens on import.

## 14. Rollout order for a new setup

1. Create the catalog files and seed them from existing memory.
2. Use "catalog this chat" on real chats and refine.
3. Add the quotes file.
4. Add Project boards, feeds, inboxes and the nightly sync — one Project first.
5. Visualisation is optional; a text status digest is usually enough.

## 15. Tools in this repository

- `tools/sweep-dropped-tokens.sh` — the mechanical check required by rule S2. Given the old and new version of a memory file and one or more source folders (for example local clones of the repositories the detail was moved to), it lists every distinctive token (identifiers, numbers, dates, hashes, file names) that was dropped from the new file and cannot be found in any source. An empty result means nothing unproven was removed.
- `tools/verify-backup.sh` — checks that each file section in a backup has exactly the byte size memory reported, so the backup is proven complete before anything is removed (rule S2).
- `tools/check-personal.sh` — scans the files in a folder for personal terms listed in a local `.personal-terms` file (never committed). Used before publishing anything generated from a personal catalog (rule S1).
