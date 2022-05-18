function [ parts ] = SplitSignal( signal, bitMap )
%SPLITSIGNAL Splits the signal between NaNs or with a given bit map

    if nargin < 2
        bitMap = ~isnan(signal(:));
    end
    
    rangeIndexes = find(~~diff([0; bitMap; 0]));
    
    parts = cell(1, length(rangeIndexes)/2);
    
    for i = 1:2:length(rangeIndexes)
        range = rangeIndexes(i):rangeIndexes(i+1)-1;
        parts{(i+1)/2} = signal(range);
    end

end

