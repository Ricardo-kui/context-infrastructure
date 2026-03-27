#!/usr/bin/env python3
"""
CLI bridge to a ChromaDB RAG system.

Usage:
    python query_rag.py "What does Mutz (2018) find about status threat?"
    python query_rag.py "parallel trends assumption" --top-k 10
    python query_rag.py --stats

RAG directory resolution order:
1) ACADEMIC_WRITING_RAG_DIR env var
2) RAG_DIR env var
3) <repo>/references/RAG (relative auto-discovery)
"""

import sys
import json
import argparse
import os
from pathlib import Path

LEGACY_RAG_DIR = Path("/Users/alessandro/Projects/Tesi/thesis/references/RAG")


def resolve_rag_dir() -> Path:
    """Resolve RAG directory from env vars or relative project layout."""
    env_rag = (
        Path((os.environ.get("ACADEMIC_WRITING_RAG_DIR") or "").strip())
        if (os.environ.get("ACADEMIC_WRITING_RAG_DIR") or "").strip()
        else None
    )
    if env_rag and env_rag.exists():
        return env_rag

    env_rag_fallback = (
        Path((os.environ.get("RAG_DIR") or "").strip())
        if (os.environ.get("RAG_DIR") or "").strip()
        else None
    )
    if env_rag_fallback and env_rag_fallback.exists():
        return env_rag_fallback

    repo_root = Path(__file__).resolve().parents[4]
    relative_candidate = repo_root / "references" / "RAG"
    if relative_candidate.exists():
        return relative_candidate

    if LEGACY_RAG_DIR.exists():
        return LEGACY_RAG_DIR

    raise FileNotFoundError(
        "RAG directory not found. Set ACADEMIC_WRITING_RAG_DIR (preferred) or RAG_DIR."
    )


RAG_DIR = resolve_rag_dir()
sys.path.insert(0, str(RAG_DIR))

try:
    from app.rag_engine import RAGEngine
except Exception as exc:
    print(
        f"ERROR: Failed importing RAGEngine from '{RAG_DIR}'. "
        "Ensure the RAG project and dependencies are available.",
        file=sys.stderr,
    )
    print(f"DETAILS: {exc}", file=sys.stderr)
    sys.exit(1)


def retrieve_chunks(query: str, top_k: int = 5) -> list:
    """Retrieve relevant chunks from ChromaDB without LLM generation."""
    engine = RAGEngine(use_claude=False, use_claude_code=False)

    if engine.collection.count() == 0:
        print("ERROR: No papers indexed. Run indexing first.", file=sys.stderr)
        sys.exit(1)

    results = engine.retrieve(query, top_k=top_k)
    concepts = engine.get_relevant_concepts(query)

    return results, concepts


def format_results(results: list, concepts: list) -> str:
    """Format retrieval results for agent consumption."""
    output = []
    output.append(f"RETRIEVED {len(results)} CHUNKS")
    output.append("=" * 60)

    for i, chunk in enumerate(results, 1):
        meta = chunk["metadata"]
        similarity = chunk["score"]
        output.append(f"\n--- Result {i} (similarity: {similarity:.3f}) ---")
        output.append(f"Source: {meta.get('author', 'Unknown')} ({meta.get('year', 'n.d.')})")
        output.append(f"Title:  {meta.get('title', 'Untitled')}")
        output.append(f"Page:   {meta.get('page', '?')}")
        output.append(f"Text:\n{chunk['text']}")

    if concepts:
        output.append(f"\n{'=' * 60}")
        output.append(f"RELATED CONCEPTS ({len(concepts)})")
        output.append("=" * 60)
        for c in concepts:
            papers = ", ".join(c.get("papers", [])[:3])
            output.append(f"\n- {c['label']} ({c['type']})")
            output.append(f"  {c['definition']}")
            if papers:
                output.append(f"  Papers: {papers}")

    return "\n".join(output)


def show_stats():
    """Show RAG system statistics."""
    engine = RAGEngine(use_claude=False, use_claude_code=False)
    stats = engine.get_stats()
    print(f"Indexed chunks:  {stats['total_chunks']}")
    print(f"Concepts:        {stats['total_concepts']}")
    print(f"Papers:          {stats['total_papers']}")
    print(f"Embedding model: {stats['embedding_model']}")


def main():
    parser = argparse.ArgumentParser(
        description="Query the thesis literature RAG system"
    )
    parser.add_argument(
        "query",
        nargs="?",
        help="Search query for the literature corpus"
    )
    parser.add_argument(
        "--top-k",
        type=int,
        default=5,
        help="Number of results to return (default: 5)"
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Output results as JSON"
    )
    parser.add_argument(
        "--stats",
        action="store_true",
        help="Show RAG system statistics"
    )

    args = parser.parse_args()

    if args.stats:
        show_stats()
        return

    if not args.query:
        parser.print_help()
        sys.exit(1)

    results, concepts = retrieve_chunks(args.query, top_k=args.top_k)

    if args.json:
        output = {
            "query": args.query,
            "results": results,
            "concepts": [
                {"label": c["label"], "definition": c["definition"],
                 "type": c["type"], "papers": c.get("papers", [])}
                for c in concepts
            ]
        }
        print(json.dumps(output, indent=2, default=str))
    else:
        print(format_results(results, concepts))


if __name__ == "__main__":
    main()
