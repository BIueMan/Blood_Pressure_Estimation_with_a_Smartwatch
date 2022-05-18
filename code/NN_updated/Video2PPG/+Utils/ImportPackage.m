function [ package ] = ImportPackage(mfilename_in)
%IMPORTPACKAGE Imports the current package of the caller
%   Usage:
%       import(Utils.ImportPackage(mfilename('fullpath')));

    package = strsplit(fileparts(mfilename_in), 'Main\');
    if length(package) < 2
        package = '';
        return;
    end
    package = package{2};
    package = package(2:end);
    package = strrep(package, '\+', '.');
    package = [package '.*'];

end

