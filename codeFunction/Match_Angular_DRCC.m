function [dis] = Match_Angular_DRCC(P,Q)
% Compute the DRCC distance between two features.
% Input:
%     P - DRCC struct or legacy 32x64 matrix
%     Q - DRCC struct or legacy 32x64 matrix
% Output:
%     dis - Distance combining dominant-direction and neighbor-order terms

[dominantP, neighborP] = unpack_drcc_feature(P);
[dominantQ, neighborQ] = unpack_drcc_feature(Q);

if ~isequal(size(dominantP), size(dominantQ)) || ~isequal(size(neighborP), size(neighborQ))
    error("Match_Angular_DRCC:SizeMismatch", ...
        "both DRCC features must have the same dominant and neighbor map sizes.");
end

[numRows, numCols] = size(dominantP);

n = 2; % Shift range
tempDis = zeros(1,(2*n+1)^2);

count=0;
for row = -n:n
    for col = -n:n
        count = count + 1;
        domainP = dominantP(1+(abs(row)-row)/2:numRows-(abs(row)+row)/2,1+(abs(col)-col)/2:numCols-(abs(col)+col)/2);
        sideP = neighborP(1+(abs(row)-row)/2:numRows-(abs(row)+row)/2,1+(abs(col)-col)/2:numCols-(abs(col)+col)/2);
        domainQ = dominantQ(1+(abs(row)+row)/2:numRows-(abs(row)-row)/2,1+(abs(col)+col)/2:numCols-(abs(col)-col)/2);
        sideQ = neighborQ(1+(abs(row)+row)/2:numRows-(abs(row)-row)/2,1+(abs(col)+col)/2:numCols-(abs(col)-col)/2);

        delta = abs(double(domainP) - double(domainQ));
        delta = min(delta, 6 - delta);
        dominantPenalty = delta / 3;
        neighborPenalty = double((delta == 0) & xor(sideP, sideQ));
        pixelPenalty = (dominantPenalty + neighborPenalty) / 2;
        tempDis(count) = mean(pixelPenalty,'all');
    end
end

dis = min(tempDis);
end

function [dominant, neighbor] = unpack_drcc_feature(feature)
if isstruct(feature)
    dominant = feature.dominant;
    neighbor = feature.neighbor;
    return;
end

if ~ismatrix(feature) || mod(size(feature, 2), 2) ~= 0
    error("Match_Angular_DRCC:InvalidFeature", ...
        "feature must be a DRCC struct or a legacy matrix with concatenated maps.");
end

halfCols = size(feature, 2) / 2;
dominant = uint8(feature(:, 1:halfCols));
neighbor = logical(feature(:, halfCols+1:end));
end
