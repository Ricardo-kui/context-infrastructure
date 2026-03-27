# Context Infrastructure 系统诊断（2026-03-24）

## 诊断结论（Executive Summary）

当前系统已完成从“示例仓库”到“教授研究场景”定制的关键第一步，但还未进入“稳定高产”状态。  
核心问题不在能力缺失，而在配置一致性和运行治理：

1. 规则层存在结构漂移（`SOUL/USER/COMMUNICATION` 同构性被破坏）  
2. skills 资产规模大幅增加（201 个 md，31 个 SKILL.md），但尚未建立“研究场景白名单”  
3. `.env` 仍是占位值，自动化链路尚未进入可运行状态  

结论：系统可用，但距离“长期稳定、高质量、低摩擦”的个人研究基础设施还有 1-2 轮结构优化。

---

## 现状快照

- 规则目录：`rules/`（含 `SOUL.md`、`USER.md`、`COMMUNICATION.md`、`WORKSPACE.md`、`README.md`）
- skills 文档总量：201（含导入）
- axioms 文档总量：88（含导入）
- 导入 skills：4 组（academic-writing / awesome-econ-ai-stuff / did-skills / stata-skill）
- `.env`：12 个变量，当前均为占位或默认示例值

---

## 关键发现（按优先级）

## P0（本周必须修）

### 1) 规则同构失真
- `COMMUNICATION.md`：10 段结构完整。
- `USER.md`：出现额外段落（“10)工作方法论”）导致结构不严格同构。
- `SOUL.md`：混入旧版段落，章节数量与编号体系明显不一致。

风险：
- Agent 每轮加载时会出现“规则冲突”和解释歧义。
- 你的“先结论后证据”风格会在部分会话中退化。

建议：
- 将三份文件强制对齐同一 10 段骨架。
- 把额外内容改为“附录”或并入对应段落，不单独新增同级章节。

### 2) 规则升级流程与 README 顺序不一致
- README 规定“先 COMMUNICATION，再 USER，再 SOUL”。
- 实际改动中出现跨文件混改，造成版本漂移。

建议：
- 固化一个“单入口变更流程”：先改 `COMMUNICATION.md`，再映射到 `USER/SOUL`。

---

## P1（两周内完成）

### 3) skills 过载，缺少“研究白名单”

现状：
- 已导入大量 skills，但 `rules/skills/INDEX.md` 仍偏通用，不是“战略管理+计量研究”优先。

风险：
- 模型触发路径变长，检索噪音上升。
- 论文任务可能调用到与你场景弱相关的 workflow。

建议：
- 新建 `rules/skills/INDEX_RESEARCH_CORE.md`，只保留 12-15 个高频核心 skills：
  - `did-analysis`, `stata`, `python-panel-data`, `r-econometrics`, `academic-paper-writer`, `latex-tables`, `lit-review-assistant` 等。
- 在 `AGENTS.md` 或 `rules/README.md` 明确：论文任务优先走 `INDEX_RESEARCH_CORE.md`。

### 4) 工作区路由模板已成型，但缺“项目实例化脚本”

现状：
- `WORKSPACE.md` 已定义了非常好的目录标准。

建议：
- 增加一个脚本（PowerShell）一键创建新课题目录骨架。
- 这样每个新项目都自动具备 `data/code/models/outputs/papers/replication` 结构。

---

## P2（一个月内做）

### 5) 记忆系统尚未形成“研究可用闭环”

现状：
- `periodic_jobs/ai_heartbeat` 存在，但未完成可运行集成。

建议：
- 将 observer/reflector 从“泛化记录”改为“论文推进追踪”：
  - 每日记录：当日假设变更、数据口径变更、回归结果变化。
  - 每周反思：识别风险清单、审稿风险预测、下周实验计划。

### 6) 缺少“审稿应对模板库”

建议：
- 新增 `docs/submission/review_response_templates.md`：
  - 质疑并行趋势时的回应模板
  - 质疑内生性时的回应模板
  - 质疑机制识别时的回应模板
  - 质疑外部效度时的回应模板

---

## 推荐目标架构（你的场景）

## L3（稳定层）
- `SOUL.md / USER.md / COMMUNICATION.md / WORKSPACE.md / axioms`
- 低频变更（月度）

## L2（研究工作流层）
- `skills core index + submission templates + method playbooks`
- 中频变更（每个项目迭代）

## L1（运行层）
- 当前项目数据、代码、输出、日志、每日记录
- 高频变更（每日）

原则：L3 稳定、L2 渐进、L1 高频。

---

## 建议的下一步执行顺序

1. 修复三份规则的同构一致性（P0）  
2. 建立研究核心技能索引（P1）  
3. 增加新项目骨架生成脚本（P1）  
4. 打通 observer/reflector 的论文追踪闭环（P2）  
5. 建立审稿应对模板库（P2）

---

## 你会直接感受到的收益

- 对话更稳定：风格和输出结构不再漂移
- 研究更快：高频任务触发路径缩短
- 审稿更强：提前准备“质疑 -> 证据回应”矩阵
- 复现更稳：每个结果都能追溯到数据、代码、参数和日志
