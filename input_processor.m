function [ im_ready, im_original ] = input_processor( im , config, LUT)
% input_processor funtion is an initial stage used to prepare the image for halftoning
%
% Parameters:
%   im - The image to prepare
%   config - the configuration of the test
%   LUT - Look up table used to apply dot gain compensation

if(~exist('LUT','var'))
  LUT=1:256;
end

disp('begin input processing');
im_original = im;

% for big images use block proc
if(max(size(im_original,1),size(im_original,2))>5000)    
    [x, y] = bestblk([size(im,1) size(im,2)],500);
    im_ready = blockproc(im,[x y],(@(block)input_processor_internal(block.data, LUT, config)),'BorderSize',[10 10],'PadPartialBlocks',true,'TrimBorder',true);
else
    im_ready = input_processor_internal(im_original, LUT, config);
end

% Scale to print resolution
rows = config.dpi * config.print_size_inches(1);
cols = config.dpi * config.print_size_inches(2);
ratio_rows=rows/size(im_ready,1);
ratio_cols=cols/size(im_ready,2);
ratio=min(ratio_rows,ratio_cols);
im_ready = imresize(im_ready,ratio);

im_original=imresize(im_original,[size(im_ready,1) size(im_ready,2)]);
disp('end input processing');
end



function [ im_ready ] = input_processor_internal(im, LUT, config)
% input_processor_internal funtion is intended to run directly or using
% block proc according to the input image size
%
% Parameters:
%   im - The image to prepare
%   config - the configuration of the test
%   LUT - Look up table used to apply dot gain compensation


% Step 1: Convert to RGB if necessary (for grayscal images)
if (size(im,3) == 1)
    rgb = zeros(size(im,1),size(im,2));
    rgb(:,:,1)=im;
    rgb(:,:,2)=im;
    rgb(:,:,3)=im;
    im=rgb;
end

% Step 2: Convert to CMYK if necessary
if (size(im,3) == 3)       
    im = rgb2cmyk(im,config);
end

% Step 3: apply LUT for dot gain compensation
im = intlut(uint8(im),uint8(LUT));

% Step 4: convert to integer for better memory usage
im_ready=uint8(im);

end

