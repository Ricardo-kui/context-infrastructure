# Preference Registry

用途：记录已经跨越单周观察阶段、但还不一定需要晋升为 `rules/` 或 `axioms/` 的稳定偏好。  
定位：这是 L2.5 层，介于 `OBSERVATIONS.md` 与 `rules/` 之间。

## 如何使用

- 新偏好先来自 `WEEKLY_REFLECTIONS.md` 中的周反思，而不是直接空想
- 优先更新已有 `PREF-ID`，避免同义重复条目
- 一个偏好至少要能回答：
  - 默认怎么做
  - 在什么条件下适用
  - 在什么边界下失效
  - 有哪些证据支持
- 当某条偏好已经成为跨项目硬约束，再考虑晋升到 `rules/`
- 当某条偏好具备高层哲学性和长期稳定性，再考虑晋升到 `axioms/`

## 维护节奏

- 每周反思：新增或更新 1-3 条偏好，优先处理最近两周重复出现的信号
- 每月回顾：检查 `stable` 条目是否仍然有效，必要时降级或退休
- 规则晋升：若某条偏好升到 `rules/`、`axioms/` 或 `skills/`，保留原条目并把 `Upgrade target` 与证据链写完整

## 条目格式

### PREF-XXX
- Domain: review | identification | measurement | writing | workflow | collaboration
- Preference:
- Default action:
- Applies when:
- Avoid when:
- Evidence:
- Confidence: low | medium | high
- Status: candidate | stable | retired
- Last reviewed:
- Upgrade target: none | rule | axiom | skill
- Linked weekly reflection:
- Notes:

---

## A. 审稿与回应

### PREF-001
- Domain: review
- Preference: 先回答审稿人最核心的识别威胁，再处理枝节评论
- Default action: 回应意见时先定位会影响因果解释、识别有效性或样本定义的主问题，再安排补充分析和文字润色
- Applies when: 审稿回复、导师反馈吸收、论文大修
- Avoid when: 只是做文风润色或格式修改
- Evidence: reviewer-style revisions on recall and DiD tasks; weekly reflection 2026-03-24
- Confidence: medium
- Status: candidate
- Last reviewed: 2026-03-27
- Upgrade target: none
- Linked weekly reflection: Week Of 2026-03-24
- Notes: 防止把时间花在礼貌性小修，而核心识别问题没有先落地

### PREF-002
- Domain: review
- Preference: 审稿回应默认采用 claim -> evidence -> change 顺序
- Default action: 每条回复先明确结论，再说明证据或新增分析，最后交代正文或附录做了什么修改
- Applies when: 审稿信、合作者反馈回应、老师逐条批注回复
- Avoid when: 内部脑暴阶段、尚未完成证据收集
- Evidence: professor-track writing rules; multiple response-drafting sessions
- Confidence: medium
- Status: candidate
- Last reviewed: 2026-03-27
- Upgrade target: none
- Linked weekly reflection: Week Of 2026-03-24
- Notes: 目的是压缩防御性叙述，减少解释很多但没有回答问题的情况

## B. 研究设计与识别

### PREF-003
- Domain: identification
- Preference: 先绑定真实项目代码与变量口径，再抽象规则
- Default action: 新项目接入时先读取核心清洗脚本、回归脚本与关键变量定义，再更新 WORKSPACE 与研究模板
- Applies when: 新研究项目接入、外部项目导入、助研项目切换
- Avoid when: 仅做抽象方法讨论、没有真实代码或数据上下文
- Evidence: `2026-03-24 shi_kun_recall onboarding`
- Confidence: medium
- Status: stable
- Last reviewed: 2026-03-27
- Upgrade target: rule
- Linked weekly reflection: Week Of 2026-03-24
- Notes: 优先锁定变量、时间和识别口径三张卡片，再抽象到规则层

### PREF-004
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
- Linked weekly reflection: Week Of 2026-03-24
- Notes: 这是高置信默认偏好，但目前已被更高层公理部分覆盖，无需重复升级

