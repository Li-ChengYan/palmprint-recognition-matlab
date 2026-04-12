function plot_roc_curve(far, gar, eer, titleText)
%PLOT_ROC_CURVE Plot ROC curve with the EER in the title.

if nargin < 4
    titleText = "ROC";
end

farToPlot = max(far, eps);
semilogx(farToPlot, gar, 'LineWidth', 1.5);
title(sprintf('%s (EER = %.4f%%)', titleText, eer));
xlabel('False Acceptance Rate (%)');
ylabel('Genuine Acceptance Rate (%)');
grid on
end
