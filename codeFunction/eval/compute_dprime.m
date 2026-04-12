function dprime = compute_dprime(genuine, imposter)
%COMPUTE_DPRIME Compute d-prime separation between genuine and imposter scores.

genuine = genuine(:);
imposter = imposter(:);

if isempty(genuine) || isempty(imposter)
    error("compute_dprime:EmptyInput", ...
        "genuine and imposter must both be non-empty.");
end

muG = mean(genuine);
muI = mean(imposter);
varG = var(genuine, 1);
varI = var(imposter, 1);
pooled = 0.5 * (varG + varI);

if pooled <= 0
    if muG == muI
        dprime = 0;
    else
        dprime = inf;
    end
    return;
end

dprime = abs(muG - muI) / sqrt(pooled);
end
