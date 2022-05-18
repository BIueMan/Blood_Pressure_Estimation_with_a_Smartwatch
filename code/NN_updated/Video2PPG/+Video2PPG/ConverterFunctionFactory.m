function converterFunc = ConverterFunctionFactory(channel)
%CONVERTERFUNCTIONFACTORY Returns a converter function for a frame. a
%function the will only return the chosen channel from the frame

    function f_out = RedFun(f)
        f_out = f(:,:,1);
    end
    function f_out = LumaFun(f)
        f_out = rgb2ycbcr(f);
        f_out = f_out(:,:,1)*(255/234);
    end
    function f_out = SaturationFun(f)
        f_out = rgb2hsv(f);
        f_out = f_out(:,:,2)*255;
    end

    if channel == 'R'
        converterFunc = @RedFun;
    elseif channel == 'Y'
        converterFunc = @LumaFun;
    elseif channel == 'S'
        converterFunc = @SaturationFun;
    end

%     types = {'RGB', 'YUV', 'HSV'};
%     switch opt
%         case 0  % RGB - red (R) comp
%             outFrame = videoCube(:,:,1,index);
%         case 1  % YUV - luma (Y) comp
%             t = rgb2ycbcr(videoCube(:,:,:,index));
%             outFrame = t(:,:,1)*(255/234);
%         case 2  % HSV - saturation (S) comp
%             t = rgb2hsv(videoCube(:,:,:,index));
%             outFrame = t(:,:,2)*255;
%     end
end
