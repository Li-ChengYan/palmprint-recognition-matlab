function [CC_G] = Generate_NpGabor_CC_BOCV_EBOCV()
% Build a Gabor filter bank with six orientations.
% Output:
%     CC_G - Cell array containing six Gabor kernels

CC_G = cell(1,6);
for k = 0:5
    theta = k*pi/6;
    CC_G{k+1} = Generate_NpGabor(theta);
end
end
