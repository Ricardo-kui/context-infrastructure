@echo off
setlocal
cd /d "%~dp0.."
if not exist "logs" mkdir "logs"
set PYTHONUTF8=1
".venv\Scripts\python.exe" "periodic_jobs\ai_heartbeat\src\v0\observer.py" --backend codex >> "logs\ai_heartbeat_observer.log" 2>&1
