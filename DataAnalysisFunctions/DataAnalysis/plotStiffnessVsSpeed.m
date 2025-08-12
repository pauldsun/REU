%% Plot the Average Stiffness at a specific Cycle # for a Given Material
%{
This function allows you to look at a specific cycle number and material, 
and plot the average stiffness at that cycle for various speeds.

trialGroups: cell array of trialIdx vectors, e.g., {1:3, 4:6, 7:9}
speeds: vector of speeds like [0.1, 0.5, 1.0]

Cannot input cycle 1 becasue stiffness is not well defined for the first
cycle(non linear).
%}
function [avgStiffnessAtCycle, stdStiffnessAtCycle] = plotStiffnessVsSpeed(material, typeOfTest, trialGroups, speeds, cycleNumber, skipFirstCycle, averageFirstCycle, doPlot)
if strcmpi(skipFirstCycle, 'y')
        if cycleNumber == 1
            error('Cycle 1 is excluded when skipFirstCycle = "y". Choose a later cycle.');
        end
        cycleIdx = cycleNumber - 1;  % since cycle 2 becomes index 1
    else
        cycleIdx = cycleNumber;
end
numSpeeds = length(speeds);
avgStiffnessAtCycle = zeros(1, numSpeeds);
stdStiffnessAtCycle = zeros(1, numSpeeds);

for i = 1:numSpeeds
    trials = trialGroups{i};
    [avgStiffness, stdStiffness] = averageStiffnessPerCycle(material, typeOfTest, trials, skipFirstCycle, averageFirstCycle);
    avgStiffnessAtCycle(i) = avgStiffness(cycleIdx);
    stdStiffnessAtCycle(i) = stdStiffness(cycleIdx);
end
if strcmpi(doPlot, 'y')
    errorbar(speeds, avgStiffnessAtCycle, stdStiffnessAtCycle, '-o', ...
        'LineWidth', 2, ...
        'MarkerFaceColor', materialColour(material), ...
        'Color', materialColour(material))
    xlabel('Speed $$\left(\frac{mm}{s}\right)$$')
    ylabel(strcat(sprintf('Stiffness at Cycle %d', cycleNumber), '$$\left(\frac{N}{mm}\right)$$'))
    grid on
else
end
end
