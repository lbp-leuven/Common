function [ X,Y ] = scale2degree( xViewAngle, xScreenPixels,yViewAngle, yScreenPixels )
%SCALE2DEGREE Returns x and y coordinates properly scaled to visual degrees
%   Input parameters:
%       xViewAngle:     Width of the stimulus in visual degrees
%       xScreenPixels:  Width of the stimulus in pixels
%       yViewAngle:     Height of the stimulus in visual degrees
%       yScreenPixels:  Height of the stimulus in pixels
%       
%       if only xViewAngle and xScreenPixels are provided, the function
%       will assume the same values for y.
%
%   Returns:
%       X and Y coordinates scaled to visual degrees

if (nargin == 2)
    yViewAngle = xViewAngle;
    yScreenPixels = xScreenPixels;
end

xDegreesPerPixel = xViewAngle/xScreenPixels;
yDegreesPerPixel = yViewAngle/yScreenPixels;

xPixelScale = 0:(xScreenPixels-1);
yPixelScale = 0:(yScreenPixels-1);

xDegreeScale = (xDegreesPerPixel.*xPixelScale) - (xViewAngle/2);
yDegreeScale = (yDegreesPerPixel.*yPixelScale) - (yViewAngle/2);

[X,Y] = meshgrid(xDegreeScale, yDegreeScale);
end

