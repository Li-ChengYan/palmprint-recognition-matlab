function selection = select_polyu_subset_files(imgPath, subsetCodes, numClasses, imagesPerClass)
%SELECT_POLYU_SUBSET_FILES Deterministically select a balanced PolyU subset.

arguments
    imgPath (1, 1) string
    subsetCodes string
    numClasses (1, 1) double {mustBePositive}
    imagesPerClass (1, 1) double {mustBePositive}
end

subsetCodes = upper(string(subsetCodes(:).'));
subsetCodes = subsetCodes(strlength(subsetCodes) > 0);
if isscalar(subsetCodes)
    codeText = char(subsetCodes);
    if numel(codeText) > 1
        subsetCodes = string(regexp(codeText, ".", "match"));
    end
end
if isempty(subsetCodes)
    error("select_polyu_subset_files:NoSubsetCodes", ...
        "subsetCodes must contain at least one subset code.");
end

records = struct("name", {}, "path", {}, "subset", {}, "classNo", {}, "sampleNo", {});
for subsetIdx = 1:numel(subsetCodes)
    pattern = sprintf("P_%s_*.bmp", char(subsetCodes(subsetIdx)));
    imgList = dir(fullfile(imgPath, pattern));
    if isempty(imgList)
        continue;
    end

    for idx = 1:numel(imgList)
        name = string(imgList(idx).name);
        tokens = regexp(name, '^P_([A-Z])_(\d+)_(\d+)\.bmp$', "tokens", "once");
        if isempty(tokens)
            continue;
        end

        records(end + 1).name = name; %#ok<AGROW>
        records(end).path = string(fullfile(imgList(idx).folder, imgList(idx).name));
        records(end).subset = string(tokens{1});
        records(end).classNo = str2double(tokens{2});
        records(end).sampleNo = str2double(tokens{3});
    end
end

if isempty(records)
    error("select_polyu_subset_files:NoValidFiles", ...
        "No valid PolyU filenames were found under %s for subset(s) %s.", ...
        imgPath, strjoin(subsetCodes, ", "));
end

selection = struct2table(records);
selection = sortrows(selection, ["classNo", "subset", "sampleNo", "name"]);

classIds = unique(selection.classNo, "sorted");
selectedRows = false(height(selection), 1);
chosenClassCount = 0;
for classIdx = 1:numel(classIds)
    rows = find(selection.classNo == classIds(classIdx));
    if ~isinf(imagesPerClass) && numel(rows) < imagesPerClass
        continue;
    end

    if isinf(imagesPerClass)
        selectedRows(rows) = true;
    else
        selectedRows(rows(1:imagesPerClass)) = true;
    end
    chosenClassCount = chosenClassCount + 1;
    if ~isinf(numClasses) && chosenClassCount == numClasses
        break;
    end
end

if ~isinf(numClasses) && chosenClassCount < numClasses
    error("select_polyu_subset_files:InsufficientClasses", ...
        "Only %d classes in subset(s) %s have at least %d images under %s.", ...
        chosenClassCount, strjoin(subsetCodes, ","), imagesPerClass, imgPath);
end

selection = selection(selectedRows, :);
selection = sortrows(selection, ["classNo", "subset", "sampleNo", "name"]);
end
