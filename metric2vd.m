function [ vd ] = metric2vd( metric, distance )
%METRIC2VD Converts physical distance to view angle
%   Input parameters:
%       metric: physical size of the stimulus
%       distance: physical distance from observer to stimulus
%
%   Returns:
%       Size of the stimulus in visual degrees

vd = 2*atand( metric/(2*distance) );

end

