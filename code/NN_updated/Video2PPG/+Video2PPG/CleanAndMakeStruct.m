function [ ppg ] = CleanAndMakeStruct( raw_signal, samplingRate, inverse, BP_frq )
%CLEANANDMAKESTRUCT Summary of this function goes here
%   Detailed explanation goes here

    import SignalAnalyzer.*
    import PPGAnalyzer.*

    ppg = [];
    if isstruct(raw_signal)
        ppg = raw_signal;
        raw_signal = ppg.raw;
        samplingRate = ppg.samplingRate;
    end
    
    if nargin < 3 || isempty(inverse)
        if isempty(ppg)
            inverse = false;
        else
            inverse = ppg.inverse;
        end
    end
    if nargin < 4 || isempty(BP_frq)
        if isempty(ppg)
            BP_frq = [0.5 5];
        else
            BP_frq = ppg.BPF;
        end
    end

    if inverse
        raw_signal = -raw_signal;
    end
    raw_signal = raw_signal - min(raw_signal);

    %% Clean Noise (BP filter) And Find Cycles And Remove Baseline
    % using 4th order Butterworth band-pass filter having cutoff frequencies of 0.3 Hz and 12.5 Hz
    [ ppg_final, xTime, cyclesLocations, signal_after_noise_cleaning, baseline ] = ...
        DenoiseAndRemoveBaseline( raw_signal, samplingRate, BP_frq, 4 );

    %% out
    ppg.inverse = inverse;
    ppg.raw = raw_signal;
    ppg.final = ppg_final;
    ppg.xTime = xTime;
    ppg.cyclesLocations = cyclesLocations;
    ppg.afterBPF = signal_after_noise_cleaning;
    ppg.BPF = BP_frq;
    ppg.baseline = baseline;
    ppg.samplingRate = samplingRate;

end

