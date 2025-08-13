%% Used for (5Cycles) Data only
%{
This function takes a run number in and calculates the elongation with the
option of plotting.
%}

function [unloadedElongation] = hysteresisRunElongation(material, typeOfTest, runNumber, doPlot)
switch typeOfTest
    case 'Force'
        baseFolder = '/Users/paulsundstrom/REU/HysteresisData/ForceControl';
    case 'Position'
        baseFolder = '/Users/paulsundstrom/REU/HysteresisData/PositionControl';
end
baseFolder = '/Users/paulsundstrom/REU/HysteresisData/ForceControl';
materialFolder = fullfile(baseFolder, material);
sampleFolder = fullfile(materialFolder,'UsedSample');
folderPath = fullfile(sampleFolder, sprintf('Run%d', runNumber));
filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
data = readtable(filePath);
data.Load = data.Load * 1000;

[peaks, peakidx] = findpeaks(data.Load, "MinPeakProminence", 50);
[troughs, troughidx] = findpeaks(-data.Load, 'MinPeakProminence', 50);
troughs = -troughs;
peakLocations = data.Crosshead(peakidx);
numCycles = length(peaks);

%add the first and last data points as troughs
troughs = [data.Load(1); troughs; data.Load(end)]; %add the first and last data points as troughs
allTroughidx = [1; troughidx; length(data.Crosshead)];
troughLocations = [data.Crosshead(1); data.Crosshead(troughidx); data.Crosshead(end)];

%plotting the data with max and mins highlighted
if strcmp(doPlot,'y')
    plot(data.Crosshead, data.Load)
    hold on
    plot(peakLocations, peaks, 'r*')
    plot(troughLocations, troughs, 'k*')
    xlabel('Displacement (mm)')
    ylabel('Force (N)')
    legend(sprintf('Run%d',runNumber), 'Peaks', 'Troughs', Location='northwest')
    grid on
end

%loadedElongation = zeros(1, length(peakLocations) - 1);
unloadedElongation = zeros(1, length(troughLocations) - 1);

%create a cell to write to csv
displacements = cell(2, numCycles + 1);
cycles = {'First Cycle', 'Second Cycle', 'Third Cycle', 'Fourth Cycle', 'Fifth Cycle'};
displacements(1,2:end) = cycles;
displacements(1,1) = {'Loaded State'};
displacements(2,1) = {'Loaded'};
displacements(3,1) = {'Unloaded'};

%for i = 1:length(loadedElongation)
%    loadedElongation(i) = peakLocations(i+1) - peakLocations(i);
%    displacements(2,i+1) = {loadedElongation(i)};
%end
for i = 1:length(unloadedElongation)
    unloadedElongation(i) = troughLocations(i+1) - troughLocations(i);
    displacements(3,i+1) = {unloadedElongation(i)};
end
end

