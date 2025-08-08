% LoadAllSpikeTimes2 - Loads spike times from EEG data marked by epileptologists
%
% Syntax:
%   spikeTimesAll = LoadAllSpikeTimes2(baseDir, epileptologists, totalHours)
%
% Inputs:
%   baseDir          - Base directory containing the data folders
%   epileptologists  - Cell array of epileptologist identifiers (e.g., {'ep_1', 'ep_2'})
%   totalHours       - Number of recordings per epileptologist
%
% Output:
%   spikeTimesAll    - Struct with fields per epileptologist, each containing
%                      a cell array of spike times (one cell per hour)



function [spikeTimesAll] = LoadAllSpikeTimes2(baseDir, epileptologists, totalHours)
    % baseDir = '/Volumes/NEW SANDISK';
    % epileptologists = {'ep_1', 'ep_2', 'ep_3'};
    % totalHours = 22;
    spikeTimesAll = struct();

    for i = 1:length(epileptologists)
        ep = epileptologists{i};
        spikeTimesAll.(ep) = cell(1, totalHours);

        epPath = fullfile(baseDir, sprintf('data_marked_by_%s', ep));
        addpath(epPath); 

        for recordNum = 1:totalHours
            recordFolder = sprintf('record%d', recordNum);
            recordPath = fullfile(epPath, recordFolder, 'data_block001.mat');

            if isfile(recordPath)
                data = load(recordPath); 
                 if isfield(data, 'F') && isfield(data, 'Events')
                    allTimes = [];

                    for j = 1:length(data.Events)
                        if isfield(data.Events(j), 'times') && ~isempty(data.Events(j).times)
                            allTimes = [allTimes; data.Events(j).times(:)];
                        end
                    end

                    spikeTimesAll.(ep){recordNum} = sort(allTimes)'
                end
            end
        end
    end
end

