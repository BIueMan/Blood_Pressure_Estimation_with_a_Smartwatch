clear all;
s = [];
%% read vidoe
% C:\Users\User\Technion\Yair Moshe - project - Blood Pressure Estimation with a Smartwatch\code\Video2PPG\matlab\+DansCode
%filePath = '+DansCode\DansVidoe_OnePlus5.mp4';
%filePath = '+DansCode\TopazNormal.mp4';
% C:\Users\User\Technion\Topaz Aharon - ???????\Smartphone_Dataset\With_BP_reference\after_exercise\num1_galaxy_s9_119-58.mp4
% filePath = '+DansCode\TopazWtihPoshUp.mp4';
name = ['+DansCode\', 'TopazWtihPoshUp', '.mp4'];
filePath = join(name,"");
videoObject = VideoReader(filePath);

%%
[ s.art18_tec1, s.art18_tec2, s.art18_tec1_inverse, s.art18_tec2_inverse ] = Video2PPG.Extract_Art18(videoObject);

%%
[s.art1, s.art1_inverse] = Video2PPG.Extract_Art1(videoObject);

%%
[s.art15, s.art15_inverse] = Video2PPG.Extract_Art15(videoObject);

%% plot

subplot(4,1,1);
hold on
title("art1")
plot(s.art1.raw)
plot(s.art1.final)
hold off

subplot(4,1,2);
hold on
title("art15")
plot(s.art15.raw)
plot(s.art15.final)
hold off

subplot(4,1,3);
hold on
title("art18_tec1")
plot(s.art18_tec1.raw)
plot(s.art18_tec1.final)
hold off

subplot(4,1,4);
hold on
title("art18_tec2")
plot(s.art18_tec2.raw)
plot(s.art18_tec2.final)
hold off


%%
saveName = [name(1), name(2)];
save(join(saveName, ""), 's');
