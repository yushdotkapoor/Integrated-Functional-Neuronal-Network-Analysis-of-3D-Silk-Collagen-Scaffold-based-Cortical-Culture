function [Clus] = avg_clus_matrix(W, met)
%a function to compute the average clusteirng coefficient for a 
%input matrix M

%Inputs:
%   W     a matrix, weighted or unweighted
%   met   a string, to represent the method to be used for computing
%         the clustering coefficient
%         possible strings: 'O' (Onnela), 'Z' (Zhang), 'B' (Barrat),
%         'bin' (binary)
%         default if none is chosen is Onnela

%Outputs:
%   Clus  the average clustering coefficient

%written by Eric Bridgeford
W(W<=0)=0;
% n = length(W);
% variable n was never used. Why is it here?

[C] = clustering_coef_matrix(W, met);

% nanmean is no longer recommended; MATLAB suggests using mean instead
% Clus = nanmean(C);
Clus = mean(C,'omitnan');
disp(Clus)

end
