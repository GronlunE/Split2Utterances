% Specify the folder containing the audio files
languages = ["Dutch", "English", "French", "German", "Italian", "Spanish", "Portuguese", "Polish"];
for langIndex = 1:length(languages)
    language = languages(langIndex);
    folderPath = sprintf('H:\\New_Language_data\\%s\\Chosen\\**\\*.opus', language);
    

    % Get a list of audio file names in the folder
    fileList = dir(folderPath);
    numFiles = length(fileList);
    
    % Initialize the cell array to store all subsamples
    allSubsamples = {};

    % Set the threshold as a multiple of the standard deviation
    thresholdFactor = 0.5; % Adjust this value as needed

    % Create the progress bar for file iteration
    fileProgressBar = waitbar(0, 'Splitting audio files...', 'Name', 'Splitting process');
    
    % Iterate through each audio file
    for fileIdx = 1:numFiles
    
        % Read the audio file
        audioPath = fullfile(fileList(fileIdx).folder, fileList(fileIdx).name);
        [y, fs] = audioread(audioPath);

        threshold = baselineSilence(y, thresholdFactor);
    
        utterances = splitter(y, fs, threshold);
    
        % Concatenate the subsamples of the current audio file to the allSubsamples cell array
        allSubsamples = [allSubsamples utterances];
        
        % Update the progress bar for file iteration
        fileProgress = fileIdx / numFiles;
        waitbar(fileProgress, fileProgressBar, sprintf('Processing audio files for %s... %d/%d\nTotal number of utterances : %d', language, fileIdx, numFiles, numel(allSubsamples)));
    end

    % Close the progress bar for file iteration
    close(fileProgressBar);

%%

    % Check if there are at least 10,000 subsamples available
    numSubsamples = length(allSubsamples);
    if numSubsamples < 10000
        error('Not enough subsamples available.');
    end
    
    % Generate random indices for subsample selection
    randomIndices = randperm(numSubsamples, 10000);
    
    % Select the subsamples corresponding to the random indices
    selectedSubsamples = allSubsamples(randomIndices);
    
    durHisto(selectedSubsamples,fs)
    
    savePath = sprintf('G:\\Split2Utterances\\utterances\\%s', language);
    
    % Create the progress bar for saving files
    fileProgBar = waitbar(0, sprintf('Saving files for %s...', language));
    
    % Iterate through each selected subsample and save as .wav files
    for i = 1:length(selectedSubsamples)
        % Create the filename for the current subsample
        filename = sprintf('%s_%d.wav', language, i);
        
        % Specify the full file path
        filePath = fullfile(savePath, filename);
        
        % Write the subsample as a .wav file
        audiowrite(filePath, selectedSubsamples{i}, fs);
        
        % Update the progress bar for saving files
        fileProg = i / length(selectedSubsamples);
        waitbar(fileProg, fileProgBar, sprintf('Saving files for %s...%d/%d', language, i, numel(selectedSubsamples)));
    end
    
    % Close the progress bar for saving files
    close(fileProgBar);
    % Display a message when the language is done
    fprintf('Language %s done!\n', language);

end