function [] = sampleElongation(material, typeOfTest)
trialNumber = 1;
trialElongation = hysteresisTrialElongation(material, typeOfTest, trialNumber, 'n');
colour = materialColour(material);
totalRunElongation = []
for runNumber = 1:3
    runElongation = hysteresisRunElongation(material, typeOfTest, runNumber, 'n');
    totalRunElongation = [totalRunElongation, runElongation];
end
totalElongation = [trialElongation, totalRunElongation];
% 0.74808 %steelLargeDiameter
% 0.27342857142857 %DuraBraid
% 0.3810 %Stealth
% 0.23828571428571 %Dyneema


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
    if idxRange(end) <= length(totalElongation)
        scatter(idxRange, totalElongation(idxRange), 150, ...
            'Marker', markerStyles{k}, ...
            'MarkerEdgeColor', colour, ...
            'MarkerFaceColor', colour);
        legendEntries{k} = tests{k};
    end
end

legend(legendEntries, 'Location', 'best')
%scatter(1:length(totalElongation), totalElongation, 50, "filled", MarkerEdgeColor=colour, MarkerFaceColor=colour)
legend(legendEntries, Location='best')
xlabel('Number of Cycles')
ylabel('Elongation (mm)')
