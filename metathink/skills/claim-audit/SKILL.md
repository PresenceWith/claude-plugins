---
name: claim-audit
description: Audit the current Claude Code conversation and split what's being discussed or decided into Facts (verified/observed/stated), Inferences (hypothesis/pattern-based/intent-inferred), and Assumptions (implicit). Invoke this skill ONLY when the user explicitly requests it — typically via the `/claim-audit` slash command, or when they ask things like "what's confirmed vs guessed?", "지금 사실이 뭐고 추론이 뭐야?", "정리해봐 — 확인된 건 뭐고 추측인 건 뭐야?", "separate facts from inferences", "truth check", "epistemic audit". Attach a concrete **verification action** to every inference and assumption so the user knows exactly how to convert it into a fact. Do NOT auto-trigger on general summary or planning requests; this is a deliberate, user-invoked audit.
---

# Fact vs. Inference Audit

## Purpose

In a working Claude Code conversation, claims pile up fast — some verified by reading code or running commands, others extrapolated from patterns or intent. When they get mixed, the user can easily act on a guess thinking it was a fact. This skill forces a clean separation.

The output is a compact **epistemic audit** of the current topic: what's actually grounded, what's inferred, what's silently assumed — and for every non-fact, how to verify it.

## When to run this

Run this skill only when the user explicitly asks for it (the `/claim-audit` command, or a direct request like "정리해줘 — 사실 vs 추론"). Do not run it on general summaries, status updates, or end-of-task reports — the user wants this ceremony to be *deliberate*, not ambient.

## Scope: the current topic, not the whole conversation

Before classifying, decide what the **current topic** is. A long conversation may have moved through several problems; the user almost always means *"for the thing we're deciding right now"*, not the full session log.

- Read the last ~10–20 exchanges and identify the active topic (the bug being diagnosed, the feature being designed, the PR being reviewed).
- If multiple active topics are genuinely in play, ask: *"Which topic should I audit — A or B?"* and stop. Don't audit both by default — the output gets noisy and the user loses signal.
- If the user's invocation specified a topic ("audit the auth refactor discussion"), use that.

## The classification taxonomy

Classify each claim under one of three top-level categories and one sub-type. If you can't tell whether something is Fact or Inference, it's Inference — the whole point of the audit is to be conservative about what counts as a fact.

### Facts — claims with direct evidence you (or the user) can point to

- **Verified** — established by directly reading code, files, or configuration during this conversation. Cite the file and line (e.g., `src/auth.ts:42`).
- **Observed** — established by running a command and reading its output (tests, build, logs, git, `ls`, etc.). Cite the command and the relevant line of output.
- **Stated** — the user said it plainly in this conversation, or it comes from an explicitly referenced document/spec. Quote the source briefly.

### Inferences — claims that sound grounded but were derived, not observed

- **Hypothesis** — a guess about cause or mechanism from partial evidence ("the 500 is probably a race condition because the error appears under load"). The key tell: the supporting observation is real, but the *explanation* was chosen, not proven.
- **Pattern-based** — extrapolation from general experience or framework conventions ("Next.js usually handles this in middleware"). The tell: no project-specific evidence; the claim would be identical on any similar codebase.
- **Intent-inferred** — a guess about what the user wants, why they want it, or what they'd accept ("you probably want strict types here"). The tell: the user never said this; you're reading between the lines.

### Assumptions — unstated premises the current reasoning depends on

Things nobody explicitly said, but the conversation has been proceeding *as if* they're true. Often these are environmental ("we're on Postgres 15"), scope-related ("we're only fixing the web client"), or about invariants ("the input is always sorted"). Surface them, because a wrong assumption quietly invalidates everything downstream.

## Output format

Produce a single markdown report. Keep it tight — every line should either state a concrete claim or tell the user how to verify one.

```markdown
## Fact vs. Inference Audit — <topic in 5–10 words>

### Facts
**Verified**
- <claim> — `path:line` (or brief quote)

**Observed**
- <claim> — from `<command>`: <relevant output>

**Stated**
- <claim> — user: "<brief quote>" (or doc reference)

### Inferences
**Hypothesis**
- <claim>
  - **Verify:** <one concrete action — a file to read, a command to run, a test to write>

**Pattern-based**
- <claim>
  - **Verify:** <action — usually "check the project-specific config/code at X" or "confirm with the user">

**Intent-inferred**
- <claim>
  - **Verify:** <action — usually a direct question to ask the user>

### Assumptions
- <unstated premise>
  - **Verify:** <action>

### Open questions
- <question that the conversation hasn't answered yet, if material>
```

**Omit empty sub-sections entirely.** A report with only Facts/Verified and Inferences/Hypothesis is fine — headers exist only where there's content.

## How to classify well

### Be conservative — promote doubt, not certainty

