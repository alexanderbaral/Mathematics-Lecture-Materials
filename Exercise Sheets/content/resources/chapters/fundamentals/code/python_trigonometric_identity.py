# -*- coding: utf-8 -*-
"""
Created on Thu Mar 17 16:13:42 2022
@author: Alexander Baral
"""

import numpy as np

lhsFct = lambda x: np.sin(x) + np.cos(x)**2
rhsFct = lambda x: 1.0


for x in [0.0, np.pi/3.0, np.pi/6.0, np.pi/12.0]:

    print('LHS(', np.round(x, 3), ') = ', np.round(lhsFct(x), 3) )
    print('RHS(', np.round(x, 3), ') = ', np.round(rhsFct(x), 3) )
    print('Delta = ', np.abs(lhsFct(x)-rhsFct(x)) )
    print()
