@echo off
setlocal
cd /d "%~dp0.."
if not exist "logs" mkdir "logs"
set PYTHONUTF8=1
set PYTHONIOENCODING=utf-8
set CODEX_CLI_PATH=C:\Users\admin\AppData\Roaming\npm\codex.cmd
set PATH=C:\Users\admin\AppData\Roaming\npm;%PATH%
set AI_HEARTBEAT_MODEL=gpt-5.4-mini
".venv\Scripts\python.exe" "periodic_jobs\ai_heartbeat\src\v0\observer.py" --backend codex >> "logs\ai_heartbeat_observer.log" 2>&1
