
load('test1.mat')
%% ploting the PPG singal
figure(1)
hold on
subplot(3,1,1);
plot(time_in, final_in)
title("PPG signal 30 FPS")

subplot(3,1,2);
plot(time_125, final_125)
title("PPG upsampling 125 FPS")

subplot(3,1,3);
shift = round((length(time_125)-length(time_new))/2) * time_new(1);
plot(shift+time_new, final_new)
title("PPG singal, cut to 30sec")
hold off