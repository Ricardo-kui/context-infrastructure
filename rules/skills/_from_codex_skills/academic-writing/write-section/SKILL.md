---
name: write-section
description: Write or revise any thesis chapter section with section-specific templates, style matching, verification, and journal-facing contribution guardrails
---

# Write Section Skill

Write or revise a section of the thesis. This skill remains section-general, but it now includes journal-facing checks so that clean prose does not hide weak positioning, vague theory, or claims that outrun evidence.

## Arguments

- `introduction` - Redirect to the `/write-introduction` skill
- `literature [section]` - Write or revise a section of Ch.2
- `abstract` - Write the thesis abstract
- `conclusion` - Write Ch.6
- `appendix A` or `appendix B` - Write appendix material
- `revise <chapter>` - Revise an existing chapter such as data, methodology, or results

## Pre-Writing Protocol

Before writing any section, you MUST:

1. Read the target file to understand current state.
2. Read `thesis/CLAUDE.md`.
3. Read `CLAUDE.md` at the repo root.
4. Read `.claude/reference/literature-evidence.md` when the section touches literature.
5. Read at least 40 lines from `03_data.tex`, `04_methodology.tex`, and `05_results.tex` to internalize the house style.
6. Read `references.bib`.

If the section is journal-facing, desk-review sensitive, or likely to be excerpted for submission, also load only the relevant `avoid-desk-reject` modules:

- Abstract / opening pages -> `rules/skills/avoid-desk-reject/references/abstract-and-introduction.md`
- Literature / theory sections -> `rules/skills/avoid-desk-reject/references/theory-and-literature.md` and `rules/skills/avoid-desk-reject/references/fit-and-contribution.md`
- Methods / empirical strategy / results sections -> `rules/skills/avoid-desk-reject/references/empirical-credibility.md`
- Cover letter / response package / transparency questions -> `rules/skills/avoid-desk-reject/references/submission-package-and-transparency.md`

## Narrative-Architect Use

For literature-heavy sections such as Ch.2 subsections, Ch.1 antecedents, or Ch.6 interpretation, build a paragraph-level outline before drafting. The section should read as an argument, not as a sequence of notes.

## Style Requirements

- First person singular where appropriate
- 25-35 words average sentence length
- Topic sentence -> support -> transition paragraph rhythm
- Exact numbers rather than rounded placeholders
- No filler words such as `interestingly` or `it is worth noting`
- `\citet{}` / `\citep{}` used correctly
- `\Cref{}` / `\cref{}` used consistently

## Journal-Facing Guardrails

For sections that may be read by editors, reviewers, or seminar audiences:

1. The section must support a recognizable contribution, not just contain correct prose.
2. Literature sections must position a conversation, not warehouse citations.
3. Theory sections must spell out mechanism, assumptions, and what would count against the claim.
4. Empirical sections must keep claim strength aligned with design strength.
5. If fit or contribution is the bottleneck, surface that instead of polishing around it.

## Section Templates

### Abstract

Structure:

1. Context
2. Research question
3. Method
4. Findings
5. Contribution

Rules:

- No citations
- No forward references
- Stand alone completely
- Use present tense
- Every sentence must be informative
- State why the question matters for the target reader, not only what the paper studies
- If the same abstract could fit another paper with only small substitutions, rewrite it
- Do not let method or dataset novelty substitute for contribution

### Literature Review Section

Structure:

1. Opening sentence: what this section covers and why
2. Narrative synthesis of the core papers
3. Comparative passages that position this thesis relative to prior work
4. Forward reference to this thesis's own design or argument
5. Closing transition

Rules:

- Synthesize, do not summarize paper-by-paper
- Make the conversation visible
- Use forward references to methodology, data, or results where relevant
- No orphan citations
- Literature review is a fit signal: the reader should know which audience this section is speaking to
- No casual references: every citation must earn its sentence-level role
- Do not hide contribution: the section should reveal what this thesis adds to the conversation

#### Project-Specific Notes

- `2.1.4 The Global Decline of the Labor Share`
  - Connect Karabarbounis and Neiman, Autor et al., and Barkai to the measurement strategy
- `2.2.3 Shift-Share Identification`
  - Add Borusyak-Hull-Jaravel and Goldsmith-Pinkham-Sorkin-Swift where useful
- `2.4 Contribution`
  - Keep it brief after the detailed articulation moves to Ch.1

### Theory, Methods, and Results Revision Guardrails

For theory-heavy or empirical sections:

- **Theory / mechanism**
  - State the mechanism, not only the outcome
  - Make hypotheses directional and falsifiable when appropriate
  - Surface the most likely competing explanation
- **Methods / empirical strategy**
  - Match claim strength to identification strength
  - Explain why the measures and sample answer the stated question
  - Flag when the prose implies causality but the design only supports association
- **Results**
  - Lead with the finding, then bound it
  - Separate headline evidence from appendix-style diagnostics
  - Do not let robustness tables do the main argument's job

### Conclusion

Structure:

1. Summary of findings
2. Interpretation
3. Policy or managerial implications
4. Limitations
5. Future research

Rules:

- No genuinely new results
- Honest limitations
- Forward-looking ending
- Keep the contribution visible even in the closing pages

### Appendix Material

- Every table and figure must have a label
- Every appendix artifact should be referenced from the main text
- Match the formatting conventions already used in Ch.5

## Post-Writing Protocol

### 1. Compile

```bash
cd /Users/alessandro/Projects/Tesi/thesis && tectonic main.tex
```

### 2. Cross-Reference Check

Make sure all `\Cref` and `\cref` targets resolve.

### 3. Citation Check

Make sure all `\citet` and `\citep` keys exist in `references.bib`.

### 4. Consistency Check

- Notation remains consistent
- Sign conventions remain consistent
- Group definitions remain consistent
- Panel sizes and core factual numbers match the source chapters

### 5. Style Self-Review

Re-read against the style checklist and revise if the prose does not match the established chapter voice.

### 6. Desk-Reject Pass (when relevant)

If the section is journal-facing, answer:

- Is the section helping the paper clear desk review, or only sounding polished?
- Does this section clarify the contribution and evidence burden, or blur them?
- If an editor only read this section plus the opening pages, would the paper feel more credible or less?

## Multi-Pass Workflow

For any non-trivial section:

1. Research
2. Outline
3. Draft
4. Style normalization
5. Verification

For short sections, outline and draft can be combined, but do not skip the final verification pass.
