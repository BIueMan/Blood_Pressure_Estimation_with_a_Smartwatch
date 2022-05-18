function [ features ] = FrequencyDomainFeaturesFromWindow( window, samplingRate )
%FREQUENCYDOMAINFEATURESFROMWINDOW returns a frequency domain features
%struct for the window

    %% Init Params
    window = window - mean(window);
    fWindow = fft(window);
    fs = samplingRate;
    N = length(fWindow);
    fWindow = abs(fWindow(1:ceil(end/2))); % take only first half
    xf = ((1:length(fWindow)) - 1) ./ N .* fs; % the frequencies
    
    %% Find the peaks in the frequency domain
    [pks, locs, w, ~] = findpeaks(fWindow);
    [~, I] = sort(pks, 'descend');
    
    %% Extract Features
    features.dominantFrequency = xf(locs(I(1)));
    features.secondDominantFrequency = xf(locs(I(2)));
    features.spectralCentroid = sum(xf .* (1:length(xf))) / sum(xf);
    features.widthOfDominantPeak = w(I(1));
    
    features.periodOfFrequency = ...
        1 ./ SignalAnalyzer.FindDominantFrequency(fWindow, samplingRate);
    
    features.bandwidth = SignalAnalyzer.FindBandwidth(fWindow, xf);

end

