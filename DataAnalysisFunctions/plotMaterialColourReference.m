%% Plotting a Colour Reference for the Materials
%{
This function plots square colour references for each material so you can
visualize which colour goes with which material.
Input:
-materials: {'MaterialName1', 'MaterialName2', ...}
%}
function plotMaterialColourReference(materials)

numMaterials = length(materials);
hold on
axis off
axis equal

for i = 1:numMaterials
    color = materialColour(materials{i});
    x = i;  % horizontal position
    y = 1;
    width = 0.8;
    height = 1;
    rectangle('Position', [x, y, width, height], ...
              'FaceColor', color, ...
              'EdgeColor', 'k')
    text(x + width/2, y + height + 0.1, materials{i}, ...
         'HorizontalAlignment', 'center', ...
         'VerticalAlignment', 'bottom', ...
         'FontSize', 10)
end

xlim([0, numMaterials + 1])
ylim([0.8, 2.2])

end
