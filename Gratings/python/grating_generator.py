# -*- coding: utf-8 -*-
"""
Created on Thu Jan 21 13:02:13 2016

@author: Christophe
"""
import math
import numpy

# Converts a physical distance into a measure of visual degrees
def metric2vd(metricStimulusSize, viewDistance):
    vd = 2.0*math.degrees(math.atan( metricStimulusSize/(2.0*viewDistance)))
    return vd

# Converts a coordinate plane into units of visual degrees
def scale2degree(*arg):
    if len(arg) == 2:
        xViewAngle = arg[0]
        xScreenPixels = arg[1]
        yViewAngle = xViewAngle
        yScreenPixels = xScreenPixels
    elif len(arg) == 4:
        xViewAngle = arg[0]
        yViewAngle = arg[1]
        xScreenPixels = arg[2]
        yScreenPixels = arg[3]
    else:
        return -1
        
    xDegreesPerPixel = xViewAngle/xScreenPixels
    yDegreesPerPixel = yViewAngle/yScreenPixels
    
    xPixelScale = [ (xDegreesPerPixel*x) - (xViewAngle/2) for x in range(0,xScreenPixels)]
    yPixelScale = [ (yDegreesPerPixel*y) - (yViewAngle/2) for y in range(0,yScreenPixels)]
    
    [x,y] = numpy.meshgrid(xPixelScale, yPixelScale)
    return x,y

def CreateGrating(X,Y, stimulusOrientation, cyclesPerDegree):
    orientation = stimulusOrientation*math.pi/180.0
    xRotated = numpy.cos(orientation)*X + numpy.sin(orientation)*Y
    grating = numpy.cos( 2.0*math.pi*cyclesPerDegree*xRotated)
    return grating