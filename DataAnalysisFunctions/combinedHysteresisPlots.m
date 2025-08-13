%% OUTDATED USE plotTrialsAndRuns INSTEAD

function [] = combinedHysteresisPlots(material)
baseFolder = '/Users/paulsundstrom/REU/HysteresisData/ForceControl';
materialFolder = fullfile(baseFolder, material);
sampleFolder = fullfile(materialFolder,'UsedSample');
trialDir = dir(fullfile(materialFolder, 'Trial*'));
runDir = dir(fullfile(sampleFolder, 'Run*'));
numTrials = numel(trialDir);
numRuns = numel(runDir);

figure()
hold on
grid on

legendEntries = {};
colors = lines(6);
for trialNumber = 1:numTrials
    folderPath = fullfile(materialFolder, sprintf('Trial%d', trialNumber));
    filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
    data = readtable(filePath);
    data.Load = data.Load * 1000;
    plot(data.Crosshead, data.Load, 'Color', colors(trialNumber, :))
    legendEntries{end + 1} = sprintf('Trial%d', trialNumber);
end

for runNumber = 1:numRuns
    folderPath = fullfile(materialFolder, sprintf('Trial%d', runNumber));
    filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
    data = readtable(filePath);
    data.Load = data.Load * 1000;
    plot(data.Crosshead, data.Load, 'Color', colors(runNumber + 3, :))
    legendEntries{end + 1} = sprintf('Run%d', runNumber);
end
xlabel('Displacement (mm)')
ylabel('Force (N)')