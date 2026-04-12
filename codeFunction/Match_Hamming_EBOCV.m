function [dis] = Match_Hamming_EBOCV(P,Q)
% Compute the distance between two EBOCV feature sets.
% Input:
%     P - 1x6 struct array with fields BOCV and PM for the first image
%     Q - 1x6 struct array with fields BOCV and PM for the second image
% Output:
%     dis - Final matching distance computed from the modified Hamming distance
%           and the fragile-bit pattern distance

fAlpha = 0.45; % Weight for the final average
n = 4; % Shift range
HDMTemp = zeros(1,(2*n+1)^2);
FPDTemp = zeros(1,(2*n+1)^2);
HDM = zeros(1,6);
FPD = zeros(1,6);

for k = 1:6
    count = 0;
    for row = -n:n
        for col = -n:n
            count = count + 1;
            nP = P(1,k).BOCV(1+(abs(row)-row)/2:32-(abs(row)+row)/2,1+(abs(col)-col)/2:32-(abs(col)+col)/2); % Matching region for image P
            nQ = Q(1,k).BOCV(1+(abs(row)+row)/2:32-(abs(row)-row)/2,1+(abs(col)+col)/2:32-(abs(col)-col)/2); % Matching region for image Q
            PM = P(1,k).PM(1+(abs(row)-row)/2:32-(abs(row)+row)/2,1+(abs(col)-col)/2:32-(abs(col)+col)/2);
            QM = Q(1,k).PM(1+(abs(row)+row)/2:32-(abs(row)-row)/2,1+(abs(col)+col)/2:32-(abs(col)-col)/2);
            M = PM & QM; % Overlap of fragile-bit masks
            S = sum(sum(M)); % Overlapping area of fragile-bit masks
            HDMTemp(count) = sum(xor(nP,nQ) & M ,'all') / S; % Modified Hamming distance
            FPDTemp(count) = sum(xor(PM,QM) ,'all') / S; % Fragile-bit pattern distance
        end
    end
    HDM(k) = min(HDMTemp); % Best Hamming distance for this direction
    FPD(k) = min(FPDTemp);
end
HDM = mean(HDM);
FPD = mean(FPD);
dis = (fAlpha * HDM) + ((1-fAlpha) * FPD); % Final distance from HDM and FPD
end
