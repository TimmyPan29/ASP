"""Adaptive filtering algorithms and reproducible experiments."""

from .filters import AdaptiveResult, apa, lms, nlms
from .steepest_descent import QuadraticCase, quadratic_trajectory

__all__ = [
    "AdaptiveResult",
    "QuadraticCase",
    "apa",
    "lms",
    "nlms",
    "quadratic_trajectory",
]

