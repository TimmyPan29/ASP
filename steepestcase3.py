import numpy as np
import matplotlib.pyplot as plt

# AR model parameters
a1, a2 = -1.5955, 0.95

# Simulation settings
N = 1000 # Number of samples
mu = 0.3  # Learning rate
sigma_u = 1  # Noise standard deviation
J_min = 0.0322
lambda1 = 1.818
lambda2 = 0.182
# Initialize the AR process
v1 = np.zeros(N)
v2 = np.zeros(N)
J  = np.zeros(N)
for n in range(0, N):
    # Use only past values of u to predict the current u[n]
    v1[n] = -1/np.sqrt(2)*((1-mu*lambda1)**n)*(a1+a2)
    v2[n] = -1/np.sqrt(2)*((1-mu*lambda2)**n)*(a1-a2)
    J[n] = J_min+lambda1*v1[n]**2+lambda2*v2[n]**2
# Calculate error vectors for plotting
def plot_ellipse(lambda1, lambda2, delta_J, color='black'):
    theta = np.linspace(0, 2 * np.pi, 100)
    r = np.sqrt(delta_J / (lambda1 * np.cos(theta)**2 + lambda2 * np.sin(theta)**2))
    v1 = r * np.cos(theta)
    v2 = r * np.sin(theta)
    plt.plot(v1, v2, color=color, linestyle='dashed', linewidth=1)
increments = [0.4,0.45, 0.5, 0.9]  # 不同的能量水平增量

# Plotting the trajectory of the error vectors
plt.figure(figsize=(10, 6))
plt.plot(v1, v2, label='Trajectory of (v1, v2)')
plt.scatter(v1[-1], v2[-1], color='red')  # End point
for inc in increments:
    plot_ellipse(lambda1, lambda2, inc)
plt.title('Adaptive Filter Error Trajectory using Steepest Descent')
plt.xlabel('v1(n)')
plt.ylabel('v2(n)')
plt.grid(True)
plt.xlim(-6, 6)
plt.ylim(-4, 4)
plt.legend()
plt.show()