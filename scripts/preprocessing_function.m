function cleaned = preprocess_epochs(epochs, fs, channels_to_keep, eeg_labels)
    cleaned = cell(size(epochs));
    
    cfg = [];
    cfg.bpfilter = 'yes';
    cfg.bpfreq = [0.5 40];
    cfg.dftfilter = 'yes';
    cfg.dftfreq = [50];
    cfg.continuous = 'no';

    for x = 1:length(epochs)
        raw = epochs{x};

        % Skip empty or invalid epochs
        if isempty(raw) || size(raw, 1) < max(channels_to_keep)
            warning('Skipping epoch %d: empty or not enough channels.', x);
            continue;
        end

        % Select desired channels
        filtered_epoch = raw(channels_to_keep, :);

        % Create FieldTrip data structure
        data_ft = [];
        data_ft.label = eeg_labels;
        data_ft.trial = {filtered_epoch};
        data_ft.time = {(0:size(filtered_epoch, 2)-1)/fs};
        data_ft.fsample = fs;

        % Run preprocessing
        try
            data_clean = ft_preprocessing(cfg, data_ft);
            cleaned{x} = data_clean.trial{1};
        catch ME
            warning('Failed to preprocess epoch %d: %s', x, ME.message);
            continue;
        end
    end
end
