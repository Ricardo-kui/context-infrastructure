# Research Core Skills Index

用途：给“战略管理 + 计量实证 + 顶刊写作”场景提供最小化、低噪音、默认可执行的技能入口。  
原则：研究任务先走这份索引；只有这里不能覆盖时，才回退到总索引 `INDEX.md`。

---

## 0. 默认行为

当用户没有明确点名 skill，但任务属于研究生产链时，默认按下面顺序选技能：

1. 先定问题与识别：
   - `did-analysis`
   - `stata`
   - `python-panel-data`
   - `r-econometrics`
2. 再做章节与论证：
   - `write-section`
   - `write-introduction`
   - `academic-paper-writer`
3. 再做结果表达：
   - `latex-tables`
   - `econ-visualization`
4. 最后做核验与投稿前预检：
   - `avoid-desk-reject`
   - `proofread`
   - `review-code`
   - `verify-claims`

默认不要一上来浏览总索引，也不要一次启用太多 skill。

如果任务描述里同时出现“战略管理”和“DiD / event study / policy shock / staggered adoption”，默认先把它视为识别与估计任务，而不是文献任务。  
此时优先组合：`did-analysis` + `stata`。

如果任务描述里同时出现 `desk reject`、`投稿前检查`、`target journal`、`abstract`、`editor` 或 `cover letter`，默认先把它视为投稿前 desk-review 风险诊断任务。  
此时优先组合：`avoid-desk-reject` + `write-section`；若主问题明显在引言，则改用 `avoid-desk-reject` + `write-introduction`。

---

## 1. 最小技能栈

绝大多数任务先在这 9 个里选，通常已经够用：

1. `did-analysis`  
路径：`rules/skills/_from_codex_skills/did-skills/SKILL.md`  
用途：现代 DiD 主入口；适用于 staggered adoption、event study、TWFE 诊断、稳健估计与敏感性分析。

2. `stata`  
路径：`rules/skills/_from_codex_skills/stata-skill/stata/SKILL.md`  
用途：Stata 主入口；适用于清洗、合并、变量构造、面板回归与 community packages。

3. `python-panel-data`  
路径：`rules/skills/_from_codex_skills/awesome-econ-ai-stuff/analysis/python-panel-data/SKILL.md`  
用途：Python 面板数据与复现实证流程主入口。

4. `write-section`  
路径：`rules/skills/_from_codex_skills/academic-writing/write-section/SKILL.md`  
用途：章节级重写与修订主入口；理论、方法、结果、讨论都优先从这里进。

5. `write-introduction`  
路径：`rules/skills/_from_codex_skills/academic-writing/write-introduction/SKILL.md`  
用途：引言专用入口；适合背景-冲突-疑问-答案式重写。

6. `latex-tables`  
路径：`rules/skills/_from_codex_skills/awesome-econ-ai-stuff/writing/latex-tables/SKILL.md`  
用途：投稿级回归表和结果表输出。

7. `avoid-desk-reject`  
路径：`rules/skills/avoid-desk-reject/SKILL.md`  
用途：英文管理学 / 国际商务期刊投稿前体检主入口；适用于 desk reject 风险诊断、fit 判断、abstract / intro / theory / empirics / submission package 预检。

8. `proofread`  
路径：`rules/skills/_from_codex_skills/academic-writing/proofread/SKILL.md`  
用途：语言、逻辑流、术语一致性和可读性收口。

9. `review-code`  
路径：`rules/skills/_from_codex_skills/academic-writing/review-code/SKILL.md`  
用途：代码正确性、复现风险与公式/口径一致性审查。

---

## 2. 任务路由表

### A. 识别设计与估计

- DiD / event study / staggered adoption：
  - 首选 `did-analysis`
  - 辅助 `stata` 或 `python-panel-data`
- IV / RDD / PSM / Heckman：
  - 首选 `r-econometrics` 或 `stata`
  - 如需代码审查，追加 `review-code`

### B. 数据清洗与变量构造

- Stata 项目：
  - 首选 `stata`
- Python 项目：
  - 首选 `python-panel-data`

### C. 章节写作

- 引言：
  - 首选 `write-introduction`
- 理论 / 方法 / 结果 / 讨论：
  - 首选 `write-section`
- 从零搭结构或大修整篇论文：
  - 首选 `academic-paper-writer`

### D. 结果表达

- 回归表：
  - 首选 `latex-tables`
- 系数图 / event-study 图 / 机制图：
  - 首选 `econ-visualization`

### E. 核验与审稿准备

- 投稿前 desk-reject 风险预检：
  - 首选 `avoid-desk-reject`
- 代码与复现：
  - 首选 `review-code`
- 文本清晰度：
  - 首选 `proofread`
- 事实和文献陈述核查：
  - 首选 `verify-claims`

### F. 需要扩容时

只有出现下面情况才回退到总索引 `INDEX.md`：

1. 当前任务不在研究生产主链里  
2. 需要多 agent 深调研  
3. 需要演示文稿、地图、API 抓数、发送报告等外围能力  
4. 上面最小技能栈无法覆盖当前工具链

---

## 3. 默认组合

高频任务直接套这些组合：

1. 识别设计或回归修正：
   - `did-analysis` + `stata`
2. Python 面板项目：
   - `python-panel-data` + `review-code`
3. 章节重写：
   - `write-section` + `proofread`
4. 引言重写：
   - `write-introduction` + `proofread`
5. 投稿结果打磨：
   - `latex-tables` + `econ-visualization` + `proofread`
6. 审稿应对或风险排查：
   - `review-code` + `verify-claims` + `write-section`
7. 投稿前 desk-reject 预检：
   - `avoid-desk-reject` + `write-section`
8. 引言导向的投稿前体检：
   - `avoid-desk-reject` + `write-introduction`
9. 识别可信度审查：
   - `avoid-desk-reject` + `did-analysis` + `stata`

---

## 4. 不要默认启用

下面这些只有明确需要时才用：

- `workflow_deep_research_survey`
- `verify-claims`
- `lit-review-assistant`
- `academic-paper-writer`
- 总索引 `INDEX.md` 里的非研究类 workflow

理由：它们要么更重，要么更宽，要么更适合后置阶段，不该抢占默认入口。

---

## 5. 研究任务的最短决策规则

如果只能快速做一个判断，就按这个：

1. 先问：这是投稿前 desk-review 风险、识别问题、代码问题、写作问题，还是表达问题？  
2. 若是投稿前风险：优先 `avoid-desk-reject`  
3. 若是识别/代码：优先 `did-analysis`、`stata`、`python-panel-data`  
4. 若是写作：优先 `write-section` 或 `write-introduction`  
5. 若是表图：优先 `latex-tables` 或 `econ-visualization`  
6. 若是收尾审查：优先 `proofread`、`review-code`、`verify-claims`
