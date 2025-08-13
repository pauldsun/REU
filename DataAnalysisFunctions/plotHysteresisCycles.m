%% Plot Specific Cycles from a Trial or Run
%{
This function allows you to plot specific loading cycles from a given
trial or run of a material. Can only look at one trial or run at a time.
Inputs:
-material: 'MaterialName'
-typeOfTest: 'Force' or 'Position'
-trialNumber: n (where n is an integer)
or 
runNumber: n
-cycleIndices: n:m (where n & m are integers)
-plotSeparate: 'true' or 'false' (does nothing right now)
%}

function [] = plotHysteresisCycles(material, typeOfTest, trialNumber, runNumber, cycleIndices, plotSeparate)
switch typeOfTest
    case 'Force'
        baseFolder = '/Users/paulsundstrom/REU/HysteresisData/ForceControl';
    case 'Position'
        baseFolder = '/Users/paulsundstrom/REU/HysteresisData/PositionControl';
end

if ~isempty(trialNumber)
    folderPath = fullfile(baseFolder, sprintf('%s/Trial%d', material, trialNumber));
    label = sprintf('Trial %d', trialNumber);
else
    folderPath = fullfile(baseFolder, sprintf('%s/UsedSample/Run%d', material, runNumber));
    label = sprintf('Run %d', runNumber);
end
warning('off', 'MATLAB:table:ModifiedAndSavedVarnames');
filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
data = readtable(filePath);
data.Load = data.Load * 1000;

[peaks, peakidx] = findpeaks(data.Load, "MinPeakProminence", 50);
[troughs, troughidx] = findpeaks(-data.Load, "MinPeakProminence", 50);
troughs = -troughs;

% Add start and end
allTroughidx = [1; troughidx; length(data.Crosshead)];

colour = materialColour(material);

if ~plotSeparate
    figure()
    hold on
    grid on
    xlabel('Displacement (mm)')
    ylabel('Force (N)')
    title(sprintf('%s - Selected Cycles', label))
end

for i = 1:length(cycleIndices)
    c = cycleIndices(i);
    if c > length(peakidx) || c > length(allTroughidx)-1
        warning('Cycle %d exceeds number of detected cycles.', c);
        continue;
    end
    
    idxRange = allTroughidx(c):allTroughidx(c+1);
    cycleDisp = data.Crosshead(idxRange);
    cycleForce = data.Load(idxRange);

    if plotSeparate
        figure()
        hold on
        grid on
        plot(cycleDisp, cycleForce, 'Color', colour)
        xlabel('Displacement (mm)')
        ylabel('Force (N)')
        title(sprintf('%s - Cycle %d', label, c))
    else
        plot(cycleDisp, cycleForce, 'DisplayName', sprintf('Cycle %d', c))
    end
end

if ~plotSeparate
    legend('show', 'Location', 'best')
end

end
