clear;
close all;

addpath(".\codeFunction\eval");

scoreFile = ".\data\baseline\PolyU_CF\MTCC.mat";
plotTitle = "PolyU-CF MTCC";

scores = load(scoreFile, "genuine", "imposter");
[far, gar, eer] = compute_roc_eer(scores.genuine, scores.imposter);

figure('Name', plotTitle, 'NumberTitle', 'off');

subplot(1, 2, 1);
plot_score_distribution(scores.genuine, scores.imposter, "Distribution");

subplot(1, 2, 2);
plot_roc_curve(far, gar, eer, "ROC");

fprintf("EER: %.4f%%\n", eer);
