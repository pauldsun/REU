%% Breaking Load Plotting
function [breakingLoad] = breakingLoadPlot(material, sampleLength, trial, doPlot)
baseFolder = '/Users/paulsundstrom/Documents/REU/BreakingLoadData';
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


%% PREVIOUS VERSION THAT DID NOT ACCEPT MULTIPLE TRIAL INPUTS
%     elseif isscalar(trial)
%     folderPath = fullfile(lengthFolder, sprintf('Trial%d', trial));
%         filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
%         data = readtable(filePath);
%         data.Load = data.Load * 1000;
%         breakingLoad = max(data.Load);
%         if strcmpi(doPlot, 'y')
%             grid on
%             plot(data.Crosshead, data.Load, Color=colour)
%             xlabel('Displacement (mm)')
%             ylabel('Force (N)')
%             legend(sprintf('Trial%d', trial), Location='northwest')
%         end
% end
% end


%% PREVIOUS VERSION THAT ONLY ACCEPTED TRIAL NUMBERS 1-5
% switch trial
%     case {1,2,3,4,5}
%         folderPath = fullfile(lengthFolder, sprintf('Trial%d', trial));
%         filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
%         data = readtable(filePath);
%         data.Load = data.Load * 1000;
%         breakingLoad = max(data.Load);
%         if strcmpi(doPlot, 'y')
%             grid on
%             plot(data.Crosshead, data.Load, Color=colour)
%             xlabel('Displacement (mm)')
%             ylabel('Force (N)')
%             legend(sprintf('Trial%d', trial), Location='northwest')
%         end
%     case 'all'
%         breakingLoad = zeros(1, length(numTrials));
%         for trialNumber = 1 : numTrials
%             folderPath = fullfile(lengthFolder, sprintf('Trial%d', trialNumber));
%             filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
%             data = readtable(filePath);
%             data.Load = data.Load * 1000;
%             breakingLoad(trialNumber) = max(data.Load);
%             if strcmpi(doPlot, 'y')
%                 grid on
%                 hold on
%                 plot(data.Crosshead, data.Load)
%                 legendEntries{trialNumber} = sprintf('Trial%d', trialNumber);
%             end
%         end
%         if strcmpi(doPlot, 'y')
%             xlabel('Displacement (mm)')
%             ylabel('Force (N)')
%             legend(legendEntries, Location='northwest')
%         end
% end
% end
