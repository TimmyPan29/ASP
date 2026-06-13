import unittest

import numpy as np

from adaptive_filters.steepest_descent import quadratic_trajectory


class SteepestDescentTests(unittest.TestCase):
    def test_stable_cost_decreases_to_minimum(self) -> None:
        modes, costs = quadratic_trajectory(
            initial_error=[-0.53, 0.81],
            eigenvalues=[1.1, 0.9],
            step_size=0.3,
            minimum_cost=0.0965,
            iterations=100,
        )

        self.assertEqual(modes.shape, (100, 2))
        self.assertTrue(np.all(np.diff(costs) <= 1e-12))
        self.assertAlmostEqual(costs[-1], 0.0965, places=10)

    def test_unstable_step_size_is_rejected(self) -> None:
        with self.assertRaises(ValueError):
            quadratic_trajectory(
                initial_error=[1.0, 1.0],
                eigenvalues=[2.0, 1.0],
                step_size=1.0,
                minimum_cost=0.0,
                iterations=10,
            )


if __name__ == "__main__":
    unittest.main()
