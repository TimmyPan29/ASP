"""Deterministic system-identification benchmark for the adaptive filters."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import numpy as np

from .filters import AdaptiveResult, apa, lms, nlms


def generate_problem(
    samples: int = 4000,
    noise_std: float = 0.03,
    seed: int = 29,
) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Create a colored-input FIR system-identification problem."""

    if samples < 100:
        raise ValueError("samples must be at least 100")
    if not np.isfinite(noise_std) or noise_std < 0:
        raise ValueError("noise_std must be finite and cannot be negative")

    rng = np.random.default_rng(seed)
    excitation = rng.normal(size=samples)
    signal = np.empty(samples, dtype=float)
    signal[0] = excitation[0]
    for index in range(1, samples):
        signal[index] = 0.75 * signal[index - 1] + excitation[index]

    system = np.array([0.8, -0.45, 0.3, 0.1], dtype=float)
    desired = np.convolve(signal, system, mode="full")[:samples]
    desired += rng.normal(scale=noise_std, size=samples)
    return signal, desired, system


def _metrics(
    result: AdaptiveResult,
    system: np.ndarray,
    tail: int = 500,
) -> dict[str, float]:
    return {
        "coefficient_error": float(
            np.linalg.norm(result.coefficients - system)
        ),
        "tail_mse": float(np.mean(result.error[-tail:] ** 2)),
    }


def run_benchmark(seed: int = 29) -> dict[str, dict[str, float]]:
    """Run all filters against the same deterministic identification problem."""

    signal, desired, system = generate_problem(seed=seed)
    results = {
        "LMS": lms(signal, desired, len(system), step_size=0.01),
        "NLMS": nlms(signal, desired, len(system), step_size=0.5),
        "APA": apa(
            signal,
            desired,
            len(system),
            step_size=0.1,
            projection_order=4,
            regularization=0.01,
        ),
    }
    return {name: _metrics(result, system) for name, result in results.items()}


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Benchmark LMS, NLMS, and APA on FIR system identification."
    )
    parser.add_argument("--seed", type=int, default=29)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    summary = run_benchmark(seed=args.seed)
    serialized = json.dumps(summary, indent=2, sort_keys=True)
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(serialized + "\n", encoding="utf-8")
    print(serialized)


if __name__ == "__main__":
    main()
