# Workflow: Plan-First Contractor Loop（Codex 适配）

## When to Use

适用于复杂且高风险任务，尤其是：

1. 计量识别设计与实证代码改造（DiD / 事件研究 / IV / Heckman 等）
2. 论文关键章节重写（引言、识别策略、机制、稳健性）
3. 多文件联动改造（规则、脚本、文档、结果口径同步）

## Core Protocol

### Step 0 - 任务分级

先判断是否进入“复杂任务模式”：

- 若任务涉及多个文件、多个决策点、或存在识别风险，则进入本 workflow
- 否则按普通快速模式处理

### Step 1 - 规格澄清（Spec First）

在动手前先输出四件事（可简短）：

1. 目标结果（最终可交付物是什么）
2. 约束条件（数据、口径、时间、风格、工具限制）
3. 完成标准（怎样算 done）
4. 风险清单（最可能出错的 3-5 点）

### Step 2 - 执行计划（Plan）

按“主线优先、可并行次之”拆解步骤：

1. 关键路径（必须先完成）
2. 可并行路径（不阻塞主线）
3. 每步验证点（执行完如何确认）

### Step 3 - Contractor Loop（执行闭环）

按以下循环推进，直到达到阈值：

1. Implement：实施修改
2. Verify：运行验证（命令/日志/结果表）
3. Audit：对照口径和目标做审计
4. Fix：修复偏差并复验

## Quality Gates（交付门槛）

1. `80`：可保存（无关键错误，主线可复现）
2. `90`：可汇报（识别口径一致，主要稳健性覆盖）
3. `95`：投稿级（叙事、识别、证据链高度统一）

默认目标：至少达到 `90`，除非用户明确说先出草稿。

## Required Outputs

每次复杂任务至少产出：

1. 变更清单（改了什么、为什么改）
2. 验证记录（跑了什么、结果如何）
3. 风险余项（还没覆盖的威胁与下一步）

## Memory Update Rule

当出现“错误->修正->确认”闭环时，写入：

- `contexts/memory/observations_professor.md`（L1 观察）
- 必要时抽象为 `rules/axioms/professor/` 新公理

## Quick Invocation Phrases

用户可直接说：

1. “按 Plan-First Contractor Loop 来做。”
2. “先出规格和计划，再执行和验证。”
3. “按 80/90/95 门槛交付，先做到 90。”

## Source

本 workflow 借鉴自 Pedro H. C. Sant'Anna 的 Claude Code workflow（已做 Codex 环境适配）：

- <https://psantanna.com/claude-code-my-workflow/workflow-guide.html>
- <https://github.com/pedrohcgs/claude-code-my-workflow>

