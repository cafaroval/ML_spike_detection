%% MAIN SCRIPT FOR EEG SPIKE ANALYSIS 
% ---------------------------------------------------------
% This script performs:
% 1. Labeling epochs based on spike annotations
% 2. Computing AND / OR consensus labels across experts
% 3. Extracting labeled EEG epochs for ANN classification
% 
% Output variables (examples):
% - OrSpike_eeg, OrNonSpike_eeg, AndSpike_eeg, AndNonSpike_eeg
% - OrSpike, OrNonSpike, AndSpike, AndNonSpike
% 
% Requires:
% - epochedEEG: segmented EEG data 
% - spikeTimesAll: struct with spike times from experts

%% 1. Label Each Epoch Using Spike Times ==========
spikeLabels = struct();
epileptologists = fieldnames(spikeTimesAll);

for epIdx = 1:length(epileptologists)
    ep = epileptologists{epIdx};
    spikeLabels.(ep) = cell(1, total_hour);

    for hour = 1:total_hour
        numEpochs = size(epochedEEG{hour}, 3);
        labels = zeros(1, numEpochs);
        spikeTimes = spikeTimesAll.(ep){hour};

        for spike = spikeTimes
            spikeSample = round(spike * fs);
            epochIdx = ceil(spikeSample / samples_per_epoch);
            if epochIdx <= numEpochs
                labels(epochIdx) = 1;
            end
        end
        spikeLabels.(ep){hour} = labels;
    end
end

% Count Total Spikes and Non-Spikes
totalSpikeCounts = struct();
totalNoSpikeCounts = struct();
epileptologists = {'ep_1', 'ep_2', 'ep_3'};
for epIdx = 1:length(epileptologists)
    ep = epileptologists{epIdx};
    spikeCount = sum(cellfun(@(x) sum(x == 1), spikeLabels.(ep)));
    noSpikeCount = sum(cellfun(@(x) sum(x == 0), spikeLabels.(ep)));
    
    totalSpikeCounts.(ep) = spikeCount;
    totalNoSpikeCounts.(ep) = noSpikeCount;
end

% Display the results
disp('Total Spikes:'); disp(totalSpikeCounts);
disp('Total No-Spikes:'); disp(totalNoSpikeCounts);

%%  2. Compute AND and OR Labels ==========
ANDLabels = [];
ORLabels = [];
for i = 1:total_hour
    ep1 = spikeLabels.ep_1{i};
    ep2 = spikeLabels.ep_2{i};
    ep3 = spikeLabels.ep_3{i};

    ANDLabels = [ANDLabels, ep1 & ep2 & ep3];
    ORLabels = [ORLabels, ep1 | ep2 | ep3];
end

disp(['AND-marking Spikes: ', num2str(sum(ANDLabels == 1))]); % 1133
disp(['OR-marking Spikes: ', num2str(sum(ORLabels == 1))]);   % 10552

% save('ANDLabels.mat', 'ANDLabels');
% save('ORLabels.mat', 'ORLabels');

%% 3. Extract Epochs Based on Labels ==========
[OrSpike_eeg, OrNonSpike_eeg, OrSpike, OrNonSpike] = deal({});
[AndSpike_eeg, AndNonSpike_eeg, AndSpike, AndNonSpike] = deal({});

% Or marking
a = 0; b = 0;
ORLabels_per_hour = mat2cell(ORLabels, 1, cellfun(@(x) size(x,3), epochedEEG));
for hour = 1:total_hour
    numEpochs = size(epochedEEG{hour}, 3);
    labels = ORLabels_per_hour{hour};
    for i = 1:numEpochs
        if labels(i) == 1
            a = a + 1; 
            OrSpike{a} = 1;
            OrSpike_eeg{a} = epochedEEG{hour}(:, :, i);
        else
            b = b + 1; 
            OrNonSpike{b} = 0;
            OrNonSpike_eeg{b} = epochedEEG{hour}(:, :, i);
        end
    end
end

% And marking
c = 0; d = 0;
AndLabels_per_hour = mat2cell(ANDLabels, 1, cellfun(@(x) size(x,3), epochedEEG));
for hour = 1:total_hour
    numEpochs = size(epochedEEG{hour}, 3);
    labels = AndLabels_per_hour{hour};
    for i = 1:numEpochs
        if labels(i) == 1
            c = c + 1; 
            AndSpike{c} = 1;
            AndSpike_eeg{c} = epochedEEG{hour}(:, :, i);
        else
            d = d + 1; 
            AndNonSpike{d} = 0;
            AndNonSpike_eeg{d} = epochedEEG{hour}(:, :, i);
        end
    end
end
