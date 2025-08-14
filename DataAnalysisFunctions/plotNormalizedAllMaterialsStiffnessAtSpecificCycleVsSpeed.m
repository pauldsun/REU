%% Plotting Stiffness at a Specific Cycle Number vs the Various Speeds
%{
This function uses the plotStiffnessVsSpeed function to plot all of the
materials at a specific cycle on the same plot.
Inputs:
-materials: cell of desired material (folder) names
-trialGroups: cell array of trialIdx vectors, e.g., {1:3, 4:6, 7:9}
-speeds: vector of speeds like [0.1, 0.5, 1.0]
-cycleNumber: the cycle you wish to look at (cannot be 1)
-skipFirstCycle: 'y' or 'n' (always keep as 'n')
-averageFirstCycle: 'y' or 'n'
%}

function plotNormalizedAllMaterialsStiffnessAtSpecificCycleVsSpeed(materials, typeOfTest, trialGroups, speeds, cycleNumber, skipFirstCycle, averageFirstCycle)
hold on
grid on
for i = 1:length(materials)
    material = materials{i};
    colour = materialColour(material);


    [avgStiffAtCycle, stdStiffAtCycle] = plotStiffnessVsSpeed(material, typeOfTest, trialGroups, speeds, cycleNumber, skipFirstCycle, averageFirstCycle, 'n');
    disp(avgStiffAtCycle)
    base = avgStiffAtCycle(1);
    normalizedAvgStiffness = avgStiffAtCycle/base;
    normalizedStdStiffness = stdStiffAtCycle/base;
    errorbar(speeds, normalizedAvgStiffness, normalizedStdStiffness, ...
        '-o', ...
        color= colour,...
        LineWidth= 2.5, ...
        MarkerSize = 7.5, ...
        MarkerFaceColor= colour, ...
        MarkerEdgeColor= colour, ...
        DisplayName= material)
    ylabel(sprintf('Normalized Stiffness at Cycle %d', cycleNumber)) %$$\left(1 = Average Lowest Speed Stiffness\right)$$ inlcude in figure caption
    xlabel('Speed $$\left(mm/s\right)$$')
    legend(Location='northwest')
    %ylim([.94 1.16])
end