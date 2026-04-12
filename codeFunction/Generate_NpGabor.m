function [G] = Generate_NpGabor(Theta)
% Build a Gabor filter based on neurophysiology.
% Input:
%     Theta - Filter orientation
% Output:
%     G - Gabor filter

n = 8;  % Filter size is 17x17 ((2*n+1)^2)
Omega = 0.5; % Filter frequency
Kappa = 2;

G = zeros(2*n + 1,2*n + 1);
for x = -n:n
    for y = -n:n
        dx = x*cos(Theta) + y*sin(Theta);
        dy = y*cos(Theta) - x*sin(Theta);
        % Expression after applying Euler's formula
        G(x+n+1,y+n+1) = -Omega/(sqrt(2*pi)*Kappa) * exp(-Omega^2*(4*dx^2+dy^2) / (8*Kappa^2)) * (cos(Omega*dx) - exp(-Kappa^2 / 2));
    end
end

G = G - mean(mean(G));

end
