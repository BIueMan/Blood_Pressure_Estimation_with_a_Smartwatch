function [ opts ] = CopyTrainingOptions( inputTrainingOptions, varargin )
%COPYTRAININGOPTIONS Summary of this function goes here
%   Detailed explanation goes here

    newStruct = nnet.cnn.TrainingOptionsSGDM.parseInputArguments(varargin{:});
    fields = fieldnames(inputTrainingOptions);
    fields = setdiff(fields, varargin(1:2:end));
    
    for i = 1:length(fields)
        newStruct.(fields{i}) = inputTrainingOptions.(fields{i});
    end
    
    opts = nnet.cnn.TrainingOptionsSGDM(newStruct);

end

