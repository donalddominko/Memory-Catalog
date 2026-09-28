---
name: tidepool
description: Tidepool, Sam's tide-times mobile app — decisions, constraints and open risks
aliases: [Tidepool, tide app]
---
- Sources of truth: the app's repository and its PROGRESS.md (build history, releases, test results). This file keeps only what is not recorded there.
- What it is: a paid mobile app showing tide times for small harbours, sold as a one-off purchase.

## Decisions
- Offline tide tables before live sea-level readings, because live data depends on the harbour authority's API terms, which aren't agreed yet ⟨a1b2c3d4 t9→t12⟩
- No accounts or sign-in in v2: the app works without the user giving any personal data ⟨a1b2c3d4 t3⟩

## Rejected alternatives
- Paid ads for the v2 launch: the budget goes to the offline feature first (also in the register) ⟨a1b2c3d4 t5→t6⟩

## Constraints and rules
- Each risky change ships as its own release, never stacked with another (see principles)
- Tide data must show its source and the time it was last updated on every screen

## Risks and open questions
- If the API terms forbid caching, the 90-day offline download needs a different data source
- Older phones may run out of memory with 90 days of data for many harbours; test on the lowest-spec device first

## Working arrangements
- Sam builds; a friend with a sailing club tests pre-releases on the water before each release
