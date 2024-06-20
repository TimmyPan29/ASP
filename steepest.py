import numpy as np
import matplotlib.pyplot as plt

# AR model parameters
a1, a2 = -0.1950, 0.95

# Simulation settings
N = 5 # Number of samples
mu = 0.3  # Learning rate
sigma_u = 1  # Noise standard deviation

# Initialize the AR process
u = np.zeros(N)
np.random.seed(0)  # Seed for reproducibility
noise = np.random.normal(0, sigma_u, N)
for n in range(2, N):
    u[n] = -a1 * u[n-1] - a2 * u[n-2] + noise[n]

# LMS algorithm to estimate AR parameters
w1 = np.zeros(N)
w2 = np.zeros(N)

for n in range(2, N):
    # Use only past values of u to predict the current u[n]
    u_vector = np.array([u[n-1], u[n-2]])
    u_hat = np.dot(np.array([w1[n-1], w2[n-1]]), u_vector)
    e = u[n] - u_hat  # Prediction error

    # Update weights using the steepest descent
    w1[n] = w1[n-1] + mu * e * u[n-1]
    w2[n] = w2[n-1] + mu * e * u[n-2]

# Calculate error vectors for plotting
v1 = w1 + a1
v2 = w2 + a2

# Plotting the trajectory of the error vectors
plt.figure(figsize=(10, 6))
plt.plot(v1, v2, label='Trajectory of (v1, v2)')
plt.scatter(v1[-1], v2[-1], color='red')  # End point
plt.title('Adaptive Filter Error Trajectory using Steepest Descent')
plt.xlabel('v1(n) = w1(n) + a1')
plt.ylabel('v2(n) = w2(n) + a2')
plt.axhline(0, color='grey', lw=0.5)
plt.axvline(0, color='grey', lw=0.5)
plt.grid(True)
plt.legend()
plt.show()