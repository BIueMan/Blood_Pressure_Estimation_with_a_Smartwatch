function [ features ] = TimeDomainFeaturesFromCycle( cycle, samplingRate )
%TimeDomainFeaturesFromCycle returns a time domain features struct for one cycle

    %% Init Params
    [pks, locs] = PPGAnalyzer.GetDominantPeaks(cycle);
    if length(pks) == 1;
        pks = [pks pks];
        locs = [locs locs];
    end
    peakTimes = locs ./ samplingRate;
    

    %% Time Intervals
    features.pulseTotalTime = length(cycle) / samplingRate;
    
    features.sysTime = peakTimes(1);
    features.distTime = peakTimes(2);
    features.deltaTime = (peakTimes(2) - peakTimes(1));
    features.fallingTime = features.pulseTotalTime - features.sysTime;
    
    %% Normalized Time Intervals
    features.fallingTimeN = (features.pulseTotalTime - features.sysTime)/features.pulseTotalTime;
    features.sysTimeN = peakTimes(1)/features.pulseTotalTime;
    features.distTimeN = peakTimes(2)/features.pulseTotalTime;
    features.deltaTimeN = (peakTimes(2) - peakTimes(1))/features.pulseTotalTime;
    
    %% Heights
    features.pulseHeight = max(cycle);
    features.sysPeakHeight = pks(1);
    features.distPeakHight = pks(2);

    %% Slopes:
    features.risingSlope = pks(1) / peakTimes(1);
    features.betweenPeaksSlope = (pks(2) - pks(1)) / (peakTimes(2) - peakTimes(1));
    features.fallingSlope = -pks(1) / features.fallingTime;
    features.risingSlopeN = pks(1) / (peakTimes(1)/features.pulseTotalTime);
    features.betweenPeaksSlopeN = (pks(2) - pks(1)) / ((peakTimes(2) - peakTimes(1))/features.pulseTotalTime);
    features.fallingSlopeN = -pks(1) / features.fallingTimeN;
    
    %% Ratios:
    features.peaksRatio = pks(1) / pks(2);

    %% More:
    features.area = trapz(cycle) ./ samplingRate;
    features.centerOfGravity = SignalAnalyzer.COG(cycle) ./ samplingRate;
    
    %% Gaussian Fitting:
    [~, ~, features.fitCoeffs] = PPGAnalyzer.CreateCycleFit(cycle, samplingRate);

end

