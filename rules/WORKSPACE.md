# WORKSPACE.md - 战略管理研究项目目录路由模板

目标：让 AI 在每次会话中，优先命中正确目录与文件，减少“找文件”和“路径误判”。

使用规则：开始检索前先看本文件；新增目录后及时更新本文件。

## 一、标准目录（建议新项目直接采用）

```text
<project_root>/
  docs/
    research_design/                # 研究设计、识别策略说明
    literature_notes/               # 文献笔记与理论综述
    meeting_notes/                  # 组会/讨论记录
    submission/                     # 投稿材料（cover letter、response letter）
  data/
    raw/                            # 原始数据（只读，不覆盖）
    interim/                        # 中间清洗数据
    processed/                      # 可直接建模的数据
    external_policy/                # 外部政策冲击、制度变化数据
  code/
    python/                         # Python 脚本（清洗、建模、可视化）
    stata/                          # Stata do 文件
    shared/                         # 跨语言通用函数与配置
  models/
    baseline/                       # 基准模型
    robustness/                     # 稳健性检验
    heterogeneity/                  # 异质性分析
    mechanism/                      # 机制检验
  outputs/
    tables/                         # 回归表、描述统计表
    figures/                        # 图（event study、系数图等）
    logs/                           # 运行日志
    appendices/                     # 附录产出
  papers/
    main/                           # 主论文（LaTeX/Word）
    sections/                       # 引言/理论/方法/结果分章草稿
    revisions/                      # 版本迭代记录
  replication/
    package/                        # 复现包（代码+数据映射+说明）
    README.md                       # 复现说明
  adhoc_jobs/                       # 临时任务（一次性）
  contexts/
    survey_sessions/                # 调研与专题扫描
    thought_review/                 # 方法反思与复盘
    daily_records/                  # 日常记录
    memory/                         # 记忆系统
  rules/
    skills/                         # 可复用技能
    axioms/                         # 决策公理
```

## 二、路由规则（AI 执行时优先级）

### 1) 研究问题与识别策略
- 研究设定、识别假设、变量定义：`docs/research_design/`
- DiD/IV/RDD/PSM 方法说明与边界：`docs/research_design/` + `models/`

### 2) 数据处理
- 原始数据读取：`data/raw/`
- 清洗与匹配：`code/python/` 或 `code/stata/`，输出到 `data/interim/`
- 建模用数据：`data/processed/`

### 3) 计量估计与稳健性
- 基准估计：`models/baseline/`
- 稳健性、安慰剂、替代口径：`models/robustness/`
- 异质性与机制：`models/heterogeneity/`、`models/mechanism/`

### 4) 结果与写作
- 回归表与图：`outputs/tables/`、`outputs/figures/`
- 论文正文：`papers/main/` 与 `papers/sections/`
- 投稿与返修：`docs/submission/`、`papers/revisions/`

### 5) 复现与对外交付
- 复现包：`replication/package/`
- 复现说明：`replication/README.md`

## 三、命名规范（保证可检索与可复现）

- 文件/目录统一：`snake_case`
- 日期统一：`YYYY-MM-DD`
- 回归输出建议：
  - 表：`tbl_<topic>_<model>.csv|tex`
  - 图：`fig_<topic>_<variant>.png|pdf`
  - 日志：`log_<task>_<date>.txt`
- 数据版本建议：`vYYYYMMDD`

## 四、执行规范（默认）

- 不覆盖 `data/raw/` 原始数据
- 每次估计在 `outputs/logs/` 生成日志
- 关键结论必须可追溯到：
  - 对应数据文件
  - 对应代码脚本
  - 对应输出表图

## 五、教授研究场景快捷路由

- 产品召回与组织学习主线：`docs/research_design/` + `models/` + `papers/sections/`
- 外部政策冲击 DiD：`data/external_policy/` + `models/baseline/` + `models/robustness/`
- Multi-agent 实验记录：`contexts/thought_review/` 或 `docs/meeting_notes/`

## 六、活跃项目映射（按需维护）

在这里维护项目别名到路径的映射，便于快速跳转。

示例：
- `recall_did_2026` -> `adhoc_jobs/recall_did_2026/`
- `org_learning_policy_shock` -> `adhoc_jobs/org_learning_policy_shock/`
- `shi_kun_recall` -> `D:\Onedrive\研究设计与汇报\施坤\`
- `shi_kun_regression` -> `D:\Onedrive\研究设计与汇报\施坤\code\2_regression_event_delay.do`
- `shi_kun_dataclean` -> `D:\Onedrive\研究设计与汇报\施坤\code\0_dataclean_ceo_rf.do`

## 七、一键创建新项目骨架

可用脚本：`tools/scaffold_research_project.ps1`

示例：

```powershell
powershell -ExecutionPolicy Bypass -File tools\scaffold_research_project.ps1 -ProjectName recall_did_2026
```

可选参数：
- `-BaseDir`：指定项目根目录（默认 `D:\Codex\projects`）
- `-Force`：已存在目录时继续并覆盖模板文件
