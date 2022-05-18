function [ ppg_tec1, ppg_tec2, ppg_tec1_inverse, ppg_tec2_inverse, thresholdValue ] = ...
    Extract_Art18( video, channel, plotMe )
%EXTRACT_ART18 Summary of this function goes here
%   Detailed explanation goes here

    import SignalAnalyzer.*
    import PPGAnalyzer.*
    
    if nargin < 2
        channel = 'R';
    end
    if nargin < 3
        plotMe = false;
    end
    
    plotMeFunc = plotMeFuncFactory(plotMe);
    
    converterFunc = Video2PPG.ConverterFunctionFactory(channel);

    %% calc Threshold
    % read from a short period of time from the video
    prctileValue = 5;
    secToRead = 2;
    
    %----
    totalDuration = video.Duration;
    timeRunner = floor(totalDuration/2 - secToRead/2):floor(totalDuration/2 + secToRead/2);
    
    outVidForThr = zeros(video.Height, video.Width);
    counter = 1;
    
    video.CurrentTime = timeRunner(1);
    while video.CurrentTime <= timeRunner(end)
        outVidForThr(:, :, counter) = converterFunc(video.readFrame());
        counter = counter + 1;
    end
    
    thresholdValue = prctile(outVidForThr(:), prctileValue);
    if thresholdValue == 255;
        thresholdValue = 254;
    end
    
    video.CurrentTime = 0;

    %% calc raw PPG
    i = 1;
    dist_mat = dist_matrix(video.Height, video.Width);
    
    rawPPG_tec1 = [];
    rawPPG_tec2 = [];
    while video.hasFrame()
        v = converterFunc(video.readFrame());
        u = v > thresholdValue; % pixel which are bigger then thresholdValue
        z = edge(u, 'sobel'); % or 'canny'
        
        plotMeFunc(v, u, z, i, video.CurrentTime);

        %% Technic #1
        temp = dist_mat.*z; % matrix of distances from center of pixels which are bigger then thresholdValue
        rawPPG_tec1(i) = mean(temp(:)); % or max

        %% Technic #2
        [xs, ys] = find(z);
        %[~,~,R,~] = circfit(xs, ys);
        x = xs(:); y = ys(:);
        a = [x y ones(size(x))] \ (-(x.^2+y.^2));
        R = sqrt((a(1)^2+a(2)^2)/4-a(3));
        rawPPG_tec2(i) = R;
        
        %%
        i = i+1;
    end
    
    %% out
    samplingRate = video.FrameRate;
    
    p1_name = 'Article 18 - Technique 1 - Centered circle';
    ppg_tec1 = makeResStruct(rawPPG_tec1, p1_name, false, 18.1);
    ppg_tec1_inverse = makeResStruct(rawPPG_tec1, p1_name, true, -18.1);
    
    p2_name = 'Article 18 - Technique 2 - Circle fit';
    ppg_tec2 = makeResStruct(rawPPG_tec2, p2_name, false, 18.2);
    ppg_tec2_inverse = makeResStruct(rawPPG_tec2, p2_name, true, -18.2);
    
    %% aux
    function ppg = makeResStruct(raw_signal, name, inverse, artId)
        ppg = Video2PPG.CleanAndMakeStruct(raw_signal, samplingRate, inverse, [0.3 12.5]);
        ppg.name = name;
        ppg.channel = channel;
        ppg.artId = artId;
    end

end

function [ dist_mat ] = dist_matrix( Nx, Ny )
    a = -floor(Nx/2):floor(Nx/2)-(1-mod(Nx,2));
    b = -floor(Ny/2):floor(Ny/2)-(1-mod(Ny,2));
    [m,n] = meshgrid(b,a);
    dist_mat = sqrt(m.^2+n.^2);
end

function   [xc,yc,R,a] = circfit(x,y)
%
%   [xc yx R] = circfit(x,y)
%
%   fits a circle  in x,y plane in a more accurate
%   (less prone to ill condition )
%  procedure than circfit2 but using more memory
%  x,y are column vector where (x(i),y(i)) is a measured point
%
%  result is center point (yc,xc) and radius R
%  an optional output is the vector of coeficient a
% describing the circle's equation
%
%   x^2+y^2+a(1)*x+a(2)*y+a(3)=0
%
%  By:  Izhak bucher 25/oct /1991, 
    x = x(:); y = y(:);
    a = [x y ones(size(x))] \ (-(x.^2+y.^2));
    xc = -.5*a(1);
    yc = -.5*a(2);
    R = sqrt((a(1)^2+a(2)^2)/4-a(3));
end

function f = plotMeFuncFactory(plotMe)
    function F(x, y, z, i, t)
        subplot(1, 3, 1);
        imshow(x);
        subplot(1, 3, 2);
        imshow(y);
        subplot(1, 3, 3);
        imshow(z);
        
        suptitle(['Frame: ' num2str(i) ' - Time: ' num2str(t) ' sec']);
        
        drawnow;
    end

    if plotMe
        f = @F;
    else
        f = @(a, b, c, d, e) 0;
    end
end
