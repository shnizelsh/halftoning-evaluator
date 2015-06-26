function [ images ] = get_test_images( path )
% get_test_images function gets a folder path and return all images in this path
%

images = cell(1);
j = 1;
if(exist(path,'dir'))
    filenames = dir([path '/*.*']);
    %for k = 1:length(filenames)-1
     for k = 1:7
        if(~filenames(k).isdir)
            filename = filenames(k).name;
            full_path = [path '/' filename];
            [~,struc]=fileattrib(full_path);
            if(~struc.system && ~struc.hidden)
                images{j} = full_path;
                j=j+1;
            end
        end
    end
else
    warning('Warnings:msg_2' ,['warnnig: no images found. make sure a folder name images exists. path:' path]);
end
end

