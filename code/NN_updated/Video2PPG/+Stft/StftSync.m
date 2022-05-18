function [ SyncRaw , SyncRef ] = StftSync( ...
    RefSig , RawSig , RefF , RawF, RefCycNum , RawCycNum  )
%UNTITLED2 Summary of this function goes here
%  the function receive two un syncronized signals and syncronizes them
%  using power spectrum and stft

% for WindowSizeInCycles = [1 5:5:35]
 WindowSizeInCycles = 5;
RefP = Spect(RefSig, RefCycNum, RefF, WindowSizeInCycles);
RawP = Spect(RawSig, RawCycNum, RawF, WindowSizeInCycles);
h=figure;
subplot(1,2,1);
sum(RefP(:))
sum(RawP(:))
imagesc(RefP);
caxis manual
range = [min(RefP(:)) max(RefP(:))];
%range = [0 1];
caxis(range);
subplot(1,2,2);
imagesc(RawP);
h.Name=num2str(WindowSizeInCycles);
caxis manual
caxis(range);
% end
SyncRaw = 1;

end
function [ p] = Spect ( signal , cycNum , Fs, WindowSizeInCycles)
seg= floor(length(signal)/cycNum);
[s,f,t,p] = spectrogram(signal,floor(seg*WindowSizeInCycles),[],[],Fs,'yaxis') ;
p = p(find(0.5<=f & f<=5),:);
p = 20*log10(p+eps);


p = p - min(p(:));
p = p./sum(p(:));

pMax = max(p(:));
pMin = min(p(:));
p(p<(pMin+0.7*(pMax-pMin)))=0;
return;

p = abs(p);
min2 = min(p(:));
max2 = max(p(:));
p = (p - min2)./(max2-min2);

end