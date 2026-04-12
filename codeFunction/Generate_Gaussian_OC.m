function [OC] = Generate_Gaussian_OC()
% Build a Gaussian filter bank with three orientations.
% Output:
%   OC - Cell array containing three Gaussian filters

OC = cell(1,3);
for i = 0:2
    theta = i*pi/6;
    OC{i+1} = gausFilter(theta)-gausFilter(theta+pi/2);
end
end

function [Gaus] = gausFilter(theta)
% Build a Gaussian filter for one orientation.
% Input:
%   theta - Filter orientation
% Output:
%   Gaus - Gaussian filter

w = 25;
h = 7;
m = fix(w/2);
n = fix(h/2);
Gaus = zeros(25,7);
for x = -m:m
    for y = -n:n
        Gaus(x+m+1,y+n+1) = exp(-((x*cos(theta)+y*sin(theta))/w)^2 - ((-x*sin(theta)+y*cos(theta))/h)^2);
    end
end
Gaus = Gaus - mean(mean(Gaus));
end
