%% Plotting Normalized Stiffness Across All Cycles for Trial 1 and Runs
%{
This function is for the outdated 5 cycle data initially collected. This
data is in different folders than the usual material name folders, thus the
materials cell inputed needs to reflect the data folder names. There are
only 4 materials to be plotted here due to the lack of samples at the time
of data collection. Run 1 is 4 days after the Trial 1. Runs 2 and 3 are only
an arbitrarily small amount of time inbetween each but the sample was
completely untensioned.
Inputs:
-materials = {'DuraBraid(5Cycles)', 'Stealth(5Cycles)', 'Dyneema(5Cycles)', 'SteelCableLD(5Cycles)'}
-typeOfTest = 'Force' or 'Position' (only use 'Force')
-averageFirstCycle: 'y' or 'n' (always use 'y')

%}
function plotNormalizedStiffnessTrialAndRunsAcrossMaterials(materials, typeOfTest, averageFirstCycle)
markers = {'s', 'pentagram', 'd', '^', 'v', '>', '<'};
linestyles = {'--', ':', '-.', '-'};
hold on

for i = 1:length(materials)
    material = materials{i};
    colour = materialColour(material);
    marker = markers{mod(i-1, length(markers)) + 1};
    linestyle = linestyles{mod(i-1, length(linestyles)) + 1};

    trialStiff = calculateLoadingStiffness(material, typeOfTest, 1, [], 'n', averageFirstCycle);
    runStiffAll = [];
    for r = 1:3
        runStiff = calculateLoadingStiffness(material, typeOfTest, [], r, 'n', averageFirstCycle);
        runStiffAll = [runStiffAll, runStiff];
    end

    fullStiff = [trialStiff, runStiffAll];
    base = fullStiff(1);
    normStiff = fullStiff / base;

    scatter(1:length(normStiff), normStiff, 125, ...
        'Marker', marker, ...
        'Color', colour, ...
        'MarkerFaceColor', colour, ...
        'MarkerEdgeColor', colour, ...
        'DisplayName', erase(material, '(5Cycles)'))
end

xlabel('Cycle Number')
ylabel('Normalized Loading Stiffness')
ylim([1 2.85])
legend('Location', 'northeast')
grid on
end
