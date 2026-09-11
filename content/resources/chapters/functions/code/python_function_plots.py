# -*- coding: utf-8 -*-
"""
@author: Alexander Baral
"""

# importing numpy
import numpy as np

# Creating Vectors
vec1 = np.array([5, 6, 9])
vec2 = np.array([1, 2, 3])

# Printing vectors
print("Vector1 : " + str(vec1))
print("Vector2 : " + str(vec2))
print()

# addVectors
addVector = vec1 + vec2
print("Sum of Vectors : " + str(addVector))

# Skalarprodukt
dot_product = np.dot(vec1, vec2)
print("Dot Product : " + str(dot_product))

# Vektorprodukt
vectorProd = np.cross(vec1, vec2)
print("VectorProduct: " + str(vectorProd))


