function [CalciumEventsTable, ISITable, SingleParameterTable]=singleROIAnalysis(processed_analysis)
%Input
%processed_analysis.m file

%Output:
% 1) CalciumEventsTable;
% 2) ISITable;
% 3) SingleParameterTable containing:
%   - meanSampleFrequency (events/min);
%   - percentageActiveROI;
%   - SyncIndex.
%% To create a table in which each column is the number of spikes per ROI
Spike=processed_analysis.Spikes_cell;   % to extract the file
numberROI=size(Spike,1);                % to calculate how many ROIs
maxspike=0;                             % to preallocate the variable
for i=1:numberROI                       % in order to create a table, all the columns must have the same size. This loop aims to fill the gaps with 'NaN'.
    spikearray=Spike{i,1};              % to extract each ROI
    numspike=length(spikearray);        % to count how many spikeas are extracted
    if numspike>maxspike                % to update the 'maxspike' variable if the number of spikes is greater than the previous ROI
        maxspike=numspike;
    end
end
ROI = zeros(maxspike, numberROI);
for j=1:numberROI                                                                   % to extract all the ROI, check their lenght and fill eventually the gaps with NaN
    spikearray=Spike{j,1};
    if length(spikearray)<maxspike
        spikearray(length(spikearray)+1:maxspike)=NaN;                              % to preserve the rectangular shape of the matrix
    end
    ROI(:,j)=transpose(spikearray);
end
ISI=diff(ROI)./processed_analysis.fps;                                              % to calculate the ISI for each ROI
% ROI_ISI=mean(ISI,'omitnan');                                                        % to calculate the mean ISI for each ROI
% meanROIISI=mean(ROI_ISI,'omitnan')                                                  % to calculate the mean ISI of the sample
time=((length(transpose(processed_analysis.F_whole)))-1)/processed_analysis.fps;    % to store the time of recording using the number of points and the fps decleared using FLUOROSNAAP
NumberEvents=sum(~isnan(ISI));                                                      % to calculate the number of events per trace (count non NaN elements)
AverageFrequency=mean(NumberEvents)/(time/60);                                      % to calculate the mean frequency of the sample (Events/min)
nonActiveROI=0;                                                                     % to preallocate the nonActiveROI variable
for k=1:numberROI                                                                   % to calculate the percentage of ROI with at least one event
    isNan=isnan(ROI(:,k));                                                          % check the kth column
    if sum(isNan)==maxspike                                                         % if the number of NaN element is equal to the length of the column, it means that there is no event in that ROI
        nonActiveROI=nonActiveROI+1;
    end
end
percentageActiveROI=((numberROI-nonActiveROI)/numberROI)*100;
%% Organize Outputs
CalciumEventsTable=array2table(ROI);
ISITable=array2table(ISI);
SyncIndex=processed_analysis.SI;
SingleParameterTable=table(AverageFrequency, percentageActiveROI, SyncIndex);
SingleParameterTable.Properties.VariableNames={'Average Frequency(events/min)','% active ROIs','Sync Index'};
end