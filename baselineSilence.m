function [thr] = baselineSilence(y, thresholdFactor)

% Calculate the energy of the audio sample
energy = y.^2;

% Calculate the mean and standard deviation of the energy
meanEnergy = mean(energy);
stdEnergy = std(energy);

thr = meanEnergy + thresholdFactor * stdEnergy;
end