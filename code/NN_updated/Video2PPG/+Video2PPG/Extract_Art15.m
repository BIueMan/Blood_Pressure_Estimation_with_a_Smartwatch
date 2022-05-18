function [ ppg, ppg_inverse, thresholdValue ] = Extract_Art15( video, channel )
%EXTRACT_ART15 Summary of this function goes here
%   Detailed explanation goes here

    import SignalAnalyzer.*
    import PPGAnalyzer.*
    
    if nargin < 2
        channel = 'R';
    end
    
    converterFunc = Video2PPG.ConverterFunctionFactory(channel);

    %% calc Threshold
    % read from a short period of time from the video
    prctileValue = 75;
    secToRead = 2;
    
    %----
    totalDuration = video.Duration;
    timeRunner = floor(totalDuration/2 - secToRead/2):floor(totalDuration/2 + secToRead/2);
    
    trdQuartilIntensitys = [];
    counter = 1;
    
    video.CurrentTime = timeRunner(1);
    while video.CurrentTime <= timeRunner(end)
        v = converterFunc(video.readFrame());
        trdQuartilIntensitys(counter) = prctile(v(:), prctileValue);
        counter = counter + 1;
    end
    
    thresholdValue = min(trdQuartilIntensitys);
    
    video.CurrentTime = 0;
    
    %% get R and remove bad frames?
    
    raw_signal = [];
    while video.hasFrame()
        v = converterFunc(video.readFrame()) >= thresholdValue;
        raw_signal = [raw_signal sum(v(:))];
    end
    
%         if v < 0.25*frameNumel || v == frameNumel
%             t = t + 1;
%             continue;
%         end

    %% out
    ppg = makeResStruct(raw_signal, false, 15);
    ppg_inverse = makeResStruct(raw_signal, true, -15);
    
    %% aux func
    function ppg = makeResStruct(raw_signal, inverse, artId)
        ppg = Video2PPG.CleanAndMakeStruct(raw_signal, video.FrameRate, inverse, [0.5 5]);
        ppg.name = 'Article 15 - Online+Clean';
        ppg.channel = channel;
        ppg.artId = artId;
    end
end
