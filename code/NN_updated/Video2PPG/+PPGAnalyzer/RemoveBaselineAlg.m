function [ outPPG, baseline, lowPeaksLocs, outX ] = ...
    RemoveBaselineAlg( inPPG, clipEdges, draw, samplingRate)
%RemoveBaselineAlg removes baseline drift
%   inPPG       - the input signal
%   clipEdges   - if true then cuts off the edges that weren't detected by
%                   the cycles detector
%                   false by default
%   draw        - if true then plots the signal with the vertical lines at
%                   the peaks
%                   by default if there are no output args, then true
    
    %inPPG = inPPG-mean(inPPG);
    if nargin < 4
        samplingRate = 1;
    end
    if nargin < 3
        draw = (nargout == 0);
    end
    if nargin < 2
        clipEdges = false;
    end

    lowPeaksLocs = PPGAnalyzer.cycle_detect(inPPG);
    
    [outPPG, baseline] = removeBaseline(inPPG, lowPeaksLocs);
    
    if clipEdges
        xRunner = lowPeaksLocs(1):lowPeaksLocs(end);
        outPPG = outPPG(xRunner);
        baseline = baseline(xRunner);
        lowPeaksLocs = lowPeaksLocs - lowPeaksLocs(1);
    end
    
    outX = (1:length(outPPG)) ./ samplingRate;

    if draw
        Printers.DrawVerLinesOnGraph(lowPeaksLocs, outPPG, samplingRate);
    end

end

function [ outSignal, baseline ] = removeBaseline( signal, baselineIndexes )
%removeBaseline removes the baseline defined by baselineIndexes

    baseline = zeros(size(signal));
    
    for i=1:length(baselineIndexes)-1
        X = baselineIndexes(i):baselineIndexes(i+1);
        X = double(X);
        
        M = (signal(X(end)) - signal(X(1))) ./ (X(end) - X(1));
        
        baseline(X) = (X - X(1)).*M + signal(X(1));
    end
    
    baseline(1:baselineIndexes(1)) = baseline(baselineIndexes(1));
    baseline(baselineIndexes(end):end) = baseline(baselineIndexes(end));
    
    outSignal = signal - baseline;

end



