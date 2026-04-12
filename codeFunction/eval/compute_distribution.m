function [x, y] = compute_distribution(data, gap)
%COMPUTE_DISTRIBUTION Convert scores into a percentage distribution curve.

if nargin < 2
    gap = 0.01;
end

data = data(:)';
if isempty(data)
    error("compute_distribution:EmptyInput", "data must be non-empty.");
end

x = (min(data) - gap):gap:(max(data) + gap);
if numel(x) < 2
    x = [data(1) - gap, data(1) + gap];
end

y = [histcounts(data, x), 0];
y = y / numel(data) * 100;
end
