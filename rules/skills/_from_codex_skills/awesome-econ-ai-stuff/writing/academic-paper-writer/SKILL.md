---
name: academic-paper-writer
description: Draft economics or management-journal papers with outlet-specific structure, contribution logic, and submission-aware writing conventions
---

# Academic Paper Writer

## Purpose

This skill helps draft, restructure, and polish academic papers while matching the writing logic of the target outlet.

It now supports two explicit modes:

- **economics-default**: for economics- or finance-style papers where IMRAD structure and results-first exposition dominate
- **management-journal**: for English management, strategy, organization, or international business journals where fit, theory positioning, and front-end editorial screening are especially important

## When to Use

- Starting a new paper from scratch
- Restructuring an existing draft
- Writing or revising core sections such as the introduction, literature review, theory, results, or conclusion
- Preparing a paper for journal submission

## Step 1: Choose the Writing Mode

Use **economics-default** when:

- the target outlet is economics or finance
- the paper is mainly empirical and the outlet expects a standard IMRAD arc
- theory development is light relative to identification and estimation

Use **management-journal** when:

- the target outlet is in management, strategy, organization, or international business
- the paper's front-end fit, theoretical positioning, and contribution framing are central to whether editors keep reading
- the paper needs to explain not only what it finds, but why this audience should care and how the paper shifts the conversation

If the user mentions journals such as `AMJ`, `SMJ`, `JIBS`, `Organization Science`, `JOM`, or similar outlets, default to **management-journal**.

## Step 2: Identify the Target and Stage

Before drafting, determine:

1. empirical or theoretical
2. target journal / audience
3. stage: outline, first draft, revision, or pre-submission tightening
4. which sections need help

Also determine the collaboration language:

- if the user is discussing the paper in Chinese but targeting an English journal, keep the working discussion in Chinese
- keep the actual paper prose, preflight-facing phrasing, and editor-facing labels in English unless the user explicitly asks otherwise

## Step 3: Load the Right Overlay

### Economics-Default

Follow the standard structure:

1. Introduction
2. Literature review
3. Data and methods
4. Results
5. Discussion
6. Conclusion

### Management-Journal

Before drafting, load the relevant `avoid-desk-reject` references:

- `rules/skills/avoid-desk-reject/references/fit-and-contribution.md`
- `rules/skills/avoid-desk-reject/references/abstract-and-introduction.md`
- `rules/skills/avoid-desk-reject/references/theory-and-literature.md`
- `rules/skills/avoid-desk-reject/references/empirical-credibility.md`

Use them to check:

1. what conversation this paper belongs to
2. what prior belief should move if the paper is correct
3. whether the abstract and opening paragraphs earn the right to be read
4. whether theory, hypotheses, measures, and claims align

If the user only wants one section, route tightly:

- introduction / abstract -> `write-introduction`
- theory / literature / results / conclusion -> `write-section`
- final pre-submission risk check -> `avoid-desk-reject`

## Step 4: Write Using the Correct Paper Logic

### Economics-Default Logic

- first paragraph states the research question and main finding
- methods are introduced early and efficiently
- literature review supports positioning but does not dominate the front end
- results lead with magnitudes and economic interpretation
- conclusion synthesizes implications and limitations

### Management-Journal Logic

- **Fit before polish**: the paper must clearly belong in the target journal's conversation
- **Contribution must move priors**: do not present a small wrinkle as the paper's main value
- **Opening earns the right to be read**: the abstract and first 3 paragraphs must show what the paper does, why it matters, and why now
- **Literature review positions the conversation**: it should not be a warehouse of citations
- **Theory carries real work**: mechanism, assumptions, and hypotheses must be explicit
- **Claims match evidence**: do not let strong prose outrun the design
- **Chinese-in, English-out when needed**: let the user reason, diagnose, and prioritize revisions in Chinese, but draft journal-facing prose in English by default

## Management-Journal Structure

For empirical management papers, prefer:

1. **Introduction**
   - topic, why it matters, what is already known, what is missing, what this paper shows
2. **Theory / literature positioning**
   - identify the exact conversation and the paper's mechanism
3. **Hypotheses or propositions**
   - explicit, directional when appropriate, and falsifiable
4. **Data and empirical strategy**
   - enough design detail to justify the claims
5. **Results**
   - lead with the headline finding, then bound it
6. **Discussion**
   - theory implications, managerial implications, limitations
7. **Conclusion**
   - concise restatement of contribution and next steps

## Management-Journal Introduction Template

```latex
\section{Introduction}

% Why this topic matters now
[OPEN WITH THE PHENOMENON, PUZZLE, OR TENSION]

% What we know and what we do not know
Existing research shows [WHAT IS KNOWN], but we still know less about
[THE SPECIFIC GAP OR UNRESOLVED RELATIONSHIP].

% Research question
This paper asks whether [RESEARCH QUESTION].

% Preview of answer
I find that [MAIN FINDING IN ONE OR TWO SENTENCES].

% Why this changes the conversation
This matters because [WHY THE RESULT SHOULD CHANGE THE READER'S PRIOR].

% Brief design signal
I test this argument using [DATA / DESIGN / IDENTIFICATION].

% Contribution
The paper contributes by [CONTRIBUTION 1], [CONTRIBUTION 2], and
[CONTRIBUTION 3].
```

## Section-Level Guidance

### Introductions

- Start with a question or tension, not a generic topic statement
- State the main finding early
- Make the contribution visible before the roadmap
- In management-journal mode, do not let sample or method novelty do all the work

### Literature Review / Theory

- Synthesize rather than summarize
- Make the conversation visible
- Explain the mechanism instead of only citing prior results
- If using management-journal mode, every major block should help answer: why should this audience care?

### Results

- Lead with the headline result
- Interpret magnitudes and boundary conditions
- Keep claim strength aligned with design strength
- Separate headline evidence from diagnostics and appendix-style robustness when possible

### Conclusion

- Do not introduce new results
- Be honest about limitations
- End on contribution and implications, not only recap

## Common Pitfalls

- Burying the main result too deep in the paper
- Using "significant" without clarifying statistical or substantive meaning
- Over-claiming causality without sufficient design support
- Writing a literature review that is only a list of papers
- Treating fit and contribution as if style polishing can substitute for them
- In management-journal mode, mistaking theory citations for actual theoretical positioning

## Pre-Submission Rule

If the user is preparing for submission, the paper is not done until it has passed a final `avoid-desk-reject` style preflight:

- fit and contribution
- abstract and introduction
- theory and literature
- empirical credibility
- submission package and transparency

## References

- [Cochrane (2005) Writing Tips for PhD Students](https://www.johnhcochrane.com/research-all/writing-tips-for-phd-studentsnbsp)
- [Shapiro (2019) How to Give an Applied Micro Talk](https://www.brown.edu/Research/Shapiro/pdfs/applied_micro_slides.pdf)
- [Thomson (2011) A Guide for the Young Economist](https://mitpress.mit.edu/books/guide-young-economist)

## Changelog

### v1.1.0
- Added `management-journal` mode
- Integrated desk-reject-aware contribution, theory, and evidence checks
- Added explicit routing to section-specific and preflight skills

### v1.0.0
- Initial release with introduction, results, and conclusion templates
