%% OUTDATED - USE propertiesBarPlot INSTEAD

function barPlotFirstCycleElongation(materials, typeOfTest)

numMaterials = length(materials);
firstCycleMeans = zeros(1, numMaterials);
firstCycleStds = zeros(1, numMaterials);
barColors = zeros(numMaterials, 3);  % RGB colors

for i = 1:numMaterials
    material = materials{i};
    [avgElongationPerCycle, stdElongationPerCycle] = averageElongationPerCycle(material, typeOfTest, 1:3, 'n');
    
    firstCycleMeans(i) = avgElongationPerCycle(1);
    firstCycleStds(i) = stdElongationPerCycle(1);
    barColors(i,:) = materialColour(material);
end

figure()
b = bar(firstCycleMeans, 'FaceColor', 'flat');
hold on

% Apply colors to bars
for i = 1:numMaterials
    b.CData(i,:) = barColors(i,:);
end

% Add error bars
errorbar(1:numMaterials, firstCycleMeans, firstCycleStds, ...
    'k.', 'LineWidth', 1.5, 'CapSize', 10);

ylabel('Unloaded Elongation (mm) – 1st Cycle')
xticks(1:numMaterials)
xticklabels(materials)
xtickangle(45)
grid on
title('First Cycle Elongation per Material')
end
