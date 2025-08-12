function propertiesBarPlot(materials, property, doSave, targetSpeed)
if nargin < 4
    targetSpeed = 0.1;
end
speeds = [0.1, 0.5, 1];
speedIdx = find(speeds == targetSpeed);
trialRange = (speedIdx - 1) * 3 + (1:3);
if strcmpi(property, 'elongation')
    lengths = {'200mm'};
else
    lengths = {'100mm', '200mm'};
end
numLengths = length(lengths);
numMaterials = length(materials);

avgValues = zeros(numMaterials, numLengths);
stdValues = zeros(numMaterials, numLengths);

for i = 1:numMaterials
    material = materials{i};
    colour = materialColour(material);
    for j = 1:numLengths
        sampleLength = lengths{j};


        switch lower(property)
            case 'stiffness'
                [meanStiffness, stdStiffness, ~, ~] = breakingLoadStiffness(material, sampleLength, 'all', 'n');
                avgValues(i,j) = meanStiffness;
                stdValues(i,j) = stdStiffness;
                yaxis = {'Stiffness (N/mm)'};
                ylim([0 350])
            case 'breaking load'
                [breakingLoad] = breakingLoadPlot(material, sampleLength, 'all', 'n');
                avgValues(i,j) = mean(breakingLoad);
                stdValues(i,j) = std(breakingLoad);
                yaxis = {'Breaking Load (N)'};
            case 'modulus of elasticity'
                [~,~,meanModulus,stdModulus,~] = breakingLoadStiffness(material, sampleLength, 'all', 'n');
                avgValues(i,j) = meanModulus;
                stdValues(i,j) = stdModulus;
                yaxis = {'Modulus of Elasticity (GPa)'};
            case 'elongation'
                [avgElonPerCycle, stdElonPerCycle] = averageElongationPerCycle(material, 'Force', trialRange, 'n');
                avgValues(i,j) = avgElonPerCycle(1);
                stdValues(i,j) = stdElonPerCycle(1);
                yaxis = {'First Cycle Elongation (mm)'};
        end
    end
end
b = bar(avgValues, 'grouped');
hold on
grid on
for j = 1:numLengths
    b(j).FaceColor = "flat";
    cData = zeros(numMaterials, 3);
    for i = 1:numMaterials
        cData(i,:) = materialColour(materials{i});
    end
    b(j).CData = cData;
end

ngroups = numMaterials;
nbars = numLengths;
groupwidth = min(0.8, nbars/(nbars+1.5));
for j = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*j-1) * groupwidth / (2*nbars);
    errorbar(x, avgValues(:,j),stdValues(:,j), 'k', LineStyle='none', LineWidth= 2, CapSize=12)
end

if numLengths == 2
    % 1. Hatch the main bars
    hatchfill2(b(1), 'single', 'HatchLineWidth', 1.5);
    hatchfill2(b(2), 'cross', 'HatchLineWidth', 1.5);

    % 2. Create the legend
    [~, object_h, ~, ~] = legendflex(b, {'100mm', '200mm'}, ...
        'ncol', 2, ...
        'anchor', {'nw','nw'}, ...
        'buffer', [10, -10]);

    % 3. Get patches from legend objects (skip hggroup layer)
    legendPatch1 = findobj(object_h(3), 'Type', 'patch');
    legendPatch2 = findobj(object_h(4), 'Type', 'patch');

    % 4. Set patch face to white
    set(legendPatch1, 'FaceColor', [1 1 1]);
    set(legendPatch2, 'FaceColor', [1 1 1]);

    % 5. Apply hatching to legend patches
    hatchfill2(legendPatch1, 'single', 'HatchColor', 'k', 'HatchDensity', 10);
    hatchfill2(legendPatch2, 'cross',  'HatchColor', 'k', 'HatchDensity', 10);
end
    xticklabels(materials)
    ylabel(yaxis)
    ylim([0, ylim(gca)*[0;1]]);




if strcmpi(doSave, 'y')
    folderPath = '/Users/paulsundstrom/Documents/REU/DataAnalysis/Plots';
    saveas(gcf, fullfile(folderPath, sprintf('%sBarPlot.png',property)));
end

end