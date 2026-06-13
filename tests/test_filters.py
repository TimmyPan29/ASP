import unittest

import numpy as np

from adaptive_filters.benchmark import generate_problem, run_benchmark
from adaptive_filters.filters import apa, lms, nlms


class AdaptiveFilterTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.signal, cls.desired, cls.system = generate_problem(
            samples=3000,
            noise_std=0.02,
            seed=29,
        )

    def assert_identifies_system(self, result, tolerance: float) -> None:
        coefficient_error = np.linalg.norm(
            result.coefficients - self.system
        )
        self.assertLess(coefficient_error, tolerance)
        early_mse = np.mean(result.error[:100] ** 2)
        late_mse = np.mean(result.error[-400:] ** 2)
        self.assertLess(late_mse, early_mse)

    def test_lms_identifies_fir_system(self) -> None:
        result = lms(
            self.signal,
            self.desired,
            len(self.system),
            step_size=0.01,
        )
        self.assert_identifies_system(result, tolerance=0.04)

    def test_nlms_identifies_fir_system(self) -> None:
        result = nlms(
            self.signal,
            self.desired,
            len(self.system),
            step_size=0.5,
        )
        self.assert_identifies_system(result, tolerance=0.04)

    def test_apa_identifies_fir_system(self) -> None:
        result = apa(
            self.signal,
            self.desired,
            len(self.system),
            step_size=0.1,
            projection_order=4,
            regularization=0.01,
        )
        self.assert_identifies_system(result, tolerance=0.04)

    def test_zero_input_remains_finite(self) -> None:
        signal = np.zeros(32)
        desired = np.ones(32)
        for algorithm in (nlms, apa):
            result = algorithm(
                signal,
                desired,
                filter_length=4,
                step_size=0.5,
            )
            self.assertTrue(np.all(np.isfinite(result.coefficients)))
            np.testing.assert_array_equal(result.coefficients, np.zeros(4))

    def test_result_contract(self) -> None:
        algorithms = (
            lms(
                self.signal,
                self.desired,
                len(self.system),
                step_size=0.01,
            ),
            nlms(
                self.signal,
                self.desired,
                len(self.system),
                step_size=0.5,
            ),
            apa(
                self.signal,
                self.desired,
                len(self.system),
                step_size=0.1,
            ),
        )
        for result in algorithms:
            np.testing.assert_allclose(
                result.output + result.error,
                self.desired,
            )
            np.testing.assert_array_equal(
                result.coefficient_history[-1],
                result.coefficients,
            )

    def test_nlms_is_scale_invariant(self) -> None:
        base = nlms(
            self.signal,
            self.desired,
            len(self.system),
            step_size=0.3,
            regularization=1e-12,
        )
        scaled = nlms(
            7 * self.signal,
            7 * self.desired,
            len(self.system),
            step_size=0.3,
            regularization=49e-12,
        )
        np.testing.assert_allclose(
            base.coefficients,
            scaled.coefficients,
            rtol=1e-11,
            atol=1e-11,
        )

    def test_first_order_apa_matches_nlms(self) -> None:
        nlms_result = nlms(
            self.signal,
            self.desired,
            len(self.system),
            step_size=0.3,
            regularization=1e-3,
        )
        apa_result = apa(
            self.signal,
            self.desired,
            len(self.system),
            step_size=0.3,
            projection_order=1,
            regularization=1e-3,
        )
        np.testing.assert_allclose(
            nlms_result.coefficient_history,
            apa_result.coefficient_history,
            rtol=1e-11,
            atol=1e-11,
        )

    def test_invalid_shapes_are_rejected(self) -> None:
        with self.assertRaises(ValueError):
            lms([1, 2], [1], filter_length=1, step_size=0.1)
        with self.assertRaises(ValueError):
            nlms([[1, 2]], [[1, 2]], filter_length=1, step_size=0.1)
        with self.assertRaises(ValueError):
            nlms([1, 2], [1, 2], filter_length=1, step_size=2)
        with self.assertRaises(ValueError):
            apa([1, 2], [1, 2], filter_length=1, step_size=2)

    def test_benchmark_is_deterministic(self) -> None:
        self.assertEqual(run_benchmark(seed=29), run_benchmark(seed=29))


if __name__ == "__main__":
    unittest.main()
