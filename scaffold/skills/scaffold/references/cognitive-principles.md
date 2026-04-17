# Cognitive Principles Reference

This document explains the cognitive science foundations behind scaffold's design decisions. Read this when you need to diagnose why an explanation isn't landing, or when you want to try an alternative technique.

## Core Principles Applied

### 1. Working Memory Limits (Cowan, 2001)

Humans can actively process about 4 independent items simultaneously. Exceeding this causes "cognitive overload" — the feeling of information washing over you without sticking.

**Application in scaffold:**
- Maximum 4 new concepts per layer
- Each concept is introduced with enough context to "attach" it to existing knowledge, reducing the number of truly independent items the user is tracking

**When to adjust:** If the user seems overwhelmed even with 4 concepts, reduce to 2-3. If they're absorbing quickly and asking for more, you can push to 5 — but never beyond.

### 2. Elaboration Theory (Reigeluth, 1979)

Learning is most effective when it proceeds from general to specific — starting with the big picture and progressively zooming in. This gives the learner a "filing cabinet" to organize details as they arrive.

**Application in scaffold:**
- Layer 0 is always the bird's-eye map
- Each subsequent layer zooms into one area
- Details are always presented after their context is established

**When to adjust:** Some users prefer bottom-up learning (start with concrete examples, then generalize). If the user seems lost with the top-down approach, try flipping: give a concrete example first, then zoom out to show where it fits.

### 3. Dual Coding Theory (Paivio, 1971)

Information encoded both verbally and visually is retained significantly better than either alone. The two encoding channels reinforce each other.

**Application in scaffold:**
- Every layer includes both text explanation AND a visualization
- Visualizations should be structurally meaningful (not decorative)

**When to adjust:** If generating a visualization feels forced for a particular concept, a well-structured text layout (indentation, grouping) can serve as a "quasi-visual" alternative.

### 4. Narrative Cognition (Bruner, 1991)

Humans naturally organize information into causal-temporal sequences (stories). A concept presented as "problem → approach → solution" is processed and retained far better than a standalone definition.

**Application in scaffold:**
- Each concept is introduced through its origin story: what problem existed, what was tried, what emerged
- Layers follow a narrative arc, not an encyclopedic structure

**When to adjust:** For highly formal/mathematical domains (e.g., abstract algebra), narrative framing may feel artificial. In these cases, use "progressive construction" instead: build the concept step by step like constructing a building, where each step is logical rather than narrative.

### 5. Schema Theory (Bartlett, 1932; Piaget, 1952)

New information is understood by connecting it to existing mental structures (schemas). If a connection point doesn't exist, the information floats unattached and is quickly forgotten.

**Application in scaffold:**
- The SURVEY phase identifies what the user already knows
- New concepts always start by connecting to something familiar
- Analogies to the user's known domains when available

**When to adjust:** Be careful with analogies — a bad analogy creates a wrong schema that's harder to fix than no schema. Only use analogies when the structural mapping is genuinely strong. If in doubt, use the narrative approach (problem → solution) instead.

### 6. Zone of Proximal Development (Vygotsky, 1978)

The optimal learning zone is just beyond what the learner can already do independently. Too easy = boring, too hard = overwhelming.

**Application in scaffold:**
- Prerequisite mapping ensures each layer is exactly one step beyond what's been established
- Adaptive responses let the user signal when something is too easy or too hard

### 7. Spacing Effect (Ebbinghaus, 1885; Cepeda et al., 2006)

Processing time between chunks of information improves retention. The brain needs moments to consolidate.

**Application in scaffold:**
- Inter-layer pauses serve as natural spacing
- The check-in question isn't just for the user's benefit — the pause itself aids processing

### 8. Advance Organizers (Ausubel, 1960)

Providing a conceptual framework before detailed content helps the learner organize incoming information.

**Application in scaffold:**
- Layer 0 (the domain map) is a macro-level advance organizer
- Each layer's preview sentence is a micro-level advance organizer

## Alternative Techniques

When the standard approach isn't working, try these:

### Concept Contrasting
Instead of defining what something IS, define what it ISN'T — especially relative to things the user might confuse it with.
- "Pod랑 컨테이너가 비슷해 보이지만, 핵심 차이는..."

### Worked Examples
Walk through a complete, concrete scenario step by step before abstracting to general principles. Useful when the domain is too abstract for narrative framing.

### Self-Explanation Prompting  
Ask the user to explain something back in their own words. This activates deeper processing. Use sparingly — once per session at most, and frame it naturally: "혹시 이걸 본인 프로젝트에 적용한다면 어떻게 될 것 같으세요?"

### Interleaving
If multiple similar-but-different concepts are causing confusion, present them side by side rather than sequentially. A comparison table or side-by-side diagram can make distinctions clearer than sequential explanation.
