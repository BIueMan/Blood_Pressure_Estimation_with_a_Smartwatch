function [ f, t, p, pt, pb, cutoffFreq, overlapPercentage ] = CreateStft( signal, sr, windowSizeInSec, overlapPercentage, cutoffFreq, plotAll )
%CREATESTFT Summary of this function goes here
%   Detailed explanation goes here

    if nargin < 4
        overlapPercentage = [];
    end
    
    if nargin < 5 || length(cutoffFreq) ~= 2
        cutoffFreq = [-inf inf];
    end
    
    if nargin < 6
        plotAll = nargout == 0;
    end
    
    if ~isempty(overlapPercentage) && overlapPercentage > 1
        overlapPercentage = overlapPercentage / 100;
    end
    
    %% init params    
    powerThreshold = 0.7;
    
    %% spectrogram
    windowSize = floor(windowSizeInSec*sr);
    noverlap = floor(overlapPercentage * windowSize);
    [s, f, t, p] = spectrogram(signal, windowSize, noverlap, [], sr, 'yaxis');
    
    %% remove frequencies (BPF)
    range = cutoffFreq(1) <= f & f <= cutoffFreq(2);
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

