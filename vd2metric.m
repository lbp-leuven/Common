function [ metric ] = vd2metric( vd, distance )
%VD2METRIC Converts view angle to physical distance
%   Input parameters:
%      vd          visual degrees
%      distance    physical distance from observer to stimulus
% 
%   Returns:
%       Physical size of the stimulus

metric = 2*distance*tand(vd/2);

end

