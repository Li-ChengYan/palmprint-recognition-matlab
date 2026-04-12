% Slightly modified from the original method.
% Improved limited Radon transform.
function [MF] = Generate_MFRAT_RLOC()
% Build a Radon filter bank with six orientations.
% Output:
%     MF - Cell array containing six Radon kernels
MF = cell(1,6);
for k = 0:5
    theta = k*pi/6;
    MF{k+1} = Mfrat(theta);
end
end

function [mask] = Mfrat(theta)

n = 8;

s = 2*n; % Template size (16 x 16)
core = n; % Center point
mask = zeros(s,s);
% mask(7:10,7:10) = 1; % Core
for i = 1:s
    if theta <= pi/4 || theta >= pi*3/4
        j = int8(core-tan(theta)*(i-core));
        mask(j-1:j+2,i) = 1;
    else
        j = int8(core-tan(pi/2 - theta)*(i-core));
        mask(i,j-1:j+2) = 1;
    end
end
end
