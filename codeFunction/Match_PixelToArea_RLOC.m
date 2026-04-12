function [dis] = Match_PixelToArea_RLOC(P,Q)
% Compute the pixel-to-area matching distance between two RLOC features.
% Input:
%     P - 32x32 feature matrix
%     Q - 32x32 feature matrix
% Output:
%     dis - Matching distance between the two features

n = 2; % Shift range
Score = zeros(1,(2*n+1)^2); % Store the distance for each shift
count = 0;
area = ones(3,3) * 6; % 3x3 area filled with 6, which is outside the code range
for row = -n:n 
    for col = -n:n
        count = count + 1;
        % Extract the shifted matching regions
        Pb = P(1+(abs(row)-row)/2:32-(abs(row)+row)/2,1+(abs(col)-col)/2:32-(abs(col)+col)/2);
        Qb = Q(1+(abs(row)+row)/2:32-(abs(row)-row)/2,1+(abs(col)+col)/2:32-(abs(col)-col)/2);
        
        [r,c] = size(Pb);
        sA = zeros(r,c); % Current matching result
        sB = zeros(r,c);
        pQb = padarray(Qb,[1 1],6); % Pad the area with a border of 6s
        pPb = padarray(Pb,[1 1],6);
        for i = 1:r
            for j = 1:c
                % Build the cross-shaped neighborhood around the current pixel
                area(1,2)= pQb(i,j+1);
                area(2,1) = pQb(i+1,j);
                area(2,2) = pQb(i+1,j+1);
                area(2,3) = pQb(i+1,j+2);
                area(3,2) = pQb(i+2,j+1);
                sA(i,j) = any(Pb(i,j) == area,'all'); % Pixel-to-area success in P
                
                area(1,2)= pPb(i,j+1);
                area(2,1) = pPb(i+1,j);
                area(2,2) = pPb(i+1,j+1);
                area(2,3) = pPb(i+1,j+2);
                area(3,2) = pPb(i+2,j+1);
                sB(i,j) = any(Qb(i,j) == area,'all');  
            end
        end
        Score(count) = max(mean(sA,'all'),mean(sB,'all')); % Match score for this shift
    end
end
dis = 1 - max(Score); % Convert similarity to distance
end
