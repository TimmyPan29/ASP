import numpy as np
import matplotlib.pyplot as plt

# AR model parameters
a1, a2 = -0.1950, 0.95

# Simulation settings
N = 200  # Number of samples
mu = 0.3  # Learning rate
sigma_u = 1  # Noise standard deviation
J_min = 0.0965
lambda1 = 1.1
lambda2 = 0.9
v1 = np.zeros(N)
v2 = np.zeros(N)
J = np.zeros(N)
for n in range(N):
    # Use only past values of u to predict the current u[n]
    v1[n] = -1/np.sqrt(2) * ((1 - mu * lambda1)**n) * (a1 + a2)
    v2[n] = -1/np.sqrt(2) * ((1 - mu * lambda2)**n) * (a1 - a2)
    J[n] = J_min + lambda1 * v1[n]**2 + lambda2 * v2[n]**2

# Generate a range for n
n = np.arange(N)  # This represents the time steps

# Plotting the trajectory of the error vectors
plt.figure(figsize=(10, 6))
plt.plot(n, J, label='X=1.22',linestyle='-')

N = 200 # Number of samples
mu = 0.3  # Learning rate
sigma_u = 1  # Noise standard deviation
J_min = 0.0731
lambda1 = 1.5
lambda2 = 0.5
a1, a2 = -0.9750, 0.95
for n in range(0, N):
    # Use only past values of u to predict the current u[n]
    v1[n] = -1/np.sqrt(2)*((1-mu*lambda1)**n)*(a1+a2)
    v2[n] = -1/np.sqrt(2)*((1-mu*lambda2)**n)*(a1-a2)
    J[n] = J_min+lambda1*v1[n]**2+lambda2*v2[n]**2
# Calculate error vectors for plotting
n = np.arange(N)  # This represents the time steps
plt.plot(n, J, label='X=3', linestyle='dotted')

N = 200 # Number of samples
mu = 0.3  # Learning rate
sigma_u = 1  # Noise standard deviation
J_min = 0.0322
lambda1 = 1.818
lambda2 = 0.182
a1, a2 = -1.5955, 0.95
for n in range(0, N):
    # Use only past values of u to predict the current u[n]
    v1[n] = -1/np.sqrt(2)*((1-mu*lambda1)**n)*(a1+a2)
    v2[n] = -1/np.sqrt(2)*((1-mu*lambda2)**n)*(a1-a2)
    J[n] = J_min+lambda1*v1[n]**2+lambda2*v2[n]**2
n = np.arange(N)  # This represents the time steps
plt.plot(n, J, label='X=10', linestyle='--')

N = 200 # Number of samples
mu = 0.3  # Learning rate
sigma_u = 1  # Noise standard deviation
J_min = 0.0038
lambda1 = 1.908
lambda2 = 0.0198
a1, a2 = -1.9114, 0.95
for n in range(0, N):
    # Use only past values of u to predict the current u[n]
    v1[n] = -1/np.sqrt(2)*((1-mu*lambda1)**n)*(a1+a2)
    v2[n] = -1/np.sqrt(2)*((1-mu*lambda2)**n)*(a1-a2)
    J[n] = J_min+lambda1*v1[n]**2+lambda2*v2[n]**2
n = np.arange(N)  # This represents the time steps
plt.plot(n, J, label='X=100', linestyle='-.')

plt.xlabel('Tune, n')
plt.ylabel('Mean-square error J(n)')
plt.grid(True)
plt.xlim(0, 200)
plt.ylim(0, 0.8)
plt.legend()
plt.show()