#!/usr/bin/env python3
"""
L1 Observer Agent (Trigger Script)

Asks OpenCode to scan recent workspace changes and append a dated block to
contexts/memory/OBSERVATIONS.md.
"""

from __future__ import annotations

import argparse
import os
from datetime import datetime
from pathlib import Path

from opencode_client import OpenCodeClient

SCRIPT_PATH = Path(__file__).resolve()
WORKSPACE_ROOT = SCRIPT_PATH.parents[4]
KNOWLEDGE_BASE = WORKSPACE_ROOT / "periodic_jobs" / "ai_heartbeat" / "docs" / "KNOWLEDGE_BASE.md"
OBSERVATIONS_PATH = WORKSPACE_ROOT / "contexts" / "memory" / "OBSERVATIONS.md"
WEEKLY_REFLECTIONS_PATH = WORKSPACE_ROOT / "contexts" / "memory" / "WEEKLY_REFLECTIONS.md"
PREFERENCE_REGISTRY_PATH = WORKSPACE_ROOT / "contexts" / "memory" / "PREFERENCE_REGISTRY.md"

DEFAULT_MODEL = os.getenv("OPENCODE_MODEL", "antigravity-gemini-3-flash")
DEFAULT_PROVIDER = os.getenv("OPENCODE_PROVIDER")
DEFAULT_AGENT = os.getenv("OPENCODE_AGENT", "OpenCode-Builder")

PROMPT_TEMPLATE = """
You are running the L1 Observer stage for the context-infrastructure memory system.

Workspace root: {workspace_root}
Knowledge base: {kb_path}
Target date: {target_date}

Before writing anything:
1. Read the SOP at {kb_path}, then load the relevant global constraints it points to.
2. Read {observations_path}. If it already contains `Date: {target_date}`, reply exactly:
   Entry for {target_date} already exists, skipping.
   and stop.
3. Stay within the L1 role. Do not edit {weekly_reflections_path}, {preferences_path}, or any file under `rules/`, `axioms/`, or `skills/`.

Task:
- Scan meaningful changes from the recent workspace activity. Prefer filesystem inspection and nested-repo awareness over a single top-level git diff.
- Ignore purely mechanical noise such as formatting-only churn, duplicate logs, and routine daily-record files.
- Append one new block to {observations_path} using this exact header:
  Date: {target_date}
- Keep each observation on one line and follow the existing traffic-light marker convention already used in {observations_path} (`High`, `Medium`, `Low`).
- When durable reuse is plausible, explicitly include one of these inline markers:
  - Pattern candidate:
  - Preference candidate:
  - Upgrade target: weekly | preference | rule | axiom | skill
- Mention files using paths relative to the workspace root.

Report back with a short walkthrough covering:
- projects or folders scanned
- strong signals kept
- obvious noise filtered out
"""


def parse_iso_date(value: str) -> str:
    return datetime.strptime(value, "%Y-%m-%d").date().isoformat()


def relative_path(path: Path) -> str:
    return path.relative_to(WORKSPACE_ROOT).as_posix()


def main() -> None:
    parser = argparse.ArgumentParser(description="L1 Observer Agent")
    parser.add_argument(
        "date",
        nargs="?",
        default=datetime.now().strftime("%Y-%m-%d"),
        help="Target date (YYYY-MM-DD)",
    )
    parser.add_argument(
        "--model",
        default=DEFAULT_MODEL,
        help="Model ID to use",
    )
    parser.add_argument(
        "--provider",
        default=DEFAULT_PROVIDER,
        help="Provider ID override (optional)",
    )
    parser.add_argument(
        "--agent",
        default=DEFAULT_AGENT,
        help="Agent identity to use",
    )
    parser.add_argument(
        "--no-delete",
        action="store_true",
        help="Keep session after completion (default: delete)",
    )
    args = parser.parse_args()

    target_date = parse_iso_date(args.date)
    model_id = args.model
    provider_id = args.provider
    agent_name = args.agent
    delete_after = not args.no_delete

    if OBSERVATIONS_PATH.exists():
        content = OBSERVATIONS_PATH.read_text(encoding="utf-8")
        if f"Date: {target_date}" in content:
            print(f"Idempotent skip: entry for {target_date} already exists in OBSERVATIONS.md")
            return

    print(f"Triggering L1 Observer for date: {target_date} using model: {model_id}...")
    client = OpenCodeClient()

    session_id = client.create_session(f"Heartbeat L1 Observer - {target_date}")
    if not session_id:
        return

    prompt = PROMPT_TEMPLATE.format(
        workspace_root=WORKSPACE_ROOT,
        kb_path=relative_path(KNOWLEDGE_BASE),
        observations_path=relative_path(OBSERVATIONS_PATH),
        weekly_reflections_path=relative_path(WEEKLY_REFLECTIONS_PATH),
        preferences_path=relative_path(PREFERENCE_REGISTRY_PATH),
        target_date=target_date,
    )
    client.send_message(
        session_id,
        prompt,
        model_id=model_id,
        provider_id=provider_id,
        agent=agent_name,
    )
    print("Waiting for session to complete (sync mode)...")
    client.wait_for_session_complete(session_id)

    if delete_after:
        if client.delete_session(session_id):
            print(f"Task complete (session {session_id} deleted).")
        else:
            print(f"Task complete (session {session_id} kept because delete failed).")
    else:
        print(f"Task complete (session {session_id} kept).")


if __name__ == "__main__":
    main()
