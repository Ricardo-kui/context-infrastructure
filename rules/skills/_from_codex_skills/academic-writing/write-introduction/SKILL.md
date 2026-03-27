---
name: write-introduction
description: Write the thesis Introduction (Chapter 1) using a research-informed, multi-pass workflow grounded in academic writing best practices and journal-facing desk-reject guardrails
---

# Write Introduction Skill

Write Chapter 1 (Introduction) for the thesis "Automation and Political Ideology: Task Displacement and the Conservative Shift Among Exposed Workers."

This skill is still thesis-specific, but it now carries an explicit journal-facing front-end filter: the introduction must not only read well, it must help the paper clear early editorial screening.

## Arguments

- `draft` - Run the full pipeline: research, outline, draft, style-match, verify
- `outline` - Produce only a detailed outline with paragraph-level annotations
- `revise` - Revise an existing draft of Ch.1

## Core Writing Foundations

This skill is built around:

- **Keith Head**: Hook -> Question -> Antecedents -> Value-Added -> Roadmap
- **Jesse Shapiro**: Aspirational paragraphs before contractual paragraphs
- **Claudia Goldin**: No mystery novels; lead with the answer
- **Marc Bellemare**: The introduction should be self-contained enough for a busy reader

### Key Principles

1. **No mystery novels**: State the main finding in the first 2 paragraphs.
2. **Every sentence earns its place**: No filler and no generic claims of importance.
3. **Aspirational before contractual**: Tell the reader what you found before telling them how the chapter is organized.
4. **Self-contained**: A reader who only reads Ch.1 should still understand the question, method, key finding, and contribution.
5. **Bridge, do not duplicate**: Antecedents should map the conversation, not replay the entire literature review.
6. **Opening earns the right to be read**: The abstract and first 3 paragraphs must surface the question, answer, and why the audience should care.
7. **Contribution must move priors**: Do not sell a small wrinkle as a journal-level contribution.
8. **Fit before polish**: If journal positioning is weak, fix that before sentence-level refinement.

## Journal-Facing Overlay

If the introduction is intended for journal submission, desk-review screening, or target-journal positioning, read these additional files before drafting or revising:

1. `rules/skills/avoid-desk-reject/references/fit-and-contribution.md`
2. `rules/skills/avoid-desk-reject/references/abstract-and-introduction.md`
3. `rules/skills/avoid-desk-reject/assets/desk-reject-preflight-template.md` only if you need to return a preflight diagnosis

Before drafting, answer four questions:

1. What conversation does this paper belong to?
2. What prior belief should change if the paper is correct?
3. Can an editor see the contribution from the abstract and first 3 paragraphs?
4. Is the opening leading with question and contribution rather than sample or method?

## Target Structure

Use this journal-aware structure:

1. **Hook** (2-3 paragraphs)
   - Ground the phenomenon in a concrete tension, puzzle, or high-signal fact
2. **Research question** (1 paragraph)
   - State the question plainly and precisely
3. **Approach and findings** (3-4 paragraphs)
   - What I do, how I identify, what I find
4. **Antecedents** (3-4 paragraphs)
   - Brief map of the relevant literatures; each paragraph should end with what prior work does not do
5. **Contribution** (3-4 paragraphs)
   - Why this changes what readers should believe, not just what the paper happens to estimate
6. **Roadmap** (1 paragraph)
   - Functional, brief, and last

## Phase 1: Research

Before writing a single word, read:

1. `thesis/CLAUDE.md`
2. `.claude/reference/literature-evidence.md`
3. `thesis/chapters/02_literature.tex`
4. `thesis/chapters/03_data.tex`
5. `thesis/chapters/04_methodology.tex`
6. `thesis/chapters/05_results.tex`
7. `thesis/references.bib`
8. `CLAUDE.md` at the repo root

If the introduction is journal-facing, also read:

9. `rules/skills/avoid-desk-reject/references/fit-and-contribution.md`
10. `rules/skills/avoid-desk-reject/references/abstract-and-introduction.md`

Extract:

- Data sources, sample size, and ideology variable from Ch.3
- Identification and design summary from Ch.4
- Headline findings and magnitudes from Ch.5
- Contribution language currently living in Ch.2 section 2.4
- Available citation keys from `references.bib`

## Phase 1.5: Build the Argument Skeleton

Before drafting, sketch the paragraph logic for:

- Hook
- Question
- Approach and findings
- Antecedents
- Contribution
- Roadmap

For Antecedents and Contribution, prefer a paragraph-level outline before prose. Each Antecedents paragraph should end with a gap statement; each Contribution paragraph should answer why that contribution matters.

## Phase 2: Draft

### Writing Rules

1. Use first person singular: `I define`, `I estimate`, `I find`.
2. Use present tense for methodology and findings, past tense for data collection or historical context.
3. Use `\citet{}` and `\citep{}` correctly; never type "Author (Year)" manually.
4. Use `\Cref{}` and `\cref{}` liberally because the introduction is a navigation hub.
5. Cite exact numbers inline; do not round if the exact number is available.
6. If a number is uncertain, mark it with `% TODO: verify`.
7. Keep equations minimal.
8. Hedge responsibly: `consistent with`, `suggesting`, `indicating`.
9. Every paragraph needs a topic sentence and a transition sentence.
10. Do not let method or data novelty carry the entire burden of contribution.

### Anti-Patterns

- Opening with generic "In recent years..." setup
- Hiding the main finding until page 2 or later
- Letting the abstract describe a topic but not a contribution
- Writing a literature-map paragraph that is only a list of citations
- Treating the introduction as a mini methods section
- Using the roadmap before the reader knows why the paper matters

### Front-End Gates

Before you accept a draft as good enough, check:

- Could the abstract fit a different paper with only minor substitutions?
- Is the target conversation visible before page 2?
- Is the contribution stronger than "this has not been studied in this exact setting"?
- Does the opening justify continued reading even before technical detail appears?

## Phase 3: Style Match

Re-read substantial stretches of Ch.3-Ch.5 and normalize the introduction to match:

- first-person singular voice
- 25-35 word average sentence length
- topic sentence -> support -> transition paragraph rhythm
- no filler, no generic intensifiers
- no hidden roadmap before the paper's value is visible

## Phase 4: Verification

### Compile

```bash
cd /Users/alessandro/Projects/Tesi/thesis && tectonic main.tex
```

### Mechanical Checks

- No undefined citations
- No undefined references
- All chapter cross-references resolve
- Contribution language is not duplicated in both Ch.1 and Ch.2

### Content Verification

- [ ] Research question appears within the first 2 paragraphs
- [ ] Main finding appears within the first 3 paragraphs
- [ ] Why this audience should care is visible from the abstract and opening pages
- [ ] Contribution is framed as a prior-moving advance, not just a wrinkle or setting
- [ ] The opening does not make method or sample novelty do all the work
- [ ] At least 4 forward references point to later chapters
- [ ] Contribution section contains at least 3 distinct points
- [ ] Roadmap mentions all 5 subsequent chapters
- [ ] No number appears without a source
- [ ] Introduction is self-contained

### Desk-Reject Preflight

If the draft is journal-facing, do one final preflight pass:

- [ ] Would the abstract still identify this paper if the key construct were swapped out?
- [ ] Would an editor know the target conversation before reaching page 2?
- [ ] Is the opening strong enough to justify continued reading before method details appear?

## Coordination with Ch.2

When this skill expands the full contribution in Ch.1, Ch.2 section 2.4 should become a brief backward-pointing summary. The long-form contribution articulation should live in the introduction, not in both chapters.
