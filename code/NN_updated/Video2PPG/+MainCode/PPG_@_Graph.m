%%
% take the PPG from the output of video2PPG_On_File and plot them all
%%

L = length(PPG);
for i = 1:L
    % load data
    raw = PPG(i).art15.raw;
    final = PPG(i).art15.final;
    xTime = PPG(i).art15.xTime;
    baseline = PPG(i).art15.baseline;
    name = PPG(i).name;

    % plot
    figure(i)
    hold on
    title(name)
	plot(xTime, raw)
    plot(xTime, baseline)
    plot(xTime, final)
    hold off
end
