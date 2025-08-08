% LoadAllEEGData - Loads raw EEG data from multiple .mat files
% 
% Syntax:
%   eegData = LoadAllEEGData(baseDir, totalHours)
%
% Inputs:
%   baseDir     - Path to the base directory
%   totalHours  - Number of recordings to load
%
% Output:
%   eegData     - Cell array containing EEG matrices from each record


function [eegData] = LoadAllEEGData(baseDir, totalHours)
    % baseDir = '/Volumes/NEW SANDISK';
    % epileptologists = {'ep_1', 'ep_2', 'ep_3'};
    % totalHours = 22;
    eegData = cell(1, totalHours);
    sharedPath = fullfile(baseDir, 'data_marked_by_ep_1');
    addpath(sharedPath);

    for recordNum = 1:totalHours
        recordPath = fullfile(sharedPath, sprintf('record%d', recordNum), 'data_block001.mat');
        if isfile(recordPath)
            data = load(recordPath);  
        % Check and extract data
            if isfield(data, 'F')
                eegData{recordNum} = data.F; 
            end
        end
    end
    % disp(eegData); %raw EEG data
end
