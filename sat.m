% sat: binds a value within a set range
%
%   y = sat(minimum, x, maximum): binds x within the range min <= x <= max
%
%   Parameters
%   minimum = minimum value of the range
%   x = the value to be bound
%   maximum = maximum value of the range
%   
%   Returns
%   y = the bound value of the input
%
%   Author: Megan Shapiro
%   Date: 1 May 2022

function [y] = sat(minimum, x, maximum)
    y = max(x, minimum);
    y = min(y, maximum);
end