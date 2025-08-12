%% Plotting the Normalized Stiffness Per Cycle of One Material at Every Speed 
%{
This function takes in only one specific material, and plots the normalized
stiffness per cycle at each of the different speeds. There will be three
lines, one for each speed.
Inputs:
-material: character array of material (folder) name
-typeOfTest: 'Force' or 'Position' (only have force at the moment)
-trialGroups: cell array of trialIdx vectors, e.g., {1:3, 4:6, 7:9}
-speeds: vector of speeds like [0.1, 0.5, 1.0]
-targetSpeed: a numerical value of speed from speeds array (ex: 0.1)
-skipFirstCycle: 'y' or 'n' (say no and average instead)
-averageFirstCylce: 'y' or 'n'
%}
function [normAvgStiffness, normStdStiffness] = plotNormalizedCycleStiffnessOneMaterialBySpeed(material, typeOfTest, trialGroups, speeds, skipFirstCycle, averageFirstCycle)

colour = materialColour(material);
markers = {'s','pentagram','d'};
linestyles = {'-', '--', ':'};

figure()
hold on
legendEntries = cell(1,length(trialGroups));

for i = 1:length(trialGroups)
    trials = trialGroups{i};
    [avgStiff, stdStiff] = averageStiffnessPerCycle(material, typeOfTest, trials, skipFirstCycle, averageFirstCycle);
    base = avgStiff(1);
    
    normAvg = avgStiff / base;
    normStd = zeros(size(avgStiff));
    
    for j = 1:length(avgStiff)
        r = normAvg(j);
        x = avgStiff(j);
        sx = stdStiff(j);
        a = base;
        sa = stdStiff(1);
        normStd(j) = r * sqrt((sx/x)^2 + (sa/a)^2);
    end
    if strcmpi(skipFirstCycle, 'y')
        x = 2:15;
    else
        x = 1:15;
    end
    errorbar(x, normAvg, normStd, ...
        'Marker', markers{i}, ...
        'LineStyle', linestyles{i}, ...
        'Color', colour, ...
        'MarkerFaceColor', colour, ...
        'LineWidth', 2.5)

    legendEntries{i} = sprintf('%.2f mm/s', speeds(i));
    
    normAvgStiffness{i} = normAvg;
    normStdStiffness{i} = normStd;
end

xlabel('Cycle Number')
ylabel('Normalized Stiffness')
legend(legendEntries, 'Location','northwest')
grid on
hold off
end
