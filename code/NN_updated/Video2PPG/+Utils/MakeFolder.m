function MakeFolder( folder )
%MAKEFOLDER Summary of this function goes here
%   Detailed explanation goes here

    if ~exist(folder,'dir')
        disp(['Making folder: ' folder]);
        mkdir(folder);
    end

end

