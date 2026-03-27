# Project Onboarding - 施坤（2026-03-24）

## 项目路径

- Root: `D:\Onedrive\研究设计与汇报\施坤`
- 数据清洗脚本: `D:\Onedrive\研究设计与汇报\施坤\code\0_dataclean_ceo_rf.do`
- 回归脚本: `D:\Onedrive\研究设计与汇报\施坤\code\2_regression_event_delay.do`

## 当前识别与建模框架（从脚本读取）

- 研究主题：CEO Regulatory Focus 与 Product Recall Timing
- 结果变量：`Recall_time = ln(Recall_days + 1)`（事件层）
- 核心解释变量：`CEO_promotion_focus`, `CEO_prevention_focus`（ZCA 标准化）
- 调节变量：`recall_midorhigh`（Class I/II）
- 主方法：`reghdfe` OLS + 多组稳健性
- 样本选择偏差：Heckman（两阶段 + IMR）单列到附录（Table A15）

## 关键口径提示（脚本已明确）

1. `fyear` 口径是 `FirmAwarenessDate` 的日历年，而非召回发起日年。  
2. 滚动窗口变量（如 `Recall_experience3`）以“知晓年”计。  
3. 年固定效应与日历年维度（如气压等日历数据）对齐。  
4. 若论文文本强调财年，需要显式说明与 Compustat `fyear` 的口径差异。

## 第一轮风险清单（供后续深挖）

1. 事件层与 firm-year 变量合并时的时间对齐误差风险。  
2. 低严重性子样本中 `recall_class1` 常量问题（脚本已注记移除）。  
3. Heckman 选择方程变量边界是否与主回归识别逻辑完全一致。  
4. 反向因果检验内的口径一致性（firm/CEO/TMT/board 控制当期值）。

## 推荐下一步（实操顺序）

1. 先跑 `0_dataclean_ceo_rf.do` 产出最新中间数据并记录日志。  
2. 再跑 `2_regression_event_delay.do` 基准回归与核心稳健性。  
3. 生成“主结果 + 关键稳健性 + 识别口径说明”三段式周报。  
4. 将本周决策与异常写入 `contexts/memory/observations_professor.md`。
