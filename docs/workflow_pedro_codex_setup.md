# Pedro Sant'Anna Workflow - Codex 适配部署说明

更新时间：2026-03-24

## 目标

基于 [Pedro H. C. Sant'Anna workflow guide](https://psantanna.com/claude-code-my-workflow/workflow-guide.html) 的核心机制，在当前 `context-infrastructure` 中完成可执行的 Codex 适配，而不是照搬 Claude 专属配置。

## 已落地内容

1. 新增可直接调用的工作流 skill：
   - `rules/skills/workflow_plan_first_contractor.md`
2. 在 Skills 索引中注册该 workflow：
   - `rules/skills/INDEX.md`
3. 在本仓库安装说明中加入该 workflow 的调用方式：
   - `CODEX_SETUP.md`

## 借鉴到的核心机制

1. Plan-First（先规格/后计划/再执行）
2. Contractor Loop（执行-验证-审计-修复循环）
3. Quality Gates（80/90/95 三档交付阈值）
4. Session Logging（关键决策写入记忆与审计文档）

## 不直接照搬的部分

1. `.claude/settings.json` hooks：当前环境优先用 `rules/ + contexts/ + tools/` 实现，不强依赖 Claude hook runtime。
2. Claude 专属 slash commands：改为 Codex 可读的 workflow 规范文件与可执行清单。

## 如何调用（在 Codex 中）

当你提出复杂任务时，直接说：

- “按 `workflow_plan_first_contractor` 跑这个任务。”
- “先做规格澄清，再出计划，按 80/90/95 质量门槛交付。”
- “进入 contractor 模式，做完后必须验证与审计。”

## 参考来源

- 指南网页：<https://psantanna.com/claude-code-my-workflow/workflow-guide.html>
- 上游仓库：<https://github.com/pedrohcgs/claude-code-my-workflow>
- 本地参考副本：`D:\Codex\claude-code-my-workflow-upstream`

