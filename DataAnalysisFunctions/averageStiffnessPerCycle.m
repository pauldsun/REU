%% Average Hysteresis Stiffness Per Cycle Over All Trials
%{
This function allows you to look at various trials and calculate the
average stiffness over each cycle. The trialIdx is intented to be a range
such as 1:3, 4:6, 7:9 representing the different speeds, but it will accept
a single value and opperate similar to the calculateLoadingStiffness
function. This is just the calculation, and it is used to plot in the
plotStiffnessPerCycle. Only do one group of trials (1:3, 4:6, 7:9) and do
not cross over because it will then calcualte averages at different speeds.
You can average the stiffness of the first cycle due to its non-linear
behaviour. Skipping the first trial is no longer used.
Inputs:
-material: 'MaterialName'
-typeOfTest: 'Force' or 'Position' (only have 'Force' right now)
-trialIdx: range of trials (ex: 1:4) or 'all'
-skipFirstCycle: 'y' or 'n'
-averageFirstCycle: 'y' or 'n'
%}
function [avgStiffnessPerCycle, stdStiffnessPerCycle] = averageStiffnessPerCycle(material, typeOfTest, trialIdx, skipFirstCycle, averageFirstCycle)
switch typeOfTest
    case 'Force'
        baseFolder = '/Users/paulsundstrom/Documents/REU/HysteresisData/ForceControl';
    case 'Position'
        baseFolder = '/Users/paulsundstrom/Documents/REU/HysteresisData/PositionControl';
end
materialFolder = fullfile(baseFolder, sprintf(material));
trialDir = dir(fullfile(materialFolder, 'Trial*'));
numTrials = length(trialIdx);
%numTrials = numel(trialDir);
numCycles = 15;
totalStiffness = zeros(numTrials, numCycles);

for i = 1:numTrials
    trialNumber = trialIdx(i);
    stiffness = calculateLoadingStiffness(material, typeOfTest, trialNumber, [], 'n', averageFirstCycle);
    totalStiffness(i, :) = stiffness;
end
if strcmpi(skipFirstCycle, 'y')
    avgStiffnessPerCycle = mean(totalStiffness(:,2:end),1);
    stdStiffnessPerCycle = std(totalStiffness(:,2:end), 0, 1);
else 
    avgStiffnessPerCycle = mean(totalStiffness, 1);
    stdStiffnessPerCycle = std(totalStiffness, 0, 1);
end

end
