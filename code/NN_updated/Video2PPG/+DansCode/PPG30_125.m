% get the sample from Video2PPG here
% s = topaz_normal;
load('C:\Users\User\Technion\Yair Moshe - project - Blood Pressure Estimation with a Smartwatch\code\Video2PPG\matlab\+DansCode\TopazNormal.mat')

%% get data in 30 FPS
FPS_in = s.art15.samplingRate;
final_in = s.art15.final;
time_in = s.art15.xTime;
% get dist, sys
tmp = s.art15.BPF;
diastolic_in  = tmp(1);
systolic_in = tmp(2);
clear tmp;


%% change it 125 sample time
[time_new, final_new] = change_FPS_30_to_125(time_in, final_in);

%% save 
filename = '+DansCode\TopazNormal_125.mat';
p = [];
p.final = final_new;
p.xTime = time_new;
p.samplingRate = 125;
p.BPF = s.art15.BPF;

save(filename, 'p');

%% plot for test
plot(time_in,final_in,'o',time_new,final_new,':.');





%% function: change a 30FPS PPG, into 125FPS
function [time_new, final_new] = change_FPS_30_to_125(xTime, final)
    % get 125 sample time
    old_FPS = 30;
    new_FPS = 125;
    
    num_of_sample = length(xTime);
    time_new = (1/(new_FPS)):(1/(new_FPS)):(num_of_sample/old_FPS);

    final_new = interp1(xTime, final, time_new, 'spline');
end