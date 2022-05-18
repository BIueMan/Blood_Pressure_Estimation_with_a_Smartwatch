%%
%this code will do video 2 ppg, for all flies in dir
%%
clear all;

% path to the dir
dirPath = '+MainCode\+data\With_BP_BD';
list = dir('+MainCode\+data\With_BP_BD');

% index_of_PPG_list
j = 1;
L = length(list);
for i = 1:L
    % get path to the file
    fileName = list(i).name;
    fliePath = join([dirPath,'\',fileName], "");
    
    % load video
    try
        videoObject = VideoReader(fliePath);
    catch
        continue
    end
    
    % video to PPG
    [PPG(j).art15, PPG(j).art15_inverse] = Video2PPG.Extract_Art15(videoObject);
    PPG(j).name = fileName;
    j = j + 1;
end

% save PPG
split = strsplit(dirPath, '\');
name = string(split(length(split)));
save(join([dirPath,'\PPG_OF_',name],""), 'PPG')