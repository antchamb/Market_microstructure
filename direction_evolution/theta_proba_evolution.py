# -*- coding: utf-8 -*-
"""
Created on Tue Mar  4 15:03:28 2025

@author: dell
"""

import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt

t_values = np.arange(1, 210)

D_low = np.log(99) / np.log(1.2/0.8)

mean_Dt = 0.2 * t_values
std_Dt = np.sqrt(0.96 * t_values)

probabilities = 1 - stats.norm.cdf(D_low, loc=mean_Dt, scale=std_Dt)

# # Find the minimum t such that P(θ_t > 0.99) > 0.95
t_required = t_values[np.where(probabilities > 0.95)][0]

# # Plot the probability P(θ_t > 0.99) as a function of t
# plt.figure(figsize=(8, 5))
# plt.plot(t_values, probabilities, label=r'$P(\theta_t > 0.99)$', color='b')
# plt.axhline(y=0.95, color='g', linestyle='--', label=r'$P = 0.95$ threshold')
# plt.axvline(x=t_required, color='r', linestyle='--', label=f'$t = {t_required}$ trades required')

# plt.xlabel('Time Step $t$')
# plt.ylabel(r'$P(\theta_t > 0.99)$')
# plt.title(r'Trade Count Required for $P(\theta_t > 0.99) > 0.95$')
# plt.legend()
# plt.grid(True)
# plt.show()# Compute the minimum t such that the expectation E[D_t | v = 1] exceeds D_low
t_expected_threshold = t_values[np.where(mean_Dt > D_low)][0]

# Plot the probability P(θ_t > 0.99) as a function of t
plt.figure(figsize=(8, 5))
plt.plot(t_values, probabilities, label=r'$P(\theta_t > 0.99)$', color='b')

# Add horizontal lines
plt.axhline(y=0.95, color='g', linestyle='--', label=r'$P = 0.95$ threshold')
plt.axhline(y=0.5, color='purple', linestyle='--', label=r'$P = 0.5$ at $t = {}$'.format(t_expected_threshold))

# Add vertical lines for t_required and t_expected_threshold
plt.axvline(x=t_required, color='r', linestyle='--', label=f'$t = {t_required}$ trades required for P > 0.95')
plt.axvline(x=t_expected_threshold, color='orange', linestyle='--', label=f'$t = {t_expected_threshold}$ (E[$D_t$] reaches $D_{{low}}$)')

# Labels and title
plt.xlabel('Time Step $t$')
plt.ylabel(r'$P(\theta_t > 0.99)$')
plt.title(r'Trade Count Required for $P(\theta_t > 0.99)$ and Expectation Threshold')
plt.legend()
plt.grid(True)

# Show plot
plt.show()

# Display the computed t values
# t_required, t_expected_threshold
