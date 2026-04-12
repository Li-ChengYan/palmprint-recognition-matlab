function ensure_directory(dirPath)
%ENSURE_DIRECTORY Create a directory if it does not exist.

if strlength(string(dirPath)) == 0
    return;
end

if ~exist(dirPath, "dir")
    mkdir(dirPath);
end
end
