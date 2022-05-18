function [ raw_signal, xTime ] = Video2RawSignal( videoObj, channel, roiParam )
%VIDEO2RAWSIGNAL a generic way to convert a video to a raw ppg signal:
%averaging the ROI of the selected channel
%
% Inputs:
%   videoObj - the video object
%   channel - 'R' for Red in RGB (default)
%             'Y' for Luma in YCbCr
%             'S' for Saturation in HSV
%   roiParam - a number between 0 to 1 (1 by default) that defines the ROI
%              in the video: 
%              0 - only the center pixel
%              1 - the whole frame
%
% Outputs:
%   raw_signal - the raw signal from the video
%   xTime - the time axis 

    import(Utils.ImportPackage(mfilename('fullpath')));

    if nargin <= 2
        roiParam = 1;
    end
    if nargin <= 1
        channel = 'R';
    end
    
    converterFunc = Video2PPG.ConverterFunctionFactory(channel);
    frame2SignalFunc = Frame2SignalFunctionFactory(videoObj, roiParam);
    raw_signal = [];
    
    i = 1;
    while hasFrame(videoObj)
        frame = converterFunc(readFrame(videoObj));
        raw_signal(i) = frame2SignalFunc(frame);
        i = i + 1;
    end
    
    xTime = (1:length(raw_signal)) ./ videoObj.FrameRate;
end

function frame2SignalFunc = Frame2SignalFunctionFactory(videoObj, roiParam)
    if roiParam == 1
        frame2SignalFunc = @mean2;
    else
        H = videoObj.Height;
        W = videoObj.Width;
        p = roiParam;
        ROIx = floor(H/2 - p*H/2+1) : floor(H/2 + p*H/2);
        ROIy = floor(W/2 - p*W/2+1) : floor(W/2 + p*W/2);
        frame2SignalFunc = @(x) mean2(x(ROIx, ROIy));
    end
end

