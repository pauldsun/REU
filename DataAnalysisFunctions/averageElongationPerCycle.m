%% Average Hysteresis Elongation of One Material
%{
This function allows you to look at the average elongation per cycle for a
specific material. You can specify the trial range (1:3, etc.) to calculate
over. To just get a plot of the elongation, always put 'n' for doPlot.
%}
function [avgElongationPerCycle, stdElongationPerCycle] = averageElongationPerCycle(material, typeOfTest, trialIdx, doPlot)
switch typeOfTest
    case 'Force'
        baseFolder = '/Users/paulsundstrom/Documents/REU/HysteresisData/ForceControl';
    case 'Position'
        baseFolder = '/Users/paulsundstrom/Documents/REU/HysteresisData/PositionControl';
end
materialFolder = fullfile(baseFolder, sprintf(material));
%firstTrial = hysteresisElongation(material, trialIdx(1), [], 'Force', 'n');
%numCycles = numel(firstTrial{1});
%trialDir = dir(fullfile(materialFolder, 'Trial*'));
numTrials = numel(trialIdx);
%totalElongation = zeros(numTrials, numCycles);
totalElongation = [];

for i = 1:numTrials
    trialNum = trialIdx(i);
    unloadedElongation = hysteresisElongation(material, trialNum, [], typeOfTest, 'n');
    if isempty(totalElongation)
        numCycles = numel(unloadedElongation{1});
        totalElongation = zeros(numTrials, numCycles);
    end
    totalElongation(i,:) = unloadedElongation{1}(:)';
end
avgElongationPerCycle = mean(totalElongation, 1);
stdElongationPerCycle = std(totalElongation, 0, 1);
if strcmpi(doPlot, 'y')
    errorbar(1:numCycles, avgElongationPerCycle, stdElongationPerCycle, '-o', ...
        'LineWidth', 2.5, ...
        'MarkerFaceColor', materialColour(material), ...
        'Color', materialColour(material))
    xlabel('Number of Cycles')
    ylabel('Unloaded Elongation $$\left(mm\right)$$')
    grid on
end
end