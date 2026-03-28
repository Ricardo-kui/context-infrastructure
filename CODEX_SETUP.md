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

## Keep the global install in sync

If you update `rules/`, `docs/`, or the setup notes in this repository, resync the global Codex install:

```powershell
powershell -ExecutionPolicy Bypass -File tools\sync_codex_context.ps1
```

This mirrors the managed files into:

- `C:\Users\admin\.codex\rules\context-infrastructure`

## Quick migration to another computer

You can export the current Codex setup into a zip bundle and import it on another Windows machine.

### What the migration bundle includes

- `C:\Users\admin\.codex\config.toml`
- `C:\Users\admin\.codex\AGENTS.md`
- `C:\Users\admin\.codex\skills`
- `C:\Users\admin\.codex\rules\context-infrastructure`
- `periodic_jobs\ai_heartbeat\config\PROJECT_PORTFOLIO.local.md`
- heartbeat schedule metadata

By default it does **not** include:

- `auth.json`
- caches, sessions, sqlite state, logs, temp files
- local memories unless you explicitly opt in

### Export on the current machine

```powershell
powershell -ExecutionPolicy Bypass -File tools\export_codex_setup.ps1
```

This creates a migration zip on the Desktop by default.

Optional flags:

```powershell
powershell -ExecutionPolicy Bypass -File tools\export_codex_setup.ps1 -IncludeAuth -IncludeMemories
```

### Import on the new machine

1. Copy the zip to the new machine.
2. Extract it anywhere.
3. Run the bundled import script:

```powershell
powershell -ExecutionPolicy Bypass -File .\import_codex_setup.ps1 -BundlePath .\codex-migration-YYYYMMDD-HHMMSS.zip
```

The import script will:

- restore the Codex config, AGENTS, skills, and installed rules
- try to clone the repo to the preferred path if it is missing
- reapply the local project portfolio
- resync the global install
- try to re-register the AI heartbeat tasks

### Post-import checklist

- Log in to Codex again if you did not export `auth.json`
- Recreate required API keys such as `SSY_API_KEY`
- Check whether OneDrive or sync-drive paths changed on the new machine
- If project roots differ, update `PROJECT_PORTFOLIO.local.md`
- If task registration needs S4U background mode, rerun the registration step from an elevated PowerShell window

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
