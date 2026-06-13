# Adaptive Filter Lab

A compact, reproducible implementation of adaptive filtering algorithms for
finite impulse response system identification.

## Algorithms

The package implements:

- Least mean squares (`LMS`)
- Normalized least mean squares (`NLMS`)
- Affine projection algorithm (`APA`)
- Steepest descent on diagonalized quadratic cost surfaces

For an input vector $\mathbf{x}(n)$, desired response $d(n)$, coefficient
vector $\mathbf{w}(n)$, and error
$e(n)=d(n)-\mathbf{w}^{T}(n)\mathbf{x}(n)$, the `LMS` update is

$$
\mathbf{w}(n+1)=\mathbf{w}(n)+\mu e(n)\mathbf{x}(n).
$$

`NLMS` normalizes the update by the instantaneous input power:

$$
\mathbf{w}(n+1)=\mathbf{w}(n)+
\frac{\mu e(n)\mathbf{x}(n)}
{\delta+\mathbf{x}^{T}(n)\mathbf{x}(n)}.
$$

`APA` uses the most recent $P$ regressors in $\mathbf{U}(n)$:

$$
\mathbf{w}(n+1)=\mathbf{w}(n)+
\mu\mathbf{U}^{T}(n)
\left(\mathbf{U}(n)\mathbf{U}^{T}(n)+\delta\mathbf{I}\right)^{-1}
\mathbf{e}(n).
$$

## Engineering Highlights

- A shared, validated API for all adaptive filters
- Deterministic experiments using fixed random seeds
- Full coefficient histories for convergence analysis
- Numerical regularization for `NLMS` and `APA`
- Explicit stability validation for quadratic steepest descent
- Automated tests for convergence, invalid inputs, determinism, and
  zero-energy signals
- No plotting, notebook, or proprietary MATLAB dependency in the core package

## Repository Layout

```text
.
├── examples/
│   └── steepest_descent.py
├── src/adaptive_filters/
│   ├── benchmark.py
│   ├── filters.py
│   └── steepest_descent.py
├── tests/
│   ├── test_filters.py
│   └── test_steepest_descent.py
└── pyproject.toml
```

## Quick Start

```bash
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install -e .
python3 -m unittest discover -s tests -v
adaptive-filter-benchmark
```

The benchmark identifies the unknown system
$\mathbf{h}=[0.8,-0.45,0.3,0.1]^{T}$ from colored input data with additive
Gaussian noise.

## Reproducible Benchmark

The default benchmark uses $4000$ samples, noise standard deviation
$\sigma=0.03$, and random seed $29$.

| Algorithm | Coefficient error $\lVert\hat{\mathbf{h}}-\mathbf{h}\rVert_2$ | Final-window MSE |
|---|---:|---:|
| `LMS` | $0.00298$ | $0.000910$ |
| `NLMS` | $0.01528$ | $0.001368$ |
| `APA` | $0.01804$ | $0.001487$ |

Run the benchmark with another seed:

```bash
adaptive-filter-benchmark --seed 42 --output results/seed-42.json
```

## Validation Scope

The automated validation assumes a real-valued, time-invariant unknown `FIR`
system, finite one-dimensional inputs, and additive zero-mean noise. The
benchmark evaluates coefficient recovery and steady-state mean-square error;
it is not a universal ranking of the algorithms.
