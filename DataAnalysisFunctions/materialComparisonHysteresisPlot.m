%% Visual Comparison of Different Materials Hysteresis
%{
This function inputs a cell of the different materials you wish to look at
and plots them all on the same plot. You need to specify which trial of
each material you want to look at. 
Inputs:
-materials: {'MaterialName1', 'MaterialName2', ...}
-trialNumber: n (where n is an integer)
%}
function [] = materialComparisonHysteresisPlot(materials, trialNumber)
%hold on
%grid on

legendEntries = cell(1, length(materials));

for i = 1:length(materials)
    material = materials{i};
    colour = materialColour(material);

    baseFolder = '/Users/paulsundstrom/REU/BreakingLoadData';
    filePath = fullfile(baseFolder, material, ...
        sprintf('Trial%d', trialNumber), 'DAQ- Crosshead, … - (Timed).csv');

    plotTrialsAndRuns(materials{i}, 1, 'none', 'Force')
    hold on
    legendEntries{i} = sprintf(material);
end

xlabel('Displacement (mm)')
ylabel('Force (N)')
legend(legendEntries, 'Location', 'northeast')
end