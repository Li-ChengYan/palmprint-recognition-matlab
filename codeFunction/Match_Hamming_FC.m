function [dis] = Match_Hamming_FC(P,Q)
% Compute the Hamming distance between two FC features.
% Input:
%     P - 32x64 feature matrix, with the left 32x32 as real part and the right 32x32 as imaginary part
%     Q - 32x64 feature matrix
% Output:
%     dis - Hamming distance between the two features

n = 2; % Shift range for robust matching
results = zeros(1,(2*n+1)^2);
count=0;
for row = -n:n 
    for col = -n:n
        count = count + 1;
        % Extract the shifted matching regions
        Pr = P(1+(abs(row)-row)/2:32-(abs(row)+row)/2,1+(abs(col)-col)/2:32-(abs(col)+col)/2);
        Pi = P(1+(abs(row)-row)/2:32-(abs(row)+row)/2,33+(abs(col)-col)/2:64-(abs(col)+col)/2);
        Qr = Q(1+(abs(row)+row)/2:32-(abs(row)-row)/2,1+(abs(col)+col)/2:32-(abs(col)-col)/2);
        Qi = Q(1+(abs(row)+row)/2:32-(abs(row)-row)/2,33+(abs(col)+col)/2:64-(abs(col)-col)/2);
        results(count) = mean(xor(Pr,Qr)+xor(Pi,Qi),'all')/2; % Normalized Hamming distance
    end
end
dis = min(results);
end
