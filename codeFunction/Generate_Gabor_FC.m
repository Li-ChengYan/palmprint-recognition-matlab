function [BOCV_G] = Generate_Gabor_FC()
% Build a Gabor filter bank with four orientations.
% Output:
%     G - Cell array containing four Gabor kernels

BOCV_G = cell(1,4);
for k = 0:3
    theta = k*pi/4;
    BOCV_G{k+1} = Generate_Gabor_PC(theta);
end
end
