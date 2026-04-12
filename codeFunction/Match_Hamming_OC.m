function [dis] = Match_Hamming_OC(P,Q)

% Compute the Hamming distance between two ordinal-code features.
% Input:
%     P - 1x3 cell array containing the three directional ordinal feature matrices
%     Q - 1x3 cell array containing the three directional ordinal feature matrices
% Output:
%     dis - Hamming distance between the two features

n = 2; % Shift range
temp = zeros(1,(2*n+1)^2);
tempAll = zeros(1,6);
for k = 1:3
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
dis = mean(tempAll); % Average across the three directions
end
