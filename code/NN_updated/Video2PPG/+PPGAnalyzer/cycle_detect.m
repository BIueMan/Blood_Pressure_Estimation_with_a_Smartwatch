function [ cycles ] = cycle_detect( signal )
% cycle_detect detects the starting locations of the cycles in the signal

    %% Init params
    signal = signal - mean(signal); % remove DC
    N = length(signal);

    %% Find dominant frequency of signal, and use it to find the period
    fSignal = fft(signal);
    [~, f0_index] = max(abs(fSignal( 1 : floor(length(fSignal)/2)+1 ))); % find dominat frequency
    
    f0 = (f0_index - 1) / N; % convert to real frequency value
    T0 = 1 / f0; % the period of the signal
    
    %% Find starting point for cycle search: Find the minimal local minimum of the signal
    [peaks , peaks_in] = findpeaks(-signal); % find min peaks
    peaks = -peaks;
    
    [~, min_peak_in] = min(peaks); % global min
    min_peak_in = peaks_in(min_peak_in); % the index of the min min peak

    %% Define search constants
    so = int32(round(T0/2)); % searchOffset - half of the period 

    % bounderies for the entire search
    boundLowIndex = so;
    boundHighIndex = length(signal)-so;

    T0 = int32(round(T0));
    
    %% Do search 
    cycles = min_peak_in;
    runningIndex = min_peak_in + T0;
    RunSearch(min_peak_in, 1);
    RunSearch(min_peak_in, -1);
    
    %% Aux function - RunSearch
    function RunSearch(startIndex, direction)
        % RunSearch - searches for all the cycles from startIndex in the
        % given direction
        runningIndex = startIndex + direction*T0;
        while runningIndex >= boundLowIndex && runningIndex <= boundHighIndex
            i = runningIndex;

            [peaks_foc, peaks_foc_in] = findpeaks(-signal(max(i-so,1):(min(i+so,length(signal)))));
            peaks_foc = -peaks_foc;
            if isempty(peaks_foc)% problem with emptypicks check!
                runningIndex = runningIndex + direction*T0;
                continue;
            end
            [~,j] = min(peaks_foc);%find min in nhiberhood
            min_peak_foc_in = peaks_foc_in(j) + i-so - 1;
            if direction == 1
                cycles = [cycles, min_peak_foc_in];
            else
                cycles = [min_peak_foc_in, cycles];
            end
            runningIndex = min_peak_foc_in + direction*T0;
        end
    end

    % for i=min_peak_in:T0:(length(ppg_signal)-so)
    %    [peaks_foc, peaks_foc_in] = findpeaks(ppg_signal((i-so):((i+so))));
    %     min_paek_foc_in = peaks_foc_in(find(peaks_foc==min(peaks_foc)));
    %     cycles = [cycles,min_paek_foc_in];
    % end
    % for i=min_peak_in:(-T0):round(T0/7)
    %    [peaks_foc, peaks_foc_in] = findpeaks(ppg_signal((i-round(T0/7)):((i+round(T0/7)))));
    %     min_paek_foc_in = peaks_foc_in(find(peaks_foc==min(peaks_foc)));
    %     cycles = [min_paek_foc_in,cycles];
    % end
    
    
end

