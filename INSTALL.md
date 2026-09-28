# Installing Memory Catalog

Memory Catalog isn't software you run. It's a set of Markdown files that live in your assistant's memory, plus a specification the assistant follows. Installing it means getting those files into memory and telling the assistant to use them.

This guide covers Claude, the platform it was built on. For other assistants, see [Other assistants](#other-assistants).

## What you need

| Requirement | Why | Required? |
|---|---|---|
| Claude with **memory turned on** (the "Generate memory from chats" setting) | The catalog is stored as memory files | Yes |
| A copy of `SPEC.md` from this repository | It is the instruction set Claude follows | Yes |
| Projects in Claude | Only for Project boards (SPEC §7) | Optional |
| Scheduled tasks in Claude | Only for the nightly sync (SPEC §8, not yet live) | Optional |
| `bash`, `grep`, `awk`, `git` | Only for the tools in `tools/` | Optional |

## Install in Claude

### 1. Get the spec

Download `SPEC.md` from this repository, or clone it:

```bash
git clone https://github.com/donalddominko/Memory-Catalog.git
```

### 2. Start the setup

Open a **new chat outside any Project**, so the catalog lands in your main memory rather than inside one Project. Attach `SPEC.md` and send:

> Set up the catalog system from this spec. Show me what you'll create before writing anything.

Rule S5 means nothing happens on import. You read the spec and ask for the setup yourself.

### 3. Review and approve

Claude will:

1. Store the spec in memory as `/catalog/protocol.md`, adapted to your memory's line format.
2. Propose the catalog files: `index`, `backlog`, `log`, `principles`, `checkpoints` and `considered`, using `templates/catalog/` as the layout.
3. Read your existing memory and propose how to sort it: work streams into the index, open tasks into the backlog, dated events into the log.
4. Ask clarifying questions following SPEC §9: each one names its work stream, and leaving an answer blank always means "keep it, change nothing".

Nothing is written until you approve (SPEC §10). Existing memory files are not removed. Any later cleanup follows rule S2: proof that each removed item exists elsewhere, and a verified backup before anything is removed.

### 4. Check the installation

Send:

> status digest

You should get a text summary of your work streams and open tasks. Your memory should now contain a `/catalog/` folder with the files above.

### 5. Add Project boards (optional)

For each Project where several chats work on the same thing, open a chat **inside that Project** and send:

> set up the board

This creates `_board.md`, `_feed.md`, `_inbox.md` and `_considered.md` in that Project's memory (see `templates/project/`). Keep the Project's memory connected to your main memory, or the catalog can't see it.

**Know the limit.** The nightly sync that moves news between Projects and main memory isn't live yet (SPEC §8). Until it is, a board shares status only between chats of the same Project. To bring a Project's news into your main catalog, open a main chat and send:

> read the *Project name* board and update the catalog

## Daily use

At the end of a working chat, say **catalog this chat**. Every other command (what to say, where to say it, and what you get back) is in the [Commands table in the README](README.md#commands), copied from [SPEC §12](SPEC.md#12-commands).

## Updating to a new spec version

Attach the new `SPEC.md` and send:

> Update the catalog protocol to this version. Show me what changes before writing.

Claude compares it with `/catalog/protocol.md`, shows the differences, and writes only after you approve. Check [CHANGELOG.md](CHANGELOG.md) for what changed.

## Removing it

Send:

> Delete the catalog files.

Whole-file deletion only happens when you ask explicitly (rule S2). You'll be offered a backup first; the backup format is in [SPEC §16](SPEC.md#16-formats-backup-cut-list-unverified-marker). Your other memory files are not affected.

## Using the tools

The scripts in `tools/` support the safety rules. Run them on your own computer; they don't touch memory.

```bash
chmod +x tools/*.sh

# S2: did a slimmed file drop anything that isn't recorded elsewhere?
tools/sweep-dropped-tokens.sh old.md new.md ~/code/my-repo ~/notes

# S2: does a backup hold each file at the exact size memory reported?
tools/verify-backup.sh backup.md /areas/project.md=15618 /catalog/log.md=2219

# S1: before publishing anything, is it free of your personal terms?
printf 'Your Name\nyour-company\n' > .personal-terms   # never committed
tools/check-personal.sh .
# strings that are allowed despite matching (e.g. your own repo URL) go in .personal-allow

# After editing SPEC §12: copy the command table into the README (or --check it)
tools/sync-readme-commands.sh
```

Each script prints its usage when run without arguments. What each one proves: [SPEC §15](SPEC.md#15-tools-and-publishing). The backup and cut-list formats they work with: [SPEC §16](SPEC.md#16-formats-backup-cut-list-unverified-marker).

## Other assistants

The structure is plain Markdown, so it carries over to any assistant that can keep persistent files:

1. Create the files from `templates/catalog/` in the assistant's memory or knowledge store.
2. Store `SPEC.md` there as the protocol, and tell the assistant to read it before any catalog action. Add `templates/area.md` for each work stream.
3. Replace Claude-specific parts that don't exist on your platform. Chat checkpoints need a way to open a past chat at a given turn. Project boards need shared per-project memory. The nightly sync needs scheduled tasks. Rule S3 covers this: without a capability, that part is skipped and the rest still works.
