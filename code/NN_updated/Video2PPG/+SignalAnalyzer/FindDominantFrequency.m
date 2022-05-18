function [ dominantFrq ] = FindDominantFrequency( signal, samplingRate )
%FINDDOMINANTFREQUENCY finds the dominant frequency using autocorr
    R = xcorr(signal);
    [pks, locs] = findpeaks(R);
    [~, I] = sort(pks, 'descend');
    locs = sort(locs(I(1:min(5, length(I)))));
    dominantFrq = max(samplingRate ./ diff(locs));
    
end

