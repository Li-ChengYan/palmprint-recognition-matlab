function code = DRCC_encode_responses(responses)
% Encode DRCC responses into a dominant-direction map and a neighbor-order map.
% Input:
%   responses - HxWx6 response tensor or a 1x6 cell array of response maps
% Output:
%   code - struct with fields:
%          dominant - uint8 matrix with zero-based direction indices
%          neighbor - logical matrix encoding the adjacent-direction ordering

if iscell(responses)
    responses = cat(3, responses{:});
end

if ndims(responses) ~= 3 || size(responses, 3) ~= 6
    error("DRCC_encode_responses:InvalidResponses", ...
        "responses must be an HxWx6 tensor or a 1x6 cell array.");
end

[~, dominantIdx] = max(responses, [], 3);
neighbor = false(size(dominantIdx));

for dir = 1:6
    mask = dominantIdx == dir;
    if ~any(mask, "all")
        continue;
    end

    leftDir = mod(dir, 6) + 1;
    rightDir = mod(dir + 4, 6) + 1;

    leftResponse = responses(:, :, leftDir);
    rightResponse = responses(:, :, rightDir);
    neighbor(mask) = leftResponse(mask) >= rightResponse(mask);
end

code = struct( ...
    "dominant", uint8(dominantIdx - 1), ...
    "neighbor", neighbor ...
);
end
