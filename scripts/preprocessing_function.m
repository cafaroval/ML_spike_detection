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
        
        filtered_epoch = raw(channels_to_keep, :);

        data_ft = [];
        data_ft.label = eeg_labels;
        data_ft.trial = {filtered_epoch};
        data_ft.time = {(0:size(filtered_epoch, 2)-1)/fs};
        data_ft.fsample = fs;

        try
            data_clean = ft_preprocessing(cfg, data_ft);
            cleaned{x} = data_clean.trial{1};
        catch ME
            warning('Failed to preprocess epoch %d: %s', x, ME.message);
            continue;
        end
    end
end
