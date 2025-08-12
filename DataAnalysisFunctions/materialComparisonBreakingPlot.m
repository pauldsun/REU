function [] = materialComparisonBreakingPlot(materials, sampleLength, trialNumber)
%figure()
%hold on
%grid on

legendEntries = cell(1, length(materials));

for i = 1:length(materials)
    material = materials{i};
    colour = materialColour(material);

    baseFolder = '/Users/paulsundstrom/Documents/REU/BreakingLoadData';
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