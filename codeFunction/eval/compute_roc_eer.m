function [far, gar, eer] = compute_roc_eer(genuine, imposter, step)
%COMPUTE_ROC_EER Compute ROC coordinates and equal error rate.

if nargin < 3
    step = 0.001;
end

genuine = genuine(:);
imposter = imposter(:);

if isempty(genuine) || isempty(imposter)
    error("compute_roc_eer:EmptyInput", ...
        "genuine and imposter must both be non-empty.");
end

thresholds = (min(genuine) - step):step:(max(imposter) + step);
far = zeros(1, numel(thresholds));
frr = zeros(1, numel(thresholds));

for idx = 1:numel(thresholds)
    threshold = thresholds(idx);
    far(idx) = sum(imposter <= threshold) / numel(imposter) * 100;
    frr(idx) = sum(genuine > threshold) / numel(genuine) * 100;
end

gar = 100 - frr;
[~, minIdx] = min(abs(far - frr));
eer = (far(minIdx) + frr(minIdx)) / 2;
end
