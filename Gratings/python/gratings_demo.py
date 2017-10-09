# -*- coding: utf-8 -*-
"""
Created on Thu Jan 21 13:02:20 2016

@author: Christophe
"""
import grating_generator as gg
import matplotlib.pyplot as plt
from PIL import Image
import numpy as np

stim_size_pixel   = 128 # pixels
stim_size_metric  = 75  # mm
viewing_distance  = 100 # mm
stim_orientation  = 0   # degrees
cycles_per_degree = 0.3   

# The following code can be used to convert cycles per degree into cycles per pixel
stim_size_degrees = gg.metric2vd(stim_size_metric, viewing_distance)
cycles_per_pixel = cycles_per_degree*stim_size_degrees/stim_size_pixel


# Create a grating and a gaussian and circular mask
grating = gg.create_grating(stim_size_pixel,stim_size_pixel,stim_orientation,cycles_per_pixel,0.5)
mask_circular = gg.create_circular_mask(stim_size_pixel,stim_size_pixel,63)
mask_gauss = gg.create_gaussian_mask(stim_size_pixel,stim_size_pixel,20)

grating_circular = grating*mask_circular
grating_gauss    = grating*mask_gauss

# Plot the images
plt.subplot(1,2,1)
plt.imshow(grating*mask_circular, cmap='Greys', clim=(-1.0, 1.0))
plt.subplot(1,2,2)
plt.imshow(grating*mask_gauss, cmap='Greys', clim=(-1.0, 1.0))

# Note: the previous image has values in the range [-1 1]. Typical computer images 
# are saved with integer values in the range [0..255]. This means we need to do
# a conversion first
grating_scaled = 255*(grating_gauss+1.0)/2.0
im = Image.fromarray( grating_scaled.astype(np.uint8))
im.save("grating_gauss.bmp")
