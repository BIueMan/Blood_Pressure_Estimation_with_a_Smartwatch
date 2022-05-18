function [ s, t, f, overlapPercentage, p ] = CreateStftAdvImg( signal, sr, windowSizeInSec, overlapPercentage, cutoffFreq, plotAll )
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
    
    %% spectrogram
    windowSize = floor(windowSizeInSec*sr);
    noverlap = floor(overlapPercentage * windowSize);
    [s, f, t, p] = spectrogram(signal, windowSize, noverlap, [], sr, 'yaxis');
    
    %% remove frequencies (BPF)
    range = cutoffFreq(1) <= f & f <= cutoffFreq(2);
    s = s(range, :);
    f = f(range);
    p = p(range, :);    
    
    %% aux funcs
    function plotSpectrogram(ff, tt, pp)
        if plotAll
            figure;
            imagesc(tt, ff, pp);
            xlabel('Time [sec]');
            ylabel('Frequency [Hz]');
        end
    end

end

