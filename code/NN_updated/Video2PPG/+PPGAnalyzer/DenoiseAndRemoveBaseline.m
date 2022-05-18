function [ ppg_final, xTime, cyclesLocations, signal_after_noise_cleaning, baseline ] = ...
    DenoiseAndRemoveBaseline( rawSignal, samplingRate, cutoffFrequencies, butterworthOrder )
%DENOISEANDREMOVEBASELINE denoises (with BPF) the raw signal, and removes the baseline
%   The default values correspond with article 1 values:
%       Cutoff frequencies are 0.5 Hz and 5 Hz by default
%       Butterworth's order is 4 by default

    %% Imports
    import SignalAnalyzer.*
    import PPGAnalyzer.*
    
    %% Init params
    if nargin < 4
        butterworthOrder = 4;
    end
    if nargin < 3
        cutoffFrequencies = [0.5 5];
    end
    
    %% Get x axis
    xTime = (1:length(rawSignal)) ./ samplingRate;
    
    %% Clean Noise - BP filter
    signal_after_noise_cleaning = ...
        ButterBandpass(rawSignal, samplingRate, butterworthOrder, cutoffFrequencies(1), cutoffFrequencies(2));
    
    %% Find Cycles And Remove Baseline
    [ ppg_final, baseline, cyclesLocations, ~ ] = ...
        RemoveBaselineAlg(signal_after_noise_cleaning, false, false, samplingRate);

end

