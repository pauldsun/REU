%% Create a Table of Set Properties for Any Desired Materials
%{
This function takes deisred materials, calculates all of the
properties I am interested in, and compiles the values in a table that can
be outputted as a csv.
Input:
-materials: {'MaterialName1', 'MaterialName2', ...}
-doSave: 'y' or 'n' (will save as a csv to Results folder)
%}
function [properties] = createPropertiesTable(materials, doSave)

categories = {'Material', 'Diameter (mm)', 'Length (mm)','Stiffness (N/mm)', ...
    'Breaking Load (N)', 'Modulus of Elasticity (GPa)'};
lengths = {'100mm', '200mm'};
properties = cell((length(materials)+1) * length(lengths), length(categories));
properties(1,:) = categories;

rowIdx = 2;
for i = 1:length(materials)
    material = materials{i};
    for j = 1:length(lengths)
        sampleLength = lengths{j};
        [meanStiffness, stiffnessStd, meanModulus, stdModulus, diameter] = breakingLoadStiffness(material, sampleLength, 'all', 'n');
        [avgBreakingLoad, breakingLoadStd] = averageBreakingLoad(material, sampleLength, 'all', 'n');
        properties{rowIdx, 1} = material;
        properties{rowIdx, 2} = diameter;
        properties{rowIdx, 3} = str2double(erase(sampleLength, 'mm'));
        properties{rowIdx, 4} = sprintf('%.2f ± %.2f', meanStiffness, stiffnessStd);
        properties{rowIdx, 5} = sprintf('%.2f ± %.2f', avgBreakingLoad, breakingLoadStd);
        properties{rowIdx, 6} = sprintf('%.2f ± %.2f',meanModulus, stdModulus);
        rowIdx = rowIdx + 1;
    end
end
if strcmpi(doSave, 'y')
    fileName = fullfile()
writecell(properties, '8_5Updated')
end
end