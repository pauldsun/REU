% Plots stiffness for 1 trial and multiple runs with different markers/styles
function plotLoadingStiffnessTrialAndRuns(material, typeOfTest, trialNumber, runNumbers)

hold on
cycleOffset = 0;

% Style options
markers = {'s', 'pentagram', 'd', '^', 'v', '>', '<'};
linestyles = {'--', ':', '-.', '-'};
colour = materialColour(material);

% Plot Trial
stiffness = calculateLoadingStiffness(material, typeOfTest, trialNumber, [], 'n');
numCycles = length(stiffness);
scatter((1:numCycles) + cycleOffset, stiffness, 90, ...
    'Marker', markers{1}, ...
    'Color', colour, ...
    'MarkerFaceColor', colour, ...
    'MarkerEdgeColor', colour, ...
    'DisplayName', sprintf('Trial %d', trialNumber))
cycleOffset = cycleOffset + numCycles;

% Plot Runs
for i = 1:length(runNumbers)
    runStiffness = calculateLoadingStiffness(material, typeOfTest, [], runNumbers(i), 'n');
    numRunCycles = length(runStiffness);
    
    marker = markers{mod(i, length(markers)) + 1};
    linestyle = linestyles{mod(i, length(linestyles)) + 1};

    scatter((1:numRunCycles) + cycleOffset, runStiffness, 90, ...
        'Marker', marker, ...
        'Color', colour, ...
        'MarkerFaceColor', colour, ...
        'MarkerEdgeColor', colour, ...
        'DisplayName', sprintf('Run %d', runNumbers(i)))
    cycleOffset = cycleOffset + numRunCycles;
end

xlabel('Global Cycle Number')
ylabel('Loading Stiffness $$\left(\frac{N}{mm}\right)$$', 'Interpreter', 'latex')
legend('Location', 'northwest')
grid on
end
