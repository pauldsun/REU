%% Plotting the Stiffness As a Function of Cycles for One Speed For All Materials
%{
This function plots the normalized stiffness across all cycles, for all of 
the specified materials, at a specified speed (targetSpeed).
Inputs:
-materials: cell {'DuraBraid', ...}
-typeOfTest: 'Force' or 'Position' (only have force at the moment)
-trialGroups: cell array of trialIdx vectors, e.g., {1:3, 4:6, 7:9}
-speeds: vector of speeds like [0.1, 0.5, 1.0]
-targetSpeed: a numerical value of speed from speeds array (ex: 0.1)
-skipFirstCycle: 'y' or 'n' (say no and average instead)
-averageFirstCylce: 'y' or 'n'
%}
function plotNormalizedStiffnessForOneSpeedSameGroups(materials, typeOfTest, trialGroups, speeds, targetSpeed, skipFirstCycle, averageFirstCycle)
% Plots normalized stiffness vs cycle at one speed across multiple materials
% using the same trialGroups structure for all

markers = {'s','pentagram','d'};
linestyles = {'--', ':', '-.'};
figure()
hold on
legendEntries = cell(1,length(materials));

speedIdx = find(abs(speeds - targetSpeed) < 1e-6);
if isempty(speedIdx)
    error('Speed %.3f mm/s not found in input speeds', targetSpeed);
end

for i = 1:length(materials)
    material = materials{i};
    colour = materialColour(material);
    trials = trialGroups{speedIdx};

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
    plot(x, normAvg, ...
        'Marker', markers{mod(i-1,length(markers))+1}, ...
        'LineStyle', linestyles{2}, ...
        'Color', colour, ...
        'MarkerFaceColor', colour, ...
        'LineWidth', 2.5)

    legendEntries{i} = material;
end

xlabel('Cycle Number')
ylabel(sprintf('Normalized Stiffness at $$%.2f$$ mm/s', targetSpeed))
legend(legendEntries, 'Location', 'northwest')
ylim([1 2.9])
grid on
hold off
end
