# Comparison Matrix Rendering Guide

**When to use:** Evaluating options against criteria. The conversation involves "A vs B",
"pros and cons", or weighing multiple alternatives by specific dimensions.

**Data source:** `alternative-to` relations in the state file, plus any criteria
mentioned in the conversation.

**Structure:** Table with options as columns, criteria as rows. Cells contain ratings or notes.

## Layout

Use an HTML table with CSS grid or `<table>`. This is an HTML-based visualization,
not SVG — use `max-width: 960px` with `margin: 0 auto`.

## Table Structure

```
             | Option A      | Option B      | Option C
-------------|---------------|---------------|----------
Criterion 1  | ✓ Good        | △ Partial     | ✗ Poor
Criterion 2  | △ Partial     | ✓ Good        | ✓ Good
Criterion 3  | ✗ Poor        | ✓ Good        | △ Partial
```

## Cell Styling

Use color-coded indicators, not just text:
- **Favorable:** Green background (`#4ade8020`), green text, ✓ icon
- **Neutral/Partial:** Yellow background (`#facc1520`), yellow text, △ icon
- **Unfavorable:** Red background (`#ef444420`), red text, ✗ icon
- **Unknown/TBD:** Gray background, "?" marker

Keep cell content brief — 1-3 words plus the indicator. Detailed notes go in tooltips.

## Header Row & Column

- Option headers: bold, centered, with the option name
- If one option is the current frontrunner, highlight its column header
- Criteria column (leftmost): left-aligned, slightly wider than data columns
- Optionally add a "Weight" or "Priority" sub-column next to criteria

## Summary Row

Add a bottom row showing the overall assessment:
- Count of favorable/neutral/unfavorable ratings per option
- Or a simple "추천" marker on the strongest option (if one clearly leads)

## Known Issues & Optimization Notes

_This section is updated as the skill is used._
