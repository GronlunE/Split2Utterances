% Specify the folder paths for the 8 languages
languages = ["Dutch", "English", "French", "German", "Italian", "Spanish", "Portuguese", "Polish"];
folderPaths = cell(length(languages), 1);

for langIndex = 1:length(languages)
    language = languages(langIndex);
    folderPaths{langIndex} = sprintf('G:\\Research\\utterances\\%s\\*.wav', language);
end

% Initialize the cell array to store all durations
allDurations = cell(length(languages), 1);

% Create a waitbar
progressBar = waitbar(0, 'Processing Languages');

% Iterate through each language
for langIndex = 1:length(languages)
    language = languages(langIndex);
    folderPath = folderPaths{langIndex};

    % Get a list of audio file names in the folder
    fileList = dir(folderPath);
    numFiles = length(fileList);

    % Initialize the array to store the durations of current language
    durations = zeros(numFiles, 1);

    % Iterate through each audio file
    for fileIdx = 1:numFiles
        % Read the audio file
        audioPath = fullfile(fileList(fileIdx).folder, fileList(fileIdx).name);
        [y, fs] = audioread(audioPath);

        % Calculate the duration of the audio file
        duration = numel(y) / fs;

        % Store the duration in the array
        durations(fileIdx) = duration;

        % Update the waitbar
        waitbar((fileIdx-1) / numFiles, progressBar, sprintf("Language: %s, File: %d/%d", language, fileIdx, numFiles));
    end

    % Store the durations of current language in the allDurations cell array
    allDurations{langIndex} = durations;
end

% Close the waitbar
close(progressBar);
%% 

% Combine the durations of all languages into a single array
combinedDurations = vertcat(allDurations{:});

% Create a combined histogram of the audio file durations with different colors for each language
figure;
hold on;

% Customize the colors for each language
colorMap = jet(length(languages));
for langIndex = 1:length(languages)
    h = histogram(allDurations{langIndex}, 'BinWidth', 1, 'FaceColor', colorMap(langIndex, :));
end

hold off;

xlabel('Duration (seconds)');
ylabel('Frequency');
title('Combined Histogram of Audio File Durations');

% Create a color legend for the languages
legend(languages, 'Interpreter', 'none');
%% 
% Get the counts and edges from the histogram
hcounts = h.Values;
hedges = h.BinEdges;

% Calculate cumulative histogram
cumulativeCounts = cumsum(hcounts);

% Find the halfway point
halfway = sum(hcounts) / 2;

% Find the bin where the cumulative counts reach halfway
halfwayBin = find(cumulativeCounts >= halfway, 1);

% Calculate the halfway value
halfwayValue = hedges(halfwayBin);

% Display the halfway bin and value
fprintf('Halfway Bin: %d\n', halfwayBin);
fprintf('Halfway Value: %.2f\n', halfwayValue);

% Plot the histogram and mark the halfway point
hold on;
line([halfwayValue halfwayValue], [0 max(hcounts)], 'Color', 'r', 'LineWidth', 2);
hold off;

xlabel('Bins');
ylabel('Counts');
title('Histogram with Halfway Point');