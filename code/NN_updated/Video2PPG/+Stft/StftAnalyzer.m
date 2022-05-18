function [ f, t, p, pt, pb, s ] = StftAnalyzer( signal, sr, cycleLocs, windowSizeInCycles, overlapPercentage, plotAll )
%STFTPLOTTER Summary of this function goes here
%   Detailed explanation goes here

    %% plotAll init
    if nargin < 5
        overlapPercentage = [];
    end
    if nargin < 6
        plotAll = nargout == 0;
    end
    
    if ~isempty(overlapPercentage) && overlapPercentage > 1
        overlapPercentage = overlapPercentage / 100;
    end
    
    %% init params
    numOfCycles = length(cycleLocs) - 1;
    segmentSize = floor(length(signal) / numOfCycles);
    
    lowFrq = 0.5;
    highFrq = 5;
    
    powerThreshold = 0.7;
    
    %% spectrogram
    windowSize = floor(segmentSize*windowSizeInCycles);
    noverlap = floor(overlapPercentage * windowSize);
    [s, f, t, p] = spectrogram(signal, floor(segmentSize*windowSizeInCycles), noverlap, [], sr, 'yaxis') ;
    
    %% remove frequencies (BPF)
    range = lowFrq <= f & f <= highFrq;
    s = s(range, :);
    f = f(range);
    p = p(range, :);
    
    %% normalize p
    p = 20*log10(p + eps);
    
    p = p - min(p(:));
    p = p./sum(p(:));
    
    plotSpectrogram(f, t, p);

    %% apply threshold
    pMax = max(p(:));
    pMin = min(p(:));
    pt = p;
    pt(pt < (pMin + powerThreshold*(pMax - pMin))) = 0;
    
    plotSpectrogram(f, t, pt);
    
    %% bineray image
    pb = pt > 0;
    
    plotSpectrogram(f, t, pb);
    
    function plotSpectrogram(ff, tt, pp)
        if plotAll
            figure;
            imagesc(tt, ff, pp);
            xlabel('Time [sec]');
            ylabel('Frequency [Hz]');
        end
    end
end