function [ rgb_image ] = cmyk2rgb( cmyk_image, config)
% cmyk2rgb converts a CMYK image to RGB using given in the config parameters ICC profile
% to define thew ICC profile use config.icc='bin/[filename].icc';
% by default it will use SWOP2013C5.icc
% for output it will use sRGB.icm

icc_params.icc_out= 'sRGB.icm';

if (~exist('config', 'var'))
    icc_params.icc_in = 'bin/SWOP2013C5.icc';
else
    icc_params.icc_in = config.icc;
end

if(size(cmyk_image,3)==4)
    icc = iccread(icc_params.icc_in);
    icm = iccread(icc_params.icc_out);
    C = makecform('icc',icc,icm);
    %C = makecform('cmyk2srgb');
    rgb_image = applycform(cmyk_image,C);
else
    rgb_image=cmyk_image;
end
end



