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
