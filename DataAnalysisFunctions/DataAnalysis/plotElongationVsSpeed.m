%% Plot a Specific Cycle Number vs Various Speeds
%{
This function plots the average the elongation of a specified material at a
specified cycle. Additionally you can input if you'd like to plot the
average (w/ errorbars) or plot each trial individually.
Inputs have the form:
-trialGroups: cell array of trialIdx vectors, e.g., {1:3, 4:6, 7:9}
-speeds: vector of speeds like [0.1, 0.5, 1.0]
-averaged = 'y' or 'n'
%}
function plotElongationVsSpeed(material, typeOfTest, trialGroups, speeds, cycleNumber, averaged)
colour = materialColour(material);
markers = {'s','*','d'};
hold on
if strcmpi(averaged, 'y')
    numSpeeds = length(speeds);
    avgElongationAtCycle = zeros(1, numSpeeds);
    stdElongationAtCycle = zeros(1, numSpeeds);

    for i = 1:numSpeeds
        trials = trialGroups{i};
        [avgStiffness, stdStiffness] = averageElongationPerCycle(material, typeOfTest, trials, 'n');
        avgElongationAtCycle(i) = avgStiffness(cycleNumber);
        stdElongationAtCycle(i) = stdStiffness(cycleNumber);
    end

    % Plotting
    errorbar(speeds, avgElongationAtCycle, stdElongationAtCycle, '-o', ...
        'LineWidth', 2, ...
        'MarkerFaceColor', materialColour(material), ...
        'Color', materialColour(material))

    xlabel('Speed $$\left(\frac{mm}{s}\right)$$')
    ylabel(strcat(sprintf('Unloaded Elongation at Cycle %d', cycleNumber), '$$\left(\frac{N}{mm}\right)$$'))
    grid on
elseif strcmpi(averaged,'n')
    for i = 1:length(speeds)
        trials = trialGroups{i};
        [trialElongations, ~] = hysteresisElongation(material, trials, [], typeOfTest, 'n');
        for j = 1:length(trialElongations)
            trialNumber = trials(j);
            elongations = trialElongations{j};
            scatter(speeds(i), elongations(cycleNumber), 60, ...
                Marker=markers{j},...
                MarkerEdgeColor= colour,...
                MarkerFaceColor = colour, ...
                DisplayName= sprintf('Trial %d', trialNumber))
        end
        xlabel('Speed $$\left(\frac{mm}{s}\right)$$')
        ylabel(strcat(sprintf('Unloaded Elongation at Cycle %d', cycleNumber), '$$\left(\frac{N}{mm}\right)$$'))
        grid on
        legend(Location='northeast')
    end
end
end
