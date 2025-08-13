%% Plotting Hysteresis Trials and/or Runs
%{
This function inputs the desired material and allows you to choose which
combination of trials and runs you would like to view. You may input a
single trial/run number, an array of trials/runs (1:2 or 2:3), 'all', or
'none' to view a plot of that combination.
Inputs:
-material: 'MaterialName'
-trails: n, n:m, or 'all' (where n & m are integers)
-runs: n, n:m, or 'all' (where n & m are integers)
-typeOfTest: 'Force' or 'Position'
%}

function [] = plotTrialsAndRuns(material, trials, runs, typeOfTest)
switch typeOfTest
    case 'Force'
        baseFolder = '/Users/paulsundstrom/REU/HysteresisData/ForceControl';
    case 'Position'
        baseFolder = '/Users/paulsundstrom/REU/HysteresisData/PositionControl';
end
materialFolder = fullfile(baseFolder, material);
sampleFolder = fullfile(materialFolder,'UsedSample');
trialDir = dir(fullfile(materialFolder, 'Trial*'));
runDir = dir(fullfile(sampleFolder, 'Run*'));
numTrials = numel(trialDir);
numRuns = numel(runDir);
legendEntries = {};
doPlotTrials = true;
doPlotRuns = true;
colour = materialColour(material);
warning('off', 'MATLAB:table:ModifiedAndSavedVarnames');
%linestyles = {'-', '--', '-.'};

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
if doPlotTrials == true || doPlotRuns == true
    grid on
    hold on
if doPlotTrials == true
    for trialNumber = trialIdx
        folderPath = fullfile(materialFolder, sprintf('Trial%d', trialNumber));
        filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
        data = readtable(filePath);
        data.Load = data.Load * 1000;
        plot(data.Crosshead, data.Load, Color=colour)
        legendEntries{end+1} = sprintf('Trial%d', trialNumber);
    end
end
if doPlotRuns == true
    for runNumber = runIdx
        folderPath = fullfile(sampleFolder, sprintf('Run%d', runNumber));
        filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
        data = readtable(filePath);
        data.Load = data.Load * 1000;
        plot(data.Crosshead, data.Load, Color=colour)
        legendEntries{end+1} = sprintf('Run%d', runNumber);
    end
end
xlabel('Displacement (mm)')
ylabel('Force (N)')
legend(legendEntries, Location='best')
end
end