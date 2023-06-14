function [] = durHisto(allSubsamples, fs)
% Calculate the durations of the subsamples
durations = cellfun(@(x) numel(x) / fs, allSubsamples);

% Plot a histogram of the durations
histogram(durations);

% Set labels and title
xlabel('Duration (seconds)');
ylabel('Frequency');
title('Histogram of Subsample Durations');
end

