%% Run Network Analysis of 3D Silk-Collagen Scaffold-based Cortical Culture
% To organize and compute topology descriptors using calcium imaging
% processed data. 
%% Input - Output -Codes descriptions
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

%% Input
clear
clc
file=uiimport;      %to import the processed_analyisis.mat file 
%% Outputs
[CalciumEventsTable, ISITable, SingleParameterTable]=singleROIAnalysis(file.processed_analysis);
[A]=matrixExtraction(file.processed_analysis);
[FinalTableNetworkData, NodeDegree, ModuleComposition, Matrix]=NetworkAnalysis(A,file.processed_analysis);
%% Save the outputs in an Excel format
% Sheet1: Matrix;
% Sheet2: CalciumEventsTable;
% Sheet3: ISITable;
% Sheet4: SingleParameterTable;
% Sheet5: FinalTableNetworkData;
% Sheet6: NodeDegree:
% Ask for custom filename
prompt = {'Save file as:'};
dlgtitle = 'Filename';
dims = [1 40];
answer = inputdlg(prompt,dlgtitle,dims);
% datestr is deprecated, using datetime instead
% time=datestr(now,'_mmddyy_HHMMSS');
time = string(datetime('now', 'Format', '_MMddyy_HHmmss'));
extension='.xlsx';
filename=['results/NetworkAnalysis_',answer{1},time,extension];
filename = filename.join("");
% write Excel file
writematrix(Matrix,filename,'Sheet',1);
writetable(CalciumEventsTable,filename,'Sheet',2);
writetable(ISITable,filename,'Sheet',3);
writetable(SingleParameterTable,filename,'Sheet',4);
writetable(FinalTableNetworkData,filename,'Sheet',5);
writetable(NodeDegree,filename,'Sheet',6);