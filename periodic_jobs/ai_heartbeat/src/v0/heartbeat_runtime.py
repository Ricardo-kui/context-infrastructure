from __future__ import annotations

import os
import shutil
import socket
import subprocess
from pathlib import Path
from typing import Iterable
from urllib.parse import urlparse

SCRIPT_PATH = Path(__file__).resolve()
WORKSPACE_ROOT = SCRIPT_PATH.parents[4]
CONFIG_DIR = WORKSPACE_ROOT / "periodic_jobs" / "ai_heartbeat" / "config"
PROJECT_PORTFOLIO_LOCAL = CONFIG_DIR / "PROJECT_PORTFOLIO.local.md"
PROJECT_PORTFOLIO_EXAMPLE = CONFIG_DIR / "PROJECT_PORTFOLIO.example.md"


def default_project_portfolio() -> Path:
    if PROJECT_PORTFOLIO_LOCAL.exists():
        return PROJECT_PORTFOLIO_LOCAL
    return PROJECT_PORTFOLIO_EXAMPLE


def read_markdown(path: Path) -> str:
    return path.read_text(encoding="utf-8-sig")


def parse_project_roots(portfolio_path: Path) -> list[Path]:
    roots: list[Path] = []
    if not portfolio_path.exists():
        return roots

    for raw_line in read_markdown(portfolio_path).splitlines():
        line = raw_line.strip()
        if not line.lower().startswith("- root path:"):
            continue
        root_value = line.split(":", 1)[1].strip()
        if not root_value:
            continue
        root_path = Path(root_value)
        if root_path.exists():
            roots.append(root_path)
        else:
            print(f"Warning: monitored project root does not exist and will be skipped: {root_path}")
    return roots


def relative_to_workspace(path: Path) -> str:
    return path.relative_to(WORKSPACE_ROOT).as_posix()


def display_path(path: Path) -> str:
    try:
        return relative_to_workspace(path)
    except ValueError:
        return str(path)


def detect_opencode_backend() -> bool:
    base_url = os.getenv("OPENCODE_BASE_URL", "http://localhost:4096")
    password = os.getenv("OPENCODE_PASSWORD")
    if not password:
        return False

    parsed = urlparse(base_url)
    host = parsed.hostname or "localhost"
    port = parsed.port or (443 if parsed.scheme == "https" else 80)
    try:
        with socket.create_connection((host, port), timeout=2):
            return True
    except OSError:
        return False


def detect_codex_command() -> list[str] | None:
    explicit = os.getenv("CODEX_CLI_PATH")
    candidates = [explicit] if explicit else []
    candidates.extend(
        [
            shutil.which("codex.cmd"),
            shutil.which("codex.exe"),
            shutil.which("codex"),
        ]
    )

    for candidate in candidates:
        if not candidate:
            continue
        candidate_path = Path(candidate)
        suffix = candidate_path.suffix.lower()
        if suffix in {".cmd", ".bat"}:
            return ["cmd.exe", "/c", str(candidate_path)]
        return [str(candidate_path)]
    return None


def choose_backend(requested_backend: str) -> str:
    if requested_backend != "auto":
        return requested_backend
    if detect_opencode_backend():
        return "opencode"
    if detect_codex_command():
        return "codex"
    raise RuntimeError("Neither OpenCode nor Codex CLI backend is available.")


def run_codex_prompt(
    prompt: str,
    model_id: str | None = None,
    add_dirs: Iterable[Path] | None = None,
) -> None:
    codex_command = detect_codex_command()
    if not codex_command:
        raise RuntimeError("Codex CLI command could not be found.")

    command = [
        *codex_command,
        "exec",
        "--dangerously-bypass-approvals-and-sandbox",
        "--color",
        "never",
        "-C",
        str(WORKSPACE_ROOT),
    ]
    if model_id:
        command.extend(["-m", model_id])
    for add_dir in add_dirs or []:
        command.extend(["--add-dir", str(add_dir)])

    print(f"Using Codex CLI backend: {' '.join(codex_command)}")
    completed = subprocess.run(
        command,
        cwd=WORKSPACE_ROOT,
        input=prompt,
        text=True,
        check=False,
    )
    if completed.returncode != 0:
        raise RuntimeError(f"Codex CLI exited with status {completed.returncode}.")


def run_opencode_prompt(
    prompt: str,
    session_title: str,
    model_id: str,
    provider_id: str | None,
    agent_name: str,
    delete_after: bool | None = None,
) -> None:
    from opencode_client import OpenCodeClient

    client = OpenCodeClient()
    session_id = client.create_session(session_title)
    if not session_id:
        raise RuntimeError("OpenCode session could not be created.")

    client.send_message(
        session_id,
        prompt,
        model_id=model_id,
        provider_id=provider_id,
        agent=agent_name,
    )
    print("Waiting for session to complete (sync mode)...")
    client.wait_for_session_complete(session_id)

    if delete_after is True:
        if client.delete_session(session_id):
            print(f"Task complete (session {session_id} deleted).")
        else:
            print(f"Task complete (session {session_id} kept because delete failed).")
    elif delete_after is False:
        print(f"Task complete (session {session_id} kept).")
    else:
        print(f"Task complete (session {session_id}).")
