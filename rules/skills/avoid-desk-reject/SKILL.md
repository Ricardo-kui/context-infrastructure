---
name: avoid-desk-reject
description: Use when the user wants a pre-submission desk-reject diagnostic for an English management or international business paper, abstract, introduction, theory section, empirical section, or submission package; outputs an English preflight report and routes revision work to writing and methods skills.
---

# Avoid Desk Reject

## When to Use

- 用户想知道论文为什么可能被 `desk reject` 或快速拒稿
- 用户想做投稿前 `preflight` / `投稿前检查`
- 用户给出 abstract、opening paragraphs、theory/literature、empirical section、cover letter 或整篇稿件，希望从编辑角度判断风险
- 用户提到 `target journal`、`fit`、`editor perspective`、`cover letter`

## Defaults

- 默认标准：英文管理学 / 国际商务顶刊的 desk-review 标准
- 如果用户明确给出 finance outlet 或 finance paper，也允许运行，但必须在报告中写明：`management-first standard; finance evidence used as supplement`
- 对话解释默认中文
- editor-facing 报告默认英文
- 默认不直接重写论文；先做诊断、排序、路由

## Load Only What You Need

- 始终先读 [source-synthesis](references/source-synthesis.md)
- 需要判断期刊匹配、问题重要性、贡献强度时，读 [fit-and-contribution](references/fit-and-contribution.md)
- 需要判断摘要、开头和研究问题呈现时，读 [abstract-and-introduction](references/abstract-and-introduction.md)
- 需要判断理论机制、文献定位、假设清晰度时，读 [theory-and-literature](references/theory-and-literature.md)
- 需要判断识别、测量、claim-evidence alignment 时，读 [empirical-credibility](references/empirical-credibility.md)
- 需要判断 cover letter、格式、重叠论文、AI/数据透明度时，读 [submission-package-and-transparency](references/submission-package-and-transparency.md)
- 生成最终报告时使用 [desk-reject-preflight-template](assets/desk-reject-preflight-template.md)

## Workflow

1. 先判断输入单元：整篇论文、abstract + introduction、theory/literature、empirical section，还是 submission package。
2. 再判断期刊标准：
   - 若未指定期刊，默认按英文管理学 / 国际商务顶刊标准
   - 若指定 finance outlet，保留 management-first 基线，并显式标注 finance 为补充证据来源
3. 按固定顺序诊断：
   - fit & contribution
   - abstract & introduction
   - theory & literature
   - empirical credibility
   - submission package & transparency
4. 产出英文 preflight report，必须包含：
   - `Target journal / default standard`
   - `Overall verdict`
   - `Top 5 desk-reject risks`
   - `Risk map`
   - `Revision priority order`
   - `Suggested next skill routes`
5. 用中文解释主要诊断逻辑，除非用户明确要求全英文或全中文。
6. 路由下一步，而不是默认把所有问题都自己重写：
   - 引言或 opening 问题 -> [write-introduction](../_from_codex_skills/academic-writing/write-introduction/SKILL.md)
   - 理论定位或文献结构问题 -> [write-section](../_from_codex_skills/academic-writing/write-section/SKILL.md)
   - 识别、测量或因果主张问题 -> [did-analysis](../_from_codex_skills/did-skills/SKILL.md)、[stata](../_from_codex_skills/stata-skill/stata/SKILL.md)、[review-code](../_from_codex_skills/academic-writing/review-code/SKILL.md)
   - 只是语言清晰度问题 -> [proofread](../_from_codex_skills/academic-writing/proofread/SKILL.md)

## Output Rules

- `Overall verdict` 只能使用：
  - `stop and reposition`
  - `major revision before submit`
  - `conditional submit-ready`
- 风险等级只能使用：
  - `high risk`
  - `medium risk`
  - `low risk`
- 如果真正的瓶颈是 fit 或 contribution，不要用写作建议掩盖它
- 如果证据只支持相关性，不要允许 verdict 用因果语气替作者背书
- 如果用户只给了一个章节或一个片段，要明确指出 verdict 受可见证据限制
- 用户未明确要求前，不要自动进入 rewrite 模式

## Common Trigger Phrases

- `desk reject`
- `投稿前检查`
- `preflight`
- `target journal`
- `fit`
- `abstract`
- `editor perspective`
- `cover letter`
- `why was this rejected`
