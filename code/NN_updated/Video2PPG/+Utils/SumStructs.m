function [ s_out ] = SumStructs( structArray )
%SUMSTRUCTS returns a struct that contains the sums from all of the fields
%of the structs in the array 'structArray'
    
    import Utils.*;

    s_out = structArray(1);
    
    fs = fieldnames(s_out);
    for fidx = 1:length(fs)
        aField = s_out.(fs{fidx});
        
        if isstruct(aField)
            s_out.(fs{fidx}) = SumStructs([structArray.(fs{fidx})]);
        else
            v = structArray.(fs{fidx});
            s_out.(fs{fidx}) = s_out.(fs{fidx}) + v;
        end
    end
end

