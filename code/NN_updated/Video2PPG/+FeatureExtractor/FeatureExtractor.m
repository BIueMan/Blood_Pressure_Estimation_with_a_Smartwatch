function [ featuresPerCycle, vectors, featureNames ] = ...
    FeatureExtractor( signal, cycleIndexes, windowSize, samplingRate, cycles2Average )
%FeatureExtractor extracts a features struct for each cycle
%   windowSize is given in seconds
%   cycles2Average - every 'cycles2Average' cycles, we will average the
%                    features
    
    %% init params
    if nargin < 5
        cycles2Average = 1;
    end
    
    %% Time Domain Features
    for i = 1:length(cycleIndexes)-1
        cycle = signal(cycleIndexes(i):cycleIndexes(i+1));        
        feature = FeatureExtractor.TimeDomainFeaturesFromCycle(cycle, samplingRate);
        featuresPerCycle(i).timeDomainFeatures = feature;
    end
    
    %% Frequncy Domain Features
    % windows start and end indexes - non-overlapping except for the last
    %                                 one. all windows are of length windowLength
    windowLength = floor(windowSize * samplingRate);
    windowsStartIndexes = 1:windowLength:length(signal);
    windowsEndIndexes = min(windowsStartIndexes + windowLength, length(signal));
    windowsStartIndexes(end) = windowsEndIndexes(end) - windowLength;
    
    % cycles start and end indexes
    cyclesStartIndexes = cycleIndexes(1:end-1);
    cyclesEndIndexes = cycleIndexes(2:end);
    
    visitedCycles = zeros(1, length(featuresPerCycle)); % if a cycle was visited more than once, we will calculate the mean
    
    % loop over the windows
    for i = 1:length(windowsStartIndexes)
        wsi = windowsStartIndexes(i);
        wei = windowsEndIndexes(i);
        
        window = signal(wsi:wei);
        feature = FeatureExtractor.FrequencyDomainFeaturesFromWindow(window, samplingRate);
        
        cyclesInWindow = find((wsi < cyclesEndIndexes & cyclesEndIndexes < wei) ...
            | (wsi < cyclesStartIndexes & cyclesStartIndexes < wei));
        
        for k = cyclesInWindow
            if visitedCycles(k) == 0
                featuresPerCycle(k).frequencyDomainFeatures = feature;
                visitedCycles(k) = 1;
            else
                featuresPerCycle(k).frequencyDomainFeatures = ...
                    [featuresPerCycle(k).frequencyDomainFeatures feature];
            end            
        end
    end
    
    % fix frequency domain features (do mean where needed)
    fl = fieldnames(featuresPerCycle(1).frequencyDomainFeatures);
    for i = 1:length(featuresPerCycle)
        fdf = featuresPerCycle(i).frequencyDomainFeatures;
        if length(fdf) > 1
            for k = 1:length(fl)
                fieldname = fl{k};
                fdf_new.(fieldname) = mean([fdf.(fieldname)]);
            end
            featuresPerCycle(i).frequencyDomainFeatures = fdf_new;
        end
    end
    
    %% Delta Features
    
    %feature.peak2peak = (nextPeakLoc + length(cycle) - locs(1)) / samplingRate;
    
    %% Get Features Vector
    [ vectors, featureNames ] = Utils.Struct2Vector( featuresPerCycle );
    
    %% Average if needed
    if cycles2Average > 1
        N = length(featuresPerCycle);
        idxs = 1:cycles2Average:N;
        vectorsAvg = zeros(size(vectors, 1), length(idxs));
        for i = 1:length(idxs)
            range = idxs(i):min(idxs(i) + cycles2Average - 1, N);
            %featuresPerCycle(range) = Utils.SumStructs(featuresPerCycle(range));
            vectorsAvg(:, i) = sum(vectors(:, range), 2) ./ length(range);
        end
        vectors = vectorsAvg;
    end
    
end

