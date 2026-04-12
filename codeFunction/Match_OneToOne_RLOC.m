function [dis] = Match_OneToOne_RLOC(P,Q)
% Compute the one-to-one matching distance between two RLOC features.
% Input:
%     P - 32x32 feature matrix
%     Q - 32x32 feature matrix
% Output:
%     dis - Matching distance between the two features

n = 4; % Shift range
Score = zeros(1,(2*n+1)^2); % Store the distance for each shift
count = 0;
for row = -n:n 
    for col = -n:n
        count = count + 1;
        % Extract the shifted matching regions
        Pb = P(1+(abs(row)-row)/2:32-(abs(row)+row)/2,1+(abs(col)-col)/2:32-(abs(col)+col)/2);
        Qb = Q(1+(abs(row)+row)/2:32-(abs(row)-row)/2,1+(abs(col)+col)/2:32-(abs(col)-col)/2);
        Score(count) = mean(Pb==Qb,'all'); % Match score for this shift
    end
end
dis = 1 - max(Score); % Convert similarity to distance
end