### PREF-005
- Domain: identification
- Preference: 对 event-study 与 staggered adoption 任务，默认先怀疑 TWFE 失真
- Default action: 先检查异质处理效应、动态效应和 cohort timing，再决定是否使用 TWFE 作为主估计或仅作对照
- Applies when: DiD、政策冲击、分期实施、事件研究
- Avoid when: 处理在同一期同时发生、仅做教学示例
- Evidence: `rules/skills/INDEX_RESEARCH_CORE.md`; DiD routing validation on 2026-03-27
- Confidence: high
- Status: stable
- Last reviewed: 2026-03-27
- Upgrade target: skill
- Linked weekly reflection: Week Of 2026-03-24
- Notes: 若后续形成固定检查清单，可继续晋升到更显式的 DiD workflow skill

## C. 写作与叙事

### PREF-006
- Domain: writing
- Preference: 先给问题和答案，再补证据和边界
- Default action: 所有研究写作默认按核心结论 -> 证据 -> 边界 -> 下一步组织首段
- Applies when: 引言、方法说明、结果解释、审稿回应
- Avoid when: 原始观察日志、素材堆叠区
- Evidence: `COMMUNICATION.md`; professor-track writing rules
- Confidence: high
- Status: stable
- Last reviewed: 2026-03-27
- Upgrade target: none
- Linked weekly reflection: Week Of 2026-03-24
- Notes: 用于压制背景很长、答案很晚出现的写作惯性

### PREF-007
- Domain: writing
- Preference: 每一段只承担一个主结论，证据服务于该结论
- Default action: 起草或改写段落时先写一句可被审稿人复述的主句，再决定哪些证据留在正文、哪些挪到附录
- Applies when: 结果解释、机制讨论、审稿回复
- Avoid when: 素材收集笔记、开放式头脑风暴
- Evidence: multiple thesis-writing and response-drafting sessions
- Confidence: medium
- Status: candidate
- Last reviewed: 2026-03-27
- Upgrade target: none
- Linked weekly reflection: Week Of 2026-03-24
- Notes: 目标是减少一段内同时讲识别、结果、贡献三件事的拥挤结构

## D. 工作流与工具路由

### PREF-008
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
- Linked weekly reflection: Week Of 2026-03-24
- Notes: 作用是减少技能过载，先走核心默认路径

### PREF-009
- Domain: workflow
- Preference: 战略管理 + DiD 类任务默认视为识别与估计任务
- Default action: 当任务描述同时出现战略管理和 DiD / event study / policy shock / staggered adoption 时，优先选择 `did-analysis` + `stata`
- Applies when: 政策冲击、事件研究、召回与组织学习等因果任务
- Avoid when: 纯文献综述、纯理论推导、仅润色写作
- Evidence: research-core routing validation on 2026-03-27
- Confidence: high
- Status: stable
- Last reviewed: 2026-03-27
- Upgrade target: none
- Linked weekly reflection: Week Of 2026-03-24
- Notes: 若未来出现 R 主流程项目，再补一个语言选择的边界条件

## E. 协作与交接

### PREF-010
- Domain: collaboration
- Preference: 协作任务先绑定交付物、源文件和决策边界，再开始执行
- Default action: 分派任务时显式写清输出文件、需要读取的核心源文件、哪些判断可以自主决定、哪些必须升级确认
- Applies when: 助研协作、代理式研究任务、跨仓库接手
- Avoid when: 单人快速试验、一次性草稿探索
- Evidence: repeated onboarding and context-handoff friction across research tasks
- Confidence: medium
- Status: candidate
- Last reviewed: 2026-03-27
- Upgrade target: rule
- Linked weekly reflection: Week Of 2026-03-24
- Notes: 目的是降低做了很多，但和真正要的交付不对齐的返工

### PREF-011
- Domain: collaboration
- Preference: 高不确定性任务要尽早暴露假设，而不是把假设埋在最终结果里
- Default action: 当数据结构、识别口径或写作目标不明确时，在早期更新中先写假设和风险，再继续推进
- Applies when: 新项目接入、审稿回应重构、跨团队协作
- Avoid when: 路径和交付已经高度确定
- Evidence: multiple Codex collaboration cycles on context-infrastructure and research tasks
- Confidence: medium
- Status: candidate
- Last reviewed: 2026-03-27
- Upgrade target: none
- Linked weekly reflection: Week Of 2026-03-24
- Notes: 这条偏好和沟通风格有关，但目前仍更适合留在 L2.5 而不是直接写进公理
