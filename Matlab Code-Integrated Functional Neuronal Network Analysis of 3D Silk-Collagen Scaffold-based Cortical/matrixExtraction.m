function [A]=matrixExtraction(processed_analysis)
%% To extract the matrix and perform network analysis
% to identify the type of FC and extract the proper matrix
switch processed_analysis.params.FC.method_idx
    case 1
        A=processed_analysis.FC.CC.C;
        fprintf('Functional connectivity method detected:Cross-correlation\n')
    case 2
        A=processed_analysis.FC.PC.C;
        fprintf('Functional connectivity method detected: Partial correlation\n')
    case 3
        A=processed_analysis.FC.phase.C;
        fprintf('Functional connectivity method detected: Instantaneous	phase\n')
    case 4
        A=processed_analysis.FC.GC.C;
        fprintf('Functional connectivity method detected: Granger causality\n')
    case 5
        A=processed_analysis.FC.TE.C;
        fprintf('Functional connectivity method detected: Transfer Entropy\n')
end
end