clear all
%% pre run parameters
VideoPath = "C:\Users\User\Technion\Yair Moshe - project - Blood Pressure Estimation with a Smartwatch\data\\Smartphone_3.1.21\blood pressure videos\\nikita_113_71.mp4";
SaveName = "nikita_113_71";
diastilic = 71;
systolic = 113;

%% load video
videoObject = VideoReader(VideoPath);

%% Video2PPG
[s.art15, art15_inverse] = Video2PPG.Extract_Art15(videoObject);

%% get the data
FPS_in = s.art15.samplingRate;
final_in = s.art15.final;
time_in = s.art15.xTime;
% get dist, sys
tmp = s.art15.BPF;
diastolic_in  = tmp(1);
systolic_in = tmp(2);
clear tmp;

%% change the FPS from 30 to 125
[time_new, final_new] = change_FPS_30_to_125(time_in, final_in);

%% cut the middle T frams
T = 4048;
if(length(final_new) < T)
    error("PPG signal is less then T fram long");
end

% 1/125 = 0.008
time_new = (0.008:0.008:(T)*0.008);

if(rem( length(final_new),2 ) == 1)
    final_new(end) = [];
end
dead_time = (length(final_new) - T)/2;
final_new = final_new(dead_time:(length(final_new)-dead_time-1));


%% save the PPG signal
filename = join(['+DansCode\', SaveName],"");
PPG = [];
PPG.final = final_new;
PPG.xTime = time_new;
PPG.samplingRate = 125;
PPG.BPF = [diastilic, systolic];

save(filename, 'PPG');


%% function: change a 30FPS PPG, into 125FPS
function [time_new, final_new] = change_FPS_30_to_125(xTime, final)
    % get 125 sample time
    old_FPS = 30;
    new_FPS = 125;
    
    num_of_sample = length(xTime);
    time_new = (1/(new_FPS)):(1/(new_FPS)):(num_of_sample/old_FPS);

    final_new = interp1(xTime, final, time_new, 'spline');
end