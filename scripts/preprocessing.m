%% Preprocess Spike and Non-Spike Epochs 
channels_to_remove = [18, 21:31];
channels_to_keep = setdiff(1:31, channels_to_remove);
eeg_labels = {'Fp1', 'Fp2', 'F3', 'F4', 'C3', 'C4', 'P3', 'P4', 'O1', 'O2', ...
              'F7', 'F8', 'T3', 'T4', 'T5', 'T6', 'Fz', 'Cz', 'Pz'};
epochs = AndSpike_eeg; 
AndSpike_eeg_clean = preprocess_epochs(AndSpike_eeg, fs, channels_to_keep, eeg_labels);

epochs = AndNonSpike_eeg; 
AndNonSpike_eeg_clean = preprocess_epochs(AndNonSpike_eeg, fs, channels_to_keep, eeg_labels);

epochs = OrSpike_eeg; 
OrSpike_eeg_clean = preprocess_epochs(OrSpike_eeg, fs, channels_to_keep, eeg_labels);

epochs = OrNonSpike_eeg; 
OrNonSpike_eeg_clean = preprocess_epochs(OrNonSpike_eeg, fs, channels_to_keep, eeg_labels);
