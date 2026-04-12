function [dis] = Match_Hamming_FastCC(P,Q)
% Compute the Hamming distance between two FastCC features.
% Input:
%     P - 32x32 matrix
%     Q - 32x32 matrix
% Output:
%     dis - Hamming distance between the two features

n = 4; % Shift range for robust matching
temp = zeros(1,(2*n+1)^2);
count=0;
for row = -n:n
    for col = -n:n
        count = count + 1;
        % Extract the shifted matching regions
        Pb = P(1+(abs(row)-row)/2:32-(abs(row)+row)/2,1+(abs(col)-col)/2:32-(abs(col)+col)/2);
        Qb = Q(1+(abs(row)+row)/2:32-(abs(row)-row)/2,1+(abs(col)+col)/2:32-(abs(col)-col)/2);
        temp(count) = mean(xor(Pb,Qb),'all'); % Normalized Hamming distance
    end
end
dis = min(temp); % Best match across all shifts
end
