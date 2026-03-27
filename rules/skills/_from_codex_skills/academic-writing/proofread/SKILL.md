---
name: proofread
description: Proofread a thesis chapter, abstract, or journal-facing section for grammar, style, clarity, and desk-reject red flags
context: fork
agent: proofreader
---

# Proofread Chapter or Section

Proofread the specified thesis chapter or section. The argument may be a chapter filename such as `05_results` or `04_methodology.tex`, or any journal-facing unit such as an abstract, introduction, theory section, empirical section, or response draft.

## When to Use

- The user wants grammar, style, clarity, and transition cleanup
- The user wants a chapter or section checked before sharing with a supervisor, reviewer, or journal
- The user says "proofread" but the real risk may be that the prose is hiding a desk-reject problem

## Workflow

1. Read the target text or file in full.
2. Identify whether the piece is journal-facing.
   - If yes, load only the relevant `avoid-desk-reject` module:
     - abstract / opening -> `rules/skills/avoid-desk-reject/references/abstract-and-introduction.md`
     - theory / literature -> `rules/skills/avoid-desk-reject/references/theory-and-literature.md`
     - empirical section -> `rules/skills/avoid-desk-reject/references/empirical-credibility.md`
3. Review on two layers:
   - **Layer 1: language and structure**
     - grammar
     - clarity
     - sentence flow
     - transitions
     - redundancy
     - tone mismatch
   - **Layer 2: editor-facing risk**
     - buried contribution
     - vague or generic abstract language
     - literature that does not position a conversation
     - claims that outrun evidence
     - polished wording masking a fit or contribution problem
4. Return a structured report with findings sorted by severity.

## Report Format

- `Overall assessment`
- `HIGH`
- `MEDIUM`
- `LOW`
- `Desk-reject red flags` (only when relevant)
- `Suggested next skill routes`

## Review Rules

- Do not reduce the task to grammar if the prose reveals a more structural problem.
- If the text is clear but strategically weak, say so explicitly.
- If the core issue is fit, contribution, theory positioning, or claim-evidence mismatch, recommend `avoid-desk-reject` or the next writing/method skill rather than pretending line edits will solve it.
- Keep examples and quoted snippets short.

If no argument is provided, ask which chapter or section to proofread.
