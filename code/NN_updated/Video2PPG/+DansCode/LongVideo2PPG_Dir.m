clear all
%% pre run parameters
VideoPath = "C:\\Users\\User\\Technion\\Yair Moshe - project - Blood Pressure Estimation with a Smartwatch\\data\\long_phone_records\\20210119_192737.mp4";
DirSaveName = "D:\20210119_192737";
% dis, sys mean. we will add same noise so not all images will have the same labels
diastilic = 68;
systolic = (100+88)/2;
bias = 6;

%% load video
videoObject = VideoReader(VideoPath);

%% Video2PPG
%% ################# this line take alot of time, save the art15 when you debuging the code ####################
[art15, art15_inverse] = Video2PPG.Extract_Art15(videoObject);

final_in = art15.final;
time_in = art15.xTime;

%% change the FPS from 30 to 125
[time_new, final_new] = change_FPS_30_to_125(time_in, final_in);

% time step
T = 4048;
shift_time = 1350;

% 1/125 = 0.008
time_new = (0.008:0.008:(T)*0.008);
cutoffFreq = [-inf 13.3056650625000];

for n = (1:1:fix((length(final_new)-2*shift_time-T)/shift_time))
    % split the time steps, every 10 sec, get a time of 30 sec
    signal = final_new(shift_time*n : shift_time*n + T - 1);
    s(n).data = signal;
    
    % long story shirt, we extract p as the STFT images
    [v, f, t, p] = spectrogram(signal, 750, 0.96*750, [], 125, 'yaxis');
    range = cutoffFreq(1) <= f & f <= cutoffFreq(2);
    v = v(range, :);
    f = f(range);
    p = p(range, :);
    p = 20*log10(p + eps);
    
    % randomis a dis and sys around bias
    dis = string(diastilic + randi([-6, 6],1,1));
    sys = string(systolic + randi([-6, 6],1,1));
    % label = id_dis_sys
    label = join([string(n), dis, sys],"_");
    
    % save images
    savename = join([DirSaveName, label],"\");
    imwrite( ind2rgb(im2uint8(mat2gray(p)), parula(256)), join([savename,'_color.png'],""))
end

save(DirSaveName, 's');




%% function: change a 30FPS PPG, into 125FPS
function [time_new, final_new] = change_FPS_30_to_125(xTime, final)
    % get 125 sample time
    old_FPS = 30;
    new_FPS = 125;
    
    num_of_sample = length(xTime);
    time_new = (1/(new_FPS)):(1/(new_FPS)):(num_of_sample/old_FPS);

    final_new = interp1(xTime, final, time_new, 'spline');
end