"""Reference implementations of common adaptive FIR filters."""

from __future__ import annotations

from dataclasses import dataclass

import numpy as np
from numpy.typing import ArrayLike, NDArray


FloatArray = NDArray[np.float64]


@dataclass(frozen=True)
class AdaptiveResult:
    """Samples and final coefficients produced by an adaptive filter."""

    output: FloatArray
    error: FloatArray
    coefficients: FloatArray
    coefficient_history: FloatArray


def _prepare_inputs(
    signal: ArrayLike,
    desired: ArrayLike,
    filter_length: int,
    step_size: float,
) -> tuple[FloatArray, FloatArray]:
    x = np.asarray(signal, dtype=float)
    d = np.asarray(desired, dtype=float)

    if x.ndim != 1 or d.ndim != 1:
        raise ValueError("signal and desired must be one-dimensional")
    if x.shape != d.shape:
        raise ValueError("signal and desired must have the same length")
    if filter_length < 1:
        raise ValueError("filter_length must be positive")
    if filter_length > x.size:
        raise ValueError("filter_length cannot exceed the signal length")
    if not np.isfinite(step_size) or step_size <= 0:
        raise ValueError("step_size must be a finite positive value")
    if not np.all(np.isfinite(x)) or not np.all(np.isfinite(d)):
        raise ValueError("signal and desired must contain only finite values")

    return x, d


def _regressor(signal: FloatArray, index: int, length: int) -> FloatArray:
    values = np.zeros(length, dtype=float)
    available = min(index + 1, length)
    values[:available] = signal[index - available + 1 : index + 1][::-1]
    return values


def lms(
    signal: ArrayLike,
    desired: ArrayLike,
    filter_length: int,
    step_size: float,
) -> AdaptiveResult:
    """Run the least-mean-squares adaptive FIR algorithm."""

    x, d = _prepare_inputs(signal, desired, filter_length, step_size)
    weights = np.zeros(filter_length, dtype=float)
    output = np.zeros_like(x)
    error = np.zeros_like(x)
    history = np.zeros((x.size, filter_length), dtype=float)

    for index in range(x.size):
        vector = _regressor(x, index, filter_length)
        output[index] = weights @ vector
        error[index] = d[index] - output[index]
        weights += step_size * error[index] * vector
        history[index] = weights

    return AdaptiveResult(output, error, weights.copy(), history)


def nlms(
    signal: ArrayLike,
    desired: ArrayLike,
    filter_length: int,
    step_size: float,
    regularization: float = 1e-8,
) -> AdaptiveResult:
    """Run normalized LMS with input-power normalization."""

    x, d = _prepare_inputs(signal, desired, filter_length, step_size)
    if step_size >= 2:
        raise ValueError("NLMS step_size must satisfy 0 < step_size < 2")
    if not np.isfinite(regularization) or regularization <= 0:
        raise ValueError("regularization must be a finite positive value")

    weights = np.zeros(filter_length, dtype=float)
    output = np.zeros_like(x)
    error = np.zeros_like(x)
    history = np.zeros((x.size, filter_length), dtype=float)

    for index in range(x.size):
        vector = _regressor(x, index, filter_length)
        output[index] = weights @ vector
        error[index] = d[index] - output[index]
        power = regularization + vector @ vector
        weights += step_size * error[index] * vector / power
        history[index] = weights

    return AdaptiveResult(output, error, weights.copy(), history)


def apa(
    signal: ArrayLike,
    desired: ArrayLike,
    filter_length: int,
    step_size: float,
    projection_order: int = 4,
    regularization: float = 1e-3,
) -> AdaptiveResult:
    """Run the affine projection algorithm.

    The newest regressor is the first row of the projection matrix. Missing
    startup regressors are omitted, so the matrix grows to ``projection_order``.
    """

    x, d = _prepare_inputs(signal, desired, filter_length, step_size)
    if step_size >= 2:
        raise ValueError("APA step_size must satisfy 0 < step_size < 2")
    if projection_order < 1:
        raise ValueError("projection_order must be positive")
    if not np.isfinite(regularization) or regularization <= 0:
        raise ValueError("regularization must be a finite positive value")

    weights = np.zeros(filter_length, dtype=float)
    output = np.zeros_like(x)
    error = np.zeros_like(x)
    history = np.zeros((x.size, filter_length), dtype=float)

    for index in range(x.size):
        current = _regressor(x, index, filter_length)
        output[index] = weights @ current
        error[index] = d[index] - output[index]

        start = max(0, index - projection_order + 1)
        sample_indices = np.arange(index, start - 1, -1)
        regressors = np.vstack(
            [
                _regressor(x, sample, filter_length)
                for sample in sample_indices
            ]
        )
        desired_vector = d[sample_indices]
        projection_error = desired_vector - regressors @ weights
        gram = regressors @ regressors.T
        system = gram + regularization * np.eye(gram.shape[0])
        weights += (
            step_size
            * regressors.T
            @ np.linalg.solve(system, projection_error)
        )
        history[index] = weights

    return AdaptiveResult(output, error, weights.copy(), history)
