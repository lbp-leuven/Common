# -*- coding: utf-8 -*-
"""
Created on Thu Jan 21 13:02:13 2016

@author: Christophe
"""
import math
import numpy as np

# Gives the size of the stimulus expressed in visual degrees, if you
# now the size and viewing distance in physical units (e.g. mm)
def metric2vd(stim_size_metric, viewing_distance):
    vd = 2.0*math.degrees(math.atan( stim_size_metric/(2.0*viewing_distance)))
    return vd

# Create a grating stimulus of 
def create_grating(W,H, stim_orientation, cpp, contrast = 1.0, phase_offset = 0):
    # Convert parameters to radians
    orientation = stim_orientation*math.pi/180.0 
    phase_offset = phase_offset*math.pi/180.0
    
    if W%2 == 0:
        x_range = np.arange(-W/2,W/2,1)
    else:
        x_range = np.arange(-(W-1)/2, (W+1)/2,1)
    
    if H%2 == 0:
        y_range = np.arange(-H/2, H/2, 1)
    else:
        y_range = np.arange(-(H-1)/2, (H+1)/2,1)
        
    [X,Y] = np.meshgrid(x_range,y_range)
    xRotated = np.cos(orientation)*X + np.sin(orientation)*Y
    
    grating = contrast * np.cos( 2.0*math.pi*cpp*xRotated + phase_offset)
    return grating

def create_circular_mask(W,H,radius):
    if W%2 == 0:
        x_range = np.arange(-W/2,W/2,1)
    else:
        x_range = np.arange(-(W-1)/2, (W+1)/2,1)
    
    if H%2 == 0:
        y_range = np.arange(-H/2, H/2, 1)
    else:
        y_range = np.arange(-(H-1)/2, (H+1)/2,1)
        
    [X,Y] = np.meshgrid(x_range,y_range)
    
    distances = np.sqrt(np.square(X) + np.square(Y))
    mask = np.zeros(distances.shape)
    mask[distances <= float(radius)] = 1
    return mask

def create_gaussian_mask(W, H, sigma):
    if W%2 == 0:
        x_range = np.arange(-W/2,W/2,1)
    else:
        x_range = np.arange(-(W-1)/2, (W+1)/2,1)
    
    if H%2 == 0:
        y_range = np.arange(-H/2, H/2, 1)
    else:
        y_range = np.arange(-(H-1)/2, (H+1)/2,1)
        
    [X,Y] = np.meshgrid(x_range,y_range)
    
    mask = np.exp(- ( (np.square(X)/(2*float(sigma)**2) + np.square(Y)/(2*float(sigma)**2))))
    
    return mask