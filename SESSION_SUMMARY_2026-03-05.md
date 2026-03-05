# Session Summary - 2026-03-05

## Goal
Move this repo from a CPU-only notebook workflow to a reproducible CUDA-capable setup on Thelio, while keeping a stable fallback environment.

## What Was Done

### Environment and tooling
- Confirmed Miniconda was installed and initialized shell integration.
- Created `DL-CUDA` conda environment for stable workflow.
- Installed core dependencies used by the project notebook:
  - `pytorch`, `torchvision`, `jupyter`, `pytest`, `ruff`, `mypy`
- Created `environment.yml` as the stable environment spec.
- Created `environment-nightly.yml` for nightly CUDA PyTorch testing.
- Registered nightly Jupyter kernel:
  - display name: `Python (DL-CUDA-nightly)`

### AGENTS guidance
- Updated `AGENTS.md` to:
  - use conda-based bootstrap (`environment.yml`)
  - document build/lint/test commands (including single-test patterns)
  - align formatter guidance to Ruff (`ruff format` + `ruff check`)
  - include code style conventions and agent workflow guidance

### Notebook and GPU enablement
- Updated `notebooks/2025-11-13-DL-hello-world.ipynb` to run on GPU:
  - explicit `device` selection
  - `model.to(device)`
  - moved batch tensors to `device` in train/test loops
- Verified notebook training runs on GPU.

## Key Issue and Resolution
- Stable PyTorch build initially warned that RTX 5060 Ti (`sm_120`) was not in supported arch list.
- Nightly CUDA wheels were installed in `DL-CUDA-nightly` and GPU compute was verified there.
- Result: GPU execution is now working in notebook with the nightly kernel.

## Repro Notes
- Stable env: `conda env create -f environment.yml`
- Nightly env: `conda env create -f environment-nightly.yml`
- In Jupyter, select kernel: `Python (DL-CUDA-nightly)` for nightly GPU path.
