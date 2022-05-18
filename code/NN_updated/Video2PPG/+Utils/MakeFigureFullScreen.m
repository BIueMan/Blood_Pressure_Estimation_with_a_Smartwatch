function f = MakeFigureFullScreen( f )
%MAKEFIGUREFULLSCREEN makes the figure full screen

    if nargin < 1
        f = gcf;
    end
    
    set(f,'units','normalized','outerposition',[0 0 1 1]);

end

