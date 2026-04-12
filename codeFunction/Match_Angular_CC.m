function [dis] = Match_Angular_CC(P,Q)
% Compute the angular distance between two CC matrices.
% Input:
%     P - 32x32 competitive code matrix with values in 0-5
%     Q - 32x32 competitive code matrix with values in 0-5
% Output:
%     dis - Angular distance between the two features

n = 2; % Shift range
tempDis = zeros(1,(2*n+1)^2); % Temporary storage for shifted distances

count=0;
for row = -n:n
    for col = -n:n
        count = count + 1;
        % Extract the shifted matching regions
        Pb = P(1+(abs(row)-row)/2:32-(abs(row)+row)/2,1+(abs(col)-col)/2:32-(abs(col)+col)/2);
        Qb = Q(1+(abs(row)+row)/2:32-(abs(row)-row)/2,1+(abs(col)+col)/2:32-(abs(col)-col)/2);
        [h,w] = size(Pb);
        d = 0;
        for x = 1:h
            for y = 1:w
                if abs(Pb(x,y)-Qb(x,y)) == 1 || abs(Pb(x,y)-Qb(x,y)) == 5
                    d = d + 1;
                elseif abs(Pb(x,y)-Qb(x,y)) == 2 || abs(Pb(x,y)-Qb(x,y)) == 4
                    d = d + 2;
                elseif abs(Pb(x,y)-Qb(x,y)) == 3
                    d = d + 3;
                end
            end
        end
       tempDis(count) = d / (3 * h * w); % Temporary angular distance
    end
end
dis = min(tempDis); % Best match over all shifts
end
