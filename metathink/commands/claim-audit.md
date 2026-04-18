---
description: Audit the current conversation topic — split claims into Facts, Inferences, and Assumptions, with a concrete verification action for every non-fact.
---

Invoke the `claim-audit` skill and run it on the current conversation topic.

If the user passed a topic hint after the command (everything after `/claim-audit`), treat it as the scope. Otherwise infer the active topic from the last ~20 exchanges, and if it's ambiguous between two or more, ask which one to audit before producing the report.

Topic hint: $ARGUMENTS
