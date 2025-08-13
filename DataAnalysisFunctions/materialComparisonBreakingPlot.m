%% Visual Comparison of Different Materials Breaking Load
%{
This function plots one breakin load trial of the desired materials on the
same plot to visualize the difference in raw data between each material.
Inputs:
-materials: {'MaterialName1', 'MaterialName2', ...}
-sampleLength: '100mm' or '200mm'
-trialNumber: n (where n is an integer)
%}
function [] = materialComparisonBreakingPlot(materials, sampleLength, trialNumber)

legendEntries = cell(1, length(materials));

for i = 1:length(materials)
    material = materials{i};
    colour = materialColour(material);

    baseFolder = '/Users/paulsundstrom/REU/BreakingLoadData';
    filePath = fullfile(baseFolder, material, sampleLength, ...
        sprintf('Trial%d', trialNumber), 'DAQ- Crosshead, … - (Timed).csv');

    breakingLoadPlot(materials{i},sampleLength, trialNumber, 'y')
    hold on
    legendEntries{i} = sprintf(material);
    %legendEntries{i} = sprintf('%s Trial %d', material, trialNumber);
end

xlabel('Displacement (mm)')
ylabel('Force (N)')
ylim([0 600])
legend(legendEntries, 'Location', 'northeast')
end