function [ cmyk_image ] = rgb2cmyk(rgb_image, config)
% rgb2cmyk converts a RGB image to CMYK using given in the config parameters ICC profile
% to define thew ICC profile use config.icc='bin/[filename].icc';
% by default it will use SWOP2013C5.icc
% for input it will use sRGB.icm


icc_params.icc_in='sRGB.icm';
if (~exist('config', 'var'))    
    icc_params.icc_out= 'bin/SWOP2013C5.icc';
else    
    icc_params.icc_out= config.icc;
end

if(size(rgb_image,3)==3)
    icm = iccread(icc_params.icc_in);
    icc = iccread(icc_params.icc_out);
    C = makecform('icc',icm,icc);
    cmyk_image = applycform(rgb_image,C);
    %[x, y] = calculate_block_size(rgb_image);
    %cmyk_image = blockproc(rgb_image,[x y],(@(block)apply(block.data,C)));    
end

end

function [ cmyk_image ] = apply(rgb_image,C)
cmyk_image = applycform(rgb_image,C);
end



