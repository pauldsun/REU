baseFolder = '/Users/paulsundstrom/REU/HysteresisData/ForceControl';
materialFolder = fullfile(baseFolder, material);
sampleFolder = fullfile(materialFolder,'UsedSample');
trialDir = dir(fullfile(materialFolder, 'Trial*'));
runDir = dir(fullfile(sampleFolder, 'Run*'));
numTrials = numel(trialDir);
numRuns = numel(runDir);
figure()
grid on
hold on

legendEntries= {};
for trialNumber = 1:1
    folderPath = fullfile(materialFolder, sprintf('Trial%d', trialNumber));
    filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
    data = readtable(filePath);

    data.Load = data.Load * 1000;
    plot(data.Crosshead, data.Load)
    legendEntries{end+1} = sprintf('Trial%d', trialNumber);
end

for runNumber = 1:3
    folderPath = fullfile(sampleFolder, sprintf('Run%d', runNumber));
    filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
    data = readtable(filePath);
    data.Load = data.Load * 1000;
    plot(data.Crosshead, data.Load)
    legendEntries{end + 1} = sprintf('Run%d', runNumber)
    %legendEntries{3 + runNumber} = sprintf('Run%d', runNumber);
end
xlabel('Displacement (mm)')
ylabel('Force (N)')
legend(legendEntries, Location='northwest')