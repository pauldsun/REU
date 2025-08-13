%% Calculate Stiffness of Each Cycle of One Hysteresis Trial/Run
%{
This function calculates the stiffness of each cycle of one trial/run of
hysteresis. You input the desired trial or run number (not both), and [] 
for the one you are not looking at.
Inputs:
-material: 'MaterialName'
-typeOfTest: 'Force' or 'Position'
-trialNumber: n (where n is an integer)
OR
runNumber: n (where n is an integer
-doPlot: 'y' or 'n'
-averageFirstCycle: 'y' or 'n'
%}
function [stiffness] = calculateLoadingStiffness(material, typeOfTest, trialNumber, runNumber, doPlot, averageFirstCycle)
switch typeOfTest
    case 'Force'
        baseFolder = '/Users/paulsundstrom/REU/HysteresisData/ForceControl';
    case 'Position'
        baseFolder = '/Users/paulsundstrom/REU/HysteresisData/PositionControl';
end
if ~isempty(trialNumber)
    folderPath = fullfile(baseFolder, sprintf('%s/Trial%d', material, trialNumber));
else
    folderPath = fullfile(baseFolder, sprintf('%s/UsedSample/Run%d', material, runNumber));
end
filePath = fullfile(folderPath, 'DAQ- Crosshead, … - (Timed).csv');
data = readtable(filePath);
data.Load = data.Load * 1000;
peakProm = 50;
minCyclesRequired = 15;

%decrease prominence until enough peaks are found
while true
    [peaks, peakidx] = findpeaks(data.Load, "MinPeakProminence", peakProm);
    [troughs, troughidx] = findpeaks(-data.Load, "MinPeakProminence", peakProm);
    if length(peaks) >= minCyclesRequired
        break
    end
    peakProm = peakProm * 0.8;  % reduce prominence
    if peakProm < 1
        warning('Peak prominence reduced below threshold. Only %d cycles found.', length(peaks));
        break
    end
end

% if strcmpi(material, 'Spectra')
%     [peaks, peakidx] = findpeaks(data.Load, "MinPeakProminence", 10);
%     [troughs, troughidx] = findpeaks(-data.Load, "MinPeakProminence", 10);
% else
%     [peaks, peakidx] = findpeaks(data.Load, "MinPeakProminence", 50);
%     [troughs, troughidx] = findpeaks(-data.Load, "MinPeakProminence", 50);
% end
troughs = -troughs;
peakLocations = data.Crosshead(peakidx);
numCycles = length(peaks);

troughs = [data.Load(1); troughs; data.Load(end)]; %add the first and last data points as troughs
allTroughidx = [1; troughidx; length(data.Crosshead)];
troughLocations = [data.Crosshead(1); data.Crosshead(troughidx); data.Crosshead(end)];

% if strcmp(doPlot,'y')
%     plot(data.Crosshead, data.Load)
%     hold on
%     plot(peakLocations, peaks, 'r*')
%     plot(troughLocations, troughs, 'k*')
%     xlabel('Displacement (mm)')
%     ylabel('Force (N)')
%     legend(sprintf('Run%d',runNumber), 'Peaks', 'Troughs', Location='northwest')
%     grid on
% end

numTrials = 5;
stiffness = zeros(1,numTrials);
for i = 1:(length(allTroughidx) - 1)
    loadingIdxRange = allTroughidx(i):peakidx(i);
    unloadingIdxRange = peakidx(i):allTroughidx(i+1);
    xfit = data.Crosshead(loadingIdxRange);
    yfit = data.Load(loadingIdxRange);
    linearfit = polyfit(xfit, yfit, 1);
    y = polyval(linearfit, data.Crosshead(allTroughidx(i):allTroughidx(i+1)));
    %legend(sprintf('Cycle %d', i), 'Loading Stiffness')
    stiffness(i) = linearfit(1);

    f = fit(data.Crosshead(unloadingIdxRange), data.Load(unloadingIdxRange), 'exp2');
    y_exp = f(data.Crosshead(unloadingIdxRange));
    %plot(data.Crosshead(unloadingIdxRange), y_exp, 'k-')
    if strcmp(doPlot, 'y')
        figure()
        grid on
        hold on
        plot(data.Crosshead(allTroughidx(i):allTroughidx(i+1)), data.Load(allTroughidx(i):allTroughidx(i+1)))
        plot(data.Crosshead(allTroughidx(i):allTroughidx(i+1)), y, 'r--')
        xlabel("Displacement (mm)")
        ylabel("Force (N)")
        legend(sprintf('Cycle %d', i), 'Loading Stiffness Fit', Location='northwest')
    end
end
if strcmpi(averageFirstCycle, 'y')
    stiffness(1) = (data.Load(peakidx(1)) - data.Load(allTroughidx(1))) / ...
        (data.Crosshead(peakidx(1))-data.Crosshead(allTroughidx(1)));
end

end