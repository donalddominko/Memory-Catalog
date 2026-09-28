# Templates

Empty starter files. The assistant uses them as the layout when you ask it to set up the catalog; you can also create the files yourself.

| Folder / file | Goes into | When |
|---|---|---|
| `catalog/index.md`, `backlog.md`, `log.md`, `principles.md`, `checkpoints.md`, `considered.md` | main memory, under `/catalog/` | At setup: these six are the working catalog |
| `catalog/quotes.md` | main memory | **Planned feature.** Only when you adopt quotes (SPEC §6) |
| `catalog/sync-state.md` | main memory | **Planned feature.** Only when you set up the nightly sync (SPEC §8) |
| `area.md` | main memory, as `/areas/<stream>.md` | One per work stream (SPEC §3) |
| `project/_board.md`, `_feed.md`, `_inbox.md`, `_considered.md` | a Project's own memory | When you say "set up the board" inside that Project (SPEC §7) |

`/catalog/protocol.md` is not a template: it is `SPEC.md` itself, stored in memory.

The frontmatter (name, description, aliases) follows the file format Claude's memory uses. If your assistant's memory uses a different line convention (for example tags at the start of each line), keep that convention; the structure is what matters.
