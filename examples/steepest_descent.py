"""Compare convergence on quadratic costs with different eigenvalue spreads."""

from adaptive_filters import quadratic_trajectory


CASES = {
    "well_conditioned": {
        "initial_error": (-0.53, 0.81),
        "eigenvalues": (1.1, 0.9),
        "minimum_cost": 0.0965,
    },
    "ill_conditioned": {
        "initial_error": (0.46, 2.02),
        "eigenvalues": (1.908, 0.0198),
        "minimum_cost": 0.0038,
    },
}


def main() -> None:
    for name, case in CASES.items():
        _, costs = quadratic_trajectory(
            **case,
            step_size=0.3,
            iterations=200,
        )
        print(
            f"{name}: initial={costs[0]:.6f}, "
            f"final={costs[-1]:.6f}"
        )


if __name__ == "__main__":
    main()

