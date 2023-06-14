function [utterances] = splitter(y, fs, threshold)

% Calculate the energy of the audio sample
energy = y.^2;

% Initialize variables
utterances = {}; % Cell array to store the subsamples
startIndex = 1; % Start index of the iteration
currentIndex = 1;

% Find the first point where audio goes over the threshold
while energy(currentIndex) < threshold
    currentIndex = currentIndex + 1;
end

% Iterate through the energy values
while currentIndex <= length(energy)
    % Find the first point where audio goes under the threshold
    while energy(currentIndex) >= threshold
        currentIndex = currentIndex + 1;
        if currentIndex > length(energy)
            break;
        end
    end
    % Check if we have reached the end of the energy values
    if currentIndex > length(energy)
        % Save the ongoing sample from the starting point to the end
        subsample = y(startIndex:end);
        
        % Add the subsample to the cell array
        utterances{end+1} = subsample;
        
        break; % Exit the loop
    end
    
    % Find the first point where audio goes back over the threshold
    silenceStartIndex = currentIndex;
    endPoint = currentIndex;
    while energy(endPoint) < threshold
        endPoint = endPoint + 1;
        if endPoint > length(energy)
            break;
        end
    end
    
    % Check if the duration of the silence is longer than 0.5 seconds
    if (endPoint - silenceStartIndex) / fs > 0.5
        % Calculate the midpoint of the silence
        midpoint = silenceStartIndex + floor((endPoint - silenceStartIndex) / 2);
        
        % Extract the subsample from the start to the midpoint of the silence
        subsample = y(startIndex:midpoint);
        
        % Add the subsample to the cell array
        utterances{end+1} = subsample;
        
        % Update the start index to the endpoint of the silence
        startIndex = midpoint;

        % Update the start index to continue iterating
        currentIndex = endPoint;
    else
        % Update the start index to continue iterating
        currentIndex = endPoint;
    end
end