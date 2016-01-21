# -*- coding: utf-8 -*-
"""
Created on Thu Jan 21 13:02:20 2016

@author: Christophe
"""
from grating_generator import *
import matplotlib.pyplot as plt
from PIL import Image

pixelStimulusSize = 240 
metricStimulusSize = 75
viewDistance = 100
stimulusOrientation = 0
cyclesPerDegree = 0.5

degreesStimulusSize = metric2vd(metricStimulusSize,viewDistance)
[X,Y] = scale2degree(degreesStimulusSize, pixelStimulusSize)

gratingStimulus = CreateGrating(X,Y,stimulusOrientation,cyclesPerDegree)
plt.imshow(gratingStimulus, cmap = 'Greys')

# Note: the previous image has values in the range [-1 1]. Typical computer images 
# are saved with integer values in the range [0..255]. This means we need to do
# a conversion first
gratingScaled = (gratingStimulus+1.0)/2.0
im = Image.fromarray( (gratingScaled*255).astype(numpy.uint8))
im.save("stim1.bmp")
