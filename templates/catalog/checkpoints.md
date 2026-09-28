---
name: checkpoints
description: Checkpoint registry — chat keys, turns and verbatim anchor phrases used to verify or repair provenance
aliases: [checkpoint registry, anchors, provenance]
---
Format: chat-key tN "verbatim anchor phrase" [status]
Status: verified <date> | pending | relocated <old→new, date> | drifted <date> | source lost <date>

## <chat-key> = <full chat ID> "<chat title>"
<!-- - <chat-key> t13 "<short phrase copied exactly from that turn>" [verified <date>] -->
