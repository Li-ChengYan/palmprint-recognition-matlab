function [genuine, imposter] = compute_genuine_imposter(cfg)
%COMPUTE_GENUINE_IMPOSTER Extract features and split pair scores by class.

arguments
    cfg struct
end

requiredFields = ["imgPath", "imgForm", "datasetType", "algorithmName"];
for idx = 1:numel(requiredFields)
    fieldName = requiredFields(idx);
    if ~isfield(cfg, fieldName)
        error("compute_genuine_imposter:MissingField", ...
            "cfg.%s is required.", fieldName);
    end
end

if isfield(cfg, "algorithmResolver")
    resolver = cfg.algorithmResolver;
else
    resolver = @algorithm;
end

[filterKernel, extractor, matcher] = resolver(cfg.algorithmName);
[images, classNo] = load_images_and_labels(cfg.imgPath, cfg.imgForm, cfg.datasetType);
numImages = numel(images);
features = cell(1, numImages);
for idx = 1:numImages
    features{idx} = extractor(images{idx}, filterKernel);
end

[numGenuine, numImposter] = count_pairs(classNo);
genuine = zeros(1, numGenuine);
imposter = zeros(1, numImposter);

genuineIdx = 1;
imposterIdx = 1;
numImages = numel(images);
for leftIdx = 1:numImages
    for rightIdx = leftIdx + 1:numImages
        score = matcher(features{leftIdx}, features{rightIdx});

        if classNo(leftIdx) == classNo(rightIdx)
            genuine(genuineIdx) = score;
            genuineIdx = genuineIdx + 1;
        else
            imposter(imposterIdx) = score;
            imposterIdx = imposterIdx + 1;
        end
    end
end
end

function [images, classNo] = load_images_and_labels(imgPath, imgForm, datasetType)
pattern = sprintf('*.%s', char(imgForm));
imgList = dir(fullfile(char(imgPath), pattern));
if isempty(imgList)
    error("compute_genuine_imposter:NoImagesFound", ...
        "No %s images found under %s.", imgForm, imgPath);
end

[~, sortIdx] = sort(string({imgList.name}));
imgList = imgList(sortIdx);

numImages = numel(imgList);
images = cell(1, numImages);
classNo = zeros(1, numImages);
for idx = 1:numImages
    fileName = string(imgList(idx).name);
    classNo(idx) = extractClassNoFromName(fileName, datasetType);
    filePath = fullfile(imgList(idx).folder, imgList(idx).name);
    img = im2gray(imread(filePath));
    images{idx} = img;
end
end

function [numGenuine, numImposter] = count_pairs(classNo)
numGenuine = 0;
numImposter = 0;
numImages = numel(classNo);
for leftIdx = 1:numImages
    for rightIdx = leftIdx + 1:numImages
        if classNo(leftIdx) == classNo(rightIdx)
            numGenuine = numGenuine + 1;
        else
            numImposter = numImposter + 1;
        end
    end
end
end
