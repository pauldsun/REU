%% Plotting Three Lines for the Various Speeds of Stiffness Per Cycle
%{
This function uses the averageStiffnessPerCycle function to calculate and
plot the stiffnesses as a function of cycles for the three different
speeds for one specified material. Inputs have the following format:
-trialGroups: cell array of trialIdx vectors, e.g., {1:3, 4:6, 7:9}
-skipFirstCycle: 'y' or 'n'
-speeds: vector of speeds like [0.1, 0.5, 1.0]
-skipFirstCycle: 'y' or 'n' (keep as 'n')
-averageFirstCycle: 'y' or 'n' (keep as 'y')
-doPlot: 'y' or 'n'
%}

function [avgStiffnessPerCycle, stdStiffnessPerCycle] = plotAllCycleStiffnessBySpeed(material, typeOfTest, trialGroups, speeds, skipFirstCycle, averageFirstCycle, doPlot)
legendEntries = cell(1,length(trialGroups));
colour = materialColour(material);
markers = {'s','*','d'};
linestyles = {'-', '--', ':'};
for i = 1:length(trialGroups)
    trials = trialGroups{i};
    [avgStiffnessPerCycle, stdStiffnessPerCycle] = averageStiffnessPerCycle(material, typeOfTest, trials, skipFirstCycle, averageFirstCycle);
    if strcmpi(doPlot, 'y')
        x = 2:length(avgStiffnessPerCycle)+1;
        errorbar(x, avgStiffnessPerCycle, stdStiffnessPerCycle, ...
            Marker=markers{i}, ...
            LineStyle=linestyles{i}, ...
            Color=colour, ...
            MarkerFaceColor=colour, ...
            Linewidth= 2.5)
        hold on
        legendEntries{i} = strcat(sprintf('%.2f', speeds(i)), '$$mm/s$$');
    end
end
if strcmpi(doPlot, 'y')
    xlabel('Number of Cycles')
    ylabel('Stiffness $$\left(\frac{N}{mm}\right)$$')
    legend(legendEntries, Location='northwest')
end
end