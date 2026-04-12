function classNo = extractClassNoFromName(imgName, datasetType)
if strcmp(datasetType, "PolyU")
    temp = split(imgName, '_');
    classNo = double(temp(3));
elseif strcmp(datasetType, "IITD")
    temp = split(imgName, '_');
    classNo = double(temp(1));
elseif strcmp(datasetType, "Tongji")
    temp = split(imgName, '_');
    classNo = double(temp(1));
elseif strcmp(datasetType, "PolyU_CF")
    temp = split(imgName, '_');
    classNo = double(temp(1));
elseif strcmp(datasetType, "REST")
    temp = split(imgName, '_');
    classNo = double(temp{1}(2:end) + "");
    if strcmp(temp{2}, 'l')
        classNo = classNo * -1;
    end
elseif strcmp(datasetType, "Zhou_1295")
    temp = split(imgName, '_');
    classNo = double(temp(1));
elseif strcmp(datasetType, "MPDv2")
    temp = split(imgName, '_');
    classNo = double(temp(1));
else
    error("extractClassNoFromName:UnknownDataset", ...
        "Unsupported datasetType '%s'. Supported values: PolyU, IITD, Tongji, PolyU_CF, REST, Zhou_1295, MPDv2.", ...
        datasetType);
end
end
