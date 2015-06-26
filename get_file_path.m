function [full_path]= get_file_path(runID,im_path,config,algorithm,marker,method)
%get_file_path function build and reutn a full path to a file
%
% Parameters:
%   runID - An aidentifier used in the filename to be used in the directory
%           name
%   im_path - The original image path
%   config - The script run configuration. the config.dpi is used in the
%            filename
%   algorithm - The algoritm object used in the directory name
%   marker - a marker used to describe the current file (e.g. '_result_')
%   method - the method used to create the filename

    algo_name = func2str(algorithm.func);
    folder_path = ['results/' runID '/' algo_name];
    if(exist(folder_path,'dir')~=7)
        mkdir(folder_path);
    end

    [~,filename,~]=fileparts(im_path);
    full_path =[folder_path '/' num2str(filename) marker method num2str(config.dpi) '.tif'];
end