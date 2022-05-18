function [ pks, locs, width, prominence ] = GetDominantPeaks( ppg_cycle, varargin)
%GetTwoPeaks returns the dominant peaks
%   parametes:
%       n - max number Of Peaks to return (2 by default), can be Inf
%       threshold - threshold for findpeaks (0 by default)
%       sortBy - parameter to sort by ('width' by default):
%           'width', 'prominence', 'hight'
    
    %% Parse inputs
    [numberOfPeaks, threshold, sortBy] = parse_inputs(varargin{:});
    
    %% Find dominant peaks
    [hight, locs, width, prominence] = findpeaks(ppg_cycle, 'Threshold', threshold);
    numberOfPeaks = min(numberOfPeaks, length(hight));
    
    [~, imaxes] = sort(eval(sortBy), 'descend');
    imaxes = imaxes(1:numberOfPeaks);
    
    %% Outputs
    pks = hight(imaxes);
    locs = locs(imaxes);
    width = width(imaxes);
    prominence = prominence(imaxes);
end

function [numberOfPeaks, threshold, sortBy] = parse_inputs(varargin)
    p = inputParser;
    addParameter(p, 'n', 2);
    addParameter(p, 'threshold', 0);
    addParameter(p, 'sortBy', 'width');
    %addParameter(p, 'sortDirection', 'descend');
    
    parse(p, varargin{:});
    
    numberOfPeaks = p.Results.n;
    threshold = p.Results.threshold;
    sortBy = p.Results.sortBy;
end
