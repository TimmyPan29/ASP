"""Steepest-descent trajectories for quadratic mean-square-error surfaces."""

from __future__ import annotations

from dataclasses import dataclass

import numpy as np
from numpy.typing import ArrayLike, NDArray


FloatArray = NDArray[np.float64]


@dataclass(frozen=True)
class QuadraticCase:
    """Diagonalized quadratic cost used by the original experiments."""

    name: str
    initial_error: tuple[float, ...]
    eigenvalues: tuple[float, ...]
    minimum_cost: float


def quadratic_trajectory(
    initial_error: ArrayLike,
    eigenvalues: ArrayLike,
    step_size: float,
    minimum_cost: float,
    iterations: int,
) -> tuple[FloatArray, FloatArray]:
    """Return coefficient-error and cost trajectories for a quadratic cost."""

    error = np.asarray(initial_error, dtype=float)
    spectrum = np.asarray(eigenvalues, dtype=float)

    if error.ndim != 1 or spectrum.ndim != 1 or error.shape != spectrum.shape:
        raise ValueError("initial_error and eigenvalues must be matching vectors")
    if error.size == 0:
        raise ValueError("at least one mode is required")
    if not np.all(np.isfinite(error)) or not np.all(np.isfinite(spectrum)):
        raise ValueError("trajectory inputs must contain only finite values")
    if np.any(spectrum <= 0):
        raise ValueError("eigenvalues must be positive")
    if iterations < 1:
        raise ValueError("iterations must be positive")
    if not np.isfinite(minimum_cost):
        raise ValueError("minimum_cost must be finite")

    stability_limit = 2.0 / np.max(spectrum)
    if not np.isfinite(step_size) or not 0 < step_size < stability_limit:
        raise ValueError(
            f"step_size must satisfy 0 < step_size < {stability_limit:.6g}"
        )

    powers = np.arange(iterations, dtype=float)[:, None]
    modes = error * (1.0 - step_size * spectrum) ** powers
    costs = minimum_cost + np.sum(spectrum * modes**2, axis=1)
    return modes, costs

