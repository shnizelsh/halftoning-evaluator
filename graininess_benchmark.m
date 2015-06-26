function [ benchmark ] = graininess_benchmark(im, config )
% graininess_benchmark calculates the graininess score of the given image
%
% Parameters:
%   im - The image to perform the analysis (CMYK or RGB)
%   config - the configuration of the test

if(size(im,3)==4)  
    im=cmyk2rgb(im,config);
end
if(size(im,3)==3)
    im = rgb2gray(im);
end

dpi = config.dpi;
mm=1.27; % milimeter
m=mm/1000; % meter
inch = convlength(m,'m','in'); % inch
patch_size = round(dpi * inch);

n = round(size(im,1)/patch_size);
sum=0;

for i = 1:patch_size:size(im,1)
    for j = 1:patch_size:size(im,2)
        to_i=i+patch_size-1;
        to_j=j+patch_size-1;
        if(to_i > size(im,1))
            to_i=size(im,1);
        end
        if(to_j > size(im,2))
            to_j = size(im,2);
        end
        
        block = double(im(i:to_i,j:to_j));
        v = var(block(:));
        sum=sum+(v/n);
    end
end
benchmark = sqrt(sum);
end


