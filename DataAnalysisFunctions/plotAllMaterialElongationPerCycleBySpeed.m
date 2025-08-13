%% Plotting Elongation as a Function of Number of Cycles for a Given Speed
%{
This function takes various materials and plots their elongation per cycle
at a specified loading speed. You can only look at one input speed.
Inputs:
-materials: {'MaterialName1', 'MaterialName2', ...}
-typeOfTest: 'Force' or 'Position'
-trialGroups: cell array of trialIdx vectors, e.g., {1:3, 4:6, 7:9}
-skipFirstCycle: 'y' or 'n'
-speeds: vector of speeds like [0.1, 0.5, 1.0]
-targetSpeed: 0.1, 0.5, or 1 (one of the values in speeds)
-doPlot: 'y' or 'n'
%}
function plotAllMaterialElongationPerCycleBySpeed(materials, typeOfTest, trialGroups, speeds, targetSpeed, doPlot)

speedIdx = find(abs(speeds - targetSpeed) < 1e-6);
if isempty(speedIdx)
    error('Speed %.3f mm/s not found in input speeds.', targetSpeed);
end

hold on
grid on
markers = {'s','*','d','^','v','>','<'};
linestyles = {'-', '--', ':'};

for i = 1:length(materials)
    material = materials{i};
    colour = materialColour(material);
    marker = markers{mod(i-1, length(markers)) + 1};

    trialIdx = trialGroups{speedIdx};

    % Replace this with your own function to get unloaded elongation
    % This must return a 1D vector (e.g., [elong1, elong2, ..., elong15])
    [avgElonPerCycle, stdElonPerCycle] = averageElongationPerCycle(material, typeOfTest, trialIdx, 'n');
    if strcmpi(doPlot, 'y')
        errorbar(1:length(avgElonPerCycle), avgElonPerCycle, stdElonPerCycle,...
            '-o', ...
            color= colour,...
            LineWidth= 2.5, ...
            MarkerSize = 7.5, ...
            MarkerFaceColor= colour, ...
            MarkerEdgeColor= colour, ...
            DisplayName= material)
    end
end
if strcmpi(doPlot, 'y')
    xlabel('Cycle Number')
    ylabel('Unloaded Elongation (mm)')
    legend(Location='northeast')
end
end
