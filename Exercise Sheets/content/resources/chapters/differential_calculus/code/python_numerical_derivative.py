# -*- coding: utf-8 -*-
"""
@author: Alexander Baral
"""

# importing numpy
import numpy as np
import matplotlib.pyplot as plt

def fct(x):
    return np.sin(x)

def dFct(x, fct=fct, eps=0.00001):
    return (fct(x+eps)-fct(x-eps))/(2.0*eps)

# PLOTTING

x_Grid = np.linspace(start=-5.0, stop=5.0, num=100, endpoint=True)


# PLOT erstellen
plt.plot(x_Grid, fct(x_Grid), label='Funktion', color='blue', linewidth=2)
plt.plot(x_Grid, dFct(x_Grid), label='1. Ableitung', color='green', linewidth=2)
plt.plot(x_Grid, dFct(x_Grid, fct=dFct), label='2.Ableitung', color='grey', linewidth=2)

# Darstellungsgrenzen
# plt.xlim( [0.0, 5.0] )
# plt.ylim( [0.0, 5.0] )

# Achsenbeschriftung
plt.xlabel(r'$x$')
plt.ylabel(r'$y$')

plt.legend()
plt.grid()
plt.show()


