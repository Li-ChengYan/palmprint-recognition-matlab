function plot_score_distribution(genuine, imposter, titleText, gap)
%PLOT_SCORE_DISTRIBUTION Plot genuine and imposter score distributions.

if nargin < 3
    titleText = "Score Distribution";
end
if nargin < 4
    gap = 0.01;
end

[genuineX, genuineY] = compute_distribution(genuine, gap);
[imposterX, imposterY] = compute_distribution(imposter, gap);

hold on
plot(genuineX, genuineY, '-r', 'LineWidth', 1.5);
plot(imposterX, imposterY, '-b', 'LineWidth', 1.5);
legend("genuine", "imposter", 'Location', 'northwest');
title(titleText);
xlabel('Matching Distance');
ylabel('Percentage (%)');
grid on
hold off
end
