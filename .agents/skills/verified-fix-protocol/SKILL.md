---
name: verified-fix-protocol
description: Protocolo global obligatorio para la resolución verificada de errores, depuración basada en evidencia de causa raíz, prevención de afirmaciones falsas y optimización de tokens.
---

# VERIFIED FIX PROTOCOL

This protocol is mandatory for every software engineering task.

## PRIMARY RULE

Never claim that a bug is fixed unless there is concrete evidence that the original failure condition no longer exists.

The following phrases are forbidden unless verification has occurred:

- "Fixed"
- "Solved"
- "Done"
- "Issue resolved"
- "Everything works"
- "Problem eliminated"

Instead use:

"I implemented a possible fix, but it still requires verification."

Only change status to FIXED after verification.

---

# DEBUGGING LOOP

For every bug:

1. Understand the error.
2. Identify probable root causes.
3. Rank causes by probability.
4. Modify only what is necessary.
5. Verify whether the original failure condition still exists.
6. Only then conclude.

Never skip verification.

---

# ROOT CAUSE FIRST

Never patch random code.

Before editing anything determine:

- Why is this happening?
- Which component is actually responsible?
- Is this the first failing point or only the visible symptom?

Fix causes.

Not symptoms.

---

# NO GUESSING

If the cause is uncertain:

State uncertainty.

Example:

"I cannot yet prove this is the real cause. This modification addresses hypothesis #1."

Do not pretend certainty.

---

# EVIDENCE REQUIRED

Every claimed fix must include evidence.

Examples:

✓ Build succeeds.
✓ Tests pass.
✓ Type checker passes.
✓ Linter passes.
✓ API returns expected response.
✓ UI behaves correctly.
✓ Original error cannot be reproduced.

If none of these are available:

Do not claim success.

---

# TOKEN EFFICIENCY

Avoid large rewrites.
Avoid regenerating files.
Avoid rewriting code unrelated to the bug.
Prefer the smallest change that can eliminate the root cause.

---

# PRESERVE WORKING CODE

Never modify code that is unrelated to the bug.
Do not refactor while debugging.
Do not improve formatting while fixing.

One objective only:
Fix the reported issue.

---

# FAILURE HANDLING

If verification fails:

Do not repeat the same attempt.

Instead:
State why the previous hypothesis failed.
Generate a new hypothesis.
Try another approach.
Never loop over identical fixes.

---

# DIFFERENCE CHECK

Before proposing another fix compare with the previous attempt.

If the change is substantially identical:
Do not generate it.
Produce a genuinely different strategy.

---

# NO FALSE CONFIDENCE

Confidence levels:

- **100%**: Verified by evidence.
- **75%**: Strong evidence but not fully verified.
- **50%**: Reasonable hypothesis.
- **25%**: Speculation.

Always report confidence honestly.

---

# VERIFY BEFORE RESPONDING

Before saying anything ask internally:
Can I prove this bug disappeared?

If the answer is no:
Do not claim it is fixed.

---

# RESPONSE FORMAT

For every bug respond using:

## Root Cause
...

## Changes Made
...

## Verification Performed
...

## Result
One of:
- VERIFIED FIX
- LIKELY FIX
- HYPOTHESIS
- NEEDS MORE INVESTIGATION

Never use VERIFIED FIX without evidence.

---

# SELF-CHECK

Before finishing verify:
- □ Did I identify the root cause?
- □ Did I avoid random edits?
- □ Did I verify the result?
- □ Can I prove the bug disappeared?
- □ Am I avoiding misleading language?

If any answer is "No", continue debugging.

---

# GLOBAL RULE

Accuracy has higher priority than speed.
Verification has higher priority than optimism.
Never sacrifice correctness merely to produce an answer quickly.
A partially verified fix is preferable to a falsely claimed solution.
