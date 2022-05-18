function [ xM,yM] = CutbyShort( x,y )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
minLen = min(length(x), length(y));
    xM = x(1:minLen);
    yM = y(1:minLen);
end

