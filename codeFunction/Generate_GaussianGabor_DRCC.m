function [DRCC_G] = Generate_GaussianGabor_DRCC()
% Build the six-direction Gabor bank used by DRCC.
% Output:
%   DRCC_G - Gabor filter bank; the seventh entry is the Gaussian prefilter

DRCC_G = cell(1,7);
for i = 0:5
    theta = i*pi/6;
    DRCC_G{i+1} = Generate_NpGabor(theta);
end

% The original DRCC pipeline smooths the image before directional coding.
sigma = 1;
n = 2;
Gaussian = zeros(2*n+1);
for x = -n:n
    for y = -n:n
        Gaussian(x+n+1,y+n+1) = 1/(2*pi*sigma^2) * exp(-(x^2+y^2)/(2*sigma^2));
    end
end
DRCC_G{7} = Gaussian / sum(Gaussian, "all");
end
