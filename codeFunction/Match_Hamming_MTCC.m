function [dis] = Match_Hamming_MTCC(P,Q)
% Compute the Hamming distance between two MTCC features.
% Input:
%     P - 1x12 cell array containing the twelve directional feature matrices
%     Q - 1x12 cell array containing the twelve directional feature matrices
% Output:
%     dis - Hamming distance between the two features

n = 4; % Shift range for robust matching
temp = zeros(1,(2*n+1)^2);
tempAll = zeros(1,12);
for k = 1:12
    count=0;
    for row = -n:n
        for col = -n:n
            count = count + 1;
            % Extract the shifted matching regions
            Pb = P{k}(1+(abs(row)-row)/2:32-(abs(row)+row)/2,1+(abs(col)-col)/2:32-(abs(col)+col)/2);
            Qb = Q{k}(1+(abs(row)+row)/2:32-(abs(row)-row)/2,1+(abs(col)+col)/2:32-(abs(col)-col)/2);
            temp(count) = mean(xor(Pb,Qb),'all'); % Normalized Hamming distance
        end
    end
    tempAll(k) = min(temp); % Best match for this direction
end
dis = mean(tempAll); % Average across all twelve directions
end
