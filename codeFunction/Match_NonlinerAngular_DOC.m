function [dis] = Match_NonlinerAngular_DOC(P,Q)
% Compute the nonlinear angular distance between two DOC codes.
% Input:
%     P - 32x64 matrix containing two competitive-code matrices
%     Q - 32x64 matrix containing two competitive-code matrices
% Output:
%     dis - Nonlinear angular distance between the two features

k = 1; % k = 1.6 or k = 1
nTheta = 12; % When k = 1.6, nTheta = 6; when k = 1, nTheta = 12

n = 2; % Shift range
tempScore = zeros(1,(2*n+1)^2); % Temporary storage for shifted distances
code_dis = cell(1,4);
count=0;
for row = -n:n
    for col = -n:n
        count = count + 1;
        % Extract the shifted matching regions
        P1 = P(1+(abs(row)-row)/2:32-(abs(row)+row)/2,1+(abs(col)-col)/2:32-(abs(col)+col)/2);
        P2 = P(1+(abs(row)-row)/2:32-(abs(row)+row)/2,33+(abs(col)-col)/2:64-(abs(col)+col)/2);
        Q1 = Q(1+(abs(row)+row)/2:32-(abs(row)-row)/2,1+(abs(col)+col)/2:32-(abs(col)-col)/2);
        Q2 = Q(1+(abs(row)+row)/2:32-(abs(row)-row)/2,33+(abs(col)+col)/2:64-(abs(col)-col)/2);
        
        % Compute the distance according to the nonlinear angular matching rule.
        code_dis{1} = min(abs(P1-Q1),nTheta - abs(P1-Q1));
        code_dis{2} = min(abs(P1-Q2),nTheta - abs(P1-Q2));
        code_dis{3} = min(abs(P2-Q1),nTheta - abs(P2-Q1));
        code_dis{4} = min(abs(P2-Q2),nTheta - abs(P2-Q2));
        
        p1_score = exp(-k*code_dis{1}) + exp(-k*code_dis{4});
        p2_score = exp(-k*code_dis{2}) + exp(-k*code_dis{3});
        p_score = max(p1_score,p2_score);
        
        tempScore(count) = mean(p_score,'all')/2; % Temporary matching score
    end
end

dis = 1 - max(tempScore); % Best score over all shifts
end
