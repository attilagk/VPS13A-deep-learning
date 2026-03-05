# AGENTS.md
Guidance for coding agents in this repository.

## Repository Snapshot
- Project: `VPS13A-deep-learning`
- State: early-stage, notebook-first.
- Main code artifact: `notebooks/2025-11-13-DL-hello-world.ipynb`
- Inferred stack: Python + PyTorch + torchvision + Jupyter.
- No build/package config found: `pyproject.toml`, `setup.cfg`, `Makefile`, `tox.ini`.
- Dependency manifest present: `environment.yml`.
- No tests/config found: `tests/`, `pytest.ini`.
- No lint/type config files found yet (`pyproject.toml`/tool sections absent).
- Empty scaffolding dirs exist: `src/`, `models/`, `eval/`, `configs/`.

## Cursor/Copilot Rules Status
- `.cursorrules`: not present.
- `.cursor/rules/`: not present.
- `.github/copilot-instructions.md`: not present.
- If added later, those files become repository policy and should be followed.

## Agent Operating Rules
- Make minimal, task-focused edits.
- Do not rewrite/remove notebooks unless requested.
- Put reusable logic in `src/`; keep notebooks exploratory.
- Preserve intended directory roles as the project grows.
- Avoid committing generated artifacts unless user asks.
- Favor reproducible, deterministic experiment code.

## Environment Bootstrap
Use Conda/Miniconda (preferred):
```bash
conda env create -f environment.yml
conda activate DL-CUDA
```
Notes:
- `environment.yml` is the source of truth for dependencies.
- This environment uses CUDA-enabled PyTorch (`pytorch-cuda=12.4`).

## Build / Run Commands
No formal build system exists yet. Use:
- Run notebook UI: `jupyter notebook`
- Execute notebook headlessly (CI smoke run): `jupyter nbconvert --to notebook --execute notebooks/2025-11-13-DL-hello-world.ipynb --output /tmp/hello-world.executed.ipynb`
- Validate notebook JSON: `python -m json.tool notebooks/2025-11-13-DL-hello-world.ipynb >/dev/null`

## Lint / Format Commands
Adopt these defaults for Python files:
- Format: `ruff format src eval models tests`
- Lint: `ruff check src eval models tests`
- Import-order checks: `ruff check --select I src eval models tests`
- Type checks: `mypy src`

## Test Commands (Single-Test Included)
Use `pytest` as the standard interface.
- Run all tests: `pytest -q`
- Run one test file: `pytest -q tests/test_example.py`
- Run one test function: `pytest -q tests/test_example.py::test_function_name`
- Run one test class: `pytest -q tests/test_example.py::TestSuiteName`
- Run tests by expression: `pytest -q -k "keyword"`

Current status:
- No tests are present yet.
- If you add tests, keep the command patterns above working unchanged.

## Code Style Guidelines

### Imports
- Order groups: standard library, third-party, local.
- One blank line between import groups.
- Prefer explicit imports; avoid wildcard imports.
- Keep imports at module top unless lazy import is justified.

### Formatting
- Use `ruff format` defaults for consistent formatting.
- Keep functions small and intent-revealing.
- Avoid deep nesting; split logic into helpers.
- Add comments only for non-obvious reasoning.

### Types
- Add type hints in all new `src/` modules.
- Annotate public function parameters and return types.
- Prefer precise types over `Any`.
- Use `None`-able types only when `None` is truly valid.

### Naming
- Files/modules: `snake_case.py`
- Variables/functions: `snake_case`
- Classes: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- Private helpers: leading underscore (`_helper`).

### Error Handling
- Fail early with clear exception types (`ValueError`, `TypeError`, etc.).
- Never use bare `except:`.
- Catch specific exceptions and include context in messages.
- Avoid silent failure paths.
- Validate external inputs at boundaries.

### Logging and Output
- Use `logging` in reusable modules.
- Use `print` mainly in notebooks/scripts.
- Keep training/eval logs concise and periodic.
- Include key context (seed, split, hyperparameters) in run output.

### ML/PyTorch Conventions
- Separate data prep, model, training, and evaluation logic.
- Seed randomness when reproducibility matters.
- Avoid hard-coded absolute paths.
- Parameterize hyperparameters near entrypoints.
- Move notebook-proven utilities into `src/` once reused.

## Testing Conventions (When Added)
- Place tests under `tests/`.
- Name files `test_<unit>.py`.
- Name tests `test_<behavior>`.
- Prefer deterministic unit tests over long training tests.
- Mark expensive tests explicitly (e.g., `@pytest.mark.slow`).

## Notebook and Data Hygiene
- Keep notebook outputs reasonably small; clear excessive output before commit.
- Use relative paths from notebook location (current notebook uses `../data`).
- Avoid downloading large datasets during every run if cached data exists.
- Keep exploratory cells separate from reusable utility code.
- When code stabilizes, move it from notebook cells into `src/` modules.
- Do not commit secrets, tokens, or local absolute paths in notebook metadata.

## Reproducibility Defaults
- Set and report random seeds for Python/NumPy/PyTorch when relevant.
- Record key hyperparameters close to entrypoint code.
- Keep train/validation/test split logic explicit and versionable.
- Prefer deterministic evaluation steps over ad-hoc notebook state.
- Log dataset version/source when experiments depend on external files.
- Name saved artifacts with timestamp + config context.

## Git Hygiene for Agents
- Do not revert unrelated user changes.
- Keep commits scoped to the task.
- Avoid force pushes and destructive git operations unless explicitly requested.
- Never commit raw datasets or generated binaries unless asked.
- Mention if commands could not be run because tooling is missing.

## Agent Pre-Completion Checklist
- Format changed Python files.
- Lint changed Python files.
- Run relevant tests (or state clearly if none exist).
- Confirm notebook-relative paths still resolve.
- Keep diffs limited to the requested task.
- Update this file if workflow assumptions change.
