function [dis] = Match_Hamming_BOCV(P,Q)
% Compute the Hamming distance between two BOCV features.
% Input:
%     P - 1x6 cell array containing the six directional feature matrices
%     Q - 1x6 cell array containing the six directional feature matrices
% Output:
%     dis - Hamming distance between the two features

n = 4; % Shift range for robust matching
temp = zeros(1,(2*n+1)^2);
tempAll = zeros(1,6);
for k = 1:6
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
dis = mean(tempAll); % Average across all six directions
end
