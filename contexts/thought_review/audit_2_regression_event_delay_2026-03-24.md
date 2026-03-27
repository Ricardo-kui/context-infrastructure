# 识别一致性审计：2_regression_event_delay.do（2026-03-24）

审计对象：`D:\Onedrive\研究设计与汇报\施坤\code\2_regression_event_delay.do`  
关联清洗脚本：`D:\Onedrive\研究设计与汇报\施坤\code\0_dataclean_ceo_rf.do`

---

## 一、关键发现（按严重性排序）

## [P0] Heckman 第一阶段的排他性变量与年份固定效应共线，识别失效风险高

- 位置：`2_regression_event_delay.do:318`, `2_regression_event_delay.do:325`
- 现状：选择方程同时放入 `FDASIA = (fyear>=2013)` 和 `i.fyear`。
- 问题：`FDASIA` 本质是年份函数，与完整年份虚拟变量高度（理论上完全）共线，Stata 会丢掉该变量或使其无识别贡献。这样 IMR 的“排他性约束”事实上不成立。
- 影响：Table A15 的样本选择修正识别基础不稳，解释力度显著下降。

## [P0] “近期召回”变量使用 `interval(fyear -2 0)`，包含当年信息，存在后视/同年前视污染

- 位置：
  - `2_regression_event_delay.do:164-165`
  - `0_dataclean_ceo_rf.do:1023-1028`
- 现状：`Recall_experience3` / `Recall_peer3` 包含当年（`0`）窗口。
- 问题：分析单位是事件层，若同年多事件，这些变量可能包含“同年晚于当前事件”的信息，甚至机械包含同年事件总量，违反“信息可得性时点”。
- 影响：主回归中的召回经验控制变量可能成为后处理变量（post-treatment）或引入 look-ahead bias。

## [P1] IMR 以 firm-year 估计并合并到 event-level，第二阶段单位不一致

- 位置：
  - IMR 生成：`2_regression_event_delay.do:311-338`
  - 合并到事件层：`2_regression_event_delay.do:1376`
- 现状：第一阶段在 firm-year 上估计 `recall_any`，第二阶段在 recall-event 上回归。
- 问题：同一 `gvkey-fyear` 的多个事件共享同一个 IMR，导致二阶段“选择机制单位”和“结果方程单位”不一致，不是标准 Heckman two-step 的经典设定。
- 影响：A15 的系数解释与标准误含义需谨慎，可能高估修正效果。

## [P1] 反向因果检验使用当期 recall 指标解释当期 CEO 特征，时序不够严格

- 位置：`2_regression_event_delay.do:698-746`
- 现状：A4 回归使用同年 `Recall_count` / `Recall_avg_time_all` 解释同年 CEO focus。
- 问题：这更像“同时性相关”检验，不是严格的 reverse causality 检验（应至少使用滞后 recall 指标或事件前窗口）。
- 影响：A4 中“insignificant alleviates reverse causality concerns”证据强度偏弱（`2_regression_event_delay.do:761`）。

## [P2] MICE 采用 `add(1)` 并 `mi extract 1` 覆盖原变量，未传播插补不确定性

- 位置：`2_regression_event_delay.do:257-294`
- 现状：链式插补后只抽一套数据用于后续分析。
- 问题：这是单次随机插补，不是 Rubin 合并；若作为“稳健性”可接受，但不能当作标准 MI 推断结果。
- 影响：如在文中呈现为 MI 结果，可能低估方差并夸大精度。

## [P2] 统一样本由 full-spec e(sample) 定义，样本流失未被系统报告

- 位置：`2_regression_event_delay.do:298-300`
- 现状：先跑 full model，再 `keep if e(sample)==1` 作为后续分析样本。
- 问题：做法本身可以用于保持可比性，但需明确报告流失比例与流失结构，否则有样本选择解释风险。
- 影响：Table 3 及后续稳健性的“外推性”会被审稿人追问。

---

## 二、口径一致性评估

## 已对齐（优点）

- `fyear` 口径在两份脚本中都明确为 `FirmAwarenessDate` 日历年（非发起日年）。  
- 事件层与 firm-year 合并键逻辑一致（`gvkey × fyear`）。
- 主回归与大部分稳健性使用同一控制变量主集（`ctrl_core`）。

## 未完全闭环（风险）

- “近期召回”窗口与事件时点信息边界未完全一致（见 P0）。
- Heckman 单位层级（firm-year vs event）未做明确方法辩护（见 P1）。

---

## 三、可执行修订清单（建议按顺序）

## Step 1（本周必须）：修复选择方程识别

1. 在 `probit recall_any ... i.fyear` 中移除 `FDASIA`，或移除 `i.fyear` 后仅保留更粗时间趋势（例如行业×线性趋势）并论证。  
2. 若坚持排他变量思路，改用真正不与年份 FE 共线的变量（且有理论支持）。

完成标准：
- `estat vce, corr` / 回归输出中排他变量不被自动剔除；
- 文稿中明确写出 exclusion restriction 逻辑。

## Step 2（本周必须）：重构“近期召回”为严格前期信息

1. 将窗口从 `interval(fyear -2 0)` 改为 `interval(fyear -3 -1)`（或同义实现），确保不含当年。  
2. 在事件层进一步校验：变量不应使用事件发生后信息。

完成标准：
- 变量标签改为“past 3 completed awareness years”；
- 主结果与旧口径并排报告一次（作为口径稳健性）。

## Step 3（下周）：重做样本选择修正的单位一致性

可选方案二选一：

- A 方案（推荐）：把 A15 改为 firm-year 结果方程（如年均时滞/是否超阈值时滞），与 selection 方程同单位。  
- B 方案：保留 event-level 主分析，但将 A15 定位为“近似诊断”，并在文中降级解读强度。

完成标准：
- 方法附录中明确两阶段单位定义与限制。

## Step 4（下周）：强化反向因果设计

1. 将 A4 的解释变量改为滞后 recall 指标（`t-1` 或 `t-2`）。  
2. 增加“lead RF 不预测过去 recall”或“事件前窗口”检验。

完成标准：
- 反向因果结论基于时序而非“同年不显著”。

## Step 5（可并行）：规范 MI 与样本流失披露

1. MI 结果若保留，明确标注“single imputation robustness only”。  
2. 增加样本流失表：从原始事件样本到 e(sample) 的逐步 N 变化。

完成标准：
- 附录新增 `Sample Attrition Table`；
- MI 表注释不再暗示 Rubin 级别推断。

---

## 四、建议新增输出文件（便于审稿）

1. `TableAx_sample_attrition.rtf`：样本流失追踪。  
2. `TableAx_timing_consistent_controls.rtf`：当年窗口 vs 严格滞后窗口对比。  
3. `TableAx_selection_unit_check.rtf`：firm-year 与 event-level 修正结果对照。  
4. `Appendix_note_identification_scope.md`：明确可识别边界与不能声称的因果强度。
