function [ filteredSignal ] = ButterBandpass( signal, sampleRate, order, w1, w2 )
%butterBandpass is a Butterworth filter
%   applied on signal (which has the given sampleRate)
%   w1, w2 are the cut-off frequences (one of them can be NaN in order to
%   get LPF or HPF)

    boolHelp = @(v1, v2) (isinf(v1) || isnan(v1)) && v2 <= sampleRate/2;
    if ~(boolHelp(w1, w2) || boolHelp(w2, w1) || (w1 < w2 && w2 <= sampleRate/2))
        error('invalid args');
    end
    
    signal = signal - mean(signal);
    N = length(signal);
    
    X = -floor(N/2):floor((N-1)/2);
    X = X .* (sampleRate./N);
    
    highPassFun = @(w) 1./(1 + (w./X).^(2.*order));
    
    highPass = highPassFun(w1);
    lowPass = 1 - highPassFun(w2);
    
    fSignal = fftshift(fft(signal));
    
    if boolHelp(w1,w2)
        highPass = 1;
    elseif boolHelp(w2,w1)
        lowPass = 1;
    end
    
    fBandPassedSignal = fSignal(:) .* highPass(:) .* lowPass(:);
    
    filteredSignal = ifft(ifftshift(fBandPassedSignal));
    
    filteredSignal = reshape(filteredSignal, size(signal));

end

