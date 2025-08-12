function plotMaterialColourReference()
materials = {'DuraBraid', 'Stealth', 'Dyneema', 'Spectra', 'Kevlar', ...
    'SteelCableSD', 'SteelCableLD'};

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
end

xlim([0, numMaterials + 1])
ylim([0.8, 2.2])

end
