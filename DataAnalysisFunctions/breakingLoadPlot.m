%% Breaking Load Plotting
%{
This function loads the desired data and simply locates the maximum force
value and returns this value as an output. Can take a single, a range, or
all of the trial entries.
Inputs:
-material: 'MaterialName'
-sampleLength: '100mm' or '200mm'
-trial: 1, [1:5], or 'all'
-doPlot: 'y' or 'n'
%}
function [breakingLoad] = breakingLoadPlot(material, sampleLength, trial, doPlot)
baseFolder = '/Users/paulsundstrom/REU/BreakingLoadData';
materialFolder = fullfile(baseFolder, material);
lengthFolder = fullfile(materialFolder, sampleLength);
trialDir = dir(fullfile(lengthFolder, 'Trial*'));
numTrials = numel(trialDir);
legendEntries = {};
colour = materialColour(material);


if ischar(trial) || isstring(trial)
    if strcmpi(trial, 'all')
        trialNames = {trialDir.name};
        trialNumbers = [];
        for k = 1:length(trialNames)
            tokens = regexp(trialNames{k}, 'Trial(\d+)','tokens');
            if ~isempty(tokens)
                trialNum = str2double(tokens{1});
                if trialNum >= 1
                    trialNumbers(end+1) = trialNum;
                end
            end
        end
        trialNumbers = sort(trialNumbers);
    else
        error('Invalid string input')
    end
elseif isnumeric(trial)
    trialNumbers = trial;
end


breakingLoad = zeros(1, length(trialNumbers));


for i = 1 : length(trialNumbers)
    trialNumber = trialNumbers(i);
    folderPath = fullfile(lengthFolder, sprintf('Trial%d', trialNumber));
    filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
    data = readtable(filePath);
    data.Load = data.Load * 1000;
    breakingLoad(i) = max(data.Load);
    if strcmpi(doPlot, 'y')
        grid on
        hold on
        plot(data.Crosshead, data.Load, DisplayName= sprintf('Trial%d', trialNumber))
        %legendEntries{trialNumber} = sprintf('Trial%d', trialNumber);
        xlabel('Displacement (mm)')
        ylabel('Force (N)')
        legend(Location='best')
    end
end
if strcmpi(doPlot, 'y')
    xlabel('Displacement (mm)')
    ylabel('Force (N)')
    %legend(legendEntries, Location='northwest')
end
end