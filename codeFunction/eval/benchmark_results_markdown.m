function markdown = benchmark_results_markdown(results)
%BENCHMARK_RESULTS_MARKDOWN Render benchmark results as a README-ready markdown table.

metadata = benchmark_algorithm_metadata();
[isKnown, orderIdx] = ismember(results.algorithm, metadata.algorithm);
if ~all(isKnown)
    error("benchmark_results_markdown:UnknownAlgorithm", ...
        "Missing metadata for: %s.", strjoin(cellstr(results.algorithm(~isKnown)), ", "));
end

metadata = metadata(orderIdx, :);
ordered = [metadata, removevars(results, "algorithm")];
ordered.ref_num = zeros(height(ordered), 1);
for idx = 1:height(ordered)
    ordered.ref_num(idx) = str2double(extractBetween(ordered.ref(idx), 2, strlength(ordered.ref(idx)) - 1));
end
ordered = sortrows(ordered, ["ref_num", "year", "usual_name"]);

bestEer = min(ordered.eer);
bestDprime = max(ordered.d_prime);
bestExtract = min(ordered.extract_ms);
bestMatch = min(ordered.match_ms);
tol = 1e-12;

header = [
    "| Ref. | Year | Usual name | Code name | Method summary | Template size / format | EER (%) | d-prime | Extract (ms/img) | Match (ms/pair) |"
    "| --- | ---: | --- | --- | --- | --- | ---: | ---: | ---: | ---: |"
];

rows = strings(height(ordered), 1);
for idx = 1:height(ordered)
    eerText = format_metric(ordered.eer(idx), abs(ordered.eer(idx) - bestEer) <= tol);
    dprimeText = format_metric(ordered.d_prime(idx), abs(ordered.d_prime(idx) - bestDprime) <= tol);
    extractText = format_metric(ordered.extract_ms(idx), abs(ordered.extract_ms(idx) - bestExtract) <= tol);
    matchText = format_metric(ordered.match_ms(idx), abs(ordered.match_ms(idx) - bestMatch) <= tol);

    rows(idx) = sprintf("| %s | %d | %s | `%s` | %s | %s | %s | %s | %s | %s |", ...
        ordered.ref(idx), ordered.year(idx), ordered.usual_name(idx), ordered.algorithm(idx), ...
        ordered.method_summary(idx), ordered.template_format(idx), ...
        eerText, dprimeText, extractText, matchText);
end

markdown = strjoin([header; rows], newline);
end

function text = format_metric(value, shouldBold)
if isinf(value)
    text = "Inf";
else
    text = sprintf("%.3f", value);
end

if shouldBold
    text = "**" + text + "**";
end
end
