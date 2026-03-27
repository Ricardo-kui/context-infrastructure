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

from heartbeat_runtime import (
    WORKSPACE_ROOT,
    choose_backend,
    display_path,
    default_project_portfolio,
    parse_project_roots,
    run_codex_prompt,
    run_opencode_prompt,
)

KNOWLEDGE_BASE = WORKSPACE_ROOT / "periodic_jobs" / "ai_heartbeat" / "docs" / "KNOWLEDGE_BASE.md"
OBSERVATIONS_PATH = WORKSPACE_ROOT / "contexts" / "memory" / "OBSERVATIONS.md"
WEEKLY_REFLECTIONS_PATH = WORKSPACE_ROOT / "contexts" / "memory" / "WEEKLY_REFLECTIONS.md"
PREFERENCE_REGISTRY_PATH = WORKSPACE_ROOT / "contexts" / "memory" / "PREFERENCE_REGISTRY.md"

DEFAULT_MODEL = os.getenv("AI_HEARTBEAT_MODEL")
DEFAULT_PROVIDER = os.getenv("OPENCODE_PROVIDER")
DEFAULT_AGENT = os.getenv("OPENCODE_AGENT", "OpenCode-Builder")

PROMPT_TEMPLATE = """
You are running the L1 Observer stage for the context-infrastructure memory system.

Workspace root: {workspace_root}
Knowledge base: {kb_path}
Project portfolio: {project_portfolio_path}
Target date: {target_date}

Before writing anything:
1. Read the SOP at {kb_path}, then load the relevant global constraints it points to.
2. Read the monitored project portfolio at {project_portfolio_path}. Treat the listed `Root path` entries as the primary research scan roots.
3. Read {observations_path}. If it already contains `Date: {target_date}`, reply exactly:
   Entry for {target_date} already exists, skipping.
   and stop.
4. Stay within the L1 role. Do not edit {weekly_reflections_path}, {preferences_path}, or any file under `rules/`, `axioms/`, or `skills/`.

Task:
- Treat the listed project roots as the primary scan scope. Do not limit scanning to the memory repo itself.
- Use the context-infrastructure repo mainly for memory files, prompts, and configuration.
- Scan meaningful changes from the recent workspace activity. Prefer filesystem inspection and nested-repo awareness over a single top-level git diff.
- Ignore purely mechanical noise such as formatting-only churn, duplicate logs, and routine daily-record files.
- Append one new block to {observations_path} using this exact header:
  Date: {target_date}
- Keep each observation on one line and follow the existing traffic-light marker convention already used in {observations_path} (`High`, `Medium`, `Low`).
- When durable reuse is plausible, explicitly include one of these inline markers:
  - Pattern candidate:
  - Preference candidate:
  - Upgrade target: weekly | preference | rule | axiom | skill
- When citing files under monitored project roots, use absolute Windows paths and include the project identity when helpful.
- When citing files inside the context-infrastructure repo, use paths relative to the workspace root.

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
        "--backend",
        choices=["auto", "codex", "opencode"],
        default="auto",
        help="Execution backend to use (default: auto)",
    )
    parser.add_argument(
        "--portfolio",
        default=str(default_project_portfolio()),
        help="Path to the monitored project portfolio Markdown file",
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
    backend = choose_backend(args.backend)
    delete_after = not args.no_delete
    project_portfolio_path = Path(args.portfolio).resolve()
    monitored_roots = parse_project_roots(project_portfolio_path)

    if OBSERVATIONS_PATH.exists():
        content = OBSERVATIONS_PATH.read_text(encoding="utf-8")
        if f"Date: {target_date}" in content:
            print(f"Idempotent skip: entry for {target_date} already exists in OBSERVATIONS.md")
            return

    print(
        f"Triggering L1 Observer for date: {target_date} using model: {model_id} "
        f"via backend: {backend}..."
    )
    if monitored_roots:
        print(f"Monitored project roots: {len(monitored_roots)}")
    else:
        print("Warning: no monitored project roots were loaded from the portfolio file.")

    prompt = PROMPT_TEMPLATE.format(
        workspace_root=WORKSPACE_ROOT,
        kb_path=display_path(KNOWLEDGE_BASE),
        project_portfolio_path=display_path(project_portfolio_path),
        observations_path=display_path(OBSERVATIONS_PATH),
        weekly_reflections_path=display_path(WEEKLY_REFLECTIONS_PATH),
        preferences_path=display_path(PREFERENCE_REGISTRY_PATH),
        target_date=target_date,
    )
    if backend == "codex":
        run_codex_prompt(prompt, model_id=model_id, add_dirs=monitored_roots)
    else:
        run_opencode_prompt(
            prompt=prompt,
            session_title=f"Heartbeat L1 Observer - {target_date}",
            model_id=model_id,
            provider_id=provider_id,
            agent_name=agent_name,
            delete_after=delete_after,
        )


if __name__ == "__main__":
    main()
