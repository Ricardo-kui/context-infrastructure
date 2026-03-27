# Preference Registry

用途：记录已经跨越“单周观察”阶段、但还不一定需要晋升为 `rules/` 或 `axioms/` 的稳定偏好。  
定位：这是 L2.5 层，介于 `OBSERVATIONS.md` 与 `rules/` 之间。

## 如何使用

- 新偏好先来自每周反思，而不是直接空想
- 一个偏好至少要能回答：
  - 默认怎么做
  - 在什么条件下适用
  - 在什么边界下失效
  - 有哪些证据支持
- 当某条偏好已经成为跨项目硬约束，再考虑晋升到 `rules/`
- 当某条偏好具备高层哲学性和长期稳定性，再考虑晋升到 `axioms/`

## 条目格式

### PREF-XXX
- Domain:
- Preference:
- Default action:
- Applies when:
- Avoid when:
- Evidence:
- Confidence: low | medium | high
- Status: candidate | stable | retired
- Last reviewed:
- Upgrade target: none | rule | axiom | skill

---

## A. 研究问题与识别

### PREF-001
- Domain: research_design
- Preference: 先绑定真实项目代码与变量口径，再抽象规则
- Default action: 新项目接入时先读取核心清洗脚本、回归脚本与关键变量定义，再更新 WORKSPACE 与研究模板
- Applies when: 新研究项目接入、外部项目导入、助研项目切换
- Avoid when: 仅做抽象方法讨论、没有真实代码或数据上下文
- Evidence: `2026-03-24 shi_kun_recall onboarding`
- Confidence: medium
- Status: stable
- Last reviewed: 2026-03-27
- Upgrade target: rule

### PREF-002
- Domain: identification
- Preference: 识别问题优先于估计细节
- Default action: 遇到 DiD / IV / RDD / Heckman 任务时，先确认识别假设、时间口径、处理定义和潜在偏误，再写估计代码
- Applies when: 因果识别、稳健性设计、审稿回应
- Avoid when: 纯描述性统计或排版任务
- Evidence: `rules/axioms/professor/p02_identification_before_estimation.md`; multiple DiD and recall-task audits
- Confidence: high
- Status: stable
- Last reviewed: 2026-03-27
- Upgrade target: none

## B. 写作与叙事

### PREF-003
- Domain: writing
- Preference: 先给问题-答案，再补证据和边界
- Default action: 所有研究写作默认按“核心结论 -> 证据 -> 边界 -> 下一步”组织首段
- Applies when: 引言、方法说明、结果解释、审稿回应
- Avoid when: 原始观察日志、素材堆叠区
- Evidence: `COMMUNICATION.md`; professor-track writing rules
- Confidence: high
- Status: stable
- Last reviewed: 2026-03-27
- Upgrade target: none

## C. 工作流与协作

### PREF-004
- Domain: workflow
- Preference: 研究任务先走 core skill index，再决定是否外扩
- Default action: 先查 `INDEX_RESEARCH_CORE.md`；若已覆盖任务，先用其中 skill，不立即扩展到总索引
- Applies when: 研究设计、实证分析、论文写作、结果表达
- Avoid when: 任务明显属于 API、自动化、报告发布、非研究外围工作
- Evidence: `AGENTS.md`, `rules/skills/INDEX.md`, `rules/skills/INDEX_RESEARCH_CORE.md`
- Confidence: high
- Status: stable
- Last reviewed: 2026-03-27
- Upgrade target: rule

### PREF-005
- Domain: workflow
- Preference: 战略管理 + DiD 类任务默认视为识别与估计任务
- Default action: 当任务描述同时出现“战略管理”和“DiD / event study / policy shock / staggered adoption”时，优先选择 `did-analysis` + `stata`
- Applies when: 政策冲击、事件研究、召回与组织学习等因果任务
- Avoid when: 纯文献综述、纯理论推导、仅润色写作
- Evidence: research-core routing validation on 2026-03-27
- Confidence: high
- Status: stable
- Last reviewed: 2026-03-27
- Upgrade target: none
