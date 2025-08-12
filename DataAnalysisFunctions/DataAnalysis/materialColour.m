function colour = materialColour(material)
cm = lines(6);
cmExtended = colorcube(10); %dont use 1,4, or 10
if contains(material, 'DuraBraid(5Cycles)')
    material = 'DuraBraidSD';
elseif contains(material, 'Stealth(5Cycles)')
    material = 'StealthSD';
elseif contains(material, 'Dyneema(5Cycles)')
    material = 'Dyneema';
elseif contains(material, 'SteelCableSD(5Cycles)')
    material = 'SteelCableSD';
elseif contains(material, 'SteelCableLD(5Cycles)')
    material = 'SteelCableLD';
end

switch material
    case 'DuraBraidSD'
        colour = cm(1,:);
    case 'StealthSD'
        colour = cm(2,:);
    case 'SteelCableLD'
        colour = cm(3,:);
    case 'Dyneema'
        colour = cm(4,:);
    case 'SteelCableSD'
        colour = cm(5,:);
    case 'Kevlar'
        colour = cmExtended(8,:);
    case 'DuraBraidLD'
        colour = cmExtended(2,:);
    case 'StealthLD'
        colour = cmExtended(3,:);
    case 'UltraCast'
        colour = cmExtended(5,:);
    case 'SpectraSD'
        colour = cmExtended(6,:);
    case 'SpectraLD'
        colour = cmExtended(9,:);
end
