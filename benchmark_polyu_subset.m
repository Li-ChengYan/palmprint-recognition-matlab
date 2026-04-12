function results = benchmark_polyu_subset(cfg)
%BENCHMARK_POLYU_SUBSET Run a deterministic PolyU benchmark.

if nargin < 1
    cfg = default_config();
else
    cfg = fill_missing_fields(cfg, default_config());
end

if isfield(cfg, "verbose")
    verbose = logical(cfg.verbose);
else
    verbose = false;
end
if isfield(cfg, "logFile")
    logFile = string(cfg.logFile);
else
    logFile = "";
end

projectRoot = fileparts(mfilename("fullpath"));
addpath(projectRoot);
addpath(fullfile(projectRoot, "codeFunction"));
addpath(fullfile(projectRoot, "codeFunction", "eval"));

if ~isfolder(cfg.imgPath)
    error("benchmark_polyu_subset:InvalidImgPath", ...
        "cfg.imgPath does not exist: %s. Point cfg.imgPath to your local PolyU dataset before running benchmark_polyu_subset.", ...
        cfg.imgPath);
end

subsetCodes = resolve_subset_codes(cfg);
selection = select_polyu_subset_files(cfg.imgPath, subsetCodes, ...
    cfg.numClasses, cfg.imagesPerClass);
imagePaths = selection.path;
classNo = selection.classNo;
subsetLabel = strjoin(subsetCodes, "+");

numAlgorithms = numel(cfg.algorithms);
records = repmat(struct( ...
    "algorithm", "", ...
    "eer", NaN, ...
    "d_prime", NaN, ...
    "extract_ms", NaN, ...
    "match_ms", NaN, ...
    "far", {[]}, ...
    "gar", {[]}, ...
    "num_images", numel(imagePaths), ...
    "num_genuine", 0, ...
    "num_imposter", 0), 1, numAlgorithms);

for idx = 1:numAlgorithms
    algorithmName = string(cfg.algorithms(idx));
    log_message(sprintf("Running %s on %d images...", algorithmName, numel(imagePaths)), logFile, verbose);
    [eer, dprime, extractMs, matchMs, far, gar, numGenuine, numImposter] = ...
        benchmark_one_algorithm(algorithmName, imagePaths, classNo);

    records(idx).algorithm = algorithmName;
    records(idx).eer = eer;
    records(idx).d_prime = dprime;
    records(idx).extract_ms = extractMs;
    records(idx).match_ms = matchMs;
    records(idx).far = far;
    records(idx).gar = gar;
    records(idx).num_genuine = numGenuine;
    records(idx).num_imposter = numImposter;
end

results = struct2table(records);
markdown = benchmark_results_markdown(results);
log_message(markdown, logFile, verbose);

if isfield(cfg, "rocOutputFile") && strlength(cfg.rocOutputFile) > 0
    plot_benchmark_roc_overview(results, cfg.rocOutputFile, ...
        sprintf("PolyU P_%s ROC Overview", subsetLabel));
end

function log_message(message, logFile, verbose)
if verbose
    fprintf("%s\n", message);
end

if strlength(logFile) > 0
    ensure_directory(fileparts(logFile));
    fid = fopen(logFile, "a");
    if fid < 0
        warning("benchmark_polyu_subset:LogWriteFailed", ...
            "Unable to append to log file: %s", logFile);
        return;
    end
    cleanup = onCleanup(@() fclose(fid));
    fprintf(fid, "%s\n", char(message));
end
end

if isfield(cfg, "outputFile") && strlength(cfg.outputFile) > 0
    ensure_directory(fileparts(cfg.outputFile));
    save(cfg.outputFile, "cfg", "selection", "results", "markdown");
end
end

function cfg = default_config()
projectRoot = fileparts(mfilename("fullpath"));
cfg = struct( ...
    "imgPath", fullfile(projectRoot, "data", "example_dataset"), ...
    "subsetCodes", "F", ...
    "numClasses", 100, ...
    "imagesPerClass", 10, ...
    "algorithms", ["PC", "FC", "CC", "FastCC", "OC", "RLOC", ...
        "FastRLOC", "BOCV", "EBOCV", "DOC", "DRCC", "EDM", ...
        "MTCC", "DoN"], ...
    "outputFile", fullfile(projectRoot, "data", "benchmark", "polyu_pf_100ids_results.mat"), ...
    "rocOutputFile", fullfile(projectRoot, "data", "benchmark", "polyu_pf_100ids_roc_overview_refstyle.png") ...
);
end

function subsetCodes = resolve_subset_codes(cfg)
if isfield(cfg, "subsetCode")
    subsetCodes = string(cfg.subsetCode);
elseif isfield(cfg, "subsetCodes")
    subsetCodes = string(cfg.subsetCodes);
else
    subsetCodes = "F";
end
end

function cfg = fill_missing_fields(cfg, defaults)
defaultFields = fieldnames(defaults);
for idx = 1:numel(defaultFields)
    fieldName = defaultFields{idx};
    if ~isfield(cfg, fieldName) || isempty(cfg.(fieldName))
        cfg.(fieldName) = defaults.(fieldName);
    end
end
end

function [eer, dprime, extractMs, matchMs, far, gar, numGenuine, numImposter] = benchmark_one_algorithm(algorithmName, imagePaths, classNo)
[filterKernel, extractor, matcher] = algorithm(algorithmName);

numImages = numel(imagePaths);
features = cell(1, numImages);
extractTimes = zeros(1, numImages);
for idx = 1:numImages
    startTime = tic;
    features{idx} = extractor(im2gray(imread(imagePaths(idx))), filterKernel);
    extractTimes(idx) = toc(startTime);
end

numPairs = numImages * (numImages - 1) / 2;
classCounts = accumarray(classNo(:), 1);
numGenuine = sum(classCounts .* (classCounts - 1) / 2);
numImposter = numPairs - numGenuine;
genuine = zeros(1, numGenuine, "single");
imposter = zeros(1, numImposter, "single");

genuineIdx = 1;
imposterIdx = 1;
matchTimeSum = 0;
for leftIdx = 1:numImages
    for rightIdx = leftIdx + 1:numImages
        startTime = tic;
        score = single(double(matcher(features{leftIdx}, features{rightIdx})));
        matchTimeSum = matchTimeSum + toc(startTime);
        if classNo(leftIdx) == classNo(rightIdx)
            genuine(genuineIdx) = score;
            genuineIdx = genuineIdx + 1;
        else
            imposter(imposterIdx) = score;
            imposterIdx = imposterIdx + 1;
        end
    end
end

[~, ~, eer] = compute_roc_eer(genuine, imposter);
dprime = compute_dprime(genuine, imposter);
[far, gar] = compute_roc_eer(genuine, imposter);
extractMs = mean(extractTimes) * 1000;
matchMs = (matchTimeSum / numPairs) * 1000;
end
