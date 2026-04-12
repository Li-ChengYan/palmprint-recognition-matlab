function [DOC_G] = Generate_RectifiedGabor_DOC()
% Generate the six-direction Gabor filter bank used by DOC.
% Output:
%   DOC_G - Gabor filter bank

DOC_G = cell(1,6);
for i = 0:5
    theta = i*pi/6;
    % Use the standard Gabor generator for each orientation.
    DOC_G{i+1} = Generate_NpGabor(theta);
end
end
