function [avgBreakingLoad, stdDev] = averageBreakingLoad(material, sampleLength, trial, doPlot)

% materialFolder = fullfile(baseFolder, material);
% lengthFolder = fullfile(materialFolder, sampleLength);
% trialDir = dir(fullfile(lengthFolder, 'Trial*'));
% numTrials = numel(trialDir);
% legendEntries = {};

breakingLoad = breakingLoadPlot(material, sampleLength, trial, doPlot);
avgBreakingLoad = mean(breakingLoad);
stdDev = std(breakingLoad);
end
    % folderPath = fullfile(baseFolder, sprintf('%s/Trial%d', material, trialNumber)
    % filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
    % data = readtable(filePath);
    % data.Load = data.Load * 1000;
