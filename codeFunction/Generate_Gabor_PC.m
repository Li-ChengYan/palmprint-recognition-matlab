function [G]=Generate_Gabor_PC(theta)
% Build a Gabor filter.
% Input:
%     theta - Filter orientation (in units of pi)
%     u - Sinusoid frequency
%     sigma - Gaussian standard deviation
%     n - Filter size is (2*n+1)^2
% Output:
%     G - Gabor kernel

% Default parameters
u = 0.0916;
sigma = 5.6179;
n = 8;

G = zeros(2*n+1,2*n+1); % Preallocate
for x = -n:n
    for y = -n:n
        G(x+n+1,y+n+1) = (1/(2*pi*sigma^2))*exp(-.5*((x^2+y^2)/sigma^2))*exp(2*pi*sqrt(-1)*(u*x*cos(theta)+u*y*sin(theta)));
    end
end
G = G - mean(mean(G)); % Remove the DC component
end
