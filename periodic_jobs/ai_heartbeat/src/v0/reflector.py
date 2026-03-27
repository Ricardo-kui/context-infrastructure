#!/usr/bin/env python3
"""
L2 Reflector Agent (Trigger Script)

Asks OpenCode to turn weekly observations into a weekly reflection, update the
preference registry, and only promote to L3 when evidence is strong.
"""

from __future__ import annotations

import argparse
import os
from datetime import date, datetime, timedelta
from pathlib import Path

from opencode_client import OpenCodeClient

SCRIPT_PATH = Path(__file__).resolve()
WORKSPACE_ROOT = SCRIPT_PATH.parents[4]
KNOWLEDGE_BASE = WORKSPACE_ROOT / "periodic_jobs" / "ai_heartbeat" / "docs" / "KNOWLEDGE_BASE.md"
OBSERVATIONS_PATH = WORKSPACE_ROOT / "contexts" / "memory" / "OBSERVATIONS.md"
WEEKLY_TEMPLATE_PATH = WORKSPACE_ROOT / "contexts" / "memory" / "reflector_weekly_template.md"
WEEKLY_REFLECTIONS_PATH = WORKSPACE_ROOT / "contexts" / "memory" / "WEEKLY_REFLECTIONS.md"
PREFERENCE_REGISTRY_PATH = WORKSPACE_ROOT / "contexts" / "memory" / "PREFERENCE_REGISTRY.md"
PROMOTION_PROTOCOL_PATH = WORKSPACE_ROOT / "contexts" / "memory" / "MEMORY_PROMOTION_PROTOCOL.md"

DEFAULT_MODEL = os.getenv("OPENCODE_MODEL", "antigravity-gemini-3-flash")
DEFAULT_PROVIDER = os.getenv("OPENCODE_PROVIDER")
DEFAULT_AGENT = os.getenv("OPENCODE_AGENT", "OpenCode-Builder")

PROMPT_TEMPLATE = """
You are running the L2 Reflector stage for the context-infrastructure memory system.

Workspace root: {workspace_root}
Week of: {week_of}
Review window: {start_date} to {end_date}

Read these files before editing anything:
- {kb_path}
- {observations_path}
- {weekly_template_path}
- {weekly_reflections_path}
- {preferences_path}
- {promotion_protocol_path}

Required outputs:
1. Append one weekly reflection entry to {weekly_reflections_path} with the header:
   ## Week Of: {week_of}
2. Use the structure in {weekly_template_path}, but keep the final entry concise and evidence-based.
3. Update {preferences_path}:
   - add or revise preferences only when the promotion protocol is satisfied
   - prefer updating existing PREF-IDs over creating duplicates
   - fill in default action, applies when, avoid when, evidence, confidence, status, last reviewed, linked weekly reflection, and upgrade target
4. Only modify `rules/`, `axioms/`, or `skills/` if the evidence clearly exceeds preference level. When uncertain, keep the change in {preferences_path}.
5. Garbage collection should be conservative:
   - preserve the evidence trail in {observations_path}
   - only remove obviously temporary duplicate low-signal noise
   - never rewrite the entire file just to clean formatting

Focus first on these domains when reviewing the week:
- review / reviewer response
- identification / methodology
- writing / narrative
- workflow / tool routing
- collaboration / handoff

If you find no durable pattern, still append a weekly reflection entry explaining why nothing was promoted.

Return a short walkthrough covering:
- durable patterns found
- preference updates made
- any L3 promotions, or why none were justified
"""


def parse_iso_date(value: str) -> date:
    return datetime.strptime(value, "%Y-%m-%d").date()


def default_week_start(today: date | None = None) -> date:
    today = today or datetime.now().date()
    return today - timedelta(days=today.weekday())


def relative_path(path: Path) -> str:
    return path.relative_to(WORKSPACE_ROOT).as_posix()


def main() -> None:
    parser = argparse.ArgumentParser(description="L2 Reflector Agent")
    parser.add_argument(
        "week_of",
        nargs="?",
        default=default_week_start().isoformat(),
        help="Week start date (YYYY-MM-DD). Defaults to the current Monday.",
    )
    parser.add_argument(
        "--days",
        type=int,
        default=7,
        help="Number of days to review starting from week_of (default: 7).",
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
        "--force",
        action="store_true",
        help="Run even if WEEKLY_REFLECTIONS.md already has the same week header.",
    )
    args = parser.parse_args()

    week_of = parse_iso_date(args.week_of)
    review_days = max(args.days, 1)
    end_date = week_of + timedelta(days=review_days - 1)
    model_id = args.model
    provider_id = args.provider
    agent_name = args.agent

    if WEEKLY_REFLECTIONS_PATH.exists() and not args.force:
        content = WEEKLY_REFLECTIONS_PATH.read_text(encoding="utf-8")
        if f"## Week Of: {week_of.isoformat()}" in content:
            print(
                "Idempotent skip: weekly reflection already exists for "
                f"{week_of.isoformat()} in WEEKLY_REFLECTIONS.md"
            )
            return

    print(
        "Triggering L2 Reflector for review window "
        f"{week_of.isoformat()} -> {end_date.isoformat()} using model: {model_id}..."
    )
    client = OpenCodeClient()

    session_id = client.create_session(f"Heartbeat L2 Reflector - {week_of.isoformat()}")
    if not session_id:
        return

    prompt = PROMPT_TEMPLATE.format(
        workspace_root=WORKSPACE_ROOT,
        week_of=week_of.isoformat(),
        start_date=week_of.isoformat(),
        end_date=end_date.isoformat(),
        kb_path=relative_path(KNOWLEDGE_BASE),
        observations_path=relative_path(OBSERVATIONS_PATH),
        weekly_template_path=relative_path(WEEKLY_TEMPLATE_PATH),
        weekly_reflections_path=relative_path(WEEKLY_REFLECTIONS_PATH),
        preferences_path=relative_path(PREFERENCE_REGISTRY_PATH),
        promotion_protocol_path=relative_path(PROMOTION_PROTOCOL_PATH),
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
    print(f"Task complete (session {session_id}).")


if __name__ == "__main__":
    main()
