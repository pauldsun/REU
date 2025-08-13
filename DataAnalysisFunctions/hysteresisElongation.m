%% Calculate Elongation of Any Hysteresis Trial or Run
%{
This function allows you to call any number of trails/runs and collects
their elongations in their repsective cell such that each row of the cell
correspods to a trial number/run number. The inputs are the material name,
the trial/run number (you can do multiple by 1:3), and 'Position' or
'Force' for the type of test. If you do not want either trails/runs you
input [].
%}

function [trialElongations, runElongations] = hysteresisElongation(material, trials, runs, typeOfTest, doPlot)
switch typeOfTest
    case 'Force'
        baseFolder = '/Users/paulsundstrom/REU/HysteresisData/ForceControl';
    case 'Position'
        baseFolder = '/Users/paulsundstrom/REU/HysteresisData/PositionControl';
end
if nargin < 5
    doPlot = 'y';
end
materialFolder = fullfile(baseFolder, material);
sampleFolder = fullfile(materialFolder,'UsedSample');
trialDir = dir(fullfile(materialFolder, 'Trial*'));
runDir = dir(fullfile(sampleFolder, 'Run*'));
numTrials = numel(trialDir);
numRuns = numel(runDir);
doPlotTrials = false;
doPlotRuns = false;
colour = materialColour(material);
showPeakLegend = true;
showTroughLegend = true;
peakProm = 50;
minCyclesRequired = 15;



if ischar(trials) || isstring(trials)
    if strcmpi(trials, 'all')
        trialIdx = 1:numTrials;
    elseif strcmpi(trials, 'none')
        doPlotTrials = false;
    else
        error('Invalid trials input.')
    end
else
    trialIdx = trials;
end

if ischar(runs) || isstring(runs)
    if strcmpi(runs, 'all')
        runIdx = 1:numRuns;
    elseif strcmpi(runs, 'none')
        doPlotRuns = false;
    else
        error('Invalid runs input.')
    end
else
    runIdx = runs;
end

trialElongations = cell(length(trialIdx), 1);
runElongations = cell(length(runIdx), 1);

if numel(trials) > 0
    for i = 1:length(trialIdx)
        trialNumber = trialIdx(i);
        folderPath = fullfile(baseFolder, sprintf('%s/Trial%d', material, trialNumber));
        filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
        data = readtable(filePath);
        data.Load = data.Load * 1000;
        %decrease prominence until enough peaks are found
        
        while true
            [peaks, peakidx] = findpeaks(data.Load, "MinPeakProminence", peakProm);
            [troughs, troughidx] = findpeaks(-data.Load, "MinPeakProminence", peakProm);
            if length(peaks) >= minCyclesRequired
                break
            end
            peakProm = peakProm * 0.8;  % reduce prominence
            if peakProm < 1
                warning('Peak prominence reduced below threshold. Only %d cycles found.', length(peaks));
                break
            end
        end
        % [peaks, peakidx] = findpeaks(data.Load, "MinPeakProminence", 50);
        % [troughs, troughidx] = findpeaks(-data.Load, 'MinPeakProminence', 50);
        troughs = -troughs;
        peakLocations = data.Crosshead(peakidx);
        numCycles = length(peaks);

        %add the first and last data points as troughs
        troughs = [data.Load(1); troughs; data.Load(end)]; %add the first and last data points as troughs
        allTroughidx = [1; troughidx; length(data.Crosshead)];
        troughLocations = [data.Crosshead(1); data.Crosshead(troughidx); data.Crosshead(end)];

        if strcmpi(doPlot,'y')
            grid on
            hold on
            doPlotTrials = true;
            if doPlotTrials == true
                plot(data.Crosshead, data.Load, DisplayName=sprintf('Trial%d', trialNumber))
                plot(peakLocations, peaks, 'r*', HandleVisibility='off')
                plot(troughLocations, troughs, 'k*', HandleVisibility='off')
                xlabel('Displacement (mm)')
                ylabel('Force (N)')
            end
        end

        %loadedElongation = zeros(1, length(peakLocations) - 1);
        unloadedElongation = zeros(1, length(troughLocations) - 1);

        %create a cell to write to csv
        %displacements = cell(2, numCycles + 1);
        %cycles = arrayfun(@(trialNumber) sprintf('Cycle %d', trialNumber), 1:numCycles, 'UniformOutput', false);
        %cycles = {'First Cycle', 'Second Cycle', 'Third Cycle', 'Fourth Cycle', 'Fifth Cycle'};
        %displacements(1,2:end) = cycles;
        %displacements(1,2:end) = cycles;
        %displacements(1,1) = {'Loaded State'};
        %displacements(2,1) = {'Loaded'};
        %displacements(2,1) = {'Unloaded'};

        %for i = 1:length(loadedElongation)
        %    loadedElongation(i) = peakLocations(i+1) - peakLocations(i);
        %    displacements(2,i+1) = {loadedElongation(i)};
        %end
        %for i = 1:length(unloadedElongation)
        %    unloadedElongation(i) = troughLocations(i+1) - troughLocations(i);
        %    displacements(3,i+1) = {unloadedElongation(i)};
        %end
        unloadedElongation = troughLocations(2:end) - troughLocations(1:end-1);
        trialElongations{i} = unloadedElongation;
    end
