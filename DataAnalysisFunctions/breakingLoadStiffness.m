%% Stiffness and Young's Modulus Calculation for Breaking Load Data
%{
This function looks as all trials of a specified material and sample length
and calculates the stiffness of the elastic region. It then averages this
stiffness over all trials and also computes the average Young's Modulus.
Inputs:
-material: 'MaterialName'
-sampleLength: '100mm' or '200mm'
-trailIdx: n, n:m, or 'all' (where n & m are integers)
-doPlot: 'y' or 'n'
Outputs:
-meanStiffness: avg. stiffness across trialIdx
-stiffnessStd: std of meanStiffness
-meanModulus: avg. modulus of elasticity across trialIdx
-stdModulus: std of meanModulus
-diameter: the diameter of the inputted material
%}

function [meanStiffness, stiffnessStd, meanModulus, stdModulus, diameter] = breakingLoadStiffness(material, sampleLength, trialIdx, doPlot)
baseFolder = '/Users/paulsundstrom/REU/BreakingLoadData';
materialFolder = fullfile(baseFolder, material);
lengthFolder = fullfile(materialFolder, sampleLength);
trialDir = dir(fullfile(lengthFolder, 'Trial*'));
numAvailableTrials = numel(trialDir);
colour = materialColour(material);

if ischar(trialIdx) || isstring(trialIdx)
    if strcmpi(trialIdx, 'all')
        trialNames = {trialDir.name};
        trialIdx = []; % will become numeric array of trial numbers
        for k = 1:length(trialNames)
            tokens = regexp(trialNames{k}, 'Trial(\d+)', 'tokens');
            if ~isempty(tokens)
                trialNum = str2double(tokens{1});
                if trialNum >= 1
                    trialIdx(end+1) = trialNum;
                end
            end
        end
        trialIdx = sort(trialIdx);
    else
        error('Invalid trialIdx input string')
    end
elseif isnumeric(trialIdx)
else
    error('trialIdx must be numeric or "all"')
end



switch material
    case 'DuraBraidSD'
        diameter = 0.36;
        A = 0.25 * pi * diameter^2;
    case 'StealthSD'
        diameter = 0.33;
        A = 0.25 * pi * diameter^2;
    case  'Dyneema'
        diameter = 0.23;
        A = 0.25 * pi * diameter^2;
    case 'SteelCableSD'
        diameter = 0.6096;
        A = 0.25 * pi * diameter^2;
    case 'SteelCableLD'
        diameter = 0.9398;
        A = 0.25 * pi * diameter^2;
    case 'DuraBraidLD'
        diameter = 0.43;
        A = 0.25 * pi * diameter^2;
    case 'StealthLD'
        diameter = 0.5;
        A = 0.25 * pi * diameter^2;
    case 'UltraCast'
        diameter = 0.39;
        A = 0.25 * pi * diameter^2;
    case 'SpectraSD'
        diameter = 0.24; %%Check Diameter
        A = 0.25 * pi * diameter^2;
    case 'Kevlar'
        diameter = 0.878;
        A = 0.25 * pi * diameter^2;
    case 'SpectraLD'
        diameter = 0.76;
        A = 0.25 * pi * diameter^2;
end

L = str2double(erase(sampleLength,'mm'));
numTrials = length(trialIdx);
stiffness = zeros(1, numTrials);
stiffnessStd = zeros(1, numTrials);
youngsModulus = zeros(1, numTrials);

for i = 1:numTrials
    trialNumber = trialIdx(i);
    lengthFolder = fullfile(materialFolder, sampleLength);
    folderPath = fullfile(lengthFolder, sprintf('Trial%d', trialNumber));
    filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
    if ~isfile(filePath)
        warning("Missing file: %s", filePath);
        continue;
    end
    data = readtable(filePath);
    data.Load = data.Load * 1000;
    windowSize = 200;
    maxR2 = -Inf;
    bestFit = [];

    for j = 1:(length(data.Crosshead) - windowSize)
        xWindow = data.Crosshead(j:j+windowSize);
        yWindow = data.Load(j:j+windowSize);
        p = polyfit(xWindow, yWindow, 1);
        yFit = polyval(p, xWindow);
        SSRes = sum((yWindow - yFit).^2);
        SSTot = sum((yWindow - mean(yWindow)).^2);
        R2 = 1 - SSRes / SSTot;

        if R2 > maxR2
            maxR2 = R2;
            bestFit = struct('slope', p(1), 'xRange', xWindow, 'yRange', yWindow, 'poly', p);
        end
    end

    stiffness(i) = bestFit.slope;
    youngsModulus(i) = (bestFit.slope * L)/A;


    if strcmpi(doPlot, 'y')
        figure()
        plot(data.Crosshead, data.Load, color = colour)
        hold on
        grid on
        fitX = linspace(min(bestFit.xRange), max(bestFit.xRange), 1000);
        fitY = polyval(bestFit.poly, fitX);
        plot(fitX, fitY, 'r--')
        plot([bestFit.xRange(1), bestFit.xRange(end)], [bestFit.yRange(1), bestFit.yRange(end)], 'ko')
        xlabel('Displacement (mm)')
        ylabel('Force (N)')
        legend('Original Data', sprintf('Stiffness Fit (%.2f N/mm)',bestFit.slope), 'Fit Region', Location='northwest')
    end
end
meanStiffness = mean(stiffness);
stiffnessStd = std(stiffness);
meanModulus = mean(youngsModulus)/1e3; %converted to GPa
stdModulus =  std(youngsModulus)/1e3;
end