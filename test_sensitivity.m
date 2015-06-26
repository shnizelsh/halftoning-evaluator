function test_sensitivity(runID, algorithm, artifact, printer, natural_images )
% This procedure tests the sensitivity of halftoning algorithm to specfic
% artifact.
%
% Parameters:
%   algorithm - the algorithm to test
%   artifact - the artifact to check with (e.g. dot size variation,
%   write-head banding, etc...)
%   printer - the printer type to use (e.g. Lazer Printer)
%   natural_images- boolean determines whether to test with natural image
%   set or plain test images


%% create test images for dot_size_variation testing
if(natural_images)
    images = get_test_images('Images');
    load('SFF/W.mat'); % for SFF
else
    images = get_test_images('TI');
end

%% calibrate printer
LUT = calibrate(algorithm);
%figure;plot(1:256,LUT);

%% for each image
for j = 1: size(images,2)
    
    tic_id=tic;
    %% get curent image
    full_path = images{j};
    
    result_file=get_file_path(runID, full_path,printer.config,algorithm,'_result_',artifact);
    if(exist(result_file,'file'))
        continue;
    end
    im = imread(full_path);
    
    %% prepare image for halftoning
    [ im, im_original ]=input_processor(im,printer.config,LUT);
    
    %% halftone
    im = halftone(im ,algorithm);
    
    %% print
    [im, s, g, b]= printer.print(im,im_original);
    
    %% evaluate
    if(natural_images)
        if(isnan(s) || s==-1)
            im=cmyk2rgb(im,printer.config);
            s = SFF(im_original, im, W);
        end
    else
        if(isnan(g) || g==-1)
            g = graininess_benchmark(im,printer.config);
        end
        if(isnan(b) || b==-1)
            b = banding_benchmark(im,printer.config);
        end
    end
    
    elapsedTime=toc(tic_id);
    %% save result
    save_results(runID,elapsedTime,algorithm,printer,artifact,g,b,s,im,im_original,full_path);
    
end

end

