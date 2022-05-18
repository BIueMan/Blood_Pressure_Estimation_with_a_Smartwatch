function [ vectors, names ] = Struct2Vector( s )
%STRUCT2VECTOR Summary of this function goes here
%   Detailed explanation goes here

    vectors = [];
    for i=1:length(s)
        [ v, names ] = OneStruct2Vector( s(i) );
        vectors = [vectors, v(:)];
    end

end

function [ v, names ] = OneStruct2Vector( s )
    v = [];
    names = {};
    
    fs = fieldnames(s);
    for fidx = 1:length(fs)
        aField = s.(fs{fidx});
        
        if isstruct(aField)
            [v_temp, names_temp] = OneStruct2Vector(aField);
            v = [v v_temp];
            names = [names cellfun(@(x) {[fs{fidx} '.' x]}, names_temp)];
        else
            if numel(aField) == 1
                v = [v aField];
                names = [names fs(fidx)];
            else
                for j=1:numel(aField)
                    v = [v aField(j)];
                    names = [names {[fs{fidx} '_' num2str(j)]}];
                end
            end
        end
    end
end