If you're torn between Fact-Stated and Inference-Intent-inferred, choose Intent-inferred. If torn between Verified and Hypothesis, choose Hypothesis. The audit's job is to make the user *more* skeptical of their own working picture, not less. Over-classifying as Fact defeats the whole exercise.

### Hedge words are a giveaway

When the assistant's turn contained claims hedged with *probably*, *likely*, *usually*, *typically*, *presumably*, *should*, *sounds like*, *that's consistent with*, *classic*, *makes sense if*, or similar — those are Inferences, even if the surrounding sentence sounded authoritative. Demote them from Fact to whichever Inference sub-type fits (usually Hypothesis or Pattern-based). A confident tone does not promote a claim to Fact; only direct evidence does.

### Don't conflate scope of agreement

When the user replied "sounds good", "makes sense", "yeah", "perfect", pin down *what specifically* they endorsed. Often they agreed to a narrow framing ("we're on Postgres so that's fine" endorses **compatibility with Postgres**, not the full schema the assistant proposed). The assistant's proposal is still an Inference/Pattern-based claim until the user explicitly confirms the broader scope. When ambiguous, classify the broader claim as Inference and make the Verify action be "confirm with the user that they meant X specifically".

### Tie each Fact to concrete evidence

A "Verified" entry without a file path is not a verified fact. An "Observed" entry without a command is not observed. If you can't produce evidence when you try to write the citation, the claim isn't a fact — move it to Inference.

### Make the verification action small and specific

The verification should be executable in under a minute without further clarification. A reader should know *exactly* what to do.

**Bad:** "Verify: check the code" / "Verify: look at the logs" / "Verify: investigate further" — these are todo stubs, not actions.

**Good:** "Verify: read `migrations/0042_add_org_id.sql` to confirm the column is `NOT NULL`" / "Verify: run `pnpm test auth.spec.ts --grep renewal` and check that the renewal path has coverage" / "Verify: ask the user 'is an unread-count badge in v1 scope, or deferred?'"

The action should tell the reader (a) what to run/read/ask, (b) what to look for in the result, (c) what outcome would satisfy the verification.

### De-duplicate aggressively

Claims often show up in multiple forms across a conversation ("the bug is in auth" / "auth middleware is the culprit" / "so it's the middleware"). Collapse them into one entry, under the strongest category they qualify for. Do not list the same claim under multiple sub-sections just because it could fit both.

### Keep section count honest — omit empties

If there are no Verified facts, do not emit a `**Verified**` header with nothing under it. Same for any sub-section. The reader skimming the headings should not encounter dead sections.

### Don't audit the audit

Don't include meta-claims like "the user is asking for an audit" or "we decided to use this skill." The report is about the *technical* conversation, not the framing of it.

## Why "Verify" actions are mandatory

The user chose a sub-classified format with verification actions because the goal isn't just to label claims — it's to make every non-fact **actionable**. A claim classified as Inference with no path to verification is a dead end; the user learns they're guessing but not what to do about it.

Every Inference and every Assumption entry must have a `**Verify:**` line. If you genuinely can't think of a cheap verification, that's itself a useful signal — write `**Verify:** no cheap verification available; proceed on this assumption only if the cost of being wrong is low` and the user will treat it accordingly.

## Example

```markdown
## Fact vs. Inference Audit — 500 error on /api/checkout under load

### Facts
**Verified**
- The retry wrapper around Stripe calls has no jitter — `src/payments/retry.ts:18`

**Observed**
- `pnpm test payments` passes all 23 cases locally
- Production logs show the 500s cluster at p99 latency >2s — from `grep '500.*checkout' prod.log`

**Stated**
- User reports customers see the error ~5% of the time during Black Friday traffic — user: "~5%のユーザーが決済失敗"

### Inferences
**Hypothesis**
- The 500s are caused by concurrent retries amplifying Stripe rate-limit hits
  - **Verify:** add a counter on retry.ts:18 and replay the Black Friday traffic sample with `scripts/replay-load.ts`; expect to see retry bursts coincident with 500 spikes

**Pattern-based**
- Stripe typically returns 429 before 500 under rate limiting
  - **Verify:** `grep -c '429.*checkout' prod.log` and `grep -c '500.*checkout' prod.log`; if 429s are absent or rare relative to 500s, the rate-limit theory weakens

**Intent-inferred**
- User wants a fix deployed before next weekend's sale, not a full rewrite
  - **Verify:** ask the user directly — "is the goal a hotfix by Friday, or a deeper refactor?"

### Assumptions
- The Stripe SDK version in prod matches the lockfile
  - **Verify:** run `ssh prod "cat node_modules/stripe/package.json | jq .version"` and compare to `pnpm list stripe` locally
```

## Keep it short

The whole audit should be readable in under a minute. Aim for under ~30 bullet points in total across all sections. If you're running long, you're probably auditing the whole conversation instead of the current topic — re-scope.