elseif numel(runs) > 0
    for i = 1:length(runIdx)
        runNumber = runIdx(i);
        folderPath = fullfile(sampleFolder, sprintf('Run%d', runNumber));
        filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
        data = readtable(filePath);
        data.Load = data.Load * 1000;
        %decrease prominence until enough peaks are found
        while true
            [peaks, peakidx] = findpeaks(data.Load, "MinPeakProminence", peakProm);
            [troughs, troughidx] = findpeaks(-data.Load, "MinPeakProminence", peakProm);
            if length(peaks) >= minCyclesRequired
                break
            end
            peakProm = peakProm * 0.8;  % reduce prominence
            if peakProm < 1
                warning('Peak prominence reduced below threshold. Only %d cycles found.', length(peaks));
                break
            end
        end
        % [peaks, peakidx] = findpeaks(data.Load, "MinPeakProminence", 50);
        % [troughs, troughidx] = findpeaks(-data.Load, 'MinPeakProminence', 50);
        troughs = -troughs;
        peakLocations = data.Crosshead(peakidx);
        numCycles = length(peaks);

        %add the first and last data points as troughs
        troughs = [data.Load(1); troughs; data.Load(end)]; %add the first and last data points as troughs
        allTroughidx = [1; troughidx; length(data.Crosshead)];
        troughLocations = [data.Crosshead(1); data.Crosshead(troughidx); data.Crosshead(end)];
        if strcmpi(doPlot,'y')
            grid on
            hold on
            doPlotTrials = true;
            if doPlotRuns == true
                %plotting the data with max and mins highlighted
                plot(data.Crosshead, data.Load, DisplayName=sprintf('Run%d', runNumber))
                plot(peakLocations, peaks, 'r*', HandleVisibility='off');
                plot(troughLocations, troughs, 'k*', HandleVisibility='off');
            end
        end

        if i == length(trialIdx)
            if showPeakLegend
                plot(peakLocations, peaks, 'r*', 'DisplayName', 'Peaks');
                showPeakLegend = false;
            else
                plot(peakLocations, peaks, 'r*', 'HandleVisibility', 'off');
            end

            if showTroughLegend
                plot(troughLocations, troughs, 'k*', 'DisplayName', 'Troughs');
                showTroughLegend = false;
            else
                plot(troughLocations, troughs, 'k*', 'HandleVisibility', 'off');
            end
        end

        xlabel('Displacement (mm)')
        ylabel('Force (N)')

        %loadedElongation = zeros(1, length(peakLocations) - 1);
        unloadedElongation = zeros(1, length(troughLocations) - 1);

        %create a cell to write to csv
        %displacements = cell(2, numCycles + 1);
        %cycles = arrayfun(@(trialNumber) sprintf('Cycle %d', trialNumber), 1:numCycles, 'UniformOutput', false);
        %cycles = {'First Cycle', 'Second Cycle', 'Third Cycle', 'Fourth Cycle', 'Fifth Cycle'};
        %displacements(1,2:end) = cycles;
        %displacements(1,1) = {'Loaded State'};
        %displacements(2,1) = {'Loaded'};
        %displacements(2,1) = {'Unloaded'};

        %for i = 1:length(loadedElongation)
        %    loadedElongation(i) = peakLocations(i+1) - peakLocations(i);
        %    displacements(2,i+1) = {loadedElongation(i)};
        %end
        %for i = 1:length(unloadedElongation)
        %    unloadedElongation(i) = troughLocations(i+1) - troughLocations(i);
        %    displacements(3,i+1) = {unloadedElongation(i)};
        %end
        unloadedElongation = troughLocations(2:end) - troughLocations(1:end-1);
        runElongations{i} = unloadedElongation;
    end
end
if strcmpi(doPlot, 'y')
    legend(Location='northwest')
end
end
