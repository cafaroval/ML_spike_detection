% Epoching of raw EEG data
fs = 200;
epoch_length = 1;
samples_per_epoch = fs * epoch_length;
total_hour = 22;

epochedEEG = cell(1, total_hour);
for hour = 1:total_hour
    currentEEG = eegData{hour};
    [numChannels, totalSamples] = size(currentEEG);
    numEpochs = floor(totalSamples / samples_per_epoch);
    epochedData = zeros(numChannels, samples_per_epoch, numEpochs);

    for epochIdx = 1:numEpochs
        startIdx = (epochIdx - 1) * samples_per_epoch + 1;
        endIdx = startIdx + samples_per_epoch - 1;
        epochedData(:, :, epochIdx) = currentEEG(:, startIdx:endIdx);
    end
    epochedEEG{hour} = epochedData;
end
