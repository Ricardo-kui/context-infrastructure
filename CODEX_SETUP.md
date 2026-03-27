# Codex Setup Notes

This repository can be applied in Codex as a workspace-level context system.

## Completed in this environment

- Repository cloned to: `D:\Codex\context-infrastructure`
- `.env` created from `.env.example`
- Rules synced to: `C:\Users\admin\.codex\rules\context-infrastructure`

## How to use in Codex

1. Open/work in this workspace: `D:\Codex\context-infrastructure`
2. Start from `AGENTS.md`
3. Fill in personal profile:
   - `rules/USER.md`
   - `rules/SOUL.md` (optional but recommended)
4. Follow `setup_guide.md` for periodic jobs and Tier-2 tools

## Borrowed Workflow (Pedro Sant'Anna) - Installed

A Codex-adapted version of the "plan-first + contractor loop" workflow has been added.

- Overview doc: `docs/workflow_pedro_codex_setup.md`
- Runnable skill: `rules/skills/workflow_plan_first_contractor.md`

You can invoke it in plain language, for example:

- "按 workflow_plan_first_contractor 跑这个任务"
- "先规格澄清再计划，再执行验证，按 90 分门槛交付"
- "进入 contractor 模式处理这个项目"

## Prerequisite gap on this machine

Python is not installed in the current environment (`python`/`py` commands not found), so script-based tools are not runnable yet.

When Python is available, install dependencies:

```powershell
cd D:\Codex\context-infrastructure
python -m venv .venv
.\.venv\Scripts\activate
pip install -r tools\requirements.txt
```
