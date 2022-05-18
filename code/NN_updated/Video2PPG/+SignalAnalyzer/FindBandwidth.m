function [ bandwidth ] = FindBandwidth( frequencyDomain, frequencies )
%FINDBANDWIDTH Summary of this function goes here
%   Detailed explanation goes here

    [pks, locs] = findpeaks(frequencyDomain);
    
    [~, I] = sort(pks, 'descend');
    
    p = min(4, length(I));
    
    X = frequencies(locs(I(1:p)));
    Y = pks(I(1:p));
    fitModel = fit(X(:), Y(:), 'exp1');
    
    y0 = fitModel(0);
        
    bandwidth = log((y0./2) ./ fitModel.a) ./ fitModel.b;

end

