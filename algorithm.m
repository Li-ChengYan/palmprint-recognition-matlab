function [filter, extractor, matcher] = algorithm(aName)
% Build the filter, extractor, and matcher for the requested algorithm.
rootDir = fileparts(mfilename("fullpath"));

filter = 0;
extractor = 0;
matcher = 0;

switch(aName)
    case "PC"
        filter = Generate_Gabor_PC(pi/4);
        extractor = @Extract_PC;
        matcher = @Match_Hamming_PC;
    case "FC"
        filter = Generate_Gabor_FC();
        extractor = @Extract_FC;
        matcher = @Match_Hamming_FC;
    case "CC"
        filter = Generate_NpGabor_CC_BOCV_EBOCV();
        extractor = @Extract_CC;
        matcher = @Match_Angular_CC;
    case "FastCC"
        filter = Generate_NpGabor_CC_BOCV_EBOCV();
        extractor = @Extract_FastCC;
        matcher = @Match_Hamming_FastCC;
    case "OC"
        filter = Generate_Gaussian_OC();
        extractor = @Extract_OC;
        matcher = @Match_Hamming_OC;
    case "RLOC"
        filter = Generate_MFRAT_RLOC();
        extractor = @Extract_RLOC;
        matcher = @Match_PixelToArea_RLOC;
    case "FastRLOC"
        filter = Generate_MFRAT_RLOC();
        extractor = @Extract_RLOC;
        matcher = @Match_OneToOne_RLOC;
    case "BOCV"
        filter = Generate_NpGabor_CC_BOCV_EBOCV();
        extractor = @Extract_BOCV;
        matcher = @Match_Hamming_BOCV;
    case "EBOCV"
        filter = Generate_NpGabor_CC_BOCV_EBOCV();
        extractor = @Extract_EBOCV;
        matcher = @Match_Hamming_EBOCV;
    case "DOC"
        filter = Generate_RectifiedGabor_DOC();
        extractor = @Extract_DOC;
        matcher = @Match_NonlinerAngular_DOC;
    case "DRCC"
        filter = Generate_GaussianGabor_DRCC();
        extractor = @Extract_DRCC;
        matcher = @Match_Angular_DRCC;
    case "EDM"
        filter = Generate_NpGabor_CC_BOCV_EBOCV();
        extractor = @Extract_EDM;
        matcher = @Match_Hamming_BOCV;
    case "MTCC"
        filter = Generate_NpGabor_CC_BOCV_EBOCV();
        extractor = @Extract_MTCC;
        matcher = @Match_Hamming_MTCC;
    case "DoN"
        load(fullfile(rootDir, "codeFunction", "DoN_kernel.mat"), "don_template");
        filter = don_template;
        extractor = @Extract_DoN;
        matcher = @Match_DoN;
    otherwise
        available = ["PC", "FC", "CC", "FastCC", "OC", "RLOC", ...
            "FastRLOC", "BOCV", "EBOCV", "DOC", "DRCC", "EDM", "MTCC", "DoN"];
        error("algorithm:UnknownAlgorithm", ...
            "Unknown algorithm '%s'. Available algorithms: %s.", ...
            aName, strjoin(cellstr(available), ", "));
end
end
