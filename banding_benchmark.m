function [benchmark,score] = banding_benchmark(im_result,config)
% This function calcualtes and returen the banding benchmark of an image

max_bands=100;
im_result=cmyk2rgb(im_result,config);
im_result=rgb2gray(im_result);
profile = mean(im_result,2);
[benchmark,score]=band_meter(profile,max_bands);
benchmark=benchmark./size(im_result,1);
score=score./size(im_result,1);
end
