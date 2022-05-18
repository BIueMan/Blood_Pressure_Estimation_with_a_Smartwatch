load('C:\Users\User\Technion\Yair Moshe - project - Blood Pressure Estimation with a Smartwatch\code\Video2PPG\matlab\+DansCode\DansVidoe_OnePlus5.mat')
s_dan = s;
load('C:\Users\User\Technion\Yair Moshe - project - Blood Pressure Estimation with a Smartwatch\code\Video2PPG\matlab\+DansCode\TopazNormal.mat')
s_topaz = s;
load('C:\Users\User\Technion\Yair Moshe - project - Blood Pressure Estimation with a Smartwatch\code\Video2PPG\matlab\+DansCode\TopazWtihPoshUp.mat')
s_topaz_with_pushUp = s;
clear s;

figure(1)
subplot(3,1,1);
hold on
plot(s_dan.art1.raw)
plot(s_dan.art1.final)
hold off
title("art1")

subplot(3,1,2);
hold on
plot(s_topaz.art1.raw)
plot(s_topaz.art1.final)
hold off

subplot(3,1,3);
hold on
plot(s_topaz_with_pushUp.art1.raw)
plot(s_topaz_with_pushUp.art1.final)
hold off


figure(2)
subplot(3,1,1);
hold on
plot(s_dan.art15.raw)
plot(s_dan.art15.final)
hold off
title(" art15 ")

subplot(3,1,2);
hold on
plot(s_topaz.art15.raw)
plot(s_topaz.art15.final)
hold off

subplot(3,1,3);
hold on
plot(s_topaz_with_pushUp.art15.raw)
plot(s_topaz_with_pushUp.art15.final)
hold off

figure(3)
subplot(3,1,1);
hold on
plot(s_dan.art18_tec2.raw)
plot(s_dan.art18_tec2.final)
hold off
title(" art18 tec2 ")

subplot(3,1,2);
hold on
plot(s_topaz.art18_tec2.raw)
plot(s_topaz.art18_tec2.final)
hold off

subplot(3,1,3);
hold on
plot(s_topaz_with_pushUp.art18_tec2.raw)
plot(s_topaz_with_pushUp.art18_tec2.final)
hold off