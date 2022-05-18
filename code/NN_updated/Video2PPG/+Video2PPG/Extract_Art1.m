function [ ppg, ppg_inverse ] = Extract_Art1( video, channel )
%EXTRACT_ART1 converts the video to PPG based on the technic in article 1
%   stages:
%       1. averaging the selected channel (R, Y, S) in each frame (by default: Luma from YCbCr)
%       2. denoising with a BPF (with cutoff frequencies of 0.5 Hz and 5 Hz)
%       3. removing the baseline

    %% Init Params
    import SignalAnalyzer.*
    import PPGAnalyzer.*
    
    if nargin < 2
        channel = 'Y';
    end
    
    %% Get Video
    if ischar(video)
        vidObj = VideoReader(video);
    else
        video.CurrentTime = 0;
        vidObj = video;
    end
    
    samplingRate = vidObj.FrameRate;
    
    %% Get Raw Signal
    [raw_signal, ~] = Video2PPG.Video2RawSignal(vidObj, channel);
    
    %% out
    ppg = makeResStruct(raw_signal, false, 1);
    ppg_inverse = makeResStruct(raw_signal, true, -1);

    %% aux func
    function ppg = makeResStruct(raw_signal, inverse, artId)
        ppg = Video2PPG.CleanAndMakeStruct(raw_signal, samplingRate, inverse, [0.5 5]);
        ppg.name = 'Article 1 - Mean';
        ppg.channel = channel;
        ppg.artId = artId;
    end

end