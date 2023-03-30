function [FinalTableNetworkData, NodeDegree, ModuleComposition, Matrix]=NetworkAnalysis(A,processed_analysis)
% to compute some network parameters from the unidirected matrix. 

%Input:
% 1) A= unidirected matrix (weighted or binary).
%   Do you want to binaryze the matrix?
%   You must decleare if you want or not to binarize the input
%   matrix. If yes, if yes, you must decleare also the
%   threshold.

%Outputs:
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

% Figures:
% 5) Kernel distribution plot of the node's degree
% 6) Circular graph

%Required Codes:
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


answer = questdlg('Do you want to bynarize the matrix?', ...
	'Binary/Weighted', ...
	'Yes','No','No');
% Handle response
switch answer
    case 'Yes'
        prompt = {'Enter threshold:'};
        dlgtitle = 'Threshold';
        dims = [1 35];
        threshold = inputdlg(prompt,dlgtitle,dims);
        threshold=str2num(threshold{1,1});
        disp(threshold)
        disp(str2double(threshold{1,1}));
        cond1=(A>=threshold);                               % to binarize the matrix
        A(cond1)=1;
        A(~cond1)=0;
        Matrix=A;
    case 'No'
        Matrix=A;
end

N=length(Matrix);                                           %number of vertices
Degree=transpose(sum(Matrix)/(N-1));                        %the normalized node degree
AverageEdgeWeight = mean(Degree);                           %the mean edge weight of the matrix
nodeIndex=transpose(1:N);                                 %node index Nx1 vector
NodeDegree= horzcat(nodeIndex,Degree);                      %first column node index; second column edge weight
%% Plot node degree distribution
[f, xi]=ksdensity(NodeDegree(:,end));                % to compute the Kernel distribution
x2=[AverageEdgeWeight,AverageEdgeWeight];           
% y2=[0,f(find(abs(AverageEdgeWeight-xi)==min(abs(AverageEdgeWeight-xi))))];  % to identify the y-coordinate of the average edge weight
y2=[0,f(abs(AverageEdgeWeight-xi)==min(abs(AverageEdgeWeight-xi)))];  % to identify the y-coordinate of the average edge weight
figure(1)
plot(xi,f,x2,y2,'--','LineWidth',3);
title('Kernel Density Distribution of the normalized node degree');
xlabel('Normalized Node Degree');
ylabel('Probability Density Estimate (pdf)');
xlim([0 1]);
hold on
% size=60;
scatter(AverageEdgeWeight,0,160,'filled','MarkerFaceColor',[0 .7 .7],'MarkerEdgeColor',[0 0 0])
legend('Kernel Density',sprintf('Average Degree:%.2f',AverageEdgeWeight));
hold off
NodeDegree=table(nodeIndex,Degree);
%% Circular Graph and negative edges detection
figure(2)
HowManyNegative=sum(sum(Matrix<0));
Matrix(Matrix<0)=0;
if HowManyNegative>0
    s=sprintf('%d negative values detected;\nNegative values are not permitted (circularGraph and Path Length)\nValues substituted with 0\nPOSSIBLE SOLUTIONS:\n1.Change type of functional connectivity method;\n2. Binarize the matrix\3.Re-scale the matrix between 0 and 1',HowManyNegative);
    msgbox(s, 'Error:Negative Values detected','error');
end
circularGraph(Matrix);
                                                                     %% Modularity
modularity=processed_analysis.modularity;                   %to store the value of modularity from the analysis
modulesID=processed_analysis.modules;                       %to store the module index from the analysis
numberModules = length(unique(modulesID));                  %to compute the total number of moddules
for i=1:numberModules
    ModuleComposition{i}=find(modulesID==i);                %to find which ROIs belongs to which module
    numberModules=length(ModuleComposition{i});
    NumberModules(i,:) = {i numberModules};
end
ModuleComposition=[NumberModules ModuleComposition'];       %variable containing for each module, the number and list of ROIs
%% Average Clustering Coef and Path length
AveragePathLength = avg_path_matrix(1./Matrix);                           % average path of the network
AverageClustCoeff = avg_clus_matrix(Matrix,'O');                          % average clustering coef. with the Onella method ('O')
                                                                %% Create Final Tables
FinalTableNetworkData= table (N,modularity,numberModules,AverageEdgeWeight,AverageClustCoeff, AveragePathLength);     %Output
FinalTableNetworkData.Properties.VariableNames={'N. ROIs','Modularity','N. of Modules','Average Edge Weight','Average Clust. Coeff.','Average Path Length'};
end