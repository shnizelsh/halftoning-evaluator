classdef PerfectPrinter < Printer
    %This class represents a Perfect Printer that introduce no artifacts
    % while printing.
    
    %% Properties
    properties
        default_ink_drop=[];
        samples = 11;% the resizing factor
    end
    
    %% Methods
    methods
        %% Constructor
        function obj = PerfectPrinter(config)
            obj@Printer(config);
            obj.Name = 'Perfect Printer';
            obj.default_ink_drop = obj.calculate_drop();
        end
        
        %% the Print Method
        function [ im_result ] = print( obj, cmyk_image )
            print@Printer(obj);
            [blockSizeX, blockSizeY] = bestblk([size(cmyk_image,1) size(cmyk_image,2)],500);
            im_result = blockproc(cmyk_image,[blockSizeX blockSizeY],@obj.print_internal,'BorderSize',[5 5],'PadPartialBlocks',true);
        end
        
        %% print internal to be used in block proc
        function [ im_result ] = print_internal( obj, block )
            cmyk_image = block.data;
            drop = obj.default_ink_drop;
            max_drop = max(drop(:));
            phase = floor(obj.samples/2);
            printed = zeros(size(cmyk_image,1)*obj.samples,size(cmyk_image,2)*obj.samples,size(cmyk_image,3));
            
            for i=1:size(cmyk_image,3)
                current=cmyk_image(:,:,i);
                us_image = upsample(upsample(current,obj.samples,phase)',obj.samples,phase)';
                result=conv2(single(us_image),drop,'full');
                result(result>max_drop)=max_drop;
                cropped = result(round(size(drop,1)/2):end-floor(size(drop,1)/2), round(size(drop,2)/2):end-floor(size(drop,2)/2));
                printed(:,:,i)= cropped;
            end
            im_result = printed;
            im_result = imresize(im_result,1/obj.samples,'box');
        end
        
        %% return a matrix with the shape of a ink drop
        function [disk] = calculate_drop(obj)
            mid = obj.samples / 2;
            radius = mid*sqrt(2);
            radius = ceil(radius);
            disk = fspecial('disk', radius);
            max_disk = max(disk(:));
            disk=disk./max_disk;
            disk = imresize(disk,10,'bilinear');
            disk = imresize(disk,0.1,'bilinear');
            disk = conv2(disk,[0 0 0 ; 0 1 0;0 0 0],'full');
        end
    end
end
