function [ fitted , Rs ] = removeOutliersData( x,y,k,fType )
% function recieve data and fit type and retums fit without ourliners
% x,y- DATA
% k - multiplier of std which acts as a threshold for outliers
% fType - fit type
if(nargin==2)
    k =1.5;
    fType = 'poly1';
elseif nargin==3 
    fType = 'poly1';
end
nanIndx = isnan(x) | isnan(y);
y(nanIndx) = [];
x(nanIndx) = [];

    fit1 = fit(x,y,fType);
    fdata = feval(fit1,x);
    I = abs(fdata - y) > k*std(y);
    outliers = excludedata(x,y,'indices',I);
    [fitted,gof] = fit(x,y,fType,'Exclude',outliers);
    Rs = gof.rsquare;
end

