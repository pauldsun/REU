%% Plotting All Trails of Hysteresis Tests of a Specific Material
%{
This function currently plots each trial of a specified material on the same
plot to compare all three trails. Can change the materials or number of
trails if more data is collected. The input is the material you wish to
look at the type of hysteresis test you wish to view (force or position).
Inputs must be strings.
%}
function [] = plotEveryHysteresisTrialOfOneMaterial(material, typeOfTest)
switch typeOfTest
    case 'Force'
        baseFolder = '/Users/paulsundstrom/REU/HysteresisData/ForceControl';
    case 'Position'
        baseFolder = '/Users/paulsundstrom/REU/HysteresisData/PositionControl';
end

%material = {'material'};
numTrials = 3;
legendEntries = cell(1, numTrials);
cm = lines(6);
for trialNumber = 1:numTrials
    folderPath = fullfile(baseFolder, sprintf('%s/Trial%d', material, trialNumber));
    filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
    data = readtable(filePath);
    plot(data.Crosshead, data.Load * 1000, 'Color',cm(trialNumber, :))
    legendEntries{trialNumber} = sprintf('Trial%d', trialNumber);
    xlabel('Displacement (mm)')
    ylabel('Force (N)')
    grid on
    hold on
end
legend(legendEntries, Location='northwest')
end