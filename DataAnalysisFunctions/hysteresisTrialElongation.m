%% Hysteresis Elongation **USE hysteresisElongation FUNCTION INSTEAD**
%{
This function looks at the elongation of a single trial of a specific material.
You can specify the type of hysteresis data (force 'or position), which
trial you would like to see, and if you would like the data plotted. The
output of this function is a matrix of the elongation corresponding to each
cycle of the test. Inputs must be strings (except trialNumber).
%}

function [unloadedElongation] = hysteresisTrialElongation(material, typeOfTest, trialNumber, doPlot)
switch typeOfTest
    case 'Force'
        baseFolder = '/Users/paulsundstrom/REU/HysteresisData/ForceControl';
    case 'Position'
        baseFolder = '/Users/paulsundstrom/REU/HysteresisData/PositionControl';
end
folderPath = fullfile(baseFolder, sprintf('%s/Trial%d', material, trialNumber));
%materialFolder = fullfile(baseFolder, material);
%sampleFolder = fullfile(materialFolder,'UsedSample');
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
    legend('Original Data', 'Peaks', 'Troughs', Location='northwest')
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