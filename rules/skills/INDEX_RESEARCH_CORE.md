# Research Core Skills Index

用途：给“战略管理 + 计量实证 + 顶刊写作”场景提供低噪音入口。  
原则：优先这份白名单；仅在这里无法覆盖任务时再回退到总索引 `INDEX.md`。

---

## A. 论文生产主链（优先）

1. `academic-paper-writer`  
路径：`rules/skills/_from_codex_skills/awesome-econ-ai-stuff/writing/academic-paper-writer/SKILL.md`  
适用：论文结构搭建、段落重写、引言与讨论打磨。

2. `write-introduction`  
路径：`rules/skills/_from_codex_skills/academic-writing/write-introduction/SKILL.md`  
适用：背景-冲突-疑问-答案式引言草拟与重写。

3. `write-section`  
路径：`rules/skills/_from_codex_skills/academic-writing/write-section/SKILL.md`  
适用：章节级写作与修订（理论/方法/结果/讨论）。

4. `proofread`  
路径：`rules/skills/_from_codex_skills/academic-writing/proofread/SKILL.md`  
适用：语言清晰度、逻辑流、术语一致性校正。

5. `latex-tables`  
路径：`rules/skills/_from_codex_skills/awesome-econ-ai-stuff/writing/latex-tables/SKILL.md`  
适用：回归表规范化输出（投稿级 LaTeX 表格）。

---

## B. 计量识别与估计主链（优先）

6. `did-analysis`  
路径：`rules/skills/_from_codex_skills/did-skills/SKILL.md`  
适用：现代 DiD 流程（TWFE 诊断、稳健估计、敏感性分析）。

7. `stata`  
路径：`rules/skills/_from_codex_skills/stata-skill/stata/SKILL.md`  
适用：Stata 清洗、估计、面板回归与常见包调用。

8. `python-panel-data`  
路径：`rules/skills/_from_codex_skills/awesome-econ-ai-stuff/analysis/python-panel-data/SKILL.md`  
适用：Python 面板模型、事件研究图、复现实证流程。

9. `r-econometrics`  
路径：`rules/skills/_from_codex_skills/awesome-econ-ai-stuff/analysis/r-econometrics/SKILL.md`  
适用：R 下 IV/DiD/RDD 等计量分析与诊断。

10. `stata-regression`  
路径：`rules/skills/_from_codex_skills/awesome-econ-ai-stuff/analysis/stata-regression/SKILL.md`  
适用：Stata 回归结果产出与稳健性扩展。

---

## C. 证据、文献与可视化（次优先）

11. `lit-review-assistant`  
路径：`rules/skills/_from_codex_skills/awesome-econ-ai-stuff/literature/lit-review-assistant/SKILL.md`  
适用：文献梳理、争议点归纳、理论定位。

12. `verify-claims`  
路径：`rules/skills/_from_codex_skills/academic-writing/verify-claims/SKILL.md`  
适用：对论文陈述进行证据核查（需本地 RAG 条件）。

13. `econ-visualization`  
路径：`rules/skills/_from_codex_skills/awesome-econ-ai-stuff/communication/econ-visualization/SKILL.md`  
适用：发表风格图表（系数图、趋势图、机制图）。

---

## D. 研究工程化（可选）

14. `review-code`  
路径：`rules/skills/_from_codex_skills/academic-writing/review-code/SKILL.md`  
适用：实证代码审查与复现风险排查。

15. `workflow_deep_research_survey`  
路径：`rules/skills/workflow_deep_research_survey.md`  
适用：前沿议题扫描、多线索调研、结构化调研报告。

---

## 推荐调用顺序（默认）

1. 先识别：`did-analysis` / `stata` / `python-panel-data`  
2. 再表达：`write-section` / `academic-paper-writer`  
3. 再收敛：`proofread` / `latex-tables` / `econ-visualization`  
4. 最后核验：`verify-claims` / `review-code`
