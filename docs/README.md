# Argilla

**A reproducible Python project template with optional Rust acceleration.**

This project is intended as a lightweight, portable, and extendable structure for weekend hacks, data experiments, or performance-critical tools.

---

## 🚀 Features

- 🐳 Docker-based environment using `uv` for dependency management
- 🧪 `make verify` pipeline: lint → typecheck → test
- 🦀 PyO3 support via `maturin` for high-performance Rust extensions
- 🧼 VSCode DevContainer and `.cursorrules` integration
- 🧠 AI-ready: structured rules and doc guidance for Cursor or Copilot

---

## 🛠️ Development Workflow

Clone and get started:

```bash
make build       # Build the Docker container
make devshell    # Start an interactive dev container
make verify      # Run ruff + mypy + pytest
