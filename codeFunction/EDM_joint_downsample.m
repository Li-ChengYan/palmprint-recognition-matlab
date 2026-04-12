function EDM = EDM_joint_downsample(responses)
% Downsample six directional responses with one shared best-impact pixel per block.
% Input:
%   responses - HxWx6 response tensor or a 1x6 cell array of response maps
% Output:
%   EDM - 1x6 cell array of logical downsampled maps

if iscell(responses)
    responses = cat(3, responses{:});
end

if ndims(responses) ~= 3 || size(responses, 3) ~= 6
    error("EDM_joint_downsample:InvalidResponses", ...
        "responses must be an HxWx6 tensor or a 1x6 cell array.");
end

blockSize = 4;
[rows, cols, numDirections] = size(responses);
if mod(rows, blockSize) ~= 0 || mod(cols, blockSize) ~= 0
    error("EDM_joint_downsample:InvalidSize", ...
        "response maps must be divisible by the 4x4 EDM block size.");
end

outRows = rows / blockSize;
outCols = cols / blockSize;
jointBits = false(outRows, outCols, numDirections);

for row = 1:outRows
    rowRange = (row - 1) * blockSize + (1:blockSize);
    for col = 1:outCols
        colRange = (col - 1) * blockSize + (1:blockSize);
        block = responses(rowRange, colRange, :);
        [bitVector, ~] = select_best_impact_pixel(block);
        jointBits(row, col, :) = bitVector;
    end
end

EDM = cell(1, numDirections);
for dir = 1:numDirections
    EDM{dir} = jointBits(:, :, dir);
end
end

function [bitVector, position] = select_best_impact_pixel(blockResponses)
% The best-impact pixel is the candidate with the largest joint directional energy.
impact = sum(abs(blockResponses), 3);
[~, linearIdx] = max(impact(:));
[row, col] = ind2sub(size(impact), linearIdx);

position = [row, col];
bitVector = reshape(blockResponses(row, col, :) > 0, 1, 1, []);
end
