function [ grating ] = CreateGrating( X,Y, or, cpd )
%CREATEGRATING Creates a grating
%   Input parameters:
%       X:      matrix of x coordinates, scaled to visual degrees
%       Y:      matrix of y coordinates, scaled to visual degrees
%       or:     orientation of the grating in degrees
%       cpd:    spatial frequency of the grating in cycles per
%       degree
%
%   Returns:
%       A grating

orientation = or*pi/180;    % Convert degree to radians

X_or = X.*cos(orientation) + Y.*sin(orientation);
grating = cos( (2*pi*cpd).*X_or);

end

