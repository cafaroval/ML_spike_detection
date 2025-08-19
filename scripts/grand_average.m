%% Grand average for AND marking
peak_channel = 'F3';
% fs = 200;
peak_align_idx = ceil(size(AndSpike_eeg_clear{1}, 2) / 2);
chanIdx = find(strcmp(eeg_labels, peak_channel));
aligned_spikes_and = [];
valid_idx = 0;

for i = 1:length(AndSpike_eeg_clean)
    trial = AndSpike_eeg_clean{i};

    [~, peakIdx] = min(trial(chanIdx, :));
    shift = peak_align_idx - peakIdx;
    aligned = circshift(trial, [0, shift]);

    valid_idx = valid_idx + 1;
    aligned_spikes_and(:, :, valid_idx) = aligned;
end

grandAvgSpike_and = mean(aligned_spikes_and, 3);
timeVec = ((1:size(grandAvgSpike_and, 2)) - peak_align_idx) * (1000/fs);

% Plot butterfly
figure('Color','w','Position',[100 100 1000 600]);
plot(timeVec, grandAvgSpike_and', 'Color', [0 0 1 0.4], 'LineWidth', 1.5);
hold on;
xline(0, 'k', 'LineWidth', 1.5); % Peak
xline(-20, '--k', 'LineWidth', 1);
xline(-5, '--k', 'LineWidth', 1);
yl = ylim();
text(-20 + 2, yl(2) * 0.9, '-20 ms', 'FontSize', 15, 'Color', 'k');
text(-5 + 2, yl(2) * 0.8, '-5 ms', 'FontSize', 15, 'Color', 'k');

xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title('EEG Butterfly Plot (Grand-Averaged Aligned Spikes) AND-marking');
grid on;

% Scale bars
line([300 300], [-10 -0], 'Color', 'k', 'LineWidth', 2);
text(305, -5, '10 µV', 'FontSize', 10);
line([200 300], [-10 -10], 'Color', 'k', 'LineWidth', 2);
text(250, -12, '100 ms', 'HorizontalAlignment', 'center', 'FontSize', 10);

%% Grand average for OR marking
peak_channel = 'F3';
peak_align_idx = ceil(size(OrSpike_eeg_clean{1}, 2) / 2);
chanIdx = find(strcmp(eeg_labels, peak_channel));
aligned_spikes_or = [];

valid_idx = 0;  % Counter for valid trials

for i = 1:length(OrSpike_eeg_clean)
    trial = OrSpike_eeg_clean{i};

    % Align to negative peak
    [~, peakIdx] = min(trial(chanIdx, :));
    shift = peak_align_idx - peakIdx;
    aligned = circshift(trial, [0, shift]);

    % Store aligned trial
    valid_idx = valid_idx + 1;
    aligned_spikes_or(:, :, valid_idx) = aligned;
end

% Grand average
grandAvgSpike_or = mean(aligned_spikes_or, 3);
timeVec = ((1:size(grandAvgSpike_or, 2)) - peak_align_idx) * (1000/fs);  % in ms

% Plot butterfly
figure('Color','w','Position',[100 100 1000 600]);
plot(timeVec, grandAvgSpike_or', 'Color', [0 0 1 0.4], 'LineWidth', 1.5);
hold on;
xline(0, 'k', 'LineWidth', 1.5); % Peak
xline(-20, '--k', 'LineWidth', 1);
xline(-5, '--k', 'LineWidth', 1);
yl = ylim();
text(-20 + 2, yl(2) * 0.9, '-20 ms', 'FontSize', 15, 'Color', 'k');
text(-5 + 2, yl(2) * 0.8, '-5 ms', 'FontSize', 15, 'Color', 'k');
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title('EEG Butterfly Plot (Grand-Averaged Aligned Spikes, OR-marking)');
grid on;

% Scale bars
line([300 300], [-10 -0], 'Color', 'k', 'LineWidth', 2);
text(305, -5, '10 µV', 'FontSize', 10);
line([200 300], [-10 -10], 'Color', 'k', 'LineWidth', 2);
text(250, -12, '100 ms', 'HorizontalAlignment', 'center', 'FontSize', 10);
