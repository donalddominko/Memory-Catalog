---
name: principles
description: Sam's adopted rules of thumb, each with a checkpoint
aliases: [heuristics, playbook]
---
Checkpoint format ⟨chat-key tP→tA⟩ = proposed at turn P, accepted at turn A.

## Building
- Ship each risky change as its own release, never stacked with another, so a rollback only undoes one thing ⟨a1b2c3d4 t9→t12⟩
- Build first what depends on nobody else; start what waits on third parties only once their terms are known ⟨a1b2c3d4 t9→t12⟩
