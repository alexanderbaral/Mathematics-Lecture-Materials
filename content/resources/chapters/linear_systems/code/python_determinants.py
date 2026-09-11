# -*- coding: utf-8 -*-
"""
Created on Thu Mar 17 16:13:42 2022
@author: Alexander Baral
"""

import numpy as np 
  
matrix = np.array([[40,30,30],
                   [50,20,20],
                   [10,50,40]]) 


print("Numpy Matrix is:") 
print(matrix) 
  

print("\nDeterminante von Matrix:", np.round(np.linalg.det(matrix),3) ) 
