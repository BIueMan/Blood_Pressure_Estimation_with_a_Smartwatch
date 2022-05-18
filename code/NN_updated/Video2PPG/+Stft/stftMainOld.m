%% get Signals
%e = Experiments.ReadExperiment(1);

%%
IphoneSig = ipSigE1;
cyclesLocsIphone = ipLocsE1;

SignalOx = oxSig1E1;
cyclesLocOx = oxLocs1E1;

FIphone = e.iphoneSR;

%% analysis
cycNumPh = length( cyclesLocsIphone) -1;
%OX_cycLoc = PPGAnalyzer.cycle_detect(oximeterSignal);
cycNumOX = length(cyclesLocOx) -1;
segOX= floor(length(SignalOx)/cycNumOX);
segPh= floor(length(IphoneSig)/cycNumPh);
figure(1)
% [sOX,fOX,tOX,pOX] = 
spectrogram( SignalOx,floor(segOX*15),[],[],500,'yaxis');%,'MinThreshold',-75) ;

% [qOX,ndOX] = max(10*log10(pOX));
% hold on
% plot(tOX,qOX,'r','linewidth',4)
% hold off
% colorbar

ax1 = gca;
figure(2)
% [sPh,fPh,tPh,pPh] = 
spectrogram(IphoneSig,floor(segPh*15),[],[],FIphone,'yaxis');%,'MinThreshold',-20) ;

% [qPh,ndPh] = max(10*log10(pPh));

% hold on
% plot(tPh,qPh,'r','linewidth',4)
% hold off
% colorbar
ax2=gca;
 linkaxes([ax1,ax2],'xy');