close all;
clear;
clc;

projectRoot = fileparts(mfilename("fullpath"));
addpath(projectRoot);
addpath(fullfile(projectRoot, "codeFunction"));

[file1, path1] = uigetfile({"*.png;*.jpg;*.jpeg;*.bmp;*.tif;*.tiff", "Image Files"}, "Select the first image");
if isequal(file1, 0)
    error("No first image selected.");
end

[file2, path2] = uigetfile({"*.png;*.jpg;*.jpeg;*.bmp;*.tif;*.tiff", "Image Files"}, "Select the second image");
if isequal(file2, 0)
    error("No second image selected.");
end

img1 = im2gray(imread(fullfile(path1, file1)));
img2 = im2gray(imread(fullfile(path2, file2)));

[filterKernel, extractor, matcher] = algorithm("PC");
feature1 = extractor(img1, filterKernel);
feature2 = extractor(img2, filterKernel);

distance = matcher(feature1, feature2);
fprintf("PC distance: %.6f\n", distance);
