%% Used only for (5Cycles) Data
%{
This function plots the elongation per cycle for one trial and all runs
which is then shows the stiffness over all 20 cycles and 4 tests.
Inputs:
-material: 'MaterialName'
-typeOfTest: 'Force' or 'Position'
%}
function [] = sampleStiffness(material, typeOfTest)
trialNumber = 1;
colour = materialColour(material);
trialStiffness = calculateLoadingStiffness(material, typeOfTest, trialNumber, [], 'n', 'y');

totalRunStiffness = [];
for runNumber = 1:3
    runStiffness = calculateLoadingStiffness(material, typeOfTest, [], runNumber, 'n', 'y');
    totalRunStiffness = [totalRunStiffness, runStiffness];
end

totalStiffness = [trialStiffness, totalRunStiffness];
figure()
grid on
hold on
markerStyles = {'o','s', '^', 'd'};
legendEntries = {};
groupStarts = [1, 6, 11, 16];
groupEnds   = [5, 10, 15, 20];
tests = {'Test 1', 'Test 2', 'Test 3', 'Test 4'};

for k = 1:length(groupStarts)
    idxRange = groupStarts(k):groupEnds(k);
    if idxRange(end) <= length(totalStiffness)
        scatter(idxRange, totalStiffness(idxRange), 150, ...
            'Marker', markerStyles{k}, ...
            'MarkerEdgeColor', colour, ...
            'MarkerFaceColor', colour);
        legendEntries{k} = tests{k};
    end
end
%scatter(1:length(totalStiffness), totalStiffness, 50, 'filled', 'MarkerEdgeColor', colour, 'MarkerFaceColor', colour)
legend(legendEntries, 'Location', 'best')
xlabel('Number of Cycles')
ylabel('Loading Stiffness $$\left(\frac{N}{mm}\right)$$')
end
