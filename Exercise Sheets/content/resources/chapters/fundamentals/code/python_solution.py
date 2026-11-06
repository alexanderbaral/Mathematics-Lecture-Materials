# -*- coding: utf-8 -*-
"""
Created on Thu Mar 17 16:13:42 2022
@author: Alexander Baral
"""

import numpy as np

print('Formel - cos(x)^2+sin(x)^2=1')
lhsFct = lambda x: np.sin(x)**2 + np.cos(x)**2
rhsFct = lambda x: 1.0

for x in [0.0, np.pi/3.0, np.pi/6.0, np.pi/12.0]:

    print('LHS(', np.round(x, 3), ') = ', np.round(lhsFct(x), 3) )
    print('RHS(', np.round(x, 3), ') = ', np.round(rhsFct(x), 3) )
    print('Delta = ', np.abs(lhsFct(x)-rhsFct(x)) )
    print()



print('Formel - Summenformel')
lhsFct = lambda n: np.sum([k**2 for k in range(1,n+1)])
rhsFct = lambda n: n*(n+1)*(2*n+1)/6.0

for n in [1, 5, 10, 100, 1000]:        
    print('LHS(', np.round(n, 3), ') = ', np.round(lhsFct(n), 3) )
    print('RHS(', np.round(n, 3), ') = ', np.round(rhsFct(n), 3) )
    print('Delta = ', np.abs(lhsFct(n)-rhsFct(n)) )
    print()