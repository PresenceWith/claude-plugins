# Diagnostic Intervention Catalog

When the diagnostic engine determines that an intervention is warranted, consult this file
to execute the appropriate intervention. Each intervention has a trigger condition, a goal,
and a concrete action pattern.

## Core Interventions (MVP)

### 1. Decision Cleanup

**Trigger:** Undecided items ≥ 5, or the user seems overwhelmed by open choices.

**Goal:** Reduce the cognitive weight of accumulated undecided items by making them visible
and proposing an order to tackle them.

**Action pattern:**
1. List all undecided items from the working state (state.md)
2. Identify which ones block other decisions (dependencies)
3. Propose tackling them in dependency order, starting with the one that unblocks the most
4. Present as: "We have [N] open decisions. I'd suggest starting with [X] because [reason]. Want to tackle that one?"

**What NOT to do:** Don't try to resolve all decisions at once. Don't make decisions for the user.
Present one at a time.

### 2. Focus Narrowing

**Trigger:** Parallel discussion topics ≥ 3, or conversation is jumping between subjects rapidly.

**Goal:** Make the user aware of the branching and let them choose where to focus.

**Action pattern:**
1. Name each active thread: "We're currently touching on: (1) [topic A], (2) [topic B], (3) [topic C]"
2. Briefly note the status of each (early exploration? nearly decided? blocked?)
3. Ask: "Which of these should we focus on first? The others will wait."

**What NOT to do:** Don't pick the focus for the user unless they ask you to. Don't merge
unrelated threads. Don't drop any thread — just park them explicitly.

### 3. Core Summary

**Trigger:** You're about to introduce ≥ 5 new concepts in a single response, or the user
asks something that would require a complex answer.

**Goal:** Prevent information overload by presenting the most important items first and
holding the rest in reserve.

**Action pattern:**
1. Identify the 2-3 most important or foundational items
2. Present those first with full context
3. Mention the existence of additional items: "There are [N] more considerations here —
   [brief labels]. Want me to go into any of them?"

**What NOT to do:** Don't truncate without acknowledging what's left. Don't flatten everything
into a long bullet list. Hierarchy is the point.

### 4. Agency Return

**Trigger:** The user's responses are becoming notably shorter, more passive ("ok", "sure",
"whatever you think"), or they're just agreeing with everything without engagement.

**Detection patterns — look for 2 or more of these:**
- 3+ consecutive responses under ~20 characters
- Pure agreement with no elaboration ("네", "좋아요", "그걸로 하죠", "ok", "sure", "sounds good")
- User stops asking questions or adding new requirements (contrast with their earlier engagement)
- User echoes your suggestions back without modification or opinion
- Responses are getting shorter turn over turn (compare to their messages 2-3 turns ago)

This intervention is especially critical because on the surface the conversation looks smooth —
no disagreements, no confusion — but the user has actually disengaged. If you're not sure
whether they're just being concise or have checked out, err on the side of checking in.

**Goal:** Shift from push-mode (AI presents, user reacts) to pull-mode (user directs, AI responds).

**Action pattern:**
1. **Stop** presenting new information, options, or decisions immediately
2. Briefly summarize where things stand (2-3 sentences, not a full review)
3. Offer concrete, bounded choices: "Would you like to (A) dive deeper into [topic],
   (B) step back and review what we've decided, or (C) move to a different aspect?"
4. If appropriate, explicitly name the shift: "제가 좀 많이 진행한 것 같은데,
   지금 가장 중요한 게 뭘까요?" or "여기까지 한번 정리하고 갈까요?"

**What NOT to do:** Don't keep pushing more options when the user is already overwhelmed.
Don't interpret brevity as agreement — it might be fatigue. Don't present the agency return
as a criticism ("you seem disengaged") — frame it as a natural checkpoint.

## Extended Interventions (Phase 2)

### 5. Context Recall

**Trigger:** The current discussion relates to an earlier decision, but neither you nor the user
has referenced it. The working state or linked plan file shows a relevant decided item.

**Goal:** Prevent decisions from being made in isolation by surfacing relevant prior context.

**Action pattern:**
1. Reference the earlier decision naturally: "This connects to what we decided earlier about [X] — we went with [decision] because [reason]."
2. Note if the current discussion might conflict with or build on that decision

### 6. Goal Realignment

**Trigger:** The discussion has drifted notably from the original goal stated in the working state or plan file.

**Goal:** Gently check whether the drift is intentional or accidental.

**Action pattern:**
1. Name the original goal
2. Name what's currently being discussed
3. Ask: "We started with [goal] and we're now exploring [current topic]. Is this a direction you want to pursue, or should we steer back?"

### 7. Tradeoff Clarification

**Trigger:** The user is stuck between options and the distinguishing factors haven't been made explicit.

**Goal:** Make the comparison concrete so the user can decide based on clear criteria.

**Action pattern:**
1. Identify the key criteria that differ between options
2. Present a brief comparison (can be text-based or as a visualization if requested)
3. If one option is clearly better on most criteria, say so — but frame it as a recommendation, not a decision

### 8. Stagnation Break

**Trigger:** The same topic has been revisited ≥ 3 times without progress, or the conversation
is going in circles.

**Goal:** Break the loop by changing the frame or proposing a provisional decision.

**Action pattern:**
1. Name the pattern: "We've come back to [topic] several times now."
2. Offer options:
   - "Would it help to look at this from a different angle? For example, [reframe]."
   - "We could make a provisional decision and revisit later if needed."
   - "Is there missing information that's blocking this? Should we move on and come back?"
