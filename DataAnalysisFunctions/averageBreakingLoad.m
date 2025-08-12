%% Average Breaking Load Calulcation
%{
This function calls the breakingLoadPlot function for the inputted trials
and computes the average over them. You can look at a various number of
trials.
Inputs:
-material: 'MaterialName'
-sampleLength: '100mm' or '200mm'
-trial: 1, [1:3], 'all'
-doPlot: 'y' or 'n'
%}

function [avgBreakingLoad, stdDev] = averageBreakingLoad(material, sampleLength, trial, doPlot)
breakingLoad = breakingLoadPlot(material, sampleLength, trial, doPlot);
avgBreakingLoad = mean(breakingLoad);
stdDev = std(breakingLoad);
end