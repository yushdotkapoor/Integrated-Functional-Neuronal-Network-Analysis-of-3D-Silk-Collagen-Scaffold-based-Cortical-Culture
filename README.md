# Integrated-Functional-Neuronal-Network-Analysis-of-3D-Silk-Collagen-Scaffold-based-Cortical-Culture
This custom MATLAB code loads the processed_analysis.mat file generated from FluoroSNNAP, extracts and organizes the variables and computes parameters that describe the network properties 

# Download and unzip Matlab Code-Integrated Functional Neuronal Network Analysis of 3D Silk-Collagen Scaffold-based Cortical.zip.  
This folder contains the following files: 
a.	avg_clus_matrix.m
b.	avg_path_matrix.m
c.	circularGraph.m
d.	clustering_coef_matrix.m
e.	matrixExtraction.m
f.	NetworkAnalysis.m
g.	node.m
h.	processed_analysis_sample.mat
i.	RunNetworkAnalysis.m
j.	singleROIAnalyis.m

# When you run RunNetworkAnalysis.m file:
%Input
% 1. processed_analysis.m file
% 2. for NetworkAnalysis.m
%   Do you want to binaryze the matrix?
%   You must decleare if you want or not to binarize the input
%   matrix. If yes, if yes, you must decleare also the
%   threshold. 

%Output from singleROIAnalysis.m function
% 1) CalciumEventsTable;
% 2) ISITable;
% 3) SingleParameterTable containing:
%   - meanSampleFrequency (events/min);
%   - percentageActiveROI;
%   - SyncIndex.
 
%Output from matrixExtraction.m
% 1.A= matrix computed accordingly to the FC method choose in FluoroSNAAP 

%Output from NetworkAnalysis.m

% 1) FinalTableNetworkData= A table summirizing the following parameters:
% N= number of nodes;
% Modularity= modularity value;
% numberModules= total number of modules;
% AverageEdgeWeight= the mean normalized edge weight of the matrix;
% net_clus= average clustering coeficient;
% net_path= average path length;

% 2)NodeDegree=A table summirizing:
% First column= the node index;
% Second column= the node degree.

% 3)ModuleComposition=a cell variable containing: 
% First column= the module index;
% Second column= the number of ROIs in each module;
% Third column:the ROI IDs for each module

% 4)Matrix= adjacent matrix (either binary or weighted based on the user's
% choice)

% 5) An excel file summirizing the results (see below)

% Figures:
% 6) Kernel distribution plot of the node's degree
% 7) Circular graph

%% Required Codes:
% 1) avg_clus_matrix.m= a function to compute the average clusteirng coefficient for a input matrix M;
%written by Eric Bridgeford; Muldoon, S., Bridgeford, E. & Bassett, D. Small-World Propensity and Weighted Brain Networks. Sci Rep 6, 22057 (2016). https://doi.org/10.1038/srep22057

% 2) avg_path_matrix.m = a function to compute the average path length of a given matrix using the graphallshortestpaths built-in matlab function;
%written by Eric Bridgeford;Muldoon, S., Bridgeford, E. & Bassett, D. Small-World Propensity and Weighted Brain Networks. Sci Rep 6, 22057 (2016). https://doi.org/10.1038/srep22057  

% 3) clustering_coef_matrix.m = a modification of the clustering coefficient function provided in the brain connectivity toolbox; 
% code originally written by Mika Rubinov, UNSW, 2007-2010; modified/written by Eric Bridgeford; Muldoon, S., Bridgeford, E. & Bassett, D. Small-World Propensity and Weighted Brain Networks. Sci Rep 6, 22057 (2016). https://doi.org/10.1038/srep22057

% 4) circularGraph.m= a function to plot the circular graph based on Matrix
% (Paul Kassebaum (2020). circularGraph https://github.com/paul-kassebaum-mathworks/circularGraph), GitHub. Retrieved October 6, 2020.)

% 5) node.m= Helper class for circularGraph.
% (Paul Kassebaum (2020). circularGraph https://github.com/paul-kassebaum-mathworks/circularGraph), GitHub. Retrieved October 6, 2020.)

%written by Mattia Bonzanni
